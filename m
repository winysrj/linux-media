Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:42292 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415Ab0EJQY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 12:24:27 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/2] tm6000: bugfix tuner callback
Date: Mon, 10 May 2010 18:22:50 +0200
Message-Id: <1273508571-16472-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 6143e20..9f6160b 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -563,7 +563,7 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 
 	switch (dev->tuner_type) {
 	case TUNER_XC2028:
-		tun_setup.tuner_callback = tm6000_tuner_callback;;
+		tun_setup.tuner_callback = tm6000_tuner_callback;
 		break;
 	case TUNER_XC5000:
 		tun_setup.tuner_callback = tm6000_xc5000_callback;
-- 
1.7.0.3

