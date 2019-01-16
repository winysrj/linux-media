Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B259BC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 14:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A30420675
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547649426;
	bh=oMdFqFUx3mHyui5xJPddQ4hMIKs+FIfh5Ngne4u3Kj4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=ighcikFUcZf3YhmaiBTJBDCorSVxR7XhN/ZdP9kHTbWFDSmVt3I+bicm+mMsPEMq8
	 VEgtEHLSRmVMfo5T07YiVamXCRTdS91UBGRqbkSfR1c++HhaKw3w5d899AKbcVX2KY
	 96oKrc32a0I5pbFOQcIC4UNMqKXz/TERKXOIEZFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393671AbfAPOhG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:37:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:50012 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfAPOhF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 09:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xuUucpH5DeStuzjgzaKw4P7WSyWOgFwB+3DUcWyHqg4=; b=m8QPKKxJVVgC1n62hERodLgfdr
        t8+NWtpDb6+C2G/cZLOR2NwzRWrI/gPPJhJd1osbZmY1XMhzXdqHXHgOcfGNPlzcWuIS7s2nY4Zdi
        6Rra0KD9eWi53fBhQmt0NX1AWfYkSZ64fwyFIEAT8qV8pVYrx+vmp++i7lS9vi4A+YEFWGCOwKWII
        c+N6U4zzyKpqLCYC8c0iSHZiQjxwYiY538ltaSTzY3r4i6WDx+hqNLDik7t7TFlOKZITgV96zbLy1
        l7SzftBrpsRaaORbvNPoATzufGVkEH2RXb6i2x8f+YJtzNY/JypJBCPY2zkla5riMf/CqR28b6hLI
        Gr9/O8ZA==;
Received: from [186.213.247.186] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gjmJT-00012c-Bn; Wed, 16 Jan 2019 14:37:03 +0000
Date:   Wed, 16 Jan 2019 12:36:59 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     james.hilliard1@gmail.com
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH zbar 1/1] Add simple dbus IPC API to zbarcam.
Message-ID: <20190116123659.3908edd4@coco.lan>
In-Reply-To: <1547628895-15129-1-git-send-email-james.hilliard1@gmail.com>
References: <1547628895-15129-1-git-send-email-james.hilliard1@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi James,

Em Wed, 16 Jan 2019 16:54:55 +0800
james.hilliard1@gmail.com escreveu:

> From: James Hilliard <james.hilliard1@gmail.com>
> 
> This is useful for running zbarcam as a systemd service so that other
> applications can receive scan messages through dbus.

Nice approach!

Yet, I would try to write it on a different way, making sure that it
could also be using by zbarimg.

I mean, if you add the dbus bindings inside the zbar core, it
shouldn't matter if the source image comes via a webcam or via a 
scanned image. Both will be able to send the scancodes via dbus.

As a future approach, we may even think on making the interface
duplex in the future, e. g. allowing any camera application to
send an image via dbus and let zbar to decode it and return
the decoded bar codes.

> 
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---
>  Makefile.am                |  6 ++++
>  configure.ac               | 30 ++++++++++++++++++++
>  dbus/org.linuxtv.Zbar.conf | 19 +++++++++++++
>  zbarcam/Makefile.am.inc    |  4 +++
>  zbarcam/zbarcam.c          | 70 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 129 insertions(+)
>  create mode 100644 dbus/org.linuxtv.Zbar.conf
> 
> diff --git a/Makefile.am b/Makefile.am
> index 624dcde..62e516a 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -50,6 +50,12 @@ if HAVE_DOC
>  include $(srcdir)/doc/Makefile.am.inc
>  endif
>  
> +if HAVE_DBUS
> +dbusconfdir = @DBUS_CONFDIR@
> +dbusconf_DATA = $(srcdir)/dbus/org.linuxtv.Zbar.conf
> +EXTRA_DIST += $(dbusconf_DATA)
> +endif
> +
>  EXTRA_DIST += zbar.ico zbar.nsi
>  
>  EXTRA_DIST += examples/barcode.png examples/upcrpc.py examples/upcrpc.pl \
> diff --git a/configure.ac b/configure.ac
> index 2633b48..2398da5 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -291,6 +291,35 @@ specify XV_LIBS or configure --without-xv to disable the extension])],
>  ])
>  AM_CONDITIONAL([HAVE_XV], [test "x$with_xv" = "xyes"])
>  
> +dnl dbus
> +AC_ARG_WITH([dbus],
> +  [AS_HELP_STRING([--without-dbus],
> +    [disable support for dbus])],
> +  [],
> +  [with_dbus="check"])
> +
> +AS_IF([test "x$with_dbus" != "xno"],
> +  [PKG_CHECK_MODULES(DBUS, dbus-1 >= 1.0, have_dbus=yes, have_dbus=no)
> +  AS_IF([test "x$have_dbusx$with_dbus" = "xnoxyes"],
> +    [AC_MSG_FAILURE([DBus development libraries not found])],
> +    [with_dbus="$have_dbus"])
> +])
> +AM_CONDITIONAL([HAVE_DBUS], [test "x$with_dbus" = "xyes"])
> +
> +AS_IF([test "x$with_dbus" = "xyes"],
> +  [CPPFLAGS="$CPPFLAGS $DBUS_CFLAGS"
> +  AC_ARG_VAR([DBUS_LIBS], [linker flags for building dbus])
> +  AC_DEFINE([HAVE_DBUS], [1], [Define to 1 to use dbus])
> +  AC_ARG_WITH(dbusconfdir, AC_HELP_STRING([--with-dbusconfdir=PATH],
> +  [path to D-Bus config directory]),
> +  [path_dbusconf=$withval],
> +  [path_dbusconf="`$PKG_CONFIG --variable=sysconfdir dbus-1`"])
> +  AS_IF([test -z "$path_dbusconf"],
> +    DBUS_CONFDIR="$sysconfdir/dbus-1/system.d",
> +    DBUS_CONFDIR="$path_dbusconf/dbus-1/system.d")
> +  AC_SUBST(DBUS_CONFDIR)
> +])
> +
>  dnl libjpeg
>  AC_ARG_WITH([jpeg],
>    [AS_HELP_STRING([--without-jpeg],
> @@ -617,6 +646,7 @@ AS_IF([test "x$enable_video" != "xyes"],
>    [echo "        => zbarcam video scanner will *NOT* be built"])
>  AS_IF([test "x$have_libv4l" != "xyes"],
>    [echo "        => libv4l will *NOT* be used"])
> +echo "dbus              --with-dbus=$with_dbus"
>  echo "jpeg              --with-jpeg=$with_jpeg"
>  AS_IF([test "x$with_jpeg" != "xyes"],
>    [echo "        => JPEG image conversions will *NOT* be supported"])
> diff --git a/dbus/org.linuxtv.Zbar.conf b/dbus/org.linuxtv.Zbar.conf
> new file mode 100644
> index 0000000..e0a5ea5
> --- /dev/null
> +++ b/dbus/org.linuxtv.Zbar.conf
> @@ -0,0 +1,19 @@
> +<!DOCTYPE busconfig PUBLIC
> + "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
> + "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
> +<busconfig>
> +
> +    <policy user="root">
> +        <allow own="org.linuxtv.Zbar"/>
> +    </policy>
> +
> +    <policy context="default">
> +        <allow send_destination="org.linuxtv.Zbar"/>
> +        <allow send_destination="org.linuxtv.Zbar"
> +               send_interface="org.linuxtv.ZbarCam1"/>
> +        <allow send_destination="org.linuxtv.Zbar"
> +               send_interface="org.freedesktop.DBus.Properties"/>
> +        <allow send_destination="org.linuxtv.Zbar"
> +               send_interface="org.freedesktop.DBus.Introspectable"/>
> +    </policy>
> +</busconfig>
> diff --git a/zbarcam/Makefile.am.inc b/zbarcam/Makefile.am.inc
> index 5aa788a..98199ee 100644
> --- a/zbarcam/Makefile.am.inc
> +++ b/zbarcam/Makefile.am.inc
> @@ -4,6 +4,10 @@ zbarcam_zbarcam_LDADD = zbar/libzbar.la
>  # automake bug in "monolithic mode"?
>  CLEANFILES += zbarcam/.libs/zbarcam zbarcam/moc_zbarcam_qt.h
>  
> +if HAVE_DBUS
> +zbarcam_zbarcam_LDADD += $(DBUS_LIBS)
> +endif
> +
>  if HAVE_GTK
>  bin_PROGRAMS += zbarcam/zbarcam-gtk
>  check_PROGRAMS += zbarcam/zbarcam-gtk
> diff --git a/zbarcam/zbarcam.c b/zbarcam/zbarcam.c
> index e0f3622..18b4fd1 100644
> --- a/zbarcam/zbarcam.c
> +++ b/zbarcam/zbarcam.c
> @@ -33,6 +33,10 @@
>  
>  #include <zbar.h>
>  
> +#ifdef HAVE_DBUS
> +#include <dbus/dbus.h>
> +#endif
> +
>  #define BELL "\a"
>  
>  static const char *note_usage =
> @@ -92,6 +96,68 @@ static inline int parse_config (const char *cfgstr, int i, int n, char *arg)
>      return(0);
>  }
>  
> +#ifdef HAVE_DBUS
> +void send_dbus(const char* sigvalue)
> +{
> +    DBusMessage* msg;
> +    DBusMessageIter args;
> +    DBusConnection* conn;
> +    DBusError err;
> +    int ret;
> +    dbus_uint32_t serial = 0;
> +
> +    // initialise the error value
> +    dbus_error_init(&err);
> +
> +    // connect to the DBUS system bus, and check for errors
> +    conn = dbus_bus_get(DBUS_BUS_SYSTEM, &err);
> +    if (dbus_error_is_set(&err)) {
> +        fprintf(stderr, "Connection Error (%s)\n", err.message);
> +        dbus_error_free(&err);
> +    }
> +    if (NULL == conn) {
> +        exit(1);
> +    }
> +
> +    // register our name on the bus, and check for errors
> +    ret = dbus_bus_request_name(conn, "org.linuxtv.Zbar", DBUS_NAME_FLAG_REPLACE_EXISTING , &err);
> +    if (dbus_error_is_set(&err)) {
> +        fprintf(stderr, "Name Error (%s)\n", err.message);
> +        dbus_error_free(&err);
> +    }
> +    if (DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER != ret) {
> +        exit(1);
> +    }
> +
> +    // create a signal & check for errors
> +    msg = dbus_message_new_signal("/org/linuxtv/ZbarCam1", // object name of the signal
> +                                 "org.linuxtv.ZbarCam1", // interface name of the signal
> +                                 "ZbarCam1"); // name of the signal
> +    if (NULL == msg)
> +    {
> +        fprintf(stderr, "Message Null\n");
> +        exit(1);
> +    }
> +
> +    // append arguments onto signal
> +    dbus_message_iter_init_append(msg, &args);
> +    if (!dbus_message_iter_append_basic(&args, DBUS_TYPE_STRING, &sigvalue)) {
> +        fprintf(stderr, "Out Of Memory!\n");
> +        exit(1);
> +    }
> +
> +    // send the message and flush the connection
> +    if (!dbus_connection_send(conn, msg, &serial)) {
> +        fprintf(stderr, "Out Of Memory!\n");
> +        exit(1);
> +    }
> +    dbus_connection_flush(conn);
> +
> +    // free the message
> +    dbus_message_unref(msg);
> +}
> +#endif
> +
>  static void data_handler (zbar_image_t *img, const void *userdata)
>  {
>      const zbar_symbol_t *sym = zbar_image_first_symbol(img);
> @@ -105,6 +171,10 @@ static void data_handler (zbar_image_t *img, const void *userdata)
>          if(type == ZBAR_PARTIAL)
>              continue;
>  
> +#ifdef HAVE_DBUS
> +        send_dbus(zbar_symbol_get_data(sym));
> +#endif
> +
>          if(!format) {
>              printf("%s:", zbar_get_symbol_name(type));
>              if(fwrite(zbar_symbol_get_data(sym),



Thanks,
Mauro
