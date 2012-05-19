Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2ESXQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 19:16:58 -0400
Date: Sun, 20 May 2012 01:16:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>,
	Magnus <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: [PATCH] V4L: sh-mobile-ceu-camera: restore the bus-width test
In-Reply-To: <87d36yezag.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1205200044490.12577@axis700.grange>
References: <87ehrf9fjo.wl%kuninori.morimoto.gx@renesas.com>
 <Pine.LNX.4.64.1204231325300.19312@axis700.grange>
 <87d36yezag.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An earlier commit "[media] V4L: sh_mobile_ceu_camera: convert to the new 
mbus-config subdev operations" has inadvertantly removed the check in the 
sh-mobile-ceu-camera driver, whether a specific bus-width is supported. 
This patch restores the check for formats, requiring wider than 8-bit 
video bus. The other check from the above commit - whether 8-bits per 
sample are supported - is, however, not restored. All currently known set 
ups support 8 bits per sample, hence, this check so far seems redundant. 
The respective SH_CEU_FLAG_USE_8BIT_BUS flag will be kept for now, but may 
be removed in the future.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

On Mon, 23 Apr 2012, Kuninori Morimoto wrote:

> 
> Hi Guennadi
> 
> Thanks for reply.
> 
> > AFAICS, all these platforms only use 8 bits, so, none of them is broken. 
> > OTOH, I'm not sure any more, what was the motivation behind that removal. 
> > Maybe exactly because we didn't have any platforms with 16-bit camera 
> > connections and maybe I saw a problem with it, so, I decided to remove 
> > them until we get a chance to properly implement and test 16-bits? Do you 
> > have such a board?
> 
> about 16bit camera, one guy has it, but he is using v3.0 kernel,
> so, it is not in trouble at this point.
> (it is working)
> 
> The motivation was just "misunderstand-able", not super important at this point.
> So please keep considering about it.

Would be nice if the below patch could be tested with a 16-bit set up. But 
it should be tested "negatively." This means: I think, also now 16-bit set 
ups work. The only problem is, that even if your board only connects 8 
data lines, an attempt to set a 16-bit format wouldn't fail and would, 
probably, deliver corrupt data. So, the test would be:
- take a 16-bit set up and choose a 16-bit format - it should work
- remove the 16-bit flag from the platform data - it would, presumably, 
  still work, which is a bug
- apply the patch
- now verify that 16-bits formats can only be used, if the board specifies 
  the respective flag in platform data

Thanks
Guennadi

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 424dfac..3e7b794 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -951,7 +951,8 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
 	else if (ret != -ENOIOCTLCMD)
 		return ret;
 
-	if (!common_flags || buswidth > 16)
+	if (!common_flags || buswidth > 16 ||
+	    (buswidth > 8 && !(pcdev->pdata->flags & SH_CEU_FLAG_USE_16BIT_BUS)))
 		return -EINVAL;
 
 	return 0;
