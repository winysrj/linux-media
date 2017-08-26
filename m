Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36132 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdHZIgK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:36:10 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, crope@iki.fi, mchehab@kernel.org,
        hans.verkuil@cisco.com, isely@pobox.com,
        ezequiel@vanguardiasur.com.ar, royale@zerezo.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 05/11] [media] pwc: make video_device const
Date: Sat, 26 Aug 2017 14:05:09 +0530
Message-Id: <1503736515-15366-6-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
References: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/pwc/pwc-if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 22420c1..eb6921d 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -146,7 +146,7 @@
 	.mmap =		vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
-static struct video_device pwc_template = {
+static const struct video_device pwc_template = {
 	.name =		"Philips Webcam",	/* Filled in later */
 	.release =	video_device_release_empty,
 	.fops =         &pwc_fops,
-- 
1.9.1
