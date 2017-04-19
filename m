Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35000 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940330AbdDSXOf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:35 -0400
Received: by mail-qt0-f169.google.com with SMTP id y33so32524506qta.2
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:30 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 02/12] au8522: don't touch i2c master registers on au8522
Date: Wed, 19 Apr 2017 19:13:45 -0400
Message-Id: <1492643635-30823-3-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some stray lines got inserted into the driver when I reverse engineered
the I2C traffic (at the time I didn't know what the registers did).

It turns up these registers muck with the onboard I2C master, which
we don't use since we instead use the I2C gate.  Remove the lines
which can actually interfere with the operation of the bus.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 12a5c2c..7811717 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -422,8 +422,6 @@ static void set_audio_input(struct au8522_state *state)
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_L_REG0F2H, 0x00);
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_R_REG0F3H, 0x00);
 	au8522_writereg(state, AU8522_AUDIO_VOLUME_REG0F4H, 0x00);
-	au8522_writereg(state, AU8522_I2C_CONTROL_REG1_REG091H, 0x80);
-	au8522_writereg(state, AU8522_I2C_CONTROL_REG0_REG090H, 0x84);
 	msleep(150);
 	au8522_writereg(state, AU8522_SYSTEM_MODULE_CONTROL_0_REG0A4H, 0x00);
 	msleep(10);
-- 
1.9.1
