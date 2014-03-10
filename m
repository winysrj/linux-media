Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaCJL74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:56 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/15] drx-j: remove external symbols
Date: Mon, 10 Mar 2014 08:58:58 -0300
Message-Id: <1394452747-5426-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver doesn't export any external symbol, except for
the attach() method.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 12 ++++++------
 drivers/media/dvb-frontends/drx39xyj/drxj.h | 30 -----------------------------
 2 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index e8c890800904..828d0527f38d 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -561,7 +561,7 @@ static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,
 				       u32 addr,
 				       u32 data, u32 flags);
 
-struct drxj_data drxj_data_g = {
+static struct drxj_data drxj_data_g = {
 	false,			/* has_lna : true if LNA (aka PGA) present      */
 	false,			/* has_oob : true if OOB supported              */
 	false,			/* has_ntsc: true if NTSC supported             */
@@ -810,7 +810,7 @@ struct drxj_data drxj_data_g = {
 * \var drxj_default_addr_g
 * \brief Default I2C address and device identifier.
 */
-struct i2c_device_addr drxj_default_addr_g = {
+static struct i2c_device_addr drxj_default_addr_g = {
 	DRXJ_DEF_I2C_ADDR,	/* i2c address */
 	DRXJ_DEF_DEMOD_DEV_ID	/* device id */
 };
@@ -819,7 +819,7 @@ struct i2c_device_addr drxj_default_addr_g = {
 * \var drxj_default_comm_attr_g
 * \brief Default common attributes of a drxj demodulator instance.
 */
-struct drx_common_attr drxj_default_comm_attr_g = {
+static struct drx_common_attr drxj_default_comm_attr_g = {
 	NULL,			/* ucode file           */
 	true,			/* ucode verify switch  */
 	{0},			/* version record       */
@@ -890,7 +890,7 @@ struct drx_common_attr drxj_default_comm_attr_g = {
 * \var drxj_default_demod_g
 * \brief Default drxj demodulator instance.
 */
-struct drx_demod_instance drxj_default_demod_g = {
+static struct drx_demod_instance drxj_default_demod_g = {
 	&drxj_default_addr_g,	/* i2c address & device id */
 	&drxj_default_comm_attr_g,	/* demod common attributes */
 	&drxj_data_g		/* demod device specific attributes */
@@ -11291,7 +11291,7 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 *
 */
 
-int drxj_open(struct drx_demod_instance *demod)
+static int drxj_open(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	struct drxj_data *ext_attr = NULL;
@@ -11504,7 +11504,7 @@ rw_error:
 * \return Status_t Return status.
 *
 */
-int drxj_close(struct drx_demod_instance *demod)
+static int drxj_close(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	int rc;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index 6d46513b7169..55ad535197d2 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -647,34 +647,4 @@ DEFINES
 	(x == DRX_LOCK_STATE_2) ? "sync lock" : \
 	"(Invalid)")
 
-/*-------------------------------------------------------------------------
-ENUM
--------------------------------------------------------------------------*/
-
-/*-------------------------------------------------------------------------
-STRUCTS
--------------------------------------------------------------------------*/
-
-/*-------------------------------------------------------------------------
-Exported FUNCTIONS
--------------------------------------------------------------------------*/
-
-	int drxj_open(struct drx_demod_instance *demod);
-	int drxj_close(struct drx_demod_instance *demod);
-	int drxj_ctrl(struct drx_demod_instance *demod,
-				     u32 ctrl, void *ctrl_data);
-
-/*-------------------------------------------------------------------------
-Exported GLOBAL VARIABLES
--------------------------------------------------------------------------*/
-	extern struct drx_access_func drx_dap_drxj_funct_g;
-	extern struct drx_demod_func drxj_functions_g;
-	extern struct drxj_data drxj_data_g;
-	extern struct i2c_device_addr drxj_default_addr_g;
-	extern struct drx_common_attr drxj_default_comm_attr_g;
-	extern struct drx_demod_instance drxj_default_demod_g;
-
-/*-------------------------------------------------------------------------
-THE END
--------------------------------------------------------------------------*/
 #endif				/* __DRXJ_H__ */
-- 
1.8.5.3

