Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55869 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbeBXSzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:55:41 -0500
Received: by mail-wm0-f66.google.com with SMTP id q83so10484361wme.5
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 10:55:40 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 03/12] [media] ngene: use defines to identify the demod_type
Date: Sat, 24 Feb 2018 19:55:25 +0100
Message-Id: <20180224185534.13792-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180224185534.13792-1-d.scheller.oss@gmail.com>
References: <20180224185534.13792-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Make it more clear which demod_type is used for which hardware by having
defines for the possible demod_type values. With that, change the
demod_type evaluation in tuner_attach_probe() to a switch-case instead
of an if() for each possible value.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 11 +++++++----
 drivers/media/pci/ngene/ngene.h       |  3 +++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 16666de8cbee..065b83ee569b 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -123,10 +123,13 @@ static int tuner_attach_tda18271(struct ngene_channel *chan)
 
 static int tuner_attach_probe(struct ngene_channel *chan)
 {
-	if (chan->demod_type == 0)
+	switch (chan->demod_type) {
+	case DEMOD_TYPE_STV090X:
 		return tuner_attach_stv6110(chan);
-	if (chan->demod_type == 1)
+	case DEMOD_TYPE_DRXK:
 		return tuner_attach_tda18271(chan);
+	}
+
 	return -EINVAL;
 }
 
@@ -251,7 +254,7 @@ static int cineS2_probe(struct ngene_channel *chan)
 		i2c = &chan->dev->channel[1].i2c_adapter;
 
 	if (port_has_stv0900(i2c, chan->number)) {
-		chan->demod_type = 0;
+		chan->demod_type = DEMOD_TYPE_STV090X;
 		fe_conf = chan->dev->card_info->fe_config[chan->number];
 		/* demod found, attach it */
 		rc = demod_attach_stv0900(chan);
@@ -280,7 +283,7 @@ static int cineS2_probe(struct ngene_channel *chan)
 			return -EIO;
 		}
 	} else if (port_has_drxk(i2c, chan->number^2)) {
-		chan->demod_type = 1;
+		chan->demod_type = DEMOD_TYPE_DRXK;
 		demod_attach_drxk(chan, i2c);
 	} else {
 		dev_err(pdev, "No demod found on chan %d\n", chan->number);
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index caf8602c7459..9724701a3274 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -51,6 +51,9 @@
 #define VIDEO_CAP_MPEG4 512
 #endif
 
+#define DEMOD_TYPE_STV090X	0
+#define DEMOD_TYPE_DRXK		1
+
 enum STREAM {
 	STREAM_VIDEOIN1 = 0,        /* ITU656 or TS Input */
 	STREAM_VIDEOIN2,
-- 
2.16.1
