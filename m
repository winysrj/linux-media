Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56253 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752289AbeDHVTu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Apr 2018 17:19:50 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Cc: Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH v2 6/7] media: rc: mce_kbd decoder: fix stuck keys
Date: Sun,  8 Apr 2018 22:19:41 +0100
Message-Id: <6e04a64c9be3f571f4927f0ffada67be5071db88.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MCE Remote sends a 0 scancode when keys are released. If this is not
received or decoded, then keys can get "stuck"; the keyup event is not
sent since the input_sync() is missing from the timeout handler.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index dcdba83290d2..a6adf54461e9 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -130,6 +130,8 @@ static void mce_kbd_rx_timeout(struct timer_list *t)
 
 	for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
 		input_report_key(raw->mce_kbd.idev, kbd_keycodes[i], 0);
+
+	input_sync(raw->mce_kbd.idev);
 }
 
 static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
-- 
2.14.3
