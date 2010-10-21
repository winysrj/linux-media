Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758476Ab0JUOKe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 10:10:34 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9LEAXPt026947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:10:34 -0400
Received: from pedra (vpn-225-164.phx2.redhat.com [10.3.225.164])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9LE9S5B022469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:10:32 -0400
Date: Thu, 21 Oct 2010 12:07:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] mceusb: Fix parser for Polaris
Message-ID: <20101021120748.47828273@pedra>
In-Reply-To: <cover.1287669886.git.mchehab@redhat.com>
References: <cover.1287669886.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a parser for polaris mce. On this device, sometimes, a control
data appears together with the IR data, causing problems at the parser.
Also, it signalizes the end of a data with a 0x80 value. The normal
parser would believe that this is a time with 0x1f size, but cx231xx
provides just one byte for it.

I'm not sure if the new parser would work for other devices (probably, it
will), but the better is to just write it as a new parser, to avoid breaking
support for other supported IR devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 609bf3d..7210760 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -265,6 +265,7 @@ struct mceusb_dev {
 		u32 connected:1;
 		u32 tx_mask_inverted:1;
 		u32 microsoft_gen1:1;
+		u32 is_polaris:1;
 		u32 reserved:29;
 	} flags;
 
@@ -697,6 +698,90 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
 	return carrier;
 }
 
+static void mceusb_parse_polaris(struct mceusb_dev *ir, int buf_len)
+{
+	struct ir_raw_event rawir;
+	int i;
+	u8 cmd;
+
+	while (i < buf_len) {
+		cmd = ir->buf_in[i];
+
+		/* Discard any non-IR cmd */
+
+		if ((cmd & 0xe0) >> 5 != 4) {
+			i++;
+			if (i >= buf_len)
+				return;
+
+			cmd = ir->buf_in[i];	/* sub cmd */
+			i++;
+			switch (cmd) {
+			case 0x08:
+			case 0x14:
+			case 0x17:
+				i += 1;
+				break;
+			case 0x11:
+				i += 5;
+				break;
+			case 0x06:
+			case 0x81:
+			case 0x15:
+			case 0x16:
+				i += 2;
+				break;
+			}
+		} else if (cmd == 0x80) {
+			/*
+			 * Special case: timeout event on cx231xx
+			 * Is it needed to check if is_polaris?
+			 */
+			rawir.pulse = 0;
+			rawir.duration = IR_MAX_DURATION;
+			dev_dbg(ir->dev, "Storing %s with duration %d\n",
+				rawir.pulse ? "pulse" : "space",
+				rawir.duration);
+
+			ir_raw_event_store(ir->idev, &rawir);
+		} else {
+			ir->rem = (cmd & MCE_PACKET_LENGTH_MASK);
+			ir->cmd = (cmd & ~MCE_PACKET_LENGTH_MASK);
+			dev_dbg(ir->dev, "New data. rem: 0x%02x, cmd: 0x%02x\n",
+				ir->rem, ir->cmd);
+			i++;
+			for (; (ir->rem > 0) && (i < buf_len); i++) {
+				ir->rem--;
+
+				rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
+				rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
+						 * MCE_TIME_UNIT * 1000;
+
+				if ((ir->buf_in[i] & MCE_PULSE_MASK) == 0x7f) {
+					if (ir->rawir.pulse == rawir.pulse)
+						ir->rawir.duration += rawir.duration;
+					else {
+						ir->rawir.duration = rawir.duration;
+						ir->rawir.pulse = rawir.pulse;
+					}
+					continue;
+				}
+				rawir.duration += ir->rawir.duration;
+				ir->rawir.duration = 0;
+				ir->rawir.pulse = rawir.pulse;
+
+				dev_dbg(ir->dev, "Storing %s with duration %d\n",
+					rawir.pulse ? "pulse" : "space",
+					rawir.duration);
+
+				ir_raw_event_store(ir->idev, &rawir);
+			}
+		}
+	}
+	dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
+	ir_raw_event_handle(ir->idev);
+}
+
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
@@ -707,6 +792,11 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 	if (ir->flags.microsoft_gen1)
 		start_index = 2;
 
+	if (ir->flags.is_polaris) {
+		mceusb_parse_polaris(ir, buf_len);
+		return;
+	}
+
 	for (i = start_index; i < buf_len;) {
 		if (ir->rem == 0) {
 			/* decode mce packets of the form (84),AA,BB,CC,DD */
@@ -1044,6 +1134,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->len_in = maxp;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
 	ir->flags.tx_mask_inverted = tx_mask_inverted;
+	ir->flags.is_polaris = is_polaris;
 	init_ir_raw_event(&ir->rawir);
 
 	/* Saving usb interface data for use by the transmitter routine */
-- 
1.7.1

