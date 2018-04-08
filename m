Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35545 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753101AbeDHVTq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Apr 2018 17:19:46 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Cc: Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v2 1/7] media: rc: set timeout to smallest value required by enabled protocols
Date: Sun,  8 Apr 2018 22:19:36 +0100
Message-Id: <88fe6a3110a122855b5d336d74aee778fd15616f.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The longer the IR timeout, the longer the rc device waits until delivering
the trailing space. So, by reducing this timeout, we reduce the delay for
the last scancode to be delivered.

Note that the lirc daemon disables all protocols, in which case we revert
back to the default value.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-imon-decoder.c    |  1 +
 drivers/media/rc/ir-jvc-decoder.c     |  1 +
 drivers/media/rc/ir-mce_kbd-decoder.c |  1 +
 drivers/media/rc/ir-nec-decoder.c     |  1 +
 drivers/media/rc/ir-rc5-decoder.c     |  1 +
 drivers/media/rc/ir-rc6-decoder.c     |  1 +
 drivers/media/rc/ir-sanyo-decoder.c   |  1 +
 drivers/media/rc/ir-sharp-decoder.c   |  1 +
 drivers/media/rc/ir-sony-decoder.c    |  1 +
 drivers/media/rc/ir-xmp-decoder.c     |  1 +
 drivers/media/rc/rc-core-priv.h       |  1 +
 drivers/media/rc/rc-ir-raw.c          | 31 ++++++++++++++++++++++++++++++-
 drivers/media/rc/rc-main.c            | 12 ++++++------
 13 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ir-imon-decoder.c b/drivers/media/rc/ir-imon-decoder.c
index a1ff06a26542..9024b359e5ee 100644
--- a/drivers/media/rc/ir-imon-decoder.c
+++ b/drivers/media/rc/ir-imon-decoder.c
@@ -170,6 +170,7 @@ static struct ir_raw_handler imon_handler = {
 	.decode		= ir_imon_decode,
 	.encode		= ir_imon_encode,
 	.carrier	= 38000,
+	.max_space	= IMON_UNIT * IMON_BITS * 2,
 };
 
 static int __init ir_imon_decode_init(void)
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 8cb68ae43282..190c690b14f8 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -213,6 +213,7 @@ static struct ir_raw_handler jvc_handler = {
 	.decode		= ir_jvc_decode,
 	.encode		= ir_jvc_encode,
 	.carrier	= 38000,
+	.max_space	= JVC_TRAILER_SPACE,
 };
 
 static int __init ir_jvc_decode_init(void)
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index c110984ca671..ae4b980c4a16 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -475,6 +475,7 @@ static struct ir_raw_handler mce_kbd_handler = {
 	.raw_register	= ir_mce_kbd_register,
 	.raw_unregister	= ir_mce_kbd_unregister,
 	.carrier	= 36000,
+	.max_space	= MCIR2_MAX_LEN,
 };
 
 static int __init ir_mce_kbd_decode_init(void)
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 21647b809e6f..fac12f867a81 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -253,6 +253,7 @@ static struct ir_raw_handler nec_handler = {
 	.decode		= ir_nec_decode,
 	.encode		= ir_nec_encode,
 	.carrier	= 38000,
+	.max_space	= NEC_TRAILER_SPACE,
 };
 
 static int __init ir_nec_decode_init(void)
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 74d3b859c3a2..711068c8de90 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -274,6 +274,7 @@ static struct ir_raw_handler rc5_handler = {
 	.decode		= ir_rc5_decode,
 	.encode		= ir_rc5_encode,
 	.carrier	= 36000,
+	.max_space	= RC5_TRAILER,
 };
 
 static int __init ir_rc5_decode_init(void)
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 8314da32453f..9cc4820878c7 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -394,6 +394,7 @@ static struct ir_raw_handler rc6_handler = {
 	.decode		= ir_rc6_decode,
 	.encode		= ir_rc6_encode,
 	.carrier	= 36000,
+	.max_space	= RC6_SUFFIX_SPACE,
 };
 
 static int __init ir_rc6_decode_init(void)
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 4efe6db5376a..e72787b446c9 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -210,6 +210,7 @@ static struct ir_raw_handler sanyo_handler = {
 	.decode		= ir_sanyo_decode,
 	.encode		= ir_sanyo_encode,
 	.carrier	= 38000,
+	.max_space	= SANYO_TRAILER_SPACE,
 };
 
 static int __init ir_sanyo_decode_init(void)
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 6a38c50566a4..e7e3841a6eb0 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -226,6 +226,7 @@ static struct ir_raw_handler sharp_handler = {
 	.decode		= ir_sharp_decode,
 	.encode		= ir_sharp_encode,
 	.carrier	= 38000,
+	.max_space	= SHARP_ECHO_SPACE,
 };
 
 static int __init ir_sharp_decode_init(void)
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 6764ec9de646..598bae8d8ffb 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -224,6 +224,7 @@ static struct ir_raw_handler sony_handler = {
 	.decode		= ir_sony_decode,
 	.encode		= ir_sony_encode,
 	.carrier	= 40000,
+	.max_space	= SONY_TRAILER_SPACE,
 };
 
 static int __init ir_sony_decode_init(void)
diff --git a/drivers/media/rc/ir-xmp-decoder.c b/drivers/media/rc/ir-xmp-decoder.c
index 58b47af1a763..e005a75a86fe 100644
--- a/drivers/media/rc/ir-xmp-decoder.c
+++ b/drivers/media/rc/ir-xmp-decoder.c
@@ -199,6 +199,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 static struct ir_raw_handler xmp_handler = {
 	.protocols	= RC_PROTO_BIT_XMP,
 	.decode		= ir_xmp_decode,
+	.max_space	= XMP_TRAILER_SPACE,
 };
 
 static int __init ir_xmp_decode_init(void)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index e0e6a17460f6..8c38941295b8 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -37,6 +37,7 @@ struct ir_raw_handler {
 	int (*encode)(enum rc_proto protocol, u32 scancode,
 		      struct ir_raw_event *events, unsigned int max);
 	u32 carrier;
+	u32 max_space;
 
 	/* These two should only be used by the mce kbd decoder */
 	int (*raw_register)(struct rc_dev *dev);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 374f83105a23..1ce008dc7f47 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -233,7 +233,36 @@ ir_raw_get_allowed_protocols(void)
 
 static int change_protocol(struct rc_dev *dev, u64 *rc_proto)
 {
-	/* the caller will update dev->enabled_protocols */
+	struct ir_raw_handler *handler;
+	u32 timeout = 0;
+
+	if (!dev->max_timeout)
+		return 0;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_for_each_entry(handler, &ir_raw_handler_list, list) {
+		if (handler->protocols & *rc_proto) {
+			if (timeout < handler->max_space)
+				timeout = handler->max_space;
+		}
+	}
+	mutex_unlock(&ir_raw_handler_lock);
+
+	if (timeout == 0)
+		timeout = IR_DEFAULT_TIMEOUT;
+	else
+		timeout += MS_TO_NS(20);
+
+	if (timeout < dev->min_timeout)
+		timeout = dev->min_timeout;
+	else if (timeout > dev->max_timeout)
+		timeout = dev->max_timeout;
+
+	if (dev->s_timeout)
+		dev->s_timeout(dev, timeout);
+	else
+		dev->timeout = timeout;
+
 	return 0;
 }
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index b67be33bd62f..6a720e9c7aa8 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1241,6 +1241,9 @@ static ssize_t store_protocols(struct device *device,
 	if (rc < 0)
 		goto out;
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_load_modules(&new_protocols);
+
 	rc = dev->change_protocol(dev, &new_protocols);
 	if (rc < 0) {
 		dev_dbg(&dev->dev, "Error setting protocols to 0x%llx\n",
@@ -1248,9 +1251,6 @@ static ssize_t store_protocols(struct device *device,
 		goto out;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_load_modules(&new_protocols);
-
 	if (new_protocols != old_protocols) {
 		*current_protocols = new_protocols;
 		dev_dbg(&dev->dev, "Protocols changed to 0x%llx\n",
@@ -1735,6 +1735,9 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_SCANCODE && !dev->change_protocol)
 		dev->enabled_protocols = dev->allowed_protocols;
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_load_modules(&rc_proto);
+
 	if (dev->change_protocol) {
 		rc = dev->change_protocol(dev, &rc_proto);
 		if (rc < 0)
@@ -1742,9 +1745,6 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 		dev->enabled_protocols = rc_proto;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_load_modules(&rc_proto);
-
 	set_bit(EV_KEY, dev->input_dev->evbit);
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
-- 
2.14.3
