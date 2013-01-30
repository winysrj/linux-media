Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3269 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3A3R46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:56:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/3] bw-qcam: zero priv field.
Date: Wed, 30 Jan 2013 18:56:42 +0100
Message-Id: <08f9f5df663bb92eec55c1a5bcfb26c820c2ed8a.1359568453.git.hans.verkuil@cisco.com>
In-Reply-To: <1359568604-27876-1-git-send-email-hverkuil@xs4all.nl>
References: <1359568604-27876-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix a v4l2-compliance problem: the priv field of v4l2_pix_format must be
cleared by drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/parport/bw-qcam.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index 5b75a64..497b342 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -693,6 +693,7 @@ static int qcam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	pix->sizeimage = pix->width * pix->height;
 	/* Just a guess */
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	pix->priv = 0;
 	return 0;
 }
 
@@ -718,6 +719,7 @@ static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format
 	pix->sizeimage = pix->width * pix->height;
 	/* Just a guess */
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	pix->priv = 0;
 	return 0;
 }
 
-- 
1.7.10.4

