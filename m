Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57647 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab2KENU0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 08:20:26 -0500
Message-ID: <1352121622.3043.97.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] drxk: Use BUG() for invalid numberOfParameters in
 QAMDemodulatorCommand()
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Mon, 05 Nov 2012 13:20:22 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If numberOfParameters is not 2 or 4, we log a warning and then
continue.  Depending on compiler version and options, this may be
recognised as an impossible case or may otherwise provoke the warning
that 'status' is uninitialised.  Using the more forceful BUG() avoids
this warning, and makes it harder to ignore incorrect usage.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb-frontends/drxk_hard.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 8b4c6d5..6da00ac 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -5459,8 +5459,7 @@ static int QAMDemodulatorCommand(struct drxk_state *state,
 				     numberOfParameters, setParamParameters,
 				     1, &cmdResult);
 	} else {
-		printk(KERN_WARNING "drxk: Unknown QAM demodulator parameter "
-			"count %d\n", numberOfParameters);
+		BUG();
 	}
 
 error:


