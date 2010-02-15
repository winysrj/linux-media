Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:60574 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787Ab0BORiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:22 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 11/11] tm6000: change version to 0.0.2
Date: Mon, 15 Feb 2010 18:37:24 +0100
Message-Id: <1266255444-7422-11-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-10-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-6-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-7-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-8-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-9-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-10-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 8611092..8285c5a 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -37,7 +37,7 @@
 #include "dvb_frontend.h"
 #include "dmxdev.h"
 
-#define TM6000_VERSION KERNEL_VERSION(0, 0, 1)
+#define TM6000_VERSION KERNEL_VERSION(0, 0, 2)
 
 /* Inputs */
 
-- 
1.6.6.1

