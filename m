Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:49245 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755428AbdIRNz3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 09:55:29 -0400
Subject: [PATCH 2/6] [media] go7007: Adjust 35 checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Message-ID: <df876d0b-45f7-7213-6b1f-870a550d1e0c@users.sourceforge.net>
Date: Mon, 18 Sep 2017 15:55:21 +0200
MIME-Version: 1.0
In-Reply-To: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 11:13:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/go7007/go7007-driver.c | 10 +++++-----
 drivers/media/usb/go7007/go7007-fw.c     |  8 ++++----
 drivers/media/usb/go7007/go7007-loader.c |  4 ++--
 drivers/media/usb/go7007/go7007-usb.c    | 18 +++++++++---------
 drivers/media/usb/go7007/go7007-v4l2.c   |  6 +++---
 drivers/media/usb/go7007/s2250-board.c   | 20 +++++++++-----------
 drivers/media/usb/go7007/snd-go7007.c    |  6 +++---
 7 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 222332189fa4..390f66ec8fd2 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -91,6 +91,6 @@ static int go7007_load_encoder(struct go7007 *go)
 	int fw_len, rv = 0;
 	u16 intr_val, intr_data;
 
-	if (go->boot_fw == NULL) {
+	if (!go->boot_fw) {
 		if (request_firmware(&fw_entry, fw_name, go->dev)) {
 			v4l2_err(go, "unable to load firmware from file \"%s\"\n", fw_name);
@@ -103,5 +103,5 @@ static int go7007_load_encoder(struct go7007 *go)
 		}
 		fw_len = fw_entry->size - 16;
 		bounce = kmemdup(fw_entry->data + 16, fw_len, GFP_KERNEL);
-		if (bounce == NULL) {
+		if (!bounce) {
 			release_firmware(fw_entry);
@@ -448,7 +448,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 	u32 *bytesused;
 	struct go7007_buffer *vb_tmp = NULL;
 
-	if (vb == NULL) {
+	if (!vb) {
 		spin_lock(&go->spinlock);
 		if (!list_empty(&go->vidq_active))
 			vb = go->active_buf =
@@ -598,7 +598,7 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 			    (buf[i] == seq_start_code ||
 			     buf[i] == gop_start_code ||
 			     buf[i] == frame_start_code)) {
-				if (vb == NULL || go->seen_frame)
+				if (!vb || go->seen_frame)
 					vb = frame_boundary(go, vb);
 				go->seen_frame = buf[i] == frame_start_code;
 				if (vb && go->seen_frame)
@@ -703,4 +703,4 @@ struct go7007 *go7007_alloc(const struct go7007_board_info *board,
-	if (go == NULL)
+	if (!go)
 		return NULL;
 	go->dev = dev;
 	go->board_info = board;
diff --git a/drivers/media/usb/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
index 60bf5f0644d1..a70a3fba79fb 100644
--- a/drivers/media/usb/go7007/go7007-fw.c
+++ b/drivers/media/usb/go7007/go7007-fw.c
@@ -378,7 +378,7 @@ static int gen_mjpeghdr_to_package(struct go7007 *go, __le16 *code, int space)
 	int size = 0, i, off = 0, chunk;
 
 	buf = kzalloc(4096, GFP_KERNEL);
-	if (buf == NULL)
+	if (!buf)
 		return -ENOMEM;
 
 	for (i = 1; i < 32; ++i) {
@@ -645,7 +645,7 @@ static int gen_mpeg1hdr_to_package(struct go7007 *go,
 	int i, off = 0, chunk;
 
 	buf = kzalloc(5120, GFP_KERNEL);
-	if (buf == NULL)
+	if (!buf)
 		return -ENOMEM;
 
 	framelen[0] = mpeg1_frame_header(go, buf, 0, 1, PFRAME);
@@ -831,7 +831,7 @@ static int gen_mpeg4hdr_to_package(struct go7007 *go,
 	int i, off = 0, chunk;
 
 	buf = kzalloc(5120, GFP_KERNEL);
-	if (buf == NULL)
+	if (!buf)
 		return -ENOMEM;
 
 	framelen[0] = mpeg4_frame_header(go, buf, 0, PFRAME);
@@ -1577,7 +1577,7 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 		return -1;
 	}
 	code = kzalloc(codespace * 2, GFP_KERNEL);
-	if (code == NULL)
+	if (!code)
 		goto fw_failed;
 
 	src = (__le16 *)fw_entry->data;
diff --git a/drivers/media/usb/go7007/go7007-loader.c b/drivers/media/usb/go7007/go7007-loader.c
index 042f78a31283..5e94f03c044d 100644
--- a/drivers/media/usb/go7007/go7007-loader.c
+++ b/drivers/media/usb/go7007/go7007-loader.c
@@ -67,7 +67,7 @@ static int go7007_loader_probe(struct usb_interface *interface,
 			break;
 
 	/* Should never happen */
-	if (fw_configs[i].fw_name1 == NULL)
+	if (!fw_configs[i].fw_name1)
 		goto failed2;
 
 	fw1 = fw_configs[i].fw_name1;
@@ -87,7 +87,7 @@ static int go7007_loader_probe(struct usb_interface *interface,
 		goto failed2;
 	}
 
-	if (fw2 == NULL)
+	if (!fw2)
 		return 0;
 
 	if (request_firmware(&fw, fw2, &usbdev->dev)) {
diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index ed9bcaf08d5e..5ad40b77763d 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -829,7 +829,7 @@ static void go7007_usb_read_audio_pipe_complete(struct urb *urb)
 		dev_err(go->dev, "short read in audio pipe!\n");
 		return;
 	}
-	if (go->audio_deliver != NULL)
+	if (go->audio_deliver)
 		go->audio_deliver(go, urb->transfer_buffer, urb->actual_length);
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r < 0)
@@ -1121,7 +1121,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	go = go7007_alloc(&board->main_info, &intf->dev);
-	if (go == NULL)
+	if (!go)
 		return -ENOMEM;
 
 	usb = kzalloc(sizeof(struct go7007_usb), GFP_KERNEL);
-	if (usb == NULL) {
+	if (!usb) {
 		kfree(go);
@@ -1143,8 +1143,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	usb->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (usb->intr_urb == NULL)
+	if (!usb->intr_urb)
 		goto allocfail;
 	usb->intr_urb->transfer_buffer = kmalloc(2*sizeof(u16), GFP_KERNEL);
-	if (usb->intr_urb->transfer_buffer == NULL)
+	if (!usb->intr_urb->transfer_buffer)
 		goto allocfail;
 
 	if (go->board_id == GO7007_BOARDID_SENSORAY_2250)
@@ -1278,9 +1278,9 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		usb->video_urbs[i] = usb_alloc_urb(0, GFP_KERNEL);
-		if (usb->video_urbs[i] == NULL)
+		if (!usb->video_urbs[i])
 			goto allocfail;
 		usb->video_urbs[i]->transfer_buffer =
 						kmalloc(v_urb_len, GFP_KERNEL);
-		if (usb->video_urbs[i]->transfer_buffer == NULL)
+		if (!usb->video_urbs[i]->transfer_buffer)
 			goto allocfail;
 		usb_fill_bulk_urb(usb->video_urbs[i], usb->usbdev, video_pipe,
 				usb->video_urbs[i]->transfer_buffer, v_urb_len,
@@ -1294,9 +1294,9 @@ static int go7007_usb_probe(struct usb_interface *intf,
 			usb->audio_urbs[i] = usb_alloc_urb(0, GFP_KERNEL);
-			if (usb->audio_urbs[i] == NULL)
+			if (!usb->audio_urbs[i])
 				goto allocfail;
 			usb->audio_urbs[i]->transfer_buffer = kmalloc(4096,
 								GFP_KERNEL);
-			if (usb->audio_urbs[i]->transfer_buffer == NULL)
+			if (!usb->audio_urbs[i]->transfer_buffer)
 				goto allocfail;
 			usb_fill_bulk_urb(usb->audio_urbs[i], usb->usbdev,
 				usb_rcvbulkpipe(usb->usbdev, 8),
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 98cd57eaf36a..f915fb5a316a 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -187,9 +187,9 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	int width, height;
 
-	if (fmt != NULL && !valid_pixelformat(fmt->fmt.pix.pixelformat))
+	if (fmt && !valid_pixelformat(fmt->fmt.pix.pixelformat))
 		return -EINVAL;
 
 	get_resolution(go, &sensor_width, &sensor_height);
 
-	if (fmt == NULL) {
+	if (!fmt) {
 		width = sensor_width;
@@ -225,7 +225,7 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 		height &= ~0xf;
 	}
 
-	if (fmt != NULL) {
+	if (fmt) {
 		u32 pixelformat = fmt->fmt.pix.pixelformat;
 
 		memset(fmt, 0, sizeof(*fmt));
diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
index 1466db150d82..d987c5f2b45a 100644
--- a/drivers/media/usb/go7007/s2250-board.c
+++ b/drivers/media/usb/go7007/s2250-board.c
@@ -165,13 +165,13 @@ static int write_reg(struct i2c_client *client, u8 reg, u8 value)
 	u8 *buf;
 
-	if (go == NULL)
+	if (!go)
 		return -ENODEV;
 
 	if (go->status == STATUS_SHUTDOWN)
 		return -EBUSY;
 
 	buf = kzalloc(16, GFP_KERNEL);
-	if (buf == NULL)
+	if (!buf)
 		return -ENOMEM;
 
 	usb = go->hpi_context;
@@ -199,12 +199,11 @@ static int write_reg_fp(struct i2c_client *client, u16 addr, u16 val)
 	struct s2250 *dec = i2c_get_clientdata(client);
 
-	if (go == NULL)
+	if (!go)
 		return -ENODEV;
 
 	if (go->status == STATUS_SHUTDOWN)
 		return -EBUSY;
 
 	buf = kzalloc(16, GFP_KERNEL);
-
-	if (buf == NULL)
+	if (!buf)
 		return -ENOMEM;
@@ -261,13 +260,12 @@ static int read_reg_fp(struct i2c_client *client, u16 addr, u16 *val)
 	int rc;
 	u8 *buf;
 
-	if (go == NULL)
+	if (!go)
 		return -ENODEV;
 
 	if (go->status == STATUS_SHUTDOWN)
 		return -EBUSY;
 
 	buf = kzalloc(16, GFP_KERNEL);
-
-	if (buf == NULL)
+	if (!buf)
 		return -ENOMEM;
@@ -514,9 +512,9 @@ static int s2250_probe(struct i2c_client *client,
 	struct go7007_usb *usb = go->hpi_context;
 
 	audio = i2c_new_dummy(adapter, TLV320_ADDRESS >> 1);
-	if (audio == NULL)
+	if (!audio)
 		return -ENOMEM;
 
 	state = kzalloc(sizeof(struct s2250), GFP_KERNEL);
-	if (state == NULL) {
+	if (!state) {
 		i2c_unregister_device(audio);
@@ -581,4 +579,4 @@ static int s2250_probe(struct i2c_client *client,
 	if (mutex_lock_interruptible(&usb->i2c_lock) == 0) {
 		data = kzalloc(16, GFP_KERNEL);
-		if (data != NULL) {
+		if (data) {
 			int rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index c618764480c6..4e612cf1afd9 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -114,6 +114,6 @@ static int go7007_snd_hw_params(struct snd_pcm_substream *substream,
 		vfree(substream->runtime->dma_area);
 	substream->runtime->dma_bytes = 0;
 	substream->runtime->dma_area = vmalloc(bytes);
-	if (substream->runtime->dma_area == NULL)
+	if (!substream->runtime->dma_area)
 		return -ENOMEM;
 	substream->runtime->dma_bytes = bytes;
@@ -140,6 +140,6 @@ static int go7007_snd_capture_open(struct snd_pcm_substream *substream)
 	int r;
 
 	spin_lock_irqsave(&gosnd->lock, flags);
-	if (gosnd->substream == NULL) {
+	if (!gosnd->substream) {
 		gosnd->substream = substream;
 		substream->runtime->hw = go7007_snd_capture_hw;
@@ -239,4 +239,4 @@ int go7007_snd_init(struct go7007 *go)
-	if (gosnd == NULL)
+	if (!gosnd)
 		return -ENOMEM;
 	spin_lock_init(&gosnd->lock);
 	gosnd->hw_ptr = gosnd->w_idx = gosnd->avail = 0;
-- 
2.14.1
