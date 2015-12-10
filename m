Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34729 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751341AbbLJNV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 08:21:28 -0500
Date: Thu, 10 Dec 2015 15:21:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH 1/1] Allow building static binaries
Message-ID: <20151210132124.GK17128@valkosipuli.retiisi.org.uk>
References: <1449587901-12784-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1449587901-12784-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

I discussed with Hans and he thought you'd be the best person to take a look
at this.

The case is that I'd like to build static binaries and that doesn't seem to
work with what's in Makefile.am for libv4l1 and libv4l2 at the moment.

Thanks.

On Tue, Dec 08, 2015 at 05:18:21PM +0200, Sakari Ailus wrote:
> 	$ LDFLAGS="--static -static" ./configure --enable-static
> 	$ LDFLAGS=-static make
> 
> can be used to create static binaries. The issue was that shared libraries
> were attempted to link statically which naturally failed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  lib/libv4l1/Makefile.am | 3 +--
>  lib/libv4l2/Makefile.am | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/libv4l1/Makefile.am b/lib/libv4l1/Makefile.am
> index 005ae10..c325390 100644
> --- a/lib/libv4l1/Makefile.am
> +++ b/lib/libv4l1/Makefile.am
> @@ -23,7 +23,6 @@ libv4l1_la_LIBADD = ../libv4l2/libv4l2.la
>  v4l1compat_la_SOURCES = v4l1compat.c
>  
>  v4l1compat_la_LIBADD = libv4l1.la
> -v4l1compat_la_LDFLAGS = -avoid-version -module -shared -export-dynamic
> -v4l1compat_la_LIBTOOLFLAGS = --tag=disable-static
> +v4l1compat_la_LDFLAGS = -avoid-version -module -export-dynamic
>  
>  EXTRA_DIST = libv4l1-kernelcode-license.txt
> diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
> index b6f4d3b..878ccd9 100644
> --- a/lib/libv4l2/Makefile.am
> +++ b/lib/libv4l2/Makefile.am
> @@ -22,7 +22,6 @@ libv4l2_la_LIBADD = ../libv4lconvert/libv4lconvert.la
>  
>  v4l2convert_la_SOURCES = v4l2convert.c
>  v4l2convert_la_LIBADD = libv4l2.la
> -v4l2convert_la_LDFLAGS = -avoid-version -module -shared -export-dynamic
> -v4l2convert_la_LIBTOOLFLAGS = --tag=disable-static
> +v4l2convert_la_LDFLAGS = -avoid-version -module -export-dynamic
>  
>  EXTRA_DIST = Android.mk v4l2-plugin-android.c
> -- 
> 2.1.0.231.g7484e3b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
