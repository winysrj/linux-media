Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:55244 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935951AbdD0UeP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 16:34:15 -0400
Subject: [PATCH 4/6] rc-core: use the full 32 bits for NEC scancodes in
 wakefilters
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 27 Apr 2017 22:34:13 +0200
Message-ID: <149332525323.32431.14186133466616956249.stgit@zeus.hardeman.nu>
In-Reply-To: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new sysfs wakefilter API will expose the difference between the NEC
protocols to userspace for no good reason and once exposed, it will be much
more difficult to change the logic.

By only allowing full NEC32 scancodes to be set, any heuristics in the kernel
can be avoided.

This is a minor preparation for the next patch which moves the rest of
rc-core over to only using NEC32.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c     |   17 ++++-------------
 drivers/media/rc/winbond-cir.c |   32 ++------------------------------
 2 files changed, 6 insertions(+), 43 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 0acc8f27abeb..8355f86a460b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -741,8 +741,6 @@ static int rc_validate_filter(struct rc_dev *dev,
 		[RC_TYPE_SONY15] = 0xff007f,
 		[RC_TYPE_SONY20] = 0x1fff7f,
 		[RC_TYPE_JVC] = 0xffff,
-		[RC_TYPE_NEC] = 0xffff,
-		[RC_TYPE_NECX] = 0xffffff,
 		[RC_TYPE_NEC32] = 0xffffffff,
 		[RC_TYPE_SANYO] = 0x1fffff,
 		[RC_TYPE_MCIR2_KBD] = 0xffff,
@@ -758,14 +756,9 @@ static int rc_validate_filter(struct rc_dev *dev,
 	enum rc_type protocol = dev->wakeup_protocol;
 
 	switch (protocol) {
+	case RC_TYPE_NEC:
 	case RC_TYPE_NECX:
-		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
-			return -EINVAL;
-		break;
-	case RC_TYPE_NEC32:
-		if ((((s >> 24) ^ ~(s >> 16)) & 0xff) == 0)
-			return -EINVAL;
-		break;
+		return -EINVAL;
 	case RC_TYPE_RC6_MCE:
 		if ((s & 0xffff0000) != 0x800f0000)
 			return -EINVAL;
@@ -1301,7 +1294,7 @@ static ssize_t store_filter(struct device *device,
 /*
  * This is the list of all variants of all protocols, which is used by
  * the wakeup_protocols sysfs entry. In the protocols sysfs entry some
- * some protocols are grouped together (e.g. nec = nec + necx + nec32).
+ * some protocols are grouped together.
  *
  * For wakeup we need to know the exact protocol variant so the hardware
  * can be programmed exactly what to expect.
@@ -1316,9 +1309,7 @@ static const char * const proto_variant_names[] = {
 	[RC_TYPE_SONY12] = "sony-12",
 	[RC_TYPE_SONY15] = "sony-15",
 	[RC_TYPE_SONY20] = "sony-20",
-	[RC_TYPE_NEC] = "nec",
-	[RC_TYPE_NECX] = "nec-x",
-	[RC_TYPE_NEC32] = "nec-32",
+	[RC_TYPE_NEC32] = "nec",
 	[RC_TYPE_SANYO] = "sanyo",
 	[RC_TYPE_MCIR2_KBD] = "mcir2-kbd",
 	[RC_TYPE_MCIR2_MSE] = "mcir2-mse",
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 5a4d4a611197..6ef0e7232356 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -714,34 +714,6 @@ wbcir_shutdown(struct pnp_dev *device)
 		proto = IR_PROTOCOL_RC5;
 		break;
 
-	case RC_TYPE_NEC:
-		mask[1] = bitrev8(mask_sc);
-		mask[0] = mask[1];
-		mask[3] = bitrev8(mask_sc >> 8);
-		mask[2] = mask[3];
-
-		match[1] = bitrev8(wake_sc);
-		match[0] = ~match[1];
-		match[3] = bitrev8(wake_sc >> 8);
-		match[2] = ~match[3];
-
-		proto = IR_PROTOCOL_NEC;
-		break;
-
-	case RC_TYPE_NECX:
-		mask[1] = bitrev8(mask_sc);
-		mask[0] = mask[1];
-		mask[2] = bitrev8(mask_sc >> 8);
-		mask[3] = bitrev8(mask_sc >> 16);
-
-		match[1] = bitrev8(wake_sc);
-		match[0] = ~match[1];
-		match[2] = bitrev8(wake_sc >> 8);
-		match[3] = bitrev8(wake_sc >> 16);
-
-		proto = IR_PROTOCOL_NEC;
-		break;
-
 	case RC_TYPE_NEC32:
 		mask[0] = bitrev8(mask_sc);
 		mask[1] = bitrev8(mask_sc >> 8);
@@ -1087,8 +1059,8 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	data->dev->rx_resolution = US_TO_NS(2);
 	data->dev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
-	data->dev->allowed_wakeup_protocols = RC_BIT_NEC | RC_BIT_NECX |
-			RC_BIT_NEC32 | RC_BIT_RC5 | RC_BIT_RC6_0 |
+	data->dev->allowed_wakeup_protocols =
+			RC_BIT_NEC | RC_BIT_RC5 | RC_BIT_RC6_0 |
 			RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
 			RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE;
 	data->dev->wakeup_protocol = RC_TYPE_RC6_MCE;
