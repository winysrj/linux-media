Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:33135 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425815AbdD1MKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:10:42 -0400
Subject: [PATCH 8/8] staging: media: atomisp: kmap() can't fail
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 28 Apr 2017 13:10:39 +0100
Message-ID: <149338143808.2556.11877229471999212854.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
References: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabian Frederick <fabf@skynet.be>

There's no need to check kmap() return value because it won't fail.
If it's highmem mapping, it will receive virtual address
or a new one; if it's lowmem, all kernel pages are already being mapped.

(Thanks to Jan Kara for explanations)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 3588723..5729539 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -333,15 +333,7 @@ static int load_and_flush_by_kmap(ia_css_ptr virt, void *data, unsigned int byte
 		idx = (virt - bo->start) >> PAGE_SHIFT;
 		offset = (virt - bo->start) - (idx << PAGE_SHIFT);
 
-		src = (char *)kmap(bo->page_obj[idx].page);
-		if (!src) {
-			dev_err(atomisp_dev,
-				    "kmap buffer object page failed: "
-				    "pg_idx = %d\n", idx);
-			return -EINVAL;
-		}
-
-		src += offset;
+		src = (char *)kmap(bo->page_obj[idx].page) + offset;
 
 		if ((bytes + offset) >= PAGE_SIZE) {
 			len = PAGE_SIZE - offset;
@@ -538,14 +530,7 @@ int hmm_set(ia_css_ptr virt, int c, unsigned int bytes)
 		idx = (virt - bo->start) >> PAGE_SHIFT;
 		offset = (virt - bo->start) - (idx << PAGE_SHIFT);
 
-		des = (char *)kmap(bo->page_obj[idx].page);
-		if (!des) {
-			dev_err(atomisp_dev,
-				    "kmap buffer object page failed: "
-				    "pg_idx = %d\n", idx);
-			return -EINVAL;
-		}
-		des += offset;
+		des = (char *)kmap(bo->page_obj[idx].page) + offset;
 
 		if ((bytes + offset) >= PAGE_SIZE) {
 			len = PAGE_SIZE - offset;
