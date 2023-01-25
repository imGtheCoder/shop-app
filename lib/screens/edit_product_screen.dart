import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Title' /*error text can be styled here */),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a title.';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _editedProduct = Product(
                      id: _editedProduct.id,
                      title: newValue,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_descFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a price greater than zero.';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(newValue),
                      imageUrl: _editedProduct.imageUrl),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descFocusNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a description.';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: newValue,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.contain,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (value) {
                          _saveForm();
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an image URL.';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid image URL.';
                          }
                          if(!value.endsWith('.jpg') && !value.endsWith('.jpeg') && !value.endsWith('.png')){
                            return 'Please enter a valid image URL.';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: newValue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
