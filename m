Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:47335 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933959Ab0BEWs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:48:58 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 11/12] tm6000: bugfix firmware xc3028L-v36.fw used with Zarlink and DTV78 or DTV8 no shift
Date: Fri,  5 Feb 2010 23:48:15 +0100
Message-Id: <1265410096-11788-10-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410096-11788-9-git-send-email-stefan.ringel@arcor.de>
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-6-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-7-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-8-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-9-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

---
 drivers/media/common/tuners/tuner-xc2028.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index ed50168..fcf19cc 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1114,7 +1114,12 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 
 	/* All S-code tables need a 200kHz shift */
 	if (priv->ctrl.demod) {
-		demod = priv->ctrl.demod + 200;
+		if ((strcmp (priv->ctrl.fname, "xc3028L-v36.fw") == 0) && 
+			(priv->ctrl.demod == XC3028_FE_ZARLINK456) &&
+				((type & DTV78) || (type & DTV8)))
+			demod = priv->ctrl.demod;
+		else
+			demod = priv->ctrl.demod + 200;
 		/*
 		 * The DTV7 S-code table needs a 700 kHz shift.
 		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
-- 
1.6.4.2

