Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback.mail.elte.hu ([157.181.151.13]:38167 "EHLO
        fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933017AbdEVVGE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 17:06:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138])
        by fallback.mail.elte.hu with esmtp (Exim)
        id 1dCuWe-00010w-5H
        from <melko@frugalware.org>
        for <linux-media@vger.kernel.org>; Mon, 22 May 2017 23:06:00 +0200
From: Paolo Cretaro <melko@frugalware.org>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Paolo Cretaro <melko@frugalware.org>
Subject: [PATCH] [media] atomisp: use NULL instead of 0 for pointers
Date: Mon, 22 May 2017 23:04:46 +0200
Message-Id: <20170522210446.20029-1-melko@frugalware.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix warning issued by sparse: Using plain integer as NULL pointer

Signed-off-by: Paolo Cretaro <melko@frugalware.org>
---
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c                     | 2 +-
 .../media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c        | 2 +-
 .../media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c    | 2 +-
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c                  | 2 +-
 drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c  | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 5e9dafe7cc32..d6447398f5ef 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -706,7 +706,7 @@ static int ov5693_read_otp_reg_array(struct i2c_client *client, u16 size,
 {
 	u16 index;
 	int ret;
-	u16 *pVal = 0;
+	u16 *pVal = NULL;
 
 	for (index = 0; index <= size; index++) {
 		pVal = (u16 *) (buf + index);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
index ed33d4c4c84a..5d40afd482f5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c
@@ -239,7 +239,7 @@ static ia_css_queue_t *bufq_get_qhandle(
 	enum sh_css_queue_id id,
 	int thread)
 {
-	ia_css_queue_t *q = 0;
+	ia_css_queue_t *q = NULL;
 
 	switch (type) {
 	case sh_css_host2sp_buffer_queue:
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
index b36d7b00ebe8..18966d89602a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
@@ -57,7 +57,7 @@ enum ia_css_err ia_css_spctrl_load_fw(sp_ID_t sp_id,
 	hrt_vaddress code_addr = mmgr_NULL;
 	struct ia_css_sp_init_dmem_cfg *init_dmem_cfg;
 
-	if ((sp_id >= N_SP_ID) || (spctrl_cfg == 0))
+	if ((sp_id >= N_SP_ID) || (spctrl_cfg == NULL))
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 
 	spctrl_cofig_info[sp_id].code_addr = mmgr_NULL;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index 57295397da3e..5e63073f3581 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -193,7 +193,7 @@ int hmm_init(void)
 	 * at the beginning, to avoid hmm_alloc return 0 in the
 	 * further allocation.
 	 */
-	dummy_ptr = hmm_alloc(1, HMM_BO_PRIVATE, 0, 0, HMM_UNCACHED);
+	dummy_ptr = hmm_alloc(1, HMM_BO_PRIVATE, 0, NULL, HMM_UNCACHED);
 
 	if (!ret) {
 		ret = sysfs_create_group(&atomisp_dev->kobj,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
index 7dff22f59e29..2e78976bb2ac 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
@@ -55,7 +55,7 @@ static ia_css_ptr __hrt_isp_css_mm_alloc(size_t bytes, void *userptr,
 	if (type == HRT_USR_PTR) {
 		if (userptr == NULL)
 			return hmm_alloc(bytes, HMM_BO_PRIVATE, 0,
-						 0, cached);
+						 NULL, cached);
 		else {
 			if (num_pages < ((__page_align(bytes)) >> PAGE_SHIFT))
 				dev_err(atomisp_dev,
@@ -94,7 +94,7 @@ ia_css_ptr hrt_isp_css_mm_alloc_user_ptr(size_t bytes, void *userptr,
 ia_css_ptr hrt_isp_css_mm_alloc_cached(size_t bytes)
 {
 	if (my_userptr == NULL)
-		return hmm_alloc(bytes, HMM_BO_PRIVATE, 0, 0,
+		return hmm_alloc(bytes, HMM_BO_PRIVATE, 0, NULL,
 						HMM_CACHED);
 	else {
 		if (my_num_pages < ((__page_align(bytes)) >> PAGE_SHIFT))
-- 
2.13.0
