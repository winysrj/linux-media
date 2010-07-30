Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab0G3LjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:04 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 02/13] IR: minor fixes:
Date: Fri, 30 Jul 2010 14:38:42 +0300
Message-Id: <1280489933-20865-3-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* lirc: Don't propagate reset event to userspace
* lirc: Remove strange logic from lirc that would make first sample always be pulse
* Make TO_US macro actualy print what it should.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h  |    4 +---
 drivers/media/IR/ir-lirc-codec.c |   14 ++++++++------
 drivers/media/IR/ir-raw-event.c  |    3 +++
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index babd520..dc26e2b 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -76,7 +76,6 @@ struct ir_raw_event_ctrl {
 	struct lirc_codec {
 		struct ir_input_dev *ir_dev;
 		struct lirc_driver *drv;
-		int lircdata;
 	} lirc;
 };
 
@@ -104,10 +103,9 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
 		ev->duration -= duration;
 }
 
-#define TO_US(duration)			(((duration) + 500) / 1000)
+#define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
 #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
 #define IS_RESET(ev)			(ev.duration == 0)
-
 /*
  * Routines from ir-sysfs.c - Meant to be called only internally inside
  * ir-core
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 3ba482d..8ca01fd 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -32,6 +32,7 @@
 static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int sample;
 
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
 		return 0;
@@ -39,18 +40,21 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
 		return -EINVAL;
 
+	if (IS_RESET(ev))
+		return 0;
+
 	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
 		   TO_US(ev.duration), TO_STR(ev.pulse));
 
-	ir_dev->raw->lirc.lircdata += ev.duration / 1000;
+
+	sample = ev.duration / 1000;
 	if (ev.pulse)
-		ir_dev->raw->lirc.lircdata |= PULSE_BIT;
+		sample |= PULSE_BIT;
 
 	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
-			  (unsigned char *) &ir_dev->raw->lirc.lircdata);
+			  (unsigned char *) &sample);
 	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
 
-	ir_dev->raw->lirc.lircdata = 0;
 
 	return 0;
 }
@@ -224,8 +228,6 @@ static int ir_lirc_register(struct input_dev *input_dev)
 
 	ir_dev->raw->lirc.drv = drv;
 	ir_dev->raw->lirc.ir_dev = ir_dev;
-	ir_dev->raw->lirc.lircdata = PULSE_MASK;
-
 	return 0;
 
 lirc_register_failed:
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 6f192ef..51f65da 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -66,6 +66,9 @@ int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev)
 	if (!ir->raw)
 		return -EINVAL;
 
+	IR_dprintk(2, "sample: (05%dus %s)\n",
+		TO_US(ev->duration), TO_STR(ev->pulse));
+
 	if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
 		return -ENOMEM;
 
-- 
1.7.0.4

