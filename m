Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005Ab0D0VXb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:23:31 -0400
Message-Id: <201004272111.o3RLBSEX020011@imap1.linux-foundation.org>
Subject: [patch 11/11] cx231xx: improve error handling
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	error27@gmail.com, dougsland@redhat.com,
	laurent.pinchart@ideasonboard.com, xyzzy@speakeasy.org
From: akpm@linux-foundation.org
Date: Tue, 27 Apr 2010 14:11:27 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>

Return -EINVAL if we don't find the control id.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Douglas Schilling Landgraf <dougsland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx231xx/cx231xx-video.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/cx231xx/cx231xx-video.c~cx231xx-improve-error-handling drivers/media/video/cx231xx/cx231xx-video.c
--- a/drivers/media/video/cx231xx/cx231xx-video.c~cx231xx-improve-error-handling
+++ a/drivers/media/video/cx231xx/cx231xx-video.c
@@ -1902,9 +1902,12 @@ static int radio_queryctrl(struct file *
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
_
