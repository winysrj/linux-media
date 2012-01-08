Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57325 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab2AHXW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 18:22:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
Subject: Re: media_build failures on 3.0.6 Gentoo
Date: Mon, 9 Jan 2012 00:22:50 +0100
Cc: linux-media@vger.kernel.org
References: <4EF1BA0D.4070002@gmail.com>
In-Reply-To: <4EF1BA0D.4070002@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201201090022.51367.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fredrik,

On Wednesday 21 December 2011 11:50:53 Fredrik Lingvall wrote:
> Hi,
> 
> I get this build failure:

[snip]

>   LD [M]  /usr/src/media_build/v4l/m5mols.o
>    CC [M]  /usr/src/media_build/v4l/s5k6aa.o
>    CC [M]  /usr/src/media_build/v4l/adp1653.o
>    CC [M]  /usr/src/media_build/v4l/as3645a.o
> /usr/src/media_build/v4l/as3645a.c: In function 'as3645a_probe':
> /usr/src/media_build/v4l/as3645a.c:815:2: error: implicit declaration of
> function 'kzalloc'
> /usr/src/media_build/v4l/as3645a.c:815:8: warning: assignment makes
> pointer from integer without a cast
> make[3]: *** [/usr/src/media_build/v4l/as3645a.o] Error 1
> make[2]: *** [_module_/usr/src/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-3.0.6-gentoo'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/usr/src/media_build/v4l'
> make: *** [all] Error 2
> build failed at ./build line 380.
> lin-tv media_build #

Could you please test this patch ?

>From c7ecae9b57cb29eaa134943d086fb0d83865514e Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Mon, 9 Jan 2012 00:18:19 +0100
Subject: [PATCH] as3645a: Fix compilation by including slab.h

The as3645a driver calls kzalloc(). Include slab.h.

Reported-by: Fredrik Lingvall <fredrik.lingvall@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/as3645a.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index ec859a5..f241702 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -29,6 +29,7 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <media/as3645a.h>
 #include <media/v4l2-ctrls.h>
-- 
Regards,

Laurent Pinchart
