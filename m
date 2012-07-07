Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41422 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GGSvM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2012 14:51:12 -0400
From: Emil Goode <emilgoode@gmail.com>
To: jarod@wilsonet.com, mchehab@infradead.org,
	gregkh@linuxfoundation.org, rusty@rustcorp.com.au, davej@redhat.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] lirc: fix non-ANSI function declaration warning
Date: Sat,  7 Jul 2012 20:53:25 +0200
Message-Id: <1341687205-21963-1-git-send-email-emilgoode@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sparse is warning about non-ANSI function declaration.
Add void to the parameterless function.

drivers/staging/media/lirc/lirc_bt829.c:174:22: warning:
	non-ANSI function declaration of function 'poll_main'

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/staging/media/lirc/lirc_bt829.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
index 4d20e9f..951007a 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -171,7 +171,7 @@ static void cycle_delay(int cycle)
 }
 
 
-static int poll_main()
+static int poll_main(void)
 {
 	unsigned char status_high, status_low;
 
-- 
1.7.10.4

