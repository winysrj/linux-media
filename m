Return-path: <linux-media-owner@vger.kernel.org>
Received: from 125-236-241-154.adsl.xtra.co.nz ([125.236.241.154]:45115 "EHLO
	mail.reveal.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2DBBQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 21:16:30 -0400
Date: Mon, 2 Apr 2012 13:11:08 +1200
From: Alan McIvor <alan.mcivor@reveal.co.nz>
To: <linux-media@vger.kernel.org>
Subject: [PATCH] Default bt878 contrast value
Message-ID: <20120402131108.7e3efa78.alan.mcivor@reveal.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default_value for the Bt878 V4L2_CID_CONTRAST control is currently
set to 32768. Internally this gets translated to an analog input
circuit gain of 1.19. However, the default gain should be 1.0. This
patch alters the default value to 27648 which corresponds to a gain of
1.0. It also alters the probe routine so that the correct value is
written on board initialisation.

Signed-off-by: Alan McIvor <alan.mcivor@reveal.co.nz>

---


diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index e581b37..2fdfbdc 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -663,7 +663,7 @@ static const struct v4l2_queryctrl bttv_ctls[] = {
                .minimum       = 0,
                .maximum       = 65535,
                .step          = 128,
-               .default_value = 32768,
+               .default_value = 27648,
                .type          = V4L2_CTRL_TYPE_INTEGER,
        },{
                .id            = V4L2_CID_SATURATION,
@@ -4394,7 +4394,7 @@ static int __devinit bttv_probe(struct pci_dev *dev,
        if (!bttv_tvcards[btv->c.type].no_video) {
                bttv_register_video(btv);
                bt848_bright(btv,32768);
-               bt848_contrast(btv,32768);
+               bt848_contrast(btv,27648);
                bt848_hue(btv,32768);
                bt848_sat(btv,32768);
                audio_mute(btv, 1);


