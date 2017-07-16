Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32886 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdGPXio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 19:38:44 -0400
From: Shy More <smklearn@gmail.com>
Cc: Shy More <smklearn@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] staging/atomisp: fixed trivial coding style issue
Date: Sun, 16 Jul 2017 16:38:22 -0700
Message-Id: <1500248306-15155-1-git-send-email-smklearn@gmail.com>
In-Reply-To: <20170713151249.GA1451@kroah.com>
References: <20170713151249.GA1451@kroah.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Below was the trival error flagged by checkpatch.pl:
ERROR: space prohibited after that open parenthesis '('

Signed-off-by: Shy More <smklearn@gmail.com>
---
 .../atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
index bb9f5cd..99edb81 100644
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
