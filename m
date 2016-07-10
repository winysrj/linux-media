Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58381 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933453AbcGJQeg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 12:34:36 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/5] [media] rc: make s_tx_carrier consistent
Date: Sun, 10 Jul 2016 17:34:33 +0100
Message-Id: <1468168473-27499-3-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIRC_SET_SEND_CARRIER should return 0 on success or -errno.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/DocBook/media/v4l/lirc_device_interface.xml | 2 +-
 drivers/media/rc/ene_ir.c                                 | 2 +-
 drivers/media/rc/iguanair.c                               | 2 +-
 drivers/media/rc/mceusb.c                                 | 2 +-
 drivers/media/rc/redrat3.c                                | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
index 34cada2..71f9dbb 100644
--- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
+++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
@@ -157,7 +157,7 @@ on working with the default settings initially.</para>
   <varlistentry>
     <term>LIRC_SET_{SEND,REC}_CARRIER</term>
     <listitem>
-      <para>Set send/receive carrier (in Hz).</para>
+      <para>Set send/receive carrier (in Hz). Return 0 on success.</para>
     </listitem>
   </varlistentry>
   <varlistentry>
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 8d77e1c..d1c61cd 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -904,7 +904,7 @@ static int ene_set_tx_carrier(struct rc_dev *rdev, u32 carrier)
 
 		dbg("TX: out of range %d-%d kHz carrier",
 			2000 / ENE_CIRMOD_PRD_MIN, 2000 / ENE_CIRMOD_PRD_MAX);
-		return -1;
+		return -EINVAL;
 	}
 
 	dev->tx_period = period;
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index ee60e17..5f63454 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -330,7 +330,7 @@ static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 
 	mutex_unlock(&ir->lock);
 
-	return carrier;
+	return 0;
 }
 
 static int iguanair_set_tx_mask(struct rc_dev *dev, uint32_t mask)
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 0d1da2c..c6d3325 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -936,7 +936,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 
 	}
 
-	return carrier;
+	return 0;
 }
 
 /*
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index ec74244..6adea78 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -708,7 +708,7 @@ static int redrat3_set_tx_carrier(struct rc_dev *rcdev, u32 carrier)
 
 	rr3->carrier = carrier;
 
-	return carrier;
+	return 0;
 }
 
 static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
-- 
2.7.4

