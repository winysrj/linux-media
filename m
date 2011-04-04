Return-path: <mchehab@pedra>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:33557 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab1DDUS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 16:18:59 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/5] tm6000: add audio mode parameter
Date: Mon,  4 Apr 2011 22:18:42 +0200
Message-Id: <1301948324-27186-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

add audio mode parameter


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-stds.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index da3e51b..a9e1921 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -22,12 +22,17 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 
+static unsigned int tm6010_a_mode;
+module_param(tm6010_a_mode, int, 0644);
+MODULE_PARM_DESC(tm6010_a_mode, "set sif audio mode (tm6010 only)");
+
 struct tm6000_reg_settings {
 	unsigned char req;
 	unsigned char reg;
 	unsigned char value;
 };
 
+/* must be updated */
 enum tm6000_audio_std {
 	BG_NICAM,
 	BTSC,
-- 
1.7.3.4

