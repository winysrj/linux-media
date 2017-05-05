Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35234 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbdEEMuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 08:50:54 -0400
From: Surender Polsani <surenderpolsani@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Surender Polsani <surenderpolsani@gmail.com>
Subject: [V1] staging : media : fixed macro expansion error
Date: Fri,  5 May 2017 18:20:46 +0530
Message-Id: <1493988646-3813-1-git-send-email-surenderpolsani@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enclosing complex macro expansion with parentheses is
meaningfull according kernel coding style

Signed-off-by: Surender Polsani <surenderpolsani@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 375c617..b9cafbb 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2001,8 +2001,8 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
 }
 
 #define DEFINE_SYSFS_PROPERTY(prop, signal, size, mask, check)		\
-property_write(prop, signal size, mask, check)				\
-property_read(prop, size, mask)
+(property_write(prop, signal size, mask, check)				\
+property_read(prop, size, mask))
 
 #define property_str_read(prop, size)					\
 static ssize_t bcm2048_##prop##_read(struct device *dev,		\
-- 
1.9.1
