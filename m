Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF98C43444
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 20:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E56E220868
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 20:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnoQml/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732843AbfAPUiZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 15:38:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37942 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732733AbfAPUiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 15:38:12 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so8532898wrw.5
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 12:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KIUGL1xmgYgN96Hs3RtUeALY0/9z+BV3FmUA/Cjzsmg=;
        b=hnoQml/X8bpCCepdvbr6EucE6LjGHVKCi2kAbP6VLR3zR4s5wv2gy1BdlnvRA74QHj
         v3qErq6oZloaY8kOS7VB5PFVI4gUhuHZ2eVAJD5JUjdXal/M2z/56yHC2HlqOZHyRjwk
         aTfv1p7sd15YuXq9w8iZ6SeO3ndcVcgbt4SLI28J8exS5/n01Dw0KbDy+7LgXFvvCDyQ
         L1RDWQF6noy4vWbSVMmhcjgnhDcqOMJd+kD2J952yvrmP5wn1+dSFwG9xLi4teCuE+JH
         zp0mH3DRlCAyiWOEQx7Mcag+vuMfCt+BSTAq29rKP8GrNK0kIOLWbgzDFLWAOto6E6qU
         tqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KIUGL1xmgYgN96Hs3RtUeALY0/9z+BV3FmUA/Cjzsmg=;
        b=NRT+I6hSfkptlXfM+5R7/NGVGN0RP+n2i3p0w04kMW1j1H37Ze6pSHXMw3YllnNtZo
         1rSEOvkCKCp92KmtnC0ETb3rIEM86VoR/PY3alpc1S6IE9jq8ZdbiHMphZg2o6iqzcp/
         +pRNxrlvo7LyxGd8pkZpkUz+GHb6D3P6mz7Jw8QP/LdDjzZwFCjwesZX460oa3LtA+xc
         YZwBfR7t7Y8iAEEYKhk4r7/WWMKgGlycFzm16Rp0idjS5S+EUsCUsvvH4ZF6y0YtcAIy
         77HwXop7OoeQSBHyWwLD4IuyH8OhiL26u8E+jBkHmW6ZoMhX/KG+RMtjoV2yk9SC30/6
         i+gA==
X-Gm-Message-State: AJcUukf8QayLw01ZuOdywzRS+7rw6TUcYmPUMvI8AEAb8DUL/pwcb2i5
        /Dnjls/C46MHmchbqMFTKBj6KPjUrV37UmJE4EQYopcU
X-Google-Smtp-Source: ALg8bN5WU6Z9GfXo+Sh06b84qEYmnY/Q+YOfcAcDKEvTFnnR9pbRT9nWgZiEmhUvNYOhuL6m0o/8vQ1mIwf4/eg09IU=
X-Received: by 2002:adf:b201:: with SMTP id u1mr8917960wra.165.1547671090679;
 Wed, 16 Jan 2019 12:38:10 -0800 (PST)
MIME-Version: 1.0
References: <1547628895-15129-1-git-send-email-james.hilliard1@gmail.com> <20190116123659.3908edd4@coco.lan>
In-Reply-To: <20190116123659.3908edd4@coco.lan>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Wed, 16 Jan 2019 13:37:58 -0700
Message-ID: <CADvTj4oL+h=bgk1yusG0LqEC2itDQ-bThKqEFsztuG6BEqEw-Q@mail.gmail.com>
Subject: Re: [PATCH zbar 1/1] Add simple dbus IPC API to zbarcam.
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 7:37 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Hi James,
>
> Em Wed, 16 Jan 2019 16:54:55 +0800
> james.hilliard1@gmail.com escreveu:
>
> > From: James Hilliard <james.hilliard1@gmail.com>
> >
> > This is useful for running zbarcam as a systemd service so that other
> > applications can receive scan messages through dbus.
>
> Nice approach!
>
> Yet, I would try to write it on a different way, making sure that it
> could also be using by zbarimg.
>
> I mean, if you add the dbus bindings inside the zbar core, it
> shouldn't matter if the source image comes via a webcam or via a
> scanned image. Both will be able to send the scancodes via dbus.
Which function should I call send_dbus() from in that case?
>
> As a future approach, we may even think on making the interface
> duplex in the future, e. g. allowing any camera application to
> send an image via dbus and let zbar to decode it and return
> the decoded bar codes.
That could be useful, probably too difficult for me to implement
myself though(I don't write a lot of c usually).
>
> >
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > ---
> >  Makefile.am                |  6 ++++
> >  configure.ac               | 30 ++++++++++++++++++++
> >  dbus/org.linuxtv.Zbar.conf | 19 +++++++++++++
> >  zbarcam/Makefile.am.inc    |  4 +++
> >  zbarcam/zbarcam.c          | 70 ++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 129 insertions(+)
> >  create mode 100644 dbus/org.linuxtv.Zbar.conf
> >
> > diff --git a/Makefile.am b/Makefile.am
> > index 624dcde..62e516a 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -50,6 +50,12 @@ if HAVE_DOC
> >  include $(srcdir)/doc/Makefile.am.inc
> >  endif
> >
> > +if HAVE_DBUS
> > +dbusconfdir = @DBUS_CONFDIR@
> > +dbusconf_DATA = $(srcdir)/dbus/org.linuxtv.Zbar.conf
> > +EXTRA_DIST += $(dbusconf_DATA)
> > +endif
> > +
> >  EXTRA_DIST += zbar.ico zbar.nsi
> >
> >  EXTRA_DIST += examples/barcode.png examples/upcrpc.py examples/upcrpc.pl \
> > diff --git a/configure.ac b/configure.ac
> > index 2633b48..2398da5 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -291,6 +291,35 @@ specify XV_LIBS or configure --without-xv to disable the extension])],
> >  ])
> >  AM_CONDITIONAL([HAVE_XV], [test "x$with_xv" = "xyes"])
> >
> > +dnl dbus
> > +AC_ARG_WITH([dbus],
> > +  [AS_HELP_STRING([--without-dbus],
> > +    [disable support for dbus])],
> > +  [],
> > +  [with_dbus="check"])
> > +
> > +AS_IF([test "x$with_dbus" != "xno"],
> > +  [PKG_CHECK_MODULES(DBUS, dbus-1 >= 1.0, have_dbus=yes, have_dbus=no)
> > +  AS_IF([test "x$have_dbusx$with_dbus" = "xnoxyes"],
> > +    [AC_MSG_FAILURE([DBus development libraries not found])],
> > +    [with_dbus="$have_dbus"])
> > +])
> > +AM_CONDITIONAL([HAVE_DBUS], [test "x$with_dbus" = "xyes"])
> > +
> > +AS_IF([test "x$with_dbus" = "xyes"],
> > +  [CPPFLAGS="$CPPFLAGS $DBUS_CFLAGS"
> > +  AC_ARG_VAR([DBUS_LIBS], [linker flags for building dbus])
> > +  AC_DEFINE([HAVE_DBUS], [1], [Define to 1 to use dbus])
> > +  AC_ARG_WITH(dbusconfdir, AC_HELP_STRING([--with-dbusconfdir=PATH],
> > +  [path to D-Bus config directory]),
> > +  [path_dbusconf=$withval],
> > +  [path_dbusconf="`$PKG_CONFIG --variable=sysconfdir dbus-1`"])
> > +  AS_IF([test -z "$path_dbusconf"],
> > +    DBUS_CONFDIR="$sysconfdir/dbus-1/system.d",
> > +    DBUS_CONFDIR="$path_dbusconf/dbus-1/system.d")
> > +  AC_SUBST(DBUS_CONFDIR)
> > +])
> > +
> >  dnl libjpeg
> >  AC_ARG_WITH([jpeg],
> >    [AS_HELP_STRING([--without-jpeg],
> > @@ -617,6 +646,7 @@ AS_IF([test "x$enable_video" != "xyes"],
> >    [echo "        => zbarcam video scanner will *NOT* be built"])
> >  AS_IF([test "x$have_libv4l" != "xyes"],
> >    [echo "        => libv4l will *NOT* be used"])
> > +echo "dbus              --with-dbus=$with_dbus"
> >  echo "jpeg              --with-jpeg=$with_jpeg"
> >  AS_IF([test "x$with_jpeg" != "xyes"],
> >    [echo "        => JPEG image conversions will *NOT* be supported"])
> > diff --git a/dbus/org.linuxtv.Zbar.conf b/dbus/org.linuxtv.Zbar.conf
> > new file mode 100644
> > index 0000000..e0a5ea5
> > --- /dev/null
> > +++ b/dbus/org.linuxtv.Zbar.conf
> > @@ -0,0 +1,19 @@
> > +<!DOCTYPE busconfig PUBLIC
> > + "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
> > + "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
> > +<busconfig>
> > +
> > +    <policy user="root">
> > +        <allow own="org.linuxtv.Zbar"/>
> > +    </policy>
> > +
> > +    <policy context="default">
> > +        <allow send_destination="org.linuxtv.Zbar"/>
> > +        <allow send_destination="org.linuxtv.Zbar"
> > +               send_interface="org.linuxtv.ZbarCam1"/>
> > +        <allow send_destination="org.linuxtv.Zbar"
> > +               send_interface="org.freedesktop.DBus.Properties"/>
> > +        <allow send_destination="org.linuxtv.Zbar"
> > +               send_interface="org.freedesktop.DBus.Introspectable"/>
> > +    </policy>
> > +</busconfig>
> > diff --git a/zbarcam/Makefile.am.inc b/zbarcam/Makefile.am.inc
> > index 5aa788a..98199ee 100644
> > --- a/zbarcam/Makefile.am.inc
> > +++ b/zbarcam/Makefile.am.inc
> > @@ -4,6 +4,10 @@ zbarcam_zbarcam_LDADD = zbar/libzbar.la
> >  # automake bug in "monolithic mode"?
> >  CLEANFILES += zbarcam/.libs/zbarcam zbarcam/moc_zbarcam_qt.h
> >
> > +if HAVE_DBUS
> > +zbarcam_zbarcam_LDADD += $(DBUS_LIBS)
> > +endif
> > +
> >  if HAVE_GTK
> >  bin_PROGRAMS += zbarcam/zbarcam-gtk
> >  check_PROGRAMS += zbarcam/zbarcam-gtk
> > diff --git a/zbarcam/zbarcam.c b/zbarcam/zbarcam.c
> > index e0f3622..18b4fd1 100644
> > --- a/zbarcam/zbarcam.c
> > +++ b/zbarcam/zbarcam.c
> > @@ -33,6 +33,10 @@
> >
> >  #include <zbar.h>
> >
> > +#ifdef HAVE_DBUS
> > +#include <dbus/dbus.h>
> > +#endif
> > +
> >  #define BELL "\a"
> >
> >  static const char *note_usage =
> > @@ -92,6 +96,68 @@ static inline int parse_config (const char *cfgstr, int i, int n, char *arg)
> >      return(0);
> >  }
> >
> > +#ifdef HAVE_DBUS
> > +void send_dbus(const char* sigvalue)
> > +{
> > +    DBusMessage* msg;
> > +    DBusMessageIter args;
> > +    DBusConnection* conn;
> > +    DBusError err;
> > +    int ret;
> > +    dbus_uint32_t serial = 0;
> > +
> > +    // initialise the error value
> > +    dbus_error_init(&err);
> > +
> > +    // connect to the DBUS system bus, and check for errors
> > +    conn = dbus_bus_get(DBUS_BUS_SYSTEM, &err);
> > +    if (dbus_error_is_set(&err)) {
> > +        fprintf(stderr, "Connection Error (%s)\n", err.message);
> > +        dbus_error_free(&err);
> > +    }
> > +    if (NULL == conn) {
> > +        exit(1);
> > +    }
> > +
> > +    // register our name on the bus, and check for errors
> > +    ret = dbus_bus_request_name(conn, "org.linuxtv.Zbar", DBUS_NAME_FLAG_REPLACE_EXISTING , &err);
> > +    if (dbus_error_is_set(&err)) {
> > +        fprintf(stderr, "Name Error (%s)\n", err.message);
> > +        dbus_error_free(&err);
> > +    }
> > +    if (DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER != ret) {
> > +        exit(1);
> > +    }
> > +
> > +    // create a signal & check for errors
> > +    msg = dbus_message_new_signal("/org/linuxtv/ZbarCam1", // object name of the signal
> > +                                 "org.linuxtv.ZbarCam1", // interface name of the signal
> > +                                 "ZbarCam1"); // name of the signal
> > +    if (NULL == msg)
> > +    {
> > +        fprintf(stderr, "Message Null\n");
> > +        exit(1);
> > +    }
> > +
> > +    // append arguments onto signal
> > +    dbus_message_iter_init_append(msg, &args);
> > +    if (!dbus_message_iter_append_basic(&args, DBUS_TYPE_STRING, &sigvalue)) {
> > +        fprintf(stderr, "Out Of Memory!\n");
> > +        exit(1);
> > +    }
> > +
> > +    // send the message and flush the connection
> > +    if (!dbus_connection_send(conn, msg, &serial)) {
> > +        fprintf(stderr, "Out Of Memory!\n");
> > +        exit(1);
> > +    }
> > +    dbus_connection_flush(conn);
> > +
> > +    // free the message
> > +    dbus_message_unref(msg);
> > +}
> > +#endif
> > +
> >  static void data_handler (zbar_image_t *img, const void *userdata)
> >  {
> >      const zbar_symbol_t *sym = zbar_image_first_symbol(img);
> > @@ -105,6 +171,10 @@ static void data_handler (zbar_image_t *img, const void *userdata)
> >          if(type == ZBAR_PARTIAL)
> >              continue;
> >
> > +#ifdef HAVE_DBUS
> > +        send_dbus(zbar_symbol_get_data(sym));
> > +#endif
> > +
> >          if(!format) {
> >              printf("%s:", zbar_get_symbol_name(type));
> >              if(fwrite(zbar_symbol_get_data(sym),
>
>
>
> Thanks,
> Mauro
