Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34977 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753014AbeDHVTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Apr 2018 17:19:48 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Cc: Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v2 4/7] media: rc: mce_kbd decoder: low timeout values cause double keydowns
Date: Sun,  8 Apr 2018 22:19:39 +0100
Message-Id: <e5bf02f1961fc60e84b74a76a0a7472f4029db26.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mce keyboard repeats pressed keys every 100ms. If the IR timeout
is set to less than that, we send key up events before the repeat
arrives, so we have key up/key down for each IR repeat.

The keyboard ends any sequence with a 0 scancode, in which case all keys
are cleared so there is no need to run the timeout timer: it only exists
for the case that the final 0 was not received.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index ae4b980c4a16..230b9397aa11 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -322,11 +322,13 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			scancode = data->body & 0xffff;
 			dev_dbg(&dev->dev, "keyboard data 0x%08x\n",
 				data->body);
-			if (dev->timeout)
-				delay = usecs_to_jiffies(dev->timeout / 1000);
-			else
-				delay = msecs_to_jiffies(100);
-			mod_timer(&data->rx_timeout, jiffies + delay);
+			if (scancode) {
+				delay = nsecs_to_jiffies(dev->timeout) +
+					msecs_to_jiffies(100);
+				mod_timer(&data->rx_timeout, jiffies + delay);
+			} else {
+				del_timer(&data->rx_timeout);
+			}
 			/* Pass data to keyboard buffer parser */
 			ir_mce_kbd_process_keyboard_data(dev, scancode);
 			lsc.rc_proto = RC_PROTO_MCIR2_KBD;
-- 
2.14.3
