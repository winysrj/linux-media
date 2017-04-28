Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39012 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965710AbdD1MJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:09:27 -0400
Subject: [PATCH 1/8] atomisp: handle allocation calls before init in the hmm
 layer
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 28 Apr 2017 13:09:23 +0100
Message-ID: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the code handles this in the abstraction above. We want to remove
that abstraction so begin by pushing down the sanity check. Unfortunately
at this point we can't simply fix the init order.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 151abf0..14537ab 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -226,6 +226,11 @@ ia_css_ptr hmm_alloc(size_t bytes, enum hmm_bo_type type,
 	struct hmm_buffer_object *bo;
 	int ret;
 
+	/* Check if we are initialized. In the ideal world we wouldn't need
+	   this but we can tackle it once the driver is a lot cleaner */
+
+	if (!dummy_ptr)
+		hmm_init();
 	/*Get page number from size*/
 	pgnr = size_to_pgnr_ceil(bytes);
 
