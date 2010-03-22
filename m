Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([91.197.165.186]:33511 "EHLO
	mail.dmz-ext.fr.lan" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884Ab0CVSZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 14:25:59 -0400
From: Nicolas Noirbent <nicolas.noirbent@smartjog.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, "Igor M. Liplianin" <liplianin@me.by>,
	matthias@tevii.com,
	Nicolas Noirbent <nicolas.noirbent@smartjog.com>
Subject: [PATCH] V4L/DVB: ds3000: fix divide-by-zero error in ds3000_read_snr()
Date: Mon, 22 Mar 2010 18:54:43 +0100
Message-Id: <1269280483-4586-1-git-send-email-nicolas.noirbent@smartjog.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a divide-by-zero error in ds3000's ds3000_read_snr(), when getting
a very low signal reading (dvbs2_signal_reading >= 1). This prevents
some nasty EIPs when running szap-s2 with a very low signal strength.

Signed-off-by: Nicolas Noirbent <nicolas.noirbent@smartjog.com>
---
 drivers/media/dvb/frontends/ds3000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index cff3535..78001e8 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -719,7 +719,7 @@ static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
 				(ds3000_readreg(state, 0x8d) << 4);
 		dvbs2_signal_reading = ds3000_readreg(state, 0x8e);
 		tmp = dvbs2_signal_reading * dvbs2_signal_reading >> 1;
-		if (dvbs2_signal_reading == 0) {
+		if (tmp == 0) {
 			*snr = 0x0000;
 			return 0;
 		}
-- 
1.7.0.2

