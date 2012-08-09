Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38418 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2HIHW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 03:22:26 -0400
Received: by bkwj10 with SMTP id j10so40877bkw.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 00:22:24 -0700 (PDT)
Message-ID: <5023652D.4010508@googlemail.com>
Date: Thu, 09 Aug 2012 09:22:21 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] Add libv4l2rds library (with changes proposed
 in RFC)
References: <[RFC PATCH 0/2] Add support for RDS decoding> <1344352315-1184-1-git-send-email-kradlow@cisco.com> <bce8b8118e9a8bcc7fd528d8b8d1a0732a9c8954.1344352285.git.kradlow@cisco.com>
In-Reply-To: <bce8b8118e9a8bcc7fd528d8b8d1a0732a9c8954.1344352285.git.kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Konke,

On 8/7/12 5:11 PM, Konke Radlow wrote:
> diff --git a/configure.ac b/configure.ac
> index 8ddcc9d..1109c4d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -146,9 +148,12 @@ AC_ARG_WITH(libv4l2subdir, AS_HELP_STRING(--with-libv4l2subdir=DIR,set libv4l2 l
>   AC_ARG_WITH(libv4lconvertsubdir, AS_HELP_STRING(--with-libv4lconvertsubdir=DIR,set libv4lconvert library subdir [default=libv4l]),
>      libv4lconvertsubdir=$withval, libv4lconvertsubdir="libv4l")
>
> +AC_ARG_WITH(libv4l2rdssubdir, AS_HELP_STRING(--with-libv4l2rdssubdir=DIR,set libv4l2rds library subdir [default=libv4l]),
> +   libv4l2rdssubdir=$withval, libv4l2rdssubdir="libv4l")
> +
>   AC_ARG_WITH(udevdir, AS_HELP_STRING(--with-udevdir=DIR,set udev directory [default=/lib/udev]),
>      udevdir=$withval, udevdir="/lib/udev")
> -
> +
>   libv4l1privdir="$libdir/$libv4l1subdir"
>   libv4l2privdir="$libdir/$libv4l2subdir"
>   libv4l2plugindir="$libv4l2privdir/plugins"

please remove these changes. They are not needed for the RDS library.

Thanks,
Gregor
