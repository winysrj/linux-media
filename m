Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36445
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754994AbdFXUlN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:41:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jean-Baptiste Abbadie <jb@abbadie.fr>,
        Shilpa P <shilpapri@gmail.com>,
        Rehas Sachdeva <aquannie@gmail.com>,
        Nikola Jelic <nikola.jelic83@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 3/4] media: radio-bcm2048: get rid of BCM2048_DRIVER_VERSION
Date: Sat, 24 Jun 2017 17:40:26 -0300
Message-Id: <6cf7b54fc87bf54d18d9d686165c49c93a19a6db.1498336792.git.mchehab@s-opensource.com>
In-Reply-To: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
References: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
In-Reply-To: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
References: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This macro is never used. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 38f72d069e27..86d7fc20f237 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -48,7 +48,6 @@
 /* driver definitions */
 #define BCM2048_DRIVER_AUTHOR	"Eero Nurkkala <ext-eero.nurkkala@nokia.com>"
 #define BCM2048_DRIVER_NAME	BCM2048_NAME
-#define BCM2048_DRIVER_VERSION	KERNEL_VERSION(0, 0, 1)
 #define BCM2048_DRIVER_CARD	"Broadcom bcm2048 FM Radio Receiver"
 #define BCM2048_DRIVER_DESC	"I2C driver for BCM2048 FM Radio Receiver"
 
-- 
2.9.4
