Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41761 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbaLWUuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 45/66] rtl2832_sdr: rename state variable from 's' to 'dev'
Date: Tue, 23 Dec 2014 22:49:38 +0200
Message-Id: <1419367799-14263-45-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'dev' sounds better than 's' for such variable.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 858 +++++++++++++++---------------
 1 file changed, 429 insertions(+), 429 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 2896b47..3af869c 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -107,7 +107,7 @@ struct rtl2832_sdr_frame_buf {
 	struct list_head list;
 };
 
-struct rtl2832_sdr_state {
+struct rtl2832_sdr_dev {
 #define POWER_ON           (1 << 1)
 #define URB_BUF            (1 << 2)
 	unsigned long flags;
@@ -161,7 +161,7 @@ struct rtl2832_sdr_state {
 };
 
 /* write multiple hardware registers */
-static int rtl2832_sdr_wr(struct rtl2832_sdr_state *s, u8 reg, const u8 *val,
+static int rtl2832_sdr_wr(struct rtl2832_sdr_dev *dev, u8 reg, const u8 *val,
 		int len)
 {
 	int ret;
@@ -170,7 +170,7 @@ static int rtl2832_sdr_wr(struct rtl2832_sdr_state *s, u8 reg, const u8 *val,
 	u8 buf[MAX_WR_XFER_LEN];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = s->cfg->i2c_addr,
+			.addr = dev->cfg->i2c_addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -183,11 +183,11 @@ static int rtl2832_sdr_wr(struct rtl2832_sdr_state *s, u8 reg, const u8 *val,
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(s->i2c, msg, 1);
+	ret = i2c_transfer(dev->i2c, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_err(&s->i2c->dev,
+		dev_err(&dev->i2c->dev,
 			"%s: I2C wr failed=%d reg=%02x len=%d\n",
 			KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -196,28 +196,28 @@ static int rtl2832_sdr_wr(struct rtl2832_sdr_state *s, u8 reg, const u8 *val,
 }
 
 /* read multiple hardware registers */
-static int rtl2832_sdr_rd(struct rtl2832_sdr_state *s, u8 reg, u8 *val, int len)
+static int rtl2832_sdr_rd(struct rtl2832_sdr_dev *dev, u8 reg, u8 *val, int len)
 {
 	int ret;
 	struct i2c_msg msg[2] = {
 		{
-			.addr = s->cfg->i2c_addr,
+			.addr = dev->cfg->i2c_addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = s->cfg->i2c_addr,
+			.addr = dev->cfg->i2c_addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val,
 		}
 	};
 
-	ret = i2c_transfer(s->i2c, msg, 2);
+	ret = i2c_transfer(dev->i2c, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_err(&s->i2c->dev,
+		dev_err(&dev->i2c->dev,
 				"%s: I2C rd failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -226,7 +226,7 @@ static int rtl2832_sdr_rd(struct rtl2832_sdr_state *s, u8 reg, u8 *val, int len)
 }
 
 /* write multiple registers */
-static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_state *s, u16 reg,
+static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_dev *dev, u16 reg,
 		const u8 *val, int len)
 {
 	int ret;
@@ -234,19 +234,19 @@ static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_state *s, u16 reg,
 	u8 bank = (reg >> 8) & 0xff;
 
 	/* switch bank if needed */
-	if (bank != s->bank) {
-		ret = rtl2832_sdr_wr(s, 0x00, &bank, 1);
+	if (bank != dev->bank) {
+		ret = rtl2832_sdr_wr(dev, 0x00, &bank, 1);
 		if (ret)
 			return ret;
 
-		s->bank = bank;
+		dev->bank = bank;
 	}
 
-	return rtl2832_sdr_wr(s, reg2, val, len);
+	return rtl2832_sdr_wr(dev, reg2, val, len);
 }
 
 /* read multiple registers */
-static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_state *s, u16 reg, u8 *val,
+static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_dev *dev, u16 reg, u8 *val,
 		int len)
 {
 	int ret;
@@ -254,33 +254,33 @@ static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_state *s, u16 reg, u8 *val,
 	u8 bank = (reg >> 8) & 0xff;
 
 	/* switch bank if needed */
-	if (bank != s->bank) {
-		ret = rtl2832_sdr_wr(s, 0x00, &bank, 1);
+	if (bank != dev->bank) {
+		ret = rtl2832_sdr_wr(dev, 0x00, &bank, 1);
 		if (ret)
 			return ret;
 
-		s->bank = bank;
+		dev->bank = bank;
 	}
 
-	return rtl2832_sdr_rd(s, reg2, val, len);
+	return rtl2832_sdr_rd(dev, reg2, val, len);
 }
 
 /* write single register */
-static int rtl2832_sdr_wr_reg(struct rtl2832_sdr_state *s, u16 reg, u8 val)
+static int rtl2832_sdr_wr_reg(struct rtl2832_sdr_dev *dev, u16 reg, u8 val)
 {
-	return rtl2832_sdr_wr_regs(s, reg, &val, 1);
+	return rtl2832_sdr_wr_regs(dev, reg, &val, 1);
 }
 
 #if 0
 /* read single register */
-static int rtl2832_sdr_rd_reg(struct rtl2832_sdr_state *s, u16 reg, u8 *val)
+static int rtl2832_sdr_rd_reg(struct rtl2832_sdr_dev *dev, u16 reg, u8 *val)
 {
-	return rtl2832_sdr_rd_regs(s, reg, val, 1);
+	return rtl2832_sdr_rd_regs(dev, reg, val, 1);
 }
 #endif
 
 /* write single register with mask */
-static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
+static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_dev *dev, u16 reg,
 		u8 val, u8 mask)
 {
 	int ret;
@@ -288,7 +288,7 @@ static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = rtl2832_sdr_rd_regs(s, reg, &tmp, 1);
+		ret = rtl2832_sdr_rd_regs(dev, reg, &tmp, 1);
 		if (ret)
 			return ret;
 
@@ -297,18 +297,18 @@ static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
 		val |= tmp;
 	}
 
-	return rtl2832_sdr_wr_regs(s, reg, &val, 1);
+	return rtl2832_sdr_wr_regs(dev, reg, &val, 1);
 }
 
 #if 0
 /* read single register with mask */
-static int rtl2832_sdr_rd_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
+static int rtl2832_sdr_rd_reg_mask(struct rtl2832_sdr_dev *dev, u16 reg,
 		u8 *val, u8 mask)
 {
 	int ret, i;
 	u8 tmp;
 
-	ret = rtl2832_sdr_rd_regs(s, reg, &tmp, 1);
+	ret = rtl2832_sdr_rd_regs(dev, reg, &tmp, 1);
 	if (ret)
 		return ret;
 
@@ -327,33 +327,33 @@ static int rtl2832_sdr_rd_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
 
 /* Private functions */
 static struct rtl2832_sdr_frame_buf *rtl2832_sdr_get_next_fill_buf(
-		struct rtl2832_sdr_state *s)
+		struct rtl2832_sdr_dev *dev)
 {
 	unsigned long flags;
 	struct rtl2832_sdr_frame_buf *buf = NULL;
 
-	spin_lock_irqsave(&s->queued_bufs_lock, flags);
-	if (list_empty(&s->queued_bufs))
+	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
+	if (list_empty(&dev->queued_bufs))
 		goto leave;
 
-	buf = list_entry(s->queued_bufs.next,
+	buf = list_entry(dev->queued_bufs.next,
 			struct rtl2832_sdr_frame_buf, list);
 	list_del(&buf->list);
 leave:
-	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 	return buf;
 }
 
-static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
+static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_dev *dev,
 		void *dst, const u8 *src, unsigned int src_len)
 {
 	unsigned int dst_len;
 
-	if (s->pixelformat ==  V4L2_SDR_FMT_CU8) {
+	if (dev->pixelformat ==  V4L2_SDR_FMT_CU8) {
 		/* native stream, no need to convert */
 		memcpy(dst, src, src_len);
 		dst_len = src_len;
-	} else if (s->pixelformat == V4L2_SDR_FMT_CU16LE) {
+	} else if (dev->pixelformat == V4L2_SDR_FMT_CU16LE) {
 		/* convert u8 to u16 */
 		unsigned int i;
 		u16 *u16dst = dst;
@@ -366,22 +366,22 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
 	}
 
 	/* calculate sample rate and output it in 10 seconds intervals */
-	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
+	if (unlikely(time_is_before_jiffies(dev->jiffies_next))) {
 		#define MSECS 10000UL
 		unsigned int msecs = jiffies_to_msecs(jiffies -
-				s->jiffies_next + msecs_to_jiffies(MSECS));
-		unsigned int samples = s->sample - s->sample_measured;
+				dev->jiffies_next + msecs_to_jiffies(MSECS));
+		unsigned int samples = dev->sample - dev->sample_measured;
 
-		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
-		s->sample_measured = s->sample;
-		dev_dbg(&s->udev->dev,
+		dev->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
+		dev->sample_measured = dev->sample;
+		dev_dbg(&dev->udev->dev,
 				"slen=%u samples=%u msecs=%u sample rate=%lu\n",
 				src_len, samples, msecs,
 				samples * 1000UL / msecs);
 	}
 
 	/* total number of I+Q pairs */
-	s->sample += src_len / 2;
+	dev->sample += src_len / 2;
 
 	return dst_len;
 }
@@ -392,10 +392,10 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
  */
 static void rtl2832_sdr_urb_complete(struct urb *urb)
 {
-	struct rtl2832_sdr_state *s = urb->context;
+	struct rtl2832_sdr_dev *dev = urb->context;
 	struct rtl2832_sdr_frame_buf *fbuf;
 
-	dev_dbg_ratelimited(&s->udev->dev,
+	dev_dbg_ratelimited(&dev->udev->dev,
 			"status=%d length=%d/%d errors=%d\n",
 			urb->status, urb->actual_length,
 			urb->transfer_buffer_length, urb->error_count);
@@ -409,7 +409,7 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:            /* error */
-		dev_err_ratelimited(&s->udev->dev, "urb failed=%d\n",
+		dev_err_ratelimited(&dev->udev->dev, "urb failed=%d\n",
 				urb->status);
 		break;
 	}
@@ -418,190 +418,190 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		void *ptr;
 		unsigned int len;
 		/* get free framebuffer */
-		fbuf = rtl2832_sdr_get_next_fill_buf(s);
+		fbuf = rtl2832_sdr_get_next_fill_buf(dev);
 		if (unlikely(fbuf == NULL)) {
-			s->vb_full++;
-			dev_notice_ratelimited(&s->udev->dev,
+			dev->vb_full++;
+			dev_notice_ratelimited(&dev->udev->dev,
 					"videobuf is full, %d packets dropped\n",
-					s->vb_full);
+					dev->vb_full);
 			goto skip;
 		}
 
 		/* fill framebuffer */
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		len = rtl2832_sdr_convert_stream(s, ptr, urb->transfer_buffer,
+		len = rtl2832_sdr_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
-		fbuf->vb.v4l2_buf.sequence = s->sequence++;
+		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
 	}
 skip:
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
-static int rtl2832_sdr_kill_urbs(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_kill_urbs(struct rtl2832_sdr_dev *dev)
 {
 	int i;
 
-	for (i = s->urbs_submitted - 1; i >= 0; i--) {
-		dev_dbg(&s->udev->dev, "kill urb=%d\n", i);
+	for (i = dev->urbs_submitted - 1; i >= 0; i--) {
+		dev_dbg(&dev->udev->dev, "kill urb=%d\n", i);
 		/* stop the URB */
-		usb_kill_urb(s->urb_list[i]);
+		usb_kill_urb(dev->urb_list[i]);
 	}
-	s->urbs_submitted = 0;
+	dev->urbs_submitted = 0;
 
 	return 0;
 }
 
-static int rtl2832_sdr_submit_urbs(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_submit_urbs(struct rtl2832_sdr_dev *dev)
 {
 	int i, ret;
 
-	for (i = 0; i < s->urbs_initialized; i++) {
-		dev_dbg(&s->udev->dev, "submit urb=%d\n", i);
-		ret = usb_submit_urb(s->urb_list[i], GFP_ATOMIC);
+	for (i = 0; i < dev->urbs_initialized; i++) {
+		dev_dbg(&dev->udev->dev, "submit urb=%d\n", i);
+		ret = usb_submit_urb(dev->urb_list[i], GFP_ATOMIC);
 		if (ret) {
-			dev_err(&s->udev->dev,
+			dev_err(&dev->udev->dev,
 					"Could not submit urb no. %d - get them all back\n",
 					i);
-			rtl2832_sdr_kill_urbs(s);
+			rtl2832_sdr_kill_urbs(dev);
 			return ret;
 		}
-		s->urbs_submitted++;
+		dev->urbs_submitted++;
 	}
 
 	return 0;
 }
 
-static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_dev *dev)
 {
-	if (s->flags & USB_STATE_URB_BUF) {
-		while (s->buf_num) {
-			s->buf_num--;
-			dev_dbg(&s->udev->dev, "free buf=%d\n", s->buf_num);
-			usb_free_coherent(s->udev, s->buf_size,
-					  s->buf_list[s->buf_num],
-					  s->dma_addr[s->buf_num]);
+	if (dev->flags & USB_STATE_URB_BUF) {
+		while (dev->buf_num) {
+			dev->buf_num--;
+			dev_dbg(&dev->udev->dev, "free buf=%d\n", dev->buf_num);
+			usb_free_coherent(dev->udev, dev->buf_size,
+					  dev->buf_list[dev->buf_num],
+					  dev->dma_addr[dev->buf_num]);
 		}
 	}
-	s->flags &= ~USB_STATE_URB_BUF;
+	dev->flags &= ~USB_STATE_URB_BUF;
 
 	return 0;
 }
 
-static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_dev *dev)
 {
-	s->buf_num = 0;
-	s->buf_size = BULK_BUFFER_SIZE;
+	dev->buf_num = 0;
+	dev->buf_size = BULK_BUFFER_SIZE;
 
-	dev_dbg(&s->udev->dev, "all in all I will use %u bytes for streaming\n",
+	dev_dbg(&dev->udev->dev, "all in all I will use %u bytes for streaming\n",
 			MAX_BULK_BUFS * BULK_BUFFER_SIZE);
 
-	for (s->buf_num = 0; s->buf_num < MAX_BULK_BUFS; s->buf_num++) {
-		s->buf_list[s->buf_num] = usb_alloc_coherent(s->udev,
+	for (dev->buf_num = 0; dev->buf_num < MAX_BULK_BUFS; dev->buf_num++) {
+		dev->buf_list[dev->buf_num] = usb_alloc_coherent(dev->udev,
 				BULK_BUFFER_SIZE, GFP_ATOMIC,
-				&s->dma_addr[s->buf_num]);
-		if (!s->buf_list[s->buf_num]) {
-			dev_dbg(&s->udev->dev, "alloc buf=%d failed\n",
-					s->buf_num);
-			rtl2832_sdr_free_stream_bufs(s);
+				&dev->dma_addr[dev->buf_num]);
+		if (!dev->buf_list[dev->buf_num]) {
+			dev_dbg(&dev->udev->dev, "alloc buf=%d failed\n",
+					dev->buf_num);
+			rtl2832_sdr_free_stream_bufs(dev);
 			return -ENOMEM;
 		}
 
-		dev_dbg(&s->udev->dev, "alloc buf=%d %p (dma %llu)\n",
-				s->buf_num, s->buf_list[s->buf_num],
-				(long long)s->dma_addr[s->buf_num]);
-		s->flags |= USB_STATE_URB_BUF;
+		dev_dbg(&dev->udev->dev, "alloc buf=%d %p (dma %llu)\n",
+				dev->buf_num, dev->buf_list[dev->buf_num],
+				(long long)dev->dma_addr[dev->buf_num]);
+		dev->flags |= USB_STATE_URB_BUF;
 	}
 
 	return 0;
 }
 
-static int rtl2832_sdr_free_urbs(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_free_urbs(struct rtl2832_sdr_dev *dev)
 {
 	int i;
 
-	rtl2832_sdr_kill_urbs(s);
+	rtl2832_sdr_kill_urbs(dev);
 
-	for (i = s->urbs_initialized - 1; i >= 0; i--) {
-		if (s->urb_list[i]) {
-			dev_dbg(&s->udev->dev, "free urb=%d\n", i);
+	for (i = dev->urbs_initialized - 1; i >= 0; i--) {
+		if (dev->urb_list[i]) {
+			dev_dbg(&dev->udev->dev, "free urb=%d\n", i);
 			/* free the URBs */
-			usb_free_urb(s->urb_list[i]);
+			usb_free_urb(dev->urb_list[i]);
 		}
 	}
-	s->urbs_initialized = 0;
+	dev->urbs_initialized = 0;
 
 	return 0;
 }
 
-static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_dev *dev)
 {
 	int i, j;
 
 	/* allocate the URBs */
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
-		dev_dbg(&s->udev->dev, "alloc urb=%d\n", i);
-		s->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
-		if (!s->urb_list[i]) {
-			dev_dbg(&s->udev->dev, "failed\n");
+		dev_dbg(&dev->udev->dev, "alloc urb=%d\n", i);
+		dev->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
+		if (!dev->urb_list[i]) {
+			dev_dbg(&dev->udev->dev, "failed\n");
 			for (j = 0; j < i; j++)
-				usb_free_urb(s->urb_list[j]);
+				usb_free_urb(dev->urb_list[j]);
 			return -ENOMEM;
 		}
-		usb_fill_bulk_urb(s->urb_list[i],
-				s->udev,
-				usb_rcvbulkpipe(s->udev, 0x81),
-				s->buf_list[i],
+		usb_fill_bulk_urb(dev->urb_list[i],
+				dev->udev,
+				usb_rcvbulkpipe(dev->udev, 0x81),
+				dev->buf_list[i],
 				BULK_BUFFER_SIZE,
-				rtl2832_sdr_urb_complete, s);
+				rtl2832_sdr_urb_complete, dev);
 
-		s->urb_list[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		s->urb_list[i]->transfer_dma = s->dma_addr[i];
-		s->urbs_initialized++;
+		dev->urb_list[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		dev->urb_list[i]->transfer_dma = dev->dma_addr[i];
+		dev->urbs_initialized++;
 	}
 
 	return 0;
 }
 
 /* Must be called with vb_queue_lock hold */
-static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_state *s)
+static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev)
 {
 	unsigned long flags;
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
-	spin_lock_irqsave(&s->queued_bufs_lock, flags);
-	while (!list_empty(&s->queued_bufs)) {
+	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
+	while (!list_empty(&dev->queued_bufs)) {
 		struct rtl2832_sdr_frame_buf *buf;
 
-		buf = list_entry(s->queued_bufs.next,
+		buf = list_entry(dev->queued_bufs.next,
 				struct rtl2832_sdr_frame_buf, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
 
 /* The user yanked out the cable... */
 static void rtl2832_sdr_release_sec(struct dvb_frontend *fe)
 {
-	struct rtl2832_sdr_state *s = fe->sec_priv;
+	struct rtl2832_sdr_dev *dev = fe->sec_priv;
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
-	mutex_lock(&s->vb_queue_lock);
-	mutex_lock(&s->v4l2_lock);
+	mutex_lock(&dev->vb_queue_lock);
+	mutex_lock(&dev->v4l2_lock);
 	/* No need to keep the urbs around after disconnection */
-	s->udev = NULL;
+	dev->udev = NULL;
 
-	v4l2_device_disconnect(&s->v4l2_dev);
-	video_unregister_device(&s->vdev);
-	mutex_unlock(&s->v4l2_lock);
-	mutex_unlock(&s->vb_queue_lock);
+	v4l2_device_disconnect(&dev->v4l2_dev);
+	video_unregister_device(&dev->vdev);
+	mutex_unlock(&dev->v4l2_lock);
+	mutex_unlock(&dev->vb_queue_lock);
 
-	v4l2_device_put(&s->v4l2_dev);
+	v4l2_device_put(&dev->v4l2_dev);
 
 	fe->sec_priv = NULL;
 }
@@ -609,13 +609,13 @@ static void rtl2832_sdr_release_sec(struct dvb_frontend *fe)
 static int rtl2832_sdr_querycap(struct file *file, void *fh,
 		struct v4l2_capability *cap)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
-	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
+	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -627,26 +627,26 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 		const struct v4l2_format *fmt, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
+	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "nbuffers=%d\n", *nbuffers);
+	dev_dbg(&dev->udev->dev, "nbuffers=%d\n", *nbuffers);
 
 	/* Need at least 8 buffers */
 	if (vq->num_buffers + *nbuffers < 8)
 		*nbuffers = 8 - vq->num_buffers;
 	*nplanes = 1;
-	sizes[0] = PAGE_ALIGN(s->buffersize);
-	dev_dbg(&s->udev->dev, "nbuffers=%d sizes[0]=%d\n",
+	sizes[0] = PAGE_ALIGN(dev->buffersize);
+	dev_dbg(&dev->udev->dev, "nbuffers=%d sizes[0]=%d\n",
 			*nbuffers, sizes[0]);
 	return 0;
 }
 
 static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
 {
-	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 
 	/* Don't allow queing new buffers after device disconnection */
-	if (!s->udev)
+	if (!dev->udev)
 		return -ENODEV;
 
 	return 0;
@@ -654,46 +654,46 @@ static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
 
 static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
 {
-	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct rtl2832_sdr_frame_buf *buf =
 			container_of(vb, struct rtl2832_sdr_frame_buf, vb);
 	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
-	if (!s->udev) {
+	if (!dev->udev) {
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
-	spin_lock_irqsave(&s->queued_bufs_lock, flags);
-	list_add_tail(&buf->list, &s->queued_bufs);
-	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
+	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
+	list_add_tail(&buf->list, &dev->queued_bufs);
+	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
 
-static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 {
-	struct dvb_frontend *fe = s->fe;
+	struct dvb_frontend *fe = dev->fe;
 	int ret;
 	unsigned int f_sr, f_if;
 	u8 buf[4], u8tmp1, u8tmp2;
 	u64 u64tmp;
 	u32 u32tmp;
 
-	dev_dbg(&s->udev->dev, "f_adc=%u\n", s->f_adc);
+	dev_dbg(&dev->udev->dev, "f_adc=%u\n", dev->f_adc);
 
-	if (!test_bit(POWER_ON, &s->flags))
+	if (!test_bit(POWER_ON, &dev->flags))
 		return 0;
 
-	if (s->f_adc == 0)
+	if (dev->f_adc == 0)
 		return 0;
 
-	f_sr = s->f_adc;
+	f_sr = dev->f_adc;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x13e, "\x00\x00", 2);
+	ret = rtl2832_sdr_wr_regs(dev, 0x13e, "\x00\x00", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x115, "\x00\x00\x00\x00", 4);
+	ret = rtl2832_sdr_wr_regs(dev, 0x115, "\x00\x00\x00\x00", 4);
 	if (ret)
 		goto err;
 
@@ -707,19 +707,19 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		goto err;
 
 	/* program IF */
-	u64tmp = f_if % s->cfg->xtal;
+	u64tmp = f_if % dev->cfg->xtal;
 	u64tmp *= 0x400000;
-	u64tmp = div_u64(u64tmp, s->cfg->xtal);
+	u64tmp = div_u64(u64tmp, dev->cfg->xtal);
 	u64tmp = -u64tmp;
 	u32tmp = u64tmp & 0x3fffff;
 
-	dev_dbg(&s->udev->dev, "f_if=%u if_ctl=%08x\n", f_if, u32tmp);
+	dev_dbg(&dev->udev->dev, "f_if=%u if_ctl=%08x\n", f_if, u32tmp);
 
 	buf[0] = (u32tmp >> 16) & 0xff;
 	buf[1] = (u32tmp >>  8) & 0xff;
 	buf[2] = (u32tmp >>  0) & 0xff;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x119, buf, 3);
+	ret = rtl2832_sdr_wr_regs(dev, 0x119, buf, 3);
 	if (ret)
 		goto err;
 
@@ -733,208 +733,208 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		u8tmp2 = 0xcd; /* enable ADC I, ADC Q */
 	}
 
-	ret = rtl2832_sdr_wr_reg(s, 0x1b1, u8tmp1);
+	ret = rtl2832_sdr_wr_reg(dev, 0x1b1, u8tmp1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_reg(s, 0x008, u8tmp2);
+	ret = rtl2832_sdr_wr_reg(dev, 0x008, u8tmp2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_reg(s, 0x006, 0x80);
+	ret = rtl2832_sdr_wr_reg(dev, 0x006, 0x80);
 	if (ret)
 		goto err;
 
 	/* program sampling rate (resampling down) */
-	u32tmp = div_u64(s->cfg->xtal * 0x400000ULL, f_sr * 4U);
+	u32tmp = div_u64(dev->cfg->xtal * 0x400000ULL, f_sr * 4U);
 	u32tmp <<= 2;
 	buf[0] = (u32tmp >> 24) & 0xff;
 	buf[1] = (u32tmp >> 16) & 0xff;
 	buf[2] = (u32tmp >>  8) & 0xff;
 	buf[3] = (u32tmp >>  0) & 0xff;
-	ret = rtl2832_sdr_wr_regs(s, 0x19f, buf, 4);
+	ret = rtl2832_sdr_wr_regs(dev, 0x19f, buf, 4);
 	if (ret)
 		goto err;
 
 	/* low-pass filter */
-	ret = rtl2832_sdr_wr_regs(s, 0x11c,
+	ret = rtl2832_sdr_wr_regs(dev, 0x11c,
 			"\xca\xdc\xd7\xd8\xe0\xf2\x0e\x35\x06\x50\x9c\x0d\x71\x11\x14\x71\x74\x19\x41\xa5",
 			20);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x017, "\x11\x10", 2);
+	ret = rtl2832_sdr_wr_regs(dev, 0x017, "\x11\x10", 2);
 	if (ret)
 		goto err;
 
 	/* mode */
-	ret = rtl2832_sdr_wr_regs(s, 0x019, "\x05", 1);
+	ret = rtl2832_sdr_wr_regs(dev, 0x019, "\x05", 1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x01a, "\x1b\x16\x0d\x06\x01\xff", 6);
+	ret = rtl2832_sdr_wr_regs(dev, 0x01a, "\x1b\x16\x0d\x06\x01\xff", 6);
 	if (ret)
 		goto err;
 
 	/* FSM */
-	ret = rtl2832_sdr_wr_regs(s, 0x192, "\x00\xf0\x0f", 3);
+	ret = rtl2832_sdr_wr_regs(dev, 0x192, "\x00\xf0\x0f", 3);
 	if (ret)
 		goto err;
 
 	/* PID filter */
-	ret = rtl2832_sdr_wr_regs(s, 0x061, "\x60", 1);
+	ret = rtl2832_sdr_wr_regs(dev, 0x061, "\x60", 1);
 	if (ret)
 		goto err;
 
 	/* used RF tuner based settings */
-	switch (s->cfg->tuner) {
+	switch (dev->cfg->tuner) {
 	case RTL2832_TUNER_E4000:
-		ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x30", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xd0", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x18", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1cb, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x107, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1cd, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1ce, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x108, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x109, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x10a, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xd4", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1db, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1dd, "\x14", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1de, "\xec", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d8, "\x0c", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1e6, "\x02", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d7, "\x09", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x83", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x010, "\x49", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x87", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x85", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x013, "\x02", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x30", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xd0", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x18", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xd4", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1e5, "\xf0", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1d9, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1db, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1dd, "\x14", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1de, "\xec", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1d8, "\x0c", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1e6, "\x02", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1d7, "\x09", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00d, "\x83", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x010, "\x49", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00d, "\x87", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00d, "\x85", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x013, "\x02", 1);
 		break;
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
-		ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x2c", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x16", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1cb, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x107, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1cd, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1ce, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x108, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x109, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x10a, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xe9\xbf", 2);
-		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1db, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1dd, "\x11", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1de, "\xef", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d8, "\x0c", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1e6, "\x02", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d7, "\x09", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x2c", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xcc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x16", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xe9\xbf", 2);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1e5, "\xf0", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1d9, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1db, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1dd, "\x11", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1de, "\xef", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1d8, "\x0c", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1e6, "\x02", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1d7, "\x09", 1);
 		break;
 	case RTL2832_TUNER_R820T:
-		ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x115, "\x01", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x24", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x14", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1cb, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x107, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1cd, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1ce, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x108, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x109, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x10a, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xf4", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x115, "\x01", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x24", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xcc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x14", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xf4", 1);
 		break;
 	default:
-		dev_notice(&s->udev->dev, "Unsupported tuner\n");
+		dev_notice(&dev->udev->dev, "Unsupported tuner\n");
 	}
 
 	/* software reset */
-	ret = rtl2832_sdr_wr_reg_mask(s, 0x101, 0x04, 0x04);
+	ret = rtl2832_sdr_wr_reg_mask(dev, 0x101, 0x04, 0x04);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_reg_mask(s, 0x101, 0x00, 0x04);
+	ret = rtl2832_sdr_wr_reg_mask(dev, 0x101, 0x00, 0x04);
 	if (ret)
 		goto err;
 err:
 	return ret;
 };
 
-static void rtl2832_sdr_unset_adc(struct rtl2832_sdr_state *s)
+static void rtl2832_sdr_unset_adc(struct rtl2832_sdr_dev *dev)
 {
 	int ret;
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
 	/* PID filter */
-	ret = rtl2832_sdr_wr_regs(s, 0x061, "\xe0", 1);
+	ret = rtl2832_sdr_wr_regs(dev, 0x061, "\xe0", 1);
 	if (ret)
 		goto err;
 
 	/* mode */
-	ret = rtl2832_sdr_wr_regs(s, 0x019, "\x20", 1);
+	ret = rtl2832_sdr_wr_regs(dev, 0x019, "\x20", 1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x017, "\x11\x10", 2);
+	ret = rtl2832_sdr_wr_regs(dev, 0x017, "\x11\x10", 2);
 	if (ret)
 		goto err;
 
 	/* FSM */
-	ret = rtl2832_sdr_wr_regs(s, 0x192, "\x00\x0f\xff", 3);
+	ret = rtl2832_sdr_wr_regs(dev, 0x192, "\x00\x0f\xff", 3);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x13e, "\x40\x00", 2);
+	ret = rtl2832_sdr_wr_regs(dev, 0x13e, "\x40\x00", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x115, "\x06\x3f\xce\xcc", 4);
+	ret = rtl2832_sdr_wr_regs(dev, 0x115, "\x06\x3f\xce\xcc", 4);
 	if (ret)
 		goto err;
 err:
 	return;
 };
 
-static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_dev *dev)
 {
-	struct dvb_frontend *fe = s->fe;
+	struct dvb_frontend *fe = dev->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct v4l2_ctrl *bandwidth_auto;
 	struct v4l2_ctrl *bandwidth;
@@ -942,29 +942,29 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_state *s)
 	/*
 	 * tuner RF (Hz)
 	 */
-	if (s->f_tuner == 0)
+	if (dev->f_tuner == 0)
 		return 0;
 
 	/*
 	 * bandwidth (Hz)
 	 */
-	bandwidth_auto = v4l2_ctrl_find(&s->hdl,
+	bandwidth_auto = v4l2_ctrl_find(&dev->hdl,
 					V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
-	bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH);
+	bandwidth = v4l2_ctrl_find(&dev->hdl, V4L2_CID_RF_TUNER_BANDWIDTH);
 	if (v4l2_ctrl_g_ctrl(bandwidth_auto)) {
-		c->bandwidth_hz = s->f_adc;
-		v4l2_ctrl_s_ctrl(bandwidth, s->f_adc);
+		c->bandwidth_hz = dev->f_adc;
+		v4l2_ctrl_s_ctrl(bandwidth, dev->f_adc);
 	} else {
 		c->bandwidth_hz = v4l2_ctrl_g_ctrl(bandwidth);
 	}
 
-	c->frequency = s->f_tuner;
+	c->frequency = dev->f_tuner;
 	c->delivery_system = SYS_DVBT;
 
-	dev_dbg(&s->udev->dev, "frequency=%u bandwidth=%d\n",
+	dev_dbg(&dev->udev->dev, "frequency=%u bandwidth=%d\n",
 			c->frequency, c->bandwidth_hz);
 
-	if (!test_bit(POWER_ON, &s->flags))
+	if (!test_bit(POWER_ON, &dev->flags))
 		return 0;
 
 	if (fe->ops.tuner_ops.set_params)
@@ -973,11 +973,11 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_state *s)
 	return 0;
 };
 
-static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_dev *dev)
 {
-	struct dvb_frontend *fe = s->fe;
+	struct dvb_frontend *fe = dev->fe;
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
 	if (fe->ops.tuner_ops.init)
 		fe->ops.tuner_ops.init(fe);
@@ -985,11 +985,11 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	return 0;
 };
 
-static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_state *s)
+static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_dev *dev)
 {
-	struct dvb_frontend *fe = s->fe;
+	struct dvb_frontend *fe = dev->fe;
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
 	if (fe->ops.tuner_ops.sleep)
 		fe->ops.tuner_ops.sleep(fe);
@@ -999,83 +999,83 @@ static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_state *s)
 
 static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
+	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
-	if (!s->udev)
+	if (!dev->udev)
 		return -ENODEV;
 
-	if (mutex_lock_interruptible(&s->v4l2_lock))
+	if (mutex_lock_interruptible(&dev->v4l2_lock))
 		return -ERESTARTSYS;
 
-	if (s->d->props->power_ctrl)
-		s->d->props->power_ctrl(s->d, 1);
+	if (dev->d->props->power_ctrl)
+		dev->d->props->power_ctrl(dev->d, 1);
 
 	/* enable ADC */
-	if (s->d->props->frontend_ctrl)
-		s->d->props->frontend_ctrl(s->fe, 1);
+	if (dev->d->props->frontend_ctrl)
+		dev->d->props->frontend_ctrl(dev->fe, 1);
 
-	set_bit(POWER_ON, &s->flags);
+	set_bit(POWER_ON, &dev->flags);
 
-	ret = rtl2832_sdr_set_tuner(s);
+	ret = rtl2832_sdr_set_tuner(dev);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_set_tuner_freq(s);
+	ret = rtl2832_sdr_set_tuner_freq(dev);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_set_adc(s);
+	ret = rtl2832_sdr_set_adc(dev);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_alloc_stream_bufs(s);
+	ret = rtl2832_sdr_alloc_stream_bufs(dev);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_alloc_urbs(s);
+	ret = rtl2832_sdr_alloc_urbs(dev);
 	if (ret)
 		goto err;
 
-	s->sequence = 0;
+	dev->sequence = 0;
 
-	ret = rtl2832_sdr_submit_urbs(s);
+	ret = rtl2832_sdr_submit_urbs(dev);
 	if (ret)
 		goto err;
 
 err:
-	mutex_unlock(&s->v4l2_lock);
+	mutex_unlock(&dev->v4l2_lock);
 
 	return ret;
 }
 
 static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 {
-	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
+	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
-	mutex_lock(&s->v4l2_lock);
+	mutex_lock(&dev->v4l2_lock);
 
-	rtl2832_sdr_kill_urbs(s);
-	rtl2832_sdr_free_urbs(s);
-	rtl2832_sdr_free_stream_bufs(s);
-	rtl2832_sdr_cleanup_queued_bufs(s);
-	rtl2832_sdr_unset_adc(s);
-	rtl2832_sdr_unset_tuner(s);
+	rtl2832_sdr_kill_urbs(dev);
+	rtl2832_sdr_free_urbs(dev);
+	rtl2832_sdr_free_stream_bufs(dev);
+	rtl2832_sdr_cleanup_queued_bufs(dev);
+	rtl2832_sdr_unset_adc(dev);
+	rtl2832_sdr_unset_tuner(dev);
 
-	clear_bit(POWER_ON, &s->flags);
+	clear_bit(POWER_ON, &dev->flags);
 
 	/* disable ADC */
-	if (s->d->props->frontend_ctrl)
-		s->d->props->frontend_ctrl(s->fe, 0);
+	if (dev->d->props->frontend_ctrl)
+		dev->d->props->frontend_ctrl(dev->fe, 0);
 
-	if (s->d->props->power_ctrl)
-		s->d->props->power_ctrl(s->d, 0);
+	if (dev->d->props->power_ctrl)
+		dev->d->props->power_ctrl(dev->d, 0);
 
-	mutex_unlock(&s->v4l2_lock);
+	mutex_unlock(&dev->v4l2_lock);
 }
 
 static struct vb2_ops rtl2832_sdr_vb2_ops = {
@@ -1091,9 +1091,9 @@ static struct vb2_ops rtl2832_sdr_vb2_ops = {
 static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *v)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "index=%d type=%d\n", v->index, v->type);
+	dev_dbg(&dev->udev->dev, "index=%d type=%d\n", v->index, v->type);
 
 	if (v->index == 0) {
 		strlcpy(v->name, "ADC: Realtek RTL2832", sizeof(v->name));
@@ -1117,9 +1117,9 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
 	if (v->index > 1)
 		return -EINVAL;
@@ -1129,9 +1129,9 @@ static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
 static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
 		struct v4l2_frequency_band *band)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "tuner=%d type=%d index=%d\n",
+	dev_dbg(&dev->udev->dev, "tuner=%d type=%d index=%d\n",
 			band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
@@ -1154,17 +1154,17 @@ static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
 static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *f)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 	int ret  = 0;
 
-	dev_dbg(&s->udev->dev, "tuner=%d type=%d\n",
+	dev_dbg(&dev->udev->dev, "tuner=%d type=%d\n",
 			f->tuner, f->type);
 
 	if (f->tuner == 0) {
-		f->frequency = s->f_adc;
+		f->frequency = dev->f_adc;
 		f->type = V4L2_TUNER_ADC;
 	} else if (f->tuner == 1) {
-		f->frequency = s->f_tuner;
+		f->frequency = dev->f_tuner;
 		f->type = V4L2_TUNER_RF;
 	} else {
 		return -EINVAL;
@@ -1176,10 +1176,10 @@ static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
 static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 	int ret, band;
 
-	dev_dbg(&s->udev->dev, "tuner=%d type=%d frequency=%u\n",
+	dev_dbg(&dev->udev->dev, "tuner=%d type=%d frequency=%u\n",
 			f->tuner, f->type, f->frequency);
 
 	/* ADC band midpoints */
@@ -1194,19 +1194,19 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 		else
 			band = 2;
 
-		s->f_adc = clamp_t(unsigned int, f->frequency,
+		dev->f_adc = clamp_t(unsigned int, f->frequency,
 				bands_adc[band].rangelow,
 				bands_adc[band].rangehigh);
 
-		dev_dbg(&s->udev->dev, "ADC frequency=%u Hz\n", s->f_adc);
-		ret = rtl2832_sdr_set_adc(s);
+		dev_dbg(&dev->udev->dev, "ADC frequency=%u Hz\n", dev->f_adc);
+		ret = rtl2832_sdr_set_adc(dev);
 	} else if (f->tuner == 1) {
-		s->f_tuner = clamp_t(unsigned int, f->frequency,
+		dev->f_tuner = clamp_t(unsigned int, f->frequency,
 				bands_fm[0].rangelow,
 				bands_fm[0].rangehigh);
-		dev_dbg(&s->udev->dev, "RF frequency=%u Hz\n", f->frequency);
+		dev_dbg(&dev->udev->dev, "RF frequency=%u Hz\n", f->frequency);
 
-		ret = rtl2832_sdr_set_tuner_freq(s);
+		ret = rtl2832_sdr_set_tuner_freq(dev);
 	} else {
 		ret = -EINVAL;
 	}
@@ -1217,11 +1217,11 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
-	if (f->index >= s->num_formats)
+	if (f->index >= dev->num_formats)
 		return -EINVAL;
 
 	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
@@ -1233,12 +1233,12 @@ static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
 static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "\n");
+	dev_dbg(&dev->udev->dev, "\n");
 
-	f->fmt.sdr.pixelformat = s->pixelformat;
-	f->fmt.sdr.buffersize = s->buffersize;
+	f->fmt.sdr.pixelformat = dev->pixelformat;
+	f->fmt.sdr.buffersize = dev->buffersize;
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 
@@ -1248,28 +1248,28 @@ static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
 static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
-	struct vb2_queue *q = &s->vb_queue;
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_queue;
 	int i;
 
-	dev_dbg(&s->udev->dev, "pixelformat fourcc %4.4s\n",
+	dev_dbg(&dev->udev->dev, "pixelformat fourcc %4.4s\n",
 			(char *)&f->fmt.sdr.pixelformat);
 
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < s->num_formats; i++) {
+	for (i = 0; i < dev->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
-			s->pixelformat = formats[i].pixelformat;
-			s->buffersize = formats[i].buffersize;
+			dev->pixelformat = formats[i].pixelformat;
+			dev->buffersize = formats[i].buffersize;
 			f->fmt.sdr.buffersize = formats[i].buffersize;
 			return 0;
 		}
 	}
 
-	s->pixelformat = formats[0].pixelformat;
-	s->buffersize = formats[0].buffersize;
+	dev->pixelformat = formats[0].pixelformat;
+	dev->buffersize = formats[0].buffersize;
 	f->fmt.sdr.pixelformat = formats[0].pixelformat;
 	f->fmt.sdr.buffersize = formats[0].buffersize;
 
@@ -1279,14 +1279,14 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
-	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 	int i;
 
-	dev_dbg(&s->udev->dev, "pixelformat fourcc %4.4s\n",
+	dev_dbg(&dev->udev->dev, "pixelformat fourcc %4.4s\n",
 			(char *)&f->fmt.sdr.pixelformat);
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
-	for (i = 0; i < s->num_formats; i++) {
+	for (i = 0; i < dev->num_formats; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
 			f->fmt.sdr.buffersize = formats[i].buffersize;
 			return 0;
@@ -1348,14 +1348,14 @@ static struct video_device rtl2832_sdr_template = {
 
 static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct rtl2832_sdr_state *s =
-			container_of(ctrl->handler, struct rtl2832_sdr_state,
+	struct rtl2832_sdr_dev *dev =
+			container_of(ctrl->handler, struct rtl2832_sdr_dev,
 					hdl);
-	struct dvb_frontend *fe = s->fe;
+	struct dvb_frontend *fe = dev->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&s->udev->dev,
+	dev_dbg(&dev->udev->dev,
 			"id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
 			ctrl->id, ctrl->name, ctrl->val,
 			ctrl->minimum, ctrl->maximum, ctrl->step);
@@ -1364,21 +1364,21 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
 		/* TODO: these controls should be moved to tuner drivers */
-		if (s->bandwidth_auto->val) {
+		if (dev->bandwidth_auto->val) {
 			/* Round towards the closest legal value */
-			s32 val = s->f_adc + div_u64(s->bandwidth->step, 2);
+			s32 val = dev->f_adc + div_u64(dev->bandwidth->step, 2);
 			u32 offset;
 
-			val = clamp_t(s32, val, s->bandwidth->minimum,
-				      s->bandwidth->maximum);
-			offset = val - s->bandwidth->minimum;
-			offset = s->bandwidth->step *
-				div_u64(offset, s->bandwidth->step);
-			s->bandwidth->val = s->bandwidth->minimum + offset;
+			val = clamp_t(s32, val, dev->bandwidth->minimum,
+				      dev->bandwidth->maximum);
+			offset = val - dev->bandwidth->minimum;
+			offset = dev->bandwidth->step *
+				div_u64(offset, dev->bandwidth->step);
+			dev->bandwidth->val = dev->bandwidth->minimum + offset;
 		}
-		c->bandwidth_hz = s->bandwidth->val;
+		c->bandwidth_hz = dev->bandwidth->val;
 
-		if (!test_bit(POWER_ON, &s->flags))
+		if (!test_bit(POWER_ON, &dev->flags))
 			return 0;
 
 		if (fe->ops.tuner_ops.set_params)
@@ -1399,12 +1399,12 @@ static const struct v4l2_ctrl_ops rtl2832_sdr_ctrl_ops = {
 
 static void rtl2832_sdr_video_release(struct v4l2_device *v)
 {
-	struct rtl2832_sdr_state *s =
-			container_of(v, struct rtl2832_sdr_state, v4l2_dev);
+	struct rtl2832_sdr_dev *dev =
+			container_of(v, struct rtl2832_sdr_dev, v4l2_dev);
 
-	v4l2_ctrl_handler_free(&s->hdl);
-	v4l2_device_unregister(&s->v4l2_dev);
-	kfree(s);
+	v4l2_ctrl_handler_free(&dev->hdl);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev);
 }
 
 struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
@@ -1412,138 +1412,138 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		struct v4l2_subdev *sd)
 {
 	int ret;
-	struct rtl2832_sdr_state *s;
+	struct rtl2832_sdr_dev *dev;
 	const struct v4l2_ctrl_ops *ops = &rtl2832_sdr_ctrl_ops;
 	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
 
-	s = kzalloc(sizeof(struct rtl2832_sdr_state), GFP_KERNEL);
-	if (s == NULL) {
+	dev = kzalloc(sizeof(struct rtl2832_sdr_dev), GFP_KERNEL);
+	if (dev == NULL) {
 		dev_err(&d->udev->dev,
-				"Could not allocate memory for rtl2832_sdr_state\n");
+				"Could not allocate memory for rtl2832_sdr_dev\n");
 		return NULL;
 	}
 
 	/* setup the state */
-	s->fe = fe;
-	s->d = d;
-	s->udev = d->udev;
-	s->i2c = i2c;
-	s->cfg = cfg;
-	s->f_adc = bands_adc[0].rangelow;
-	s->f_tuner = bands_fm[0].rangelow;
-	s->pixelformat = formats[0].pixelformat;
-	s->buffersize = formats[0].buffersize;
-	s->num_formats = NUM_FORMATS;
+	dev->fe = fe;
+	dev->d = d;
+	dev->udev = d->udev;
+	dev->i2c = i2c;
+	dev->cfg = cfg;
+	dev->f_adc = bands_adc[0].rangelow;
+	dev->f_tuner = bands_fm[0].rangelow;
+	dev->pixelformat = formats[0].pixelformat;
+	dev->buffersize = formats[0].buffersize;
+	dev->num_formats = NUM_FORMATS;
 	if (!rtl2832_sdr_emulated_fmt)
-		s->num_formats -= 1;
+		dev->num_formats -= 1;
 
-	mutex_init(&s->v4l2_lock);
-	mutex_init(&s->vb_queue_lock);
-	spin_lock_init(&s->queued_bufs_lock);
-	INIT_LIST_HEAD(&s->queued_bufs);
+	mutex_init(&dev->v4l2_lock);
+	mutex_init(&dev->vb_queue_lock);
+	spin_lock_init(&dev->queued_bufs_lock);
+	INIT_LIST_HEAD(&dev->queued_bufs);
 
 	/* Init videobuf2 queue structure */
-	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
-	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
-	s->vb_queue.drv_priv = s;
-	s->vb_queue.buf_struct_size = sizeof(struct rtl2832_sdr_frame_buf);
-	s->vb_queue.ops = &rtl2832_sdr_vb2_ops;
-	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
-	s->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	ret = vb2_queue_init(&s->vb_queue);
+	dev->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
+	dev->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	dev->vb_queue.drv_priv = dev;
+	dev->vb_queue.buf_struct_size = sizeof(struct rtl2832_sdr_frame_buf);
+	dev->vb_queue.ops = &rtl2832_sdr_vb2_ops;
+	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
+	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	ret = vb2_queue_init(&dev->vb_queue);
 	if (ret) {
-		dev_err(&s->udev->dev, "Could not initialize vb2 queue\n");
+		dev_err(&dev->udev->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
 	}
 
 	/* Register controls */
-	switch (s->cfg->tuner) {
+	switch (dev->cfg->tuner) {
 	case RTL2832_TUNER_E4000:
-		v4l2_ctrl_handler_init(&s->hdl, 9);
+		v4l2_ctrl_handler_init(&dev->hdl, 9);
 		if (sd)
-			v4l2_ctrl_add_handler(&s->hdl, sd->ctrl_handler, NULL);
+			v4l2_ctrl_add_handler(&dev->hdl, sd->ctrl_handler, NULL);
 		break;
 	case RTL2832_TUNER_R820T:
-		v4l2_ctrl_handler_init(&s->hdl, 2);
-		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops,
+		v4l2_ctrl_handler_init(&dev->hdl, 2);
+		dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, ops,
 						      V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
 						      0, 1, 1, 1);
-		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops,
+		dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, ops,
 						 V4L2_CID_RF_TUNER_BANDWIDTH,
 						 0, 8000000, 100000, 0);
-		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+		v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
 		break;
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
-		v4l2_ctrl_handler_init(&s->hdl, 2);
-		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops,
+		v4l2_ctrl_handler_init(&dev->hdl, 2);
+		dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, ops,
 						      V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
 						      0, 1, 1, 1);
-		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops,
+		dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, ops,
 						 V4L2_CID_RF_TUNER_BANDWIDTH,
 						 6000000, 8000000, 1000000,
 						 6000000);
-		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+		v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
 		break;
 	default:
-		v4l2_ctrl_handler_init(&s->hdl, 0);
-		dev_notice(&s->udev->dev, "%s: Unsupported tuner\n",
+		v4l2_ctrl_handler_init(&dev->hdl, 0);
+		dev_notice(&dev->udev->dev, "%s: Unsupported tuner\n",
 				KBUILD_MODNAME);
 		goto err_free_controls;
 	}
 
-	if (s->hdl.error) {
-		ret = s->hdl.error;
-		dev_err(&s->udev->dev, "Could not initialize controls\n");
+	if (dev->hdl.error) {
+		ret = dev->hdl.error;
+		dev_err(&dev->udev->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
 
 	/* Init video_device structure */
-	s->vdev = rtl2832_sdr_template;
-	s->vdev.queue = &s->vb_queue;
-	s->vdev.queue->lock = &s->vb_queue_lock;
-	video_set_drvdata(&s->vdev, s);
+	dev->vdev = rtl2832_sdr_template;
+	dev->vdev.queue = &dev->vb_queue;
+	dev->vdev.queue->lock = &dev->vb_queue_lock;
+	video_set_drvdata(&dev->vdev, dev);
 
 	/* Register the v4l2_device structure */
-	s->v4l2_dev.release = rtl2832_sdr_video_release;
-	ret = v4l2_device_register(&s->udev->dev, &s->v4l2_dev);
+	dev->v4l2_dev.release = rtl2832_sdr_video_release;
+	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
 	if (ret) {
-		dev_err(&s->udev->dev,
+		dev_err(&dev->udev->dev,
 				"Failed to register v4l2-device (%d)\n", ret);
 		goto err_free_controls;
 	}
 
-	s->v4l2_dev.ctrl_handler = &s->hdl;
-	s->vdev.v4l2_dev = &s->v4l2_dev;
-	s->vdev.lock = &s->v4l2_lock;
-	s->vdev.vfl_dir = VFL_DIR_RX;
+	dev->v4l2_dev.ctrl_handler = &dev->hdl;
+	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+	dev->vdev.lock = &dev->v4l2_lock;
+	dev->vdev.vfl_dir = VFL_DIR_RX;
 
-	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
+	ret = video_register_device(&dev->vdev, VFL_TYPE_SDR, -1);
 	if (ret) {
-		dev_err(&s->udev->dev,
+		dev_err(&dev->udev->dev,
 				"Failed to register as video device (%d)\n",
 				ret);
 		goto err_unregister_v4l2_dev;
 	}
-	dev_info(&s->udev->dev, "Registered as %s\n",
-			video_device_node_name(&s->vdev));
+	dev_info(&dev->udev->dev, "Registered as %s\n",
+			video_device_node_name(&dev->vdev));
 
-	fe->sec_priv = s;
+	fe->sec_priv = dev;
 	fe->ops.release_sec = rtl2832_sdr_release_sec;
 
-	dev_info(&s->i2c->dev, "%s: Realtek RTL2832 SDR attached\n",
+	dev_info(&dev->i2c->dev, "%s: Realtek RTL2832 SDR attached\n",
 			KBUILD_MODNAME);
-	dev_notice(&s->udev->dev,
+	dev_notice(&dev->udev->dev,
 			"%s: SDR API is still slightly experimental and functionality changes may follow\n",
 			KBUILD_MODNAME);
 	return fe;
 
 err_unregister_v4l2_dev:
-	v4l2_device_unregister(&s->v4l2_dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
 err_free_controls:
-	v4l2_ctrl_handler_free(&s->hdl);
+	v4l2_ctrl_handler_free(&dev->hdl);
 err_free_mem:
-	kfree(s);
+	kfree(dev);
 	return NULL;
 }
 EXPORT_SYMBOL(rtl2832_sdr_attach);
-- 
http://palosaari.fi/

