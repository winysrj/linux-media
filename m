Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33096 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754192AbdCTLFw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 07:05:52 -0400
Date: Mon, 20 Mar 2017 19:59:15 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] staging: atomisp: remove else statement after return
Message-ID: <20170320105915.GA17117@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't need to have else statement after return.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index d97a8df..8bdb224 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -2958,11 +2958,11 @@ int atomisp_get_metadata(struct atomisp_sub_device *asd, int flag,
 		dev_err(isp->dev, "copy to user failed: copied %d bytes\n",
 			ret);
 		return -EFAULT;
-	} else {
-		list_del_init(&md_buf->list);
-		list_add_tail(&md_buf->list, &asd->metadata[md_type]);
 	}
 
+	list_del_init(&md_buf->list);
+	list_add_tail(&md_buf->list, &asd->metadata[md_type]);
+
 	dev_dbg(isp->dev, "%s: HAL de-queued metadata type %d with exp_id %d\n",
 		__func__, md_type, md->exp_id);
 	return 0;
-- 
1.9.1
