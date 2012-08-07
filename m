Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab2HGCr4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:56 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:56 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 10/24] au8522: fix regression in logging introduced by separation of modules
Date: Mon,  6 Aug 2012 22:47:00 -0400
Message-Id: <1344307634-11673-11-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The au8522 driver was broken into three modules (dig, decoder, common), and
as a result the debug modprobe option doesn't work for any of the common
functions.

Copy the module macros over to the common module so that the debug option
works again.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb/frontends/au8522_common.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/au8522_common.c b/drivers/media/dvb/frontends/au8522_common.c
index 5cfe151..8b4da40 100644
--- a/drivers/media/dvb/frontends/au8522_common.c
+++ b/drivers/media/dvb/frontends/au8522_common.c
@@ -26,8 +26,6 @@
 #include "dvb_frontend.h"
 #include "au8522_priv.h"
 
-MODULE_LICENSE("GPL");
-
 static int debug;
 
 #define dprintk(arg...)\
@@ -257,3 +255,10 @@ int au8522_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 EXPORT_SYMBOL(au8522_sleep);
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Enable verbose debug messages");
+
+MODULE_DESCRIPTION("Auvitek AU8522 QAM-B/ATSC Demodulator driver");
+MODULE_AUTHOR("Steven Toth");
+MODULE_LICENSE("GPL");
-- 
1.7.1

