Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50514 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933623AbbDXH0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 03:26:31 -0400
Message-ID: <5539F009.9060505@xs4all.nl>
Date: Fri, 24 Apr 2015 09:26:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Federico Simoncelli <fsimonce@redhat.com>,
	Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] usbtv: fix v4l2-compliance issues
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Running v4l2-compliance on my usbtv stick revealed two failures:

1) Correct handling of CREATE_BUFS in usbtv_queue_setup was missing. Added this.
2) The sequence counter wasn't reset to 0 when starting streaming.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 9d3525f..08fb0f2 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -599,15 +599,18 @@ static struct v4l2_file_operations usbtv_fops = {
 };
 
 static int usbtv_queue_setup(struct vb2_queue *vq,
-	const struct v4l2_format *v4l_fmt, unsigned int *nbuffers,
+	const struct v4l2_format *fmt, unsigned int *nbuffers,
 	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
+	unsigned size = USBTV_CHUNK * usbtv->n_chunks * 2 * sizeof(u32);
 
-	if (*nbuffers < 2)
-		*nbuffers = 2;
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
 	*nplanes = 1;
-	sizes[0] = USBTV_CHUNK * usbtv->n_chunks * 2 * sizeof(u32);
+	if (fmt && fmt->fmt.pix.sizeimage < size)
+		return -EINVAL;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
 
 	return 0;
 }
@@ -635,6 +638,7 @@ static int usbtv_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (usbtv->udev == NULL)
 		return -ENODEV;
 
+	usbtv->sequence = 0;
 	return usbtv_start(usbtv);
 }
 
