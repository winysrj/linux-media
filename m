Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50357 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751297AbdCYMC7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:59 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/8] [media] staging: sir: make sure we are ready to receive interrupts
Date: Sat, 25 Mar 2017 12:02:24 +0000
Message-Id: <6ce08ca0fb313e3998a6cd437c55eabbe22036ca.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure that the timer is ready before we request interrupts.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_sir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index c9ca86f..058f260 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -338,6 +338,8 @@ static int init_port(void)
 {
 	int retval;
 
+	setup_timer(&timerlist, sir_timeout, 0);
+
 	/* get I/O port access and IRQ line */
 	if (!request_region(io, 8, KBUILD_MODNAME)) {
 		pr_err("i/o port 0x%.4x already in use.\n", io);
@@ -352,8 +354,6 @@ static int init_port(void)
 	}
 	pr_info("I/O port 0x%.4x, IRQ %d.\n", io, irq);
 
-	setup_timer(&timerlist, sir_timeout, 0);
-
 	return 0;
 }
 
-- 
2.9.3
