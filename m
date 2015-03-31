Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36622 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbbCaRtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 13:49:10 -0400
Received: by lbbug6 with SMTP id ug6so18249618lbb.3
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2015 10:49:09 -0700 (PDT)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v3 7/7] rc: nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback
Date: Tue, 31 Mar 2015 20:48:12 +0300
Message-Id: <1427824092-23163-8-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nuvoton-cir utilizes the encoding capabilities of rc-core to convert
scancodes from user space to pulse/space format understood by the
underlying hardware.

Converted samples are then written to the wakeup fifo along with other
necessary configuration to enable wake up functionality.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james@albanarts.com>
Cc: Jarod Wilson <jarod@redhat.com>
---

Notes:
    Changes in v3:
     - Ported to apply against latest media-tree
     - Checkpatch.pl fixes
    
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

 drivers/media/rc/nuvoton-cir.c | 127 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |   1 +
 include/media/rc-core.h        |   1 +
 3 files changed, 129 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 9c2c863..6391d70 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -526,6 +526,130 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
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
+static int nvt_ir_raw_set_wakeup_filter(struct rc_dev *dev,
+					struct rc_scancode_filter *sc_filter)
+{
+	u8 *reg_buf;
+	u8 buf_val;
+	int i, ret, count;
+	unsigned int val;
+	struct ir_raw_event *raw;
+	bool complete;
+
+	/* Require both mask and data to be set before actually committing */
+	if (!sc_filter->mask || !sc_filter->data)
+		return 0;
+
+	raw = kmalloc_array(WAKE_FIFO_LEN, sizeof(*raw), GFP_KERNEL);
+	if (!raw)
+		return -ENOMEM;
+
+	ret = ir_raw_encode_scancode(dev->enabled_wakeup_protocols, sc_filter,
+				     raw, WAKE_FIFO_LEN);
+	complete = (ret != -ENOBUFS);
+	if (!complete)
+		ret = WAKE_FIFO_LEN;
+	else if (ret < 0)
+		goto out_raw;
+
+	reg_buf = kmalloc_array(WAKE_FIFO_LEN, sizeof(*reg_buf), GFP_KERNEL);
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
+/* Dummy implementation. nuvoton is agnostic to the protocol used */
+static int nvt_ir_raw_change_wakeup_protocol(struct rc_dev *dev,
+					     u64 *rc_type)
+{
+	return 0;
+}
+
 /*
  * nvt_tx_ir
  *
@@ -1043,11 +1167,14 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
+	rdev->encode_wakeup = true;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
+	rdev->s_wakeup_filter = nvt_ir_raw_set_wakeup_filter;
+	rdev->change_wakeup_protocol = nvt_ir_raw_change_wakeup_protocol;
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
index 9ae433c..f1cb9da 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -246,6 +246,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 #define US_TO_NS(usec)		((usec) * 1000)
 #define MS_TO_US(msec)		((msec) * 1000)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
+#define NS_TO_US(nsec)		DIV_ROUND_UP(nsec, 1000L)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-- 
2.0.5

