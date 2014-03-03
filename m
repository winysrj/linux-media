Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaCCKIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:14 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 55/79] [media] drx-j: get rid of drxj_ctrl()
Date: Mon,  3 Mar 2014 07:06:49 -0300
Message-Id: <1393841233-24840-56-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With this change, we finally got rid of all abstraction
layers on this driver.

This patch also fixes the LNA GPIO settings, as the original
code were using a wrong control name for it.

This patch exposes the several functions that aren't used.
Some of them are related to analog demod that might be
used some day, but others will likely never be needed, as
they don't fit on Linux media APIs.

Latter patches will clean up this mess.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |  55 ------
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 205 ++--------------------
 2 files changed, 12 insertions(+), 248 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index b9ba48f88523..daa9027983e8 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -782,61 +782,6 @@ enum drx_pilot_mode {
 	DRX_PILOT_AUTO = DRX_AUTO /**< Autodetect Pilot     */
 };
 
-#define DRX_CTRL_BASE          ((u32)0)
-
-#define DRX_CTRL_NOP             (DRX_CTRL_BASE +  0)/**< No Operation       */
-#define DRX_CTRL_PROBE_DEVICE    (DRX_CTRL_BASE +  1)/**< Probe device       */
-
-#define DRX_CTRL_LOAD_UCODE      (DRX_CTRL_BASE +  2)/**< Load microcode     */
-#define DRX_CTRL_VERIFY_UCODE    (DRX_CTRL_BASE +  3)/**< Verify microcode   */
-#define DRX_CTRL_SET_CHANNEL     (DRX_CTRL_BASE +  4)/**< Set channel        */
-#define DRX_CTRL_GET_CHANNEL     (DRX_CTRL_BASE +  5)/**< Get channel        */
-#define DRX_CTRL_LOCK_STATUS     (DRX_CTRL_BASE +  6)/**< Get lock status    */
-#define DRX_CTRL_SIG_QUALITY     (DRX_CTRL_BASE +  7)/**< Get signal quality */
-#define DRX_CTRL_SIG_STRENGTH    (DRX_CTRL_BASE +  8)/**< Get signal strength*/
-#define DRX_CTRL_RF_POWER        (DRX_CTRL_BASE +  9)/**< Get RF power       */
-#define DRX_CTRL_CONSTEL         (DRX_CTRL_BASE + 10)/**< Get constel point  */
-#define DRX_CTRL_SCAN_INIT       (DRX_CTRL_BASE + 11)/**< Initialize scan    */
-#define DRX_CTRL_SCAN_NEXT       (DRX_CTRL_BASE + 12)/**< Scan for next      */
-#define DRX_CTRL_SCAN_STOP       (DRX_CTRL_BASE + 13)/**< Stop scan          */
-#define DRX_CTRL_TPS_INFO        (DRX_CTRL_BASE + 14)/**< Get TPS info       */
-#define DRX_CTRL_SET_CFG         (DRX_CTRL_BASE + 15)/**< Set configuration  */
-#define DRX_CTRL_GET_CFG         (DRX_CTRL_BASE + 16)/**< Get configuration  */
-#define DRX_CTRL_VERSION         (DRX_CTRL_BASE + 17)/**< Get version info   */
-#define DRX_CTRL_I2C_BRIDGE      (DRX_CTRL_BASE + 18)/**< Open/close  bridge */
-#define DRX_CTRL_SET_STANDARD    (DRX_CTRL_BASE + 19)/**< Set demod std      */
-#define DRX_CTRL_GET_STANDARD    (DRX_CTRL_BASE + 20)/**< Get demod std      */
-#define DRX_CTRL_SET_OOB         (DRX_CTRL_BASE + 21)/**< Set OOB param      */
-#define DRX_CTRL_GET_OOB         (DRX_CTRL_BASE + 22)/**< Get OOB param      */
-#define DRX_CTRL_AUD_SET_STANDARD (DRX_CTRL_BASE + 23)/**< Set audio param    */
-#define DRX_CTRL_AUD_GET_STANDARD (DRX_CTRL_BASE + 24)/**< Get audio param    */
-#define DRX_CTRL_AUD_GET_STATUS  (DRX_CTRL_BASE + 25)/**< Read RDS           */
-#define DRX_CTRL_AUD_BEEP        (DRX_CTRL_BASE + 26)/**< Read RDS           */
-#define DRX_CTRL_I2C_READWRITE   (DRX_CTRL_BASE + 27)/**< Read/write I2C     */
-#define DRX_CTRL_PROGRAM_TUNER   (DRX_CTRL_BASE + 28)/**< Program tuner      */
-
-	/* Professional */
-#define DRX_CTRL_MB_CFG          (DRX_CTRL_BASE + 29) /**<                   */
-#define DRX_CTRL_MB_READ         (DRX_CTRL_BASE + 30) /**<                   */
-#define DRX_CTRL_MB_WRITE        (DRX_CTRL_BASE + 31) /**<                   */
-#define DRX_CTRL_MB_CONSTEL      (DRX_CTRL_BASE + 32) /**<                   */
-#define DRX_CTRL_MB_MER          (DRX_CTRL_BASE + 33) /**<                   */
-
-	/* Misc */
-#define DRX_CTRL_UIO_CFG         DRX_CTRL_SET_UIO_CFG  /**< Configure UIO     */
-#define DRX_CTRL_SET_UIO_CFG     (DRX_CTRL_BASE + 34) /**< Configure UIO     */
-#define DRX_CTRL_GET_UIO_CFG     (DRX_CTRL_BASE + 35) /**< Configure UIO     */
-#define DRX_CTRL_UIO_READ        (DRX_CTRL_BASE + 36) /**< Read from UIO     */
-#define DRX_CTRL_UIO_WRITE       (DRX_CTRL_BASE + 37) /**< Write to UIO      */
-#define DRX_CTRL_READ_EVENTS     (DRX_CTRL_BASE + 38) /**< Read events       */
-#define DRX_CTRL_HDL_EVENTS      (DRX_CTRL_BASE + 39) /**< Handle events     */
-#define DRX_CTRL_POWER_MODE      (DRX_CTRL_BASE + 40) /**< Set power mode    */
-#define DRX_CTRL_LOAD_FILTER     (DRX_CTRL_BASE + 41) /**< Load chan. filter */
-#define DRX_CTRL_VALIDATE_UCODE  (DRX_CTRL_BASE + 42) /**< Validate ucode    */
-#define DRX_CTRL_DUMP_REGISTERS  (DRX_CTRL_BASE + 43) /**< Dump registers    */
-
-#define DRX_CTRL_MAX             (DRX_CTRL_BASE + 44)	/* never to be used    */
-
 /**
  * enum drxu_code_action - indicate if firmware has to be uploaded or verified.
  * @UCODE_UPLOAD:	Upload the microcode image to device
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 635698990e28..66a83b83f70e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -20127,187 +20127,6 @@ rw_error:
 	return -EIO;
 }
 
-/*============================================================================*/
-/**
-* \fn drxj_ctrl()
-* \brief DRXJ specific control function
-* \return Status_t Return status.
-*/
-int
-drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
-{
-	switch (ctrl) {
-      /*======================================================================*/
-	case DRX_CTRL_SET_CHANNEL:
-		{
-			return ctrl_set_channel(demod, (struct drx_channel *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_GET_CHANNEL:
-		{
-			return ctrl_get_channel(demod, (struct drx_channel *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_SIG_QUALITY:
-		{
-			return ctrl_sig_quality(demod,
-					      (struct drx_sig_quality *) ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_SIG_STRENGTH:
-		{
-			return ctrl_sig_strength(demod, (u16 *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_CONSTEL:
-		{
-			return ctrl_constel(demod, (struct drx_complex *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_SET_CFG:
-		{
-			return ctrl_set_cfg(demod, (struct drx_cfg *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_GET_CFG:
-		{
-			return ctrl_get_cfg(demod, (struct drx_cfg *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_I2C_BRIDGE:
-		{
-			return ctrl_i2c_bridge(demod, (bool *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_LOCK_STATUS:
-		{
-			return ctrl_lock_status(demod,
-					      (enum drx_lock_status *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_SET_STANDARD:
-		{
-			return ctrl_set_standard(demod,
-					       (enum drx_standard *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_GET_STANDARD:
-		{
-			return ctrl_get_standard(demod,
-					       (enum drx_standard *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_POWER_MODE:
-		{
-			return ctrl_power_mode(demod, (enum drx_power_mode *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_VERSION:
-		{
-			return ctrl_version(demod,
-					   (struct drx_version_list **)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_PROBE_DEVICE:
-		{
-			return ctrl_probe_device(demod);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_SET_OOB:
-		{
-			return ctrl_set_oob(demod, (struct drxoob *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_GET_OOB:
-		{
-			return ctrl_get_oob(demod, (struct drxoob_status *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_SET_UIO_CFG:
-		{
-			return ctrl_set_uio_cfg(demod, (struct drxuio_cfg *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_GET_UIO_CFG:
-		{
-			return ctrl_getuio_cfg(demod, (struct drxuio_cfg *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_UIO_READ:
-		{
-			return ctrl_uio_read(demod, (struct drxuio_data *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_UIO_WRITE:
-		{
-			return ctrl_uio_write(demod, (struct drxuio_data *)ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_AUD_SET_STANDARD:
-		{
-			return aud_ctrl_set_standard(demod,
-						  (enum drx_aud_standard *) ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_AUD_GET_STANDARD:
-		{
-			return aud_ctrl_get_standard(demod,
-						  (enum drx_aud_standard *) ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_AUD_GET_STATUS:
-		{
-			return aud_ctrl_get_status(demod,
-						(struct drx_aud_status *) ctrl_data);
-		}
-		break;
-      /*======================================================================*/
-	case DRX_CTRL_AUD_BEEP:
-		{
-			return aud_ctrl_beep(demod, (struct drx_aud_beep *)ctrl_data);
-		}
-		break;
-
-      /*======================================================================*/
-	case DRX_CTRL_I2C_READWRITE:
-		{
-			return ctrl_i2c_write_read(demod,
-						(struct drxi2c_data *) ctrl_data);
-		}
-		break;
-	case DRX_CTRL_VALIDATE_UCODE:
-		{
-			return ctrl_validate_u_code(demod);
-		}
-		break;
-	default:
-		return -ENOTSUPP;
-	}
-	return 0;
-}
-
 /*
  * Microcode related functions
  */
@@ -20635,7 +20454,7 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 	else
 		power_mode = DRX_POWER_DOWN;
 
-	result = drxj_ctrl(demod, DRX_CTRL_POWER_MODE, &power_mode);
+	result = ctrl_power_mode(demod, &power_mode);
 	if (result != 0) {
 		pr_err("Power state change failed\n");
 		return 0;
@@ -20654,7 +20473,7 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	*status = 0;
 
-	result = drxj_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_status);
+	result = ctrl_lock_status(demod, &lock_status);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get lock status!\n");
 		*status = 0;
@@ -20699,7 +20518,7 @@ static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = ctrl_sig_quality(demod, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get ber!\n");
 		*ber = 0;
@@ -20718,7 +20537,7 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = ctrl_sig_quality(demod, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get signal strength!\n");
 		*strength = 0;
@@ -20737,7 +20556,7 @@ static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = ctrl_sig_quality(demod, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not read snr!\n");
 		*snr = 0;
@@ -20755,7 +20574,7 @@ static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = ctrl_sig_quality(demod, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get uc blocks!\n");
 		*ucblocks = 0;
@@ -20834,7 +20653,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 
 	if (standard != state->current_standard || state->powered_up == 0) {
 		/* Set the standard (will be powered up if necessary */
-		result = drxj_ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
+		result = ctrl_set_standard(demod, &standard);
 		if (result != 0) {
 			pr_err("Failed to set standard! result=%02x\n",
 			       result);
@@ -20851,7 +20670,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	channel.constellation = constellation;
 
 	/* program channel */
-	result = drxj_ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
+	result = ctrl_set_channel(demod, &channel);
 	if (result != 0) {
 		pr_err("Failed to set channel!\n");
 		return -EINVAL;
@@ -20859,7 +20678,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	/* Just for giggles, let's shut off the LNA again.... */
 	uio_data.uio = DRX_UIO1;
 	uio_data.value = false;
-	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
+	result = ctrl_uio_write(demod, &uio_data);
 	if (result != 0) {
 		pr_err("Failed to disable LNA!\n");
 		return 0;
@@ -20905,7 +20724,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 		return 0;
 	}
 
-	result = drxj_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &i2c_gate_state);
+	result = ctrl_i2c_bridge(demod, &i2c_gate_state);
 	if (result != 0) {
 		pr_err("drx39xxj: could not open i2c gate [%d]\n",
 		       result);
@@ -21013,7 +20832,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	uio_cfg.uio = DRX_UIO1;
 	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
 	/* Configure user-I/O #3: enable read/write */
-	result = drxj_ctrl(demod, DRX_CTRL_UIO_CFG, &uio_cfg);
+	result = ctrl_set_uio_cfg(demod, &uio_cfg);
 	if (result) {
 		pr_err("Failed to setup LNA GPIO!\n");
 		goto error;
@@ -21021,7 +20840,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	uio_data.uio = DRX_UIO1;
 	uio_data.value = false;
-	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
+	result = ctrl_uio_write(demod, &uio_data);
 	if (result != 0) {
 		pr_err("Failed to disable LNA!\n");
 		goto error;
-- 
1.8.5.3

