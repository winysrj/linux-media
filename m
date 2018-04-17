Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:52811 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752546AbeDQMJB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 08:09:01 -0400
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
To: <linux-media@vger.kernel.org>
CC: Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Joe Perches" <joe@perches.com>
Subject: [PATCH] media: atomisp: fix misleading addr information
Date: Tue, 17 Apr 2018 20:08:09 +0800
Message-ID: <1523966889-62697-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IA_CSS_ERROR shows the ddr_buffer_addr as a decimal value with a '0x'
prefix, which is somewhat misleading.

Let's fix it to print hexadecimal, as was intended.

Fixes: 158aeefc("[media] atomisp: Add __printf validation and fix fallout") 

Cc: Alan Cox <alan@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index c771e4b..4bcc835 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -4455,7 +4455,7 @@ ia_css_pipe_dequeue_buffer(struct ia_css_pipe *pipe,
 			ia_css_rmgr_rel_vbuf(hmm_buffer_pool, &hmm_buffer_record->h_vbuf);
 			sh_css_hmm_buffer_record_reset(hmm_buffer_record);
 		} else {
-			IA_CSS_ERROR("hmm_buffer_record not found (0x%u) buf_type(%d)",
+			IA_CSS_ERROR("hmm_buffer_record not found (0x%x) buf_type(%d)",
 				 ddr_buffer_addr, buf_type);
 			IA_CSS_LEAVE_ERR(IA_CSS_ERR_INTERNAL_ERROR);
 			return IA_CSS_ERR_INTERNAL_ERROR;
-- 
2.7.4
