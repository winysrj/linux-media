Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59524 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZKQOpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 09:45:47 -0500
From: "Y, Kishore" <kishore.y@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 17 Nov 2009 20:18:20 +0530
Subject: [RFC] [PATCH] V4L2: Allow rotation between stream off-on
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940254299E37@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is dependent on the patch
[PATCH 4/4] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2

>From cda5b97d02784318d89a029a2fde97903610d2b2 Mon Sep 17 00:00:00 2001
From: Kishore Y <kishore.y@ti.com>
Date: Wed, 11 Nov 2009 19:22:46 +0530
Subject: [PATCH] V4L2: Allow rotation between stream off-on

This patch configures vrfb buffers when streamon ioctl is called
in order to allow changing video rotation among streamoff/streamon
sequences without calling reqbuf ioctl

Signed-off-by: Kishore Y <kishore.y@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index c39c8a7..6118665 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1800,6 +1800,7 @@ static int vidioc_streamon(struct file *file, void *fh,
 	struct omap_vout_device *vout = fh;
 	struct videobuf_queue *q = &vout->vbq;
 	u32 addr = 0;
+	unsigned int count;
 	int r = 0;
 	int t;
 	struct omapvideo_info *ovid = &vout->vid_info;
@@ -1837,6 +1838,9 @@ static int vidioc_streamon(struct file *file, void *fh,
 
 	vout->first_int = 1;
 
+	count = vout->buffer_allocated;
+	omap_vout_vrfb_buffer_setup(vout, &count, 0);
+
 	if (omap_vout_calculate_offset(vout)) {
 		mutex_unlock(&vout->lock);
 		return -EINVAL;
-- 
1.5.4.3


Regards,
Kishore Y
Ph:- +918039813085

