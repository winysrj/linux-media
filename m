Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:35584 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1HXReB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 13:34:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id C256C3153A1D
	for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 19:34:00 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id paojpnRk8uLC for <linux-media@vger.kernel.org>;
	Wed, 24 Aug 2011 19:33:54 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 7502B3153A4B
	for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 19:33:53 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] DVB: dvb_frontend: check function pointers on reinitialize
Date: Wed, 24 Aug 2011 17:33:52 +0000
Message-Id: <1314207232-6031-2-git-send-email-obi@linuxtv.org>
In-Reply-To: <1314207232-6031-1-git-send-email-obi@linuxtv.org>
References: <1314207232-6031-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index f433a88..79a3cc3 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -576,12 +576,10 @@ restart:
 
 		if (fepriv->reinitialise) {
 			dvb_frontend_init(fe);
-			if (fepriv->tone != -1) {
+			if (fe->ops.set_tone && fepriv->tone != -1)
 				fe->ops.set_tone(fe, fepriv->tone);
-			}
-			if (fepriv->voltage != -1) {
+			if (fe->ops.set_voltage && fepriv->voltage != -1)
 				fe->ops.set_voltage(fe, fepriv->voltage);
-			}
 			fepriv->reinitialise = 0;
 		}
 
-- 
1.7.2.5

