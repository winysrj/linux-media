Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ukl.yahoo.com ([217.146.183.200]:43625 "HELO
	nm2.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752694Ab1IYNx3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 09:53:29 -0400
Message-ID: <4E7F3255.5060209@yahoo.com>
Date: Sun, 25 Sep 2011 14:53:25 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH] EM28xx - remove unused prototypes
Content-Type: multipart/mixed;
 boundary="------------020607060508040004050300"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020607060508040004050300
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Mauro,

This patch just removes the prototypes for the two functions that I've already 
deleted in my previous patches.

Cheers,
Chris

Signed-off-by: Chris Rankin <rankincj@yahoo.com>

--------------020607060508040004050300
Content-Type: text/x-patch;
 name="EM28xx-remove-unused-prototypes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-remove-unused-prototypes.diff"

--- linux/drivers/media/video/em28xx/em28xx.h.orig	2011-09-25 14:46:02.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx.h	2011-09-25 14:46:10.000000000 +0100
@@ -678,8 +678,6 @@
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
 int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio);
 void em28xx_wake_i2c(struct em28xx *dev);
-void em28xx_remove_from_devlist(struct em28xx *dev);
-void em28xx_add_into_devlist(struct em28xx *dev);
 int em28xx_register_extension(struct em28xx_ops *dev);
 void em28xx_unregister_extension(struct em28xx_ops *dev);
 void em28xx_init_extension(struct em28xx *dev);

--------------020607060508040004050300--
