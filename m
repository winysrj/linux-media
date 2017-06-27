Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:64543 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753262AbdF0PDh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 11:03:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [media] venus: don't abuse dma_alloc for non-DMA allocations
Date: Tue, 27 Jun 2017 17:02:47 +0200
Message-Id: <20170627150310.719212-2-arnd@arndb.de>
In-Reply-To: <20170627150310.719212-1-arnd@arndb.de>
References: <20170627150310.719212-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In venus_boot(), we pass a pointer to a phys_addr_t
into dmam_alloc_coherent, which the compiler warns about:

platform/qcom/venus/firmware.c: In function 'venus_boot':
platform/qcom/venus/firmware.c:63:49: error: passing argument 3 of 'dmam_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]

The returned DMA address is later passed on to a function that
takes a phys_addr_t, so it's clearly wrong to use the DMA
mapping interface here: the memory may be uncached, or the
address may be completely wrong if there is an IOMMU connected
to the device.

My interpretation is that using dmam_alloc_coherent() had two
purposes:

 a) get a chunk of consecutive memory that may be larger than
    the limit for kmalloc()

 b) use the devres infrastructure to simplify the unwinding
    in the error case.

I think ideally we'd use a devres-based version of
alloc_pages_exact() here, but since that doesn't exist,
let's use devm_get_free_pages() instead. This wastes a little
memory as the size gets rounded up to a power of two, but
is otherwise harmless. If we want to save memory here, calling
devm_free_pages() to release the memory once it is no longer
needed is probably better anyway.

Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
The same problem exists in the drm driver, as of commit 7c65817e6d38
("drm/msm: gpu: Enable zap shader for A5XX"), and I submitted the
same patch for that already.
---
 drivers/media/platform/qcom/venus/firmware.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 1b1a4f355918..76edb9f60311 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -60,11 +60,13 @@ int venus_boot(struct device *parent, struct device *fw_dev, const char *fwname)
 
 	mem_size = VENUS_FW_MEM_SIZE;
 
-	mem_va = dmam_alloc_coherent(fw_dev, mem_size, &mem_phys, GFP_KERNEL);
+	mem_va = (void *)devm_get_free_pages(parent, GFP_KERNEL,
+					     get_order(mem_size));
 	if (!mem_va) {
 		ret = -ENOMEM;
 		goto err_unreg_device;
 	}
+	mem_phys = virt_to_phys(mem_va);
 
 	ret = request_firmware(&mdt, fwname, fw_dev);
 	if (ret < 0)
-- 
2.9.0
