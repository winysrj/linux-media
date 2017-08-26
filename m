Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34172 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdHZIhG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:37:06 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, crope@iki.fi, mchehab@kernel.org,
        hans.verkuil@cisco.com, isely@pobox.com,
        ezequiel@vanguardiasur.com.ar, royale@zerezo.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 11/11] [media] airspy: make video_device const
Date: Sat, 26 Aug 2017 14:05:15 +0530
Message-Id: <1503736515-15366-12-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
References: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/airspy/airspy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 07f3f4e..e70c9e2 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -859,7 +859,7 @@ static int airspy_enum_freq_bands(struct file *file, void *priv,
 	.unlocked_ioctl           = video_ioctl2,
 };
 
-static struct video_device airspy_template = {
+static const struct video_device airspy_template = {
 	.name                     = "AirSpy SDR",
 	.release                  = video_device_release_empty,
 	.fops                     = &airspy_fops,
-- 
1.9.1
