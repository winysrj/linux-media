Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52379 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab1KHXQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 18:16:23 -0500
Received: by faan17 with SMTP id n17so1063733faa.19
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2011 15:16:22 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH] staging: as102: Add missing function argument
Date: Wed,  9 Nov 2011 00:16:04 +0100
Message-Id: <1320794164-11537-1-git-send-email-snjw23@gmail.com>
In-Reply-To: <4EB9304C.5020305@redhat.com>
References: <4EB9304C.5020305@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing dev argument in dev_err() call to correct an error
introduced in commit 880102898f19cf9f9ba36dc9d838b5476645ce00
"...as102: Fix the dvb device registration error path".

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index b8adfd2..beacb2c 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -220,7 +220,7 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 
 	ret = dvb_dmx_init(&as102_dev->dvb_dmx);
 	if (ret < 0) {
-		dev_err("%s: dvb_dmx_init() failed: %d\n", __func__, ret);
+		dev_err(dev, "%s: dvb_dmx_init() failed: %d\n", __func__, ret);
 		goto edmxinit;
 	}
 
-- 
1.7.5.4

