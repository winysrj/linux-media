Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:62827 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdITQ7H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 12:59:07 -0400
Subject: [PATCH 2/5] [media] s2255drv: Adjust 13 checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Message-ID: <66f0b95e-e717-7a50-39d2-05fcbf7b77bd@users.sourceforge.net>
Date: Wed, 20 Sep 2017 18:58:56 +0200
MIME-Version: 1.0
In-Reply-To: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 16:46:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/s2255/s2255drv.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 29285e8cd742..aee83bf6fa94 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -516,6 +516,6 @@ static void s2255_fwchunk_complete(struct urb *urb)
 		wake_up(&data->wait_fw);
 		return;
 	}
-	if (data->fw_urb == NULL) {
+	if (!data->fw_urb) {
 		s2255_dev_err(&udev->dev, "disconnected\n");
 		atomic_set(&data->fw_state, S2255_FW_FAILED);
@@ -680,5 +680,5 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	dprintk(vc->dev, 4, "%s\n", __func__);
-	if (vc->fmt == NULL)
+	if (!vc->fmt)
 		return -EINVAL;
 
 	if ((w < norm_minw(vc)) ||
@@ -785,6 +785,5 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-
-	if (fmt == NULL)
+	if (!fmt)
 		return -EINVAL;
 
 	field = f->fmt.pix.field;
@@ -853,6 +852,5 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-
-	if (fmt == NULL)
+	if (!fmt)
 		return -EINVAL;
 
 	if (vb2_is_busy(q)) {
@@ -936,6 +934,6 @@ static u32 get_transfer_size(struct s2255_mode *mode)
 	unsigned int mask_mult;
 
-	if (mode == NULL)
+	if (!mode)
 		return 0;
 
 	if (mode->format == FORMAT_NTSC) {
@@ -1390,4 +1388,4 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 	fmt = format_by_fourcc(fe->pixel_format);
-	if (fmt == NULL)
+	if (!fmt)
 		return -EINVAL;
 	fe->type = V4L2_FRMSIZE_TYPE_DISCRETE;
@@ -1412,5 +1410,5 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 	fmt = format_by_fourcc(fe->pixel_format);
-	if (fmt == NULL)
+	if (!fmt)
 		return -EINVAL;
 
 	sizes = is_ntsc ? ntsc_sizes : pal_sizes;
@@ -1834,6 +1832,5 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 	psrc = (u8 *)pipe_info->transfer_buffer + offset;
 
-
-	if (frm->lpvbits == NULL) {
+	if (!frm->lpvbits) {
 		dprintk(dev, 1, "s2255 frame buffer == NULL.%p %p %d %d",
 			frm, dev, dev->cc, idx);
@@ -1965,6 +1962,6 @@ static int s2255_create_sys_buffers(struct s2255_vc *vc)
 		vc->buffer.frame[i].lpvbits = vmalloc(reqsize);
 		vc->buffer.frame[i].size = reqsize;
-		if (vc->buffer.frame[i].lpvbits == NULL) {
+		if (!vc->buffer.frame[i].lpvbits) {
 			pr_info("out of memory.  using less frames\n");
 			vc->buffer.dwFrames = i;
 			break;
@@ -2007,6 +2004,6 @@ static int s2255_board_init(struct s2255_dev *dev)
 	pipe->transfer_buffer = kzalloc(pipe->max_transfer_size,
 					GFP_KERNEL);
-	if (pipe->transfer_buffer == NULL) {
+	if (!pipe->transfer_buffer) {
 		dprintk(dev, 1, "out of memory!\n");
 		return -ENOMEM;
 	}
@@ -2068,8 +2065,8 @@ static void read_pipe_completion(struct urb *purb)
 	pipe_info = purb->context;
-	if (pipe_info == NULL) {
+	if (!pipe_info) {
 		dev_err(&purb->dev->dev, "no context!\n");
 		return;
 	}
 	dev = pipe_info->dev;
-	if (dev == NULL) {
+	if (!dev) {
 		dev_err(&purb->dev->dev, "no context!\n");
@@ -2257,5 +2254,5 @@ static int s2255_probe(struct usb_interface *interface,
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	if (dev->udev == NULL) {
+	if (!dev->udev) {
 		dev_err(&interface->dev, "null usb device\n");
 		retval = -ENODEV;
 		goto errorUDEV;
-- 
2.14.1
