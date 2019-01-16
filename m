Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BB9C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 08:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3A5920840
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 08:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q8Oudawo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389101AbfAPIzZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 03:55:25 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:53148 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388751AbfAPIzZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 03:55:25 -0500
Received: by mail-it1-f195.google.com with SMTP id g76so1880098itg.2
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 00:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YYk1LguKhw25PfAkyEP90PyeW6gAYAejCgARmBMpH5Q=;
        b=q8OudawoW2efn3qMnXAcq8IMSGnG8DOO4z71Kwws+fnn+sDHmYetdF+SYElSYJWqz6
         CVx7+WR2X6i/VAJ5Tl1CAFw7dWQoMgQmyddgFhgcxlfecW2tt2qgeKG3y2qplY35WmDL
         MJAyZVbZtCWdgE2chu4BHYDJMBRDarzqC81Mh8yMNdLGAV5tAGnm6bC6ykVq0BlopJ+4
         LDR4E0IlQC6NB2L1lF4LLmW731Uo7Vr7azhF41GOER7WCgy5V73kqq38nls2bZmL2BW2
         ft6iq9K3jB6WNG/x/CXZsER2z2iAHByqE7h82yqAPVZYpoecKbiy+73YHSTr5mxM5kBS
         bvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YYk1LguKhw25PfAkyEP90PyeW6gAYAejCgARmBMpH5Q=;
        b=FxEZpoV25Idk0eSYUROaW9hWY2vbgQGwfr9Zub5MeGAldI8Y9llQkXAPOlG9vlwU6t
         sHrSzCnufFKK3FJENpWBNugtdcWNlsTeGHR+DJmsgjQg3eKfpwELMK4wFa3v4yG248rw
         N+281rFSNhx2M6ExXcI+eF7BbRAPY1bgaQMvjL0wWiyOMOcyyQxoolxqgZMnflcUa8gJ
         fjKNf2vNxxQT8Ooc4rLv4vnkqYw6sDun/Q5rV53GS64n2YfVwEoU1DFvzyXYs8adgegj
         UnqcyANO7ZSPD0huWnpEZ126A7+d8+2XgR01g6rDjr8AxUD1G4L2QZteu5xA1TE+zIzw
         G89Q==
X-Gm-Message-State: AJcUukewnKIBJldKwRwFkCJm+lkkl0u1KAyvMcZd+NOYx/wayW3kaaUF
        Vu1NyPM4I3PCokTyMEGyvyQ=
X-Google-Smtp-Source: ALg8bN5WF1xlAYXwwCfxlGHjqkoH0Jc1dHoUZNfKb+v9WFnOeNjJ7PlDSkle7hmjrxQ4XCriv5Vf8Q==
X-Received: by 2002:a24:f30b:: with SMTP id t11mr4379038ith.40.1547628923896;
        Wed, 16 Jan 2019 00:55:23 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id j14sm2237178ioa.5.2019.01.16.00.55.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Jan 2019 00:55:22 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 1/1] Add simple dbus IPC API to zbarcam.
Date:   Wed, 16 Jan 2019 16:54:55 +0800
Message-Id: <1547628895-15129-1-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

This is useful for running zbarcam as a systemd service so that other
applications can receive scan messages through dbus.

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 Makefile.am                |  6 ++++
 configure.ac               | 30 ++++++++++++++++++++
 dbus/org.linuxtv.Zbar.conf | 19 +++++++++++++
 zbarcam/Makefile.am.inc    |  4 +++
 zbarcam/zbarcam.c          | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 129 insertions(+)
 create mode 100644 dbus/org.linuxtv.Zbar.conf

diff --git a/Makefile.am b/Makefile.am
index 624dcde..62e516a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -50,6 +50,12 @@ if HAVE_DOC
 include $(srcdir)/doc/Makefile.am.inc
 endif
 
+if HAVE_DBUS
+dbusconfdir = @DBUS_CONFDIR@
+dbusconf_DATA = $(srcdir)/dbus/org.linuxtv.Zbar.conf
+EXTRA_DIST += $(dbusconf_DATA)
+endif
+
 EXTRA_DIST += zbar.ico zbar.nsi
 
 EXTRA_DIST += examples/barcode.png examples/upcrpc.py examples/upcrpc.pl \
diff --git a/configure.ac b/configure.ac
index 2633b48..2398da5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -291,6 +291,35 @@ specify XV_LIBS or configure --without-xv to disable the extension])],
 ])
 AM_CONDITIONAL([HAVE_XV], [test "x$with_xv" = "xyes"])
 
+dnl dbus
+AC_ARG_WITH([dbus],
+  [AS_HELP_STRING([--without-dbus],
+    [disable support for dbus])],
+  [],
+  [with_dbus="check"])
+
+AS_IF([test "x$with_dbus" != "xno"],
+  [PKG_CHECK_MODULES(DBUS, dbus-1 >= 1.0, have_dbus=yes, have_dbus=no)
+  AS_IF([test "x$have_dbusx$with_dbus" = "xnoxyes"],
+    [AC_MSG_FAILURE([DBus development libraries not found])],
+    [with_dbus="$have_dbus"])
+])
+AM_CONDITIONAL([HAVE_DBUS], [test "x$with_dbus" = "xyes"])
+
+AS_IF([test "x$with_dbus" = "xyes"],
+  [CPPFLAGS="$CPPFLAGS $DBUS_CFLAGS"
+  AC_ARG_VAR([DBUS_LIBS], [linker flags for building dbus])
+  AC_DEFINE([HAVE_DBUS], [1], [Define to 1 to use dbus])
+  AC_ARG_WITH(dbusconfdir, AC_HELP_STRING([--with-dbusconfdir=PATH],
+  [path to D-Bus config directory]),
+  [path_dbusconf=$withval],
+  [path_dbusconf="`$PKG_CONFIG --variable=sysconfdir dbus-1`"])
+  AS_IF([test -z "$path_dbusconf"],
+    DBUS_CONFDIR="$sysconfdir/dbus-1/system.d",
+    DBUS_CONFDIR="$path_dbusconf/dbus-1/system.d")
+  AC_SUBST(DBUS_CONFDIR)
+])
+
 dnl libjpeg
 AC_ARG_WITH([jpeg],
   [AS_HELP_STRING([--without-jpeg],
@@ -617,6 +646,7 @@ AS_IF([test "x$enable_video" != "xyes"],
   [echo "        => zbarcam video scanner will *NOT* be built"])
 AS_IF([test "x$have_libv4l" != "xyes"],
   [echo "        => libv4l will *NOT* be used"])
+echo "dbus              --with-dbus=$with_dbus"
 echo "jpeg              --with-jpeg=$with_jpeg"
 AS_IF([test "x$with_jpeg" != "xyes"],
   [echo "        => JPEG image conversions will *NOT* be supported"])
diff --git a/dbus/org.linuxtv.Zbar.conf b/dbus/org.linuxtv.Zbar.conf
new file mode 100644
index 0000000..e0a5ea5
--- /dev/null
+++ b/dbus/org.linuxtv.Zbar.conf
@@ -0,0 +1,19 @@
+<!DOCTYPE busconfig PUBLIC
+ "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
+ "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
+<busconfig>
+
+    <policy user="root">
+        <allow own="org.linuxtv.Zbar"/>
+    </policy>
+
+    <policy context="default">
+        <allow send_destination="org.linuxtv.Zbar"/>
+        <allow send_destination="org.linuxtv.Zbar"
+               send_interface="org.linuxtv.ZbarCam1"/>
+        <allow send_destination="org.linuxtv.Zbar"
+               send_interface="org.freedesktop.DBus.Properties"/>
+        <allow send_destination="org.linuxtv.Zbar"
+               send_interface="org.freedesktop.DBus.Introspectable"/>
+    </policy>
+</busconfig>
diff --git a/zbarcam/Makefile.am.inc b/zbarcam/Makefile.am.inc
index 5aa788a..98199ee 100644
--- a/zbarcam/Makefile.am.inc
+++ b/zbarcam/Makefile.am.inc
@@ -4,6 +4,10 @@ zbarcam_zbarcam_LDADD = zbar/libzbar.la
 # automake bug in "monolithic mode"?
 CLEANFILES += zbarcam/.libs/zbarcam zbarcam/moc_zbarcam_qt.h
 
+if HAVE_DBUS
+zbarcam_zbarcam_LDADD += $(DBUS_LIBS)
+endif
+
 if HAVE_GTK
 bin_PROGRAMS += zbarcam/zbarcam-gtk
 check_PROGRAMS += zbarcam/zbarcam-gtk
diff --git a/zbarcam/zbarcam.c b/zbarcam/zbarcam.c
index e0f3622..18b4fd1 100644
--- a/zbarcam/zbarcam.c
+++ b/zbarcam/zbarcam.c
@@ -33,6 +33,10 @@
 
 #include <zbar.h>
 
+#ifdef HAVE_DBUS
+#include <dbus/dbus.h>
+#endif
+
 #define BELL "\a"
 
 static const char *note_usage =
@@ -92,6 +96,68 @@ static inline int parse_config (const char *cfgstr, int i, int n, char *arg)
     return(0);
 }
 
+#ifdef HAVE_DBUS
+void send_dbus(const char* sigvalue)
+{
+    DBusMessage* msg;
+    DBusMessageIter args;
+    DBusConnection* conn;
+    DBusError err;
+    int ret;
+    dbus_uint32_t serial = 0;
+
+    // initialise the error value
+    dbus_error_init(&err);
+
+    // connect to the DBUS system bus, and check for errors
+    conn = dbus_bus_get(DBUS_BUS_SYSTEM, &err);
+    if (dbus_error_is_set(&err)) {
+        fprintf(stderr, "Connection Error (%s)\n", err.message);
+        dbus_error_free(&err);
+    }
+    if (NULL == conn) {
+        exit(1);
+    }
+
+    // register our name on the bus, and check for errors
+    ret = dbus_bus_request_name(conn, "org.linuxtv.Zbar", DBUS_NAME_FLAG_REPLACE_EXISTING , &err);
+    if (dbus_error_is_set(&err)) {
+        fprintf(stderr, "Name Error (%s)\n", err.message);
+        dbus_error_free(&err);
+    }
+    if (DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER != ret) {
+        exit(1);
+    }
+
+    // create a signal & check for errors
+    msg = dbus_message_new_signal("/org/linuxtv/ZbarCam1", // object name of the signal
+                                 "org.linuxtv.ZbarCam1", // interface name of the signal
+                                 "ZbarCam1"); // name of the signal
+    if (NULL == msg)
+    {
+        fprintf(stderr, "Message Null\n");
+        exit(1);
+    }
+
+    // append arguments onto signal
+    dbus_message_iter_init_append(msg, &args);
+    if (!dbus_message_iter_append_basic(&args, DBUS_TYPE_STRING, &sigvalue)) {
+        fprintf(stderr, "Out Of Memory!\n");
+        exit(1);
+    }
+
+    // send the message and flush the connection
+    if (!dbus_connection_send(conn, msg, &serial)) {
+        fprintf(stderr, "Out Of Memory!\n");
+        exit(1);
+    }
+    dbus_connection_flush(conn);
+
+    // free the message
+    dbus_message_unref(msg);
+}
+#endif
+
 static void data_handler (zbar_image_t *img, const void *userdata)
 {
     const zbar_symbol_t *sym = zbar_image_first_symbol(img);
@@ -105,6 +171,10 @@ static void data_handler (zbar_image_t *img, const void *userdata)
         if(type == ZBAR_PARTIAL)
             continue;
 
+#ifdef HAVE_DBUS
+        send_dbus(zbar_symbol_get_data(sym));
+#endif
+
         if(!format) {
             printf("%s:", zbar_get_symbol_name(type));
             if(fwrite(zbar_symbol_get_data(sym),
-- 
2.7.4

