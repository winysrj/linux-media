Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39630 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbeK2VYk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 16:24:40 -0500
From: Colin King <colin.king@canonical.com>
To: Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: pvrusb2: fix spelling mistake "statuss" -> "status"
Date: Thu, 29 Nov 2018 10:19:45 +0000
Message-Id: <20181129101945.14518-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pvr2_trace trace message, fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 7702285c1519..446a999dd2ce 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -1698,7 +1698,7 @@ static int pvr2_hdw_untrip_unlocked(struct pvr2_hdw *hdw)
 	if (!hdw->flag_tripped) return 0;
 	hdw->flag_tripped = 0;
 	pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-		   "Clearing driver error statuss");
+		   "Clearing driver error status");
 	return !0;
 }
 
-- 
2.19.1
