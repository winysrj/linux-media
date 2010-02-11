Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:36465 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075Ab0BKPwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 10:52:08 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: bugfix firmware xc3028L-v36.fw used with Zarlink and DTV78 or DTV8 no shift
Date: Thu, 11 Feb 2010 16:51:26 +0100
Message-Id: <1265903486-15058-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/media/common/tuners/tuner-xc2028.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

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

