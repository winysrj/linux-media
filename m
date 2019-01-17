Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD189C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 00:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FB932077B
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 00:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MgrVt2jm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfAQAIo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 19:08:44 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:51259 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfAQAIn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 19:08:43 -0500
Received: by mail-it1-f194.google.com with SMTP id w18so6106292ite.1
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 16:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ROgsGRC1aXPyNDUNLbPIVE46F5mzP1j4NIuVo7iWHb0=;
        b=MgrVt2jmcNDe2WgxOQHBKa9h4m7Vh+KzBjrnStpPep+L3JjsIjzXEx61MYUSLufGZT
         ECrfPi1I7bQL6lGKjTHqT6Rgaw4aSKU/n5o/lD7weQ4BE6GhbHuJdonl/BOLvePZKGxa
         jKtq5UHZs5Q6AK+1HCtNXBl02PrU2IBahNS18FXMq0xdUHDvtgVi0+N/JSrSEbYZdKzp
         Qj5npqFixe30NSTd3uh+l1MMMShR36sakuQPFzQ5fthuPzOvqKljOEbLodcPGGTKqgPI
         J72PFQ0t8zj6A7LfHUlYBjFLeBargQ2McdAEhNDpgvVJ9x2o+Jz4Ss3kx9prvX8hEVvY
         tnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ROgsGRC1aXPyNDUNLbPIVE46F5mzP1j4NIuVo7iWHb0=;
        b=Y0kGZNwexH/j9m9S9r0icetSYvyq/erJaU7SWL7OnigHx2ULMYh6+uucCmemluriNC
         TwwCPYd/uovx8yK5fXANfAp2rSc9muqcpqi7A8ScwDjGBBvLGANXhKwE4jml+Igx0Fdv
         q9Za7OD390ekCQoBpL4QLOG2zciBp0kL1rB9tpuw8U8r9crmiqSg0XGfIz8SBa8+WWLG
         j/wOu5zR7Bgq1GwIh9UhCEHumtO0DaO9mnsgd4jpYbuToHs30e+KX/WbGgbJ9qLccGIl
         HeeqtF/R8BmSEp75RzPsru1A/3YBqmgu1dejHO33sfxEYb27yTbNxb7JmsJFDVl2b6Cu
         Eihg==
X-Gm-Message-State: AJcUukdCUYS6/gS2E1ZGzhYS79DYPaC2GyhhoPRTxmP7nyy/KDo9IAAA
        wbT9KaFiaHHhw3q9LhhyQEHhFE3+
X-Google-Smtp-Source: ALg8bN5BXWyARXUzEPfqDSuLThx3wWaYC886vAq5YyvScGDbbV3GRuFeRvhXtw0NU3iHzhfU0R31gQ==
X-Received: by 2002:a05:660c:452:: with SMTP id d18mr7091879itl.124.1547683722256;
        Wed, 16 Jan 2019 16:08:42 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id w16sm4306173ita.38.2019.01.16.16.08.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Jan 2019 16:08:40 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar v2 1/1] Add simple dbus IPC API to zbarcam.
Date:   Thu, 17 Jan 2019 08:08:32 +0800
Message-Id: <1547683712-23970-1-git-send-email-james.hilliard1@gmail.com>
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
 .gitignore                 |  1 +
 Makefile.am                |  6 +++
 configure.ac               | 30 ++++++++++++++
 dbus/org.linuxtv.Zbar.conf | 19 +++++++++
 include/zbar.h             |  8 ++++
 zbar/Makefile.am.inc       |  4 ++
 zbar/processor.c           | 99 ++++++++++++++++++++++++++++++++++++++++++++++
 zbar/processor.h           |  4 ++
 zbarcam/zbarcam.c          | 14 +++++++
 zbarimg/zbarimg.c          | 14 +++++++
 10 files changed, 199 insertions(+)
 create mode 100644 dbus/org.linuxtv.Zbar.conf

diff --git a/.gitignore b/.gitignore
index 0d716e3..f7a0090 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,6 +20,7 @@ gtk/zbarmarshal.c
 gtk/zbarmarshal.h
 include/config.h
 include/config.h.in
+include/config.h.in~
 include/stamp-h1
 libtool
 pygtk/zbarpygtk.c
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
index 0000000..75304c4
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
+               send_interface="org.linuxtv.Zbar1.Code"/>
+        <allow send_destination="org.linuxtv.Zbar"
+               send_interface="org.freedesktop.DBus.Properties"/>
+        <allow send_destination="org.linuxtv.Zbar"
+               send_interface="org.freedesktop.DBus.Introspectable"/>
+    </policy>
+</busconfig>
diff --git a/include/zbar.h b/include/zbar.h
index 7138a95..e999fa8 100644
--- a/include/zbar.h
+++ b/include/zbar.h
@@ -985,6 +985,14 @@ extern int zbar_process_one(zbar_processor_t *processor,
 extern int zbar_process_image(zbar_processor_t *processor,
                               zbar_image_t *image);
 
+/** enable dbus IPC API.
+ * @returns 0 succesful
+ */
+#ifdef HAVE_DBUS
+int zbar_processor_request_dbus (zbar_processor_t *proc,
+                                 int req_dbus_enabled);
+#endif
+
 /** display detail for last processor error to stderr.
  * @returns a non-zero value suitable for passing to exit()
  */
diff --git a/zbar/Makefile.am.inc b/zbar/Makefile.am.inc
index 7806295..85d05c2 100644
--- a/zbar/Makefile.am.inc
+++ b/zbar/Makefile.am.inc
@@ -106,5 +106,9 @@ zbar_libzbar_la_SOURCES += zbar/processor/null.c zbar/window/null.c
 endif
 endif
 
+if HAVE_DBUS
+zbar_libzbar_la_LDFLAGS += $(DBUS_LIBS)
+endif
+
 zbar_libzbar_la_LDFLAGS += $(AM_LDFLAGS)
 zbar_libzbar_la_LIBADD += $(AM_LIBADD)
diff --git a/zbar/processor.c b/zbar/processor.c
index 1c7a150..7938d54 100644
--- a/zbar/processor.c
+++ b/zbar/processor.c
@@ -25,6 +25,10 @@
 #include "window.h"
 #include "image.h"
 
+#ifdef HAVE_DBUS
+#include <dbus/dbus.h>
+#endif
+
 static inline int proc_enter (zbar_processor_t *proc)
 {
     _zbar_mutex_lock(&proc->mutex);
@@ -49,6 +53,86 @@ static inline int proc_open (zbar_processor_t *proc)
     return(_zbar_processor_open(proc, "zbar barcode reader", width, height));
 }
 
+#ifdef HAVE_DBUS
+void zbar_send_dbus(const char* sigvalue)
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
+    ret = dbus_bus_request_name(conn, "org.linuxtv.Zbar", DBUS_NAME_FLAG_REPLACE_EXISTING, &err);
+    if (dbus_error_is_set(&err)) {
+        fprintf(stderr, "Name Error (%s)\n", err.message);
+        dbus_error_free(&err);
+    }
+    if (DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER != ret) {
+        exit(1);
+    }
+
+    // create a signal & check for errors
+    msg = dbus_message_new_signal("/org/linuxtv/Zbar1/Code", // object name of the signal
+                                 "org.linuxtv.Zbar1.Code", // interface name of the signal
+                                 "Code"); // name of the signal
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
+
+static void zbar_send_code_via_dbus (zbar_image_t *img, const void *userdata)
+{
+    const zbar_symbol_t *sym = zbar_image_first_symbol(img);
+    assert(sym);
+    int n = 0;
+    for(; sym; sym = zbar_symbol_next(sym)) {
+        if(zbar_symbol_get_count(sym))
+            continue;
+
+        zbar_symbol_type_t type = zbar_symbol_get_type(sym);
+        if(type == ZBAR_PARTIAL)
+            continue;
+
+        zbar_send_dbus(zbar_symbol_get_data(sym));
+        n++;
+    }
+}
+#endif
+
 /* API lock is already held */
 int _zbar_process_image (zbar_processor_t *proc,
                          zbar_image_t *img)
@@ -114,6 +198,10 @@ int _zbar_process_image (zbar_processor_t *proc,
             _zbar_mutex_unlock(&proc->mutex);
             if(proc->handler)
                 proc->handler(img, proc->userdata);
+#ifdef HAVE_DBUS
+            if(proc->is_dbus_enabled)
+                zbar_send_code_via_dbus(img, proc->userdata);
+#endif
         }
 
         if(force_fmt) {
@@ -711,3 +799,14 @@ int zbar_process_image (zbar_processor_t *proc,
     proc_leave(proc);
     return(rc);
 }
+
+#ifdef HAVE_DBUS
+int zbar_processor_request_dbus (zbar_processor_t *proc,
+                                 int req_dbus_enabled)
+{
+    proc_enter(proc);
+    proc->is_dbus_enabled = req_dbus_enabled;
+    proc_leave(proc);
+    return(0);
+}
+#endif
diff --git a/zbar/processor.h b/zbar/processor.h
index 5dcd05a..39bfc37 100644
--- a/zbar/processor.h
+++ b/zbar/processor.h
@@ -69,6 +69,10 @@ struct zbar_processor_s {
 
     zbar_image_data_handler_t *handler; /* application data handler */
 
+#ifdef HAVE_DBUS
+    int is_dbus_enabled;                /* dbus enabled flag */
+#endif
+
     unsigned req_width, req_height;     /* application requested video size */
     int req_intf, req_iomode;           /* application requested interface */
     uint32_t force_input;               /* force input format (debug) */
diff --git a/zbarcam/zbarcam.c b/zbarcam/zbarcam.c
index e0f3622..7259af5 100644
--- a/zbarcam/zbarcam.c
+++ b/zbarcam/zbarcam.c
@@ -48,6 +48,9 @@ static const char *note_usage =
     "    --verbose=N     set specific debug output level\n"
     "    --xml           use XML output format\n"
     "    --raw           output decoded symbol data without symbology prefix\n"
+#ifdef HAVE_DBUS
+    "    --nodbus        disable dbus message\n"
+#endif
     "    --nodisplay     disable video display window\n"
     "    --prescale=<W>x<H>\n"
     "                    request alternate video image size from driver\n"
@@ -150,6 +153,9 @@ int main (int argc, const char *argv[])
     zbar_processor_set_data_handler(proc, data_handler, NULL);
 
     const char *video_device = "";
+#ifdef HAVE_DBUS
+    int dbus = 1;
+#endif
     int display = 1;
     unsigned long infmt = 0, outfmt = 0;
     int i;
@@ -203,6 +209,10 @@ int main (int argc, const char *argv[])
             format = XML;
         else if(!strcmp(argv[i], "--raw"))
             format = RAW;
+#ifdef HAVE_DBUS
+        else if(!strcmp(argv[i], "--nodbus"))
+            dbus = 0;
+#endif
         else if(!strcmp(argv[i], "--nodisplay"))
             display = 0;
         else if(!strcmp(argv[i], "--verbose"))
@@ -247,6 +257,10 @@ int main (int argc, const char *argv[])
     if(infmt || outfmt)
         zbar_processor_force_format(proc, infmt, outfmt);
 
+#ifdef HAVE_DBUS
+    zbar_processor_request_dbus(proc, dbus);
+#endif
+
     /* open video device, open window */
     if(zbar_processor_init(proc, video_device, display) ||
        /* show window */
diff --git a/zbarimg/zbarimg.c b/zbarimg/zbarimg.c
index d3cf5e8..e149c07 100644
--- a/zbarimg/zbarimg.c
+++ b/zbarimg/zbarimg.c
@@ -74,6 +74,9 @@ static const char *note_usage =
     "    -q, --quiet     minimal output, only print decoded symbol data\n"
     "    -v, --verbose   increase debug output level\n"
     "    --verbose=N     set specific debug output level\n"
+#ifdef HAVE_DBUS
+    "    --nodbus        disable dbus message\n"
+#endif
     "    -d, --display   enable display of following images to the screen\n"
     "    -D, --nodisplay disable display of following images (default)\n"
     "    --xml, --noxml  enable/disable XML output format\n"
@@ -265,6 +268,9 @@ int main (int argc, const char *argv[])
 {
     // option pre-scan
     int quiet = 0;
+#ifdef HAVE_DBUS
+    int dbus = 1;
+#endif
     int display = 0;
     int i, j;
     for(i = 1; i < argc; i++) {
@@ -305,6 +311,10 @@ int main (int argc, const char *argv[])
             zbar_increase_verbosity();
         else if(!strncmp(arg, "--verbose=", 10))
             zbar_set_verbosity(strtol(argv[i] + 10, NULL, 0));
+#ifdef HAVE_DBUS
+        else if(!strcmp(arg, "--nodbus"))
+            dbus = 0;
+#endif
         else if(!strcmp(arg, "--display"))
             display++;
         else if(!strcmp(arg, "--nodisplay") ||
@@ -328,6 +338,10 @@ int main (int argc, const char *argv[])
 
     InitializeMagick("zbarimg");
 
+#ifdef HAVE_DBUS
+    zbar_processor_request_dbus(processor, dbus);
+#endif
+
     processor = zbar_processor_create(0);
     assert(processor);
     if(zbar_processor_init(processor, NULL, display)) {
-- 
2.7.4

