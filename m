Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55009 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750915AbZBEXV3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2009 18:21:29 -0500
Date: Fri, 6 Feb 2009 00:21:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] sh_mobile_ceu_camera: NV12/21/16/61 are added only once.
In-Reply-To: <aec7e5c30901222024k3600b6b6t718998b945461a40@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0902060012000.12903@axis700.grange>
References: <ur62u4qh5.wl%morimoto.kuninori@renesas.com>
 <aec7e5c30901222024k3600b6b6t718998b945461a40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Fri, 23 Jan 2009, Magnus Damm wrote:

> On Fri, Jan 23, 2009 at 9:28 AM, Kuninori Morimoto
> <morimoto.kuninori@renesas.com> wrote:
> > NV12/21/16/61 had been added every time
> > UYVY/VYUY/YUYV/YVYU appears on get_formats.
> > This patch modify this problem.
> 
> That's one way to do it. Every similar driver has to do the same thing. Yuck.
> 
> Or we could have a better translation framework that does OR for us,
> using for instance bitmaps.

This has been on my list for a while now, but I'm quite busy these days, 
but I think I now have an idea how to fix this problem in a less 
destructive way, withoug undermining the soc-camera algorithms:-) Please, 
have a look at the patch below. Does it fix the problem for you? If not - 
how can we modify it to work for you? Notice - not even completely compile 
tested:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer


Fix multiple inclusion of NV* formats into the available format list.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index a53f5bb..b8234c7 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -585,11 +585,29 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 	if (ret < 0)
 		return 0;
 
+	/* Beginning of a pass */
+	if (!idx)
+		icd->host_priv = NULL;
+
 	switch (icd->formats[idx].fourcc) {
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_VYUY:
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_YVYU:
+		if (icd->host_priv)
+			goto add_single_format;
+
+		/*
+		 * Our case is simple so far: for any of the above four camera
+		 * formats we add all our four synthesized NV* formats, so,
+		 * just marking the device with a single flag suffices. If
+		 * the format generation rules are more complex, you would have
+		 * to actually hang your already added / counted formats onto
+		 * the host_priv pointer and check whether the format you're
+		 * going to add now is already there.
+		 */
+		icd->host_priv = (void *)sh_mobile_ceu_formats;
+
 		n = ARRAY_SIZE(sh_mobile_ceu_formats);
 		formats += n;
 		for (k = 0; xlate && k < n; k++) {
@@ -602,6 +620,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 				icd->formats[idx].name);
 		}
 	default:
+add_single_format:
 		/* Generic pass-through */
 		formats++;
 		if (xlate) {
