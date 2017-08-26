Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38762 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdHZGCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 02:02:37 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, awalls@md.metrocast.net, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] cx18: make v4l2_file_operations const
Date: Sat, 26 Aug 2017 11:32:08 +0530
Message-Id: <1503727328-29254-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only stored in a const field of a
video_device structure.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx18/cx18-streams.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index 81d06c1..8385411 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -31,7 +31,7 @@
 
 #define CX18_DSP0_INTERRUPT_MASK     	0xd0004C
 
-static struct v4l2_file_operations cx18_v4l2_enc_fops = {
+static const struct v4l2_file_operations cx18_v4l2_enc_fops = {
 	.owner = THIS_MODULE,
 	.read = cx18_v4l2_read,
 	.open = cx18_v4l2_open,
-- 
1.9.1
