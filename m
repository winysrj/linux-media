Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44807 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1CFQhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 11:37:13 -0500
Received: by wyg36 with SMTP id 36so3534473wyg.19
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2011 08:37:11 -0800 (PST)
Subject: [PATCH] STV0288 added full frontend status
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 16:37:00 +0000
Message-ID: <1299429420.14858.5.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

status now returns
 FE_HAS_CARRIER
 FE_HAS_SIGNAL
 FE_HAS_VITERBI

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/stv0288.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index 63db8fd..5e8c7fd 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -367,8 +367,11 @@ static int stv0288_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	dprintk("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __func__, sync);
 
 	*status = 0;
-
-	if ((sync & 0x08) == 0x08) {
+	if (sync & 0x80)
+		*status |= FE_HAS_CARRIER | FE_HAS_SIGNAL;
+	if (sync & 0x10)
+		*status |= FE_HAS_VITERBI;
+	if (sync & 0x08) {
 		*status |= FE_HAS_LOCK;
 		dprintk("stv0288 has locked\n");
 	}
-- 
1.7.1

