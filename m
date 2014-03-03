Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbaCCKID (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:03 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 11/79] [media] drx-j: get rid of most of the typedefs
Date: Mon,  3 Mar 2014 07:06:05 -0300
Message-Id: <1393841233-24840-12-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

There are lots of typedefs there. Let's get rid of them.

Most of the work here is due to this small script:

	if [ "$3" == "" ]; then
		echo "usage: $0 type DRXName drx_name"
	fi
	t=$1; f=$2; g=$3
	for i in *.[ch]; do
		sed s,"p${f}_t","$t $g *",g <$i >a && mv a $i && \
		sed s,"${f}_t","$t $g",g <$i >a && mv a $i
	done

Just kept there the function typedefs, as those are still useful.

Yet, all those tuner_ops can likely be just removed on a latter
cleanup patch.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    |  20 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |   2 +-
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |  18 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  70 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  96 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  | 664 +++++++-------
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 974 ++++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |  22 +-
 8 files changed, 918 insertions(+), 948 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index d68b34b1cc7a..414d152524e4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -34,7 +34,7 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	DRXStatus_t result;
+	int result;
 	DRXPowerMode_t powerMode;
 
 	if (enable)
@@ -56,7 +56,7 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	DRXStatus_t result;
+	int result;
 	DRXLockStatus_t lock_status;
 
 	*status = 0;
@@ -103,7 +103,7 @@ static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	DRXStatus_t result;
+	int result;
 	DRXSigQuality_t sig_quality;
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
@@ -122,7 +122,7 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	DRXStatus_t result;
+	int result;
 	DRXSigQuality_t sig_quality;
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
@@ -141,7 +141,7 @@ static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	DRXStatus_t result;
+	int result;
 	DRXSigQuality_t sig_quality;
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
@@ -159,7 +159,7 @@ static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	DRXStatus_t result;
+	int result;
 	DRXSigQuality_t sig_quality;
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
@@ -181,9 +181,9 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	DRXStandard_t standard = DRX_STANDARD_8VSB;
+	enum drx_standard standard = DRX_STANDARD_8VSB;
 	DRXChannel_t channel;
-	DRXStatus_t result;
+	int result;
 	DRXUIOData_t uioData;
 	DRXChannel_t defChannel = { /* frequency      */ 0,
 		/* bandwidth      */ DRX_BANDWIDTH_6MHZ,
@@ -270,7 +270,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
 	bool i2c_gate_state;
-	DRXStatus_t result;
+	int result;
 
 #ifdef DJH_DEBUG
 	printk(KERN_DBG "i2c gate call: enable=%d state=%d\n", enable,
@@ -331,7 +331,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	DRXDemodInstance_t *demod = NULL;
 	DRXUIOCfg_t uioCfg;
 	DRXUIOData_t uioData;
-	DRXStatus_t result;
+	int result;
 
 	/* allocate memory for the internal state */
 	state = kmalloc(sizeof(struct drx39xxj_state), GFP_KERNEL);
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index 467b390372d8..1f0b30bbd0c3 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -29,7 +29,7 @@
 struct drx39xxj_state {
 	struct i2c_adapter *i2c;
 	DRXDemodInstance_t *demod;
-	DRXStandard_t current_standard;
+	enum drx_standard current_standard;
 	struct dvb_frontend frontend;
 	int powered_up:1;
 	unsigned int i2c_gate_open:1;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 5471263b490b..ff6e33411bcd 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -11,33 +11,33 @@
 #include "drx39xxj.h"
 
 /* Dummy function to satisfy drxj.c */
-DRXStatus_t DRXBSP_TUNER_Open(pTUNERInstance_t tuner)
+int DRXBSP_TUNER_Open(struct tuner_instance *tuner)
 {
 	return DRX_STS_OK;
 }
 
-DRXStatus_t DRXBSP_TUNER_Close(pTUNERInstance_t tuner)
+int DRXBSP_TUNER_Close(struct tuner_instance *tuner)
 {
 	return DRX_STS_OK;
 }
 
-DRXStatus_t DRXBSP_TUNER_SetFrequency(pTUNERInstance_t tuner,
-				      TUNERMode_t mode,
+int DRXBSP_TUNER_SetFrequency(struct tuner_instance *tuner,
+				      u32 mode,
 				      s32 centerFrequency)
 {
 	return DRX_STS_OK;
 }
 
-DRXStatus_t
-DRXBSP_TUNER_GetFrequency(pTUNERInstance_t tuner,
-			  TUNERMode_t mode,
+int
+DRXBSP_TUNER_GetFrequency(struct tuner_instance *tuner,
+			  u32 mode,
 			  s32 *RFfrequency,
 			  s32 *IFfrequency)
 {
 	return DRX_STS_OK;
 }
 
-DRXStatus_t DRXBSP_HST_Sleep(u32 n)
+int DRXBSP_HST_Sleep(u32 n)
 {
 	msleep(n);
 	return DRX_STS_OK;
@@ -58,7 +58,7 @@ void *DRXBSP_HST_Memcpy(void *to, void *from, u32 n)
 	return (memcpy(to, from, (size_t) n));
 }
 
-DRXStatus_t DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
+int DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
 				 u16 wCount,
 				 u8 *wData,
 				 struct i2c_device_addr *rDevAddr,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 9bea12ee4ed5..479db94b1782 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -55,61 +55,61 @@
 /*============================================================================*/
 
 /* Function prototypes */
-static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register/memory   */
 					  u16 datasize,	/* size of data                 */
 					  u8 *data,	/* data to send                 */
 					  DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register/memory   */
 					 u16 datasize,	/* size of data                 */
 					 u8 *data,	/* data to send                 */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 u8 data,	/* data to write                */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					DRXaddr_t addr,	/* address of register          */
 					u8 *data,	/* buffer to receive data       */
 					DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t waddr,	/* address of register          */
 						   DRXaddr_t raddr,	/* address to read back from    */
 						   u8 datain,	/* data to send                 */
 						   u8 *dataout);	/* data to receive back         */
 
-static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register          */
 					  u16 data,	/* data to write                */
 					  DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 u16 *data,	/* buffer to receive data       */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
 						    u16 datain,	/* data to send                 */
 						    u16 *dataout);	/* data to receive back         */
 
-static DRXStatus_t DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register          */
 					  u32 data,	/* data to write                */
 					  DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 u32 *data,	/* buffer to receive data       */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
 						    u32 datain,	/* data to send                 */
@@ -149,7 +149,7 @@ DRXAccessFunc_t drxDapFASIFunct_g = {
 
 /* Functions not supported by protocol*/
 
-static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 u8 data,	/* data to write                */
 					 DRXflags_t flags)
@@ -157,7 +157,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* add
 	return DRX_STS_ERROR;
 }
 
-static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					DRXaddr_t addr,	/* address of register          */
 					u8 *data,	/* buffer to receive data       */
 					DRXflags_t flags)
@@ -165,7 +165,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* addr
 	return DRX_STS_ERROR;
 }
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t waddr,	/* address of register          */
 						   DRXaddr_t raddr,	/* address to read back from    */
 						   u8 datain,	/* data to send                 */
@@ -174,7 +174,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAd
 	return DRX_STS_ERROR;
 }
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
+static int DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
 						    u32 datain,	/* data to send                 */
@@ -187,7 +187,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devA
 
 /******************************
 *
-* DRXStatus_t DRXDAP_FASI_ReadBlock (
+* int DRXDAP_FASI_ReadBlock (
 *      struct i2c_device_addr *devAddr,      -- address of I2C device
 *      DRXaddr_t        addr,         -- address of chip register/memory
 *      u16            datasize,     -- number of bytes to read
@@ -210,14 +210,14 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devA
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
+static int DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 u16 datasize,
 					 u8 *data, DRXflags_t flags)
 {
 	u8 buf[4];
 	u16 bufx;
-	DRXStatus_t rc;
+	int rc;
 	u16 overheadSize = 0;
 
 	/* Check parameters ******************************************************* */
@@ -302,7 +302,7 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 
 /******************************
 *
-* DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16 (
+* int DRXDAP_FASI_ReadModifyWriteReg16 (
 *      struct i2c_device_addr *devAddr,   -- address of I2C device
 *      DRXaddr_t        waddr,     -- address of chip register/memory
 *      DRXaddr_t        raddr,     -- chip address to read back from
@@ -325,12 +325,12 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
+static int DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						    DRXaddr_t waddr,
 						    DRXaddr_t raddr,
 						    u16 wdata, u16 *rdata)
 {
-	DRXStatus_t rc = DRX_STS_ERROR;
+	int rc = DRX_STS_ERROR;
 
 #if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
 	if (rdata == NULL) {
@@ -348,7 +348,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devA
 
 /******************************
 *
-* DRXStatus_t DRXDAP_FASI_ReadReg16 (
+* int DRXDAP_FASI_ReadReg16 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     u16 *data,    -- data to receive
@@ -364,12 +364,12 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devA
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
+static int DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 u16 *data, DRXflags_t flags)
 {
 	u8 buf[sizeof(*data)];
-	DRXStatus_t rc;
+	int rc;
 
 	if (!data) {
 		return DRX_STS_INVALID_ARG;
@@ -381,7 +381,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
 
 /******************************
 *
-* DRXStatus_t DRXDAP_FASI_ReadReg32 (
+* int DRXDAP_FASI_ReadReg32 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     u32 *data,    -- data to receive
@@ -397,12 +397,12 @@ static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
+static int DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 u32 *data, DRXflags_t flags)
 {
 	u8 buf[sizeof(*data)];
-	DRXStatus_t rc;
+	int rc;
 
 	if (!data) {
 		return DRX_STS_INVALID_ARG;
@@ -416,7 +416,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
 
 /******************************
 *
-* DRXStatus_t DRXDAP_FASI_WriteBlock (
+* int DRXDAP_FASI_WriteBlock (
 *      struct i2c_device_addr *devAddr,    -- address of I2C device
 *      DRXaddr_t        addr,       -- address of chip register/memory
 *      u16            datasize,   -- number of bytes to read
@@ -436,14 +436,14 @@ static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
+static int DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16 datasize,
 					  u8 *data, DRXflags_t flags)
 {
 	u8 buf[DRXDAP_MAX_WCHUNKSIZE];
-	DRXStatus_t st = DRX_STS_ERROR;
-	DRXStatus_t firstErr = DRX_STS_OK;
+	int st = DRX_STS_ERROR;
+	int firstErr = DRX_STS_OK;
 	u16 overheadSize = 0;
 	u16 blockSize = 0;
 
@@ -560,7 +560,7 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 
 /******************************
 *
-* DRXStatus_t DRXDAP_FASI_WriteReg16 (
+* int DRXDAP_FASI_WriteReg16 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     u16            data,    -- data to send
@@ -575,7 +575,7 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
+static int DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16 data, DRXflags_t flags)
 {
@@ -589,7 +589,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
 
 /******************************
 *
-* DRXStatus_t DRXDAP_FASI_WriteReg32 (
+* int DRXDAP_FASI_WriteReg32 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     u32            data,    -- data to send
@@ -604,7 +604,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,
+static int DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u32 data, DRXflags_t flags)
 {
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 19aa5465100d..d33f9cefe050 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -145,7 +145,7 @@ FUNCTIONS
 #ifndef DRX_EXCLUDE_SCAN
 
 /* Prototype of default scanning function */
-static DRXStatus_t
+static int
 ScanFunctionDefault(void *scanContext,
 		    DRXScanCommand_t scanCommand,
 		    pDRXChannel_t scanChannel, bool * getNextChannel);
@@ -197,7 +197,7 @@ void *GetScanContext(pDRXDemodInstance_t demod, void *scanContext)
 * \brief Wait for lock while scanning.
 * \param demod:    Pointer to demodulator instance.
 * \param lockStat: Pointer to bool indicating if end result is lock or not.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:    Success
 * \retval DRX_STS_ERROR: I2C failure or bsp function failure.
 *
@@ -211,7 +211,7 @@ void *GetScanContext(pDRXDemodInstance_t demod, void *scanContext)
 * In case DRX_NEVER_LOCK is returned the poll-wait will be aborted.
 *
 */
-static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, bool * isLocked)
+static int ScanWaitForLock(pDRXDemodInstance_t demod, bool * isLocked)
 {
 	bool doneWaiting = false;
 	DRXLockStatus_t lockState = DRX_NOT_LOCKED;
@@ -263,7 +263,7 @@ static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, bool * isLocked)
 * \brief Determine next frequency to scan.
 * \param demod: Pointer to demodulator instance.
 * \param skip : Minimum frequency step to take.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:          Succes.
 * \retval DRX_STS_INVALID_ARG: Invalid frequency plan.
 *
@@ -272,7 +272,7 @@ static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, bool * isLocked)
 * Check if scan is ready.
 *
 */
-static DRXStatus_t
+static int
 ScanPrepareNextScan(pDRXDemodInstance_t demod, s32 skip)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
@@ -345,7 +345,7 @@ ScanPrepareNextScan(pDRXDemodInstance_t demod, s32 skip)
 * \param scanChannel:    Channel to check: frequency and bandwidth, others AUTO
 * \param getNextChannel: Return true if next frequency is desired at next call
 *
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:      Channel found, DRX_CTRL_GET_CHANNEL can be used
 *                             to retrieve channel parameters.
 * \retval DRX_STS_BUSY:    Channel not found (yet).
@@ -353,13 +353,13 @@ ScanPrepareNextScan(pDRXDemodInstance_t demod, s32 skip)
 *
 * scanChannel and getNextChannel will be NULL for INIT and STOP.
 */
-static DRXStatus_t
+static int
 ScanFunctionDefault(void *scanContext,
 		    DRXScanCommand_t scanCommand,
 		    pDRXChannel_t scanChannel, bool * getNextChannel)
 {
 	pDRXDemodInstance_t demod = NULL;
-	DRXStatus_t status = DRX_STS_ERROR;
+	int status = DRX_STS_ERROR;
 	bool isLocked = false;
 
 	demod = (pDRXDemodInstance_t) scanContext;
@@ -398,7 +398,7 @@ ScanFunctionDefault(void *scanContext,
 * \brief Initialize for channel scan.
 * \param demod:     Pointer to demodulator instance.
 * \param scanParam: Pointer to scan parameters.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:          Initialized for scan.
 * \retval DRX_STS_ERROR:       No overlap between frequency plan and tuner
 *                              range.
@@ -411,10 +411,10 @@ ScanFunctionDefault(void *scanContext,
 * center frequency of the frequency plan that is within the tuner range.
 *
 */
-static DRXStatus_t
+static int
 CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 {
-	DRXStatus_t status = DRX_STS_ERROR;
+	int status = DRX_STS_ERROR;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	s32 maxTunerFreq = 0;
 	s32 minTunerFreq = 0;
@@ -546,14 +546,14 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 /**
 * \brief Stop scanning.
 * \param demod:         Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:          Scan stopped.
 * \retval DRX_STS_ERROR:       Something went wrong.
 * \retval DRX_STS_INVALID_ARG: Wrong parameters.
 */
-static DRXStatus_t CtrlScanStop(pDRXDemodInstance_t demod)
+static int CtrlScanStop(pDRXDemodInstance_t demod)
 {
-	DRXStatus_t status = DRX_STS_ERROR;
+	int status = DRX_STS_ERROR;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	void *scanContext = NULL;
 
@@ -587,7 +587,7 @@ static DRXStatus_t CtrlScanStop(pDRXDemodInstance_t demod)
 * \brief Scan for next channel.
 * \param demod:         Pointer to demodulator instance.
 * \param scanProgress:  Pointer to scan progress.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:          Channel found, DRX_CTRL_GET_CHANNEL can be used
 *                              to retrieve channel parameters.
 * \retval DRX_STS_BUSY:        Tried part of the channels, as specified in
@@ -601,7 +601,7 @@ static DRXStatus_t CtrlScanStop(pDRXDemodInstance_t demod)
 * Progress indication will run from 0 upto DRX_SCAN_MAX_PROGRESS during scan.
 *
 */
-static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
+static int CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	bool * scanReady = (bool *) (NULL);
@@ -636,7 +636,7 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 
 	for (i = 0; ((i < numTries) && ((*scanReady) == false)); i++) {
 		DRXChannel_t scanChannel = { 0 };
-		DRXStatus_t status = DRX_STS_ERROR;
+		int status = DRX_STS_ERROR;
 		pDRXFrequencyPlan_t freqPlan = (pDRXFrequencyPlan_t) (NULL);
 		bool nextChannel = false;
 		void *scanContext = NULL;
@@ -671,7 +671,7 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 
 		/* Proceed to next channel if requested */
 		if (nextChannel == true) {
-			DRXStatus_t nextStatus = DRX_STS_ERROR;
+			int nextStatus = DRX_STS_ERROR;
 			s32 skip = 0;
 
 			if (status == DRX_STS_OK) {
@@ -718,7 +718,7 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 * \brief Program tuner.
 * \param demod:         Pointer to demodulator instance.
 * \param tunerChannel:  Pointer to tuning parameters.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:          Tuner programmed successfully.
 * \retval DRX_STS_ERROR:       Something went wrong.
 * \retval DRX_STS_INVALID_ARG: Wrong parameters.
@@ -727,13 +727,13 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 * but also returns the actual RF and IF frequency from the tuner.
 *
 */
-static DRXStatus_t
+static int
 CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
-	TUNERMode_t tunerMode = 0;
-	DRXStatus_t status = DRX_STS_ERROR;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
+	u32 tunerMode = 0;
+	int status = DRX_STS_ERROR;
 	s32 ifFrequency = 0;
 	bool tunerSlowMode = false;
 
@@ -782,7 +782,7 @@ CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 
 	if (commonAttr->tunerPortNr == 1) {
 		bool bridgeClosed = true;
-		DRXStatus_t statusBridge = DRX_STS_ERROR;
+		int statusBridge = DRX_STS_ERROR;
 
 		statusBridge =
 		    DRX_Ctrl(demod, DRX_CTRL_I2C_BRIDGE, &bridgeClosed);
@@ -797,7 +797,7 @@ CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	/* attempt restoring bridge before checking status of SetFrequency */
 	if (commonAttr->tunerPortNr == 1) {
 		bool bridgeClosed = false;
-		DRXStatus_t statusBridge = DRX_STS_ERROR;
+		int statusBridge = DRX_STS_ERROR;
 
 		statusBridge =
 		    DRX_Ctrl(demod, DRX_CTRL_I2C_BRIDGE, &bridgeClosed);
@@ -833,13 +833,13 @@ CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 * \brief function to do a register dump.
 * \param demod:            Pointer to demodulator instance.
 * \param registers:        Registers to dump.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:          Dump executed successfully.
 * \retval DRX_STS_ERROR:       Something went wrong.
 * \retval DRX_STS_INVALID_ARG: Wrong parameters.
 *
 */
-DRXStatus_t CtrlDumpRegisters(pDRXDemodInstance_t demod,
+int CtrlDumpRegisters(pDRXDemodInstance_t demod,
 			      pDRXRegDump_t registers)
 {
 	u16 i = 0;
@@ -851,7 +851,7 @@ DRXStatus_t CtrlDumpRegisters(pDRXDemodInstance_t demod,
 
 	/* start dumping registers */
 	while (registers[i].address != 0) {
-		DRXStatus_t status = DRX_STS_ERROR;
+		int status = DRX_STS_ERROR;
 		u16 value = 0;
 		u32 data = 0;
 
@@ -968,7 +968,7 @@ static u16 UCodeComputeCRC(u8 *blockData, u16 nrWords)
 * \param devAddr: Address of device.
 * \param mcInfo:  Pointer to information about microcode data.
 * \param action:  Either UCODE_UPLOAD or UCODE_VERIFY
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:
 *                    - In case of UCODE_UPLOAD: code is successfully uploaded.
 *                    - In case of UCODE_VERIFY: image on device is equal to
@@ -981,11 +981,11 @@ static u16 UCodeComputeCRC(u8 *blockData, u16 nrWords)
 *                    - Invalid arguments.
 *                    - Provided image is corrupt
 */
-static DRXStatus_t
+static int
 CtrlUCode(pDRXDemodInstance_t demod,
 	  pDRXUCodeInfo_t mcInfo, DRXUCodeAction_t action)
 {
-	DRXStatus_t rc;
+	int rc;
 	u16 i = 0;
 	u16 mcNrOfBlks = 0;
 	u16 mcMagicWord = 0;
@@ -1197,11 +1197,11 @@ CtrlUCode(pDRXDemodInstance_t demod,
 * \brief Build list of version information.
 * \param demod: A pointer to a demodulator instance.
 * \param versionList: Pointer to linked list of versions.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK:          Version information stored in versionList
 * \retval DRX_STS_INVALID_ARG: Invalid arguments.
 */
-static DRXStatus_t
+static int
 CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 {
 	static char drxDriverCoreModuleName[] = "Core driver";
@@ -1212,7 +1212,7 @@ CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 	static DRXVersionList_t drxDriverCoreVersionList;
 
 	pDRXVersionList_t demodVersionList = (pDRXVersionList_t) (NULL);
-	DRXStatus_t returnStatus = DRX_STS_ERROR;
+	int returnStatus = DRX_STS_ERROR;
 
 	/* Check arguments */
 	if (versionList == NULL) {
@@ -1264,14 +1264,14 @@ CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 /**
 * \brief This function is obsolete.
 * \param demods: Don't care, parameter is ignored.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK: Initialization completed.
 *
 * This function is obsolete, prototype available for backward compatability.
 *
 */
 
-DRXStatus_t DRX_Init(pDRXDemodInstance_t demods[])
+int DRX_Init(pDRXDemodInstance_t demods[])
 {
 	return DRX_STS_OK;
 }
@@ -1280,14 +1280,14 @@ DRXStatus_t DRX_Init(pDRXDemodInstance_t demods[])
 
 /**
 * \brief This function is obsolete.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK: Terminated driver successful.
 *
 * This function is obsolete, prototype available for backward compatability.
 *
 */
 
-DRXStatus_t DRX_Term(void)
+int DRX_Term(void)
 {
 	return DRX_STS_OK;
 }
@@ -1297,7 +1297,7 @@ DRXStatus_t DRX_Term(void)
 /**
 * \brief Open a demodulator instance.
 * \param demod: A pointer to a demodulator instance.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK:          Opened demod instance with succes.
 * \retval DRX_STS_ERROR:       Driver not initialized or unable to initialize
 *                              demod.
@@ -1305,9 +1305,9 @@ DRXStatus_t DRX_Term(void)
 *
 */
 
-DRXStatus_t DRX_Open(pDRXDemodInstance_t demod)
+int DRX_Open(pDRXDemodInstance_t demod)
 {
-	DRXStatus_t status = DRX_STS_OK;
+	int status = DRX_STS_OK;
 
 	if ((demod == NULL) ||
 	    (demod->myDemodFunct == NULL) ||
@@ -1332,7 +1332,7 @@ DRXStatus_t DRX_Open(pDRXDemodInstance_t demod)
 /**
 * \brief Close device.
 * \param demod: A pointer to a demodulator instance.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK:          Closed demod instance with succes.
 * \retval DRX_STS_ERROR:       Driver not initialized or error during close
 *                              demod.
@@ -1342,9 +1342,9 @@ DRXStatus_t DRX_Open(pDRXDemodInstance_t demod)
 * Put device into sleep mode.
 */
 
-DRXStatus_t DRX_Close(pDRXDemodInstance_t demod)
+int DRX_Close(pDRXDemodInstance_t demod)
 {
-	DRXStatus_t status = DRX_STS_OK;
+	int status = DRX_STS_OK;
 
 	if ((demod == NULL) ||
 	    (demod->myDemodFunct == NULL) ||
@@ -1369,7 +1369,7 @@ DRXStatus_t DRX_Close(pDRXDemodInstance_t demod)
 * \param demod:    A pointer to a demodulator instance.
 * \param ctrl:     Reference to desired control function.
 * \param ctrlData: Pointer to data structure for control function.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK:                 Control function completed successfully.
 * \retval DRX_STS_ERROR:              Driver not initialized or error during
 *                                     control demod.
@@ -1382,10 +1382,10 @@ DRXStatus_t DRX_Close(pDRXDemodInstance_t demod)
 *
 */
 
-DRXStatus_t
-DRX_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
+int
+DRX_Ctrl(pDRXDemodInstance_t demod, u32 ctrl, void *ctrlData)
 {
-	DRXStatus_t status = DRX_STS_ERROR;
+	int status = DRX_STS_ERROR;
 
 	if ((demod == NULL) ||
 	    (demod->myDemodFunct == NULL) ||
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 752b2b3a50ac..1e906b8298fc 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -42,7 +42,7 @@
 INCLUDES
 -------------------------------------------------------------------------*/
 
-typedef enum {
+enum DRXStatus {
 	DRX_STS_READY = 3,  /**< device/service is ready     */
 	DRX_STS_BUSY = 2,   /**< device/service is busy      */
 	DRX_STS_OK = 1,	    /**< everything is OK            */
@@ -51,7 +51,7 @@ typedef enum {
 	DRX_STS_ERROR = -2, /**< general error               */
 	DRX_STS_FUNC_NOT_AVAILABLE = -3
 				/**< unavailable functionality   */
-} DRXStatus_t, *pDRXStatus_t;
+};
 
 /*
  * This structure contains the I2C address, the device ID and a userData pointer.
@@ -81,23 +81,23 @@ Exported FUNCTIONS
 /**
 * \fn DRXBSP_I2C_Init()
 * \brief Initialize I2C communication module.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK Initialization successful.
 * \retval DRX_STS_ERROR Initialization failed.
 */
-DRXStatus_t DRXBSP_I2C_Init(void);
+int DRXBSP_I2C_Init(void);
 
 /**
 * \fn DRXBSP_I2C_Term()
 * \brief Terminate I2C communication module.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK Termination successful.
 * \retval DRX_STS_ERROR Termination failed.
 */
-DRXStatus_t DRXBSP_I2C_Term(void);
+int DRXBSP_I2C_Term(void);
 
 /**
-* \fn DRXStatus_t DRXBSP_I2C_WriteRead( struct i2c_device_addr *wDevAddr,
+* \fn int DRXBSP_I2C_WriteRead( struct i2c_device_addr *wDevAddr,
 *                                       u16 wCount,
 *                                       u8 * wData,
 *                                       struct i2c_device_addr *rDevAddr,
@@ -110,7 +110,7 @@ DRXStatus_t DRXBSP_I2C_Term(void);
 * \param rDevAddr The device i2c address and the device ID to read from
 * \param rCount   The number of bytes to read
 * \param rData    The array to read the data from
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK Succes.
 * \retval DRX_STS_ERROR Failure.
 * \retval DRX_STS_INVALID_ARG Parameter 'wcount' is not zero but parameter
@@ -126,7 +126,7 @@ DRXStatus_t DRXBSP_I2C_Term(void);
 * The device ID can be useful if several devices share an I2C address.
 * It can be used to control a "switch" on the I2C bus to the correct device.
 */
-DRXStatus_t DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
+int DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
 					u16 wCount,
 					u8 * wData,
 					struct i2c_device_addr *rDevAddr,
@@ -170,26 +170,19 @@ extern int DRX_I2C_Error_g;
 			      TUNER_MODE_SUB4 | TUNER_MODE_SUB5 | \
 			      TUNER_MODE_SUB6 | TUNER_MODE_SUB7 )
 
-typedef u32 TUNERMode_t;
-typedef u32 * pTUNERMode_t;
-
-typedef char *TUNERSubMode_t;	/* description of submode */
-typedef TUNERSubMode_t *pTUNERSubMode_t;
-
-typedef enum {
 
+enum tuner_lock_status {
 	TUNER_LOCKED,
 	TUNER_NOT_LOCKED
-} TUNERLockStatus_t, *pTUNERLockStatus_t;
-
-typedef struct {
+};
 
+struct tuner_common {
 	char *name;	/* Tuner brand & type name */
 	s32 minFreqRF;	/* Lowest  RF input frequency, in kHz */
 	s32 maxFreqRF;	/* Highest RF input frequency, in kHz */
 
 	u8 subMode;	/* Index to sub-mode in use */
-	pTUNERSubMode_t subModeDescriptions;	/* Pointer to description of sub-modes */
+	char *** subModeDescriptions;	/* Pointer to description of sub-modes */
 	u8 subModes;	/* Number of available sub-modes      */
 
 	/* The following fields will be either 0, NULL or false and do not need
@@ -201,31 +194,30 @@ typedef struct {
 
 	void *myUserData;	/* pointer to associated demod instance */
 	u16 myCapabilities;	/* value for storing application flags  */
+};
 
-} TUNERCommonAttr_t, *pTUNERCommonAttr_t;
-
-typedef struct TUNERInstance_s *pTUNERInstance_t;
+struct tuner_instance;
 
-typedef DRXStatus_t(*TUNEROpenFunc_t) (pTUNERInstance_t tuner);
-typedef DRXStatus_t(*TUNERCloseFunc_t) (pTUNERInstance_t tuner);
+typedef int(*TUNEROpenFunc_t) (struct tuner_instance *tuner);
+typedef int(*TUNERCloseFunc_t) (struct tuner_instance *tuner);
 
-typedef DRXStatus_t(*TUNERSetFrequencyFunc_t) (pTUNERInstance_t tuner,
-						TUNERMode_t mode,
+typedef int(*TUNERSetFrequencyFunc_t) (struct tuner_instance *tuner,
+						u32 mode,
 						s32
 						frequency);
 
-typedef DRXStatus_t(*TUNERGetFrequencyFunc_t) (pTUNERInstance_t tuner,
-						TUNERMode_t mode,
+typedef int(*TUNERGetFrequencyFunc_t) (struct tuner_instance *tuner,
+						u32 mode,
 						s32 *
 						RFfrequency,
 						s32 *
 						IFfrequency);
 
-typedef DRXStatus_t(*TUNERLockStatusFunc_t) (pTUNERInstance_t tuner,
-						pTUNERLockStatus_t
+typedef int(*TUNERLockStatusFunc_t) (struct tuner_instance *tuner,
+						enum tuner_lock_status *
 						lockStat);
 
-typedef DRXStatus_t(*TUNERi2cWriteReadFunc_t) (pTUNERInstance_t tuner,
+typedef int(*TUNERi2cWriteReadFunc_t) (struct tuner_instance *tuner,
 						struct i2c_device_addr *
 						wDevAddr, u16 wCount,
 						u8 * wData,
@@ -233,7 +225,7 @@ typedef DRXStatus_t(*TUNERi2cWriteReadFunc_t) (pTUNERInstance_t tuner,
 						rDevAddr, u16 rCount,
 						u8 * rData);
 
-typedef struct {
+struct tuner_ops {
 	TUNEROpenFunc_t openFunc;
 	TUNERCloseFunc_t closeFunc;
 	TUNERSetFrequencyFunc_t setFrequencyFunc;
@@ -241,43 +233,42 @@ typedef struct {
 	TUNERLockStatusFunc_t lockStatusFunc;
 	TUNERi2cWriteReadFunc_t i2cWriteReadFunc;
 
-} TUNERFunc_t, *pTUNERFunc_t;
-
-typedef struct TUNERInstance_s {
+};
 
+struct tuner_instance {
 	struct i2c_device_addr myI2CDevAddr;
-	pTUNERCommonAttr_t myCommonAttr;
+	struct tuner_common * myCommonAttr;
 	void *myExtAttr;
-	pTUNERFunc_t myFunct;
+	struct tuner_ops * myFunct;
+};
 
-} TUNERInstance_t;
 
-DRXStatus_t DRXBSP_TUNER_Open(pTUNERInstance_t tuner);
+int DRXBSP_TUNER_Open(struct tuner_instance *tuner);
 
-DRXStatus_t DRXBSP_TUNER_Close(pTUNERInstance_t tuner);
+int DRXBSP_TUNER_Close(struct tuner_instance *tuner);
 
-DRXStatus_t DRXBSP_TUNER_SetFrequency(pTUNERInstance_t tuner,
-					TUNERMode_t mode,
+int DRXBSP_TUNER_SetFrequency(struct tuner_instance *tuner,
+					u32 mode,
 					s32 frequency);
 
-DRXStatus_t DRXBSP_TUNER_GetFrequency(pTUNERInstance_t tuner,
-					TUNERMode_t mode,
+int DRXBSP_TUNER_GetFrequency(struct tuner_instance *tuner,
+					u32 mode,
 					s32 * RFfrequency,
 					s32 * IFfrequency);
 
-DRXStatus_t DRXBSP_TUNER_LockStatus(pTUNERInstance_t tuner,
-					pTUNERLockStatus_t lockStat);
+int DRXBSP_TUNER_LockStatus(struct tuner_instance *tuner,
+					enum tuner_lock_status * lockStat);
 
-DRXStatus_t DRXBSP_TUNER_DefaultI2CWriteRead(pTUNERInstance_t tuner,
+int DRXBSP_TUNER_DefaultI2CWriteRead(struct tuner_instance *tuner,
 						struct i2c_device_addr *wDevAddr,
 						u16 wCount,
 						u8 * wData,
 						struct i2c_device_addr *rDevAddr,
 						u16 rCount, u8 * rData);
 
-DRXStatus_t DRXBSP_HST_Init(void);
+int DRXBSP_HST_Init(void);
 
-DRXStatus_t DRXBSP_HST_Term(void);
+int DRXBSP_HST_Term(void);
 
 void *DRXBSP_HST_Memcpy(void *to, void *from, u32 n);
 
@@ -285,19 +276,9 @@ int DRXBSP_HST_Memcmp(void *s1, void *s2, u32 n);
 
 u32 DRXBSP_HST_Clock(void);
 
-DRXStatus_t DRXBSP_HST_Sleep(u32 n);
+int DRXBSP_HST_Sleep(u32 n);
 
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-/*-------------------------------------------------------------------------
-TYPEDEFS
--------------------------------------------------------------------------*/
-
-/*-------------------------------------------------------------------------
-DEFINES
--------------------------------------------------------------------------*/
 
 /**************
 *
@@ -535,132 +516,132 @@ ENUM
 -------------------------------------------------------------------------*/
 
 /**
-* \enum DRXStandard_t
+* \enum enum drx_standard
 * \brief Modulation standards.
 */
-	typedef enum {
-		DRX_STANDARD_DVBT = 0, /**< Terrestrial DVB-T.               */
-		DRX_STANDARD_8VSB,     /**< Terrestrial 8VSB.                */
-		DRX_STANDARD_NTSC,     /**< Terrestrial\Cable analog NTSC.   */
-		DRX_STANDARD_PAL_SECAM_BG,
-				       /**< Terrestrial analog PAL/SECAM B/G */
-		DRX_STANDARD_PAL_SECAM_DK,
-				       /**< Terrestrial analog PAL/SECAM D/K */
-		DRX_STANDARD_PAL_SECAM_I,
-				       /**< Terrestrial analog PAL/SECAM I   */
-		DRX_STANDARD_PAL_SECAM_L,
-				       /**< Terrestrial analog PAL/SECAM L
-					     with negative modulation        */
-		DRX_STANDARD_PAL_SECAM_LP,
-				       /**< Terrestrial analog PAL/SECAM L
-					     with positive modulation        */
-		DRX_STANDARD_ITU_A,    /**< Cable ITU ANNEX A.               */
-		DRX_STANDARD_ITU_B,    /**< Cable ITU ANNEX B.               */
-		DRX_STANDARD_ITU_C,    /**< Cable ITU ANNEX C.               */
-		DRX_STANDARD_ITU_D,    /**< Cable ITU ANNEX D.               */
-		DRX_STANDARD_FM,       /**< Terrestrial\Cable FM radio       */
-		DRX_STANDARD_DTMB,     /**< Terrestrial DTMB standard (China)*/
-		DRX_STANDARD_UNKNOWN = DRX_UNKNOWN,
-				       /**< Standard unknown.                */
-		DRX_STANDARD_AUTO = DRX_AUTO
-				       /**< Autodetect standard.             */
-	} DRXStandard_t, *pDRXStandard_t;
-
-/**
-* \enum DRXStandard_t
+enum drx_standard {
+	DRX_STANDARD_DVBT = 0, /**< Terrestrial DVB-T.               */
+	DRX_STANDARD_8VSB,     /**< Terrestrial 8VSB.                */
+	DRX_STANDARD_NTSC,     /**< Terrestrial\Cable analog NTSC.   */
+	DRX_STANDARD_PAL_SECAM_BG,
+				/**< Terrestrial analog PAL/SECAM B/G */
+	DRX_STANDARD_PAL_SECAM_DK,
+				/**< Terrestrial analog PAL/SECAM D/K */
+	DRX_STANDARD_PAL_SECAM_I,
+				/**< Terrestrial analog PAL/SECAM I   */
+	DRX_STANDARD_PAL_SECAM_L,
+				/**< Terrestrial analog PAL/SECAM L
+					with negative modulation        */
+	DRX_STANDARD_PAL_SECAM_LP,
+				/**< Terrestrial analog PAL/SECAM L
+					with positive modulation        */
+	DRX_STANDARD_ITU_A,    /**< Cable ITU ANNEX A.               */
+	DRX_STANDARD_ITU_B,    /**< Cable ITU ANNEX B.               */
+	DRX_STANDARD_ITU_C,    /**< Cable ITU ANNEX C.               */
+	DRX_STANDARD_ITU_D,    /**< Cable ITU ANNEX D.               */
+	DRX_STANDARD_FM,       /**< Terrestrial\Cable FM radio       */
+	DRX_STANDARD_DTMB,     /**< Terrestrial DTMB standard (China)*/
+	DRX_STANDARD_UNKNOWN = DRX_UNKNOWN,
+				/**< Standard unknown.                */
+	DRX_STANDARD_AUTO = DRX_AUTO
+				/**< Autodetect standard.             */
+};
+
+/**
+* \enum enum drx_standard
 * \brief Modulation sub-standards.
 */
-	typedef enum {
-		DRX_SUBSTANDARD_MAIN = 0, /**< Main subvariant of standard   */
-		DRX_SUBSTANDARD_ATV_BG_SCANDINAVIA,
-		DRX_SUBSTANDARD_ATV_DK_POLAND,
-		DRX_SUBSTANDARD_ATV_DK_CHINA,
-		DRX_SUBSTANDARD_UNKNOWN = DRX_UNKNOWN,
-					  /**< Sub-standard unknown.         */
-		DRX_SUBSTANDARD_AUTO = DRX_AUTO
-					  /**< Auto (default) sub-standard   */
-	} DRXSubstandard_t, *pDRXSubstandard_t;
-
-/**
-* \enum DRXBandwidth_t
+enum drx_substandard {
+	DRX_SUBSTANDARD_MAIN = 0, /**< Main subvariant of standard   */
+	DRX_SUBSTANDARD_ATV_BG_SCANDINAVIA,
+	DRX_SUBSTANDARD_ATV_DK_POLAND,
+	DRX_SUBSTANDARD_ATV_DK_CHINA,
+	DRX_SUBSTANDARD_UNKNOWN = DRX_UNKNOWN,
+					/**< Sub-standard unknown.         */
+	DRX_SUBSTANDARD_AUTO = DRX_AUTO
+					/**< Auto (default) sub-standard   */
+};
+
+/**
+* \enum enum drx_bandwidth
 * \brief Channel bandwidth or channel spacing.
 */
-	typedef enum {
-		DRX_BANDWIDTH_8MHZ = 0,	 /**< Bandwidth 8 MHz.   */
-		DRX_BANDWIDTH_7MHZ,	 /**< Bandwidth 7 MHz.   */
-		DRX_BANDWIDTH_6MHZ,	 /**< Bandwidth 6 MHz.   */
-		DRX_BANDWIDTH_UNKNOWN = DRX_UNKNOWN,
-					 /**< Bandwidth unknown. */
-		DRX_BANDWIDTH_AUTO = DRX_AUTO
-					 /**< Auto Set Bandwidth */
-	} DRXBandwidth_t, *pDRXBandwidth_t;
+enum drx_bandwidth {
+	DRX_BANDWIDTH_8MHZ = 0,	 /**< Bandwidth 8 MHz.   */
+	DRX_BANDWIDTH_7MHZ,	 /**< Bandwidth 7 MHz.   */
+	DRX_BANDWIDTH_6MHZ,	 /**< Bandwidth 6 MHz.   */
+	DRX_BANDWIDTH_UNKNOWN = DRX_UNKNOWN,
+					/**< Bandwidth unknown. */
+	DRX_BANDWIDTH_AUTO = DRX_AUTO
+					/**< Auto Set Bandwidth */
+};
 
 /**
-* \enum DRXMirror_t
+* \enum enum drx_mirror
 * \brief Indicate if channel spectrum is mirrored or not.
 */
-	typedef enum {
-		DRX_MIRROR_NO = 0,   /**< Spectrum is not mirrored.           */
-		DRX_MIRROR_YES,	     /**< Spectrum is mirrored.               */
-		DRX_MIRROR_UNKNOWN = DRX_UNKNOWN,
-				     /**< Unknown if spectrum is mirrored.    */
-		DRX_MIRROR_AUTO = DRX_AUTO
-				     /**< Autodetect if spectrum is mirrored. */
-	} DRXMirror_t, *pDRXMirror_t;
+enum drx_mirror{
+	DRX_MIRROR_NO = 0,   /**< Spectrum is not mirrored.           */
+	DRX_MIRROR_YES,	     /**< Spectrum is mirrored.               */
+	DRX_MIRROR_UNKNOWN = DRX_UNKNOWN,
+				/**< Unknown if spectrum is mirrored.    */
+	DRX_MIRROR_AUTO = DRX_AUTO
+				/**< Autodetect if spectrum is mirrored. */
+};
 
 /**
-* \enum DRXConstellation_t
+* \enum enum drx_modulation
 * \brief Constellation type of the channel.
 */
-	typedef enum {
-		DRX_CONSTELLATION_BPSK = 0,  /**< Modulation is BPSK.       */
-		DRX_CONSTELLATION_QPSK,	     /**< Constellation is QPSK.    */
-		DRX_CONSTELLATION_PSK8,	     /**< Constellation is PSK8.    */
-		DRX_CONSTELLATION_QAM16,     /**< Constellation is QAM16.   */
-		DRX_CONSTELLATION_QAM32,     /**< Constellation is QAM32.   */
-		DRX_CONSTELLATION_QAM64,     /**< Constellation is QAM64.   */
-		DRX_CONSTELLATION_QAM128,    /**< Constellation is QAM128.  */
-		DRX_CONSTELLATION_QAM256,    /**< Constellation is QAM256.  */
-		DRX_CONSTELLATION_QAM512,    /**< Constellation is QAM512.  */
-		DRX_CONSTELLATION_QAM1024,   /**< Constellation is QAM1024. */
-		DRX_CONSTELLATION_QPSK_NR,   /**< Constellation is QPSK_NR  */
-		DRX_CONSTELLATION_UNKNOWN = DRX_UNKNOWN,
-					     /**< Constellation unknown.    */
-		DRX_CONSTELLATION_AUTO = DRX_AUTO
-					     /**< Autodetect constellation. */
-	} DRXConstellation_t, *pDRXConstellation_t;
-
-/**
-* \enum DRXHierarchy_t
+enum drx_modulation {
+	DRX_CONSTELLATION_BPSK = 0,  /**< Modulation is BPSK.       */
+	DRX_CONSTELLATION_QPSK,	     /**< Constellation is QPSK.    */
+	DRX_CONSTELLATION_PSK8,	     /**< Constellation is PSK8.    */
+	DRX_CONSTELLATION_QAM16,     /**< Constellation is QAM16.   */
+	DRX_CONSTELLATION_QAM32,     /**< Constellation is QAM32.   */
+	DRX_CONSTELLATION_QAM64,     /**< Constellation is QAM64.   */
+	DRX_CONSTELLATION_QAM128,    /**< Constellation is QAM128.  */
+	DRX_CONSTELLATION_QAM256,    /**< Constellation is QAM256.  */
+	DRX_CONSTELLATION_QAM512,    /**< Constellation is QAM512.  */
+	DRX_CONSTELLATION_QAM1024,   /**< Constellation is QAM1024. */
+	DRX_CONSTELLATION_QPSK_NR,   /**< Constellation is QPSK_NR  */
+	DRX_CONSTELLATION_UNKNOWN = DRX_UNKNOWN,
+					/**< Constellation unknown.    */
+	DRX_CONSTELLATION_AUTO = DRX_AUTO
+					/**< Autodetect constellation. */
+};
+
+/**
+* \enum enum drx_hierarchy
 * \brief Hierarchy of the channel.
 */
-	typedef enum {
-		DRX_HIERARCHY_NONE = 0,	/**< None hierarchical channel.     */
-		DRX_HIERARCHY_ALPHA1,	/**< Hierarchical channel, alpha=1. */
-		DRX_HIERARCHY_ALPHA2,	/**< Hierarchical channel, alpha=2. */
-		DRX_HIERARCHY_ALPHA4,	/**< Hierarchical channel, alpha=4. */
-		DRX_HIERARCHY_UNKNOWN = DRX_UNKNOWN,
-					/**< Hierarchy unknown.             */
-		DRX_HIERARCHY_AUTO = DRX_AUTO
-					/**< Autodetect hierarchy.          */
-	} DRXHierarchy_t, *pDRXHierarchy_t;
-
-/**
-* \enum DRXPriority_t
+enum drx_hierarchy {
+	DRX_HIERARCHY_NONE = 0,	/**< None hierarchical channel.     */
+	DRX_HIERARCHY_ALPHA1,	/**< Hierarchical channel, alpha=1. */
+	DRX_HIERARCHY_ALPHA2,	/**< Hierarchical channel, alpha=2. */
+	DRX_HIERARCHY_ALPHA4,	/**< Hierarchical channel, alpha=4. */
+	DRX_HIERARCHY_UNKNOWN = DRX_UNKNOWN,
+				/**< Hierarchy unknown.             */
+	DRX_HIERARCHY_AUTO = DRX_AUTO
+				/**< Autodetect hierarchy.          */
+};
+
+/**
+* \enum enum drx_priority
 * \brief Channel priority in case of hierarchical transmission.
 */
-	typedef enum {
-		DRX_PRIORITY_LOW = 0,  /**< Low priority channel.  */
-		DRX_PRIORITY_HIGH,     /**< High priority channel. */
-		DRX_PRIORITY_UNKNOWN = DRX_UNKNOWN
-				       /**< Priority unknown.      */
-	} DRXPriority_t, *pDRXPriority_t;
+enum drx_priority {
+	DRX_PRIORITY_LOW = 0,  /**< Low priority channel.  */
+	DRX_PRIORITY_HIGH,     /**< High priority channel. */
+	DRX_PRIORITY_UNKNOWN = DRX_UNKNOWN
+				/**< Priority unknown.      */
+};
 
 /**
-* \enum DRXCoderate_t
+* \enum enum drx_coderate
 * \brief Channel priority in case of hierarchical transmission.
 */
-	typedef enum {
+enum drx_coderate{
 		DRX_CODERATE_1DIV2 = 0,	/**< Code rate 1/2nd.      */
 		DRX_CODERATE_2DIV3,	/**< Code rate 2/3nd.      */
 		DRX_CODERATE_3DIV4,	/**< Code rate 3/4nd.      */
@@ -670,164 +651,156 @@ ENUM
 					/**< Code rate unknown.    */
 		DRX_CODERATE_AUTO = DRX_AUTO
 					/**< Autodetect code rate. */
-	} DRXCoderate_t, *pDRXCoderate_t;
+};
 
 /**
-* \enum DRXGuard_t
+* \enum enum drx_guard
 * \brief Guard interval of a channel.
 */
-	typedef enum {
-		DRX_GUARD_1DIV32 = 0, /**< Guard interval 1/32nd.     */
-		DRX_GUARD_1DIV16,     /**< Guard interval 1/16th.     */
-		DRX_GUARD_1DIV8,      /**< Guard interval 1/8th.      */
-		DRX_GUARD_1DIV4,      /**< Guard interval 1/4th.      */
-		DRX_GUARD_UNKNOWN = DRX_UNKNOWN,
-				      /**< Guard interval unknown.    */
-		DRX_GUARD_AUTO = DRX_AUTO
-				      /**< Autodetect guard interval. */
-	} DRXGuard_t, *pDRXGuard_t;
-
-/**
-* \enum DRXFftmode_t
+enum drx_guard {
+	DRX_GUARD_1DIV32 = 0, /**< Guard interval 1/32nd.     */
+	DRX_GUARD_1DIV16,     /**< Guard interval 1/16th.     */
+	DRX_GUARD_1DIV8,      /**< Guard interval 1/8th.      */
+	DRX_GUARD_1DIV4,      /**< Guard interval 1/4th.      */
+	DRX_GUARD_UNKNOWN = DRX_UNKNOWN,
+				/**< Guard interval unknown.    */
+	DRX_GUARD_AUTO = DRX_AUTO
+				/**< Autodetect guard interval. */
+};
+
+/**
+* \enum enum drx_fft_mode
 * \brief FFT mode.
 */
-	typedef enum {
-		DRX_FFTMODE_2K = 0,    /**< 2K FFT mode.         */
-		DRX_FFTMODE_4K,	       /**< 4K FFT mode.         */
-		DRX_FFTMODE_8K,	       /**< 8K FFT mode.         */
-		DRX_FFTMODE_UNKNOWN = DRX_UNKNOWN,
-				       /**< FFT mode unknown.    */
-		DRX_FFTMODE_AUTO = DRX_AUTO
-				       /**< Autodetect FFT mode. */
-	} DRXFftmode_t, *pDRXFftmode_t;
+enum drx_fft_mode {
+	DRX_FFTMODE_2K = 0,    /**< 2K FFT mode.         */
+	DRX_FFTMODE_4K,	       /**< 4K FFT mode.         */
+	DRX_FFTMODE_8K,	       /**< 8K FFT mode.         */
+	DRX_FFTMODE_UNKNOWN = DRX_UNKNOWN,
+				/**< FFT mode unknown.    */
+	DRX_FFTMODE_AUTO = DRX_AUTO
+				/**< Autodetect FFT mode. */
+};
 
 /**
-* \enum DRXClassification_t
+* \enum enum drx_classification
 * \brief Channel classification.
 */
-	typedef enum {
-		DRX_CLASSIFICATION_GAUSS = 0, /**< Gaussion noise.            */
-		DRX_CLASSIFICATION_HVY_GAUSS, /**< Heavy Gaussion noise.      */
-		DRX_CLASSIFICATION_COCHANNEL, /**< Co-channel.                */
-		DRX_CLASSIFICATION_STATIC,    /**< Static echo.               */
-		DRX_CLASSIFICATION_MOVING,    /**< Moving echo.               */
-		DRX_CLASSIFICATION_ZERODB,    /**< Zero dB echo.              */
-		DRX_CLASSIFICATION_UNKNOWN = DRX_UNKNOWN,
-					      /**< Unknown classification     */
-		DRX_CLASSIFICATION_AUTO = DRX_AUTO
-					      /**< Autodetect classification. */
-	} DRXClassification_t, *pDRXClassification_t;
-
-/**
-* /enum DRXInterleaveModes_t
+enum drx_classification {
+	DRX_CLASSIFICATION_GAUSS = 0, /**< Gaussion noise.            */
+	DRX_CLASSIFICATION_HVY_GAUSS, /**< Heavy Gaussion noise.      */
+	DRX_CLASSIFICATION_COCHANNEL, /**< Co-channel.                */
+	DRX_CLASSIFICATION_STATIC,    /**< Static echo.               */
+	DRX_CLASSIFICATION_MOVING,    /**< Moving echo.               */
+	DRX_CLASSIFICATION_ZERODB,    /**< Zero dB echo.              */
+	DRX_CLASSIFICATION_UNKNOWN = DRX_UNKNOWN,
+					/**< Unknown classification     */
+	DRX_CLASSIFICATION_AUTO = DRX_AUTO
+					/**< Autodetect classification. */
+};
+
+/**
+* /enum enum drx_interleave_mode
 * /brief Interleave modes
 */
-	typedef enum {
-		DRX_INTERLEAVEMODE_I128_J1 = 0,
-		DRX_INTERLEAVEMODE_I128_J1_V2,
-		DRX_INTERLEAVEMODE_I128_J2,
-		DRX_INTERLEAVEMODE_I64_J2,
-		DRX_INTERLEAVEMODE_I128_J3,
-		DRX_INTERLEAVEMODE_I32_J4,
-		DRX_INTERLEAVEMODE_I128_J4,
-		DRX_INTERLEAVEMODE_I16_J8,
-		DRX_INTERLEAVEMODE_I128_J5,
-		DRX_INTERLEAVEMODE_I8_J16,
-		DRX_INTERLEAVEMODE_I128_J6,
-		DRX_INTERLEAVEMODE_RESERVED_11,
-		DRX_INTERLEAVEMODE_I128_J7,
-		DRX_INTERLEAVEMODE_RESERVED_13,
-		DRX_INTERLEAVEMODE_I128_J8,
-		DRX_INTERLEAVEMODE_RESERVED_15,
-		DRX_INTERLEAVEMODE_I12_J17,
-		DRX_INTERLEAVEMODE_I5_J4,
-		DRX_INTERLEAVEMODE_B52_M240,
-		DRX_INTERLEAVEMODE_B52_M720,
-		DRX_INTERLEAVEMODE_B52_M48,
-		DRX_INTERLEAVEMODE_B52_M0,
-		DRX_INTERLEAVEMODE_UNKNOWN = DRX_UNKNOWN,
-					      /**< Unknown interleave mode    */
-		DRX_INTERLEAVEMODE_AUTO = DRX_AUTO
-					      /**< Autodetect interleave mode */
-	} DRXInterleaveModes_t, *pDRXInterleaveModes_t;
-
-/**
-* \enum DRXCarrier_t
+enum drx_interleave_mode {
+	DRX_INTERLEAVEMODE_I128_J1 = 0,
+	DRX_INTERLEAVEMODE_I128_J1_V2,
+	DRX_INTERLEAVEMODE_I128_J2,
+	DRX_INTERLEAVEMODE_I64_J2,
+	DRX_INTERLEAVEMODE_I128_J3,
+	DRX_INTERLEAVEMODE_I32_J4,
+	DRX_INTERLEAVEMODE_I128_J4,
+	DRX_INTERLEAVEMODE_I16_J8,
+	DRX_INTERLEAVEMODE_I128_J5,
+	DRX_INTERLEAVEMODE_I8_J16,
+	DRX_INTERLEAVEMODE_I128_J6,
+	DRX_INTERLEAVEMODE_RESERVED_11,
+	DRX_INTERLEAVEMODE_I128_J7,
+	DRX_INTERLEAVEMODE_RESERVED_13,
+	DRX_INTERLEAVEMODE_I128_J8,
+	DRX_INTERLEAVEMODE_RESERVED_15,
+	DRX_INTERLEAVEMODE_I12_J17,
+	DRX_INTERLEAVEMODE_I5_J4,
+	DRX_INTERLEAVEMODE_B52_M240,
+	DRX_INTERLEAVEMODE_B52_M720,
+	DRX_INTERLEAVEMODE_B52_M48,
+	DRX_INTERLEAVEMODE_B52_M0,
+	DRX_INTERLEAVEMODE_UNKNOWN = DRX_UNKNOWN,
+					/**< Unknown interleave mode    */
+	DRX_INTERLEAVEMODE_AUTO = DRX_AUTO
+					/**< Autodetect interleave mode */
+};
+
+/**
+* \enum enum drx_carrier_mode
 * \brief Channel Carrier Mode.
 */
-	typedef enum {
-		DRX_CARRIER_MULTI = 0,		/**< Multi carrier mode       */
-		DRX_CARRIER_SINGLE,		/**< Single carrier mode      */
-		DRX_CARRIER_UNKNOWN = DRX_UNKNOWN,
-						/**< Carrier mode unknown.    */
-		DRX_CARRIER_AUTO = DRX_AUTO	/**< Autodetect carrier mode  */
-	} DRXCarrier_t, *pDRXCarrier_t;
+enum drx_carrier_mode{
+	DRX_CARRIER_MULTI = 0,		/**< Multi carrier mode       */
+	DRX_CARRIER_SINGLE,		/**< Single carrier mode      */
+	DRX_CARRIER_UNKNOWN = DRX_UNKNOWN,
+					/**< Carrier mode unknown.    */
+	DRX_CARRIER_AUTO = DRX_AUTO	/**< Autodetect carrier mode  */
+};
 
 /**
-* \enum DRXFramemode_t
+* \enum enum drx_frame_mode
 * \brief Channel Frame Mode.
 */
-	typedef enum {
-		DRX_FRAMEMODE_420 = 0,	 /**< 420 with variable PN  */
-		DRX_FRAMEMODE_595,	 /**< 595                   */
-		DRX_FRAMEMODE_945,	 /**< 945 with variable PN  */
-		DRX_FRAMEMODE_420_FIXED_PN,
-					 /**< 420 with fixed PN     */
-		DRX_FRAMEMODE_945_FIXED_PN,
-					 /**< 945 with fixed PN     */
-		DRX_FRAMEMODE_UNKNOWN = DRX_UNKNOWN,
-					 /**< Frame mode unknown.   */
-		DRX_FRAMEMODE_AUTO = DRX_AUTO
-					 /**< Autodetect frame mode */
-	} DRXFramemode_t, *pDRXFramemode_t;
-
-/**
-* \enum DRXTPSFrame_t
+enum drx_frame_mode{
+	DRX_FRAMEMODE_420 = 0,	 /**< 420 with variable PN  */
+	DRX_FRAMEMODE_595,	 /**< 595                   */
+	DRX_FRAMEMODE_945,	 /**< 945 with variable PN  */
+	DRX_FRAMEMODE_420_FIXED_PN,
+					/**< 420 with fixed PN     */
+	DRX_FRAMEMODE_945_FIXED_PN,
+					/**< 945 with fixed PN     */
+	DRX_FRAMEMODE_UNKNOWN = DRX_UNKNOWN,
+					/**< Frame mode unknown.   */
+	DRX_FRAMEMODE_AUTO = DRX_AUTO
+					/**< Autodetect frame mode */
+};
+
+/**
+* \enum enum drx_tps_frame
 * \brief Frame number in current super-frame.
 */
-	typedef enum {
-		DRX_TPS_FRAME1 = 0,	  /**< TPS frame 1.       */
-		DRX_TPS_FRAME2,		  /**< TPS frame 2.       */
-		DRX_TPS_FRAME3,		  /**< TPS frame 3.       */
-		DRX_TPS_FRAME4,		  /**< TPS frame 4.       */
-		DRX_TPS_FRAME_UNKNOWN = DRX_UNKNOWN
-					  /**< TPS frame unknown. */
-	} DRXTPSFrame_t, *pDRXTPSFrame_t;
+enum drx_tps_frame{
+	DRX_TPS_FRAME1 = 0,	  /**< TPS frame 1.       */
+	DRX_TPS_FRAME2,		  /**< TPS frame 2.       */
+	DRX_TPS_FRAME3,		  /**< TPS frame 3.       */
+	DRX_TPS_FRAME4,		  /**< TPS frame 4.       */
+	DRX_TPS_FRAME_UNKNOWN = DRX_UNKNOWN
+					/**< TPS frame unknown. */
+};
 
 /**
-* \enum DRXLDPC_t
+* \enum enum drx_ldpc
 * \brief TPS LDPC .
 */
-	typedef enum {
-		DRX_LDPC_0_4 = 0,	  /**< LDPC 0.4           */
-		DRX_LDPC_0_6,		  /**< LDPC 0.6           */
-		DRX_LDPC_0_8,		  /**< LDPC 0.8           */
-		DRX_LDPC_UNKNOWN = DRX_UNKNOWN,
-					  /**< LDPC unknown.      */
-		DRX_LDPC_AUTO = DRX_AUTO  /**< Autodetect LDPC    */
-	} DRXLDPC_t, *pDRXLDPC_t;
+enum drx_ldpc{
+	DRX_LDPC_0_4 = 0,	  /**< LDPC 0.4           */
+	DRX_LDPC_0_6,		  /**< LDPC 0.6           */
+	DRX_LDPC_0_8,		  /**< LDPC 0.8           */
+	DRX_LDPC_UNKNOWN = DRX_UNKNOWN,
+					/**< LDPC unknown.      */
+	DRX_LDPC_AUTO = DRX_AUTO  /**< Autodetect LDPC    */
+};
 
 /**
-* \enum DRXPilotMode_t
+* \enum enum drx_pilot_mode
 * \brief Pilot modes in DTMB.
 */
-	typedef enum {
-		DRX_PILOT_ON = 0,	  /**< Pilot On             */
-		DRX_PILOT_OFF,		  /**< Pilot Off            */
-		DRX_PILOT_UNKNOWN = DRX_UNKNOWN,
-					  /**< Pilot unknown.       */
-		DRX_PILOT_AUTO = DRX_AUTO /**< Autodetect Pilot     */
-	} DRXPilotMode_t, *pDRXPilotMode_t;
-
-/**
-* \enum DRXCtrlIndex_t
-* \brief Indices of the control functions.
-*/
-	typedef u32 DRXCtrlIndex_t, *pDRXCtrlIndex_t;
+enum drx_pilot_mode{
+	DRX_PILOT_ON = 0,	  /**< Pilot On             */
+	DRX_PILOT_OFF,		  /**< Pilot Off            */
+	DRX_PILOT_UNKNOWN = DRX_UNKNOWN,
+					/**< Pilot unknown.       */
+	DRX_PILOT_AUTO = DRX_AUTO /**< Autodetect Pilot     */
+};
 
-#ifndef DRX_CTRL_BASE
-#define DRX_CTRL_BASE          ((DRXCtrlIndex_t)0)
-#endif
+#define DRX_CTRL_BASE          ((u32)0)
 
 #define DRX_CTRL_NOP             ( DRX_CTRL_BASE +  0)/**< No Operation       */
 #define DRX_CTRL_PROBE_DEVICE    ( DRX_CTRL_BASE +  1)/**< Probe device       */
@@ -1129,28 +1102,28 @@ STRUCTS
 	typedef struct {
 		s32 frequency;
 					/**< frequency in kHz                 */
-		DRXBandwidth_t bandwidth;
+		enum drx_bandwidth bandwidth;
 					/**< bandwidth                        */
-		DRXMirror_t mirror;	/**< mirrored or not on RF            */
-		DRXConstellation_t constellation;
+		enum drx_mirror mirror;	/**< mirrored or not on RF            */
+		enum drx_modulation constellation;
 					/**< constellation                    */
-		DRXHierarchy_t hierarchy;
+		enum drx_hierarchy hierarchy;
 					/**< hierarchy                        */
-		DRXPriority_t priority;	/**< priority                         */
-		DRXCoderate_t coderate;	/**< coderate                         */
-		DRXGuard_t guard;	/**< guard interval                   */
-		DRXFftmode_t fftmode;	/**< fftmode                          */
-		DRXClassification_t classification;
+		enum drx_priority priority;	/**< priority                         */
+		enum drx_coderate coderate;	/**< coderate                         */
+		enum drx_guard guard;	/**< guard interval                   */
+		enum drx_fft_mode fftmode;	/**< fftmode                          */
+		enum drx_classification classification;
 					/**< classification                   */
 		u32 symbolrate;
 					/**< symbolrate in symbols/sec        */
-		DRXInterleaveModes_t interleavemode;
+		enum drx_interleave_mode interleavemode;
 					/**< interleaveMode QAM               */
-		DRXLDPC_t ldpc;		/**< ldpc                             */
-		DRXCarrier_t carrier;	/**< carrier                          */
-		DRXFramemode_t framemode;
+		enum drx_ldpc ldpc;		/**< ldpc                             */
+		enum drx_carrier_mode carrier;	/**< carrier                          */
+		enum drx_frame_mode framemode;
 					/**< frame mode                       */
-		DRXPilotMode_t pilot;	/**< pilot mode                       */
+		enum drx_pilot_mode pilot;	/**< pilot mode                       */
 	} DRXChannel_t, *pDRXChannel_t;
 
 /*========================================*/
@@ -1217,7 +1190,7 @@ STRUCTS
 			     /**< Last centre frequency in this band         */
 		s32 step;
 			     /**< Stepping frequency in this band            */
-		DRXBandwidth_t bandwidth;
+		enum drx_bandwidth bandwidth;
 			     /**< Bandwidth within this frequency band       */
 		u16 chNumber;
 			     /**< First channel number in this band, or first
@@ -1250,7 +1223,7 @@ STRUCTS
 	typedef struct {
 		u32 *symbolrate;	  /**<  list of symbolrates to scan   */
 		u16 symbolrateSize;	  /**<  size of symbolrate array      */
-		pDRXConstellation_t constellation;
+		enum drx_modulation * constellation;
 					  /**<  list of constellations        */
 		u16 constellationSize;    /**<  size of constellation array */
 		u16 ifAgcThreshold;	  /**<  thresholf for IF-AGC based
@@ -1303,7 +1276,7 @@ STRUCTS
 /**
 * \brief Inner scan function prototype.
 */
-	typedef DRXStatus_t(*DRXScanFunc_t) (void *scanContext,
+	typedef int(*DRXScanFunc_t) (void *scanContext,
 					     DRXScanCommand_t scanCommand,
 					     pDRXChannel_t scanChannel,
 					     bool * getNextChannel);
@@ -1317,17 +1290,17 @@ STRUCTS
 * Used by DRX_CTRL_TPS_INFO.
 */
 	typedef struct {
-		DRXFftmode_t fftmode;	/**< Fft mode       */
-		DRXGuard_t guard;	/**< Guard interval */
-		DRXConstellation_t constellation;
+		enum drx_fft_mode fftmode;	/**< Fft mode       */
+		enum drx_guard guard;	/**< Guard interval */
+		enum drx_modulation constellation;
 					/**< Constellation  */
-		DRXHierarchy_t hierarchy;
+		enum drx_hierarchy hierarchy;
 					/**< Hierarchy      */
-		DRXCoderate_t highCoderate;
+		enum drx_coderate highCoderate;
 					/**< High code rate */
-		DRXCoderate_t lowCoderate;
+		enum drx_coderate lowCoderate;
 					/**< Low cod rate   */
-		DRXTPSFrame_t frame;	/**< Tps frame      */
+		enum drx_tps_frame frame;	/**< Tps frame      */
 		u8 length;		/**< Length         */
 		u16 cellId;		/**< Cell id        */
 	} DRXTPSInfo_t, *pDRXTPSInfo_t;
@@ -1970,71 +1943,71 @@ STRUCTS
 	typedef u32 DRXflags_t, *pDRXflags_t;
 
 /* Write block of data to device */
-	typedef DRXStatus_t(*DRXWriteBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXWriteBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
 						   u16 datasize,	/* size of data in bytes        */
 						   u8 *data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read block of data from device */
-	typedef DRXStatus_t(*DRXReadBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXReadBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  u16 datasize,	/* size of data in bytes        */
 						  u8 *data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Write 8-bits value to device */
-	typedef DRXStatus_t(*DRXWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  u8 data,	/* data to send                 */
 						  DRXflags_t flags);
 
 /* Read 8-bits value to device */
-	typedef DRXStatus_t(*DRXReadReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXReadReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						 DRXaddr_t addr,	/* address of register/memory   */
 						 u8 *data,	/* receive buffer               */
 						 DRXflags_t flags);
 
 /* Read modify write 8-bits value to device */
-	typedef DRXStatus_t(*DRXReadModifyWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
+	typedef int(*DRXReadModifyWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							    DRXaddr_t waddr,	/* write address of register   */
 							    DRXaddr_t raddr,	/* read  address of register   */
 							    u8 wdata,	/* data to write               */
 							    u8 *rdata);	/* data to read                */
 
 /* Write 16-bits value to device */
-	typedef DRXStatus_t(*DRXWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
 						   u16 data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read 16-bits value to device */
-	typedef DRXStatus_t(*DRXReadReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXReadReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  u16 *data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Read modify write 16-bits value to device */
-	typedef DRXStatus_t(*DRXReadModifyWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
+	typedef int(*DRXReadModifyWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							     DRXaddr_t waddr,	/* write address of register   */
 							     DRXaddr_t raddr,	/* read  address of register   */
 							     u16 wdata,	/* data to write               */
 							     u16 *rdata);	/* data to read                */
 
 /* Write 32-bits value to device */
-	typedef DRXStatus_t(*DRXWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
 						   u32 data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read 32-bits value to device */
-	typedef DRXStatus_t(*DRXReadReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
+	typedef int(*DRXReadReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  u32 *data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Read modify write 32-bits value to device */
-	typedef DRXStatus_t(*DRXReadModifyWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
+	typedef int(*DRXReadModifyWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							     DRXaddr_t waddr,	/* write address of register   */
 							     DRXaddr_t raddr,	/* read  address of register   */
 							     u32 wdata,	/* data to write               */
@@ -2146,11 +2119,11 @@ STRUCTS
 
 		DRXChannel_t currentChannel;
 				      /**< current channel parameters         */
-		DRXStandard_t currentStandard;
+		enum drx_standard currentStandard;
 				      /**< current standard selection         */
-		DRXStandard_t prevStandard;
+		enum drx_standard prevStandard;
 				      /**< previous standard selection        */
-		DRXStandard_t diCacheStandard;
+		enum drx_standard diCacheStandard;
 				      /**< standard in DI cache if available  */
 		bool useBootloader; /**< use bootloader in open             */
 		u32 capabilities;   /**< capabilities flags                 */
@@ -2163,10 +2136,10 @@ STRUCTS
 */
 	typedef struct DRXDemodInstance_s *pDRXDemodInstance_t;
 
-	typedef DRXStatus_t(*DRXOpenFunc_t) (pDRXDemodInstance_t demod);
-	typedef DRXStatus_t(*DRXCloseFunc_t) (pDRXDemodInstance_t demod);
-	typedef DRXStatus_t(*DRXCtrlFunc_t) (pDRXDemodInstance_t demod,
-					     DRXCtrlIndex_t ctrl,
+	typedef int(*DRXOpenFunc_t) (pDRXDemodInstance_t demod);
+	typedef int(*DRXCloseFunc_t) (pDRXDemodInstance_t demod);
+	typedef int(*DRXCtrlFunc_t) (pDRXDemodInstance_t demod,
+					     u32 ctrl,
 					     void *ctrlData);
 
 /**
@@ -2190,7 +2163,7 @@ STRUCTS
 				    /**< demodulator functions                */
 		pDRXAccessFunc_t myAccessFunct;
 				    /**< data access protocol functions       */
-		pTUNERInstance_t myTuner;
+		struct tuner_instance *myTuner;
 				    /**< tuner instance,if NULL then baseband */
 		struct i2c_device_addr *myI2CDevAddr;
 				    /**< i2c address and device identifier    */
@@ -2865,7 +2838,7 @@ Access macros
 
 #define DRX_ACCESSMACRO_GET( demod, value, cfgName, dataType, errorValue ) \
    do {                                                                    \
-      DRXStatus_t cfgStatus;                                               \
+      int cfgStatus;                                               \
       DRXCfg_t    config;                                                  \
       dataType    cfgData;                                                 \
       config.cfgType = cfgName;                                            \
@@ -2946,21 +2919,18 @@ Access macros
 Exported FUNCTIONS
 -------------------------------------------------------------------------*/
 
-	DRXStatus_t DRX_Init(pDRXDemodInstance_t demods[]);
+	int DRX_Init(pDRXDemodInstance_t demods[]);
 
-	DRXStatus_t DRX_Term(void);
+	int DRX_Term(void);
 
-	DRXStatus_t DRX_Open(pDRXDemodInstance_t demod);
+	int DRX_Open(pDRXDemodInstance_t demod);
 
-	DRXStatus_t DRX_Close(pDRXDemodInstance_t demod);
+	int DRX_Close(pDRXDemodInstance_t demod);
 
-	DRXStatus_t DRX_Ctrl(pDRXDemodInstance_t demod,
-			     DRXCtrlIndex_t ctrl, void *ctrlData);
+	int DRX_Ctrl(pDRXDemodInstance_t demod,
+			     u32 ctrl, void *ctrlData);
 
 /*-------------------------------------------------------------------------
 THE END
 -------------------------------------------------------------------------*/
-#ifdef __cplusplus
-}
-#endif
 #endif				/* __DRXDRIVER_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 384b86951353..c8212069a540 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -586,10 +586,10 @@ DEFINES
 /*-----------------------------------------------------------------------------
 STATIC VARIABLES
 ----------------------------------------------------------------------------*/
-DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod);
-DRXStatus_t DRXJ_Close(pDRXDemodInstance_t demod);
-DRXStatus_t DRXJ_Ctrl(pDRXDemodInstance_t demod,
-		      DRXCtrlIndex_t ctrl, void *ctrlData);
+int DRXJ_Open(pDRXDemodInstance_t demod);
+int DRXJ_Close(pDRXDemodInstance_t demod);
+int DRXJ_Ctrl(pDRXDemodInstance_t demod,
+		      u32 ctrl, void *ctrlData);
 
 /*-----------------------------------------------------------------------------
 GLOBAL VARIABLES
@@ -598,52 +598,52 @@ GLOBAL VARIABLES
  * DRXJ DAP structures
  */
 
-static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u16 datasize,
 				      u8 *data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 						DRXaddr_t waddr,
 						DRXaddr_t raddr,
 						u8 wdata, u8 *rdata);
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u16 wdata, u16 *rdata);
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u32 wdata, u32 *rdata);
 
-static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
 				     u8 *data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u16 *data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u32 *data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16 datasize,
 				       u8 *data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u8 data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16 data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u32 data, DRXflags_t flags);
 
@@ -1145,33 +1145,33 @@ typedef struct {
 FUNCTIONS
 ----------------------------------------------------------------------------*/
 /* Some prototypes */
-static DRXStatus_t
+static int
 HICommand(struct i2c_device_addr *devAddr,
 	  const pDRXJHiCmd_t cmd, u16 *result);
 
-static DRXStatus_t
+static int
 CtrlLockStatus(pDRXDemodInstance_t demod, pDRXLockStatus_t lockStat);
 
-static DRXStatus_t
+static int
 CtrlPowerMode(pDRXDemodInstance_t demod, pDRXPowerMode_t mode);
 
-static DRXStatus_t PowerDownAud(pDRXDemodInstance_t demod);
+static int PowerDownAud(pDRXDemodInstance_t demod);
 
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, bool setStandard);
+static int PowerUpAud(pDRXDemodInstance_t demod, bool setStandard);
 #endif
 
-static DRXStatus_t
+static int
 AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard);
 
-static DRXStatus_t
+static int
 CtrlSetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw);
 
-static DRXStatus_t
+static int
 CtrlSetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain);
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
-static DRXStatus_t
+static int
 CtrlUCodeUpload(pDRXDemodInstance_t demod,
 		pDRXUCodeInfo_t mcInfo,
 		DRXUCodeAction_t action, bool audioMCUpload);
@@ -1712,7 +1712,7 @@ bool IsHandledByAudTrIf(DRXaddr_t addr)
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u16 datasize,
 				      u8 *data, DRXflags_t flags)
@@ -1723,7 +1723,7 @@ static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 						DRXaddr_t waddr,
 						DRXaddr_t raddr,
 						u8 wdata, u8 *rdata)
@@ -1736,14 +1736,14 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t DRXJ_DAP_RMWriteReg16Short
+* \fn int DRXJ_DAP_RMWriteReg16Short
 * \brief Read modify write 16 bits audio register using short format only.
 * \param devAddr
 * \param waddr    Address to write to
 * \param raddr    Address to read from (usually SIO_HI_RA_RAM_S0_RMWBUF__A)
 * \param wdata    Data to write
 * \param rdata    Buffer for data to read
-* \return DRXStatus_t
+* \return int
 * \retval DRX_STS_OK Succes
 * \retval DRX_STS_ERROR Timeout, I2C error, illegal bank
 *
@@ -1756,12 +1756,12 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 /* TODO correct define should be #if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
    See comments DRXJ_DAP_ReadModifyWriteReg16 */
 #if ( DRXDAPFASI_LONG_ADDR_ALLOWED == 0 )
-static DRXStatus_t DRXJ_DAP_RMWriteReg16Short(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_RMWriteReg16Short(struct i2c_device_addr *devAddr,
 					      DRXaddr_t waddr,
 					      DRXaddr_t raddr,
 					      u16 wdata, u16 *rdata)
 {
-	DRXStatus_t rc;
+	int rc;
 
 	if (rdata == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -1795,7 +1795,7 @@ static DRXStatus_t DRXJ_DAP_RMWriteReg16Short(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u16 wdata, u16 *rdata)
@@ -1814,7 +1814,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u32 wdata, u32 *rdata)
@@ -1826,7 +1826,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
 				     u8 *data, DRXflags_t flags)
 {
@@ -1836,26 +1836,26 @@ static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t DRXJ_DAP_ReadAudReg16
+* \fn int DRXJ_DAP_ReadAudReg16
 * \brief Read 16 bits audio register
 * \param devAddr
 * \param addr
 * \param data
-* \return DRXStatus_t
+* \return int
 * \retval DRX_STS_OK Succes
 * \retval DRX_STS_ERROR Timeout, I2C error, illegal bank
 *
 * 16 bits register read access via audio token ring interface.
 *
 */
-static DRXStatus_t DRXJ_DAP_ReadAudReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadAudReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr, u16 *data)
 {
 	u32 startTimer = 0;
 	u32 currentTimer = 0;
 	u32 deltaTimer = 0;
 	u16 trStatus = 0;
-	DRXStatus_t stat = DRX_STS_ERROR;
+	int stat = DRX_STS_ERROR;
 
 	/* No read possible for bank 3, return with error */
 	if (DRXDAP_FASI_ADDR2BANK(addr) == 3) {
@@ -1928,11 +1928,11 @@ static DRXStatus_t DRXJ_DAP_ReadAudReg16(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u16 *data, DRXflags_t flags)
 {
-	DRXStatus_t stat = DRX_STS_ERROR;
+	int stat = DRX_STS_ERROR;
 
 	/* Check param */
 	if ((devAddr == NULL) || (data == NULL)) {
@@ -1951,7 +1951,7 @@ static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u32 *data, DRXflags_t flags)
 {
@@ -1960,7 +1960,7 @@ static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16 datasize,
 				       u8 *data, DRXflags_t flags)
@@ -1971,7 +1971,7 @@ static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u8 data, DRXflags_t flags)
 {
@@ -1981,22 +1981,22 @@ static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t DRXJ_DAP_WriteAudReg16
+* \fn int DRXJ_DAP_WriteAudReg16
 * \brief Write 16 bits audio register
 * \param devAddr
 * \param addr
 * \param data
-* \return DRXStatus_t
+* \return int
 * \retval DRX_STS_OK Succes
 * \retval DRX_STS_ERROR Timeout, I2C error, illegal bank
 *
 * 16 bits register write access via audio token ring interface.
 *
 */
-static DRXStatus_t DRXJ_DAP_WriteAudReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteAudReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr, u16 data)
 {
-	DRXStatus_t stat = DRX_STS_ERROR;
+	int stat = DRX_STS_ERROR;
 
 	/* No write possible for bank 2, return with error */
 	if (DRXDAP_FASI_ADDR2BANK(addr) == 2) {
@@ -2040,11 +2040,11 @@ static DRXStatus_t DRXJ_DAP_WriteAudReg16(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16 data, DRXflags_t flags)
 {
-	DRXStatus_t stat = DRX_STS_ERROR;
+	int stat = DRX_STS_ERROR;
 
 	/* Check param */
 	if (devAddr == NULL) {
@@ -2063,7 +2063,7 @@ static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
+static int DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u32 data, DRXflags_t flags)
 {
@@ -2082,19 +2082,19 @@ static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 #define DRXJ_HI_ATOMIC_WRITE     SIO_HI_RA_RAM_PAR_3_ACP_RW_WRITE
 
 /**
-* \fn DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock()
+* \fn int DRXJ_DAP_AtomicReadWriteBlock()
 * \brief Basic access routine for atomic read or write access
 * \param devAddr  pointer to i2c dev address
 * \param addr     destination/source address
 * \param datasize size of data buffer in bytes
 * \param data     pointer to data buffer
-* \return DRXStatus_t
+* \return int
 * \retval DRX_STS_OK Succes
 * \retval DRX_STS_ERROR Timeout, I2C error, illegal bank
 *
 */
 static
-DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
+int DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16 datasize,
 					  u8 *data, bool readFlag)
@@ -2164,16 +2164,16 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t DRXJ_DAP_AtomicReadReg32()
+* \fn int DRXJ_DAP_AtomicReadReg32()
 * \brief Atomic read of 32 bits words
 */
 static
-DRXStatus_t DRXJ_DAP_AtomicReadReg32(struct i2c_device_addr *devAddr,
+int DRXJ_DAP_AtomicReadReg32(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
 				     u32 *data, DRXflags_t flags)
 {
 	u8 buf[sizeof(*data)];
-	DRXStatus_t rc = DRX_STS_ERROR;
+	int rc = DRX_STS_ERROR;
 	u32 word = 0;
 
 	if (!data) {
@@ -2209,17 +2209,17 @@ DRXStatus_t DRXJ_DAP_AtomicReadReg32(struct i2c_device_addr *devAddr,
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t HICfgCommand()
+* \fn int HICfgCommand()
 * \brief Configure HI with settings stored in the demod structure.
 * \param demod Demodulator.
-* \return DRXStatus_t.
+* \return int.
 *
 * This routine was created because to much orthogonal settings have
 * been put into one HI API function (configure). Especially the I2C bridge
 * enable/disable should not need re-configuration of the HI.
 *
 */
-static DRXStatus_t HICfgCommand(const pDRXDemodInstance_t demod)
+static int HICfgCommand(const pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	DRXJHiCmd_t hiCmd;
@@ -2247,17 +2247,17 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t HICommand()
+* \fn int HICommand()
 * \brief Configure HI with settings stored in the demod structure.
 * \param devAddr I2C address.
 * \param cmd HI command.
 * \param result HI command result.
-* \return DRXStatus_t.
+* \return int.
 *
 * Sends command to HI
 *
 */
-static DRXStatus_t
+static int
 HICommand(struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, u16 *result)
 {
 	u16 waitCmd = 0;
@@ -2322,10 +2322,10 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t InitHI( const pDRXDemodInstance_t demod )
+* \fn int InitHI( const pDRXDemodInstance_t demod )
 * \brief Initialise and configurate HI.
 * \param demod pointer to demod data.
-* \return DRXStatus_t Return status.
+* \return int Return status.
 * \retval DRX_STS_OK Success.
 * \retval DRX_STS_ERROR Failure.
 *
@@ -2334,7 +2334,7 @@ rw_error:
 * bridging is controlled.
 *
 */
-static DRXStatus_t InitHI(const pDRXDemodInstance_t demod)
+static int InitHI(const pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
@@ -2396,10 +2396,10 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t GetDeviceCapabilities()
+* \fn int GetDeviceCapabilities()
 * \brief Get and store device capabilities.
 * \param demod  Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 * \return DRX_STS_OK    Success
 * \retval DRX_STS_ERROR Failure
 *
@@ -2411,7 +2411,7 @@ rw_error:
 *  * extAttr->hasOOB
 *
 */
-static DRXStatus_t GetDeviceCapabilities(pDRXDemodInstance_t demod)
+static int GetDeviceCapabilities(pDRXDemodInstance_t demod)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
@@ -2573,10 +2573,10 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t PowerUpDevice()
+* \fn int PowerUpDevice()
 * \brief Power up device.
 * \param demod  Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 * \return DRX_STS_OK    Success
 * \retval DRX_STS_ERROR Failure, I2C or max retries reached
 *
@@ -2586,7 +2586,7 @@ rw_error:
 #define DRXJ_MAX_RETRIES_POWERUP 10
 #endif
 
-static DRXStatus_t PowerUpDevice(pDRXDemodInstance_t demod)
+static int PowerUpDevice(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	u8 data = 0;
@@ -2626,16 +2626,16 @@ static DRXStatus_t PowerUpDevice(pDRXDemodInstance_t demod)
 /* MPEG Output Configuration Functions - begin                                */
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t CtrlSetCfgMPEGOutput()
+* \fn int CtrlSetCfgMPEGOutput()
 * \brief Set MPEG output configuration of the device.
 * \param devmod  Pointer to demodulator instance.
 * \param cfgData Pointer to mpeg output configuaration.
-* \return DRXStatus_t.
+* \return int.
 *
 *  Configure MPEG output parameters.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
@@ -3028,16 +3028,16 @@ rw_error:
 /*----------------------------------------------------------------------------*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgMPEGOutput()
+* \fn int CtrlGetCfgMPEGOutput()
 * \brief Get MPEG output configuration of the device.
 * \param devmod  Pointer to demodulator instance.
 * \param cfgData Pointer to MPEG output configuaration struct.
-* \return DRXStatus_t.
+* \return int.
 *
 *  Retrieve MPEG output configuartion.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
@@ -3087,15 +3087,15 @@ rw_error:
 /*----------------------------------------------------------------------------*/
 
 /**
-* \fn DRXStatus_t SetMPEGTEIHandling()
+* \fn int SetMPEGTEIHandling()
 * \brief Activate MPEG TEI handling settings.
 * \param devmod  Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 *
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static DRXStatus_t SetMPEGTEIHandling(pDRXDemodInstance_t demod)
+static int SetMPEGTEIHandling(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
@@ -3135,15 +3135,15 @@ rw_error:
 
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t BitReverseMPEGOutput()
+* \fn int BitReverseMPEGOutput()
 * \brief Set MPEG output bit-endian settings.
 * \param devmod  Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 *
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static DRXStatus_t BitReverseMPEGOutput(pDRXDemodInstance_t demod)
+static int BitReverseMPEGOutput(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
@@ -3171,15 +3171,15 @@ rw_error:
 
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t SetMPEGOutputClockRate()
+* \fn int SetMPEGOutputClockRate()
 * \brief Set MPEG output clock rate.
 * \param devmod  Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 *
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static DRXStatus_t SetMPEGOutputClockRate(pDRXDemodInstance_t demod)
+static int SetMPEGOutputClockRate(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
@@ -3199,15 +3199,15 @@ rw_error:
 
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t SetMPEGStartWidth()
+* \fn int SetMPEGStartWidth()
 * \brief Set MPEG start width.
 * \param devmod  Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 *
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static DRXStatus_t SetMPEGStartWidth(pDRXDemodInstance_t demod)
+static int SetMPEGStartWidth(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
@@ -3235,17 +3235,17 @@ rw_error:
 
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t CtrlSetCfgMpegOutputMisc()
+* \fn int CtrlSetCfgMpegOutputMisc()
 * \brief Set miscellaneous configuartions
 * \param devmod  Pointer to demodulator instance.
 * \param cfgData pDRXJCfgMisc_t
-* \return DRXStatus_t.
+* \return int.
 *
 *  This routine can be used to set configuartion options that are DRXJ
 *  specific and/or added to the requirements at a late stage.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgMpegOutputMisc(pDRXDemodInstance_t demod,
 			 pDRXJCfgMpegOutputMisc_t cfgData)
 {
@@ -3284,18 +3284,18 @@ rw_error:
 /*----------------------------------------------------------------------------*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgMpegOutputMisc()
+* \fn int CtrlGetCfgMpegOutputMisc()
 * \brief Get miscellaneous configuartions.
 * \param devmod  Pointer to demodulator instance.
 * \param cfgData Pointer to DRXJCfgMisc_t.
-* \return DRXStatus_t.
+* \return int.
 *
 *  This routine can be used to retreive the current setting of the configuartion
 *  options that are DRXJ specific and/or added to the requirements at a
 *  late stage.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgMpegOutputMisc(pDRXDemodInstance_t demod,
 			 pDRXJCfgMpegOutputMisc_t cfgData)
 {
@@ -3326,18 +3326,18 @@ rw_error:
 /*----------------------------------------------------------------------------*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgHwCfg()
+* \fn int CtrlGetCfgHwCfg()
 * \brief Get HW configuartions.
 * \param devmod  Pointer to demodulator instance.
 * \param cfgData Pointer to Bool.
-* \return DRXStatus_t.
+* \return int.
 *
 *  This routine can be used to retreive the current setting of the configuartion
 *  options that are DRXJ specific and/or added to the requirements at a
 *  late stage.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgHwCfg(pDRXDemodInstance_t demod, pDRXJCfgHwCfg_t cfgData)
 {
 	u16 data = 0;
@@ -3368,13 +3368,13 @@ rw_error:
 /* UIO Configuration Functions - begin                                        */
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t CtrlSetUIOCfg()
+* \fn int CtrlSetUIOCfg()
 * \brief Configure modus oprandi UIO.
 * \param demod Pointer to demodulator instance.
 * \param UIOCfg Pointer to a configuration setting for a certain UIO.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t CtrlSetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
+static int CtrlSetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 
@@ -3481,13 +3481,13 @@ rw_error:
 
 /*============================================================================*/
 /**
-* \fn DRXStatus_t CtrlGetUIOCfg()
+* \fn int CtrlGetUIOCfg()
 * \brief Get modus oprandi UIO.
 * \param demod Pointer to demodulator instance.
 * \param UIOCfg Pointer to a configuration setting for a certain UIO.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t CtrlGetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
+static int CtrlGetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
 {
 
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
@@ -3524,13 +3524,13 @@ static DRXStatus_t CtrlGetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
 }
 
 /**
-* \fn DRXStatus_t CtrlUIOWrite()
+* \fn int CtrlUIOWrite()
 * \brief Write to a UIO.
 * \param demod Pointer to demodulator instance.
 * \param UIOData Pointer to data container for a certain UIO.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
@@ -3670,13 +3670,13 @@ rw_error:
 }
 
 /**
-*\fn DRXStatus_t CtrlUIORead
+*\fn int CtrlUIORead
 *\brief Read from a UIO.
 * \param demod Pointer to demodulator instance.
 * \param UIOData Pointer to data container for a certain UIO.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
+static int CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	u16 pinCfgValue = 0;
@@ -3815,14 +3815,14 @@ rw_error:
 /* I2C Bridge Functions - begin                                               */
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t CtrlI2CBridge()
+* \fn int CtrlI2CBridge()
 * \brief Open or close the I2C switch to tuner.
 * \param demod Pointer to demodulator instance.
 * \param bridgeClosed Pointer to bool indication if bridge is closed not.
-* \return DRXStatus_t.
+* \return int.
 
 */
-static DRXStatus_t
+static int
 CtrlI2CBridge(pDRXDemodInstance_t demod, bool * bridgeClosed)
 {
 	DRXJHiCmd_t hiCmd;
@@ -3852,13 +3852,13 @@ CtrlI2CBridge(pDRXDemodInstance_t demod, bool * bridgeClosed)
 /* Smart antenna Functions - begin                                            */
 /*----------------------------------------------------------------------------*/
 /**
-* \fn DRXStatus_t SmartAntInit()
+* \fn int SmartAntInit()
 * \brief Initialize Smart Antenna.
 * \param pointer to DRXDemodInstance_t.
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t SmartAntInit(pDRXDemodInstance_t demod)
+static int SmartAntInit(pDRXDemodInstance_t demod)
 {
 	u16 data = 0;
 	pDRXJData_t extAttr = NULL;
@@ -3895,13 +3895,13 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t CtrlSetCfgSmartAnt()
+* \fn int CtrlSetCfgSmartAnt()
 * \brief Set Smart Antenna.
 * \param pointer to DRXJCfgSmartAnt_t.
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgSmartAnt(pDRXDemodInstance_t demod, pDRXJCfgSmartAnt_t smartAnt)
 {
 	pDRXJData_t extAttr = NULL;
@@ -3989,7 +3989,7 @@ rw_error:
 	return (DRX_STS_ERROR);
 }
 
-static DRXStatus_t SCUCommand(struct i2c_device_addr *devAddr, pDRXJSCUCmd_t cmd)
+static int SCUCommand(struct i2c_device_addr *devAddr, pDRXJSCUCmd_t cmd)
 {
 	u16 curCmd = 0;
 	u32 startTime = 0;
@@ -4082,20 +4082,20 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t DRXJ_DAP_SCUAtomicReadWriteBlock()
+* \fn int DRXJ_DAP_SCUAtomicReadWriteBlock()
 * \brief Basic access routine for SCU atomic read or write access
 * \param devAddr  pointer to i2c dev address
 * \param addr     destination/source address
 * \param datasize size of data buffer in bytes
 * \param data     pointer to data buffer
-* \return DRXStatus_t
+* \return int
 * \retval DRX_STS_OK Succes
 * \retval DRX_STS_ERROR Timeout, I2C error, illegal bank
 *
 */
 #define ADDR_AT_SCU_SPACE(x) ((x - 0x82E000) * 2)
 static
-DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, DRXaddr_t addr, u16 datasize,	/* max 30 bytes because the limit of SCU parameter */
+int DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, DRXaddr_t addr, u16 datasize,	/* max 30 bytes because the limit of SCU parameter */
 					      u8 *data, bool readFlag)
 {
 	DRXJSCUCmd_t scuCmd;
@@ -4152,16 +4152,16 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t DRXJ_DAP_AtomicReadReg16()
+* \fn int DRXJ_DAP_AtomicReadReg16()
 * \brief Atomic read of 16 bits words
 */
 static
-DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
+int DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 u16 *data, DRXflags_t flags)
 {
 	u8 buf[2];
-	DRXStatus_t rc = DRX_STS_ERROR;
+	int rc = DRX_STS_ERROR;
 	u16 word = 0;
 
 	if (!data) {
@@ -4179,16 +4179,16 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
 
 /*============================================================================*/
 /**
-* \fn DRXStatus_t DRXJ_DAP_SCU_AtomicWriteReg16()
+* \fn int DRXJ_DAP_SCU_AtomicWriteReg16()
 * \brief Atomic read of 16 bits words
 */
 static
-DRXStatus_t DRXJ_DAP_SCU_AtomicWriteReg16(struct i2c_device_addr *devAddr,
+int DRXJ_DAP_SCU_AtomicWriteReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16 data, DRXflags_t flags)
 {
 	u8 buf[2];
-	DRXStatus_t rc = DRX_STS_ERROR;
+	int rc = DRX_STS_ERROR;
 
 	buf[0] = (u8) (data & 0xff);
 	buf[1] = (u8) ((data >> 8) & 0xff);
@@ -4198,14 +4198,14 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicWriteReg16(struct i2c_device_addr *devAddr,
 	return rc;
 }
 
-static DRXStatus_t
+static int
 CtrlI2CWriteRead(pDRXDemodInstance_t demod, pDRXI2CData_t i2cData)
 {
 	return (DRX_STS_FUNC_NOT_AVAILABLE);
 }
 
-DRXStatus_t
-TunerI2CWriteRead(pTUNERInstance_t tuner,
+int
+TunerI2CWriteRead(struct tuner_instance *tuner,
 		  struct i2c_device_addr *wDevAddr,
 		  u16 wCount,
 		  u8 *wData,
@@ -4225,12 +4225,12 @@ TunerI2CWriteRead(pTUNERInstance_t tuner,
 * \brief Measure result of ADC synchronisation
 * \param demod demod instance
 * \param count (returned) count
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK    Success
 * \retval DRX_STS_ERROR Failure: I2C error
 *
 */
-static DRXStatus_t ADCSyncMeasurement(pDRXDemodInstance_t demod, u16 *count)
+static int ADCSyncMeasurement(pDRXDemodInstance_t demod, u16 *count)
 {
 	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -4266,7 +4266,7 @@ rw_error:
 /**
 * \brief Synchronize analog and digital clock domains
 * \param demod demod instance
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK    Success
 * \retval DRX_STS_ERROR Failure: I2C error or failure to synchronize
 *
@@ -4275,7 +4275,7 @@ rw_error:
 *
 */
 
-static DRXStatus_t ADCSynchronization(pDRXDemodInstance_t demod)
+static int ADCSynchronization(pDRXDemodInstance_t demod)
 {
 	u16 count = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -4310,9 +4310,9 @@ rw_error:
 * \brief Configure IQM AF registers
 * \param demod instance of demodulator.
 * \param active
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t IQMSetAf(pDRXDemodInstance_t demod, bool active)
+static int IQMSetAf(pDRXDemodInstance_t demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -4346,16 +4346,16 @@ rw_error:
 }
 
 /* -------------------------------------------------------------------------- */
-static DRXStatus_t
+static int
 CtrlSetCfgATVOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg);
 
 /**
 * \brief set configuration of pin-safe mode
 * \param demod instance of demodulator.
 * \param enable boolean; true: activate pin-safe mode, false: de-activate p.s.m.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool * enable)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
@@ -4479,9 +4479,9 @@ rw_error:
 * \brief get configuration of pin-safe mode
 * \param demod instance of demodulator.
 * \param enable boolean indicating whether pin-safe mode is active
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlGetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool * enabled)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
@@ -4499,9 +4499,9 @@ CtrlGetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool * enabled)
 /**
 * \brief Verifies whether microcode can be loaded.
 * \param demod Demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t CtrlValidateUCode(pDRXDemodInstance_t demod)
+static int CtrlValidateUCode(pDRXDemodInstance_t demod)
 {
 	u32 mcDev, mcPatch;
 	u16 verType;
@@ -4543,13 +4543,13 @@ static DRXStatus_t CtrlValidateUCode(pDRXDemodInstance_t demod)
 /*============================================================================*/
 /*============================================================================*/
 /**
-* \fn DRXStatus_t InitAGC ()
+* \fn int InitAGC ()
 * \brief Initialize AGC for all standards.
 * \param demod instance of demodulator.
 * \param channel pointer to channel data.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
+static int InitAGC(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
@@ -4749,14 +4749,14 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t SetFrequency ()
+* \fn int SetFrequency ()
 * \brief Set frequency shift.
 * \param demod instance of demodulator.
 * \param channel pointer to channel data.
 * \param tunerFreqOffset residual frequency from tuner.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 SetFrequency(pDRXDemodInstance_t demod,
 	     pDRXChannel_t channel, s32 tunerFreqOffset)
 {
@@ -4851,11 +4851,11 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetSigStrength()
+* \fn int GetSigStrength()
 * \brief Retrieve signal strength for VSB and QAM.
 * \param demod Pointer to demod instance
 * \param u16-t Pointer to signal strength data; range 0, .. , 100.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK sigStrength contains valid data.
 * \retval DRX_STS_INVALID_ARG sigStrength is NULL.
 * \retval DRX_STS_ERROR Erroneous data, sigStrength contains invalid data.
@@ -4865,7 +4865,7 @@ rw_error:
 #define DRXJ_RFAGC_MAX  0x3fff
 #define DRXJ_RFAGC_MIN  0x800
 
-static DRXStatus_t GetSigStrength(pDRXDemodInstance_t demod, u16 *sigStrength)
+static int GetSigStrength(pDRXDemodInstance_t demod, u16 *sigStrength)
 {
 	u16 rfGain = 0;
 	u16 ifGain = 0;
@@ -4914,17 +4914,17 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetAccPktErr()
+* \fn int GetAccPktErr()
 * \brief Retrieve signal strength for VSB and QAM.
 * \param demod Pointer to demod instance
 * \param packetErr Pointer to packet error
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK sigStrength contains valid data.
 * \retval DRX_STS_INVALID_ARG sigStrength is NULL.
 * \retval DRX_STS_ERROR Erroneous data, sigStrength contains invalid data.
 */
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
-static DRXStatus_t GetAccPktErr(pDRXDemodInstance_t demod, u16 *packetErr)
+static int GetAccPktErr(pDRXDemodInstance_t demod, u16 *packetErr)
 {
 	static u16 pktErr = 0;
 	static u16 lastPktErr = 0;
@@ -4958,14 +4958,14 @@ rw_error:
 #endif
 
 /**
-* \fn DRXStatus_t ResetAccPktErr()
+* \fn int ResetAccPktErr()
 * \brief Reset Accumulating packet error count.
 * \param demod Pointer to demod instance
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK.
 * \retval DRX_STS_ERROR Erroneous data.
 */
-static DRXStatus_t CtrlSetCfgResetPktErr(pDRXDemodInstance_t demod)
+static int CtrlSetCfgResetPktErr(pDRXDemodInstance_t demod)
 {
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
 	pDRXJData_t extAttr = NULL;
@@ -4987,12 +4987,12 @@ rw_error:
 * \brief Get symbol rate offset in QAM & 8VSB mode
 * \return Error code
 */
-static DRXStatus_t GetSTRFreqOffset(pDRXDemodInstance_t demod, s32 *STRFreq)
+static int GetSTRFreqOffset(pDRXDemodInstance_t demod, s32 *STRFreq)
 {
 	u32 symbolFrequencyRatio = 0;
 	u32 symbolNomFrequencyRatio = 0;
 
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
@@ -5025,7 +5025,7 @@ rw_error:
 * \brief Get the value of CTLFreq in QAM & ATSC mode
 * \return Error code
 */
-static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32 *CTLFreq)
+static int GetCTLFreqOffset(pDRXDemodInstance_t demod, s32 *CTLFreq)
 {
 	s32 samplingFrequency = 0;
 	s32 currentFrequency = 0;
@@ -5075,13 +5075,13 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t SetAgcRf ()
+* \fn int SetAgcRf ()
 * \brief Configure RF AGC
 * \param demod instance of demodulator.
 * \param agcSettings AGC configuration structure
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 SetAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, bool atomic)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -5253,18 +5253,18 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetAgcRf ()
+* \fn int GetAgcRf ()
 * \brief get configuration of RF AGC
 * \param demod instance of demodulator.
 * \param agcSettings AGC configuration structure
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 GetAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -5314,13 +5314,13 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t SetAgcIf ()
+* \fn int SetAgcIf ()
 * \brief Configure If AGC
 * \param demod instance of demodulator.
 * \param agcSettings AGC configuration structure
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 SetAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, bool atomic)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -5505,18 +5505,18 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetAgcIf ()
+* \fn int GetAgcIf ()
 * \brief get configuration of If AGC
 * \param demod instance of demodulator.
 * \param agcSettings AGC configuration structure
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 GetAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -5567,13 +5567,13 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t SetIqmAf ()
+* \fn int SetIqmAf ()
 * \brief Configure IQM AF registers
 * \param demod instance of demodulator.
 * \param active
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetIqmAf(pDRXDemodInstance_t demod, bool active)
+static int SetIqmAf(pDRXDemodInstance_t demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -5615,13 +5615,13 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t PowerDownVSB ()
+* \fn int PowerDownVSB ()
 * \brief Powr down QAM related blocks.
 * \param demod instance of demodulator.
 * \param channel pointer to channel data.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t PowerDownVSB(pDRXDemodInstance_t demod, bool primary)
+static int PowerDownVSB(pDRXDemodInstance_t demod, bool primary)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command     */ 0,
@@ -5671,12 +5671,12 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t SetVSBLeakNGain ()
+* \fn int SetVSBLeakNGain ()
 * \brief Set ATSC demod.
 * \param demod instance of demodulator.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetVSBLeakNGain(pDRXDemodInstance_t demod)
+static int SetVSBLeakNGain(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
 
@@ -5880,13 +5880,13 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t SetVSB()
+* \fn int SetVSB()
 * \brief Set 8VSB demod.
 * \param demod instance of demodulator.
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
+static int SetVSB(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	u16 cmdResult = 0;
@@ -6105,7 +6105,7 @@ rw_error:
 * \brief Get the values of packet error in 8VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBPostRSPckErr(struct i2c_device_addr *devAddr, u16 *pckErrs)
+static int GetVSBPostRSPckErr(struct i2c_device_addr *devAddr, u16 *pckErrs)
 {
 	u16 data = 0;
 	u16 period = 0;
@@ -6136,7 +6136,7 @@ rw_error:
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBpostViterbiBer(struct i2c_device_addr *devAddr, u32 *ber)
+static int GetVSBpostViterbiBer(struct i2c_device_addr *devAddr, u32 *ber)
 {
 	u16 data = 0;
 	u16 period = 0;
@@ -6174,7 +6174,7 @@ rw_error:
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, u32 *ber)
+static int GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, u32 * ber)
 {
 	u16 data = 0;
 
@@ -6193,7 +6193,7 @@ rw_error:
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBSymbErr(struct i2c_device_addr *devAddr, u32 *ser)
+static int GetVSBSymbErr(struct i2c_device_addr *devAddr, u32 *ser)
 {
 	u16 data = 0;
 	u16 period = 0;
@@ -6219,11 +6219,11 @@ rw_error:
 }
 
 /**
-* \fn static DRXStatus_t GetVSBMER(struct i2c_device_addr * devAddr, u16 *mer)
+* \fn static int GetVSBMER(struct i2c_device_addr *devAddr, u16 *mer)
 * \brief Get the values of MER
 * \return Error code
 */
-static DRXStatus_t GetVSBMER(struct i2c_device_addr *devAddr, u16 *mer)
+static int GetVSBMER(struct i2c_device_addr *devAddr, u16 *mer)
 {
 	u16 dataHi = 0;
 
@@ -6238,14 +6238,14 @@ rw_error:
 
 /*============================================================================*/
 /**
-* \fn DRXStatus_t CtrlGetVSBConstel()
+* \fn int CtrlGetVSBConstel()
 * \brief Retreive a VSB constellation point via I2C.
 * \param demod Pointer to demodulator instance.
 * \param complexNr Pointer to the structure in which to store the
 		   constellation point.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlGetVSBConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -6304,13 +6304,13 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t PowerDownQAM ()
+* \fn int PowerDownQAM ()
 * \brief Powr down QAM related blocks.
 * \param demod instance of demodulator.
 * \param channel pointer to channel data.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t PowerDownQAM(pDRXDemodInstance_t demod, bool primary)
+static int PowerDownQAM(pDRXDemodInstance_t demod, bool primary)
 {
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
 		/* parameterLen */ 0,
@@ -6364,11 +6364,11 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t SetQAMMeasurement ()
+* \fn int SetQAMMeasurement ()
 * \brief Setup of the QAM Measuremnt intervals for signal quality
 * \param demod instance of demod.
 * \param constellation current constellation.
-* \return DRXStatus_t.
+* \return int.
 *
 *  NOTE:
 *  Take into account that for certain settings the errorcounters can overflow.
@@ -6380,9 +6380,9 @@ rw_error:
 *
 */
 #ifndef DRXJ_VSB_ONLY
-static DRXStatus_t
+static int
 SetQAMMeasurement(pDRXDemodInstance_t demod,
-		  DRXConstellation_t constellation, u32 symbolRate)
+		  enum drx_modulation constellation, u32 symbolRate)
 {
 	struct i2c_device_addr *devAddr = NULL;	/* device address for I2C writes */
 	pDRXJData_t extAttr = NULL;	/* Global data container for DRXJ specif data */
@@ -6538,12 +6538,12 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t SetQAM16 ()
+* \fn int SetQAM16 ()
 * \brief QAM16 specific setup
 * \param demod instance of demod.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetQAM16(pDRXDemodInstance_t demod)
+static int SetQAM16(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8 qamDqQualFun[] = {
@@ -6618,12 +6618,12 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t SetQAM32 ()
+* \fn int SetQAM32 ()
 * \brief QAM32 specific setup
 * \param demod instance of demod.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetQAM32(pDRXDemodInstance_t demod)
+static int SetQAM32(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8 qamDqQualFun[] = {
@@ -6698,12 +6698,12 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t SetQAM64 ()
+* \fn int SetQAM64 ()
 * \brief QAM64 specific setup
 * \param demod instance of demod.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetQAM64(pDRXDemodInstance_t demod)
+static int SetQAM64(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8 qamDqQualFun[] = {	/* this is hw reset value. no necessary to re-write */
@@ -6778,12 +6778,12 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t SetQAM128 ()
+* \fn int SetQAM128 ()
 * \brief QAM128 specific setup
 * \param demod: instance of demod.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetQAM128(pDRXDemodInstance_t demod)
+static int SetQAM128(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8 qamDqQualFun[] = {
@@ -6858,12 +6858,12 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t SetQAM256 ()
+* \fn int SetQAM256 ()
 * \brief QAM256 specific setup
 * \param demod: instance of demod.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetQAM256(pDRXDemodInstance_t demod)
+static int SetQAM256(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8 qamDqQualFun[] = {
@@ -6941,13 +6941,13 @@ rw_error:
 #define QAM_SET_OP_SPECTRUM 0X4
 
 /**
-* \fn DRXStatus_t SetQAM ()
+* \fn int SetQAM ()
 * \brief Set QAM demod.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 SetQAM(pDRXDemodInstance_t demod,
        pDRXChannel_t channel, s32 tunerFreqOffset, u32 op)
 {
@@ -7410,9 +7410,9 @@ rw_error:
 }
 
 /*============================================================================*/
-static DRXStatus_t
+static int
 CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality);
-static DRXStatus_t qamFlipSpec(pDRXDemodInstance_t demod, pDRXChannel_t channel)
+static int qamFlipSpec(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 {
 	u32 iqmFsRateOfs = 0;
 	u32 iqmFsRateLo = 0;
@@ -7500,15 +7500,15 @@ rw_error:
 #define  SYNC_FLIPPED   0x2
 #define  SPEC_MIRRORED  0x4
 /**
-* \fn DRXStatus_t QAM64Auto ()
+* \fn int QAM64Auto ()
 * \brief auto do sync pattern switching and mirroring.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
 * \param tunerFreqOffset: tuner frequency offset.
 * \param lockStatus: pointer to lock status.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 QAM64Auto(pDRXDemodInstance_t demod,
 	  pDRXChannel_t channel,
 	  s32 tunerFreqOffset, pDRXLockStatus_t lockStatus)
@@ -7614,15 +7614,15 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t QAM256Auto ()
+* \fn int QAM256Auto ()
 * \brief auto do sync pattern switching and mirroring.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
 * \param tunerFreqOffset: tuner frequency offset.
 * \param lockStatus: pointer to lock status.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 QAM256Auto(pDRXDemodInstance_t demod,
 	   pDRXChannel_t channel,
 	   s32 tunerFreqOffset, pDRXLockStatus_t lockStatus)
@@ -7685,13 +7685,13 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t SetQAMChannel ()
+* \fn int SetQAMChannel ()
 * \brief Set QAM channel according to the requested constellation.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 SetQAMChannel(pDRXDemodInstance_t demod,
 	      pDRXChannel_t channel, s32 tunerFreqOffset)
 {
@@ -7841,7 +7841,7 @@ rw_error:
 * precondition: measurement period & measurement prescale must be set
 *
 */
-static DRXStatus_t
+static int
 GetQAMRSErrCount(struct i2c_device_addr *devAddr, pDRXJRSErrors_t RSErrors)
 {
 	u16 nrBitErrors = 0,
@@ -7884,23 +7884,23 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetQAMSigQuality()
+* \fn int CtrlGetQAMSigQuality()
 * \brief Retreive QAM signal quality from device.
 * \param devmod Pointer to demodulator instance.
 * \param sigQuality Pointer to signal quality data.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK sigQuality contains valid data.
 * \retval DRX_STS_INVALID_ARG sigQuality is NULL.
 * \retval DRX_STS_ERROR Erroneous data, sigQuality contains invalid data.
 
 *  Pre-condition: Device must be started and in lock.
 */
-static DRXStatus_t
+static int
 CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	DRXConstellation_t constellation = DRX_CONSTELLATION_UNKNOWN;
+	enum drx_modulation constellation = DRX_CONSTELLATION_UNKNOWN;
 	DRXJRSErrors_t measuredRSErrors = { 0, 0, 0, 0, 0 };
 
 	u32 preBitErrRS = 0;	/* pre RedSolomon Bit Error Rate */
@@ -8070,14 +8070,14 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t CtrlGetQAMConstel()
+* \fn int CtrlGetQAMConstel()
 * \brief Retreive a QAM constellation point via I2C.
 * \param demod Pointer to demodulator instance.
 * \param complexNr Pointer to the structure in which to store the
 		   constellation point.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlGetQAMConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 {
 	u16 fecOcOcrMode = 0;
@@ -8222,10 +8222,10 @@ rw_error:
 * \brief Get array index for atv coef (extAttr->atvTopCoefX[index])
 * \param standard
 * \param pointer to index
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t AtvEquCoefIndex(DRXStandard_t standard, int *index)
+static int AtvEquCoefIndex(enum drx_standard standard, int *index)
 {
 	switch (standard) {
 	case DRX_STANDARD_PAL_SECAM_BG:
@@ -8260,14 +8260,14 @@ static DRXStatus_t AtvEquCoefIndex(DRXStandard_t standard, int *index)
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t AtvUpdateConfig ()
+* \fn int AtvUpdateConfig ()
 * \brief Flush changes in ATV shadow registers to physical registers.
 * \param demod instance of demodulator
 * \param forceUpdate don't look at standard or change flags, flush all.
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AtvUpdateConfig(pDRXDemodInstance_t demod, bool forceUpdate)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -8368,14 +8368,14 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t CtrlSetCfgATVOutput()
+* \fn int CtrlSetCfgATVOutput()
 * \brief Configure ATV ouputs
 * \param demod instance of demodulator
 * \param outputCfg output configuaration
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgATVOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg)
 {
 	pDRXJData_t extAttr = NULL;
@@ -8425,14 +8425,14 @@ rw_error:
 /* -------------------------------------------------------------------------- */
 #ifndef DRXJ_DIGITAL_ONLY
 /**
-* \fn DRXStatus_t CtrlSetCfgAtvEquCoef()
+* \fn int CtrlSetCfgAtvEquCoef()
 * \brief Set ATV equalizer coefficients
 * \param demod instance of demodulator
 * \param coef  the equalizer coefficients
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgAtvEquCoef(pDRXDemodInstance_t demod, pDRXJCfgAtvEquCoef_t coef)
 {
 	pDRXJData_t extAttr = NULL;
@@ -8474,11 +8474,11 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t CtrlGetCfgAtvEquCoef()
+* \fn int CtrlGetCfgAtvEquCoef()
 * \brief Get ATV equ coef settings
 * \param demod instance of demodulator
 * \param coef The ATV equ coefficients
-* \return DRXStatus_t.
+* \return int.
 *
 * The values are read from the shadow registers maintained by the drxdriver
 * If registers are manipulated outside of the drxdriver scope the reported
@@ -8486,7 +8486,7 @@ rw_error:
 * regitsers.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAtvEquCoef(pDRXDemodInstance_t demod, pDRXJCfgAtvEquCoef_t coef)
 {
 	pDRXJData_t extAttr = NULL;
@@ -8517,14 +8517,14 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t CtrlSetCfgAtvMisc()
+* \fn int CtrlSetCfgAtvMisc()
 * \brief Set misc. settings for ATV.
 * \param demod instance of demodulator
 * \param
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgAtvMisc(pDRXDemodInstance_t demod, pDRXJCfgAtvMisc_t settings)
 {
 	pDRXJData_t extAttr = NULL;
@@ -8558,18 +8558,18 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t  CtrlGetCfgAtvMisc()
+* \fn int  CtrlGetCfgAtvMisc()
 * \brief Get misc settings of ATV.
 * \param demod instance of demodulator
 * \param settings misc. ATV settings
-* \return DRXStatus_t.
+* \return int.
 *
 * The values are read from the shadow registers maintained by the drxdriver
 * If registers are manipulated outside of the drxdriver scope the reported
 * settings will not reflect these changes because of the use of shadow
 * regitsers.
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAtvMisc(pDRXDemodInstance_t demod, pDRXJCfgAtvMisc_t settings)
 {
 	pDRXJData_t extAttr = NULL;
@@ -8591,14 +8591,14 @@ CtrlGetCfgAtvMisc(pDRXDemodInstance_t demod, pDRXJCfgAtvMisc_t settings)
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t  CtrlGetCfgAtvOutput()
+* \fn int  CtrlGetCfgAtvOutput()
 * \brief
 * \param demod instance of demodulator
 * \param outputCfg output configuaration
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAtvOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg)
 {
 	u16 data = 0;
@@ -8630,14 +8630,14 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t  CtrlGetCfgAtvAgcStatus()
+* \fn int  CtrlGetCfgAtvAgcStatus()
 * \brief
 * \param demod instance of demodulator
 * \param agcStatus agc status
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAtvAgcStatus(pDRXDemodInstance_t demod,
 		       pDRXJCfgAtvAgcStatus_t agcStatus)
 {
@@ -8733,16 +8733,16 @@ rw_error:
 /* -------------------------------------------------------------------------- */
 
 /**
-* \fn DRXStatus_t PowerUpATV ()
+* \fn int PowerUpATV ()
 * \brief Power up ATV.
 * \param demod instance of demodulator
 * \param standard either NTSC or FM (sub strandard for ATV )
-* \return DRXStatus_t.
+* \return int.
 *
 * * Starts ATV and IQM
 * * AUdio already started during standard init for ATV.
 */
-static DRXStatus_t PowerUpATV(pDRXDemodInstance_t demod, DRXStandard_t standard)
+static int PowerUpATV(pDRXDemodInstance_t demod, enum drx_standard standard)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -8769,18 +8769,18 @@ rw_error:
 /* -------------------------------------------------------------------------- */
 
 /**
-* \fn DRXStatus_t PowerDownATV ()
+* \fn int PowerDownATV ()
 * \brief Power down ATV.
 * \param demod instance of demodulator
 * \param standard either NTSC or FM (sub strandard for ATV )
-* \return DRXStatus_t.
+* \return int.
 *
 *  Stops and thus resets ATV and IQM block
 *  SIF and CVBS ADC are powered down
 *  Calls audio power down
 */
-static DRXStatus_t
-PowerDownATV(pDRXDemodInstance_t demod, DRXStandard_t standard, bool primary)
+static int
+PowerDownATV(pDRXDemodInstance_t demod, enum drx_standard standard, bool primary)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
@@ -8828,11 +8828,11 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t SetATVStandard ()
+* \fn int SetATVStandard ()
 * \brief Set up ATV demodulator.
 * \param demod instance of demodulator
 * \param standard either NTSC or FM (sub strandard for ATV )
-* \return DRXStatus_t.
+* \return int.
 *
 * Init all channel independent registers.
 * Assuming that IQM, ATV and AUD blocks have been reset and are in STOP mode
@@ -8840,8 +8840,8 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 #define SCU_RAM_ATV_ENABLE_IIR_WA__A 0x831F6D	/* TODO remove after done with reg import */
-static DRXStatus_t
-SetATVStandard(pDRXDemodInstance_t demod, pDRXStandard_t standard)
+static int
+SetATVStandard(pDRXDemodInstance_t demod, enum drx_standard * standard)
 {
 /* TODO: enable alternative for tap settings via external file
 
@@ -9444,10 +9444,10 @@ rw_error:
 
 #ifndef DRXJ_DIGITAL_ONLY
 /**
-* \fn DRXStatus_t SetATVChannel ()
+* \fn int SetATVChannel ()
 * \brief Set ATV channel.
 * \param demod:   instance of demod.
-* \return DRXStatus_t.
+* \return int.
 *
 * Not much needs to be done here, only start the SCU for NTSC/FM.
 * Mirrored channels are not expected in the RF domain, so IQM FS setting
@@ -9455,10 +9455,10 @@ rw_error:
 * The channel->mirror parameter is therefor ignored.
 *
 */
-static DRXStatus_t
+static int
 SetATVChannel(pDRXDemodInstance_t demod,
 	      s32 tunerFreqOffset,
-	      pDRXChannel_t channel, DRXStandard_t standard)
+	      pDRXChannel_t channel, enum drx_standard standard)
 {
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
 		/* parameterLen */ 0,
@@ -9509,12 +9509,12 @@ rw_error:
 /* -------------------------------------------------------------------------- */
 
 /**
-* \fn DRXStatus_t GetATVChannel ()
+* \fn int GetATVChannel ()
 * \brief Set ATV channel.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
 * \param standard: NTSC or FM.
-* \return DRXStatus_t.
+* \return int.
 *
 * Covers NTSC, PAL/SECAM - B/G, D/K, I, L, LP and FM.
 * Computes the frequency offset in te RF domain and adds it to
@@ -9522,9 +9522,9 @@ rw_error:
 *
 */
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t
+static int
 GetATVChannel(pDRXDemodInstance_t demod,
-	      pDRXChannel_t channel, DRXStandard_t standard)
+	      pDRXChannel_t channel, enum drx_standard standard)
 {
 	s32 offset = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -9591,11 +9591,11 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t GetAtvSigStrength()
+* \fn int GetAtvSigStrength()
 * \brief Retrieve signal strength for ATV & FM.
 * \param devmod Pointer to demodulator instance.
 * \param sigQuality Pointer to signal strength data; range 0, .. , 100.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK sigStrength contains valid data.
 * \retval DRX_STS_ERROR Erroneous data, sigStrength equals 0.
 *
@@ -9609,7 +9609,7 @@ rw_error:
 * TODO: ? dynamically adapt weights in case RF and/or IF agc of drxj
 *         is not used ?
 */
-static DRXStatus_t
+static int
 GetAtvSigStrength(pDRXDemodInstance_t demod, u16 *sigStrength)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -9708,17 +9708,17 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 /**
-* \fn DRXStatus_t AtvSigQuality()
+* \fn int AtvSigQuality()
 * \brief Retrieve signal quality indication for ATV.
 * \param devmod Pointer to demodulator instance.
 * \param sigQuality Pointer to signal quality structure.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK sigQuality contains valid data.
 * \retval DRX_STS_ERROR Erroneous data, sigQuality indicator equals 0.
 *
 *
 */
-static DRXStatus_t
+static int
 AtvSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -9774,10 +9774,10 @@ rw_error:
 /*
 * \brief Power up AUD.
 * \param demod instance of demodulator
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, bool setStandard)
+static int PowerUpAud(pDRXDemodInstance_t demod, bool setStandard)
 {
 	DRXAudStandard_t audStandard = DRX_AUD_STANDARD_AUTO;
 	struct i2c_device_addr *devAddr = NULL;
@@ -9803,10 +9803,10 @@ rw_error:
 /**
 * \brief Power up AUD.
 * \param demod instance of demodulator
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t PowerDownAud(pDRXDemodInstance_t demod)
+static int PowerDownAud(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -9828,10 +9828,10 @@ rw_error:
 * \brief Get Modus data from audio RAM
 * \param demod instance of demodulator
 * \param pointer to modus
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t AUDGetModus(pDRXDemodInstance_t demod, u16 *modus)
+static int AUDGetModus(pDRXDemodInstance_t demod, u16 *modus)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -9873,10 +9873,10 @@ rw_error:
 * \brief Get audio RDS dat
 * \param demod instance of demodulator
 * \param pointer to DRXCfgAudRDS_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgRDS(pDRXDemodInstance_t demod, pDRXCfgAudRDS_t status)
 {
 	struct i2c_device_addr *addr = NULL;
@@ -9943,10 +9943,10 @@ rw_error:
 * \brief Get the current audio carrier detection status
 * \param demod instance of demodulator
 * \param pointer to AUDCtrlGetStatus
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCarrierDetectStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 {
 	pDRXJData_t extAttr = NULL;
@@ -10021,10 +10021,10 @@ rw_error:
 * \brief Get the current audio status parameters
 * \param demod instance of demodulator
 * \param pointer to AUDCtrlGetStatus
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 {
 	pDRXJData_t extAttr = NULL;
@@ -10062,10 +10062,10 @@ rw_error:
 * \brief Get the current volume settings
 * \param demod instance of demodulator
 * \param pointer to DRXCfgAudVolume_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -10196,10 +10196,10 @@ rw_error:
 * \brief Set the current volume settings
 * \param demod instance of demodulator
 * \param pointer to DRXCfgAudVolume_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -10331,10 +10331,10 @@ rw_error:
 * \brief Get the I2S settings
 * \param demod instance of demodulator
 * \param pointer to DRXCfgI2SOutput_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -10434,10 +10434,10 @@ rw_error:
 * \brief Set the I2S settings
 * \param demod instance of demodulator
 * \param pointer to DRXCfgI2SOutput_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -10589,10 +10589,10 @@ rw_error:
 *        and Automatic Sound Change (ASC)
 * \param demod instance of demodulator
 * \param pointer to pDRXAudAutoSound_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgAutoSound(pDRXDemodInstance_t demod,
 		       pDRXCfgAudAutoSound_t autoSound)
 {
@@ -10646,10 +10646,10 @@ rw_error:
 *        and Automatic Sound Change (ASC)
 * \param demod instance of demodulator
 * \param pointer to pDRXAudAutoSound_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrSetlCfgAutoSound(pDRXDemodInstance_t demod,
 		       pDRXCfgAudAutoSound_t autoSound)
 {
@@ -10712,10 +10712,10 @@ rw_error:
 * \brief Get the Automatic Standard Select thresholds
 * \param demod instance of demodulator
 * \param pointer to pDRXAudASSThres_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgASSThres(pDRXDemodInstance_t demod, pDRXCfgAudASSThres_t thres)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -10756,10 +10756,10 @@ rw_error:
 * \brief Get the Automatic Standard Select thresholds
 * \param demod instance of demodulator
 * \param pointer to pDRXAudASSThres_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgASSThres(pDRXDemodInstance_t demod, pDRXCfgAudASSThres_t thres)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -10795,10 +10795,10 @@ rw_error:
 * \brief Get Audio Carrier settings
 * \param demod instance of demodulator
 * \param pointer to pDRXAudCarrier_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -10900,10 +10900,10 @@ rw_error:
 * \brief Set Audio Carrier settings
 * \param demod instance of demodulator
 * \param pointer to pDRXAudCarrier_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11000,10 +11000,10 @@ rw_error:
 * \brief Get I2S Source, I2S matrix and FM matrix
 * \param demod instance of demodulator
 * \param pointer to pDRXAudmixer_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11095,10 +11095,10 @@ rw_error:
 * \brief Set I2S Source, I2S matrix and FM matrix
 * \param demod instance of demodulator
 * \param pointer to DRXAudmixer_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11203,10 +11203,10 @@ rw_error:
 * \brief Set AV Sync settings
 * \param demod instance of demodulator
 * \param pointer to DRXICfgAVSync_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11268,10 +11268,10 @@ rw_error:
 * \brief Get AV Sync settings
 * \param demod instance of demodulator
 * \param pointer to DRXICfgAVSync_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11325,10 +11325,10 @@ rw_error:
 * \brief Get deviation mode
 * \param demod instance of demodulator
 * \param pointer to DRXCfgAudDeviation_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11366,10 +11366,10 @@ rw_error:
 * \brief Get deviation mode
 * \param demod instance of demodulator
 * \param pointer to DRXCfgAudDeviation_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11419,10 +11419,10 @@ rw_error:
 * \brief Get Prescaler settings
 * \param demod instance of demodulator
 * \param pointer to DRXCfgAudPrescale_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11494,10 +11494,10 @@ rw_error:
 * \brief Set Prescaler settings
 * \param demod instance of demodulator
 * \param pointer to DRXCfgAudPrescale_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -11577,10 +11577,10 @@ rw_error:
 * \brief Beep
 * \param demod instance of demodulator
 * \param pointer to DRXAudBeep_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t AUDCtrlBeep(pDRXDemodInstance_t demod, pDRXAudBeep_t beep)
+static int AUDCtrlBeep(pDRXDemodInstance_t demod, pDRXAudBeep_t beep)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
@@ -11635,15 +11635,15 @@ rw_error:
 * \brief Set an audio standard
 * \param demod instance of demodulator
 * \param pointer to DRXAudStandard_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	DRXStandard_t currentStandard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard currentStandard = DRX_STANDARD_UNKNOWN;
 
 	u16 wStandard = 0;
 	u16 wModus = 0;
@@ -11813,10 +11813,10 @@ rw_error:
 * \brief Get the current audio standard
 * \param demod instance of demodulator
 * \param pointer to DRXAudStandard_t
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 AUDCtrlGetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -11920,10 +11920,10 @@ rw_error:
 * \brief Retreive lock status in case of FM standard
 * \param demod instance of demodulator
 * \param pointer to lock status
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 FmLockStatus(pDRXDemodInstance_t demod, pDRXLockStatus_t lockStat)
 {
 	DRXAudStatus_t status;
@@ -11949,13 +11949,13 @@ rw_error:
 * \brief retreive signal quality in case of FM standard
 * \param demod instance of demodulator
 * \param pointer to signal quality
-* \return DRXStatus_t.
+* \return int.
 *
 * Only the quality indicator field is will be supplied.
 * This will either be 0% or 100%, nothing in between.
 *
 */
-static DRXStatus_t
+static int
 FmSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
@@ -11986,16 +11986,16 @@ rw_error:
 /*============================================================================*/
 #ifndef DRXJ_DIGITAL_ONLY
 /**
-* \fn DRXStatus_t GetOOBLockStatus ()
+* \fn int GetOOBLockStatus ()
 * \brief Get OOB lock status.
 * \param devAddr I2C address
   \      oobLock OOB lock status.
-* \return DRXStatus_t.
+* \return int.
 *
 * Gets OOB lock status
 *
 */
-static DRXStatus_t
+static int
 GetOOBLockStatus(pDRXDemodInstance_t demod,
 		 struct i2c_device_addr *devAddr, pDRXLockStatus_t oobLock)
 {
@@ -12041,16 +12041,16 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetOOBSymbolRateOffset ()
+* \fn int GetOOBSymbolRateOffset ()
 * \brief Get OOB Symbol rate offset. Unit is [ppm]
 * \param devAddr I2C address
 * \      Symbol Rate Offset OOB parameter.
-* \return DRXStatus_t.
+* \return int.
 *
 * Gets OOB frequency offset
 *
 */
-static DRXStatus_t
+static int
 GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, s32 *SymbolRateOffset)
 {
 /*  offset = -{(timingOffset/2^19)*(symbolRate/12,656250MHz)}*10^6 [ppm]  */
@@ -12122,16 +12122,16 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetOOBFreqOffset ()
+* \fn int GetOOBFreqOffset ()
 * \brief Get OOB lock status.
 * \param devAddr I2C address
 * \      freqOffset OOB frequency offset.
-* \return DRXStatus_t.
+* \return int.
 *
 * Gets OOB frequency offset
 *
 */
-static DRXStatus_t
+static int
 GetOOBFreqOffset(pDRXDemodInstance_t demod, s32 *freqOffset)
 {
 	u16 data = 0;
@@ -12223,16 +12223,16 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetOOBFrequency ()
+* \fn int GetOOBFrequency ()
 * \brief Get OOB frequency (Unit:KHz).
 * \param devAddr I2C address
 * \      frequency OOB frequency parameters.
-* \return DRXStatus_t.
+* \return int.
 *
 * Gets OOB frequency
 *
 */
-static DRXStatus_t
+static int
 GetOOBFrequency(pDRXDemodInstance_t demod, s32 *frequency)
 {
 	u16 data = 0;
@@ -12258,16 +12258,16 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t GetOOBMER ()
+* \fn int GetOOBMER ()
 * \brief Get OOB MER.
 * \param devAddr I2C address
   \      MER OOB parameter in dB.
-* \return DRXStatus_t.
+* \return int.
 *
 * Gets OOB MER. Table for MER is in Programming guide.
 *
 */
-static DRXStatus_t GetOOBMER(struct i2c_device_addr *devAddr, u32 *mer)
+static int GetOOBMER(struct i2c_device_addr *devAddr, u32 *mer)
 {
 	u16 data = 0;
 
@@ -12402,13 +12402,13 @@ rw_error:
 #endif /*#ifndef DRXJ_DIGITAL_ONLY */
 
 /**
-* \fn DRXStatus_t SetOrxNsuAox()
+* \fn int SetOrxNsuAox()
 * \brief Configure OrxNsuAox for OOB
 * \param demod instance of demodulator.
 * \param active
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t SetOrxNsuAox(pDRXDemodInstance_t demod, bool active)
+static int SetOrxNsuAox(pDRXDemodInstance_t demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -12448,12 +12448,12 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t CtrlSetOOB()
+* \fn int CtrlSetOOB()
 * \brief Set OOB channel to be used.
 * \param demod instance of demodulator
 * \param oobParam OOB parameters for channel setting.
 * \frequency should be in KHz
-* \return DRXStatus_t.
+* \return int.
 *
 * Accepts  only. Returns error otherwise.
 * Demapper value is written after SCUCommand START
@@ -12471,7 +12471,7 @@ rw_error:
 /* Coefficients for the nyquist fitler (total: 27 taps) */
 #define NYQFILTERLEN 27
 
-static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
+static int CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 {
 #ifndef DRXJ_DIGITAL_ONLY
 	DRXOOBDownstreamStandard_t standard = DRX_OOB_MODE_A;
@@ -12740,13 +12740,13 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t CtrlGetOOB()
+* \fn int CtrlGetOOB()
 * \brief Set modulation standard to be used.
 * \param demod instance of demodulator
 * \param oobStatus OOB status parameters.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlGetOOB(pDRXDemodInstance_t demod, pDRXOOBStatus_t oobStatus)
 {
 #ifndef DRXJ_DIGITAL_ONLY
@@ -12784,13 +12784,13 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t CtrlSetCfgOOBPreSAW()
+* \fn int CtrlSetCfgOOBPreSAW()
 * \brief Configure PreSAW treshold value
 * \param cfgData Pointer to configuration parameter
 * \return Error code
 */
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t
+static int
 CtrlSetCfgOOBPreSAW(pDRXDemodInstance_t demod, u16 *cfgData)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -12811,13 +12811,13 @@ rw_error:
 #endif
 
 /**
-* \fn DRXStatus_t CtrlGetCfgOOBPreSAW()
+* \fn int CtrlGetCfgOOBPreSAW()
 * \brief Configure PreSAW treshold value
 * \param cfgData Pointer to configuration parameter
 * \return Error code
 */
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t
+static int
 CtrlGetCfgOOBPreSAW(pDRXDemodInstance_t demod, u16 *cfgData)
 {
 	pDRXJData_t extAttr = NULL;
@@ -12834,13 +12834,13 @@ CtrlGetCfgOOBPreSAW(pDRXDemodInstance_t demod, u16 *cfgData)
 #endif
 
 /**
-* \fn DRXStatus_t CtrlSetCfgOOBLoPower()
+* \fn int CtrlSetCfgOOBLoPower()
 * \brief Configure LO Power value
 * \param cfgData Pointer to pDRXJCfgOobLoPower_t
 * \return Error code
 */
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t
+static int
 CtrlSetCfgOOBLoPower(pDRXDemodInstance_t demod, pDRXJCfgOobLoPower_t cfgData)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -12861,13 +12861,13 @@ rw_error:
 #endif
 
 /**
-* \fn DRXStatus_t CtrlGetCfgOOBLoPower()
+* \fn int CtrlGetCfgOOBLoPower()
 * \brief Configure LO Power value
 * \param cfgData Pointer to pDRXJCfgOobLoPower_t
 * \return Error code
 */
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t
+static int
 CtrlGetCfgOOBLoPower(pDRXDemodInstance_t demod, pDRXJCfgOobLoPower_t cfgData)
 {
 	pDRXJData_t extAttr = NULL;
@@ -12894,17 +12894,17 @@ CtrlGetCfgOOBLoPower(pDRXDemodInstance_t demod, pDRXJCfgOobLoPower_t cfgData)
   ===== CtrlSetChannel() ==========================================================
   ===========================================================================*/
 /**
-* \fn DRXStatus_t CtrlSetChannel()
+* \fn int CtrlSetChannel()
 * \brief Select a new transmission channel.
 * \param demod instance of demod.
 * \param channel Pointer to channel data.
-* \return DRXStatus_t.
+* \return int.
 *
 * In case the tuner module is not used and in case of NTSC/FM the pogrammer
 * must tune the tuner to the centre frequency of the NTSC/FM channel.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 {
 
@@ -12914,8 +12914,8 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	s32 intermediateFreq = 0;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
-	TUNERMode_t tunerMode = 0;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
+	u32 tunerMode = 0;
 	pDRXCommonAttr_t commonAttr = NULL;
 	bool bridgeClosed = false;
 #ifndef DRXJ_VSB_ONLY
@@ -13280,19 +13280,19 @@ rw_error:
   ===== CtrlGetChannel() ==========================================================
   ===========================================================================*/
 /**
-* \fn DRXStatus_t CtrlGetChannel()
+* \fn int CtrlGetChannel()
 * \brief Retreive parameters of current transmission channel.
 * \param demod   Pointer to demod instance.
 * \param channel Pointer to channel data.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	pDRXCommonAttr_t commonAttr = NULL;
 	s32 intermediateFreq = 0;
 	s32 CTLFreqOffset = 0;
@@ -13436,7 +13436,7 @@ CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 					CHK_ERROR(SCUCommand(devAddr, &cmdSCU));
 
 					channel->interleavemode =
-					    (DRXInterleaveModes_t) (cmdSCU.
+					    (enum drx_interleave_mode) (cmdSCU.
 								    result[2]);
 				}
 
@@ -13527,22 +13527,22 @@ mer2indicator(u16 mer, u16 minMer, u16 thresholdMer, u16 maxMer)
 }
 
 /**
-* \fn DRXStatus_t CtrlSigQuality()
+* \fn int CtrlSigQuality()
 * \brief Retreive signal quality form device.
 * \param devmod Pointer to demodulator instance.
 * \param sigQuality Pointer to signal quality data.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK sigQuality contains valid data.
 * \retval DRX_STS_INVALID_ARG sigQuality is NULL.
 * \retval DRX_STS_ERROR Erroneous data, sigQuality contains invalid data.
 
 */
-static DRXStatus_t
+static int
 CtrlSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
 	u16 minMer = 0;
 	u16 maxMer = 0;
@@ -13664,17 +13664,17 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlLockStatus()
+* \fn int CtrlLockStatus()
 * \brief Retreive lock status .
 * \param devAddr Pointer to demodulator device address.
 * \param lockStat Pointer to lock status structure.
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlLockStatus(pDRXDemodInstance_t demod, pDRXLockStatus_t lockStat)
 {
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
@@ -13761,17 +13761,17 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlConstel()
+* \fn int CtrlConstel()
 * \brief Retreive a constellation point via I2C.
 * \param demod Pointer to demodulator instance.
 * \param complexNr Pointer to the structure in which to store the
 		   constellation point.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 {
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 						     /**< active standard */
 
 	/* check arguments */
@@ -13807,20 +13807,20 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlSetStandard()
+* \fn int CtrlSetStandard()
 * \brief Set modulation standard to be used.
 * \param standard Modulation standard.
-* \return DRXStatus_t.
+* \return int.
 *
 * Setup stuff for the desired demodulation standard.
 * Disable and power down the previous selected demodulation standard
 *
 */
-static DRXStatus_t
-CtrlSetStandard(pDRXDemodInstance_t demod, pDRXStandard_t standard)
+static int
+CtrlSetStandard(pDRXDemodInstance_t demod, enum drx_standard * standard)
 {
 	pDRXJData_t extAttr = NULL;
-	DRXStandard_t prevStandard;
+	enum drx_standard prevStandard;
 
 	/* check arguments */
 	if ((standard == NULL) || (demod == NULL)) {
@@ -13908,16 +13908,16 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetStandard()
+* \fn int CtrlGetStandard()
 * \brief Get modulation standard currently used to demodulate.
 * \param standard Modulation standard.
-* \return DRXStatus_t.
+* \return int.
 *
 * Returns 8VSB, NTSC, QAM only.
 *
 */
-static DRXStatus_t
-CtrlGetStandard(pDRXDemodInstance_t demod, pDRXStandard_t standard)
+static int
+CtrlGetStandard(pDRXDemodInstance_t demod, enum drx_standard * standard)
 {
 	pDRXJData_t extAttr = NULL;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -13937,16 +13937,16 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgSymbolClockOffset()
+* \fn int CtrlGetCfgSymbolClockOffset()
 * \brief Get frequency offsets of STR.
 * \param pointer to s32.
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgSymbolClockOffset(pDRXDemodInstance_t demod, s32 *rateOffset)
 {
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
@@ -13982,18 +13982,18 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlPowerMode()
+* \fn int CtrlPowerMode()
 * \brief Set the power mode of the device to the specified power mode
 * \param demod Pointer to demodulator instance.
 * \param mode  Pointer to new power mode.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK          Success
 * \retval DRX_STS_ERROR       I2C error or other failure
 * \retval DRX_STS_INVALID_ARG Invalid mode argument.
 *
 *
 */
-static DRXStatus_t
+static int
 CtrlPowerMode(pDRXDemodInstance_t demod, pDRXPowerMode_t mode)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) NULL;
@@ -14102,11 +14102,11 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlVersion()
+* \fn int CtrlVersion()
 * \brief Report version of microcode and if possible version of device
 * \param demod Pointer to demodulator instance.
 * \param versionList Pointer to pointer of linked list of versions.
-* \return DRXStatus_t.
+* \return int.
 *
 * Using static structures so no allocation of memory is needed.
 * Filling in all the fields each time, cause you don't know if they are
@@ -14121,7 +14121,7 @@ rw_error:
 * DRX3933J B1 => number: 33.2.1 text: "DRX3933J:B1"
 *
 */
-static DRXStatus_t
+static int
 CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
@@ -14261,10 +14261,10 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlProbeDevice()
+* \fn int CtrlProbeDevice()
 * \brief Probe device, check if it is present
 * \param demod Pointer to demodulator instance.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK    a drx39xxj device has been detected.
 * \retval DRX_STS_ERROR no drx39xxj device detected.
 *
@@ -14272,10 +14272,10 @@ rw_error:
 *
 */
 
-static DRXStatus_t CtrlProbeDevice(pDRXDemodInstance_t demod)
+static int CtrlProbeDevice(pDRXDemodInstance_t demod)
 {
 	DRXPowerMode_t orgPowerMode = DRX_POWER_UP;
-	DRXStatus_t retStatus = DRX_STS_OK;
+	int retStatus = DRX_STS_OK;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
@@ -14342,7 +14342,7 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t IsMCBlockAudio()
+* \fn int IsMCBlockAudio()
 * \brief Check if MC block is Audio or not Audio.
 * \param addr        Pointer to demodulator instance.
 * \param audioUpload true  if MC block is Audio
@@ -14360,16 +14360,16 @@ bool IsMCBlockAudio(u32 addr)
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlUCodeUpload()
+* \fn int CtrlUCodeUpload()
 * \brief Handle Audio or !Audio part of microcode upload.
 * \param demod          Pointer to demodulator instance.
 * \param mcInfo         Pointer to information about microcode data.
 * \param action         Either UCODE_UPLOAD or UCODE_VERIFY.
 * \param uploadAudioMC  true  if Audio MC need to be uploaded.
 			false if !Audio MC need to be uploaded.
-* \return DRXStatus_t.
+* \return int.
 */
-static DRXStatus_t
+static int
 CtrlUCodeUpload(pDRXDemodInstance_t demod,
 		pDRXUCodeInfo_t mcInfo,
 		DRXUCodeAction_t action, bool uploadAudioMC)
@@ -14540,21 +14540,21 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 
 /*===== SigStrength() =========================================================*/
 /**
-* \fn DRXStatus_t CtrlSigStrength()
+* \fn int CtrlSigStrength()
 * \brief Retrieve signal strength.
 * \param devmod Pointer to demodulator instance.
 * \param sigQuality Pointer to signal strength data; range 0, .. , 100.
-* \return DRXStatus_t.
+* \return int.
 * \retval DRX_STS_OK sigStrength contains valid data.
 * \retval DRX_STS_INVALID_ARG sigStrength is NULL.
 * \retval DRX_STS_ERROR Erroneous data, sigStrength contains invalid data.
 
 */
-static DRXStatus_t
+static int
 CtrlSigStrength(pDRXDemodInstance_t demod, u16 *sigStrength)
 {
 	pDRXJData_t extAttr = NULL;
-	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
+	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 
 	/* Check arguments */
 	if ((sigStrength == NULL) || (demod == NULL)) {
@@ -14600,14 +14600,14 @@ rw_error:
 
 /*============================================================================*/
 /**
-* \fn DRXStatus_t CtrlGetCfgOOBMisc()
+* \fn int CtrlGetCfgOOBMisc()
 * \brief Get current state information of OOB.
 * \param pointer to DRXJCfgOOBMisc_t.
-* \return DRXStatus_t.
+* \return int.
 *
 */
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t
+static int
 CtrlGetCfgOOBMisc(pDRXDemodInstance_t demod, pDRXJCfgOOBMisc_t misc)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -14653,13 +14653,13 @@ rw_error:
 #endif
 
 /**
-* \fn DRXStatus_t CtrlGetCfgVSBMisc()
+* \fn int CtrlGetCfgVSBMisc()
 * \brief Get current state information of OOB.
 * \param pointer to DRXJCfgOOBMisc_t.
-* \return DRXStatus_t.
+* \return int.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgVSBMisc(pDRXDemodInstance_t demod, pDRXJCfgVSBMisc_t misc)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -14680,17 +14680,17 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlSetCfgAgcIf()
+* \fn int CtrlSetCfgAgcIf()
 * \brief Set IF AGC.
 * \param demod demod instance
 * \param agcSettings If agc configuration
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
 	/* check arguments */
@@ -14736,17 +14736,17 @@ CtrlSetCfgAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgAgcIf()
+* \fn int CtrlGetCfgAgcIf()
 * \brief Retrieve IF AGC settings.
 * \param demod demod instance
 * \param agcSettings If agc configuration
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
 	/* check arguments */
@@ -14783,17 +14783,17 @@ CtrlGetCfgAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlSetCfgAgcRf()
+* \fn int CtrlSetCfgAgcRf()
 * \brief Set RF AGC.
 * \param demod demod instance
 * \param agcSettings rf agc configuration
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
 	/* check arguments */
@@ -14839,17 +14839,17 @@ CtrlSetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgAgcRf()
+* \fn int CtrlGetCfgAgcRf()
 * \brief Retrieve RF AGC settings.
 * \param demod demod instance
 * \param agcSettings Rf agc configuration
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
 	/* check arguments */
@@ -14886,17 +14886,17 @@ CtrlGetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgAgcInternal()
+* \fn int CtrlGetCfgAgcInternal()
 * \brief Retrieve internal AGC value.
 * \param demod demod instance
 * \param u16
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAgcInternal(pDRXDemodInstance_t demod, u16 *agcInternal)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -14969,17 +14969,17 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlSetCfgPreSaw()
+* \fn int CtrlSetCfgPreSaw()
 * \brief Set Pre-saw reference.
 * \param demod demod instance
 * \param u16 *
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -15038,17 +15038,17 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlSetCfgAfeGain()
+* \fn int CtrlSetCfgAfeGain()
 * \brief Set AFE Gain.
 * \param demod demod instance
 * \param u16 *
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlSetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -15114,17 +15114,17 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgPreSaw()
+* \fn int CtrlGetCfgPreSaw()
 * \brief Get Pre-saw reference setting.
 * \param demod demod instance
 * \param u16 *
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -15174,17 +15174,17 @@ CtrlGetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw)
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfgAfeGain()
+* \fn int CtrlGetCfgAfeGain()
 * \brief Get AFE Gain.
 * \param demod demod instance
 * \param u16 *
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 {
 	struct i2c_device_addr *devAddr = NULL;
@@ -15219,17 +15219,17 @@ CtrlGetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetFecMeasSeqCount()
+* \fn int CtrlGetFecMeasSeqCount()
 * \brief Get FEC measurement sequnce number.
 * \param demod demod instance
 * \param u16 *
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetFecMeasSeqCount(pDRXDemodInstance_t demod, u16 *fecMeasSeqCount)
 {
 	/* check arguments */
@@ -15247,17 +15247,17 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetAccumCrRSCwErr()
+* \fn int CtrlGetAccumCrRSCwErr()
 * \brief Get accumulative corrected RS codeword number.
 * \param demod demod instance
 * \param u32 *
-* \return DRXStatus_t.
+* \return int.
 *
 * Check arguments
 * Dispatch handling to standard specific function.
 *
 */
-static DRXStatus_t
+static int
 CtrlGetAccumCrRSCwErr(pDRXDemodInstance_t demod, u32 *accumCrRsCWErr)
 {
 	if (accumCrRsCWErr == NULL) {
@@ -15273,14 +15273,14 @@ rw_error:
 }
 
 /**
-* \fn DRXStatus_t CtrlSetCfg()
+* \fn int CtrlSetCfg()
 * \brief Set 'some' configuration of the device.
 * \param devmod Pointer to demodulator instance.
 * \param config Pointer to configuration parameters (type and data).
-* \return DRXStatus_t.
+* \return int.
 
 */
-static DRXStatus_t CtrlSetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
+static int CtrlSetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
 {
 	if (config == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -15381,14 +15381,14 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn DRXStatus_t CtrlGetCfg()
+* \fn int CtrlGetCfg()
 * \brief Get 'some' configuration of the device.
 * \param devmod Pointer to demodulator instance.
 * \param config Pointer to configuration parameters (type and data).
-* \return DRXStatus_t.
+* \return int.
 */
 
-static DRXStatus_t CtrlGetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
+static int CtrlGetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
 {
 	if (config == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -15521,7 +15521,7 @@ rw_error:
 * rely on SCU or AUD ucode to be present.
 *
 */
-DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
+int DRXJ_Open(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -15738,7 +15738,7 @@ rw_error:
 * \return Status_t Return status.
 *
 */
-DRXStatus_t DRXJ_Close(pDRXDemodInstance_t demod)
+int DRXJ_Close(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -15780,8 +15780,8 @@ rw_error:
 * \brief DRXJ specific control function
 * \return Status_t Return status.
 */
-DRXStatus_t
-DRXJ_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
+int
+DRXJ_Ctrl(pDRXDemodInstance_t demod, u32 ctrl, void *ctrlData)
 {
 	switch (ctrl) {
       /*======================================================================*/
@@ -15844,14 +15844,14 @@ DRXJ_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
 	case DRX_CTRL_SET_STANDARD:
 		{
 			return CtrlSetStandard(demod,
-					       (pDRXStandard_t) ctrlData);
+					       (enum drx_standard *) ctrlData);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_STANDARD:
 		{
 			return CtrlGetStandard(demod,
-					       (pDRXStandard_t) ctrlData);
+					       (enum drx_standard *) ctrlData);
 		}
 		break;
       /*======================================================================*/
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index 87a8f2c188d4..47a0e3cc5b4b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -184,7 +184,7 @@ TYPEDEFS
 * Generic interface for all AGCs present on the DRXJ.
 */
 	typedef struct {
-		DRXStandard_t standard;	/* standard for which these settings apply */
+		enum drx_standard standard;	/* standard for which these settings apply */
 		DRXJAgcCtrlMode_t ctrlMode;	/* off, user, auto          */
 		u16 outputLevel;	/* range dependent on AGC   */
 		u16 minOutputLevel;	/* range dependent on AGC   */
@@ -202,7 +202,7 @@ TYPEDEFS
 * Interface to configure pre SAW sense.
 */
 	typedef struct {
-		DRXStandard_t standard;	/* standard to which these settings apply */
+		enum drx_standard standard;	/* standard to which these settings apply */
 		u16 reference;	/* pre SAW reference value, range 0 .. 31 */
 		bool usePreSaw;	/* true algorithms must use pre SAW sense */
 	} DRXJCfgPreSaw_t, *pDRXJCfgPreSaw_t;
@@ -214,7 +214,7 @@ TYPEDEFS
 * Interface to configure gain of AFE (LNA + PGA).
 */
 	typedef struct {
-		DRXStandard_t standard;	/* standard to which these settings apply */
+		enum drx_standard standard;	/* standard to which these settings apply */
 		u16 gain;	/* gain in 0.1 dB steps, DRXJ range 140 .. 335 */
 	} DRXJCfgAfeGain_t, *pDRXJCfgAfeGain_t;
 
@@ -462,13 +462,13 @@ TYPEDEFS
 		bool mirrorFreqSpectOOB;/**< tuner inversion (true = tuner mirrors the signal */
 
 		/* standard/channel settings */
-		DRXStandard_t standard;	  /**< current standard information                     */
-		DRXConstellation_t constellation;
+		enum drx_standard standard;	  /**< current standard information                     */
+		enum drx_modulation constellation;
 					  /**< current constellation                            */
 		s32 frequency; /**< center signal frequency in KHz                   */
-		DRXBandwidth_t currBandwidth;
+		enum drx_bandwidth currBandwidth;
 					  /**< current channel bandwidth                        */
-		DRXMirror_t mirror;	  /**< current channel mirror                           */
+		enum drx_mirror mirror;	  /**< current channel mirror                           */
 
 		/* signal quality information */
 		u32 fecBitsDesired;	  /**< BER accounting period                            */
@@ -723,10 +723,10 @@ STRUCTS
 Exported FUNCTIONS
 -------------------------------------------------------------------------*/
 
-	extern DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod);
-	extern DRXStatus_t DRXJ_Close(pDRXDemodInstance_t demod);
-	extern DRXStatus_t DRXJ_Ctrl(pDRXDemodInstance_t demod,
-				     DRXCtrlIndex_t ctrl, void *ctrlData);
+	extern int DRXJ_Open(pDRXDemodInstance_t demod);
+	extern int DRXJ_Close(pDRXDemodInstance_t demod);
+	extern int DRXJ_Ctrl(pDRXDemodInstance_t demod,
+				     u32 ctrl, void *ctrlData);
 
 /*-------------------------------------------------------------------------
 Exported GLOBAL VARIABLES
-- 
1.8.5.3

