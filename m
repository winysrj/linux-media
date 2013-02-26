Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54402 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab3BZT22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 14:28:28 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so2653935pab.3
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2013 11:28:28 -0800 (PST)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Cc: syamsidhardh@gmail.com, awalls@md.metrocast.net, mchehab@redhat.com
Subject: [PATCH] media: ivtv: Remove redundant NULL check before kfree
Date: Wed, 27 Feb 2013 00:58:15 +0530
Message-Id: <1361906895-2687-1-git-send-email-s.syam@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/media/pci/ivtv/ivtvfb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 05b94aa..9ff1230 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -1171,8 +1171,7 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 		fb_dealloc_cmap(&oi->ivtvfb_info.cmap);
 
 	/* Release pseudo palette */
-	if (oi->ivtvfb_info.pseudo_palette)
-		kfree(oi->ivtvfb_info.pseudo_palette);
+	kfree(oi->ivtvfb_info.pseudo_palette);
 
 #ifdef CONFIG_MTRR
 	if (oi->fb_end_aligned_physaddr) {
-- 
1.7.9.5

