Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36552 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbdGMPvK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:51:10 -0400
From: Shy More <smklearn@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, smklearn@gmail.com
Subject: [PATCH] [media] staging/atomisp: fix minor coding style issue
Date: Thu, 13 Jul 2017 08:50:39 -0700
Message-Id: <1499961039-12293-1-git-send-email-smklearn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Below was the minor issue flagged by checkpatch.pl:
- ERROR: space prohibited after that open parenthesis '('

Signed-off-by: Shy More <smklearn@gmail.com>
---
 .../atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
index 76d9142..4e61cb7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
@@ -131,7 +131,7 @@ void ia_css_isys_ibuf_rmgr_release(
 	for (i = 0; i < ibuf_rsrc.num_allocated; i++) {
 		handle = getHandle(i);
 		if ((handle->start_addr == *start_addr)
-		    && ( true == handle->active)) {
+		    && (true == handle->active)) {
 			handle->active = false;
 			ibuf_rsrc.num_active--;
 			break;
-- 
1.9.1
