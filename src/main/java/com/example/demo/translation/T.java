package com.example.demo.translation;


import com.vaadin.flow.server.VaadinSession;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * Translator
 */
public class T {
    public static final Map<String, T> translations = new HashMap<>();


    static{
        translations.put("en", new T());
        translations.put("de", new GermanTranslation());
    }

    /**
     * Short for translate.
     */
    public static String t(TString s){
        Locale locale = VaadinSession.getCurrent().getLocale();
        T translation = translations.get(locale.getLanguage());
        if (translation == null) {
            return getFieldValueString(s.fieldName, new T());
        } else {
            try {
                Field tField = translation.getClass().getDeclaredField(s.fieldName);
                tField.setAccessible(true); // Allow access to private fields
                return ((TString) tField.get(translation)).value;
            } catch (NoSuchFieldException | IllegalAccessException e) {
                e.printStackTrace();
                return getFieldValueString(s.fieldName, new T());
            }
        }
    }

    public static String getFieldValueString(String fieldName, Object translation){
        try{
            Field field = translation.getClass().getDeclaredField(fieldName);
            field.setAccessible(true);
            return ((TString) field.get(translation)).value;
        } catch (Exception e) {
            e.printStackTrace();
            return fieldName;
        }
    }

    public static TString HELLO = new TString("HELLO", "Hello");
    public static TString HELLO_ANON = new TString("HELLO_ANON", "Hello anonymous user.");
    public static TString LOGIN = new TString("LOGIN", "Login");
    public static TString EMAIL = new TString("EMAIL", "Email");
    public static TString PASSWORD = new TString("PASSWORD", "Password");
    public static TString EMAIL_OR_PASSWORD_WRONG = new TString("EMAIL_OR_PASSWORD_WRONG", "Email/Password is wrong.");
    public static TString AUTH_SUCCESS = new TString("AUTH_SUCCESS", "Authentication success.");
    public static TString SUCCESS = new TString("SUCCESS", "Success.");
    public static TString NOT_AUTHENTICATED = new TString("NOT_AUTHENTICATED", "Not authenticated.");
    public static TString EMAIL_EXISTS = new TString("EMAIL_EXISTS", "An account for this email already exists.");
    public static TString EMPTY_EMAIL_ERROR = new TString("EMPTY_EMAIL_ERROR", "Your email is empty or only contains invalid characters.");
    public static TString EMPTY_PASSWORD_ERROR = new TString("EMPTY_PASSWORD_ERROR", "Your password is empty or only contains invalid characters.");
    public static TString EMAIL_LENGTH_ERROR = new TString("EMAIL_LENGTH_ERROR", "Your email has more than 72 characters. This is not allowed.");
    public static TString PASSWORD_LENGTH_ERROR = new TString("PASSWORD_LENGTH_ERROR", "Your password has more than 72 characters. This is not allowed.");
    public static TString FILTER = new TString("FILTER", "Filter");
    public static TString OPEN = new TString("OPEN", "Open");
    public static TString OPEN_VERB = new TString("OPEN_VERB", "Open");
    public static TString CLOSED = new TString("CLOSED", "Closed");
    public static TString DEATH_CASE = new TString("DEATH_CASE", "Death case");
    public static TString PRECAUTION = new TString("PRECAUTION", "Precaution");
    public static TString CREATED = new TString("CREATED", "Created");
    public static TString NEW_CASE = new TString("NEW_CASE", "New Case");
    public static TString SHOW_DETAILS = new TString("SHOW_DETAILS", "+ Show Details");
    public static TString HIDE_DETAILS = new TString("HIDE_DETAILS", "- Hide Details");
    public static TString REFRESH_DATA_INFO = new TString("REFRESH_DATA_INFO", "Newer data is available. Click here to update once done with your current work.");
    public static TString CREATED_AT = new TString("CREATED_AT", "Created at");
    public static TString GENERAL = new TString("GENERAL", "General");
    public static TString GALLERY = new TString("GALLERY", "Gallery");
    public static TString PERSONS = new TString("PERSONS", "Persons");
    public static TString ORDERS = new TString("ORDERS", "Orders");
    public static TString USERS = new TString("USERS", "Users");
    public static TString FORMS = new TString("FORMS", "Forms");
    public static TString PRODUCTS = new TString("PRODUCTS", "Products");
    public static TString NEW_PERSON = new TString("NEW_PERSON", "New Person");
    public static TString NEW_FORM = new TString("NEW_FORM", "New Form");
    public static TString NEW_FILE = new TString("NEW_FILE", "New File");
    public static TString NEW_USER = new TString("NEW_USER", "New User");
    public static TString NEW_PRODUCT = new TString("NEW_PRODUCT", "New Product");
    public static TString ADD_NEW_PERSON = new TString("ADD_NEW_PERSON", "Add new Person");
    public static TString NEW = new TString("NEW", "New");
    public static TString OPEN_IN_NEW_TAB = new TString("OPEN_IN_NEW_TAB", "Open in new tab");
    public static TString FILES = new TString("FILES", "Files");
    public static TString RENAME = new TString("RENAME", "Rename");
    public static TString DELETE = new TString("DELETE", "Delete");
    public static TString DOWNLOAD = new TString("DOWNLOAD", "Download");
    public static TString EDIT = new TString("EDIT", "Edit");
    public static TString EDIT_METADATA = new TString("EDIT_METADATA", "Edit Metadata");
    public static TString DISCARD = new TString("DISCARD", "Discard");
    public static TString SAVE = new TString("SAVE", "Save");

}
