Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43630 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2GZSqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 14:46:24 -0400
Received: by bkwj10 with SMTP id j10so1461275bkw.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 11:46:23 -0700 (PDT)
Message-ID: <5011907A.7010505@googlemail.com>
Date: Thu, 26 Jul 2012 20:46:18 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	hdegoede@redhat.com
Subject: Re: [RFC PATCH 1/2] Initial version of the RDS-decoder library Signed-off-by:
 Konke Radlow <kradlow@cisco.com>
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com> <d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com>
In-Reply-To: <d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/25/12 7:44 PM, Konke Radlow wrote:
> diff --git a/configure.ac b/configure.ac
> index 8ddcc9d..1d7eb29 100644
> --- a/configure.ac
> +++ b/configure.ac
...
> @@ -146,13 +148,17 @@ AC_ARG_WITH(libv4l2subdir, AS_HELP_STRING(--with-libv4l2subdir=DIR,set libv4l2 l
>  AC_ARG_WITH(libv4lconvertsubdir, AS_HELP_STRING(--with-libv4lconvertsubdir=DIR,set libv4lconvert library subdir [default=libv4l]),
>     libv4lconvertsubdir=$withval, libv4lconvertsubdir="libv4l")
>  
> +AC_ARG_WITH(libv4l2rdssubdir, AS_HELP_STRING(--with-libv4l2rdssubdir=DIR,set libv4l2rds library subdir [default=libv4l]),
> +   libv4l2rdssubdir=$withval, libv4l2rdssubdir="libv4l")
> +
>  AC_ARG_WITH(udevdir, AS_HELP_STRING(--with-udevdir=DIR,set udev directory [default=/lib/udev]),
>     udevdir=$withval, udevdir="/lib/udev")
> -
> +   
>  libv4l1privdir="$libdir/$libv4l1subdir"
>  libv4l2privdir="$libdir/$libv4l2subdir"
>  libv4l2plugindir="$libv4l2privdir/plugins"
>  libv4lconvertprivdir="$libdir/$libv4lconvertsubdir"
> +libv4l2rdsprivdir="$libdir/$libv4l2rdssubdir"
>  
>  keytablesystemdir="$udevdir/rc_keymaps"
>  keytableuserdir="$sysconfdir/rc_keymaps"
> @@ -166,6 +172,7 @@ AC_SUBST(libv4lconvertprivdir)
>  AC_SUBST(keytablesystemdir)
>  AC_SUBST(keytableuserdir)
>  AC_SUBST(udevrulesdir)
> +AC_SUBST(libv4l2rdsprivdir)
>  AC_SUBST(pkgconfigdir)
>  
>  AC_DEFINE_UNQUOTED([V4L_UTILS_VERSION], ["$PACKAGE_VERSION"], [v4l-utils version string])
> @@ -173,6 +180,7 @@ AC_DEFINE_DIR([LIBV4L1_PRIV_DIR], [libv4l1privdir], [libv4l1 private lib directo
>  AC_DEFINE_DIR([LIBV4L2_PRIV_DIR], [libv4l2privdir], [libv4l2 private lib directory])
>  AC_DEFINE_DIR([LIBV4L2_PLUGIN_DIR], [libv4l2plugindir], [libv4l2 plugin directory])
>  AC_DEFINE_DIR([LIBV4LCONVERT_PRIV_DIR], [libv4lconvertprivdir], [libv4lconvert private lib directory])
> +AC_DEFINE_DIR([LIBV4L2RDS_PRIV_DIR], [libv4l2rdsprivdir], [libv4l2rds private lib directory])
>  AC_DEFINE_DIR([IR_KEYTABLE_SYSTEM_DIR], [keytablesystemdir], [ir-keytable preinstalled tables directory])
>  AC_DEFINE_DIR([IR_KEYTABLE_USER_DIR], [keytableuserdir], [ir-keytable user defined tables directory])
>  

I don't think you need these changes. In libv4l these are for the
wrapper libraries. You don't have one.

Thanks,
Gregor
