Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2341 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966090Ab3E2OTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/14] zoran: remove bogus autodetect mode in set_norm
Date: Wed, 29 May 2013 16:19:03 +0200
Message-Id: <1369837147-8747-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Currently, if the norm set is V4L2_STD_ALL, then autodetect the current
standard and use that. This is non-standard behavior, and in fact it hasn't
worked for a very long time: before s_std is called in this driver, the
v4l2 core will mask it with the tvnorms field. So even if the application
passes V4L2_STD_ALL, the zoran driver will always see a subset of that.

Since nobody ever complained about this we just remove this non-standard
functionality.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran_driver.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 1168a84..4ec2708 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1456,29 +1456,6 @@ zoran_set_norm (struct zoran *zr,
 		return -EINVAL;
 	}
 
-	if (norm == V4L2_STD_ALL) {
-		unsigned int status = 0;
-		v4l2_std_id std = 0;
-
-		decoder_call(zr, video, querystd, &std);
-		decoder_call(zr, core, s_std, std);
-
-		/* let changes come into effect */
-		ssleep(2);
-
-		decoder_call(zr, video, g_input_status, &status);
-		if (status & V4L2_IN_ST_NO_SIGNAL) {
-			dprintk(1,
-				KERN_ERR
-				"%s: %s - no norm detected\n",
-				ZR_DEVNAME(zr), __func__);
-			/* reset norm */
-			decoder_call(zr, core, s_std, zr->norm);
-			return -EIO;
-		}
-
-		norm = std;
-	}
 	if (norm & V4L2_STD_SECAM)
 		zr->timing = zr->card.tvn[2];
 	else if (norm & V4L2_STD_NTSC)
-- 
1.7.10.4

