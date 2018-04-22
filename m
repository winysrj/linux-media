Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38502 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754090AbeDVQGz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 12:06:55 -0400
Received: by mail-wr0-f195.google.com with SMTP id h3-v6so34742703wrh.5
        for <linux-media@vger.kernel.org>; Sun, 22 Apr 2018 09:06:55 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 1/2] [media] ngene: cleanup superfluous I2C adapter evaluation
Date: Sun, 22 Apr 2018 18:06:51 +0200
Message-Id: <20180422160652.20173-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Commit ee93340e98bc ("media: ngene: deduplicate I2C adapter evaluation")
added a helper to evaluate the I2C adapter to be used for demod/tuner
attachment based on the given ngene_channel, and that helper is used in
many attach functions to initialise the i2c_adapter variable. However,
for some reason in tuner_attach_stv6110() and demod_attach_stv0900(), the
adapter evaluation wasn't removed as in all other functions. Fix (or
finalize, even) the helper use by cleaning up the superfluous I2C adapter
evaluation leftover in these two functions.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 65fc8f23ad86..caa5976055c4 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -137,11 +137,6 @@ static int tuner_attach_stv6110(struct ngene_channel *chan)
 		chan->dev->card_info->tuner_config[chan->number];
 	const struct stv6110x_devctl *ctl;
 
-	if (chan->number < 2)
-		i2c = &chan->dev->channel[0].i2c_adapter;
-	else
-		i2c = &chan->dev->channel[1].i2c_adapter;
-
 	ctl = dvb_attach(stv6110x_attach, chan->fe, tunerconf, i2c);
 	if (ctl == NULL) {
 		dev_err(pdev, "No STV6110X found!\n");
@@ -304,14 +299,6 @@ static int demod_attach_stv0900(struct ngene_channel *chan)
 	struct stv090x_config *feconf = (struct stv090x_config *)
 		chan->dev->card_info->fe_config[chan->number];
 
-	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
-	/* Note: Both adapters share the same i2c bus, but the demod     */
-	/*       driver requires that each demod has its own i2c adapter */
-	if (chan->number < 2)
-		i2c = &chan->dev->channel[0].i2c_adapter;
-	else
-		i2c = &chan->dev->channel[1].i2c_adapter;
-
 	chan->fe = dvb_attach(stv090x_attach, feconf, i2c,
 			(chan->number & 1) == 0 ? STV090x_DEMODULATOR_0
 						: STV090x_DEMODULATOR_1);
-- 
2.16.1
