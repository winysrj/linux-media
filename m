Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51958 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbaB0PBS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 10:01:18 -0500
Received: from Workstation4.fritz.box ([109.91.85.119]) by mail.gmx.com
 (mrgmx002) with ESMTPSA (Nemesis) id 0MTCDO-1Whks704Hu-00S9BA for
 <linux-media@vger.kernel.org>; Thu, 27 Feb 2014 16:01:17 +0100
From: xypron.glpk@gmx.de
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Reading array out of bound in ds3000_read_snr
Date: Thu, 27 Feb 2014 16:00:53 +0100
Message-Id: <1393513253-10723-1-git-send-email-xypron.glpk@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

An attempt was made to read dvbs2_snr_tab[80],
though dvbs2_snr_tab has only 80 elements.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/media/dvb-frontends/ds3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 1e344b0..335daef 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -616,7 +616,7 @@ static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
 			snr_reading = dvbs2_noise_reading / tmp;
 			if (snr_reading > 80)
 				snr_reading = 80;
-			*snr = -(dvbs2_snr_tab[snr_reading] / 1000);
+			*snr = -(dvbs2_snr_tab[snr_reading - 1] / 1000);
 		}
 		dprintk("%s: raw / cooked = 0x%02x / 0x%04x\n", __func__,
 				snr_reading, *snr);
-- 
1.7.10.4

