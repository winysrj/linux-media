Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34773 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940333AbdDSXOd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:33 -0400
Received: by mail-qk0-f174.google.com with SMTP id y63so2964384qkd.1
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:33 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 07/12] au8522: fix lock detection to be more reliable.
Date: Wed, 19 Apr 2017 19:13:50 -0400
Message-Id: <1492643635-30823-8-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only looking at the lock register causes the status to float
between locked and not locked when there is no signal.  So improve
the logic to also examine the state of the FSC PLL, which results
in the lock status being consistently reported.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 5e21640..343dc92 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -623,10 +623,12 @@ static int au8522_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	int val = 0;
 	struct au8522_state *state = to_state(sd);
 	u8 lock_status;
+	u8 pll_status;
 
 	/* Interrogate the decoder to see if we are getting a real signal */
 	lock_status = au8522_readreg(state, 0x00);
-	if (lock_status == 0xa2)
+	pll_status = au8522_readreg(state, 0x7e);
+	if ((lock_status == 0xa2) && (pll_status & 0x10))
 		vt->signal = 0xffff;
 	else
 		vt->signal = 0x00;
-- 
1.9.1
