Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49911 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab2FUTxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:37 -0400
Received: by mail-yx0-f174.google.com with SMTP id l2so879477yen.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:37 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 02/10] staging: solo6x10: Use linux/{io,uaccess}.h instead of asm/{io,uaccess}.h
Date: Thu, 21 Jun 2012 16:52:04 -0300
Message-Id: <1340308332-1118-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/gpio.c     |    2 +-
 drivers/staging/media/solo6x10/solo6x10.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/solo6x10/gpio.c b/drivers/staging/media/solo6x10/gpio.c
index 0925e6f..6129111 100644
--- a/drivers/staging/media/solo6x10/gpio.c
+++ b/drivers/staging/media/solo6x10/gpio.c
@@ -19,7 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "solo6x10.h"
 
 static void solo_gpio_mode(struct solo_dev *solo_dev,
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index abee721..5e9b399 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -29,7 +29,7 @@
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/atomic.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
-- 
1.7.4.4

