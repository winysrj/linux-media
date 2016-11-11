Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39741 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750877AbcKKKdL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 05:33:11 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cobalt: fix copy-and-paste error
Message-ID: <ba0d8aa1-7afb-6569-7c6e-5c7ffa6c94a1@xs4all.nl>
Date: Fri, 11 Nov 2016 11:33:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vmr_stat variable was filled with the contents of the control register,
not the status register. Classic copy-and-paste error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 5c76637..f900f9f 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -527,7 +527,7 @@ static void cobalt_video_input_status_show(struct cobalt_stream *s)
 	cvi_ctrl = ioread32(&cvi->control);
 	cvi_stat = ioread32(&cvi->status);
 	vmr_ctrl = ioread32(&vmr->control);
-	vmr_stat = ioread32(&vmr->control);
+	vmr_stat = ioread32(&vmr->status);
 	cobalt_info("rx%d: cvi resolution: %dx%d\n", rx,
 		    ioread32(&cvi->frame_width), ioread32(&cvi->frame_height));
 	cobalt_info("rx%d: cvi control: %s%s%s\n", rx,
