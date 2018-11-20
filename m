Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55366 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbeKTUl1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:41:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.20] gspca: fix frame overflow error
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: softwarebugs <softwarebugs@protonmail.com>
Message-ID: <9c1c14cf-61e2-e289-2bb4-e9940462fb55@xs4all.nl>
Date: Tue, 20 Nov 2018 11:13:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When converting gspca to vb2 I missed that fact that the buffer sizes
were rounded up to the next page size. As a result some gspca drivers
(spca561 being one of them) reported frame overflows.

Modify the code to align the buffer sizes to the next page size, just
as the original code did.

Fixes: 1f5965c4dfd7 ("media: gspca: convert to vb2")
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: softwarebugs <softwarebugs@protonmail.com>
Cc: <stable@vger.kernel.org>      # for v4.18 and up
---
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index fce9d6f4b7c9..3137f5d89d80 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -426,10 +426,10 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,

 	/* append the packet to the frame buffer */
 	if (len > 0) {
-		if (gspca_dev->image_len + len > gspca_dev->pixfmt.sizeimage) {
+		if (gspca_dev->image_len + len > PAGE_ALIGN(gspca_dev->pixfmt.sizeimage)) {
 			gspca_err(gspca_dev, "frame overflow %d > %d\n",
 				  gspca_dev->image_len + len,
-				  gspca_dev->pixfmt.sizeimage);
+				  PAGE_ALIGN(gspca_dev->pixfmt.sizeimage));
 			packet_type = DISCARD_PACKET;
 		} else {
 /* !! image is NULL only when last pkt is LAST or DISCARD
@@ -1297,18 +1297,19 @@ static int gspca_queue_setup(struct vb2_queue *vq,
 			     unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vq);
+	unsigned int size = PAGE_ALIGN(gspca_dev->pixfmt.sizeimage);

 	if (*nplanes)
-		return sizes[0] < gspca_dev->pixfmt.sizeimage ? -EINVAL : 0;
+		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
-	sizes[0] = gspca_dev->pixfmt.sizeimage;
+	sizes[0] = size;
 	return 0;
 }

 static int gspca_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vb->vb2_queue);
-	unsigned long size = gspca_dev->pixfmt.sizeimage;
+	unsigned long size = PAGE_ALIGN(gspca_dev->pixfmt.sizeimage);

 	if (vb2_plane_size(vb, 0) < size) {
 		gspca_err(gspca_dev, "buffer too small (%lu < %lu)\n",
