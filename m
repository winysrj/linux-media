Return-path: <mchehab@pedra>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:43127 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717Ab0HXTgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 15:36:16 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/2] tm6000: bugfix param string
Date: Tue, 24 Aug 2010 21:36:09 +0200
Message-Id: <1282678570-13462-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 32f7a0a..7b07096 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -36,7 +36,7 @@ MODULE_PARM_DESC(ir_debug, "enable debug message [IR]");
 
 static unsigned int enable_ir = 1;
 module_param(enable_ir, int, 0644);
-MODULE_PARM_DESC(enable_ir, "enable ir (default is enable");
+MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 
 #undef dprintk
 
-- 
1.7.1

