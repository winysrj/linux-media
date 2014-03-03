Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaCCKIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:02 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 37/79] [media] drx-j: remove the useless microcode_size
Date: Mon,  3 Mar 2014 07:06:31 -0300
Message-Id: <1393841233-24840-38-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This var is not used. Remove it from the code, as we'll now be
converting the driver to load the firmware from an external
file.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |  4 ----
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 10 +++-------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index c36321b9dd72..f5add1a72dd6 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -1021,8 +1021,6 @@ STRUCTS
 struct drxu_code_info {
 	u8 *mc_data;
 	     /**< Pointer to microcode image. */
-	u16 mc_size;
-	     /**< Microcode image size.       */
 };
 
 /**
@@ -1932,7 +1930,6 @@ struct drx_reg_dump {
 	struct drx_common_attr {
 		/* Microcode (firmware) attributes */
 		u8 *microcode;   /**< Pointer to microcode image.           */
-		u16 microcode_size;
 				   /**< Size of microcode image in bytes.     */
 		bool verify_microcode;
 				   /**< Use microcode verify or not.          */
@@ -2351,7 +2348,6 @@ Access macros
 #define DRX_ATTR_CACHESTANDARD(d)   ((d)->my_common_attr->di_cache_standard)
 #define DRX_ATTR_CURRENTCHANNEL(d)  ((d)->my_common_attr->current_channel)
 #define DRX_ATTR_MICROCODE(d)       ((d)->my_common_attr->microcode)
-#define DRX_ATTR_MICROCODESIZE(d)   ((d)->my_common_attr->microcode_size)
 #define DRX_ATTR_VERIFYMICROCODE(d) ((d)->my_common_attr->verify_microcode)
 #define DRX_ATTR_CAPABILITIES(d)    ((d)->my_common_attr->capabilities)
 #define DRX_ATTR_PRODUCTID(d)       ((d)->my_common_attr->product_id)
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c04745202c49..e21dd5a7dd2b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -876,7 +876,6 @@ struct i2c_device_addr drxj_default_addr_g = {
 */
 struct drx_common_attr drxj_default_comm_attr_g = {
 	(u8 *)NULL,		/* ucode ptr            */
-	0,			/* ucode size           */
 	true,			/* ucode verify switch  */
 	{0},			/* version record       */
 
@@ -12171,7 +12170,6 @@ trouble ?
 	/* Check if audio microcode is already uploaded */
 	if (!(ext_attr->flag_aud_mc_uploaded)) {
 		ucode_info.mc_data = common_attr->microcode;
-		ucode_info.mc_size = common_attr->microcode_size;
 
 		/* Upload only audio microcode */
 		rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_UPLOAD, true);
@@ -18831,8 +18829,8 @@ bool is_mc_block_audio(u32 addr)
 */
 static int
 ctrl_u_code_upload(struct drx_demod_instance *demod,
-		  struct drxu_code_info *mc_info,
-		enum drxu_code_actionaction, bool upload_audio_mc)
+		   struct drxu_code_info *mc_info,
+		   enum drxu_code_actionaction, bool upload_audio_mc)
 {
 	u16 i = 0;
 	u16 mc_nr_of_blks = 0;
@@ -18846,8 +18844,7 @@ ctrl_u_code_upload(struct drx_demod_instance *demod,
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* Check arguments */
-	if ((mc_info == NULL) ||
-	    (mc_info->mc_data == NULL) || (mc_info->mc_size == 0)) {
+	if (!mc_info || !mc_info->mc_data) {
 		return -EINVAL;
 	}
 
@@ -20147,7 +20144,6 @@ int drxj_open(struct drx_demod_instance *demod)
 		   pretend device is already open */
 		common_attr->is_opened = true;
 		ucode_info.mc_data = common_attr->microcode;
-		ucode_info.mc_size = common_attr->microcode_size;
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 		/* Upload microcode without audio part */
-- 
1.8.5.3

