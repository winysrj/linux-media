Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab1KFUca (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:30 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498582faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:29 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 10/13] staging: as102: Use linux/uaccess.h instead of asm/uaccess.h
Date: Sun,  6 Nov 2011 21:31:47 +0100
Message-Id: <1320611510-3326-11-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 3234039..44f6017 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -24,7 +24,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/kref.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 
 /* header file for Usb device driver*/
-- 
1.7.5.4

