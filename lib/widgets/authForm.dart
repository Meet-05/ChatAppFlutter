import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String username, String email, String password,
      bool isLogin, BuildContext context) _submitAuthForm;
  bool isLoading;
  AuthForm(this._submitAuthForm, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailNode = FocusNode();
  final _usernameNode = FocusNode();
  final _passwordNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String _userEmail = '';
  String _username = '';
  String _userPassword = '';
  bool isLogin = true;
  bool hidePassword = true;
  void onFormSubmitted() {
    FocusScope.of(context).unfocus();
    bool validate = _form.currentState.validate();
    if (validate) {
      _form.currentState.save();
      widget._submitAuthForm(
          _username, _userEmail, _userPassword, isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(25.0),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      key: ValueKey('email'),
                      focusNode: _emailNode,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'invaild email';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_usernameNode);
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        focusNode: _usernameNode,
                        decoration: InputDecoration(
                          labelText: 'username',
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'username length should be min 7 characters';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordNode);
                        },
                        onSaved: (value) {
                          _username = value;
                        },
                      ),
                    Row(
                      children: [
                        Container(
                          width: 260.0,
                          child: TextFormField(
                            key: ValueKey('password'),
                            focusNode: _passwordNode,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length < 7) {
                                return 'Password should be min 7 char';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              onFormSubmitted();
                            },
                            onSaved: (value) {
                              _userPassword = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                          onPressed: () {
                            onFormSubmitted();
                          },
                          child: Text(isLogin ? 'LOGIN' : 'Signup')),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(isLogin
                            ? 'Create New Account'
                            : 'Already have an account?'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
