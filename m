Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030295AbbD1PoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:07 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 12/14] ir-sony-decoder: shutup smatch warnings
Date: Tue, 28 Apr 2015 12:43:51 -0300
Message-Id: <c76838d663ededfbba6261dbfe8f5ec93139bfcf.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some false-positive warnings produced by smatch:
	drivers/media/rc/ir-sony-decoder.c:129 ir_sony_decode() warn: missing break? reassigning 'data->state'
	drivers/media/rc/ir-sony-decoder.c:137 ir_sony_decode() warn: missing break? reassigning 'data->state'
	drivers/media/rc/ir-sony-decoder.c:165 ir_sony_decode() warn: missing break? reassigning 'data->state'

This is due to the logic used there to detect the need of a break.

While those are false positives, it is easy to get rid of them without
any drawbacks. The side effect is a cleaner function, with is good.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index d12dc3da5931..58ef06f35175 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -125,30 +125,27 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
-			if (!(dev->enabled_protocols & RC_BIT_SONY12)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
+			if (!(dev->enabled_protocols & RC_BIT_SONY12))
+				goto finish_state_machine;
+
 			device    = bitrev8((data->bits <<  3) & 0xF8);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  4) & 0xFE);
 			protocol = RC_TYPE_SONY12;
 			break;
 		case 15:
-			if (!(dev->enabled_protocols & RC_BIT_SONY15)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
+			if (!(dev->enabled_protocols & RC_BIT_SONY15))
+				goto finish_state_machine;
+
 			device    = bitrev8((data->bits >>  0) & 0xFF);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  7) & 0xFE);
 			protocol = RC_TYPE_SONY15;
 			break;
 		case 20:
-			if (!(dev->enabled_protocols & RC_BIT_SONY20)) {
-				data->state = STATE_INACTIVE;
-				return 0;
-			}
+			if (!(dev->enabled_protocols & RC_BIT_SONY20))
+				goto finish_state_machine;
+
 			device    = bitrev8((data->bits >>  5) & 0xF8);
 			subdevice = bitrev8((data->bits >>  0) & 0xFF);
 			function  = bitrev8((data->bits >> 12) & 0xFE);
@@ -162,8 +159,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		scancode = device << 16 | subdevice << 8 | function;
 		IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
 		rc_keydown(dev, protocol, scancode, 0);
-		data->state = STATE_INACTIVE;
-		return 0;
+		goto finish_state_machine;
 	}
 
 out:
@@ -171,6 +167,10 @@ out:
 		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
+
+finish_state_machine:
+	data->state = STATE_INACTIVE;
+	return 0;
 }
 
 static struct ir_raw_handler sony_handler = {
-- 
2.1.0

