Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35544 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2EUPe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 11:34:27 -0400
Received: by qabj40 with SMTP id j40so2621534qab.1
        for <linux-media@vger.kernel.org>; Mon, 21 May 2012 08:34:26 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] lg2160: fix off-by-one error in lg216x_write_regs
Date: Mon, 21 May 2012 11:34:02 -0400
Message-Id: <1337614442-31599-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix an off-by-one error in lg216x_write_regs, causing the last element
of the lg216x init block to be ignored.  Spotted by Dan Carpenteter.

Thanks-to: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/frontends/lg2160.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/lg2160.c b/drivers/media/dvb/frontends/lg2160.c
index a3ab1a5..cc11260 100644
--- a/drivers/media/dvb/frontends/lg2160.c
+++ b/drivers/media/dvb/frontends/lg2160.c
@@ -126,7 +126,7 @@ static int lg216x_write_regs(struct lg216x_state *state,
 
 	lg_reg("writing %d registers...\n", len);
 
-	for (i = 0; i < len - 1; i++) {
+	for (i = 0; i < len; i++) {
 		ret = lg216x_write_reg(state, regs[i].reg, regs[i].val);
 		if (lg_fail(ret))
 			return ret;
-- 
1.7.9.5

