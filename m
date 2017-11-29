Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49546 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753116AbdK2MIS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 07:08:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Andi Shyti <andi.shyti@samsung.com>,
        James Hogan <jhogan@kernel.org>
Subject: [PATCH 2/7] media: rc: fix kernel-doc parameter names
Date: Wed, 29 Nov 2017 07:08:05 -0500
Message-Id: <cc043fc67b9fa1e3f33a076c9a7f4b628c4a206f.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several parameters there that are named wrong, as
reported by those warnings:

	drivers/media/rc/ir-sharp-decoder.c:47: warning: No description found for parameter 'ev'
	drivers/media/rc/ir-sharp-decoder.c:47: warning: Excess function parameter 'duration' description in 'ir_sharp_decode'
	drivers/media/rc/ir-sanyo-decoder.c:56: warning: No description found for parameter 'ev'
	drivers/media/rc/ir-sanyo-decoder.c:56: warning: Excess function parameter 'duration' description in 'ir_sanyo_decode'
	drivers/media/rc/ir-xmp-decoder.c:43: warning: No description found for parameter 'ev'
	drivers/media/rc/ir-xmp-decoder.c:43: warning: Excess function parameter 'duration' description in 'ir_xmp_decode'
	drivers/media/rc/ir-jvc-decoder.c:47: warning: No description found for parameter 'ev'
	drivers/media/rc/ir-jvc-decoder.c:47: warning: Excess function parameter 'duration' description in 'ir_jvc_decode'
	drivers/media/rc/ir-lirc-codec.c:34: warning: No description found for parameter 'dev'
	drivers/media/rc/ir-lirc-codec.c:34: warning: No description found for parameter 'ev'
	drivers/media/rc/ir-lirc-codec.c:34: warning: Excess function parameter 'input_dev' description in 'ir_lirc_decode'
	drivers/media/rc/ir-lirc-codec.c:34: warning: Excess function parameter 'duration' description in 'ir_lirc_decode'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/ir-jvc-decoder.c   | 2 +-
 drivers/media/rc/ir-lirc-codec.c    | 4 ++--
 drivers/media/rc/ir-sanyo-decoder.c | 2 +-
 drivers/media/rc/ir-sharp-decoder.c | 2 +-
 drivers/media/rc/ir-xmp-decoder.c   | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index e2bd68c42edf..22c8aee3df4f 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -39,7 +39,7 @@ enum jvc_state {
 /**
  * ir_jvc_decode() - Decode one JVC pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:   the struct ir_raw_event descriptor of the pulse/space
+ * @ev:   the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 8f2f37412fc5..4fd4521693d9 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -25,8 +25,8 @@
 /**
  * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
  *		      lircd userspace daemon for decoding.
- * @input_dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the lirc interfaces aren't wired up.
  */
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 758c60956850..d94e07b02f3b 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -48,7 +48,7 @@ enum sanyo_state {
 /**
  * ir_sanyo_decode() - Decode one SANYO pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 129b558acc92..7140dd6160ee 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -39,7 +39,7 @@ enum sharp_state {
 /**
  * ir_sharp_decode() - Decode one Sharp pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
diff --git a/drivers/media/rc/ir-xmp-decoder.c b/drivers/media/rc/ir-xmp-decoder.c
index 6f464be1c8d7..712bc6d76e92 100644
--- a/drivers/media/rc/ir-xmp-decoder.c
+++ b/drivers/media/rc/ir-xmp-decoder.c
@@ -35,7 +35,7 @@ enum xmp_state {
 /**
  * ir_xmp_decode() - Decode one XMP pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-- 
2.14.3
