Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4349 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3BFP4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 16/17] bttv: there may be multiple tvaudio/tda7432 devices.
Date: Wed,  6 Feb 2013 16:56:34 +0100
Message-Id: <46207ecc56e90dee9480a25cdeb59ce2a877964b.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Probe for additional tvaudio devices, and allow tvaudio+tda7432 to
co-exist. My STB TV PCI FM bttv card has a tda7432, a tda9850 and a
tea6420.

Unfortunately, even with this patch I still don't get audio out, but
at least all the devices are recognized.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-cards.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 682ed89..fa0faaa 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -3547,6 +3547,16 @@ void bttv_init_card2(struct bttv *btv)
 	if (btv->sd_msp34xx)
 		return;
 
+	/* Now see if we can find one of the tvaudio devices. */
+	btv->sd_tvaudio = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
+		&btv->c.i2c_adap, "tvaudio", 0, tvaudio_addrs());
+	if (btv->sd_tvaudio) {
+		/* There may be two tvaudio chips on the card, so try to
+		   find another. */
+		v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
+			&btv->c.i2c_adap, "tvaudio", 0, tvaudio_addrs());
+	}
+
 	/* it might also be a tda7432. */
 	if (!bttv_tvcards[btv->c.type].no_tda7432) {
 		static const unsigned short addrs[] = {
@@ -3559,10 +3569,6 @@ void bttv_init_card2(struct bttv *btv)
 		if (btv->sd_tda7432)
 			return;
 	}
-
-	/* Now see if we can find one of the tvaudio devices. */
-	btv->sd_tvaudio = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-		&btv->c.i2c_adap, "tvaudio", 0, tvaudio_addrs());
 	if (btv->sd_tvaudio)
 		return;
 
-- 
1.7.10.4

