Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49727 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1951885AbdDYSVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:22 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, target-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dm-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:20:52 -0600
Message-Id: <1493144468-22493-6-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 05/21] drm/i915: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a single straightforward conversion from kmap to sg_map.

We also create the i915_gem_object_unmap function to common up the
unmap code.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 07e9b27..2c33000 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2202,6 +2202,15 @@ static void __i915_gem_object_reset_page_iter(struct drm_i915_gem_object *obj)
 		radix_tree_delete(&obj->mm.get_page.radix, iter.index);
 }
 
+static void i915_gem_object_unmap(const struct drm_i915_gem_object *obj,
+				  void *ptr)
+{
+	if (is_vmalloc_addr(ptr))
+		vunmap(ptr);
+	else
+		sg_unmap(obj->mm.pages->sgl, ptr, 0, SG_KMAP);
+}
+
 void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
 				 enum i915_mm_subclass subclass)
 {
@@ -2229,10 +2238,7 @@ void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
 		void *ptr;
 
 		ptr = ptr_mask_bits(obj->mm.mapping);
-		if (is_vmalloc_addr(ptr))
-			vunmap(ptr);
-		else
-			kunmap(kmap_to_page(ptr));
+		i915_gem_object_unmap(obj, ptr);
 
 		obj->mm.mapping = NULL;
 	}
@@ -2499,8 +2505,11 @@ static void *i915_gem_object_map(const struct drm_i915_gem_object *obj,
 	void *addr;
 
 	/* A single page can always be kmapped */
-	if (n_pages == 1 && type == I915_MAP_WB)
-		return kmap(sg_page(sgt->sgl));
+	if (n_pages == 1 && type == I915_MAP_WB) {
+		addr = sg_map(sgt->sgl, 0, SG_KMAP);
+		if (IS_ERR(addr))
+			return NULL;
+	}
 
 	if (n_pages > ARRAY_SIZE(stack_pages)) {
 		/* Too big for stack -- allocate temporary array instead */
@@ -2567,11 +2576,7 @@ void *i915_gem_object_pin_map(struct drm_i915_gem_object *obj,
 			goto err_unpin;
 		}
 
-		if (is_vmalloc_addr(ptr))
-			vunmap(ptr);
-		else
-			kunmap(kmap_to_page(ptr));
-
+		i915_gem_object_unmap(obj, ptr);
 		ptr = obj->mm.mapping = NULL;
 	}
 
-- 
2.1.4
