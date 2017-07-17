Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33118 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdGQELZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 00:11:25 -0400
From: Shy More <smklearn@gmail.com>
Cc: joe@perches.com, Shy More <smklearn@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] [media] staging/atomisp: fixed trivial coding style issue
Date: Sun, 16 Jul 2017 21:10:57 -0700
Message-Id: <1500264662-18331-1-git-send-email-smklearn@gmail.com>
In-Reply-To: <1500249440.4457.95.camel@perches.com>
References: <1500249440.4457.95.camel@perches.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Below was the trival error flagged by checkpatch.pl:
ERROR: space prohibited after that open parenthesis '('

Signed-off-by: Shy More <smklearn@gmail.com>

---
changes in v2:
- made the suggested corrections
---
 .../atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c     | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
index bb9f5cd..faef976 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
@@ -130,8 +130,7 @@ void ia_css_isys_ibuf_rmgr_release(
 
 	for (i = 0; i < ibuf_rsrc.num_allocated; i++) {
 		handle = getHandle(i);
-		if ((handle->start_addr == *start_addr)
-		    && ( true == handle->active)) {
+		if (handle->active && handle->start_addr == *start_addr) {
 			handle->active = false;
 			ibuf_rsrc.num_active--;
 			break;
-- 
1.9.1
