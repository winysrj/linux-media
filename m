Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50790 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbaCNXHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:08 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so2748900wgg.30
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:07:07 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2 9/9] rc: nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback
Date: Fri, 14 Mar 2014 23:04:19 +0000
Message-Id: <1394838259-14260-10-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Seppälä <a.seppala@gmail.com>

Nuvoton-cir utilizes the encoding capabilities of rc-core to convert
scancodes from user space to pulse/space format understood by the
underlying hardware.

Converted samples are then written to the wakeup fifo along with other
necessary configuration to enable wake up functionality.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
Please note this patch is only build tested.

Changes in v2 (James Hogan):
 - Handle new -ENOBUFS when IR encoding buffer isn't long enough and
   reduce buffer size to the size of the wake fifo so that time isn't
   wasted processing encoded IR events that will be discarded. Also only
   discard the last event if the encoded data is complete.
 - Change reference to rc_dev::enabled_protocols to
   enabled_protocols[type] since it has been converted to an array.
 - Fix IR encoding buffer loop condition to be i < ret rather than i <=
   ret. The return value of ir_raw_encode_scancode is the number of
   events rather than the last event.
 - Set encode_wakeup so that the set of allowed wakeup protocols matches
   the set of raw IR encoders.
---
 drivers/media/rc/nuvoton-cir.c | 123 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |   1 +
 include/media/rc-core.h        |   1 +
 3 files changed, 125 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index d244e1a..ec8f4fc 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -527,6 +527,127 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static int nvt_write_wakeup_codes(struct rc_dev *dev,
+				  const u8 *wakeup_sample_buf, int count)
+{
+	int i = 0;
+	u8 reg, reg_learn_mode;
+	unsigned long flags;
+	struct nvt_dev *nvt = dev->priv;
+
+	nvt_dbg_wake("writing wakeup samples");
+
+	reg = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
+	reg_learn_mode = reg & ~CIR_WAKE_IRCON_MODE0;
+	reg_learn_mode |= CIR_WAKE_IRCON_MODE1;
+
+	/* Lock the learn area to prevent racing with wake-isr */
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+
+	/* Enable fifo writes */
+	nvt_cir_wake_reg_write(nvt, reg_learn_mode, CIR_WAKE_IRCON);
+
+	/* Clear cir wake rx fifo */
+	nvt_clear_cir_wake_fifo(nvt);
+
+	if (count > WAKE_FIFO_LEN) {
+		nvt_dbg_wake("HW FIFO too small for all wake samples");
+		count = WAKE_FIFO_LEN;
+	}
+
+	if (count)
+		pr_info("Wake samples (%d) =", count);
+	else
+		pr_info("Wake sample fifo cleared");
+
+	/* Write wake samples to fifo */
+	for (i = 0; i < count; i++) {
+		pr_cont(" %02x", wakeup_sample_buf[i]);
+		nvt_cir_wake_reg_write(nvt, wakeup_sample_buf[i],
+				       CIR_WAKE_WR_FIFO_DATA);
+	}
+	pr_cont("\n");
+
+	/* Switch cir to wakeup mode and disable fifo writing */
+	nvt_cir_wake_reg_write(nvt, reg, CIR_WAKE_IRCON);
+
+	/* Set number of bytes needed for wake */
+	nvt_cir_wake_reg_write(nvt, count ? count :
+			       CIR_WAKE_FIFO_CMP_BYTES,
+			       CIR_WAKE_FIFO_CMP_DEEP);
+
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+	return 0;
+}
+
+static int nvt_ir_raw_set_filter(struct rc_dev *dev, enum rc_filter_type type,
+				 struct rc_scancode_filter *sc_filter)
+{
+	u8 *reg_buf;
+	u8 buf_val;
+	int i, ret, count;
+	unsigned int val;
+	struct ir_raw_event *raw;
+	bool complete;
+
+	/* Other types are not valid for nuvoton */
+	if (type != RC_FILTER_WAKEUP)
+		return -EINVAL;
+
+	/* Require both mask and data to be set before actually committing */
+	if (!sc_filter->mask || !sc_filter->data)
+		return 0;
+
+	raw = kmalloc(WAKE_FIFO_LEN * sizeof(*raw), GFP_KERNEL);
+	if (!raw)
+		return -ENOMEM;
+
+	ret = ir_raw_encode_scancode(dev->enabled_protocols[type], sc_filter,
+				     raw, WAKE_FIFO_LEN);
+	complete = (ret != -ENOBUFS);
+	if (!complete)
+		ret = WAKE_FIFO_LEN;
+	else if (ret < 0)
+		goto out_raw;
+
+	reg_buf = kmalloc(sizeof(*reg_buf) * WAKE_FIFO_LEN, GFP_KERNEL);
+	if (!reg_buf) {
+		ret = -ENOMEM;
+		goto out_raw;
+	}
+
+	/* Inspect the ir samples */
+	for (i = 0, count = 0; i < ret && count < WAKE_FIFO_LEN; ++i) {
+		val = NS_TO_US((raw[i]).duration) / SAMPLE_PERIOD;
+
+		/* Split too large values into several smaller ones */
+		while (val > 0 && count < WAKE_FIFO_LEN) {
+
+			/* Skip last value for better comparison tolerance */
+			if (complete && i == ret - 1 && val < BUF_LEN_MASK)
+				break;
+
+			/* Clamp values to BUF_LEN_MASK at most */
+			buf_val = (val > BUF_LEN_MASK) ? BUF_LEN_MASK : val;
+
+			reg_buf[count] = buf_val;
+			val -= buf_val;
+			if ((raw[i]).pulse)
+				reg_buf[count] |= BUF_PULSE_BIT;
+			count++;
+		}
+	}
+
+	ret = nvt_write_wakeup_codes(dev, reg_buf, count);
+
+	kfree(reg_buf);
+out_raw:
+	kfree(raw);
+
+	return ret;
+}
+
 /*
  * nvt_tx_ir
  *
@@ -1044,11 +1165,13 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
+	rdev->encode_wakeup = true;
 	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
+	rdev->s_filter = nvt_ir_raw_set_filter;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
 	rdev->input_phys = "nuvoton/cir0";
 	rdev->input_id.bustype = BUS_HOST;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index e1cf23c..9d0e161 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -63,6 +63,7 @@ static int debug;
  */
 #define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
+#define WAKE_FIFO_LEN 67
 
 struct nvt_dev {
 	struct pnp_dev *pdev;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 2d81d6c..80177da 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -271,6 +271,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 #define US_TO_NS(usec)		((usec) * 1000)
 #define MS_TO_US(msec)		((msec) * 1000)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
+#define NS_TO_US(nsec)		DIV_ROUND_UP(nsec, 1000L)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-- 
1.8.3.2

