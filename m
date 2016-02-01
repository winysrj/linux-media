Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39269 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbcBAM74 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 07:59:56 -0500
Date: Mon, 1 Feb 2016 10:59:45 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH 1/2] v4l: libv4l1, libv4l2: Use $(mkdir_p)
 instead of deprecated $(MKDIR_P)
Message-ID: <20160201105945.20dd5087@recife.lan>
In-Reply-To: <1453725684-4561-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1453725684-4561-1-git-send-email-sakari.ailus@linux.intel.com>
	<1453725684-4561-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Jan 2016 14:41:23 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> autoconf thinks $(MKDIR_P) is deprecated. Use $(mkdir_p) instead.

Did you get any troubles with the deprecated macro?

At least here (version 2.69), I don't see any error by using $(MKDIR_P).

Regards,
Mauro

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  lib/libv4l1/Makefile.am | 2 +-
>  lib/libv4l2/Makefile.am | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/libv4l1/Makefile.am b/lib/libv4l1/Makefile.am
> index 005ae10..f768eaa 100644
> --- a/lib/libv4l1/Makefile.am
> +++ b/lib/libv4l1/Makefile.am
> @@ -7,7 +7,7 @@ if WITH_V4L_WRAPPERS
>  libv4l1priv_LTLIBRARIES = v4l1compat.la
>  
>  install-exec-hook:
> -	$(MKDIR_P) $(DESTDIR)/$(libdir)
> +	$(mkdir_p) $(DESTDIR)/$(libdir)
>  	(cd $(DESTDIR)/$(libdir) && rm -f v4l1compat.so && $(LN_S) $(libv4l1subdir)/v4l1compat.so v4l1compat.so)
>  
>  endif
> diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
> index b6f4d3b..1314a99 100644
> --- a/lib/libv4l2/Makefile.am
> +++ b/lib/libv4l2/Makefile.am
> @@ -7,7 +7,7 @@ if WITH_V4L_WRAPPERS
>  libv4l2priv_LTLIBRARIES = v4l2convert.la
>  
>  install-exec-hook:
> -	$(MKDIR_P) $(DESTDIR)/$(libdir)
> +	$(mkdir_p) $(DESTDIR)/$(libdir)
>  	(cd $(DESTDIR)/$(libdir) && rm -f v4l2convert.so && $(LN_S) $(libv4l2subdir)/v4l2convert.so v4l2convert.so)
>  
>  endif
