Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52200 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378Ab2COPDn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 11:03:43 -0400
Received: by eaaq12 with SMTP id q12so1609840eaa.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 08:03:42 -0700 (PDT)
Message-ID: <4F6204CB.5000505@gmail.com>
Date: Thu, 15 Mar 2012 16:03:39 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] Support for tuner FC0012
References: <201202222321.35533.hfvogt@gmx.net> <4F61FE49.6010704@gmail.com>
In-Reply-To: <4F61FE49.6010704@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 15/03/2012 15:35, poma ha scritto:

> Patched git://linuxtv.org/media_build.git with your Fitipower FC0012
> tuner driver(fc0012.patch) got here:
> ..
>   CC [M]  /tmp/media_build/v4l/fc0012.o
> /tmp/media_build/v4l/tda18212.c:21:0: warning: "pr_fmt" redefined
> [enabled by default]
> include/linux/printk.h:152:0: note: this is the location of the previous
> definition
> /tmp/media_build/v4l/fc0012.c:146:16: warning: 'struct
> dvb_frontend_parameters' declared inside parameter list [enabled by default]
> /tmp/media_build/v4l/fc0012.c:146:16: warning: its scope is only this
> definition or declaration, which is probably not what you want [enabled
> by default]
> /tmp/media_build/v4l/fc0012.c: In function 'fc0012_set_params':
> /tmp/media_build/v4l/fc0012.c:156:19: error: dereferencing pointer to
> incomplete type
> /tmp/media_build/v4l/fc0012.c:279:17: error: dereferencing pointer to
> incomplete type
> /tmp/media_build/v4l/fc0012.c:280:8: error: 'BANDWIDTH_6_MHZ' undeclared
> (first use in this function)
> /tmp/media_build/v4l/fc0012.c:280:8: note: each undeclared identifier is
> reported only once for each function it appears in
> /tmp/media_build/v4l/fc0012.c:284:8: error: 'BANDWIDTH_7_MHZ' undeclared
> (first use in this function)
> /tmp/media_build/v4l/fc0012.c:288:8: error: 'BANDWIDTH_8_MHZ' undeclared
> (first use in this function)
> /tmp/media_build/v4l/fc0012.c: At top level:
> /tmp/media_build/v4l/fc0012.c:393:9: warning: initialization from
> incompatible pointer type [enabled by default]
> /tmp/media_build/v4l/fc0012.c:393:9: warning: (near initialization for
> 'fc0012_tuner_ops.set_params') [enabled by default]
> make[3]: *** [/tmp/media_build/v4l/fc0012.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [_module_/tmp/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernels/3.2.9-2.fc16.x86_64'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/tmp/media_build/v4l'
> make: *** [all] Error 2
> 
> rgds,
> poma

Hi poma,
this is due to the fact that you are using a 3.2 kernel together with
the current media_build tree. You should use a 3.3 kernel, otherwise the
directives like:

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0))
....
#else
....
#endif

will select the wrong code path (current media_build trees need the same
code path of the 3.3 kernel).

Another solution (very ugly) is to replace the lines like the one above
with something like this:

#ifdef V4L2_DVB_V5
....
#else
....
#endif

where V4L2_DVB_V5 is defined like this (for example, in af903x-fe.h):

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)) || ((defined
V4L2_VERSION) && (V4L2_VERSION >= 197120))
#define V4L2_DVB_V5
#endif

This will make the code compile with all kernels supported by the
media_build tree (>= 2.6.31).

The same applies for

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0))
....
#else
....
#endif

that should be replaced with

#ifdef V4L2_REFACTORED_MFE_CODE
....
#else
....
#endif

where V4L2_REFACTORED_MFE_CODE is defined this way:

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)) || ((defined
V4L2_VERSION) && (V4L2_VERSION >= 196608))
#define V4L2_REFACTORED_MFE_CODE
#endif

Probably there are cleaver solutions that I could not figure out.
If you want to test the driver, I can share with you the modified patches.

Regards,
Gianluca
