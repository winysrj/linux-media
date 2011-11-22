Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3215 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1KVMDf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 07:03:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ian Armstrong <mail01@iarmst.co.uk>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Archit Taneja <archit@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [RFCv2 PATCH 3/3] omap_vout: add missing OVERLAY_OUTPUT cap and set V4L2_FBUF_FLAG_OVERLAY
Date: Tue, 22 Nov 2011 13:03:22 +0100
Message-Id: <02961843cbfd0aac821861157893b3be6aeef365.1321963291.git.hans.verkuil@cisco.com>
In-Reply-To: <1321963402-1259-1-git-send-email-hverkuil@xs4all.nl>
References: <1321963402-1259-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <22fb81ba5ba878d10fe996d5421f983dd34a1988.1321963291.git.hans.verkuil@cisco.com>
References: <22fb81ba5ba878d10fe996d5421f983dd34a1988.1321963291.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The omap_vout driver has an output overlay, but never advertised that
capability.

The driver should also set the V4L2_FBUF_FLAG_OVERLAY flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
CC: Archit Taneja <archit@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index def6472..632f38e 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1045,7 +1045,8 @@ static int vidioc_querycap(struct file *file, void *fh,
 	strlcpy(cap->driver, VOUT_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, vout->vfd->name, sizeof(cap->card));
 	cap->bus_info[0] = '\0';
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT |
+		V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
 
 	return 0;
 }
@@ -1827,7 +1828,9 @@ static int vidioc_g_fbuf(struct file *file, void *fh,
 	ovid = &vout->vid_info;
 	ovl = ovid->overlays[0];
 
-	a->flags = 0x0;
+	/* The video overlay must stay within the framebuffer and can't be
+	   positioned independently. */
+	a->flags = V4L2_FBUF_FLAG_OVERLAY;
 	a->capability = V4L2_FBUF_CAP_LOCAL_ALPHA | V4L2_FBUF_CAP_CHROMAKEY
 		| V4L2_FBUF_CAP_SRC_CHROMAKEY;
 
-- 
1.7.7.3

