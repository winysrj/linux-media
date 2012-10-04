Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61323 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2JDSXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 14:23:04 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so493884bkc.19
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2012 11:23:04 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] drxk: Use the #define instead of hardcoded values.
Date: Thu,  4 Oct 2012 20:22:55 +0200
Message-Id: <1349374975-5934-2-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1349374975-5934-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1349374975-5934-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 8b4c6d5..894b6eca 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -921,7 +921,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
+	status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
 	if (status < 0)
 		goto error;
 	status = read16(state, SIO_PDR_OHW_CFG__A, &sioPdrOhwCfg);
@@ -1217,7 +1217,7 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 		goto error;
 
 	/*  MPEG TS pad configuration */
-	status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
+	status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
 	if (status < 0)
 		goto error;
 
-- 
1.7.12.2

