Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37788 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbbGPHFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 03:05:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 8/9] hackrf: add support for transmitter
Date: Thu, 16 Jul 2015 10:04:57 +0300
Message-Id: <1437030298-20944-9-git-send-email-crope@iki.fi>
In-Reply-To: <1437030298-20944-1-git-send-email-crope@iki.fi>
References: <1437030298-20944-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HackRF SDR device has both receiver and transmitter. There is limitation
that receiver and transmitter cannot be used at the same time
(half-duplex operation). That patch implements transmitter support to
existing receiver only driver.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/hackrf/hackrf.c | 787 +++++++++++++++++++++++++++-----------
 1 file changed, 572 insertions(+), 215 deletions(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 5bd291b..97de9cb6 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -34,6 +34,7 @@ enum {
 	CMD_AMP_ENABLE                     = 0x11,
 	CMD_SET_LNA_GAIN                   = 0x13,
 	CMD_SET_VGA_GAIN                   = 0x14,
+	CMD_SET_TXVGA_GAIN                 = 0x15,
 };
 
 /*
@@ -44,7 +45,7 @@ enum {
 #define MAX_BULK_BUFS            (6)
 #define BULK_BUFFER_SIZE         (128 * 512)
 
-static const struct v4l2_frequency_band bands_adc[] = {
+static const struct v4l2_frequency_band bands_adc_dac[] = {
 	{
 		.tuner = 0,
 		.type = V4L2_TUNER_ADC,
@@ -55,7 +56,7 @@ static const struct v4l2_frequency_band bands_adc[] = {
 	},
 };
 
-static const struct v4l2_frequency_band bands_rf[] = {
+static const struct v4l2_frequency_band bands_rx_tx[] = {
 	{
 		.tuner = 1,
 		.type = V4L2_TUNER_RF,
@@ -91,28 +92,39 @@ struct hackrf_frame_buf {
 };
 
 struct hackrf_dev {
-#define POWER_ON                         1
-#define USB_STATE_URB_BUF                2 /* XXX: set manually */
-#define SAMPLE_RATE_SET                 10
-#define RX_BANDWIDTH                    11
-#define RX_RF_FREQUENCY                 12
-#define RX_RF_GAIN                      13
-#define RX_LNA_GAIN                     14
-#define RX_IF_GAIN                      15
+#define USB_STATE_URB_BUF                1 /* XXX: set manually */
+#define QUEUE_SETUP                      3
+#define RX_ON                            4
+#define TX_ON                            5
+#define RX_ADC_FREQUENCY                11
+#define TX_DAC_FREQUENCY                12
+#define RX_BANDWIDTH                    13
+#define TX_BANDWIDTH                    14
+#define RX_RF_FREQUENCY                 15
+#define TX_RF_FREQUENCY                 16
+#define RX_RF_GAIN                      17
+#define TX_RF_GAIN                      18
+#define RX_IF_GAIN                      19
+#define RX_LNA_GAIN                     20
+#define TX_LNA_GAIN                     21
 	unsigned long flags;
 
 	struct usb_interface *intf;
 	struct device *dev;
 	struct usb_device *udev;
-	struct video_device vdev;
-	struct v4l2_device v4l2_dev;
+	struct video_device rx_vdev;
+	struct video_device tx_vdev;
+	struct v4l2_device rx_v4l2_dev;
+	struct v4l2_device tx_v4l2_dev;
 
 	/* videobuf2 queue and queued buffers list */
-	struct vb2_queue vb_queue;
+	struct vb2_queue rx_vb2_queue;
+	struct vb2_queue tx_vb2_queue;
 	struct list_head queued_bufs;
 	spinlock_t queued_bufs_lock; /* Protects queued_bufs */
 	unsigned sequence;	     /* Buffer sequence counter */
 	unsigned int vb_full;        /* vb is full and packets dropped */
+	unsigned int vb_empty;       /* vb is empty and packets dropped */
 
 	/* Note if taking both locks v4l2_lock must always be locked first! */
 	struct mutex v4l2_lock;      /* Protects everything else */
@@ -132,17 +144,24 @@ struct hackrf_dev {
 
 	/* Current configuration */
 	unsigned int f_adc;
-	unsigned int f_rf;
+	unsigned int f_dac;
+	unsigned int f_rx;
+	unsigned int f_tx;
 	u32 pixelformat;
 	u32 buffersize;
 
 	/* Controls */
-	struct v4l2_ctrl_handler hdl;
-	struct v4l2_ctrl *bandwidth_auto;
-	struct v4l2_ctrl *bandwidth;
-	struct v4l2_ctrl *rf_gain;
-	struct v4l2_ctrl *lna_gain;
-	struct v4l2_ctrl *if_gain;
+	struct v4l2_ctrl_handler rx_ctrl_handler;
+	struct v4l2_ctrl *rx_bandwidth_auto;
+	struct v4l2_ctrl *rx_bandwidth;
+	struct v4l2_ctrl *rx_rf_gain;
+	struct v4l2_ctrl *rx_lna_gain;
+	struct v4l2_ctrl *rx_if_gain;
+	struct v4l2_ctrl_handler tx_ctrl_handler;
+	struct v4l2_ctrl *tx_bandwidth_auto;
+	struct v4l2_ctrl *tx_bandwidth;
+	struct v4l2_ctrl *tx_rf_gain;
+	struct v4l2_ctrl *tx_lna_gain;
 
 	/* Sample rate calc */
 	unsigned long jiffies_next;
@@ -182,6 +201,7 @@ static int hackrf_ctrl_msg(struct hackrf_dev *dev, u8 request, u16 value,
 	case CMD_VERSION_STRING_READ:
 	case CMD_SET_LNA_GAIN:
 	case CMD_SET_VGA_GAIN:
+	case CMD_SET_TXVGA_GAIN:
 		pipe = usb_rcvctrlpipe(dev->udev, 0);
 		requesttype = (USB_TYPE_VENDOR | USB_DIR_IN);
 		break;
@@ -220,16 +240,49 @@ static int hackrf_set_params(struct hackrf_dev *dev)
 	int ret, i;
 	u8 buf[8], u8tmp;
 	unsigned int uitmp, uitmp1, uitmp2;
-
-	if (!test_bit(POWER_ON, &dev->flags)) {
+	const bool rx = test_bit(RX_ON, &dev->flags);
+	const bool tx = test_bit(TX_ON, &dev->flags);
+	static const struct {
+		u32 freq;
+	} bandwidth_lut[] = {
+		{ 1750000}, /*  1.75 MHz */
+		{ 2500000}, /*  2.5  MHz */
+		{ 3500000}, /*  3.5  MHz */
+		{ 5000000}, /*  5    MHz */
+		{ 5500000}, /*  5.5  MHz */
+		{ 6000000}, /*  6    MHz */
+		{ 7000000}, /*  7    MHz */
+		{ 8000000}, /*  8    MHz */
+		{ 9000000}, /*  9    MHz */
+		{10000000}, /* 10    MHz */
+		{12000000}, /* 12    MHz */
+		{14000000}, /* 14    MHz */
+		{15000000}, /* 15    MHz */
+		{20000000}, /* 20    MHz */
+		{24000000}, /* 24    MHz */
+		{28000000}, /* 28    MHz */
+	};
+
+	if (!rx && !tx) {
 		dev_dbg(&intf->dev, "device is sleeping\n");
 		return 0;
 	}
 
-	if (test_and_clear_bit(SAMPLE_RATE_SET, &dev->flags)) {
-		dev_dbg(&intf->dev, "ADC frequency=%u Hz\n", dev->f_adc);
+	/* ADC / DAC frequency */
+	if (rx && test_and_clear_bit(RX_ADC_FREQUENCY, &dev->flags)) {
+		dev_dbg(&intf->dev, "RX ADC frequency=%u Hz\n", dev->f_adc);
 		uitmp1 = dev->f_adc;
 		uitmp2 = 1;
+		set_bit(TX_DAC_FREQUENCY, &dev->flags);
+	} else if (tx && test_and_clear_bit(TX_DAC_FREQUENCY, &dev->flags)) {
+		dev_dbg(&intf->dev, "TX DAC frequency=%u Hz\n", dev->f_dac);
+		uitmp1 = dev->f_dac;
+		uitmp2 = 1;
+		set_bit(RX_ADC_FREQUENCY, &dev->flags);
+	} else {
+		uitmp1 = uitmp2 = 0;
+	}
+	if (uitmp1 || uitmp2) {
 		buf[0] = (uitmp1 >>  0) & 0xff;
 		buf[1] = (uitmp1 >>  8) & 0xff;
 		buf[2] = (uitmp1 >> 16) & 0xff;
@@ -243,32 +296,12 @@ static int hackrf_set_params(struct hackrf_dev *dev)
 			goto err;
 	}
 
-	if (test_and_clear_bit(RX_BANDWIDTH, &dev->flags)) {
-		static const struct {
-			u32 freq;
-		} bandwidth_lut[] = {
-			{ 1750000}, /*  1.75 MHz */
-			{ 2500000}, /*  2.5  MHz */
-			{ 3500000}, /*  3.5  MHz */
-			{ 5000000}, /*  5    MHz */
-			{ 5500000}, /*  5.5  MHz */
-			{ 6000000}, /*  6    MHz */
-			{ 7000000}, /*  7    MHz */
-			{ 8000000}, /*  8    MHz */
-			{ 9000000}, /*  9    MHz */
-			{10000000}, /* 10    MHz */
-			{12000000}, /* 12    MHz */
-			{14000000}, /* 14    MHz */
-			{15000000}, /* 15    MHz */
-			{20000000}, /* 20    MHz */
-			{24000000}, /* 24    MHz */
-			{28000000}, /* 28    MHz */
-		};
-
-		if (dev->bandwidth_auto->val == true)
+	/* bandwidth */
+	if (rx && test_and_clear_bit(RX_BANDWIDTH, &dev->flags)) {
+		if (dev->rx_bandwidth_auto->val == true)
 			uitmp = dev->f_adc;
 		else
-			uitmp = dev->bandwidth->val;
+			uitmp = dev->rx_bandwidth->val;
 
 		for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
 			if (uitmp <= bandwidth_lut[i].freq) {
@@ -276,29 +309,56 @@ static int hackrf_set_params(struct hackrf_dev *dev)
 				break;
 			}
 		}
+		dev->rx_bandwidth->val = uitmp;
+		dev->rx_bandwidth->cur.val = uitmp;
+		dev_dbg(&intf->dev, "RX bandwidth selected=%u\n", uitmp);
+		set_bit(TX_BANDWIDTH, &dev->flags);
+	} else if (tx && test_and_clear_bit(TX_BANDWIDTH, &dev->flags)) {
+		if (dev->tx_bandwidth_auto->val == true)
+			uitmp = dev->f_dac;
+		else
+			uitmp = dev->tx_bandwidth->val;
 
-		dev->bandwidth->val = uitmp;
-		dev->bandwidth->cur.val = uitmp;
-
-		dev_dbg(&intf->dev, "bandwidth selected=%u\n", uitmp);
-
-		uitmp1 = 0;
-		uitmp1 |= ((uitmp >> 0) & 0xff) << 0;
-		uitmp1 |= ((uitmp >> 8) & 0xff) << 8;
-		uitmp2 = 0;
+		for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
+			if (uitmp <= bandwidth_lut[i].freq) {
+				uitmp = bandwidth_lut[i].freq;
+				break;
+			}
+		}
+		dev->tx_bandwidth->val = uitmp;
+		dev->tx_bandwidth->cur.val = uitmp;
+		dev_dbg(&intf->dev, "TX bandwidth selected=%u\n", uitmp);
+		set_bit(RX_BANDWIDTH, &dev->flags);
+	} else {
+		uitmp = 0;
+	}
+	if (uitmp) {
+		uitmp1 = uitmp2 = 0;
+		uitmp1 |= ((uitmp >>  0) & 0xff) << 0;
+		uitmp1 |= ((uitmp >>  8) & 0xff) << 8;
 		uitmp2 |= ((uitmp >> 16) & 0xff) << 0;
 		uitmp2 |= ((uitmp >> 24) & 0xff) << 8;
-
 		ret = hackrf_ctrl_msg(dev, CMD_BASEBAND_FILTER_BANDWIDTH_SET,
 				      uitmp1, uitmp2, NULL, 0);
 		if (ret)
 			goto err;
 	}
 
-	if (test_and_clear_bit(RX_RF_FREQUENCY, &dev->flags)) {
-		dev_dbg(&intf->dev, "RF frequency=%u Hz\n", dev->f_rf);
-		uitmp1 = dev->f_rf / 1000000;
-		uitmp2 = dev->f_rf % 1000000;
+	/* RX / TX RF frequency */
+	if (rx && test_and_clear_bit(RX_RF_FREQUENCY, &dev->flags)) {
+		dev_dbg(&intf->dev, "RX RF frequency=%u Hz\n", dev->f_rx);
+		uitmp1 = dev->f_rx / 1000000;
+		uitmp2 = dev->f_rx % 1000000;
+		set_bit(TX_RF_FREQUENCY, &dev->flags);
+	} else if (tx && test_and_clear_bit(TX_RF_FREQUENCY, &dev->flags)) {
+		dev_dbg(&intf->dev, "TX RF frequency=%u Hz\n", dev->f_tx);
+		uitmp1 = dev->f_tx / 1000000;
+		uitmp2 = dev->f_tx % 1000000;
+		set_bit(RX_RF_FREQUENCY, &dev->flags);
+	} else {
+		uitmp1 = uitmp2 = 0;
+	}
+	if (uitmp1 || uitmp2) {
 		buf[0] = (uitmp1 >>  0) & 0xff;
 		buf[1] = (uitmp1 >>  8) & 0xff;
 		buf[2] = (uitmp1 >> 16) & 0xff;
@@ -312,32 +372,59 @@ static int hackrf_set_params(struct hackrf_dev *dev)
 			goto err;
 	}
 
-	if (test_and_clear_bit(RX_RF_GAIN, &dev->flags)) {
-		dev_dbg(&intf->dev, "RF gain val=%d->%d\n",
-			dev->rf_gain->cur.val, dev->rf_gain->val);
+	/* RX RF gain */
+	if (rx && test_and_clear_bit(RX_RF_GAIN, &dev->flags)) {
+		dev_dbg(&intf->dev, "RX RF gain val=%d->%d\n",
+			dev->rx_rf_gain->cur.val, dev->rx_rf_gain->val);
+
+		u8tmp = (dev->rx_rf_gain->val) ? 1 : 0;
+		ret = hackrf_ctrl_msg(dev, CMD_AMP_ENABLE, u8tmp, 0, NULL, 0);
+		if (ret)
+			goto err;
+		set_bit(TX_RF_GAIN, &dev->flags);
+	}
+
+	/* TX RF gain */
+	if (tx && test_and_clear_bit(TX_RF_GAIN, &dev->flags)) {
+		dev_dbg(&intf->dev, "TX RF gain val=%d->%d\n",
+			dev->tx_rf_gain->cur.val, dev->tx_rf_gain->val);
 
-		u8tmp = (dev->rf_gain->val) ? 1 : 0;
+		u8tmp = (dev->tx_rf_gain->val) ? 1 : 0;
 		ret = hackrf_ctrl_msg(dev, CMD_AMP_ENABLE, u8tmp, 0, NULL, 0);
 		if (ret)
 			goto err;
+		set_bit(RX_RF_GAIN, &dev->flags);
 	}
 
-	if (test_and_clear_bit(RX_LNA_GAIN, &dev->flags)) {
-		dev_dbg(dev->dev, "LNA gain val=%d->%d\n",
-			dev->lna_gain->cur.val, dev->lna_gain->val);
+	/* RX LNA gain */
+	if (rx && test_and_clear_bit(RX_LNA_GAIN, &dev->flags)) {
+		dev_dbg(dev->dev, "RX LNA gain val=%d->%d\n",
+			dev->rx_lna_gain->cur.val, dev->rx_lna_gain->val);
 
 		ret = hackrf_ctrl_msg(dev, CMD_SET_LNA_GAIN, 0,
-				      dev->lna_gain->val, &u8tmp, 1);
+				      dev->rx_lna_gain->val, &u8tmp, 1);
 		if (ret)
 			goto err;
 	}
 
-	if (test_and_clear_bit(RX_IF_GAIN, &dev->flags)) {
+	/* RX IF gain */
+	if (rx && test_and_clear_bit(RX_IF_GAIN, &dev->flags)) {
 		dev_dbg(&intf->dev, "IF gain val=%d->%d\n",
-			dev->if_gain->cur.val, dev->if_gain->val);
+			dev->rx_if_gain->cur.val, dev->rx_if_gain->val);
 
 		ret = hackrf_ctrl_msg(dev, CMD_SET_VGA_GAIN, 0,
-				      dev->if_gain->val, &u8tmp, 1);
+				      dev->rx_if_gain->val, &u8tmp, 1);
+		if (ret)
+			goto err;
+	}
+
+	/* TX LNA gain */
+	if (tx && test_and_clear_bit(TX_LNA_GAIN, &dev->flags)) {
+		dev_dbg(&intf->dev, "TX LNA gain val=%d->%d\n",
+			dev->tx_lna_gain->cur.val, dev->tx_lna_gain->val);
+
+		ret = hackrf_ctrl_msg(dev, CMD_SET_TXVGA_GAIN, 0,
+				      dev->tx_lna_gain->val, &u8tmp, 1);
 		if (ret)
 			goto err;
 	}
@@ -365,8 +452,8 @@ leave:
 	return buf;
 }
 
-static unsigned int hackrf_convert_stream(struct hackrf_dev *dev,
-		void *dst, void *src, unsigned int src_len)
+void hackrf_copy_stream(struct hackrf_dev *dev, void *dst,
+				       void *src, unsigned int src_len)
 {
 	memcpy(dst, src, src_len);
 
@@ -386,22 +473,21 @@ static unsigned int hackrf_convert_stream(struct hackrf_dev *dev,
 
 	/* total number of samples */
 	dev->sample += src_len / 2;
-
-	return src_len;
 }
 
 /*
  * This gets called for the bulk stream pipe. This is done in interrupt
  * time, so it has to be fast, not crash, and not stall. Neat.
  */
-static void hackrf_urb_complete(struct urb *urb)
+static void hackrf_urb_complete_in(struct urb *urb)
 {
 	struct hackrf_dev *dev = urb->context;
-	struct hackrf_frame_buf *fbuf;
+	struct usb_interface *intf = dev->intf;
+	struct hackrf_frame_buf *buf;
+	unsigned int len;
 
-	dev_dbg_ratelimited(dev->dev, "status=%d length=%d/%d errors=%d\n",
-			urb->status, urb->actual_length,
-			urb->transfer_buffer_length, urb->error_count);
+	dev_dbg_ratelimited(&intf->dev, "status=%d length=%u/%u\n", urb->status,
+			    urb->actual_length, urb->transfer_buffer_length);
 
 	switch (urb->status) {
 	case 0:             /* success */
@@ -412,33 +498,74 @@ static void hackrf_urb_complete(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:            /* error */
-		dev_err_ratelimited(dev->dev, "URB failed %d\n", urb->status);
-		break;
+		dev_err_ratelimited(&intf->dev, "URB failed %d\n", urb->status);
+		goto exit_usb_submit_urb;
 	}
 
-	if (likely(urb->actual_length > 0)) {
-		void *ptr;
-		unsigned int len;
-		/* get free framebuffer */
-		fbuf = hackrf_get_next_fill_buf(dev);
-		if (unlikely(fbuf == NULL)) {
-			dev->vb_full++;
-			dev_notice_ratelimited(dev->dev,
-					"videobuf is full, %d packets dropped\n",
-					dev->vb_full);
-			goto skip;
-		}
+	/* get buffer to write */
+	buf = hackrf_get_next_fill_buf(dev);
+	if (unlikely(buf == NULL)) {
+		dev->vb_full++;
+		dev_notice_ratelimited(&intf->dev,
+				       "buffer is full - %u packets dropped\n",
+				       dev->vb_full);
+		goto exit_usb_submit_urb;
+	}
+
+	len = min_t(unsigned long, vb2_plane_size(&buf->vb, 0),
+		    urb->actual_length);
+	hackrf_copy_stream(dev, vb2_plane_vaddr(&buf->vb, 0),
+		    urb->transfer_buffer, len);
+	vb2_set_plane_payload(&buf->vb, 0, len);
+	buf->vb.v4l2_buf.sequence = dev->sequence++;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+exit_usb_submit_urb:
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static void hackrf_urb_complete_out(struct urb *urb)
+{
+	struct hackrf_dev *dev = urb->context;
+	struct usb_interface *intf = dev->intf;
+	struct hackrf_frame_buf *buf;
+	unsigned int len;
 
-		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		len = hackrf_convert_stream(dev, ptr, urb->transfer_buffer,
-				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
-		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+	dev_dbg_ratelimited(&intf->dev, "status=%d length=%u/%u\n", urb->status,
+			    urb->actual_length, urb->transfer_buffer_length);
+
+	switch (urb->status) {
+	case 0:             /* success */
+	case -ETIMEDOUT:    /* NAK */
+		break;
+	case -ECONNRESET:   /* kill */
+	case -ENOENT:
+	case -ESHUTDOWN:
+		return;
+	default:            /* error */
+		dev_err_ratelimited(&intf->dev, "URB failed %d\n", urb->status);
+	}
+
+	/* get buffer to read */
+	buf = hackrf_get_next_fill_buf(dev);
+	if (unlikely(buf == NULL)) {
+		dev->vb_empty++;
+		dev_notice_ratelimited(&intf->dev,
+				       "buffer is empty - %u packets dropped\n",
+				       dev->vb_empty);
+		urb->actual_length = 0;
+		goto exit_usb_submit_urb;
 	}
-skip:
+
+	len = min_t(unsigned long, urb->transfer_buffer_length,
+		    vb2_get_plane_payload(&buf->vb, 0));
+	hackrf_copy_stream(dev, urb->transfer_buffer,
+			   vb2_plane_vaddr(&buf->vb, 0), len);
+	urb->actual_length = len;
+	buf->vb.v4l2_buf.sequence = dev->sequence++;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+exit_usb_submit_urb:
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
@@ -537,9 +664,19 @@ static int hackrf_free_urbs(struct hackrf_dev *dev)
 	return 0;
 }
 
-static int hackrf_alloc_urbs(struct hackrf_dev *dev)
+static int hackrf_alloc_urbs(struct hackrf_dev *dev, bool rcv)
 {
 	int i, j;
+	unsigned int pipe;
+	usb_complete_t complete;
+
+	if (rcv) {
+		pipe = usb_rcvbulkpipe(dev->udev, 0x81);
+		complete = &hackrf_urb_complete_in;
+	} else {
+		pipe = usb_sndbulkpipe(dev->udev, 0x02);
+		complete = &hackrf_urb_complete_out;
+	}
 
 	/* allocate the URBs */
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
@@ -553,10 +690,10 @@ static int hackrf_alloc_urbs(struct hackrf_dev *dev)
 		}
 		usb_fill_bulk_urb(dev->urb_list[i],
 				dev->udev,
-				usb_rcvbulkpipe(dev->udev, 0x81),
+				pipe,
 				dev->buf_list[i],
 				BULK_BUFFER_SIZE,
-				hackrf_urb_complete, dev);
+				complete, dev);
 
 		dev->urb_list[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		dev->urb_list[i]->transfer_dma = dev->dma_addr[i];
@@ -589,7 +726,8 @@ static void hackrf_cleanup_queued_bufs(struct hackrf_dev *dev)
 static void hackrf_disconnect(struct usb_interface *intf)
 {
 	struct v4l2_device *v = usb_get_intfdata(intf);
-	struct hackrf_dev *dev = container_of(v, struct hackrf_dev, v4l2_dev);
+	struct hackrf_dev *dev = container_of(v, struct hackrf_dev,
+					      rx_v4l2_dev);
 
 	dev_dbg(dev->dev, "\n");
 
@@ -597,12 +735,14 @@ static void hackrf_disconnect(struct usb_interface *intf)
 	mutex_lock(&dev->v4l2_lock);
 	/* No need to keep the urbs around after disconnection */
 	dev->udev = NULL;
-	v4l2_device_disconnect(&dev->v4l2_dev);
-	video_unregister_device(&dev->vdev);
+	v4l2_device_disconnect(&dev->tx_v4l2_dev);
+	v4l2_device_disconnect(&dev->rx_v4l2_dev);
+	video_unregister_device(&dev->tx_vdev);
+	video_unregister_device(&dev->rx_vdev);
 	mutex_unlock(&dev->v4l2_lock);
 	mutex_unlock(&dev->vb_queue_lock);
-
-	v4l2_device_put(&dev->v4l2_dev);
+	v4l2_device_put(&dev->tx_v4l2_dev);
+	v4l2_device_put(&dev->rx_v4l2_dev);
 }
 
 /* Videobuf2 operations */
@@ -611,8 +751,15 @@ static int hackrf_queue_setup(struct vb2_queue *vq,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
+	struct usb_interface *intf = dev->intf;
+	int ret;
 
-	dev_dbg(dev->dev, "nbuffers=%d\n", *nbuffers);
+	dev_dbg(&intf->dev, "nbuffers=%d\n", *nbuffers);
+
+	if (test_and_set_bit(QUEUE_SETUP, &dev->flags)) {
+		ret = -EBUSY;
+		goto err;
+	}
 
 	/* Need at least 8 buffers */
 	if (vq->num_buffers + *nbuffers < 8)
@@ -620,8 +767,11 @@ static int hackrf_queue_setup(struct vb2_queue *vq,
 	*nplanes = 1;
 	sizes[0] = PAGE_ALIGN(dev->buffersize);
 
-	dev_dbg(dev->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
+	dev_dbg(&intf->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
 	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
+	return ret;
 }
 
 static void hackrf_buf_queue(struct vb2_buffer *vb)
@@ -640,23 +790,26 @@ static int hackrf_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
 	int ret;
+	unsigned int mode;
 
 	dev_dbg(dev->dev, "\n");
 
-	if (!dev->udev)
-		return -ENODEV;
-
 	mutex_lock(&dev->v4l2_lock);
 
 	dev->sequence = 0;
-
-	set_bit(POWER_ON, &dev->flags);
+	if (vq->type == V4L2_BUF_TYPE_SDR_CAPTURE) {
+		mode = 1;
+		set_bit(RX_ON, &dev->flags);
+	} else {
+		mode = 2;
+		set_bit(TX_ON, &dev->flags);
+	}
 
 	ret = hackrf_alloc_stream_bufs(dev);
 	if (ret)
 		goto err;
 
-	ret = hackrf_alloc_urbs(dev);
+	ret = hackrf_alloc_urbs(dev, (mode == 1));
 	if (ret)
 		goto err;
 
@@ -669,7 +822,7 @@ static int hackrf_start_streaming(struct vb2_queue *vq, unsigned int count)
 		goto err;
 
 	/* start hardware streaming */
-	ret = hackrf_ctrl_msg(dev, CMD_SET_TRANSCEIVER_MODE, 1, 0, NULL, 0);
+	ret = hackrf_ctrl_msg(dev, CMD_SET_TRANSCEIVER_MODE, mode, 0, NULL, 0);
 	if (ret)
 		goto err;
 
@@ -678,7 +831,8 @@ err:
 	hackrf_kill_urbs(dev);
 	hackrf_free_urbs(dev);
 	hackrf_free_stream_bufs(dev);
-	clear_bit(POWER_ON, &dev->flags);
+	clear_bit(RX_ON, &dev->flags);
+	clear_bit(TX_ON, &dev->flags);
 
 	/* return all queued buffers to vb2 */
 	{
@@ -690,6 +844,8 @@ err:
 		}
 	}
 
+	clear_bit(QUEUE_SETUP, &dev->flags);
+
 exit_mutex_unlock:
 	mutex_unlock(&dev->v4l2_lock);
 
@@ -713,7 +869,9 @@ static void hackrf_stop_streaming(struct vb2_queue *vq)
 
 	hackrf_cleanup_queued_bufs(dev);
 
-	clear_bit(POWER_ON, &dev->flags);
+	clear_bit(RX_ON, &dev->flags);
+	clear_bit(TX_ON, &dev->flags);
+	clear_bit(QUEUE_SETUP, &dev->flags);
 
 	mutex_unlock(&dev->v4l2_lock);
 }
@@ -731,15 +889,19 @@ static int hackrf_querycap(struct file *file, void *fh,
 		struct v4l2_capability *cap)
 {
 	struct hackrf_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
 
 	dev_dbg(dev->dev, "\n");
 
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
+	else
+		cap->device_caps = V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR;
+	cap->device_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
+	strlcpy(cap->card, dev->rx_vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
@@ -748,7 +910,7 @@ static int hackrf_s_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct hackrf_dev *dev = video_drvdata(file);
-	struct vb2_queue *q = &dev->vb_queue;
+	struct vb2_queue *q = &dev->rx_vb2_queue;
 	int i;
 
 	dev_dbg(dev->dev, "pixelformat fourcc %4.4s\n",
@@ -858,15 +1020,59 @@ static int hackrf_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 		strlcpy(v->name, "HackRF ADC", sizeof(v->name));
 		v->type = V4L2_TUNER_ADC;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
-		v->rangelow  = bands_adc[0].rangelow;
-		v->rangehigh = bands_adc[0].rangehigh;
+		v->rangelow  = bands_adc_dac[0].rangelow;
+		v->rangehigh = bands_adc_dac[0].rangehigh;
 		ret = 0;
 	} else if (v->index == 1) {
-		strlcpy(v->name, "HackRF RF", sizeof(v->name));
+		strlcpy(v->name, "HackRF RF RX", sizeof(v->name));
 		v->type = V4L2_TUNER_RF;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
-		v->rangelow  = bands_rf[0].rangelow;
-		v->rangehigh = bands_rf[0].rangehigh;
+		v->rangelow  = bands_rx_tx[0].rangelow;
+		v->rangehigh = bands_rx_tx[0].rangehigh;
+		ret = 0;
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+int hackrf_s_modulator(struct file *file, void *fh,
+		       const struct v4l2_modulator *a)
+{
+	struct hackrf_dev *dev = video_drvdata(file);
+	int ret;
+
+	dev_dbg(dev->dev, "index=%d\n", a->index);
+
+	if (a->index == 0)
+		ret = 0;
+	else if (a->index == 1)
+		ret = 0;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+int hackrf_g_modulator(struct file *file, void *fh, struct v4l2_modulator *a)
+{
+	struct hackrf_dev *dev = video_drvdata(file);
+	int ret;
+
+	dev_dbg(dev->dev, "index=%d\n", a->index);
+
+	if (a->index == 0) {
+		strlcpy(a->name, "HackRF DAC", sizeof(a->name));
+		a->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		a->rangelow  = bands_adc_dac[0].rangelow;
+		a->rangehigh = bands_adc_dac[0].rangehigh;
+		ret = 0;
+	} else if (a->index == 1) {
+		strlcpy(a->name, "HackRF RF TX", sizeof(a->name));
+		a->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		a->rangelow  = bands_rx_tx[0].rangelow;
+		a->rangehigh = bands_rx_tx[0].rangehigh;
 		ret = 0;
 	} else {
 		ret = -EINVAL;
@@ -880,19 +1086,33 @@ static int hackrf_s_frequency(struct file *file, void *priv,
 {
 	struct hackrf_dev *dev = video_drvdata(file);
 	struct usb_interface *intf = dev->intf;
+	struct video_device *vdev = video_devdata(file);
 	int ret;
+	unsigned int uitmp;
 
 	dev_dbg(&intf->dev, "tuner=%d type=%d frequency=%u\n",
 			f->tuner, f->type, f->frequency);
 
 	if (f->tuner == 0) {
-		dev->f_adc = clamp_t(unsigned int, f->frequency,
-				bands_adc[0].rangelow, bands_adc[0].rangehigh);
-		set_bit(SAMPLE_RATE_SET, &dev->flags);
+		uitmp = clamp(f->frequency, bands_adc_dac[0].rangelow,
+			      bands_adc_dac[0].rangehigh);
+		if (vdev->vfl_dir == VFL_DIR_RX) {
+			dev->f_adc = uitmp;
+			set_bit(RX_ADC_FREQUENCY, &dev->flags);
+		} else {
+			dev->f_dac = uitmp;
+			set_bit(TX_DAC_FREQUENCY, &dev->flags);
+		}
 	} else if (f->tuner == 1) {
-		dev->f_rf = clamp_t(unsigned int, f->frequency,
-				bands_rf[0].rangelow, bands_rf[0].rangehigh);
-		set_bit(RX_RF_FREQUENCY, &dev->flags);
+		uitmp = clamp(f->frequency, bands_rx_tx[0].rangelow,
+			      bands_rx_tx[0].rangehigh);
+		if (vdev->vfl_dir == VFL_DIR_RX) {
+			dev->f_rx = uitmp;
+			set_bit(RX_RF_FREQUENCY, &dev->flags);
+		} else {
+			dev->f_tx = uitmp;
+			set_bit(TX_RF_FREQUENCY, &dev->flags);
+		}
 	} else {
 		ret = -EINVAL;
 		goto err;
@@ -912,22 +1132,32 @@ static int hackrf_g_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *f)
 {
 	struct hackrf_dev *dev = video_drvdata(file);
+	struct usb_interface *intf = dev->intf;
+	struct video_device *vdev = video_devdata(file);
 	int ret;
 
 	dev_dbg(dev->dev, "tuner=%d type=%d\n", f->tuner, f->type);
 
 	if (f->tuner == 0) {
 		f->type = V4L2_TUNER_ADC;
-		f->frequency = dev->f_adc;
-		ret = 0;
+		if (vdev->vfl_dir == VFL_DIR_RX)
+			f->frequency = dev->f_adc;
+		else
+			f->frequency = dev->f_dac;
 	} else if (f->tuner == 1) {
 		f->type = V4L2_TUNER_RF;
-		f->frequency = dev->f_rf;
-		ret = 0;
+		if (vdev->vfl_dir == VFL_DIR_RX)
+			f->frequency = dev->f_rx;
+		else
+			f->frequency = dev->f_tx;
 	} else {
 		ret = -EINVAL;
+		goto err;
 	}
 
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -941,17 +1171,17 @@ static int hackrf_enum_freq_bands(struct file *file, void *priv,
 			band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
-		if (band->index >= ARRAY_SIZE(bands_adc)) {
+		if (band->index >= ARRAY_SIZE(bands_adc_dac)) {
 			ret = -EINVAL;
 		} else {
-			*band = bands_adc[band->index];
+			*band = bands_adc_dac[band->index];
 			ret = 0;
 		}
 	} else if (band->tuner == 1) {
-		if (band->index >= ARRAY_SIZE(bands_rf)) {
+		if (band->index >= ARRAY_SIZE(bands_rx_tx)) {
 			ret = -EINVAL;
 		} else {
-			*band = bands_rf[band->index];
+			*band = bands_rx_tx[band->index];
 			ret = 0;
 		}
 	} else {
@@ -969,6 +1199,11 @@ static const struct v4l2_ioctl_ops hackrf_ioctl_ops = {
 	.vidioc_enum_fmt_sdr_cap  = hackrf_enum_fmt_sdr_cap,
 	.vidioc_try_fmt_sdr_cap   = hackrf_try_fmt_sdr_cap,
 
+	.vidioc_s_fmt_sdr_out     = hackrf_s_fmt_sdr_cap,
+	.vidioc_g_fmt_sdr_out     = hackrf_g_fmt_sdr_cap,
+	.vidioc_enum_fmt_sdr_out  = hackrf_enum_fmt_sdr_cap,
+	.vidioc_try_fmt_sdr_out   = hackrf_try_fmt_sdr_cap,
+
 	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
 	.vidioc_prepare_buf       = vb2_ioctl_prepare_buf,
@@ -982,6 +1217,9 @@ static const struct v4l2_ioctl_ops hackrf_ioctl_ops = {
 	.vidioc_s_tuner           = hackrf_s_tuner,
 	.vidioc_g_tuner           = hackrf_g_tuner,
 
+	.vidioc_s_modulator       = hackrf_s_modulator,
+	.vidioc_g_modulator       = hackrf_g_modulator,
+
 	.vidioc_s_frequency       = hackrf_s_frequency,
 	.vidioc_g_frequency       = hackrf_g_frequency,
 	.vidioc_enum_freq_bands   = hackrf_enum_freq_bands,
@@ -996,6 +1234,7 @@ static const struct v4l2_file_operations hackrf_fops = {
 	.open                     = v4l2_fh_open,
 	.release                  = vb2_fop_release,
 	.read                     = vb2_fop_read,
+	.write                    = vb2_fop_write,
 	.poll                     = vb2_fop_poll,
 	.mmap                     = vb2_fop_mmap,
 	.unlocked_ioctl           = video_ioctl2,
@@ -1010,17 +1249,22 @@ static struct video_device hackrf_template = {
 
 static void hackrf_video_release(struct v4l2_device *v)
 {
-	struct hackrf_dev *dev = container_of(v, struct hackrf_dev, v4l2_dev);
+	struct hackrf_dev *dev = container_of(v, struct hackrf_dev,
+					      rx_v4l2_dev);
+
+	dev_dbg(dev->dev, "\n");
 
-	v4l2_ctrl_handler_free(&dev->hdl);
-	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_ctrl_handler_free(&dev->rx_ctrl_handler);
+	v4l2_ctrl_handler_free(&dev->tx_ctrl_handler);
+	v4l2_device_unregister(&dev->tx_v4l2_dev);
+	v4l2_device_unregister(&dev->rx_v4l2_dev);
 	kfree(dev);
 }
 
-static int hackrf_s_ctrl(struct v4l2_ctrl *ctrl)
+static int hackrf_s_ctrl_rx(struct v4l2_ctrl *ctrl)
 {
 	struct hackrf_dev *dev = container_of(ctrl->handler,
-			struct hackrf_dev, hdl);
+			struct hackrf_dev, rx_ctrl_handler);
 	struct usb_interface *intf = dev->intf;
 	int ret;
 
@@ -1055,8 +1299,47 @@ err:
 	return ret;
 }
 
-static const struct v4l2_ctrl_ops hackrf_ctrl_ops = {
-	.s_ctrl = hackrf_s_ctrl,
+static int hackrf_s_ctrl_tx(struct v4l2_ctrl *ctrl)
+{
+	struct hackrf_dev *dev = container_of(ctrl->handler,
+			struct hackrf_dev, tx_ctrl_handler);
+	struct usb_interface *intf = dev->intf;
+	int ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
+	case V4L2_CID_RF_TUNER_BANDWIDTH:
+		set_bit(TX_BANDWIDTH, &dev->flags);
+		break;
+	case  V4L2_CID_RF_TUNER_LNA_GAIN:
+		set_bit(TX_LNA_GAIN, &dev->flags);
+		break;
+	case  V4L2_CID_RF_TUNER_RF_GAIN:
+		set_bit(TX_RF_GAIN, &dev->flags);
+		break;
+	default:
+		dev_dbg(&intf->dev, "unknown ctrl: id=%d name=%s\n",
+			ctrl->id, ctrl->name);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = hackrf_set_params(dev);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops hackrf_ctrl_ops_rx = {
+	.s_ctrl = hackrf_s_ctrl_rx,
+};
+
+static const struct v4l2_ctrl_ops hackrf_ctrl_ops_tx = {
+	.s_ctrl = hackrf_s_ctrl_tx,
 };
 
 static int hackrf_probe(struct usb_interface *intf,
@@ -1067,8 +1350,10 @@ static int hackrf_probe(struct usb_interface *intf,
 	u8 u8tmp, buf[BUF_SIZE];
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL)
-		return -ENOMEM;
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	mutex_init(&dev->v4l2_lock);
 	mutex_init(&dev->vb_queue_lock);
@@ -1077,10 +1362,16 @@ static int hackrf_probe(struct usb_interface *intf,
 	dev->intf = intf;
 	dev->dev = &intf->dev;
 	dev->udev = interface_to_usbdev(intf);
-	dev->f_adc = bands_adc[0].rangelow;
-	dev->f_rf = bands_rf[0].rangelow;
 	dev->pixelformat = formats[0].pixelformat;
 	dev->buffersize = formats[0].buffersize;
+	dev->f_adc = bands_adc_dac[0].rangelow;
+	dev->f_dac = bands_adc_dac[0].rangelow;
+	dev->f_rx = bands_rx_tx[0].rangelow;
+	dev->f_tx = bands_rx_tx[0].rangelow;
+	set_bit(RX_ADC_FREQUENCY, &dev->flags);
+	set_bit(TX_DAC_FREQUENCY, &dev->flags);
+	set_bit(RX_RF_FREQUENCY, &dev->flags);
+	set_bit(TX_RF_FREQUENCY, &dev->flags);
 
 	/* Detect device */
 	ret = hackrf_ctrl_msg(dev, CMD_BOARD_ID_READ, 0, 0, &u8tmp, 1);
@@ -1089,85 +1380,151 @@ static int hackrf_probe(struct usb_interface *intf,
 				buf, BUF_SIZE);
 	if (ret) {
 		dev_err(dev->dev, "Could not detect board\n");
-		goto err_free_mem;
+		goto err_kfree;
 	}
 
 	buf[BUF_SIZE - 1] = '\0';
-
 	dev_info(dev->dev, "Board ID: %02x\n", u8tmp);
 	dev_info(dev->dev, "Firmware version: %s\n", buf);
 
-	/* Init videobuf2 queue structure */
-	dev->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
-	dev->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
-	dev->vb_queue.drv_priv = dev;
-	dev->vb_queue.buf_struct_size = sizeof(struct hackrf_frame_buf);
-	dev->vb_queue.ops = &hackrf_vb2_ops;
-	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
-	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	ret = vb2_queue_init(&dev->vb_queue);
+	/* Init vb2 queue structure for receiver */
+	dev->rx_vb2_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
+	dev->rx_vb2_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	dev->rx_vb2_queue.ops = &hackrf_vb2_ops;
+	dev->rx_vb2_queue.mem_ops = &vb2_vmalloc_memops;
+	dev->rx_vb2_queue.drv_priv = dev;
+	dev->rx_vb2_queue.buf_struct_size = sizeof(struct hackrf_frame_buf);
+	dev->rx_vb2_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	ret = vb2_queue_init(&dev->rx_vb2_queue);
 	if (ret) {
-		dev_err(dev->dev, "Could not initialize vb2 queue\n");
-		goto err_free_mem;
+		dev_err(dev->dev, "Could not initialize rx vb2 queue\n");
+		goto err_kfree;
 	}
 
-	/* Init video_device structure */
-	dev->vdev = hackrf_template;
-	dev->vdev.queue = &dev->vb_queue;
-	dev->vdev.queue->lock = &dev->vb_queue_lock;
-	video_set_drvdata(&dev->vdev, dev);
-
-	/* Register the v4l2_device structure */
-	dev->v4l2_dev.release = hackrf_video_release;
-	ret = v4l2_device_register(&intf->dev, &dev->v4l2_dev);
+	/* Init vb2 queue structure for transmitter */
+	dev->tx_vb2_queue.type = V4L2_BUF_TYPE_SDR_OUTPUT;
+	dev->tx_vb2_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_WRITE;
+	dev->tx_vb2_queue.ops = &hackrf_vb2_ops;
+	dev->tx_vb2_queue.mem_ops = &vb2_vmalloc_memops;
+	dev->tx_vb2_queue.drv_priv = dev;
+	dev->tx_vb2_queue.buf_struct_size = sizeof(struct hackrf_frame_buf);
+	dev->tx_vb2_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	ret = vb2_queue_init(&dev->tx_vb2_queue);
 	if (ret) {
-		dev_err(dev->dev, "Failed to register v4l2-device (%d)\n", ret);
-		goto err_free_mem;
+		dev_err(dev->dev, "Could not initialize tx vb2 queue\n");
+		goto err_kfree;
 	}
 
-	/* Register controls */
-	v4l2_ctrl_handler_init(&dev->hdl, 5);
-	dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
-			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
-			V4L2_CID_RF_TUNER_BANDWIDTH,
-			1750000, 28000000, 50000, 1750000);
-	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
-	dev->rf_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
-			V4L2_CID_RF_TUNER_RF_GAIN, 0, 12, 12, 0);
-	dev->lna_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
-			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 40, 8, 0);
-	dev->if_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
-			V4L2_CID_RF_TUNER_IF_GAIN, 0, 62, 2, 0);
-	if (dev->hdl.error) {
-		ret = dev->hdl.error;
+	/* Register controls for receiver */
+	v4l2_ctrl_handler_init(&dev->rx_ctrl_handler, 5);
+	dev->rx_bandwidth_auto = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
+		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
+		0, 1, 0, 1);
+	dev->rx_bandwidth = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
+		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_BANDWIDTH,
+		1750000, 28000000, 50000, 1750000);
+	v4l2_ctrl_auto_cluster(2, &dev->rx_bandwidth_auto, 0, false);
+	dev->rx_rf_gain = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
+		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_RF_GAIN, 0, 12, 12, 0);
+	dev->rx_lna_gain = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
+		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_LNA_GAIN, 0, 40, 8, 0);
+	dev->rx_if_gain = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
+		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_IF_GAIN, 0, 62, 2, 0);
+	if (dev->rx_ctrl_handler.error) {
+		ret = dev->rx_ctrl_handler.error;
+		dev_err(dev->dev, "Could not initialize controls\n");
+		goto err_v4l2_ctrl_handler_free_rx;
+	}
+	v4l2_ctrl_handler_setup(&dev->rx_ctrl_handler);
+
+	/* Register controls for transmitter */
+	v4l2_ctrl_handler_init(&dev->tx_ctrl_handler, 4);
+	dev->tx_bandwidth_auto = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
+		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
+		0, 1, 0, 1);
+	dev->tx_bandwidth = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
+		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_BANDWIDTH,
+		1750000, 28000000, 50000, 1750000);
+	v4l2_ctrl_auto_cluster(2, &dev->tx_bandwidth_auto, 0, false);
+	dev->tx_lna_gain = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
+		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_LNA_GAIN, 0, 47, 1, 0);
+	dev->tx_rf_gain = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
+		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_RF_GAIN, 0, 15, 15, 0);
+	if (dev->tx_ctrl_handler.error) {
+		ret = dev->tx_ctrl_handler.error;
 		dev_err(dev->dev, "Could not initialize controls\n");
-		goto err_free_controls;
+		goto err_v4l2_ctrl_handler_free_tx;
 	}
+	v4l2_ctrl_handler_setup(&dev->tx_ctrl_handler);
 
-	v4l2_ctrl_handler_setup(&dev->hdl);
+	/* Register the v4l2_device structure for receiver */
+	dev->rx_v4l2_dev.release = hackrf_video_release;
+	dev->rx_v4l2_dev.ctrl_handler = &dev->rx_ctrl_handler;
+	ret = v4l2_device_register(&intf->dev, &dev->rx_v4l2_dev);
+	if (ret) {
+		dev_err(dev->dev, "Failed to register v4l2-device (%d)\n", ret);
+		goto err_v4l2_ctrl_handler_free_tx;
+	}
 
-	dev->v4l2_dev.ctrl_handler = &dev->hdl;
-	dev->vdev.v4l2_dev = &dev->v4l2_dev;
-	dev->vdev.lock = &dev->v4l2_lock;
+	/* Register the v4l2_device structure for transmitter */
+	/* release called by receiver v4l2 dev */
+	dev->tx_v4l2_dev.ctrl_handler = &dev->tx_ctrl_handler;
+	ret = v4l2_device_register(&intf->dev, &dev->tx_v4l2_dev);
+	if (ret) {
+		dev_err(dev->dev, "Failed to register v4l2-device (%d)\n", ret);
+		goto err_v4l2_device_unregister_rx;
+	}
 
-	ret = video_register_device(&dev->vdev, VFL_TYPE_SDR, -1);
+	/* Init video_device structure for receiver */
+	dev->rx_vdev = hackrf_template;
+	dev->rx_vdev.queue = &dev->rx_vb2_queue;
+	dev->rx_vdev.queue->lock = &dev->vb_queue_lock;
+	dev->rx_vdev.v4l2_dev = &dev->rx_v4l2_dev;
+	dev->rx_vdev.lock = &dev->v4l2_lock;
+	dev->rx_vdev.vfl_dir = VFL_DIR_RX;
+	video_set_drvdata(&dev->rx_vdev, dev);
+	ret = video_register_device(&dev->rx_vdev, VFL_TYPE_SDR, -1);
+	if (ret) {
+		dev_err(dev->dev,
+			"Failed to register as video device (%d)\n", ret);
+		goto err_v4l2_device_unregister_tx;
+	}
+	dev_info(dev->dev, "Registered as %s\n",
+		 video_device_node_name(&dev->rx_vdev));
+
+	/* Init video_device structure for transmitter */
+	dev->tx_vdev = hackrf_template;
+	dev->tx_vdev.queue = &dev->tx_vb2_queue;
+	dev->tx_vdev.queue->lock = &dev->vb_queue_lock;
+	dev->tx_vdev.v4l2_dev = &dev->tx_v4l2_dev;
+	dev->tx_vdev.lock = &dev->v4l2_lock;
+	dev->tx_vdev.vfl_dir = VFL_DIR_TX;
+	video_set_drvdata(&dev->tx_vdev, dev);
+	ret = video_register_device(&dev->tx_vdev, VFL_TYPE_SDR, -1);
 	if (ret) {
-		dev_err(dev->dev, "Failed to register as video device (%d)\n",
-				ret);
-		goto err_unregister_v4l2_dev;
+		dev_err(dev->dev,
+			"Failed to register as video device (%d)\n", ret);
+		goto err_video_unregister_device_rx;
 	}
 	dev_info(dev->dev, "Registered as %s\n",
-			video_device_node_name(&dev->vdev));
+		 video_device_node_name(&dev->tx_vdev));
+
 	dev_notice(dev->dev, "SDR API is still slightly experimental and functionality changes may follow\n");
 	return 0;
-
-err_free_controls:
-	v4l2_ctrl_handler_free(&dev->hdl);
-err_unregister_v4l2_dev:
-	v4l2_device_unregister(&dev->v4l2_dev);
-err_free_mem:
+err_video_unregister_device_rx:
+	video_unregister_device(&dev->rx_vdev);
+err_v4l2_device_unregister_tx:
+	v4l2_device_unregister(&dev->tx_v4l2_dev);
+err_v4l2_device_unregister_rx:
+	v4l2_device_unregister(&dev->rx_v4l2_dev);
+err_v4l2_ctrl_handler_free_tx:
+	v4l2_ctrl_handler_free(&dev->tx_ctrl_handler);
+err_v4l2_ctrl_handler_free_rx:
+	v4l2_ctrl_handler_free(&dev->rx_ctrl_handler);
+err_kfree:
 	kfree(dev);
+err:
+	dev_dbg(dev->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-- 
http://palosaari.fi/

