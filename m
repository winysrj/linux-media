Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51871 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752389AbeEKIgv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 04:36:51 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [PATCH 1/3] media: mceusb: filter out bogus timing irdata of duration 0
Date: Fri, 11 May 2018 09:36:48 +0100
Message-Id: <20180511083650.20020-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A mceusb device has been observed producing invalid irdata. Proactively
guard against this.

Suggested-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 1619b748469b..1ca49491abc8 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1177,6 +1177,11 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			init_ir_raw_event(&rawir);
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK);
+			if (unlikely(!rawir.duration)) {
+				dev_warn(ir->dev, "nonsensical irdata %02x with duration 0",
+					 ir->buf_in[i]);
+				break;
+			}
 			if (rawir.pulse) {
 				ir->pulse_tunit += rawir.duration;
 				ir->pulse_count++;
-- 
2.14.3
