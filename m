Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0GaO7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 10:59:36 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 01/13] IR: Kconfig fixes
Date: Sat, 31 Jul 2010 17:59:14 +0300
Message-Id: <1280588366-26101-2-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280588366-26101-1-git-send-email-maximlevitsky@gmail.com>
References: <1280588366-26101-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move IR drives below separate menu.
This allows to disable them.
Also correct a typo.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/Kconfig |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index e557ae0..fc48a3f 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -1,8 +1,10 @@
-config IR_CORE
-	tristate
+menuconfig IR_CORE
+	tristate "Infrared remote controller adapters"
 	depends on INPUT
 	default INPUT
 
+if IR_CORE
+
 config VIDEO_IR
 	tristate
 	depends on IR_CORE
@@ -16,7 +18,7 @@ config LIRC
 	   Enable this option to build the Linux Infrared Remote
 	   Control (LIRC) core device interface driver. The LIRC
 	   interface passes raw IR to and from userspace, where the
-	   LIRC daemon handles protocol decoding for IR reception ann
+	   LIRC daemon handles protocol decoding for IR reception and
 	   encoding for IR transmitting (aka "blasting").
 
 source "drivers/media/IR/keymaps/Kconfig"
@@ -102,3 +104,5 @@ config IR_MCEUSB
 
 	   To compile this driver as a module, choose M here: the
 	   module will be called mceusb.
+
+endif #IR_CORE
-- 
1.7.0.4

