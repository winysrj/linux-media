Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:58107 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaGYSaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 14:30:55 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so3316630lab.4
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 11:30:54 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: m.chehab@samsung.com, hans.verkuil@cisco.com, khalasa@piap.pl,
	ismael.luceno@corp.bluecherry.net
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] drivers/media/pci/solo6x10/solo6x10-disp.c: check kzalloc() result
Date: Fri, 25 Jul 2014 21:30:49 +0300
Message-Id: <1406313049-9604-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/solo6x10/solo6x10-disp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-disp.c b/drivers/media/pci/solo6x10/solo6x10-disp.c
index ed88ab4..93cbbb1 100644
--- a/drivers/media/pci/solo6x10/solo6x10-disp.c
+++ b/drivers/media/pci/solo6x10/solo6x10-disp.c
@@ -216,6 +216,8 @@ int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 	int ret = 0;
 
 	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 	for (y = 0; y < SOLO_MOTION_SZ; y++) {
 		for (x = 0; x < SOLO_MOTION_SZ; x++)
 			buf[x] = cpu_to_le16(thresholds[y * SOLO_MOTION_SZ + x]);
-- 
1.8.5.5

