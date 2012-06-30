Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51113 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2F3Wme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 18:42:34 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so3878345bkc.19
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 15:42:33 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] [media] drxk: Improve logging.
Date: Sun,  1 Jul 2012 00:42:15 +0200
Message-Id: <1341096135-1393-2-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1340918440-17523-3-git-send-email-martin.blumenstingl@googlemail.com>
References: <1340918440-17523-3-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch simply fixes some logging calls:
- Use KERN_INFO when printing the chip status.
- Add a missing space when logging the drxk_gate_ctrl call.
- Use the same logging text as always if the scu_command in GetQAMLockStatus fails.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/dvb/frontends/drxk_hard.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index ef146ca..128a4e6 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -959,7 +959,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	if (status < 0)
 		goto error;
 
-printk(KERN_ERR "drxk: status = 0x%08x\n", sioTopJtagidLo);
+	printk(KERN_INFO "drxk: status = 0x%08x\n", sioTopJtagidLo);
 
 	/* driver 0.9.0 */
 	switch ((sioTopJtagidLo >> 29) & 0xF) {
@@ -5388,7 +5388,7 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 			SCU_RAM_COMMAND_CMD_DEMOD_GET_LOCK, 0, NULL, 2,
 			Result);
 	if (status < 0)
-		printk(KERN_ERR "drxk: %s status = %08x\n", __func__, status);
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	if (Result[1] < SCU_RAM_QAM_LOCKED_LOCKED_DEMOD_LOCKED) {
 		/* 0x0000 NOT LOCKED */
@@ -6318,7 +6318,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
-	dprintk(1, "%s\n", enable ? "enable" : "disable");
+	dprintk(1, ": %s\n", enable ? "enable" : "disable");
 
 	if (state->m_DrxkState == DRXK_NO_DEV)
 		return -ENODEV;
-- 
1.7.11.1

