Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35214 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbeAYWTX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 17:19:23 -0500
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: mchehab@kernel.org, sean@mess.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Don't mark IR decoders default y
Date: Thu, 25 Jan 2018 14:19:08 -0800
Message-Id: <20180125221908.18022-1-andi@firstfloor.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andi Kleen <ak@linux.intel.com>

I usually update my config with make oldconfig and pressing return,
trusting that whoever updates Kconfig sets sensible defaults.

But my recent kernels  ended up with all kinds of IR decoders
built in that are not used by anything because they are all
marked with default y.

default y should only be set for something that prevents
booting on common systems, never for some random weirdo
driver feature like this.

Remove all the "default y" in drivers/media/rc/Kconfig

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/media/rc/Kconfig | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index afb3456d4e20..0994371275a7 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -19,7 +19,6 @@ source "drivers/media/rc/keymaps/Kconfig"
 menuconfig RC_DECODERS
         bool "Remote controller decoders"
 	depends on RC_CORE
-	default y
 
 if RC_DECODERS
 config LIRC
@@ -37,7 +36,6 @@ config IR_LIRC_CODEC
 	tristate "Enable IR to LIRC bridge"
 	depends on RC_CORE
 	depends on LIRC
-	default y
 
 	---help---
 	   Enable this option to pass raw IR to and from userspace via
@@ -48,7 +46,6 @@ config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have IR with NEC protocol, and
@@ -58,7 +55,6 @@ config IR_RC5_DECODER
 	tristate "Enable IR raw decoder for the RC-5 protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have IR with RC-5 protocol, and
@@ -68,7 +64,6 @@ config IR_RC6_DECODER
 	tristate "Enable IR raw decoder for the RC6 protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -78,7 +73,6 @@ config IR_JVC_DECODER
 	tristate "Enable IR raw decoder for the JVC protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -88,7 +82,6 @@ config IR_SONY_DECODER
 	tristate "Enable IR raw decoder for the Sony protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -97,7 +90,6 @@ config IR_SONY_DECODER
 config IR_SANYO_DECODER
 	tristate "Enable IR raw decoder for the Sanyo protocol"
 	depends on RC_CORE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -107,7 +99,6 @@ config IR_SANYO_DECODER
 config IR_SHARP_DECODER
 	tristate "Enable IR raw decoder for the Sharp protocol"
 	depends on RC_CORE
-	default y
 
 	---help---
 	   Enable this option if you have an infrared remote control which
@@ -118,7 +109,6 @@ config IR_MCE_KBD_DECODER
 	tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have a Microsoft Remote Keyboard for
@@ -129,7 +119,6 @@ config IR_XMP_DECODER
 	tristate "Enable IR raw decoder for the XMP protocol"
 	depends on RC_CORE
 	select BITREVERSE
-	default y
 
 	---help---
 	   Enable this option if you have IR with XMP protocol, and
@@ -459,7 +448,6 @@ config IR_SERIAL
 
 config IR_SERIAL_TRANSMITTER
 	bool "Serial Port Transmitter"
-	default y
 	depends on IR_SERIAL
 	---help---
 	   Serial Port Transmitter support
-- 
2.14.3
