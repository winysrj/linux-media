Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37420 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754312AbdHZIfy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:35:54 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, crope@iki.fi, mchehab@kernel.org,
        hans.verkuil@cisco.com, isely@pobox.com,
        ezequiel@vanguardiasur.com.ar, royale@zerezo.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 03/11] [media] stk1160: make video_device const
Date: Sat, 26 Aug 2017 14:05:07 +0530
Message-Id: <1503736515-15366-4-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
References: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-v4l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a132faa..77b759a 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -751,7 +751,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	.wait_finish		= vb2_ops_wait_finish,
 };
 
-static struct video_device v4l_template = {
+static const struct video_device v4l_template = {
 	.name = "stk1160",
 	.tvnorms = V4L2_STD_525_60 | V4L2_STD_625_50,
 	.fops = &stk1160_fops,
-- 
1.9.1
