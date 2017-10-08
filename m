Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38002 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbdJHJYL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 05:24:11 -0400
Date: Sun, 8 Oct 2017 14:54:03 +0530
From: Aishwarya Pant <aishpant@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: outreachy-kernel@googlegroups.com
Subject: [PATCH 2/2] staging: atomisp: cleanup out of memory messages
Message-ID: <644e80397e30cfa2085c7dd0548ae7e74f0ea4a0.1507454423.git.aishpant@gmail.com>
References: <cover.1507454423.git.aishpant@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1507454423.git.aishpant@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Logging of explicit out of memory messages is redundant since memory allocation
failures produce a backtrace.

Done with the help of the following cocci script:

@@
expression ex, ret;
statement s;
constant char[] c;
constant err;
identifier f, l;
@@

ex =
\(kmalloc\|kmalloc_array\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\|devm_kzalloc\)(...)
... when != ex

if (
(
!ex
|
unlikely(!ex)
)
)
- {
- f(..., c, ...);
(
return ret;
|
return;
|
return err;
|
goto l;
)
- }
else s

Another case where if branch has multiple statements was handled with the
following condition:

{
...
- f(..., c, ...);
...
}

Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c                     |  4 +---
 drivers/staging/media/atomisp/i2c/gc0310.c                     |  4 +---
 drivers/staging/media/atomisp/i2c/gc2235.c                     |  4 +---
 drivers/staging/media/atomisp/i2c/imx/imx.c                    |  4 +---
 drivers/staging/media/atomisp/i2c/lm3554.c                     |  4 +---
 drivers/staging/media/atomisp/i2c/mt9m114.c                    |  4 +---
 drivers/staging/media/atomisp/i2c/ov2680.c                     |  4 +---
 drivers/staging/media/atomisp/i2c/ov2722.c                     |  4 +---
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c              |  4 +---
 drivers/staging/media/atomisp/i2c/ov8858.c                     |  6 +-----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c      |  4 +---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  9 ++-------
 .../media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c  |  4 +---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c        | 10 ++--------
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c  |  6 +-----
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c |  5 +----
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c        |  4 +---
 .../media/atomisp/platform/intel-mid/atomisp_gmin_platform.c   |  4 +---
 18 files changed, 20 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index 2f772a020c8b..bfbf85122c3b 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -1153,10 +1153,8 @@ static int ap1302_probe(struct i2c_client *client,
 
 	/* allocate device & init sub device */
 	dev = devm_kzalloc(&client->dev, sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "%s: out of memory\n", __func__);
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 35ed51ffe944..291565451bfe 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -1385,10 +1385,8 @@ static int gc0310_probe(struct i2c_client *client,
 
 	pr_info("%s S\n", __func__);
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "out of memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index e43d31ea9676..f51535eee091 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -1123,10 +1123,8 @@ static int gc2235_probe(struct i2c_client *client,
 	unsigned int i;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "out of memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.c b/drivers/staging/media/atomisp/i2c/imx/imx.c
index 49ab0af87096..957fb1863b40 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.c
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.c
@@ -2365,10 +2365,8 @@ static int imx_probe(struct i2c_client *client,
 
 	/* allocate sensor device & init sub device */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		v4l2_err(client, "%s: out of memory\n", __func__);
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/lm3554.c
index 679176f7c542..37876d245a02 100644
--- a/drivers/staging/media/atomisp/i2c/lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/lm3554.c
@@ -871,10 +871,8 @@ static int lm3554_probe(struct i2c_client *client,
 	int ret;
 
 	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
-	if (!flash) {
-		dev_err(&client->dev, "out of memory\n");
+	if (!flash)
 		return -ENOMEM;
-	}
 
 	flash->pdata = client->dev.platform_data;
 
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 3c837cb8859c..e204238ae06b 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1863,10 +1863,8 @@ static int mt9m114_probe(struct i2c_client *client,
 
 	/* Setup sensor configuration structure */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "out of memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	v4l2_i2c_subdev_init(&dev->sd, client, &mt9m114_ops);
 	pdata = client->dev.platform_data;
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 51b7d61df0f5..c81e80e7bdea 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -1447,10 +1447,8 @@ static int ov2680_probe(struct i2c_client *client,
 	unsigned int i;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "out of memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index 10094ac56561..5f2e8a2798ef 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -1285,10 +1285,8 @@ static int ov2722_probe(struct i2c_client *client,
 	struct acpi_device *adev;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "out of memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 123642557aa8..3560f3cd25e8 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -1965,10 +1965,8 @@ static int ov5693_probe(struct i2c_client *client,
 	}
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "out of memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index 43e1638fd674..918139d3d3c0 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -480,8 +480,6 @@ static int ov8858_priv_int_data_init(struct v4l2_subdev *sd)
 	if (!dev->otp_data) {
 		dev->otp_data = devm_kzalloc(&client->dev, size, GFP_KERNEL);
 		if (!dev->otp_data) {
-			dev_err(&client->dev, "%s: can't allocate memory",
-				__func__);
 			r = -ENOMEM;
 			goto error3;
 		}
@@ -2094,10 +2092,8 @@ static int ov8858_probe(struct i2c_client *client,
 
 	/* allocate sensor device & init sub device */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&client->dev, "%s: out of memory\n", __func__);
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mutex_init(&dev->input_lock);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index d8cfed358d55..d64c98944d49 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -1137,10 +1137,8 @@ static int remove_pad_from_frame(struct atomisp_device *isp,
 	ia_css_ptr store = load;
 
 	buffer = kmalloc(width*sizeof(load), GFP_KERNEL);
-	if (!buffer) {
-		dev_err(isp->dev, "out of memory.\n");
+	if (!buffer)
 		return -ENOMEM;
-	}
 
 	load += ISP_LEFT_PAD;
 	for (i = 0; i < height; i++) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 717647951fb6..889cc73be800 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -943,10 +943,8 @@ int atomisp_alloc_css_stat_bufs(struct atomisp_sub_device *asd,
 		dev_dbg(isp->dev, "allocating %d 3a buffers\n", count);
 		while (count--) {
 			s3a_buf = kzalloc(sizeof(struct atomisp_s3a_buf), GFP_KERNEL);
-			if (!s3a_buf) {
-				dev_err(isp->dev, "s3a stat buf alloc failed\n");
+			if (!s3a_buf)
 				goto error;
-			}
 
 			if (atomisp_css_allocate_stat_buffers(
 					asd, stream_id, s3a_buf, NULL, NULL)) {
@@ -965,7 +963,6 @@ int atomisp_alloc_css_stat_bufs(struct atomisp_sub_device *asd,
 		while (count--) {
 			dis_buf = kzalloc(sizeof(struct atomisp_dis_buf), GFP_KERNEL);
 			if (!dis_buf) {
-				dev_err(isp->dev, "dis stat buf alloc failed\n");
 				kfree(s3a_buf);
 				goto error;
 			}
@@ -990,10 +987,8 @@ int atomisp_alloc_css_stat_bufs(struct atomisp_sub_device *asd,
 			while (count--) {
 				md_buf = kzalloc(sizeof(struct atomisp_metadata_buf),
 						 GFP_KERNEL);
-				if (!md_buf) {
-					dev_err(isp->dev, "metadata buf alloc failed\n");
+				if (!md_buf)
 					goto error;
-				}
 
 				if (atomisp_css_allocate_stat_buffers(
 						asd, stream_id, NULL, NULL, md_buf)) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
index 48e2e63c2336..e6ebd1b08f0d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
@@ -365,10 +365,8 @@ ia_css_shading_table_alloc(
 	IA_CSS_ENTER("");
 
 	me = kmalloc(sizeof(*me), GFP_KERNEL);
-	if (!me) {
-		IA_CSS_ERROR("out of memory");
+	if (!me)
 		return me;
-	}
 
 	me->width         = width;
 	me->height        = height;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index 5232327f5d9c..ca90b22020cc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -727,10 +727,8 @@ static int alloc_private_pages(struct hmm_buffer_object *bo,
 
 	bo->page_obj = kmalloc_array(pgnr, sizeof(struct hmm_page_object),
 				GFP_KERNEL);
-	if (unlikely(!bo->page_obj)) {
-		dev_err(atomisp_dev, "out of memory for bo->page_obj\n");
+	if (unlikely(!bo->page_obj))
 		return -ENOMEM;
-	}
 
 	i = 0;
 	alloc_pgnr = 0;
@@ -991,15 +989,12 @@ static int alloc_user_pages(struct hmm_buffer_object *bo,
 	struct page **pages;
 
 	pages = kmalloc_array(bo->pgnr, sizeof(struct page *), GFP_KERNEL);
-	if (unlikely(!pages)) {
-		dev_err(atomisp_dev, "out of memory for pages...\n");
+	if (unlikely(!pages))
 		return -ENOMEM;
-	}
 
 	bo->page_obj = kmalloc_array(bo->pgnr, sizeof(struct hmm_page_object),
 		GFP_KERNEL);
 	if (unlikely(!bo->page_obj)) {
-		dev_err(atomisp_dev, "out of memory for bo->page_obj...\n");
 		kfree(pages);
 		return -ENOMEM;
 	}
@@ -1366,7 +1361,6 @@ void *hmm_bo_vmap(struct hmm_buffer_object *bo, bool cached)
 	pages = kmalloc_array(bo->pgnr, sizeof(*pages), GFP_KERNEL);
 	if (unlikely(!pages)) {
 		mutex_unlock(&bo->mutex);
-		dev_err(atomisp_dev, "out of memory for pages...\n");
 		return NULL;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
index 19e0e9ee37de..eb82c3e4c776 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
@@ -116,8 +116,6 @@ static void free_pages_to_dynamic_pool(void *pool,
 	hmm_page = kmem_cache_zalloc(dypool_info->pgptr_cache,
 						GFP_KERNEL);
 	if (!hmm_page) {
-		dev_err(atomisp_dev, "out of memory for hmm_page.\n");
-
 		/* free page directly */
 		ret = set_pages_wb(page_obj->page, 1);
 		if (ret)
@@ -151,10 +149,8 @@ static int hmm_dynamic_pool_init(void **pool, unsigned int pool_size)
 
 	dypool_info = kmalloc(sizeof(struct hmm_dynamic_pool_info),
 		GFP_KERNEL);
-	if (unlikely(!dypool_info)) {
-		dev_err(atomisp_dev, "out of memory for repool_info.\n");
+	if (unlikely(!dypool_info))
 		return -ENOMEM;
-	}
 
 	dypool_info->pgptr_cache = kmem_cache_create("pgptr_cache",
 						sizeof(struct hmm_page), 0,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
index bf6586805f7f..177bc354f1d7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
@@ -92,15 +92,12 @@ static int hmm_reserved_pool_setup(struct hmm_reserved_pool_info **repool_info,
 
 	pool_info = kmalloc(sizeof(struct hmm_reserved_pool_info),
 				GFP_KERNEL);
-	if (unlikely(!pool_info)) {
-		dev_err(atomisp_dev, "out of memory for repool_info.\n");
+	if (unlikely(!pool_info))
 		return -ENOMEM;
-	}
 
 	pool_info->pages = kmalloc(sizeof(struct page *) * pool_size,
 			GFP_KERNEL);
 	if (unlikely(!pool_info->pages)) {
-		dev_err(atomisp_dev, "out of memory for repool_info->pages.\n");
 		kfree(pool_info);
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c
index 0722a68a49e7..402ffd9cb480 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c
@@ -89,10 +89,8 @@ static struct hmm_vm_node *alloc_hmm_vm_node(unsigned int pgnr,
 	struct hmm_vm_node *node;
 
 	node = kmem_cache_alloc(vm->cache, GFP_KERNEL);
-	if (!node) {
-		dev_err(atomisp_dev, "out of memory.\n");
+	if (!node)
 		return NULL;
-	}
 
 	INIT_LIST_HEAD(&node->list);
 	node->pgnr = pgnr;
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index edaae93af8f9..0304801fcbe5 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -739,10 +739,8 @@ int camera_sensor_csi(struct v4l2_subdev *sd, u32 port,
 
 	if (flag) {
 		csi = kzalloc(sizeof(*csi), GFP_KERNEL);
-		if (!csi) {
-			dev_err(&client->dev, "out of memory\n");
+		if (!csi)
 			return -ENOMEM;
-		}
 		csi->port = port;
 		csi->num_lanes = lanes;
 		csi->input_format = format;
-- 
2.11.0
