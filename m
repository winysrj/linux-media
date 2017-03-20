Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33077 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753766AbdCTOmS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:18 -0400
Subject: [PATCH 21/24] staging: atomisp: remove else statement after return
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:42:15 +0000
Message-ID: <149002093288.17109.3683560672141808229.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daeseok Youn <daeseok.youn@gmail.com>

It doesn't need to have else statement after return.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 37d334e..036413b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -2951,11 +2951,11 @@ int atomisp_get_metadata(struct atomisp_sub_device *asd, int flag,
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
