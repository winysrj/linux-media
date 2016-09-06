Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46799 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932286AbcIFMpg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 08:45:36 -0400
From: Colin King <colin.king@canonical.com>
To: Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] variable name is never null, so remove null check
Date: Tue,  6 Sep 2016 13:44:09 +0100
Message-Id: <20160906124409.16385-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The variable name is always assigned to a literal string in the
proceeding switch statement, so it is never null and hence the
null check is redundant. Remove null the check.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 06fe63c..d977976 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -116,7 +116,6 @@ static ssize_t show_type(struct device *class_dev,
 	}
 	pvr2_sysfs_trace("pvr2_sysfs(%p) show_type(cid=%d) is %s",
 			 cip->chptr, cip->ctl_id, name);
-	if (!name) return -EINVAL;
 	return scnprintf(buf, PAGE_SIZE, "%s\n", name);
 }
 
-- 
2.9.3

