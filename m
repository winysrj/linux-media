Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:38148 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755643Ab0BORiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:11 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 01/11] xc2028: tm6000: bugfix firmware xc3028L-v36.fw used with Zarlink and DTV78 or DTV8 no shift
Date: Mon, 15 Feb 2010 18:37:14 +0100
Message-Id: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index ed50168..e051caa 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1114,7 +1114,12 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 
 	/* All S-code tables need a 200kHz shift */
 	if (priv->ctrl.demod) {
-		demod = priv->ctrl.demod + 200;
+		if ((priv->firm_version == 0x0306) && 
+			(priv->ctrl.demod == XC3028_FE_ZARLINK456) &&
+				((type & DTV78) || (type & DTV8)))
+			demod = priv->ctrl.demod;
+		else
+			demod = priv->ctrl.demod + 200;
 		/*
 		 * The DTV7 S-code table needs a 700 kHz shift.
 		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
-- 
1.6.6.1

