Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34697 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933216AbeGJNpD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 09:45:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id c13-v6so14651128wrt.1
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2018 06:45:02 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: mchehab@kernel.org
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        linux-media@lists.freedesktop.org,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: platform: meson-ao-cec: make busy TX warning silent
Date: Tue, 10 Jul 2018 15:44:57 +0200
Message-Id: <1531230297-30921-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to dev_dbg for the busy TX message to avoid having a flood of:
[  228.064570] meson-ao-cec c8100100.cec: meson_ao_cec_transmit: busy TX: aborting
[  230.368489] meson-ao-cec c8100100.cec: meson_ao_cec_transmit: busy TX: aborting
[  234.208655] meson-ao-cec c8100100.cec: meson_ao_cec_transmit: busy TX: aborting
[  236.512558] meson-ao-cec c8100100.cec: meson_ao_cec_transmit: busy TX: aborting

This message is only a debug hint and not an error.

Fixes: 7ec2c0f72cb1 ("media: platform: Add Amlogic Meson AO CEC Controller driver")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/media/platform/meson/ao-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/meson/ao-cec.c b/drivers/media/platform/meson/ao-cec.c
index 8040a62..cd4be38 100644
--- a/drivers/media/platform/meson/ao-cec.c
+++ b/drivers/media/platform/meson/ao-cec.c
@@ -524,7 +524,7 @@ static int meson_ao_cec_transmit(struct cec_adapter *adap, u8 attempts,
 		return ret;
 
 	if (reg == TX_BUSY) {
-		dev_err(&ao_cec->pdev->dev, "%s: busy TX: aborting\n",
+		dev_dbg(&ao_cec->pdev->dev, "%s: busy TX: aborting\n",
 			__func__);
 		meson_ao_cec_write(ao_cec, CEC_TX_MSG_CMD, TX_ABORT, &ret);
 	}
-- 
2.7.4
