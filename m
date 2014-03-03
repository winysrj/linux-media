Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaCCKIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:06 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 65/79] [media] drx-j: Get rid of I2C protocol version
Date: Mon,  3 Mar 2014 07:06:59 -0300
Message-Id: <1393841233-24840-66-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is not used anywere. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c | 15 ---------------
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h   |  1 -
 drivers/media/dvb-frontends/drx39xyj/drxj.c         | 15 ---------------
 3 files changed, 31 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index b78d45b68668..b81b4f9cd4b0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -108,23 +108,8 @@ static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
 						    u32 datain,	/* data to send                 */
 						    u32 *dataout);	/* data to receive back         */
 
-/* The version structure of this protocol implementation */
-char drx_dap_fasi_module_name[] = "FASI Data Access Protocol";
-char drx_dap_fasi_version_text[] = "";
-
-struct drx_version drx_dap_fasi_version = {
-	DRX_MODULE_DAP,	      /**< type identifier of the module */
-	drx_dap_fasi_module_name, /**< name or description of module */
-
-	0,		      /**< major version number */
-	0,		      /**< minor version number */
-	0,		      /**< patch version number */
-	drx_dap_fasi_version_text /**< version as text string */
-};
-
 /* The structure containing the protocol interface */
 struct drx_access_func drx_dap_fasi_funct_g = {
-	&drx_dap_fasi_version,
 	drxdap_fasi_write_block,	/* Supported */
 	drxdap_fasi_read_block,	/* Supported */
 	drxdap_fasi_write_reg8,	/* Not supported */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index aabd5c56d55b..f3098b6bd006 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -1825,7 +1825,6 @@ struct drx_aud_data {
 * \struct struct drx_access_func * \brief Interface to an access protocol.
 */
 struct drx_access_func {
-	struct drx_version *protocolVersion;
 	drx_write_block_func_t write_block_func;
 	drx_read_block_func_t read_block_func;
 	drx_write_reg8func_t write_reg8func;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 8f2f2653af2c..1e202dafe335 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -584,23 +584,8 @@ static int drxj_dap_write_reg32(struct i2c_device_addr *dev_addr,
 				       u32 addr,
 				       u32 data, u32 flags);
 
-/* The version structure of this protocol implementation */
-char drx_dap_drxj_module_name[] = "DRXJ Data Access Protocol";
-char drx_dap_drxj_version_text[] = "0.0.0";
-
-struct drx_version drx_dap_drxj_version = {
-	DRX_MODULE_DAP,	      /**< type identifier of the module  */
-	drx_dap_drxj_module_name, /**< name or description of module  */
-
-	0,		      /**< major version number           */
-	0,		      /**< minor version number           */
-	0,		      /**< patch version number           */
-	drx_dap_drxj_version_text /**< version as text string         */
-};
-
 /* The structure containing the protocol interface */
 struct drx_access_func drx_dap_drxj_funct_g = {
-	&drx_dap_drxj_version,
 	drxj_dap_write_block,	/* Supported       */
 	drxj_dap_read_block,	/* Supported       */
 	drxj_dap_write_reg8,	/* Not supported   */
-- 
1.8.5.3

