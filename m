Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:53963 "EHLO m50-132.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750919AbcLCMjy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Dec 2016 07:39:54 -0500
From: Pan Bian <bianpan201602@163.com>
To: Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] media: platform: sti: return -ENOMEM on errors
Date: Sat,  3 Dec 2016 20:39:33 +0800
Message-Id: <1480768773-5926-1-git-send-email-bianpan201602@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pan Bian <bianpan2016@163.com>

Function bdisp_debugfs_create() returns 0 even on errors. So its caller
cannot detect the errors. It may be better to return "-ENOMEM" on the
exception paths.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188801

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/media/platform/sti/bdisp/bdisp-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
index 79c5635..7af6686 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
@@ -677,7 +677,7 @@ int bdisp_debugfs_create(struct bdisp_dev *bdisp)
 
 err:
 	bdisp_debugfs_remove(bdisp);
-	return 0;
+	return -ENOMEM;
 }
 
 void bdisp_debugfs_remove(struct bdisp_dev *bdisp)
-- 
1.9.1


