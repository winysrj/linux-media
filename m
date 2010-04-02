Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f217.google.com ([209.85.218.217]:34917 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab0DBLgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 07:36:25 -0400
Date: Fri, 2 Apr 2010 14:30:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] cx231xx: improve error handling
Message-ID: <20100402113010.GK5265@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return -EINVAL if we don't find the control id.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index d4f546f..5a74ef8 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -1901,9 +1901,12 @@ static int radio_queryctrl(struct file *file, void *priv,
 	if (c->id < V4L2_CID_BASE || c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
 	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		for (i = 0; i < CX231XX_CTLS; i++)
+		for (i = 0; i < CX231XX_CTLS; i++) {
 			if (cx231xx_ctls[i].v.id == c->id)
 				break;
+		}
+		if (i == CX231XX_CTLS)
+			return -EINVAL;
 		*c = cx231xx_ctls[i].v;
 	} else
 		*c = no_ctl;
