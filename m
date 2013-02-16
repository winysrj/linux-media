Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:54442 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab3BPVZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 16:25:48 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] redrat3: remove memcpys and fix unaligned memory access
Date: Sat, 16 Feb 2013 21:25:44 +0000
Message-Id: <6e51e6a63379f58bbd47de318c550b7d8b9b6d39.1361020108.git.sean@mess.org>
In-Reply-To: <cover.1361020108.git.sean@mess.org>
References: <cover.1361020108.git.sean@mess.org>
In-Reply-To: <cover.1361020108.git.sean@mess.org>
References: <cover.1361020108.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In stead of doing a memcpy from #defined offset, declare structs which
describe the incoming and outgoing data accurately.

Tested on first generation RedRat.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c |  351 +++++++++++++-------------------------------
 1 files changed, 103 insertions(+), 248 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 842bdcd..ec655b8 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -45,6 +45,7 @@
  *
  */
 
+#include <asm/unaligned.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -129,25 +130,11 @@ static int debug;
 /* USB bulk-in IR data endpoint address */
 #define RR3_BULK_IN_EP_ADDR	0x82
 
-/* Raw Modulated signal data value offsets */
-#define RR3_PAUSE_OFFSET	0
-#define RR3_FREQ_COUNT_OFFSET	4
-#define RR3_NUM_PERIOD_OFFSET	6
-#define RR3_MAX_LENGTHS_OFFSET	8
-#define RR3_NUM_LENGTHS_OFFSET	9
-#define RR3_MAX_SIGS_OFFSET	10
-#define RR3_NUM_SIGS_OFFSET	12
-#define RR3_REPEATS_OFFSET	14
-
 /* Size of the fixed-length portion of the signal */
-#define RR3_HEADER_LENGTH	15
 #define RR3_DRIVER_MAXLENS	128
 #define RR3_MAX_SIG_SIZE	512
-#define RR3_MAX_BUF_SIZE	\
-	((2 * RR3_HEADER_LENGTH) + RR3_DRIVER_MAXLENS + RR3_MAX_SIG_SIZE)
 #define RR3_TIME_UNIT		50
 #define RR3_END_OF_SIGNAL	0x7f
-#define RR3_TX_HEADER_OFFSET	4
 #define RR3_TX_TRAILER_LEN	2
 #define RR3_RX_MIN_TIMEOUT	5
 #define RR3_RX_MAX_TIMEOUT	2000
@@ -159,6 +146,32 @@ static int debug;
 #define USB_RR3USB_PRODUCT_ID	0x0001
 #define USB_RR3IIUSB_PRODUCT_ID	0x0005
 
+struct redrat3_header {
+	__be16 length;
+	__be16 transfer_type;
+} __packed;
+
+/* sending and receiving irdata */
+struct redrat3_irdata {
+	struct redrat3_header header;
+	__be32 pause;
+	__be16 mod_freq_count;
+	__be16 num_periods;
+	__u8 max_lengths;
+	__u8 no_lengths;
+	__be16 max_sig_size;
+	__be16 sig_size;
+	__u8 no_repeats;
+	__be16 lens[RR3_DRIVER_MAXLENS]; /* not aligned */
+	__u8 sigdata[RR3_MAX_SIG_SIZE];
+} __packed;
+
+/* firmware errors */
+struct redrat3_error {
+	struct redrat3_header header;
+	__be16 fw_error;
+} __packed;
+
 /* table of devices that work with this driver */
 static struct usb_device_id redrat3_dev_table[] = {
 	/* Original version of the RedRat3 */
@@ -180,7 +193,7 @@ struct redrat3_dev {
 	/* the receive endpoint */
 	struct usb_endpoint_descriptor *ep_in;
 	/* the buffer to receive data */
-	unsigned char *bulk_in_buf;
+	void *bulk_in_buf;
 	/* urb used to read ir data */
 	struct urb *read_urb;
 
@@ -205,69 +218,15 @@ struct redrat3_dev {
 	bool transmitting;
 
 	/* store for current packet */
-	char pbuf[RR3_MAX_BUF_SIZE];
-	u16 pktlen;
-	u16 pkttype;
+	struct redrat3_irdata irdata;
 	u16 bytes_read;
-	char *datap;
 
 	u32 carrier;
 
-	char name[128];
+	char name[64];
 	char phys[64];
 };
 
-/* All incoming data buffers adhere to a very specific data format */
-struct redrat3_signal_header {
-	u16 length;	/* Length of data being transferred */
-	u16 transfer_type; /* Type of data transferred */
-	u32 pause;	/* Pause between main and repeat signals */
-	u16 mod_freq_count; /* Value of timer on mod. freq. measurement */
-	u16 no_periods;	/* No. of periods over which mod. freq. is measured */
-	u8 max_lengths;	/* Max no. of lengths (i.e. size of array) */
-	u8 no_lengths;	/* Actual no. of elements in lengths array */
-	u16 max_sig_size; /* Max no. of values in signal data array */
-	u16 sig_size;	/* Acuto no. of values in signal data array */
-	u8 no_repeats;	/* No. of repeats of repeat signal section */
-	/* Here forward is the lengths and signal data */
-};
-
-static void redrat3_dump_signal_header(struct redrat3_signal_header *header)
-{
-	pr_info("%s:\n", __func__);
-	pr_info(" * length: %u, transfer_type: 0x%02x\n",
-		header->length, header->transfer_type);
-	pr_info(" * pause: %u, freq_count: %u, no_periods: %u\n",
-		header->pause, header->mod_freq_count, header->no_periods);
-	pr_info(" * lengths: %u (max: %u)\n",
-		header->no_lengths, header->max_lengths);
-	pr_info(" * sig_size: %u (max: %u)\n",
-		header->sig_size, header->max_sig_size);
-	pr_info(" * repeats: %u\n", header->no_repeats);
-}
-
-static void redrat3_dump_signal_data(char *buffer, u16 len)
-{
-	int offset, i;
-	char *data_vals;
-
-	pr_info("%s:", __func__);
-
-	offset = RR3_TX_HEADER_OFFSET + RR3_HEADER_LENGTH
-		 + (RR3_DRIVER_MAXLENS * sizeof(u16));
-
-	/* read RR3_DRIVER_MAXLENS from ctrl msg */
-	data_vals = buffer + offset;
-
-	for (i = 0; i < len; i++) {
-		if (i % 10 == 0)
-			pr_cont("\n * ");
-		pr_cont("%02x ", *data_vals++);
-	}
-
-	pr_cont("\n");
-}
-
 /*
  * redrat3_issue_async
  *
@@ -349,13 +308,14 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 	}
 }
 
-static u32 redrat3_val_to_mod_freq(struct redrat3_signal_header *ph)
+static u32 redrat3_val_to_mod_freq(struct redrat3_irdata *irdata)
 {
 	u32 mod_freq = 0;
+	u16 mod_freq_count = be16_to_cpu(irdata->mod_freq_count);
 
-	if (ph->mod_freq_count != 0)
-		mod_freq = (RR3_CLK * ph->no_periods) /
-				(ph->mod_freq_count * RR3_CLK_PER_COUNT);
+	if (mod_freq_count != 0)
+		mod_freq = (RR3_CLK * be16_to_cpu(irdata->num_periods)) /
+			(mod_freq_count * RR3_CLK_PER_COUNT);
 
 	return mod_freq;
 }
@@ -407,16 +367,11 @@ static void redrat3_rx_timeout(unsigned long data)
 static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
-	struct redrat3_signal_header header;
 	struct device *dev;
 	int i, trailer = 0;
+	unsigned sig_size, single_len, offset, val;
 	unsigned long delay;
-	u32 mod_freq, single_len;
-	u16 *len_vals;
-	u8 *data_vals;
-	u32 tmp32;
-	u16 tmp16;
-	char *sig_data;
+	u32 mod_freq;
 
 	if (!rr3) {
 		pr_err("%s called with no context!\n", __func__);
@@ -426,57 +381,20 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	rr3_ftr(rr3->dev, "Entered %s\n", __func__);
 
 	dev = rr3->dev;
-	sig_data = rr3->pbuf;
-
-	header.length = rr3->pktlen;
-	header.transfer_type = rr3->pkttype;
-
-	/* Sanity check */
-	if (!(header.length >= RR3_HEADER_LENGTH))
-		dev_warn(dev, "read returned less than rr3 header len\n");
 
 	/* Make sure we reset the IR kfifo after a bit of inactivity */
 	delay = usecs_to_jiffies(rr3->hw_timeout);
 	mod_timer(&rr3->rx_timeout, jiffies + delay);
 
-	memcpy(&tmp32, sig_data + RR3_PAUSE_OFFSET, sizeof(tmp32));
-	header.pause = be32_to_cpu(tmp32);
-
-	memcpy(&tmp16, sig_data + RR3_FREQ_COUNT_OFFSET, sizeof(tmp16));
-	header.mod_freq_count = be16_to_cpu(tmp16);
-
-	memcpy(&tmp16, sig_data + RR3_NUM_PERIOD_OFFSET, sizeof(tmp16));
-	header.no_periods = be16_to_cpu(tmp16);
-
-	header.max_lengths = sig_data[RR3_MAX_LENGTHS_OFFSET];
-	header.no_lengths = sig_data[RR3_NUM_LENGTHS_OFFSET];
-
-	memcpy(&tmp16, sig_data + RR3_MAX_SIGS_OFFSET, sizeof(tmp16));
-	header.max_sig_size = be16_to_cpu(tmp16);
-
-	memcpy(&tmp16, sig_data + RR3_NUM_SIGS_OFFSET, sizeof(tmp16));
-	header.sig_size = be16_to_cpu(tmp16);
-
-	header.no_repeats= sig_data[RR3_REPEATS_OFFSET];
-
-	if (debug) {
-		redrat3_dump_signal_header(&header);
-		redrat3_dump_signal_data(sig_data, header.sig_size);
-	}
-
-	mod_freq = redrat3_val_to_mod_freq(&header);
+	mod_freq = redrat3_val_to_mod_freq(&rr3->irdata);
 	rr3_dbg(dev, "Got mod_freq of %u\n", mod_freq);
 
-	/* Here we pull out the 'length' values from the signal */
-	len_vals = (u16 *)(sig_data + RR3_HEADER_LENGTH);
-
-	data_vals = sig_data + RR3_HEADER_LENGTH +
-		    (header.max_lengths * sizeof(u16));
-
 	/* process each rr3 encoded byte into an int */
-	for (i = 0; i < header.sig_size; i++) {
-		u16 val = len_vals[data_vals[i]];
-		single_len = redrat3_len_to_us((u32)be16_to_cpu(val));
+	sig_size = be16_to_cpu(rr3->irdata.sig_size);
+	for (i = 0; i < sig_size; i++) {
+		offset = rr3->irdata.sigdata[i];
+		val = get_unaligned_be16(&rr3->irdata.lens[offset]);
+		single_len = redrat3_len_to_us(val);
 
 		/* we should always get pulse/space/pulse/space samples */
 		if (i % 2)
@@ -534,7 +452,7 @@ static u8 redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
 			__func__, res, *data);
 		res = -EIO;
 	} else
-		res = (u8)data[0];
+		res = data[0];
 
 	kfree(data);
 
@@ -704,79 +622,72 @@ static void redrat3_get_firmware_rev(struct redrat3_dev *rr3)
 
 static void redrat3_read_packet_start(struct redrat3_dev *rr3, int len)
 {
-	u16 tx_error;
-	u16 hdrlen;
+	struct redrat3_header *header = rr3->bulk_in_buf;
+	unsigned pktlen, pkttype;
 
 	rr3_ftr(rr3->dev, "Entering %s\n", __func__);
 
 	/* grab the Length and type of transfer */
-	memcpy(&(rr3->pktlen), (unsigned char *) rr3->bulk_in_buf,
-	       sizeof(rr3->pktlen));
-	memcpy(&(rr3->pkttype), ((unsigned char *) rr3->bulk_in_buf +
-		sizeof(rr3->pktlen)),
-	       sizeof(rr3->pkttype));
+	pktlen = be16_to_cpu(header->length);
+	pkttype = be16_to_cpu(header->transfer_type);
 
-	/*data needs conversion to know what its real values are*/
-	rr3->pktlen = be16_to_cpu(rr3->pktlen);
-	rr3->pkttype = be16_to_cpu(rr3->pkttype);
+	if (pktlen > sizeof(rr3->irdata)) {
+		dev_warn(rr3->dev, "packet length %u too large\n", pktlen);
+		return;
+	}
 
-	switch (rr3->pkttype) {
+	switch (pkttype) {
 	case RR3_ERROR:
-		memcpy(&tx_error, ((unsigned char *)rr3->bulk_in_buf
-			+ (sizeof(rr3->pktlen) + sizeof(rr3->pkttype))),
-		       sizeof(tx_error));
-		tx_error = be16_to_cpu(tx_error);
-		redrat3_dump_fw_error(rr3, tx_error);
+		if (len >= sizeof(struct redrat3_error)) {
+			struct redrat3_error *error = rr3->bulk_in_buf;
+			unsigned fw_error = be16_to_cpu(error->fw_error);
+			redrat3_dump_fw_error(rr3, fw_error);
+		}
 		break;
 
 	case RR3_MOD_SIGNAL_IN:
-		hdrlen = sizeof(rr3->pktlen) + sizeof(rr3->pkttype);
+		memcpy(&rr3->irdata, rr3->bulk_in_buf, len);
 		rr3->bytes_read = len;
-		rr3->bytes_read -= hdrlen;
-		rr3->datap = &(rr3->pbuf[0]);
-
-		memcpy(rr3->datap, ((unsigned char *)rr3->bulk_in_buf + hdrlen),
-		       rr3->bytes_read);
-		rr3->datap += rr3->bytes_read;
 		rr3_dbg(rr3->dev, "bytes_read %d, pktlen %d\n",
-			rr3->bytes_read, rr3->pktlen);
+			rr3->bytes_read, pktlen);
 		break;
 
 	default:
-		rr3_dbg(rr3->dev, "ignoring packet with type 0x%02x, "
-			"len of %d, 0x%02x\n", rr3->pkttype, len, rr3->pktlen);
+		rr3_dbg(rr3->dev, "ignoring packet with type 0x%02x, len of %d, 0x%02x\n",
+						pkttype, len, pktlen);
 		break;
 	}
 }
 
 static void redrat3_read_packet_continue(struct redrat3_dev *rr3, int len)
 {
+	void *irdata = &rr3->irdata;
+
 	rr3_ftr(rr3->dev, "Entering %s\n", __func__);
 
-	memcpy(rr3->datap, (unsigned char *)rr3->bulk_in_buf, len);
-	rr3->datap += len;
+	if (len + rr3->bytes_read > sizeof(rr3->irdata)) {
+		dev_warn(rr3->dev, "too much data for packet\n");
+		rr3->bytes_read = 0;
+		return;
+	}
+
+	memcpy(irdata + rr3->bytes_read, rr3->bulk_in_buf, len);
 
 	rr3->bytes_read += len;
-	rr3_dbg(rr3->dev, "bytes_read %d, pktlen %d\n",
-		rr3->bytes_read, rr3->pktlen);
+	rr3_dbg(rr3->dev, "bytes_read %d, pktlen %d\n", rr3->bytes_read,
+				 be16_to_cpu(rr3->irdata.header.length));
 }
 
 /* gather IR data from incoming urb, process it when we have enough */
 static int redrat3_get_ir_data(struct redrat3_dev *rr3, int len)
 {
 	struct device *dev = rr3->dev;
+	unsigned pkttype;
 	int ret = 0;
 
 	rr3_ftr(dev, "Entering %s\n", __func__);
 
-	if (rr3->pktlen > RR3_MAX_BUF_SIZE) {
-		dev_err(rr3->dev, "error: packet larger than buffer\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if ((rr3->bytes_read == 0) &&
-	    (len >= (sizeof(rr3->pkttype) + sizeof(rr3->pktlen)))) {
+	if (rr3->bytes_read == 0 && len >= sizeof(struct redrat3_header)) {
 		redrat3_read_packet_start(rr3, len);
 	} else if (rr3->bytes_read != 0) {
 		redrat3_read_packet_continue(rr3, len);
@@ -786,26 +697,20 @@ static int redrat3_get_ir_data(struct redrat3_dev *rr3, int len)
 		goto out;
 	}
 
-	if (rr3->bytes_read > rr3->pktlen) {
-		dev_err(dev, "bytes_read (%d) greater than pktlen (%d)\n",
-			rr3->bytes_read, rr3->pktlen);
-		ret = -EINVAL;
-		goto out;
-	} else if (rr3->bytes_read < rr3->pktlen)
+	if (rr3->bytes_read < be16_to_cpu(rr3->irdata.header.length))
 		/* we're still accumulating data */
 		return 0;
 
 	/* if we get here, we've got IR data to decode */
-	if (rr3->pkttype == RR3_MOD_SIGNAL_IN)
+	pkttype = be16_to_cpu(rr3->irdata.header.transfer_type);
+	if (pkttype == RR3_MOD_SIGNAL_IN)
 		redrat3_process_ir_data(rr3);
 	else
-		rr3_dbg(dev, "discarding non-signal data packet "
-			"(type 0x%02x)\n", rr3->pkttype);
+		rr3_dbg(dev, "discarding non-signal data packet (type 0x%02x)\n",
+								pkttype);
 
 out:
 	rr3->bytes_read = 0;
-	rr3->pktlen = 0;
-	rr3->pkttype = 0;
 	return ret;
 }
 
@@ -846,8 +751,6 @@ static void redrat3_handle_async(struct urb *urb)
 	default:
 		dev_warn(rr3->dev, "Error: urb status = %d\n", urb->status);
 		rr3->bytes_read = 0;
-		rr3->pktlen = 0;
-		rr3->pkttype = 0;
 		break;
 	}
 }
@@ -873,7 +776,7 @@ static u16 mod_freq_to_val(unsigned int mod_freq)
 	int mult = 6000000;
 
 	/* Clk used in mod. freq. generation is CLK24/4. */
-	return (u16)(65536 - (mult / mod_freq));
+	return 65536 - (mult / mod_freq);
 }
 
 static int redrat3_set_tx_carrier(struct rc_dev *rcdev, u32 carrier)
@@ -895,16 +798,11 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 {
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
-	struct redrat3_signal_header header;
-	int i, ret, ret_len, offset;
+	struct redrat3_irdata *irdata = NULL;
+	int i, ret, ret_len;
 	int lencheck, cur_sample_len, pipe;
-	char *buffer = NULL, *sigdata = NULL;
 	int *sample_lens = NULL;
-	u32 tmpi;
-	u16 tmps;
-	u8 *datap;
 	u8 curlencheck = 0;
-	u16 *lengths_ptr;
 	int sendbuf_len;
 
 	rr3_ftr(dev, "Entering %s\n", __func__);
@@ -926,8 +824,8 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		goto out;
 	}
 
-	sigdata = kzalloc((count + RR3_TX_TRAILER_LEN), GFP_KERNEL);
-	if (!sigdata) {
+	irdata = kzalloc(sizeof(*irdata), GFP_KERNEL);
+	if (!irdata) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -950,83 +848,41 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 				/* now convert the value to a proper
 				 * rr3 value.. */
 				sample_lens[curlencheck] = cur_sample_len;
+				put_unaligned_be16(cur_sample_len,
+						&irdata->lens[curlencheck]);
 				curlencheck++;
 			} else {
 				count = i - 1;
 				break;
 			}
 		}
-		sigdata[i] = lencheck;
+		irdata->sigdata[i] = lencheck;
 	}
 
-	sigdata[count] = RR3_END_OF_SIGNAL;
-	sigdata[count + 1] = RR3_END_OF_SIGNAL;
-
-	offset = RR3_TX_HEADER_OFFSET;
-	sendbuf_len = RR3_HEADER_LENGTH + (sizeof(u16) * RR3_DRIVER_MAXLENS)
-			+ count + RR3_TX_TRAILER_LEN + offset;
-
-	buffer = kzalloc(sendbuf_len, GFP_KERNEL);
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	irdata->sigdata[count] = RR3_END_OF_SIGNAL;
+	irdata->sigdata[count + 1] = RR3_END_OF_SIGNAL;
 
+	sendbuf_len = offsetof(struct redrat3_irdata,
+					sigdata[count + RR3_TX_TRAILER_LEN]);
 	/* fill in our packet header */
-	header.length = sendbuf_len - offset;
-	header.transfer_type = RR3_MOD_SIGNAL_OUT;
-	header.pause = redrat3_len_to_us(100);
-	header.mod_freq_count = mod_freq_to_val(rr3->carrier);
-	header.no_periods = 0; /* n/a to transmit */
-	header.max_lengths = RR3_DRIVER_MAXLENS;
-	header.no_lengths = curlencheck;
-	header.max_sig_size = RR3_MAX_SIG_SIZE;
-	header.sig_size = count + RR3_TX_TRAILER_LEN;
-	/* we currently rely on repeat handling in the IR encoding source */
-	header.no_repeats = 0;
-
-	tmps = cpu_to_be16(header.length);
-	memcpy(buffer, &tmps, 2);
-
-	tmps = cpu_to_be16(header.transfer_type);
-	memcpy(buffer + 2, &tmps, 2);
-
-	tmpi = cpu_to_be32(header.pause);
-	memcpy(buffer + offset, &tmpi, sizeof(tmpi));
-
-	tmps = cpu_to_be16(header.mod_freq_count);
-	memcpy(buffer + offset + RR3_FREQ_COUNT_OFFSET, &tmps, 2);
-
-	buffer[offset + RR3_NUM_LENGTHS_OFFSET] = header.no_lengths;
-
-	tmps = cpu_to_be16(header.sig_size);
-	memcpy(buffer + offset + RR3_NUM_SIGS_OFFSET, &tmps, 2);
-
-	buffer[offset + RR3_REPEATS_OFFSET] = header.no_repeats;
-
-	lengths_ptr = (u16 *)(buffer + offset + RR3_HEADER_LENGTH);
-	for (i = 0; i < curlencheck; ++i)
-		lengths_ptr[i] = cpu_to_be16(sample_lens[i]);
-
-	datap = (u8 *)(buffer + offset + RR3_HEADER_LENGTH +
-			    (sizeof(u16) * RR3_DRIVER_MAXLENS));
-	memcpy(datap, sigdata, (count + RR3_TX_TRAILER_LEN));
-
-	if (debug) {
-		redrat3_dump_signal_header(&header);
-		redrat3_dump_signal_data(buffer, header.sig_size);
-	}
+	irdata->header.length = cpu_to_be16(sendbuf_len -
+						sizeof(struct redrat3_header));
+	irdata->header.transfer_type = cpu_to_be16(RR3_MOD_SIGNAL_OUT);
+	irdata->pause = cpu_to_be32(redrat3_len_to_us(100));
+	irdata->mod_freq_count = cpu_to_be16(mod_freq_to_val(rr3->carrier));
+	irdata->no_lengths = curlencheck;
+	irdata->sig_size = cpu_to_be16(count + RR3_TX_TRAILER_LEN);
 
 	pipe = usb_sndbulkpipe(rr3->udev, rr3->ep_out->bEndpointAddress);
-	tmps = usb_bulk_msg(rr3->udev, pipe, buffer,
+	ret = usb_bulk_msg(rr3->udev, pipe, irdata,
 			    sendbuf_len, &ret_len, 10 * HZ);
-	rr3_dbg(dev, "sent %d bytes, (ret %d)\n", ret_len, tmps);
+	rr3_dbg(dev, "sent %d bytes, (ret %d)\n", ret_len, ret);
 
 	/* now tell the hardware to transmit what we sent it */
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
 	ret = usb_control_msg(rr3->udev, pipe, RR3_TX_SEND_SIGNAL,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0, 0, buffer, 2, HZ * 10);
+			      0, 0, irdata, 2, HZ * 10);
 
 	if (ret < 0)
 		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
@@ -1035,8 +891,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 
 out:
 	kfree(sample_lens);
-	kfree(buffer);
-	kfree(sigdata);
+	kfree(irdata);
 
 	rr3->transmitting = false;
 	/* rr3 re-enables rc detector because it was enabled before */
-- 
1.7.2.5

