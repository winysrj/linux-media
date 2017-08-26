Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34810 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdHZIgb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:36:31 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, crope@iki.fi, mchehab@kernel.org,
        hans.verkuil@cisco.com, isely@pobox.com,
        ezequiel@vanguardiasur.com.ar, royale@zerezo.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 07/11] [media] msi2500: make video_device const
Date: Sat, 26 Aug 2017 14:05:11 +0530
Message-Id: <1503736515-15366-8-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
References: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/msi2500/msi2500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 79bfd2d..a097d3d 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1143,7 +1143,7 @@ static int msi2500_enum_freq_bands(struct file *file, void *priv,
 	.unlocked_ioctl           = video_ioctl2,
 };
 
-static struct video_device msi2500_template = {
+static const struct video_device msi2500_template = {
 	.name                     = "Mirics MSi3101 SDR Dongle",
 	.release                  = video_device_release_empty,
 	.fops                     = &msi2500_fops,
-- 
1.9.1
