Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33372 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbcLSRVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 12:21:31 -0500
From: Santosh Kumar Singh <kumar.san1093@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: [PATCH] pvrusb2: Clean up file handle in open() error path.
Date: Mon, 19 Dec 2016 22:50:37 +0530
Message-Id: <1482168037-4995-1-git-send-email-kumar.san1093@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to avoid possible exit file handle in error paths.

Signed-off-by: Santosh Kumar Singh <kumar.san1093@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 2cc4d2b..2683373 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -1054,7 +1054,7 @@ static int pvr2_v4l2_open(struct file *file)
 		pvr2_trace(PVR2_TRACE_STRUCT,
 			   "Destroying pvr_v4l2_fh id=%p (input mask error)",
 			   fhp);
-
+		v4l2_fh_exit(&fhp->fh);
 		kfree(fhp);
 		return ret;
 	}
@@ -1071,6 +1071,7 @@ static int pvr2_v4l2_open(struct file *file)
 		pvr2_trace(PVR2_TRACE_STRUCT,
 			   "Destroying pvr_v4l2_fh id=%p (input map failure)",
 			   fhp);
+		v4l2_fh_exit(&fhp->fh);
 		kfree(fhp);
 		return -ENOMEM;
 	}
-- 
1.9.1

