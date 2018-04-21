Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40039 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752771AbeDUJt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 05:49:58 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: rc: imon decoder: support the stick
Date: Sat, 21 Apr 2018 10:49:57 +0100
Message-Id: <20180421094957.25387-2-sean@mess.org>
In-Reply-To: <20180421094957.25387-1-sean@mess.org>
References: <20180421094957.25387-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The iMON PAD controller has a analog stick, which can be switched to
keyboard mode (cursor keys) or work as a crappy mouse.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-imon-decoder.c | 128 ++++++++++++++++++++++++++++++++++++-
 drivers/media/rc/rc-core-priv.h    |   3 +
 2 files changed, 128 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ir-imon-decoder.c b/drivers/media/rc/ir-imon-decoder.c
index 52ea3b2fda74..c69906ba1a90 100644
--- a/drivers/media/rc/ir-imon-decoder.c
+++ b/drivers/media/rc/ir-imon-decoder.c
@@ -31,9 +31,62 @@ enum imon_state {
 	STATE_INACTIVE,
 	STATE_BIT_CHK,
 	STATE_BIT_START,
-	STATE_FINISHED
+	STATE_FINISHED,
+	STATE_ERROR,
 };
 
+static void ir_imon_decode_scancode(struct rc_dev *dev)
+{
+	struct imon_dec *imon = &dev->raw->imon;
+
+	/* Keyboard/Mouse toggle */
+	if (imon->bits == 0x299115b7) {
+		imon->stick_keyboard = !imon->stick_keyboard;
+		return;
+	}
+
+	if ((imon->bits & 0xfc0000ff) == 0x680000b7) {
+		s8 rel_x, rel_y;
+		u8 buf;
+
+		buf = imon->bits >> 16;
+		rel_x = (buf & 0x08) | (buf & 0x10) >> 2 |
+			(buf & 0x20) >> 4 | (buf & 0x40) >> 6;
+		if (imon->bits & 0x02000000)
+			rel_x |= ~0x0f;
+		buf = imon->bits >> 8;
+		rel_y = (buf & 0x08) | (buf & 0x10) >> 2 |
+			(buf & 0x20) >> 4 | (buf & 0x40) >> 6;
+		if (imon->bits & 0x01000000)
+			rel_y |= ~0x0f;
+
+		if (rel_x && rel_y && imon->stick_keyboard) {
+			if (abs(rel_y) > abs(rel_x))
+				imon->bits = rel_y > 0 ? 0x289515b7 :
+					     0x2aa515b7;
+			else
+				imon->bits = rel_x > 0 ? 0x2ba515b7 :
+					     0x29a515b7;
+		}
+
+		if (!imon->stick_keyboard) {
+			input_event(imon->idev, EV_MSC, MSC_SCAN, imon->bits);
+
+			input_report_rel(imon->idev, REL_X, rel_x);
+			input_report_rel(imon->idev, REL_Y, rel_y);
+
+			input_report_key(imon->idev, BTN_LEFT,
+					 (imon->bits & 0x00010000) != 0);
+			input_report_key(imon->idev, BTN_RIGHT,
+					 (imon->bits & 0x00040000) != 0);
+			input_sync(imon->idev);
+			return;
+		}
+	}
+
+	rc_keydown(dev, RC_PROTO_IMON, imon->bits, 0);
+}
+
 /**
  * ir_imon_decode() - Decode one iMON pulse or space
  * @dev:	the struct rc_dev descriptor of the device
@@ -56,6 +109,22 @@ static int ir_imon_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		data->state, data->count, TO_US(ev.duration),
 		TO_STR(ev.pulse));
 
+	/*
+	 * Since iMON protocol is a series of bits, if at any point
+	 * we encounter an error, make sure that any remaining bits
+	 * aren't parsed as a scancode made up of less bits.
+	 *
+	 * Note that if the stick is held, then the remote repeats
+	 * the scancode with about 12ms between them. So, make sure
+	 * we have at least 10ms of space after an error. That way,
+	 * we're at a new scancode.
+	 */
+	if (data->state == STATE_ERROR) {
+		if (!ev.pulse && ev.duration > MS_TO_NS(10))
+			data->state = STATE_INACTIVE;
+		return 0;
+	}
+
 	for (;;) {
 		if (!geq_margin(ev.duration, IMON_UNIT, IMON_UNIT / 2))
 			return 0;
@@ -95,7 +164,7 @@ static int ir_imon_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		case STATE_FINISHED:
 			if (ev.pulse)
 				goto err_out;
-			rc_keydown(dev, RC_PROTO_IMON, data->bits, 0);
+			ir_imon_decode_scancode(dev);
 			data->state = STATE_INACTIVE;
 			break;
 		}
@@ -107,7 +176,7 @@ static int ir_imon_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		data->state, data->count, TO_US(ev.duration),
 		TO_STR(ev.pulse));
 
-	data->state = STATE_INACTIVE;
+	data->state = STATE_ERROR;
 
 	return -EINVAL;
 }
@@ -165,11 +234,64 @@ static int ir_imon_encode(enum rc_proto protocol, u32 scancode,
 	return e - events;
 }
 
+static int ir_imon_register(struct rc_dev *dev)
+{
+	struct input_dev *idev;
+	struct imon_dec *imon = &dev->raw->imon;
+	int ret;
+
+	idev = input_allocate_device();
+	if (!idev)
+		return -ENOMEM;
+
+	snprintf(imon->name, sizeof(imon->name),
+		 "iMON PAD Stick (%s)", dev->device_name);
+	idev->name = imon->name;
+	idev->phys = dev->input_phys;
+
+	/* Mouse bits */
+	set_bit(EV_REL, idev->evbit);
+	set_bit(EV_KEY, idev->evbit);
+	set_bit(REL_X, idev->relbit);
+	set_bit(REL_Y, idev->relbit);
+	set_bit(BTN_LEFT, idev->keybit);
+	set_bit(BTN_RIGHT, idev->keybit);
+
+	/* Report scancodes too */
+	set_bit(EV_MSC, idev->evbit);
+	set_bit(MSC_SCAN, idev->mscbit);
+
+	input_set_drvdata(idev, imon);
+
+	ret = input_register_device(idev);
+	if (ret < 0) {
+		input_free_device(idev);
+		return -EIO;
+	}
+
+	imon->idev = idev;
+	imon->stick_keyboard = false;
+
+	return 0;
+}
+
+static int ir_imon_unregister(struct rc_dev *dev)
+{
+	struct imon_dec *imon = &dev->raw->imon;
+
+	input_unregister_device(imon->idev);
+	imon->idev = NULL;
+
+	return 0;
+}
+
 static struct ir_raw_handler imon_handler = {
 	.protocols	= RC_PROTO_BIT_IMON,
 	.decode		= ir_imon_decode,
 	.encode		= ir_imon_encode,
 	.carrier	= 38000,
+	.raw_register	= ir_imon_register,
+	.raw_unregister	= ir_imon_unregister,
 	.min_timeout	= IMON_UNIT * IMON_BITS * 2,
 };
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 07ba77fe6a3b..bbb9a7eb6b63 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -126,6 +126,9 @@ struct ir_raw_event_ctrl {
 		int count;
 		int last_chk;
 		unsigned int bits;
+		bool stick_keyboard;
+		struct input_dev *idev;
+		char name[64];
 	} imon;
 };
 
-- 
2.14.3
