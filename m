Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaCCKI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:28 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 21/79] [media] drx-j: get rid of typedefs in drx_driver.h
Date: Mon,  3 Mar 2014 07:06:15 -0300
Message-Id: <1393841233-24840-22-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the changes were done with scripts like:
	for i in drivers/media/dvb-frontends/drx39xyj/*.[ch]; do perl -ne '$var = "drx_sig_quality"; s,\b($var)_t\s+,struct \1 ,g; s,\bp_*($var)_t\s+,struct \1 *,g; s,\b($var)_t\b,struct \1,g; s,\bp_*($var)_t\b,struct \1 *,g; print $_' <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    |   50 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |    2 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  120 +--
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  110 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  | 1060 +++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |  746 +++++++-------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |   28 +-
 8 files changed, 999 insertions(+), 1119 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index d32bab033bf0..837bb64fa930 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -33,9 +33,9 @@
 static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	int result;
-	drx_power_mode_t power_mode;
+	enum drx_power_mode power_mode;
 
 	if (enable)
 		power_mode = DRX_POWER_UP;
@@ -55,9 +55,9 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	int result;
-	drx_lock_status_t lock_status;
+	enum drx_lock_status lock_status;
 
 	*status = 0;
 
@@ -102,9 +102,9 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	int result;
-	drx_sig_quality_t sig_quality;
+	struct drx_sig_quality sig_quality;
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
@@ -121,9 +121,9 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 					 u16 *strength)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	int result;
-	drx_sig_quality_t sig_quality;
+	struct drx_sig_quality sig_quality;
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
@@ -140,9 +140,9 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	int result;
-	drx_sig_quality_t sig_quality;
+	struct drx_sig_quality sig_quality;
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
@@ -158,9 +158,9 @@ static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	int result;
-	drx_sig_quality_t sig_quality;
+	struct drx_sig_quality sig_quality;
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
@@ -180,12 +180,12 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 #endif
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	enum drx_standard standard = DRX_STANDARD_8VSB;
-	drx_channel_t channel;
+	struct drx_channel channel;
 	int result;
-	drxuio_data_t uio_data;
-	drx_channel_t def_channel = { /* frequency      */ 0,
+	struct drxuio_data uio_data;
+	struct drx_channel def_channel = { /* frequency      */ 0,
 		/* bandwidth      */ DRX_BANDWIDTH_6MHZ,
 		/* mirror         */ DRX_MIRROR_NO,
 		/* constellation  */ DRX_CONSTELLATION_AUTO,
@@ -268,7 +268,7 @@ static int drx39xxj_sleep(struct dvb_frontend *fe)
 static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
-	drx_demod_instance_t *demod = state->demod;
+	struct drx_demod_instance *demod = state->demod;
 	bool i2c_gate_state;
 	int result;
 
@@ -326,11 +326,11 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	struct drx39xxj_state *state = NULL;
 
 	struct i2c_device_addr *demod_addr = NULL;
-	drx_common_attr_t *demod_comm_attr = NULL;
+	struct drx_common_attr *demod_comm_attr = NULL;
 	drxj_data_t *demod_ext_attr = NULL;
-	drx_demod_instance_t *demod = NULL;
-	drxuio_cfg_t uio_cfg;
-	drxuio_data_t uio_data;
+	struct drx_demod_instance *demod = NULL;
+	struct drxuio_cfg uio_cfg;
+	struct drxuio_data uio_data;
 	int result;
 
 	/* allocate memory for the internal state */
@@ -338,7 +338,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	if (state == NULL)
 		goto error;
 
-	demod = kmalloc(sizeof(drx_demod_instance_t), GFP_KERNEL);
+	demod = kmalloc(sizeof(struct drx_demod_instance), GFP_KERNEL);
 	if (demod == NULL)
 		goto error;
 
@@ -346,7 +346,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	if (demod_addr == NULL)
 		goto error;
 
-	demod_comm_attr = kmalloc(sizeof(drx_common_attr_t), GFP_KERNEL);
+	demod_comm_attr = kmalloc(sizeof(struct drx_common_attr), GFP_KERNEL);
 	if (demod_comm_attr == NULL)
 		goto error;
 
@@ -358,7 +358,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	state->i2c = i2c;
 	state->demod = demod;
 
-	memcpy(demod, &drxj_default_demod_g, sizeof(drx_demod_instance_t));
+	memcpy(demod, &drxj_default_demod_g, sizeof(struct drx_demod_instance));
 
 	demod->my_i2c_dev_addr = demod_addr;
 	memcpy(demod->my_i2c_dev_addr, &drxj_default_addr_g,
@@ -366,7 +366,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	demod->my_i2c_dev_addr->user_data = state;
 	demod->my_common_attr = demod_comm_attr;
 	memcpy(demod->my_common_attr, &drxj_default_comm_attr_g,
-	       sizeof(drx_common_attr_t));
+	       sizeof(struct drx_common_attr));
 	demod->my_common_attr->microcode = DRXJ_MC_MAIN;
 #if 0
 	demod->my_common_attr->verify_microcode = false;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index 622172d25a9f..a7eb7166be15 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -28,7 +28,7 @@
 
 struct drx39xxj_state {
 	struct i2c_adapter *i2c;
-	drx_demod_instance_t *demod;
+	struct drx_demod_instance *demod;
 	enum drx_standard current_standard;
 	struct dvb_frontend frontend;
 	int powered_up:1;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 9e9556b6d8a4..3f33b130cda0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -56,62 +56,62 @@
 
 /* Function prototypes */
 static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					  dr_xaddr_t addr,	/* address of register/memory   */
+					  u32 addr,	/* address of register/memory   */
 					  u16 datasize,	/* size of data                 */
 					  u8 *data,	/* data to send                 */
-					  dr_xflags_t flags);	/* special device flags         */
+					  u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 dr_xaddr_t addr,	/* address of register/memory   */
+					 u32 addr,	/* address of register/memory   */
 					 u16 datasize,	/* size of data                 */
 					 u8 *data,	/* data to send                 */
-					 dr_xflags_t flags);	/* special device flags         */
+					 u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_write_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 dr_xaddr_t addr,	/* address of register          */
+					 u32 addr,	/* address of register          */
 					 u8 data,	/* data to write                */
-					 dr_xflags_t flags);	/* special device flags         */
+					 u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_read_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					dr_xaddr_t addr,	/* address of register          */
+					u32 addr,	/* address of register          */
 					u8 *data,	/* buffer to receive data       */
-					dr_xflags_t flags);	/* special device flags         */
+					u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_read_modify_write_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						   dr_xaddr_t waddr,	/* address of register          */
-						   dr_xaddr_t raddr,	/* address to read back from    */
+						   u32 waddr,	/* address of register          */
+						   u32 raddr,	/* address to read back from    */
 						   u8 datain,	/* data to send                 */
 						   u8 *dataout);	/* data to receive back         */
 
 static int drxdap_fasi_write_reg16(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					  dr_xaddr_t addr,	/* address of register          */
+					  u32 addr,	/* address of register          */
 					  u16 data,	/* data to write                */
-					  dr_xflags_t flags);	/* special device flags         */
+					  u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_read_reg16(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 dr_xaddr_t addr,	/* address of register          */
+					 u32 addr,	/* address of register          */
 					 u16 *data,	/* buffer to receive data       */
-					 dr_xflags_t flags);	/* special device flags         */
+					 u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						    dr_xaddr_t waddr,	/* address of register          */
-						    dr_xaddr_t raddr,	/* address to read back from    */
+						    u32 waddr,	/* address of register          */
+						    u32 raddr,	/* address to read back from    */
 						    u16 datain,	/* data to send                 */
 						    u16 *dataout);	/* data to receive back         */
 
 static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					  dr_xaddr_t addr,	/* address of register          */
+					  u32 addr,	/* address of register          */
 					  u32 data,	/* data to write                */
-					  dr_xflags_t flags);	/* special device flags         */
+					  u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_read_reg32(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 dr_xaddr_t addr,	/* address of register          */
+					 u32 addr,	/* address of register          */
 					 u32 *data,	/* buffer to receive data       */
-					 dr_xflags_t flags);	/* special device flags         */
+					 u32 flags);	/* special device flags         */
 
 static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						    dr_xaddr_t waddr,	/* address of register          */
-						    dr_xaddr_t raddr,	/* address to read back from    */
+						    u32 waddr,	/* address of register          */
+						    u32 raddr,	/* address to read back from    */
 						    u32 datain,	/* data to send                 */
 						    u32 *dataout);	/* data to receive back         */
 
@@ -119,7 +119,7 @@ static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
 char drx_dap_fasi_module_name[] = "FASI Data Access Protocol";
 char drx_dap_fasi_version_text[] = "";
 
-drx_version_t drx_dap_fasi_version = {
+struct drx_version drx_dap_fasi_version = {
 	DRX_MODULE_DAP,	      /**< type identifier of the module */
 	drx_dap_fasi_module_name, /**< name or description of module */
 
@@ -130,7 +130,7 @@ drx_version_t drx_dap_fasi_version = {
 };
 
 /* The structure containing the protocol interface */
-drx_access_func_t drx_dap_fasi_funct_g = {
+struct drx_access_func drx_dap_fasi_funct_g = {
 	&drx_dap_fasi_version,
 	drxdap_fasi_write_block,	/* Supported */
 	drxdap_fasi_read_block,	/* Supported */
@@ -150,24 +150,24 @@ drx_access_func_t drx_dap_fasi_funct_g = {
 /* Functions not supported by protocol*/
 
 static int drxdap_fasi_write_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 dr_xaddr_t addr,	/* address of register          */
+					 u32 addr,	/* address of register          */
 					 u8 data,	/* data to write                */
-					 dr_xflags_t flags)
+					 u32 flags)
 {				/* special device flags         */
 	return DRX_STS_ERROR;
 }
 
 static int drxdap_fasi_read_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					dr_xaddr_t addr,	/* address of register          */
+					u32 addr,	/* address of register          */
 					u8 *data,	/* buffer to receive data       */
-					dr_xflags_t flags)
+					u32 flags)
 {				/* special device flags         */
 	return DRX_STS_ERROR;
 }
 
 static int drxdap_fasi_read_modify_write_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						   dr_xaddr_t waddr,	/* address of register          */
-						   dr_xaddr_t raddr,	/* address to read back from    */
+						   u32 waddr,	/* address of register          */
+						   u32 raddr,	/* address to read back from    */
 						   u8 datain,	/* data to send                 */
 						   u8 *dataout)
 {				/* data to receive back         */
@@ -175,8 +175,8 @@ static int drxdap_fasi_read_modify_write_reg8(struct i2c_device_addr *dev_addr,
 }
 
 static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						    dr_xaddr_t waddr,	/* address of register          */
-						    dr_xaddr_t raddr,	/* address to read back from    */
+						    u32 waddr,	/* address of register          */
+						    u32 raddr,	/* address to read back from    */
 						    u32 datain,	/* data to send                 */
 						    u32 *dataout)
 {				/* data to receive back         */
@@ -189,10 +189,10 @@ static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
 *
 * int drxdap_fasi_read_block (
 *      struct i2c_device_addr *dev_addr,      -- address of I2C device
-*      dr_xaddr_t        addr,         -- address of chip register/memory
+*      u32 addr,         -- address of chip register/memory
 *      u16            datasize,     -- number of bytes to read
 *      u8 *data,         -- data to receive
-*      dr_xflags_t       flags)        -- special device flags
+*      u32 flags)        -- special device flags
 *
 * Read block data from chip address. Because the chip is word oriented,
 * the number of bytes to read must be even.
@@ -211,9 +211,9 @@ static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
 ******************************/
 
 static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
-					 dr_xaddr_t addr,
+					 u32 addr,
 					 u16 datasize,
-					 u8 *data, dr_xflags_t flags)
+					 u8 *data, u32 flags)
 {
 	u8 buf[4];
 	u16 bufx;
@@ -304,8 +304,8 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 *
 * int drxdap_fasi_read_modify_write_reg16 (
 *      struct i2c_device_addr *dev_addr,   -- address of I2C device
-*      dr_xaddr_t        waddr,     -- address of chip register/memory
-*      dr_xaddr_t        raddr,     -- chip address to read back from
+*      u32 waddr,     -- address of chip register/memory
+*      u32 raddr,     -- chip address to read back from
 *      u16            wdata,     -- data to send
 *      u16 *rdata)     -- data to receive back
 *
@@ -326,8 +326,8 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 ******************************/
 
 static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
-						    dr_xaddr_t waddr,
-						    dr_xaddr_t raddr,
+						    u32 waddr,
+						    u32 raddr,
 						    u16 wdata, u16 *rdata)
 {
 	int rc = DRX_STS_ERROR;
@@ -350,9 +350,9 @@ static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 *
 * int drxdap_fasi_read_reg16 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
-*     dr_xaddr_t        addr,    -- address of chip register/memory
+*     u32 addr,    -- address of chip register/memory
 *     u16 *data,    -- data to receive
-*     dr_xflags_t       flags)   -- special device flags
+*     u32 flags)   -- special device flags
 *
 * Read one 16-bit register or memory location. The data received back is
 * converted back to the target platform's endianness.
@@ -365,8 +365,8 @@ static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 ******************************/
 
 static int drxdap_fasi_read_reg16(struct i2c_device_addr *dev_addr,
-					 dr_xaddr_t addr,
-					 u16 *data, dr_xflags_t flags)
+					 u32 addr,
+					 u16 *data, u32 flags)
 {
 	u8 buf[sizeof(*data)];
 	int rc;
@@ -383,9 +383,9 @@ static int drxdap_fasi_read_reg16(struct i2c_device_addr *dev_addr,
 *
 * int drxdap_fasi_read_reg32 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
-*     dr_xaddr_t        addr,    -- address of chip register/memory
+*     u32 addr,    -- address of chip register/memory
 *     u32 *data,    -- data to receive
-*     dr_xflags_t       flags)   -- special device flags
+*     u32 flags)   -- special device flags
 *
 * Read one 32-bit register or memory location. The data received back is
 * converted back to the target platform's endianness.
@@ -398,8 +398,8 @@ static int drxdap_fasi_read_reg16(struct i2c_device_addr *dev_addr,
 ******************************/
 
 static int drxdap_fasi_read_reg32(struct i2c_device_addr *dev_addr,
-					 dr_xaddr_t addr,
-					 u32 *data, dr_xflags_t flags)
+					 u32 addr,
+					 u32 *data, u32 flags)
 {
 	u8 buf[sizeof(*data)];
 	int rc;
@@ -418,10 +418,10 @@ static int drxdap_fasi_read_reg32(struct i2c_device_addr *dev_addr,
 *
 * int drxdap_fasi_write_block (
 *      struct i2c_device_addr *dev_addr,    -- address of I2C device
-*      dr_xaddr_t        addr,       -- address of chip register/memory
+*      u32 addr,       -- address of chip register/memory
 *      u16            datasize,   -- number of bytes to read
 *      u8 *data,       -- data to receive
-*      dr_xflags_t       flags)      -- special device flags
+*      u32 flags)      -- special device flags
 *
 * Write block data to chip address. Because the chip is word oriented,
 * the number of bytes to write must be even.
@@ -437,9 +437,9 @@ static int drxdap_fasi_read_reg32(struct i2c_device_addr *dev_addr,
 ******************************/
 
 static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
-					  dr_xaddr_t addr,
+					  u32 addr,
 					  u16 datasize,
-					  u8 *data, dr_xflags_t flags)
+					  u8 *data, u32 flags)
 {
 	u8 buf[DRXDAP_MAX_WCHUNKSIZE];
 	int st = DRX_STS_ERROR;
@@ -562,9 +562,9 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 *
 * int drxdap_fasi_write_reg16 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
-*     dr_xaddr_t        addr,    -- address of chip register/memory
+*     u32 addr,    -- address of chip register/memory
 *     u16            data,    -- data to send
-*     dr_xflags_t       flags)   -- special device flags
+*     u32 flags)   -- special device flags
 *
 * Write one 16-bit register or memory location. The data being written is
 * converted from the target platform's endianness to little endian.
@@ -576,8 +576,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 ******************************/
 
 static int drxdap_fasi_write_reg16(struct i2c_device_addr *dev_addr,
-					  dr_xaddr_t addr,
-					  u16 data, dr_xflags_t flags)
+					  u32 addr,
+					  u16 data, u32 flags)
 {
 	u8 buf[sizeof(data)];
 
@@ -591,9 +591,9 @@ static int drxdap_fasi_write_reg16(struct i2c_device_addr *dev_addr,
 *
 * int drxdap_fasi_write_reg32 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
-*     dr_xaddr_t        addr,    -- address of chip register/memory
+*     u32 addr,    -- address of chip register/memory
 *     u32            data,    -- data to send
-*     dr_xflags_t       flags)   -- special device flags
+*     u32 flags)   -- special device flags
 *
 * Write one 32-bit register or memory location. The data being written is
 * converted from the target platform's endianness to little endian.
@@ -605,8 +605,8 @@ static int drxdap_fasi_write_reg16(struct i2c_device_addr *dev_addr,
 ******************************/
 
 static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,
-					  dr_xaddr_t addr,
-					  u32 data, dr_xflags_t flags)
+					  u32 addr,
+					  u32 data, u32 flags)
 {
 	u8 buf[sizeof(data)];
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
index 02b2c3037954..4151876f0ebe 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
@@ -238,7 +238,7 @@
 extern "C" {
 #endif
 
-	extern drx_access_func_t drx_dap_fasi_funct_g;
+	extern struct drx_access_func drx_dap_fasi_funct_g;
 
 #define DRXDAP_FASI_RMW           0x10000000
 #define DRXDAP_FASI_BROADCAST     0x20000000
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index db92b4f9b650..af894b9f5b0d 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -147,21 +147,21 @@ FUNCTIONS
 /* Prototype of default scanning function */
 static int
 scan_function_default(void *scan_context,
-		      drx_scan_command_t scan_command,
-		    pdrx_channel_t scan_channel, bool *get_next_channel);
+		      enum drx_scan_command scan_command,
+		    struct drx_channel *scan_channel, bool *get_next_channel);
 
 /**
 * \brief Get pointer to scanning function.
 * \param demod:    Pointer to demodulator instance.
 * \return drx_scan_func_t.
 */
-static drx_scan_func_t get_scan_function(pdrx_demod_instance_t demod)
+static drx_scan_func_t get_scan_function(struct drx_demod_instance *demod)
 {
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	drx_scan_func_t scan_func = (drx_scan_func_t) (NULL);
 
 	/* get scan function from common attributes */
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	scan_func = common_attr->scan_function;
 
 	if (scan_func != NULL) {
@@ -178,12 +178,12 @@ static drx_scan_func_t get_scan_function(pdrx_demod_instance_t demod)
 * \param scan_context: Context Pointer.
 * \return drx_scan_func_t.
 */
-static void *get_scan_context(pdrx_demod_instance_t demod, void *scan_context)
+static void *get_scan_context(struct drx_demod_instance *demod, void *scan_context)
 {
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 
 	/* get scan function from common attributes */
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	scan_context = common_attr->scan_context;
 
 	if (scan_context == NULL) {
@@ -211,11 +211,11 @@ static void *get_scan_context(pdrx_demod_instance_t demod, void *scan_context)
 * In case DRX_NEVER_LOCK is returned the poll-wait will be aborted.
 *
 */
-static int scan_wait_for_lock(pdrx_demod_instance_t demod, bool *is_locked)
+static int scan_wait_for_lock(struct drx_demod_instance *demod, bool *is_locked)
 {
 	bool done_waiting = false;
-	drx_lock_status_t lock_state = DRX_NOT_LOCKED;
-	drx_lock_status_t desired_lock_state = DRX_NOT_LOCKED;
+	enum drx_lock_status lock_state = DRX_NOT_LOCKED;
+	enum drx_lock_status desired_lock_state = DRX_NOT_LOCKED;
 	u32 timeout_value = 0;
 	u32 start_time_lock_stage = 0;
 	u32 current_time = 0;
@@ -273,17 +273,17 @@ static int scan_wait_for_lock(pdrx_demod_instance_t demod, bool *is_locked)
 *
 */
 static int
-scan_prepare_next_scan(pdrx_demod_instance_t demod, s32 skip)
+scan_prepare_next_scan(struct drx_demod_instance *demod, s32 skip)
 {
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	u16 table_index = 0;
 	u16 frequency_plan_size = 0;
-	p_drx_frequency_plan_t frequency_plan = (p_drx_frequency_plan_t) (NULL);
+	struct drx_frequency_plan *frequency_plan = (struct drx_frequency_plan *) (NULL);
 	s32 next_frequency = 0;
 	s32 tuner_min_frequency = 0;
 	s32 tuner_max_frequency = 0;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	table_index = common_attr->scan_freq_plan_index;
 	frequency_plan = common_attr->scan_param->frequency_plan;
 	next_frequency = common_attr->scan_next_frequency;
@@ -355,14 +355,14 @@ scan_prepare_next_scan(pdrx_demod_instance_t demod, s32 skip)
 */
 static int
 scan_function_default(void *scan_context,
-		      drx_scan_command_t scan_command,
-		    pdrx_channel_t scan_channel, bool *get_next_channel)
+		      enum drx_scan_command scan_command,
+		    struct drx_channel *scan_channel, bool *get_next_channel)
 {
-	pdrx_demod_instance_t demod = NULL;
+	struct drx_demod_instance *demod = NULL;
 	int status = DRX_STS_ERROR;
 	bool is_locked = false;
 
-	demod = (pdrx_demod_instance_t) scan_context;
+	demod = (struct drx_demod_instance *) scan_context;
 
 	if (scan_command != DRX_SCAN_COMMAND_NEXT) {
 		/* just return OK if not doing "scan next" */
@@ -412,21 +412,21 @@ scan_function_default(void *scan_context,
 *
 */
 static int
-ctrl_scan_init(pdrx_demod_instance_t demod, p_drx_scan_param_t scan_param)
+ctrl_scan_init(struct drx_demod_instance *demod, struct drx_scan_param *scan_param)
 {
 	int status = DRX_STS_ERROR;
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	s32 max_tuner_freq = 0;
 	s32 min_tuner_freq = 0;
 	u16 nr_channels_in_plan = 0;
 	u16 i = 0;
 	void *scan_context = NULL;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	common_attr->scan_active = true;
 
 	/* invalidate a previous SCAN_INIT */
-	common_attr->scan_param = (p_drx_scan_param_t) (NULL);
+	common_attr->scan_param = NULL;
 	common_attr->scan_next_frequency = 0;
 
 	/* Check parameters */
@@ -551,13 +551,13 @@ ctrl_scan_init(pdrx_demod_instance_t demod, p_drx_scan_param_t scan_param)
 * \retval DRX_STS_ERROR:       Something went wrong.
 * \retval DRX_STS_INVALID_ARG: Wrong parameters.
 */
-static int ctrl_scan_stop(pdrx_demod_instance_t demod)
+static int ctrl_scan_stop(struct drx_demod_instance *demod)
 {
 	int status = DRX_STS_ERROR;
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	void *scan_context = NULL;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	common_attr->scan_active = true;
 
 	if ((common_attr->scan_param == NULL) ||
@@ -601,15 +601,15 @@ static int ctrl_scan_stop(pdrx_demod_instance_t demod)
 * Progress indication will run from 0 upto DRX_SCAN_MAX_PROGRESS during scan.
 *
 */
-static int ctrl_scan_next(pdrx_demod_instance_t demod, u16 *scan_progress)
+static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 {
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	bool *scan_ready = (bool *)(NULL);
 	u16 max_progress = DRX_SCAN_MAX_PROGRESS;
 	u32 num_tries = 0;
 	u32 i = 0;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	/* Check scan parameters */
 	if (scan_progress == NULL) {
@@ -635,9 +635,9 @@ static int ctrl_scan_next(pdrx_demod_instance_t demod, u16 *scan_progress)
 	scan_ready = &(common_attr->scan_ready);
 
 	for (i = 0; ((i < num_tries) && ((*scan_ready) == false)); i++) {
-		drx_channel_t scan_channel = { 0 };
+		struct drx_channel scan_channel = { 0 };
 		int status = DRX_STS_ERROR;
-		p_drx_frequency_plan_t freq_plan = (p_drx_frequency_plan_t) (NULL);
+		struct drx_frequency_plan *freq_plan = (struct drx_frequency_plan *) (NULL);
 		bool next_channel = false;
 		void *scan_context = NULL;
 
@@ -728,9 +728,9 @@ static int ctrl_scan_next(pdrx_demod_instance_t demod, u16 *scan_progress)
 *
 */
 static int
-ctrl_program_tuner(pdrx_demod_instance_t demod, pdrx_channel_t channel)
+ctrl_program_tuner(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	u32 tuner_mode = 0;
 	int status = DRX_STS_ERROR;
@@ -742,7 +742,7 @@ ctrl_program_tuner(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	/* select analog or digital tuner mode based on current standard */
 	if (drx_ctrl(demod, DRX_CTRL_GET_STANDARD, &standard) != DRX_STS_OK) {
@@ -839,8 +839,8 @@ ctrl_program_tuner(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 * \retval DRX_STS_INVALID_ARG: Wrong parameters.
 *
 */
-static int ctrl_dump_registers(pdrx_demod_instance_t demod,
-			      p_drx_reg_dump_t registers)
+static int ctrl_dump_registers(struct drx_demod_instance *demod,
+			      struct drx_reg_dump *registers)
 {
 	u16 i = 0;
 
@@ -982,8 +982,8 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 *                    - Provided image is corrupt
 */
 static int
-ctrl_u_code(pdrx_demod_instance_t demod,
-	    p_drxu_code_info_t mc_info, drxu_code_action_t action)
+ctrl_u_code(struct drx_demod_instance *demod,
+	    struct drxu_code_info *mc_info, enum drxu_code_action action)
 {
 	int rc;
 	u16 i = 0;
@@ -1123,7 +1123,7 @@ ctrl_u_code(pdrx_demod_instance_t demod,
 					    [DRX_UCODE_MAX_BUF_SIZE];
 					u32 bytes_to_compare = 0;
 					u32 bytes_left_to_compare = 0;
-					dr_xaddr_t curr_addr = (dr_xaddr_t) 0;
+					u32 curr_addr = (dr_xaddr_t) 0;
 					u8 *curr_ptr = NULL;
 
 					bytes_left_to_compare = mc_block_nr_bytes;
@@ -1202,16 +1202,16 @@ ctrl_u_code(pdrx_demod_instance_t demod,
 * \retval DRX_STS_INVALID_ARG: Invalid arguments.
 */
 static int
-ctrl_version(pdrx_demod_instance_t demod, p_drx_version_list_t *version_list)
+ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version_list)
 {
 	static char drx_driver_core_module_name[] = "Core driver";
 	static char drx_driver_core_version_text[] =
 	    DRX_VERSIONSTRING(VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH);
 
-	static drx_version_t drx_driver_core_version;
-	static drx_version_list_t drx_driver_core_versionList;
+	static struct drx_version drx_driver_core_version;
+	static struct drx_version_list drx_driver_core_versionList;
 
-	p_drx_version_list_t demod_version_list = (p_drx_version_list_t) (NULL);
+	struct drx_version_list *demod_version_list = (struct drx_version_list *) (NULL);
 	int return_status = DRX_STS_ERROR;
 
 	/* Check arguments */
@@ -1234,13 +1234,13 @@ ctrl_version(pdrx_demod_instance_t demod, p_drx_version_list_t *version_list)
 	drx_driver_core_version.v_string = drx_driver_core_version_text;
 
 	drx_driver_core_versionList.version = &drx_driver_core_version;
-	drx_driver_core_versionList.next = (p_drx_version_list_t) (NULL);
+	drx_driver_core_versionList.next = (struct drx_version_list *) (NULL);
 
 	if ((return_status == DRX_STS_OK) && (demod_version_list != NULL)) {
 		/* Append versioninfo from driver to versioninfo from demod  */
 		/* Return version info in "bottom-up" order. This way, multiple
 		   devices can be handled without using malloc. */
-		p_drx_version_list_t current_list_element = demod_version_list;
+		struct drx_version_list *current_list_element = demod_version_list;
 		while (current_list_element->next != NULL) {
 			current_list_element = current_list_element->next;
 		}
@@ -1271,7 +1271,7 @@ ctrl_version(pdrx_demod_instance_t demod, p_drx_version_list_t *version_list)
 *
 */
 
-int drx_init(pdrx_demod_instance_t demods[])
+int drx_init(struct drx_demod_instance *demods[])
 {
 	return DRX_STS_OK;
 }
@@ -1305,7 +1305,7 @@ int drx_term(void)
 *
 */
 
-int drx_open(pdrx_demod_instance_t demod)
+int drx_open(struct drx_demod_instance *demod)
 {
 	int status = DRX_STS_OK;
 
@@ -1342,7 +1342,7 @@ int drx_open(pdrx_demod_instance_t demod)
 * Put device into sleep mode.
 */
 
-int drx_close(pdrx_demod_instance_t demod)
+int drx_close(struct drx_demod_instance *demod)
 {
 	int status = DRX_STS_OK;
 
@@ -1383,7 +1383,7 @@ int drx_close(pdrx_demod_instance_t demod)
 */
 
 int
-drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
+drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 {
 	int status = DRX_STS_ERROR;
 
@@ -1420,7 +1420,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 
       /*======================================================================*/
 	case DRX_CTRL_VERSION:
-		return ctrl_version(demod, (p_drx_version_list_t *)ctrl_data);
+		return ctrl_version(demod, (struct drx_version_list **)ctrl_data);
 		break;
 
       /*======================================================================*/
@@ -1438,7 +1438,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 	 /*===================================================================*/
 		case DRX_CTRL_LOAD_UCODE:
 			return ctrl_u_code(demod,
-					 (p_drxu_code_info_t) ctrl_data,
+					 (struct drxu_code_info *)ctrl_data,
 					 UCODE_UPLOAD);
 			break;
 
@@ -1446,7 +1446,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 		case DRX_CTRL_VERIFY_UCODE:
 			{
 				return ctrl_u_code(demod,
-						 (p_drxu_code_info_t) ctrl_data,
+						 (struct drxu_code_info *)ctrl_data,
 						 UCODE_VERIFY);
 			}
 			break;
@@ -1456,7 +1456,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 		case DRX_CTRL_SCAN_INIT:
 			{
 				return ctrl_scan_init(demod,
-						    (p_drx_scan_param_t) ctrl_data);
+						    (struct drx_scan_param *) ctrl_data);
 			}
 			break;
 
@@ -1479,7 +1479,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 		case DRX_CTRL_PROGRAM_TUNER:
 			{
 				return ctrl_program_tuner(demod,
-							(pdrx_channel_t)
+							(struct drx_channel *)
 							ctrl_data);
 			}
 			break;
@@ -1488,7 +1488,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 		case DRX_CTRL_DUMP_REGISTERS:
 			{
 				return ctrl_dump_registers(demod,
-							 (p_drx_reg_dump_t)
+							 (struct drx_reg_dump *)
 							 ctrl_data);
 			}
 			break;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index ca07a6c4f58d..e0316f667f4c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -242,7 +242,6 @@ struct tuner_instance {
 	struct tuner_ops *my_funct;
 };
 
-
 int drxbsp_tuner_open(struct tuner_instance *tuner);
 
 int drxbsp_tuner_close(struct tuner_instance *tuner);
@@ -498,9 +497,9 @@ MACROS
 /**
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
-#define DRX_S24TODRXFREQ(x) ((( (u32) x) & 0x00800000UL) ? \
+#define DRX_S24TODRXFREQ(x) ((((u32) x) & 0x00800000UL) ? \
 				 ((s32) \
-				    (((u32) x) | 0xFF000000) ) : \
+				    (((u32) x) | 0xFF000000)) : \
 				 ((s32) x))
 
 /**
@@ -508,7 +507,7 @@ MACROS
 */
 #define DRX_U16TODRXFREQ(x)   ((x & 0x8000) ? \
 				 ((s32) \
-				    (((u32) x) | 0xFFFF0000) ) : \
+				    (((u32) x) | 0xFFFF0000)) : \
 				 ((s32) x))
 
 /*-------------------------------------------------------------------------
@@ -856,133 +855,141 @@ enum drx_pilot_mode {
 #define DRX_CTRL_MAX             (DRX_CTRL_BASE + 44)	/* never to be used    */
 
 /**
-* \enum drxu_code_action_t
-* \brief Used to indicate if firmware has to be uploaded or verified.
-*/
-
-	typedef enum {
-		UCODE_UPLOAD,
-		  /**< Upload the microcode image to device        */
-		UCODE_VERIFY
-		  /**< Compare microcode image with code on device */
-	} drxu_code_action_t, *pdrxu_code_action_t;
+ * enum drxu_code_action - indicate if firmware has to be uploaded or verified.
+ * @UCODE_UPLOAD:	Upload the microcode image to device
+ * @UCODE_VERIFY:	Compare microcode image with code on device
+ */
+enum drxu_code_action {
+	UCODE_UPLOAD,
+	UCODE_VERIFY
+};
 
 /**
-* \enum drx_lock_status_t
-* \brief Used to reflect current lock status of demodulator.
+* \enum enum drx_lock_status * \brief Used to reflect current lock status of demodulator.
 *
 * The generic lock states have device dependent semantics.
-*/
-	typedef enum {
+
 		DRX_NEVER_LOCK = 0,
-			      /**< Device will never lock on this signal */
+			      **< Device will never lock on this signal *
 		DRX_NOT_LOCKED,
-			      /**< Device has no lock at all             */
+			      **< Device has no lock at all             *
 		DRX_LOCK_STATE_1,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_2,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_3,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_4,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_5,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_6,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_7,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_8,
-			      /**< Generic lock state                    */
+			      **< Generic lock state                    *
 		DRX_LOCK_STATE_9,
-			      /**< Generic lock state                    */
-		DRX_LOCKED    /**< Device is in lock                     */
-	} drx_lock_status_t, *pdrx_lock_status_t;
-
-/**
-* \enum DRXUIO_t
-* \brief Used to address a User IO (UIO).
-*/
-	typedef enum {
-		DRX_UIO1,
-		DRX_UIO2,
-		DRX_UIO3,
-		DRX_UIO4,
-		DRX_UIO5,
-		DRX_UIO6,
-		DRX_UIO7,
-		DRX_UIO8,
-		DRX_UIO9,
-		DRX_UIO10,
-		DRX_UIO11,
-		DRX_UIO12,
-		DRX_UIO13,
-		DRX_UIO14,
-		DRX_UIO15,
-		DRX_UIO16,
-		DRX_UIO17,
-		DRX_UIO18,
-		DRX_UIO19,
-		DRX_UIO20,
-		DRX_UIO21,
-		DRX_UIO22,
-		DRX_UIO23,
-		DRX_UIO24,
-		DRX_UIO25,
-		DRX_UIO26,
-		DRX_UIO27,
-		DRX_UIO28,
-		DRX_UIO29,
-		DRX_UIO30,
-		DRX_UIO31,
-		DRX_UIO32,
-		DRX_UIO_MAX = DRX_UIO32
-	} DRXUIO_t, *p_drxuio_t;
-
-/**
-* \enum drxuio_mode_t
-* \brief Used to configure the modus oprandi of a UIO.
+			      **< Generic lock state                    *
+		DRX_LOCKED    **< Device is in lock                     *
+*/
+
+enum drx_lock_status {
+	DRX_NEVER_LOCK = 0,
+	DRX_NOT_LOCKED,
+	DRX_LOCK_STATE_1,
+	DRX_LOCK_STATE_2,
+	DRX_LOCK_STATE_3,
+	DRX_LOCK_STATE_4,
+	DRX_LOCK_STATE_5,
+	DRX_LOCK_STATE_6,
+	DRX_LOCK_STATE_7,
+	DRX_LOCK_STATE_8,
+	DRX_LOCK_STATE_9,
+	DRX_LOCKED
+};
+
+/**
+* \enum enum drx_uio* \brief Used to address a User IO (UIO).
+*/
+enum drx_uio {
+	DRX_UIO1,
+	DRX_UIO2,
+	DRX_UIO3,
+	DRX_UIO4,
+	DRX_UIO5,
+	DRX_UIO6,
+	DRX_UIO7,
+	DRX_UIO8,
+	DRX_UIO9,
+	DRX_UIO10,
+	DRX_UIO11,
+	DRX_UIO12,
+	DRX_UIO13,
+	DRX_UIO14,
+	DRX_UIO15,
+	DRX_UIO16,
+	DRX_UIO17,
+	DRX_UIO18,
+	DRX_UIO19,
+	DRX_UIO20,
+	DRX_UIO21,
+	DRX_UIO22,
+	DRX_UIO23,
+	DRX_UIO24,
+	DRX_UIO25,
+	DRX_UIO26,
+	DRX_UIO27,
+	DRX_UIO28,
+	DRX_UIO29,
+	DRX_UIO30,
+	DRX_UIO31,
+	DRX_UIO32,
+	DRX_UIO_MAX = DRX_UIO32
+};
+
+/**
+* \enum enum drxuio_mode * \brief Used to configure the modus oprandi of a UIO.
 *
 * DRX_UIO_MODE_FIRMWARE is an old uio mode.
 * It is replaced by the modes DRX_UIO_MODE_FIRMWARE0 .. DRX_UIO_MODE_FIRMWARE9.
 * To be backward compatible DRX_UIO_MODE_FIRMWARE is equivalent to
 * DRX_UIO_MODE_FIRMWARE0.
 */
-	typedef enum {
-		DRX_UIO_MODE_DISABLE = 0x01,
-				    /**< not used, pin is configured as input */
-		DRX_UIO_MODE_READWRITE = 0x02,
-				    /**< used for read/write by application   */
-		DRX_UIO_MODE_FIRMWARE = 0x04,
-				    /**< controlled by firmware, function 0   */
-		DRX_UIO_MODE_FIRMWARE0 = DRX_UIO_MODE_FIRMWARE,
-						    /**< same as above        */
-		DRX_UIO_MODE_FIRMWARE1 = 0x08,
-				    /**< controlled by firmware, function 1   */
-		DRX_UIO_MODE_FIRMWARE2 = 0x10,
-				    /**< controlled by firmware, function 2   */
-		DRX_UIO_MODE_FIRMWARE3 = 0x20,
-				    /**< controlled by firmware, function 3   */
-		DRX_UIO_MODE_FIRMWARE4 = 0x40,
-				    /**< controlled by firmware, function 4   */
-		DRX_UIO_MODE_FIRMWARE5 = 0x80
-				    /**< controlled by firmware, function 5   */
-	} drxuio_mode_t, *pdrxuio_mode_t;
-
-/**
-* \enum drxoob_downstream_standard_t
-* \brief Used to select OOB standard.
+enum drxuio_mode {
+	DRX_UIO_MODE_DISABLE = 0x01,
+			    /**< not used, pin is configured as input */
+	DRX_UIO_MODE_READWRITE = 0x02,
+			    /**< used for read/write by application   */
+	DRX_UIO_MODE_FIRMWARE = 0x04,
+			    /**< controlled by firmware, function 0   */
+	DRX_UIO_MODE_FIRMWARE0 = DRX_UIO_MODE_FIRMWARE,
+					    /**< same as above        */
+	DRX_UIO_MODE_FIRMWARE1 = 0x08,
+			    /**< controlled by firmware, function 1   */
+	DRX_UIO_MODE_FIRMWARE2 = 0x10,
+			    /**< controlled by firmware, function 2   */
+	DRX_UIO_MODE_FIRMWARE3 = 0x20,
+			    /**< controlled by firmware, function 3   */
+	DRX_UIO_MODE_FIRMWARE4 = 0x40,
+			    /**< controlled by firmware, function 4   */
+	DRX_UIO_MODE_FIRMWARE5 = 0x80
+			    /**< controlled by firmware, function 5   */
+};
+
+/**
+* \enum enum drxoob_downstream_standard * \brief Used to select OOB standard.
 *
 * Based on ANSI 55-1 and 55-2
 */
-	typedef enum {
-		DRX_OOB_MODE_A = 0,
-			       /**< ANSI 55-1   */
-		DRX_OOB_MODE_B_GRADE_A,
-			       /**< ANSI 55-2 A */
-		DRX_OOB_MODE_B_GRADE_B
-			       /**< ANSI 55-2 B */
-	} drxoob_downstream_standard_t, *pdrxoob_downstream_standard_t;
+enum drxoob_downstream_standard {
+	DRX_OOB_MODE_A = 0,
+		       /**< ANSI 55-1   */
+	DRX_OOB_MODE_B_GRADE_A,
+		       /**< ANSI 55-2 A */
+	DRX_OOB_MODE_B_GRADE_B
+		       /**< ANSI 55-2 B */
+};
 
 /*-------------------------------------------------------------------------
 STRUCTS
@@ -994,14 +1001,8 @@ STRUCTS
 /*============================================================================*/
 /*============================================================================*/
 
-/**
-* \enum drx_cfg_type_t
-* \brief Generic configuration function identifiers.
-*/
-	typedef u32 drx_cfg_type_t, *pdrx_cfg_type_t;
-
 #ifndef DRX_CFG_BASE
-#define DRX_CFG_BASE          ((drx_cfg_type_t)0)
+#define DRX_CFG_BASE          0
 #endif
 
 #define DRX_CFG_MPEG_OUTPUT         (DRX_CFG_BASE +  0)	/* MPEG TS output    */
@@ -1032,17 +1033,16 @@ STRUCTS
 /*============================================================================*/
 
 /**
-* \struct drxu_code_info_t
-* \brief Parameters for microcode upload and verfiy.
+* \struct struct drxu_code_info * \brief Parameters for microcode upload and verfiy.
 *
 * Used by DRX_CTRL_LOAD_UCODE and DRX_CTRL_VERIFY_UCODE
 */
-	typedef struct {
-		u8 *mc_data;
-		     /**< Pointer to microcode image. */
-		u16 mc_size;
-		     /**< Microcode image size.       */
-	} drxu_code_info_t, *p_drxu_code_info_t;
+struct drxu_code_info {
+	u8 *mc_data;
+	     /**< Pointer to microcode image. */
+	u16 mc_size;
+	     /**< Microcode image size.       */
+};
 
 /**
 * \struct drx_mc_version_rec_t
@@ -1063,12 +1063,12 @@ STRUCTS
 */
 #define AUX_VER_RECORD 0x8000
 
-	typedef struct {
-		u16 aux_type;	/* type of aux data - 0x8000 for version record     */
-		u32 mc_dev_type;	/* device type, based on JTAG ID                    */
-		u32 mc_version;	/* version of microcode                             */
-		u32 mc_base_version;	/* in case of patch: the original microcode version */
-	} drx_mc_version_rec_t, *pdrx_mc_version_rec_t;
+struct drx_mc_version_rec {
+	u16 aux_type;	/* type of aux data - 0x8000 for version record     */
+	u32 mc_dev_type;	/* device type, based on JTAG ID                    */
+	u32 mc_version;	/* version of microcode                             */
+	u32 mc_base_version;	/* in case of patch: the original microcode version */
+};
 
 /*========================================*/
 
@@ -1078,186 +1078,140 @@ STRUCTS
 *
 * Used by DRX_CTRL_LOAD_FILTER
 */
-	typedef struct {
-		u8 *data_re;
-		      /**< pointer to coefficients for RE */
-		u8 *data_im;
-		      /**< pointer to coefficients for IM */
-		u16 size_re;
-		      /**< size of coefficients for RE    */
-		u16 size_im;
-		      /**< size of coefficients for IM    */
-	} drx_filter_info_t, *pdrx_filter_info_t;
+struct drx_filter_info {
+	u8 *data_re;
+	      /**< pointer to coefficients for RE */
+	u8 *data_im;
+	      /**< pointer to coefficients for IM */
+	u16 size_re;
+	      /**< size of coefficients for RE    */
+	u16 size_im;
+	      /**< size of coefficients for IM    */
+};
 
 /*========================================*/
 
 /**
-* \struct drx_channel_t
-* \brief The set of parameters describing a single channel.
+* \struct struct drx_channel * \brief The set of parameters describing a single channel.
 *
 * Used by DRX_CTRL_SET_CHANNEL and DRX_CTRL_GET_CHANNEL.
 * Only certain fields need to be used for a specfic standard.
 *
 */
-	typedef struct {
-		s32 frequency;
-					/**< frequency in kHz                 */
-		enum drx_bandwidth bandwidth;
-					/**< bandwidth                        */
-		enum drx_mirror mirror;	/**< mirrored or not on RF            */
-		enum drx_modulation constellation;
-					/**< constellation                    */
-		enum drx_hierarchy hierarchy;
-					/**< hierarchy                        */
-		enum drx_priority priority;	/**< priority                         */
-		enum drx_coderate coderate;	/**< coderate                         */
-		enum drx_guard guard;	/**< guard interval                   */
-		enum drx_fft_mode fftmode;	/**< fftmode                          */
-		enum drx_classification classification;
-					/**< classification                   */
-		u32 symbolrate;
-					/**< symbolrate in symbols/sec        */
-		enum drx_interleave_mode interleavemode;
-					/**< interleaveMode QAM               */
-		enum drx_ldpc ldpc;		/**< ldpc                             */
-		enum drx_carrier_mode carrier;	/**< carrier                          */
-		enum drx_frame_mode framemode;
-					/**< frame mode                       */
-		enum drx_pilot_mode pilot;	/**< pilot mode                       */
-	} drx_channel_t, *pdrx_channel_t;
+struct drx_channel {
+	s32 frequency;
+				/**< frequency in kHz                 */
+	enum drx_bandwidth bandwidth;
+				/**< bandwidth                        */
+	enum drx_mirror mirror;	/**< mirrored or not on RF            */
+	enum drx_modulation constellation;
+				/**< constellation                    */
+	enum drx_hierarchy hierarchy;
+				/**< hierarchy                        */
+	enum drx_priority priority;	/**< priority                         */
+	enum drx_coderate coderate;	/**< coderate                         */
+	enum drx_guard guard;	/**< guard interval                   */
+	enum drx_fft_mode fftmode;	/**< fftmode                          */
+	enum drx_classification classification;
+				/**< classification                   */
+	u32 symbolrate;
+				/**< symbolrate in symbols/sec        */
+	enum drx_interleave_mode interleavemode;
+				/**< interleaveMode QAM               */
+	enum drx_ldpc ldpc;		/**< ldpc                             */
+	enum drx_carrier_mode carrier;	/**< carrier                          */
+	enum drx_frame_mode framemode;
+				/**< frame mode                       */
+	enum drx_pilot_mode pilot;	/**< pilot mode                       */
+};
 
 /*========================================*/
 
 /**
-* \struct drx_sig_quality_t
-* Signal quality metrics.
+* \struct struct drx_sig_quality * Signal quality metrics.
 *
 * Used by DRX_CTRL_SIG_QUALITY.
 */
-	typedef struct {
-		u16 MER;     /**< in steps of 0.1 dB                        */
-		u32 pre_viterbi_ber;
-			       /**< in steps of 1/scale_factor_ber              */
-		u32 post_viterbi_ber;
-			       /**< in steps of 1/scale_factor_ber              */
-		u32 scale_factor_ber;
-			       /**< scale factor for BER                      */
-		u16 packet_error;
-			       /**< number of packet errors                   */
-		u32 post_reed_solomon_ber;
-			       /**< in steps of 1/scale_factor_ber              */
-		u32 pre_ldpc_ber;
-			       /**< in steps of 1/scale_factor_ber              */
-		u32 aver_iter;/**< in steps of 0.01                          */
-		u16 indicator;
-			       /**< indicative signal quality low=0..100=high */
-	} drx_sig_quality_t, *pdrx_sig_quality_t;
-
-	typedef enum {
-		DRX_SQI_SPEED_FAST = 0,
-		DRX_SQI_SPEED_MEDIUM,
-		DRX_SQI_SPEED_SLOW,
-		DRX_SQI_SPEED_UNKNOWN = DRX_UNKNOWN
-	} drx_cfg_sqi_speed_t, *pdrx_cfg_sqi_speed_t;
+struct drx_sig_quality {
+	u16 MER;     /**< in steps of 0.1 dB                        */
+	u32 pre_viterbi_ber;
+		       /**< in steps of 1/scale_factor_ber              */
+	u32 post_viterbi_ber;
+		       /**< in steps of 1/scale_factor_ber              */
+	u32 scale_factor_ber;
+		       /**< scale factor for BER                      */
+	u16 packet_error;
+		       /**< number of packet errors                   */
+	u32 post_reed_solomon_ber;
+		       /**< in steps of 1/scale_factor_ber              */
+	u32 pre_ldpc_ber;
+		       /**< in steps of 1/scale_factor_ber              */
+	u32 aver_iter;/**< in steps of 0.01                          */
+	u16 indicator;
+		       /**< indicative signal quality low=0..100=high */
+};
+
+enum drx_cfg_sqi_speed {
+	DRX_SQI_SPEED_FAST = 0,
+	DRX_SQI_SPEED_MEDIUM,
+	DRX_SQI_SPEED_SLOW,
+	DRX_SQI_SPEED_UNKNOWN = DRX_UNKNOWN
+};
 
 /*========================================*/
 
 /**
-* \struct drx_complex_t
-* A complex number.
+* \struct struct drx_complex * A complex number.
 *
 * Used by DRX_CTRL_CONSTEL.
 */
-	typedef struct {
-		s16 im;
-	     /**< Imaginary part. */
-		s16 re;
-	     /**< Real part.      */
-	} drx_complex_t, *pdrx_complex_t;
+struct drx_complex {
+	s16 im;
+     /**< Imaginary part. */
+	s16 re;
+     /**< Real part.      */
+};
 
 /*========================================*/
 
 /**
-* \struct drx_frequency_plan_t
-* Array element of a frequency plan.
+* \struct struct drx_frequency_plan * Array element of a frequency plan.
 *
 * Used by DRX_CTRL_SCAN_INIT.
 */
-	typedef struct {
-		s32 first;
-			     /**< First centre frequency in this band        */
-		s32 last;
-			     /**< Last centre frequency in this band         */
-		s32 step;
-			     /**< Stepping frequency in this band            */
-		enum drx_bandwidth bandwidth;
-			     /**< Bandwidth within this frequency band       */
-		u16 ch_number;
-			     /**< First channel number in this band, or first
-				    index in ch_names                         */
-		char **ch_names;
-			     /**< Optional list of channel names in this
-				    band                                     */
-	} drx_frequency_plan_t, *p_drx_frequency_plan_t;
-
-/*========================================*/
-
-/**
-* \struct drx_frequency_plan_info_t
-* Array element of a list of frequency plans.
-*
-* Used by frequency_plan.h
-*/
-	typedef struct {
-		p_drx_frequency_plan_t freq_plan;
-		int freq_planSize;
-		char *freq_planName;
-	} drx_frequency_plan_info_t, *pdrx_frequency_plan_info_t;
-
-/*========================================*/
-
-/**
-* /struct drx_scan_data_qam_t
-* QAM specific scanning variables
-*/
-	typedef struct {
-		u32 *symbolrate;	  /**<  list of symbolrates to scan   */
-		u16 symbolrate_size;	  /**<  size of symbolrate array      */
-		enum drx_modulation *constellation;
-					  /**<  list of constellations        */
-		u16 constellation_size;    /**<  size of constellation array */
-		u16 if_agc_threshold;	  /**<  thresholf for IF-AGC based
-						scanning filter               */
-	} drx_scan_data_qam_t, *pdrx_scan_data_qam_t;
-
-/*========================================*/
-
-/**
-* /struct drx_scan_data_atv_t
-* ATV specific scanning variables
-*/
-	typedef struct {
-		s16 svr_threshold;
-			/**< threshold of Sound/Video ratio in 0.1dB steps */
-	} drx_scan_data_atv_t, *pdrx_scan_data_atv_t;
+struct drx_frequency_plan {
+	s32 first;
+		     /**< First centre frequency in this band        */
+	s32 last;
+		     /**< Last centre frequency in this band         */
+	s32 step;
+		     /**< Stepping frequency in this band            */
+	enum drx_bandwidth bandwidth;
+		     /**< Bandwidth within this frequency band       */
+	u16 ch_number;
+		     /**< First channel number in this band, or first
+			    index in ch_names                         */
+	char **ch_names;
+		     /**< Optional list of channel names in this
+			    band                                     */
+};
 
 /*========================================*/
 
 /**
-* \struct drx_scan_param_t
-* Parameters for channel scan.
+* \struct struct drx_scan_param * Parameters for channel scan.
 *
 * Used by DRX_CTRL_SCAN_INIT.
 */
-	typedef struct {
-		p_drx_frequency_plan_t frequency_plan;
-					  /**< Frequency plan (array)*/
-		u16 frequency_plan_size;  /**< Number of bands       */
-		u32 num_tries;		  /**< Max channels tried    */
-		s32 skip;	  /**< Minimum frequency step to take
-						after a channel is found */
-		void *ext_params;	  /**< Standard specific params */
-	} drx_scan_param_t, *p_drx_scan_param_t;
+struct drx_scan_param {
+	struct drx_frequency_plan *frequency_plan;
+				  /**< Frequency plan (array)*/
+	u16 frequency_plan_size;  /**< Number of bands       */
+	u32 num_tries;		  /**< Max channels tried    */
+	s32 skip;	  /**< Minimum frequency step to take
+					after a channel is found */
+	void *ext_params;	  /**< Standard specific params */
+};
 
 /*========================================*/
 
@@ -1265,31 +1219,30 @@ STRUCTS
 * \brief Scan commands.
 * Used by scanning algorithms.
 */
-	typedef enum {
+enum drx_scan_command {
 		DRX_SCAN_COMMAND_INIT = 0,/**< Initialize scanning */
 		DRX_SCAN_COMMAND_NEXT,	  /**< Next scan           */
 		DRX_SCAN_COMMAND_STOP	  /**< Stop scanning       */
-	} drx_scan_command_t, *pdrx_scan_command_t;
+};
 
 /*========================================*/
 
 /**
 * \brief Inner scan function prototype.
 */
-	typedef int(*drx_scan_func_t) (void *scan_context,
-					     drx_scan_command_t scan_command,
-					     pdrx_channel_t scan_channel,
-					     bool *get_next_channel);
+typedef int(*drx_scan_func_t) (void *scan_context,
+				     enum drx_scan_command scan_command,
+				     struct drx_channel *scan_channel,
+				     bool *get_next_channel);
 
 /*========================================*/
 
 /**
-* \struct drxtps_info_t
-* TPS information, DVB-T specific.
+* \struct struct drxtps_info * TPS information, DVB-T specific.
 *
 * Used by DRX_CTRL_TPS_INFO.
 */
-	typedef struct {
+	struct drxtps_info {
 		enum drx_fft_mode fftmode;	/**< Fft mode       */
 		enum drx_guard guard;	/**< Guard interval */
 		enum drx_modulation constellation;
@@ -1303,7 +1256,7 @@ STRUCTS
 		enum drx_tps_frame frame;	/**< Tps frame      */
 		u8 length;		/**< Length         */
 		u16 cell_id;		/**< Cell id        */
-	} drxtps_info_t, *pdrxtps_info_t;
+	};
 
 /*========================================*/
 
@@ -1312,7 +1265,7 @@ STRUCTS
 *
 * Used by DRX_CTRL_SET_POWER_MODE.
 */
-	typedef enum {
+	enum drx_power_mode {
 		DRX_POWER_UP = 0,
 			 /**< Generic         , Power Up Mode   */
 		DRX_POWER_MODE_1,
@@ -1350,17 +1303,16 @@ STRUCTS
 			 /**< Device specific , Power Down Mode */
 		DRX_POWER_DOWN = 255
 			 /**< Generic         , Power Down Mode */
-	} drx_power_mode_t, *pdrx_power_mode_t;
+	};
 
 /*========================================*/
 
 /**
-* \enum drx_module_t
-* \brief Software module identification.
+* \enum enum drx_module * \brief Software module identification.
 *
 * Used by DRX_CTRL_VERSION.
 */
-	typedef enum {
+	enum drx_module {
 		DRX_MODULE_DEVICE,
 		DRX_MODULE_MICROCODE,
 		DRX_MODULE_DRIVERCORE,
@@ -1370,16 +1322,15 @@ STRUCTS
 		DRX_MODULE_BSP_TUNER,
 		DRX_MODULE_BSP_HOST,
 		DRX_MODULE_UNKNOWN
-	} drx_module_t, *pdrx_module_t;
+	};
 
 /**
-* \enum drx_version_t
-* \brief Version information of one software module.
+* \enum struct drx_version * \brief Version information of one software module.
 *
 * Used by DRX_CTRL_VERSION.
 */
-	typedef struct {
-		drx_module_t module_type;
+	struct drx_version {
+		enum drx_module module_type;
 			       /**< Type identifier of the module */
 		char *module_name;
 			       /**< Name or description of module */
@@ -1387,19 +1338,18 @@ STRUCTS
 		u16 v_minor;  /**< Minor version number          */
 		u16 v_patch;  /**< Patch version number          */
 		char *v_string; /**< Version as text string        */
-	} drx_version_t, *pdrx_version_t;
+	};
 
 /**
-* \enum drx_version_list_t
-* \brief List element of NULL terminated, linked list for version information.
+* \enum struct drx_version_list * \brief List element of NULL terminated, linked list for version information.
 *
 * Used by DRX_CTRL_VERSION.
 */
-	typedef struct drx_version_list_s {
-		pdrx_version_t version;/**< Version information */
-		struct drx_version_list_s *next;
-				      /**< Next list element   */
-	} drx_version_list_t, *p_drx_version_list_t;
+struct drx_version_list {
+	struct drx_version *version;/**< Version information */
+	struct drx_version_list *next;
+			      /**< Next list element   */
+};
 
 /*========================================*/
 
@@ -1408,12 +1358,12 @@ STRUCTS
 *
 * Used by DRX_CTRL_UIO_CFG.
 */
-	typedef struct {
-		DRXUIO_t uio;
+	struct drxuio_cfg {
+		enum drx_uio uio;
 		       /**< UIO identifier       */
-		drxuio_mode_t mode;
+		enum drxuio_mode mode;
 		       /**< UIO operational mode */
-	} drxuio_cfg_t, *pdrxuio_cfg_t;
+	};
 
 /*========================================*/
 
@@ -1422,12 +1372,12 @@ STRUCTS
 *
 * Used by DRX_CTRL_UIO_READ and DRX_CTRL_UIO_WRITE.
 */
-	typedef struct {
-		DRXUIO_t uio;
+	struct drxuio_data {
+		enum drx_uio uio;
 		   /**< UIO identifier              */
 		bool value;
 		   /**< UIO value (true=1, false=0) */
-	} drxuio_data_t, *pdrxuio_data_t;
+	};
 
 /*========================================*/
 
@@ -1436,13 +1386,13 @@ STRUCTS
 *
 * Used by DRX_CTRL_SET_OOB.
 */
-	typedef struct {
+	struct drxoob {
 		s32 frequency;	   /**< Frequency in kHz      */
-		drxoob_downstream_standard_t standard;
+		enum drxoob_downstream_standard standard;
 						   /**< OOB standard          */
 		bool spectrum_inverted;	   /**< If true, then spectrum
 							 is inverted          */
-	} DRXOOB_t, *p_drxoob_t;
+	};
 
 /*========================================*/
 
@@ -1451,12 +1401,12 @@ STRUCTS
 *
 * Used by DRX_CTRL_GET_OOB.
 */
-	typedef struct {
+	struct drxoob_status {
 		s32 frequency; /**< Frequency in Khz         */
-		drx_lock_status_t lock;	  /**< Lock status              */
+		enum drx_lock_status lock;	  /**< Lock status              */
 		u32 mer;		  /**< MER                      */
 		s32 symbol_rate_offset;	  /**< Symbolrate offset in ppm */
-	} drxoob_status_t, *pdrxoob_status_t;
+	};
 
 /*========================================*/
 
@@ -1466,12 +1416,12 @@ STRUCTS
 * Used by DRX_CTRL_SET_CFG and DRX_CTRL_GET_CFG.
 * A sort of nested drx_ctrl() functionality for device specific controls.
 */
-	typedef struct {
-		drx_cfg_type_t cfg_type;
+	struct drx_cfg {
+		u32 cfg_type;
 			  /**< Function identifier */
 		void *cfg_data;
 			  /**< Function data */
-	} drx_cfg_t, *pdrx_cfg_t;
+	};
 
 /*========================================*/
 
@@ -1480,21 +1430,20 @@ STRUCTS
 * MStart width [nr MCLK cycles] for serial MPEG output.
 */
 
-	typedef enum {
+	enum drxmpeg_str_width {
 		DRX_MPEG_STR_WIDTH_1,
 		DRX_MPEG_STR_WIDTH_8
-	} drxmpeg_str_width_t, *pdrxmpeg_str_width_t;
+	};
 
 /* CTRL CFG MPEG ouput */
 /**
-* \struct drx_cfg_mpeg_output_t
-* \brief Configuartion parameters for MPEG output control.
+* \struct struct drx_cfg_mpeg_output * \brief Configuartion parameters for MPEG output control.
 *
 * Used by DRX_CFG_MPEG_OUTPUT, in combination with DRX_CTRL_SET_CFG and
 * DRX_CTRL_GET_CFG.
 */
 
-	typedef struct {
+	struct drx_cfg_mpeg_output {
 		bool enable_mpeg_output;/**< If true, enable MPEG output      */
 		bool insert_rs_byte;	/**< If true, insert RS byte          */
 		bool enable_parallel;	/**< If true, parallel out otherwise
@@ -1510,41 +1459,21 @@ STRUCTS
 					     TS                               */
 		u32 bitrate;		/**< Maximum bitrate in b/s in case
 					     static clockrate is selected     */
-		drxmpeg_str_width_t width_str;
+		enum drxmpeg_str_width width_str;
 					/**< MPEG start width                 */
-	} drx_cfg_mpeg_output_t, *pdrx_cfg_mpeg_output_t;
-
-/* CTRL CFG SMA */
-/**
-* /struct drx_cfg_smaio_t
-* smart antenna i/o.
-*/
-	typedef enum drx_cfg_smaio_t {
-		DRX_SMA_OUTPUT = 0,
-		DRX_SMA_INPUT
-	} drx_cfg_smaio_t, *pdrx_cfg_smaio_t;
+	};
 
-/**
-* /struct drx_cfg_sma_t
-* Set smart antenna.
-*/
-	typedef struct {
-		drx_cfg_smaio_t io;
-		u16 ctrl_data;
-		bool smart_ant_inverted;
-	} drx_cfg_sma_t, *pdrx_cfg_sma_t;
 
 /*========================================*/
 
 /**
-* \struct drxi2c_data_t
-* \brief Data for I2C via 2nd or 3rd or etc I2C port.
+* \struct struct drxi2c_data * \brief Data for I2C via 2nd or 3rd or etc I2C port.
 *
 * Used by DRX_CTRL_I2C_READWRITE.
 * If port_nr is equal to primairy port_nr BSPI2C will be used.
 *
 */
-	typedef struct {
+	struct drxi2c_data {
 		u16 port_nr;	/**< I2C port number               */
 		struct i2c_device_addr *w_dev_addr;
 				/**< Write device address          */
@@ -1554,17 +1483,16 @@ STRUCTS
 				/**< Read device address           */
 		u16 r_count;	/**< Size of data to read in bytes */
 		u8 *r_data;	/**< Pointer to read buffer        */
-	} drxi2c_data_t, *pdrxi2c_data_t;
+	};
 
 /*========================================*/
 
 /**
-* \enum drx_aud_standard_t
-* \brief Audio standard identifier.
+* \enum enum drx_aud_standard * \brief Audio standard identifier.
 *
 * Used by DRX_CTRL_SET_AUD.
 */
-	typedef enum {
+	enum drx_aud_standard {
 		DRX_AUD_STANDARD_BTSC,	   /**< set BTSC standard (USA)       */
 		DRX_AUD_STANDARD_A2,	   /**< set A2-Korea FM Stereo        */
 		DRX_AUD_STANDARD_EIAJ,	   /**< set to Japanese FM Stereo     */
@@ -1588,35 +1516,33 @@ STRUCTS
 					   /**< Automatic Standard Detection  */
 		DRX_AUD_STANDARD_UNKNOWN = DRX_UNKNOWN
 					   /**< used as auto and for readback */
-	} drx_aud_standard_t, *pdrx_aud_standard_t;
+	};
 
-/* CTRL_AUD_GET_STATUS    - drx_aud_status_t */
+/* CTRL_AUD_GET_STATUS    - struct drx_aud_status */
 /**
-* \enum drx_aud_nicam_status_t
-* \brief Status of NICAM carrier.
+* \enum enum drx_aud_nicam_status * \brief Status of NICAM carrier.
 */
-	typedef enum {
+	enum drx_aud_nicam_status {
 		DRX_AUD_NICAM_DETECTED = 0,
 					  /**< NICAM carrier detected         */
 		DRX_AUD_NICAM_NOT_DETECTED,
 					  /**< NICAM carrier not detected     */
 		DRX_AUD_NICAM_BAD	  /**< NICAM carrier bad quality      */
-	} drx_aud_nicam_status_t, *pdrx_aud_nicam_status_t;
+	};
 
 /**
-* \struct drx_aud_status_t
-* \brief Audio status characteristics.
+* \struct struct drx_aud_status * \brief Audio status characteristics.
 */
-	typedef struct {
+	struct drx_aud_status {
 		bool stereo;		  /**< stereo detection               */
 		bool carrier_a;	  /**< carrier A detected             */
 		bool carrier_b;	  /**< carrier B detected             */
 		bool sap;		  /**< sap / bilingual detection      */
 		bool rds;		  /**< RDS data array present         */
-		drx_aud_nicam_status_t nicam_status;
+		enum drx_aud_nicam_status nicam_status;
 					  /**< status of NICAM carrier        */
 		s8 fm_ident;		  /**< FM Identification value        */
-	} drx_aud_status_t, *pdrx_aud_status_t;
+	};
 
 /* CTRL_AUD_READ_RDS       - DRXRDSdata_t */
 
@@ -1624,234 +1550,218 @@ STRUCTS
 * \struct DRXRDSdata_t
 * \brief Raw RDS data array.
 */
-	typedef struct {
+	struct drx_cfg_aud_rds {
 		bool valid;		  /**< RDS data validation            */
 		u16 data[18];		  /**< data from one RDS data array   */
-	} drx_cfg_aud_rds_t, *pdrx_cfg_aud_rds_t;
+	};
 
-/* DRX_CFG_AUD_VOLUME      - drx_cfg_aud_volume_t - set/get */
+/* DRX_CFG_AUD_VOLUME      - struct drx_cfg_aud_volume - set/get */
 /**
 * \enum DRXAudAVCDecayTime_t
 * \brief Automatic volume control configuration.
 */
-	typedef enum {
+	enum drx_aud_avc_mode {
 		DRX_AUD_AVC_OFF,	  /**< Automatic volume control off   */
 		DRX_AUD_AVC_DECAYTIME_8S, /**< level volume in  8 seconds     */
 		DRX_AUD_AVC_DECAYTIME_4S, /**< level volume in  4 seconds     */
 		DRX_AUD_AVC_DECAYTIME_2S, /**< level volume in  2 seconds     */
 		DRX_AUD_AVC_DECAYTIME_20MS/**< level volume in 20 millisec    */
-	} drx_aud_avc_mode_t, *pdrx_aud_avc_mode_t;
+	};
 
 /**
 * /enum DRXAudMaxAVCGain_t
 * /brief Automatic volume control max gain in audio baseband.
 */
-	typedef enum {
+	enum drx_aud_avc_max_gain {
 		DRX_AUD_AVC_MAX_GAIN_0DB, /**< maximum AVC gain  0 dB         */
 		DRX_AUD_AVC_MAX_GAIN_6DB, /**< maximum AVC gain  6 dB         */
 		DRX_AUD_AVC_MAX_GAIN_12DB /**< maximum AVC gain 12 dB         */
-	} drx_aud_avc_max_gain_t, *pdrx_aud_avc_max_gain_t;
+	};
 
 /**
 * /enum DRXAudMaxAVCAtten_t
 * /brief Automatic volume control max attenuation in audio baseband.
 */
-	typedef enum {
+	enum drx_aud_avc_max_atten {
 		DRX_AUD_AVC_MAX_ATTEN_12DB,
 					  /**< maximum AVC attenuation 12 dB  */
 		DRX_AUD_AVC_MAX_ATTEN_18DB,
 					  /**< maximum AVC attenuation 18 dB  */
 		DRX_AUD_AVC_MAX_ATTEN_24DB/**< maximum AVC attenuation 24 dB  */
-	} drx_aud_avc_max_atten_t, *pdrx_aud_avc_max_atten_t;
+	};
 /**
-* \struct drx_cfg_aud_volume_t
-* \brief Audio volume configuration.
+* \struct struct drx_cfg_aud_volume * \brief Audio volume configuration.
 */
-	typedef struct {
+	struct drx_cfg_aud_volume {
 		bool mute;		  /**< mute overrides volume setting  */
 		s16 volume;		  /**< volume, range -114 to 12 dB    */
-		drx_aud_avc_mode_t avc_mode;  /**< AVC auto volume control mode   */
+		enum drx_aud_avc_mode avc_mode;  /**< AVC auto volume control mode   */
 		u16 avc_ref_level;	  /**< AVC reference level            */
-		drx_aud_avc_max_gain_t avc_max_gain;
+		enum drx_aud_avc_max_gain avc_max_gain;
 					  /**< AVC max gain selection         */
-		drx_aud_avc_max_atten_t avc_max_atten;
+		enum drx_aud_avc_max_atten avc_max_atten;
 					  /**< AVC max attenuation selection  */
 		s16 strength_left;	  /**< quasi-peak, left speaker       */
 		s16 strength_right;	  /**< quasi-peak, right speaker      */
-	} drx_cfg_aud_volume_t, *pdrx_cfg_aud_volume_t;
+	};
 
-/* DRX_CFG_I2S_OUTPUT      - drx_cfg_i2s_output_t - set/get */
+/* DRX_CFG_I2S_OUTPUT      - struct drx_cfg_i2s_output - set/get */
 /**
-* \enum drxi2s_mode_t
-* \brief I2S output mode.
+* \enum enum drxi2s_mode * \brief I2S output mode.
 */
-	typedef enum {
+	enum drxi2s_mode {
 		DRX_I2S_MODE_MASTER,	  /**< I2S is in master mode          */
 		DRX_I2S_MODE_SLAVE	  /**< I2S is in slave mode           */
-	} drxi2s_mode_t, *pdrxi2s_mode_t;
+	};
 
 /**
-* \enum drxi2s_word_length_t
-* \brief Width of I2S data.
+* \enum enum drxi2s_word_length * \brief Width of I2S data.
 */
-	typedef enum {
+	enum drxi2s_word_length {
 		DRX_I2S_WORDLENGTH_32 = 0,/**< I2S data is 32 bit wide        */
 		DRX_I2S_WORDLENGTH_16 = 1 /**< I2S data is 16 bit wide        */
-	} drxi2s_word_length_t, *pdrxi2s_word_length_t;
+	};
 
 /**
-* \enum drxi2s_format_t
-* \brief Data wordstrobe alignment for I2S.
+* \enum enum drxi2s_format * \brief Data wordstrobe alignment for I2S.
 */
-	typedef enum {
+	enum drxi2s_format {
 		DRX_I2S_FORMAT_WS_WITH_DATA,
 				    /**< I2S data and wordstrobe are aligned  */
 		DRX_I2S_FORMAT_WS_ADVANCED
 				    /**< I2S data one cycle after wordstrobe  */
-	} drxi2s_format_t, *pdrxi2s_format_t;
+	};
 
 /**
-* \enum drxi2s_polarity_t
-* \brief Polarity of I2S data.
+* \enum enum drxi2s_polarity * \brief Polarity of I2S data.
 */
-	typedef enum {
+	enum drxi2s_polarity {
 		DRX_I2S_POLARITY_RIGHT,/**< wordstrobe - right high, left low */
 		DRX_I2S_POLARITY_LEFT  /**< wordstrobe - right low, left high */
-	} drxi2s_polarity_t, *pdrxi2s_polarity_t;
+	};
 
 /**
-* \struct drx_cfg_i2s_output_t
-* \brief I2S output configuration.
+* \struct struct drx_cfg_i2s_output * \brief I2S output configuration.
 */
-	typedef struct {
+	struct drx_cfg_i2s_output {
 		bool output_enable;	  /**< I2S output enable              */
 		u32 frequency;	  /**< range from 8000-48000 Hz       */
-		drxi2s_mode_t mode;	  /**< I2S mode, master or slave      */
-		drxi2s_word_length_t word_length;
+		enum drxi2s_mode mode;	  /**< I2S mode, master or slave      */
+		enum drxi2s_word_length word_length;
 					  /**< I2S wordlength, 16 or 32 bits  */
-		drxi2s_polarity_t polarity;/**< I2S wordstrobe polarity        */
-		drxi2s_format_t format;	  /**< I2S wordstrobe delay to data   */
-	} drx_cfg_i2s_output_t, *pdrx_cfg_i2s_output_t;
+		enum drxi2s_polarity polarity;/**< I2S wordstrobe polarity        */
+		enum drxi2s_format format;	  /**< I2S wordstrobe delay to data   */
+	};
 
 /* ------------------------------expert interface-----------------------------*/
 /**
-* /enum drx_aud_fm_deemphasis_t
-* setting for FM-Deemphasis in audio demodulator.
+* /enum enum drx_aud_fm_deemphasis * setting for FM-Deemphasis in audio demodulator.
 *
 */
-	typedef enum {
+	enum drx_aud_fm_deemphasis {
 		DRX_AUD_FM_DEEMPH_50US,
 		DRX_AUD_FM_DEEMPH_75US,
 		DRX_AUD_FM_DEEMPH_OFF
-	} drx_aud_fm_deemphasis_t, *pdrx_aud_fm_deemphasis_t;
+	};
 
 /**
 * /enum DRXAudDeviation_t
 * setting for deviation mode in audio demodulator.
 *
 */
-	typedef enum {
+	enum drx_cfg_aud_deviation {
 		DRX_AUD_DEVIATION_NORMAL,
 		DRX_AUD_DEVIATION_HIGH
-	} drx_cfg_aud_deviation_t, *pdrx_cfg_aud_deviation_t;
+	};
 
 /**
-* /enum drx_no_carrier_option_t
-* setting for carrier, mute/noise.
+* /enum enum drx_no_carrier_option * setting for carrier, mute/noise.
 *
 */
-	typedef enum {
+	enum drx_no_carrier_option {
 		DRX_NO_CARRIER_MUTE,
 		DRX_NO_CARRIER_NOISE
-	} drx_no_carrier_option_t, *pdrx_no_carrier_option_t;
+	};
 
 /**
 * \enum DRXAudAutoSound_t
 * \brief Automatic Sound
 */
-	typedef enum {
+	enum drx_cfg_aud_auto_sound {
 		DRX_AUD_AUTO_SOUND_OFF = 0,
 		DRX_AUD_AUTO_SOUND_SELECT_ON_CHANGE_ON,
 		DRX_AUD_AUTO_SOUND_SELECT_ON_CHANGE_OFF
-	} drx_cfg_aud_auto_sound_t, *pdrx_cfg_aud_auto_sound_t;
+	};
 
 /**
 * \enum DRXAudASSThres_t
 * \brief Automatic Sound Select Thresholds
 */
-	typedef struct {
+	struct drx_cfg_aud_ass_thres {
 		u16 a2;	/* A2 Threshold for ASS configuration */
 		u16 btsc;	/* BTSC Threshold for ASS configuration */
 		u16 nicam;	/* Nicam Threshold for ASS configuration */
-	} drx_cfg_aud_ass_thres_t, *pdrx_cfg_aud_ass_thres_t;
+	};
 
 /**
-* \struct drx_aud_carrier_t
-* \brief Carrier detection related parameters
+* \struct struct drx_aud_carrier * \brief Carrier detection related parameters
 */
-	typedef struct {
+	struct drx_aud_carrier {
 		u16 thres;	/* carrier detetcion threshold for primary carrier (A) */
-		drx_no_carrier_option_t opt;	/* Mute or noise at no carrier detection (A) */
+		enum drx_no_carrier_option opt;	/* Mute or noise at no carrier detection (A) */
 		s32 shift;	/* DC level of incoming signal (A) */
 		s32 dco;	/* frequency adjustment (A) */
-	} drx_aud_carrier_t, *p_drx_cfg_aud_carrier_t;
+	};
 
 /**
-* \struct drx_cfg_aud_carriers_t
-* \brief combining carrier A & B to one struct
+* \struct struct drx_cfg_aud_carriers * \brief combining carrier A & B to one struct
 */
-	typedef struct {
-		drx_aud_carrier_t a;
-		drx_aud_carrier_t b;
-	} drx_cfg_aud_carriers_t, *pdrx_cfg_aud_carriers_t;
+	struct drx_cfg_aud_carriers {
+		struct drx_aud_carrier a;
+		struct drx_aud_carrier b;
+	};
 
 /**
-* /enum drx_aud_i2s_src_t
-* Selection of audio source
+* /enum enum drx_aud_i2s_src * Selection of audio source
 */
-	typedef enum {
+	enum drx_aud_i2s_src {
 		DRX_AUD_SRC_MONO,
 		DRX_AUD_SRC_STEREO_OR_AB,
 		DRX_AUD_SRC_STEREO_OR_A,
-		DRX_AUD_SRC_STEREO_OR_B
-	} drx_aud_i2s_src_t, *pdrx_aud_i2s_src_t;
+		DRX_AUD_SRC_STEREO_OR_B};
 
 /**
-* \enum drx_aud_i2s_matrix_t
-* \brief Used for selecting I2S output.
+* \enum enum drx_aud_i2s_matrix * \brief Used for selecting I2S output.
 */
-	typedef enum {
+	enum drx_aud_i2s_matrix {
 		DRX_AUD_I2S_MATRIX_A_MONO,
 					/**< A sound only, stereo or mono     */
 		DRX_AUD_I2S_MATRIX_B_MONO,
 					/**< B sound only, stereo or mono     */
 		DRX_AUD_I2S_MATRIX_STEREO,
 					/**< A+B sound, transparant           */
-		DRX_AUD_I2S_MATRIX_MONO	/**< A+B mixed to mono sum, (L+R)/2   */
-	} drx_aud_i2s_matrix_t, *pdrx_aud_i2s_matrix_t;
+		DRX_AUD_I2S_MATRIX_MONO	/**< A+B mixed to mono sum, (L+R)/2   */};
 
 /**
-* /enum drx_aud_fm_matrix_t
-* setting for FM-Matrix in audio demodulator.
+* /enum enum drx_aud_fm_matrix * setting for FM-Matrix in audio demodulator.
 *
 */
-	typedef enum {
+	enum drx_aud_fm_matrix {
 		DRX_AUD_FM_MATRIX_NO_MATRIX,
 		DRX_AUD_FM_MATRIX_GERMAN,
 		DRX_AUD_FM_MATRIX_KOREAN,
 		DRX_AUD_FM_MATRIX_SOUND_A,
-		DRX_AUD_FM_MATRIX_SOUND_B
-	} drx_aud_fm_matrix_t, *pdrx_aud_fm_matrix_t;
+		DRX_AUD_FM_MATRIX_SOUND_B};
 
 /**
 * \struct DRXAudMatrices_t
 * \brief Mixer settings
 */
-	typedef struct {
-		drx_aud_i2s_src_t source_i2s;
-		drx_aud_i2s_matrix_t matrix_i2s;
-		drx_aud_fm_matrix_t matrix_fm;
-	} drx_cfg_aud_mixer_t, *pdrx_cfg_aud_mixer_t;
+struct drx_cfg_aud_mixer {
+	enum drx_aud_i2s_src source_i2s;
+	enum drx_aud_i2s_matrix matrix_i2s;
+	enum drx_aud_fm_matrix matrix_fm;
+};
 
 /**
 * \enum DRXI2SVidSync_t
@@ -1859,76 +1769,68 @@ STRUCTS
 * AUTO_1 and AUTO_2 are for automatic video standard detection with preference
 * for NTSC or Monochrome, because the frequencies are too close (59.94 & 60 Hz)
 */
-	typedef enum {
+	enum drx_cfg_aud_av_sync {
 		DRX_AUD_AVSYNC_OFF,/**< audio/video synchronization is off   */
 		DRX_AUD_AVSYNC_NTSC,
 				   /**< it is an NTSC system                 */
 		DRX_AUD_AVSYNC_MONOCHROME,
 				   /**< it is a MONOCHROME system            */
 		DRX_AUD_AVSYNC_PAL_SECAM
-				   /**< it is a PAL/SECAM system             */
-	} drx_cfg_aud_av_sync_t, *pdrx_cfg_aud_av_sync_t;
+				   /**< it is a PAL/SECAM system             */};
 
 /**
-* \struct drx_cfg_aud_prescale_t
-* \brief Prescalers
+* \struct struct drx_cfg_aud_prescale * \brief Prescalers
 */
-	typedef struct {
-		u16 fm_deviation;
-		s16 nicam_gain;
-	} drx_cfg_aud_prescale_t, *pdrx_cfg_aud_prescale_t;
+struct drx_cfg_aud_prescale {
+	u16 fm_deviation;
+	s16 nicam_gain;
+};
 
 /**
-* \struct drx_aud_beep_t
-* \brief Beep
+* \struct struct drx_aud_beep * \brief Beep
 */
-	typedef struct {
-		s16 volume;	/* dB */
-		u16 frequency;	/* Hz */
-		bool mute;
-	} drx_aud_beep_t, *pdrx_aud_beep_t;
+struct drx_aud_beep {
+	s16 volume;	/* dB */
+	u16 frequency;	/* Hz */
+	bool mute;
+};
 
 /**
-* \enum drx_aud_btsc_detect_t
-* \brief BTSC detetcion mode
+* \enum enum drx_aud_btsc_detect * \brief BTSC detetcion mode
 */
-	typedef enum {
+	enum drx_aud_btsc_detect {
 		DRX_BTSC_STEREO,
-		DRX_BTSC_MONO_AND_SAP
-	} drx_aud_btsc_detect_t, *pdrx_aud_btsc_detect_t;
-
-/**
-* \struct drx_aud_data_t
-* \brief Audio data structure
-*/
-	typedef struct {
-		/* audio storage */
-		bool audio_is_active;
-		drx_aud_standard_t audio_standard;
-		drx_cfg_i2s_output_t i2sdata;
-		drx_cfg_aud_volume_t volume;
-		drx_cfg_aud_auto_sound_t auto_sound;
-		drx_cfg_aud_ass_thres_t ass_thresholds;
-		drx_cfg_aud_carriers_t carriers;
-		drx_cfg_aud_mixer_t mixer;
-		drx_cfg_aud_deviation_t deviation;
-		drx_cfg_aud_av_sync_t av_sync;
-		drx_cfg_aud_prescale_t prescale;
-		drx_aud_fm_deemphasis_t deemph;
-		drx_aud_btsc_detect_t btsc_detect;
-		/* rds */
-		u16 rds_data_counter;
-		bool rds_data_present;
-	} drx_aud_data_t, *pdrx_aud_data_t;
-
-/**
-* \enum drx_qam_lock_range_t
-* \brief QAM lock range mode
-*/
-	typedef enum {
+		DRX_BTSC_MONO_AND_SAP};
+
+/**
+* \struct struct drx_aud_data * \brief Audio data structure
+*/
+struct drx_aud_data {
+	/* audio storage */
+	bool audio_is_active;
+	enum drx_aud_standard audio_standard;
+	struct drx_cfg_i2s_output i2sdata;
+	struct drx_cfg_aud_volume volume;
+	enum drx_cfg_aud_auto_sound auto_sound;
+	struct drx_cfg_aud_ass_thres ass_thresholds;
+	struct drx_cfg_aud_carriers carriers;
+	struct drx_cfg_aud_mixer mixer;
+	enum drx_cfg_aud_deviation deviation;
+	enum drx_cfg_aud_av_sync av_sync;
+	struct drx_cfg_aud_prescale prescale;
+	enum drx_aud_fm_deemphasis deemph;
+	enum drx_aud_btsc_detect btsc_detect;
+	/* rds */
+	u16 rds_data_counter;
+	bool rds_data_present;
+};
+
+/**
+* \enum enum drx_qam_lock_range * \brief QAM lock range mode
+*/
+	enum drx_qam_lock_range {
 		DRX_QAM_LOCKRANGE_NORMAL,
-		DRX_QAM_LOCKRANGE_EXTENDED
-	} drx_qam_lock_range_t, *pdrx_qam_lock_range_t;
+		DRX_QAM_LOCKRANGE_EXTENDED};
 
 /*============================================================================*/
 /*============================================================================*/
@@ -1944,101 +1846,98 @@ STRUCTS
 
 /* Write block of data to device */
 	typedef int(*drx_write_block_func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						   dr_xaddr_t addr,	/* address of register/memory   */
+						   u32 addr,	/* address of register/memory   */
 						   u16 datasize,	/* size of data in bytes        */
 						   u8 *data,	/* data to send                 */
-						   dr_xflags_t flags);
+						   u32 flags);
 
 /* Read block of data from device */
 	typedef int(*drx_read_block_func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						  dr_xaddr_t addr,	/* address of register/memory   */
+						  u32 addr,	/* address of register/memory   */
 						  u16 datasize,	/* size of data in bytes        */
 						  u8 *data,	/* receive buffer               */
-						  dr_xflags_t flags);
+						  u32 flags);
 
 /* Write 8-bits value to device */
 	typedef int(*drx_write_reg8func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						  dr_xaddr_t addr,	/* address of register/memory   */
+						  u32 addr,	/* address of register/memory   */
 						  u8 data,	/* data to send                 */
-						  dr_xflags_t flags);
+						  u32 flags);
 
 /* Read 8-bits value to device */
 	typedef int(*drx_read_reg8func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						 dr_xaddr_t addr,	/* address of register/memory   */
+						 u32 addr,	/* address of register/memory   */
 						 u8 *data,	/* receive buffer               */
-						 dr_xflags_t flags);
+						 u32 flags);
 
 /* Read modify write 8-bits value to device */
 	typedef int(*drx_read_modify_write_reg8func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device       */
-							    dr_xaddr_t waddr,	/* write address of register   */
-							    dr_xaddr_t raddr,	/* read  address of register   */
+							    u32 waddr,	/* write address of register   */
+							    u32 raddr,	/* read  address of register   */
 							    u8 wdata,	/* data to write               */
 							    u8 *rdata);	/* data to read                */
 
 /* Write 16-bits value to device */
 	typedef int(*drx_write_reg16func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						   dr_xaddr_t addr,	/* address of register/memory   */
+						   u32 addr,	/* address of register/memory   */
 						   u16 data,	/* data to send                 */
-						   dr_xflags_t flags);
+						   u32 flags);
 
 /* Read 16-bits value to device */
 	typedef int(*drx_read_reg16func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						  dr_xaddr_t addr,	/* address of register/memory   */
+						  u32 addr,	/* address of register/memory   */
 						  u16 *data,	/* receive buffer               */
-						  dr_xflags_t flags);
+						  u32 flags);
 
 /* Read modify write 16-bits value to device */
 	typedef int(*drx_read_modify_write_reg16func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device       */
-							     dr_xaddr_t waddr,	/* write address of register   */
-							     dr_xaddr_t raddr,	/* read  address of register   */
+							     u32 waddr,	/* write address of register   */
+							     u32 raddr,	/* read  address of register   */
 							     u16 wdata,	/* data to write               */
 							     u16 *rdata);	/* data to read                */
 
 /* Write 32-bits value to device */
 	typedef int(*drx_write_reg32func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						   dr_xaddr_t addr,	/* address of register/memory   */
+						   u32 addr,	/* address of register/memory   */
 						   u32 data,	/* data to send                 */
-						   dr_xflags_t flags);
+						   u32 flags);
 
 /* Read 32-bits value to device */
 	typedef int(*drx_read_reg32func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						  dr_xaddr_t addr,	/* address of register/memory   */
+						  u32 addr,	/* address of register/memory   */
 						  u32 *data,	/* receive buffer               */
-						  dr_xflags_t flags);
+						  u32 flags);
 
 /* Read modify write 32-bits value to device */
 	typedef int(*drx_read_modify_write_reg32func_t) (struct i2c_device_addr *dev_addr,	/* address of I2C device       */
-							     dr_xaddr_t waddr,	/* write address of register   */
-							     dr_xaddr_t raddr,	/* read  address of register   */
+							     u32 waddr,	/* write address of register   */
+							     u32 raddr,	/* read  address of register   */
 							     u32 wdata,	/* data to write               */
 							     u32 *rdata);	/* data to read                */
 
 /**
-* \struct drx_access_func_t
-* \brief Interface to an access protocol.
-*/
-	typedef struct {
-		pdrx_version_t protocolVersion;
-		drx_write_block_func_t write_block_func;
-		drx_read_block_func_t read_block_func;
-		drx_write_reg8func_t write_reg8func;
-		drx_read_reg8func_t read_reg8func;
-		drx_read_modify_write_reg8func_t read_modify_write_reg8func;
-		drx_write_reg16func_t write_reg16func;
-		drx_read_reg16func_t read_reg16func;
-		drx_read_modify_write_reg16func_t read_modify_write_reg16func;
-		drx_write_reg32func_t write_reg32func;
-		drx_read_reg32func_t read_reg32func;
-		drx_read_modify_write_reg32func_t read_modify_write_reg32func;
-	} drx_access_func_t, *pdrx_access_func_t;
+* \struct struct drx_access_func * \brief Interface to an access protocol.
+*/
+struct drx_access_func {
+	struct drx_version *protocolVersion;
+	drx_write_block_func_t write_block_func;
+	drx_read_block_func_t read_block_func;
+	drx_write_reg8func_t write_reg8func;
+	drx_read_reg8func_t read_reg8func;
+	drx_read_modify_write_reg8func_t read_modify_write_reg8func;
+	drx_write_reg16func_t write_reg16func;
+	drx_read_reg16func_t read_reg16func;
+	drx_read_modify_write_reg16func_t read_modify_write_reg16func;
+	drx_write_reg32func_t write_reg32func;
+	drx_read_reg32func_t read_reg32func;
+	drx_read_modify_write_reg32func_t read_modify_write_reg32func;
+};
 
 /* Register address and data for register dump function */
-	typedef struct {
-
-		dr_xaddr_t address;
-		u32 data;
-
-	} drx_reg_dump_t, *p_drx_reg_dump_t;
+struct drx_reg_dump {
+	u32 address;
+	u32 data;
+};
 
 /*============================================================================*/
 /*============================================================================*/
@@ -2047,17 +1946,16 @@ STRUCTS
 /*============================================================================*/
 
 /**
-* \struct drx_common_attr_t
-* \brief Set of common attributes, shared by all DRX devices.
+* \struct struct drx_common_attr * \brief Set of common attributes, shared by all DRX devices.
 */
-	typedef struct {
+	struct drx_common_attr {
 		/* Microcode (firmware) attributes */
 		u8 *microcode;   /**< Pointer to microcode image.           */
 		u16 microcode_size;
 				   /**< Size of microcode image in bytes.     */
 		bool verify_microcode;
 				   /**< Use microcode verify or not.          */
-		drx_mc_version_rec_t mcversion;
+		struct drx_mc_version_rec mcversion;
 				   /**< Version record of microcode from file */
 
 		/* Clocks and tuner attributes */
@@ -2073,13 +1971,13 @@ STRUCTS
 				     /**< Mirror IF frequency spectrum or not.*/
 
 		/* Initial MPEG output attributes */
-		drx_cfg_mpeg_output_t mpeg_cfg;
+		struct drx_cfg_mpeg_output mpeg_cfg;
 				     /**< MPEG configuration                  */
 
 		bool is_opened;     /**< if true instance is already opened. */
 
 		/* Channel scan */
-		p_drx_scan_param_t scan_param;
+		struct drx_scan_param *scan_param;
 				      /**< scan parameters                    */
 		u16 scan_freq_plan_index;
 				      /**< next index in freq plan            */
@@ -2097,14 +1995,14 @@ STRUCTS
 		/* Channel scan - parameters for default DTV scan function in core driver  */
 		u16 scan_demod_lock_timeout;
 					 /**< millisecs to wait for lock      */
-		drx_lock_status_t scan_desired_lock;
+		enum drx_lock_status scan_desired_lock;
 				      /**< lock requirement for channel found */
 		/* scan_active can be used by SetChannel to decide how to program the tuner,
 		   fast or slow (but stable). Usually fast during scan. */
 		bool scan_active;    /**< true when scan routines are active */
 
 		/* Power management */
-		drx_power_mode_t current_power_mode;
+		enum drx_power_mode current_power_mode;
 				      /**< current power management mode      */
 
 		/* Tuner */
@@ -2117,7 +2015,7 @@ STRUCTS
 		bool tuner_if_agc_pol; /**< if true invert IF AGC polarity     */
 		bool tuner_slow_mode; /**< if true invert IF AGC polarity     */
 
-		drx_channel_t current_channel;
+		struct drx_channel current_channel;
 				      /**< current channel parameters         */
 		enum drx_standard current_standard;
 				      /**< current standard selection         */
@@ -2127,51 +2025,47 @@ STRUCTS
 				      /**< standard in DI cache if available  */
 		bool use_bootloader; /**< use bootloader in open             */
 		u32 capabilities;   /**< capabilities flags                 */
-		u32 product_id;      /**< product ID inc. metal fix number   */
-
-	} drx_common_attr_t, *pdrx_common_attr_t;
+		u32 product_id;      /**< product ID inc. metal fix number   */};
 
 /*
 * Generic functions for DRX devices.
 */
-	typedef struct drx_demod_instance_s *pdrx_demod_instance_t;
 
-	typedef int(*drx_open_func_t) (pdrx_demod_instance_t demod);
-	typedef int(*drx_close_func_t) (pdrx_demod_instance_t demod);
-	typedef int(*drx_ctrl_func_t) (pdrx_demod_instance_t demod,
+struct drx_demod_instance;
+
+	typedef int(*drx_open_func_t) (struct drx_demod_instance *demod);
+	typedef int(*drx_close_func_t) (struct drx_demod_instance *demod);
+	typedef int(*drx_ctrl_func_t) (struct drx_demod_instance *demod,
 					     u32 ctrl,
 					     void *ctrl_data);
 
 /**
-* \struct drx_demod_func_t
-* \brief A stucture containing all functions of a demodulator.
+* \struct struct drx_demod_func * \brief A stucture containing all functions of a demodulator.
 */
-	typedef struct {
+	struct drx_demod_func {
 		u32 type_id;		 /**< Device type identifier.      */
 		drx_open_func_t open_func;	 /**< Pointer to Open() function.  */
 		drx_close_func_t close_func;/**< Pointer to Close() function. */
-		drx_ctrl_func_t ctrl_func;	 /**< Pointer to Ctrl() function.  */
-	} drx_demod_func_t, *pdrx_demod_func_t;
+		drx_ctrl_func_t ctrl_func;	 /**< Pointer to Ctrl() function.  */};
 
 /**
-* \struct drx_demod_instance_t
-* \brief Top structure of demodulator instance.
+* \struct struct drx_demod_instance * \brief Top structure of demodulator instance.
 */
-	typedef struct drx_demod_instance_s {
+	struct drx_demod_instance {
 		/* type specific demodulator data */
-		pdrx_demod_func_t my_demod_funct;
+		struct drx_demod_func *my_demod_funct;
 				    /**< demodulator functions                */
-		pdrx_access_func_t my_access_funct;
+		struct drx_access_func *my_access_funct;
 				    /**< data access protocol functions       */
 		struct tuner_instance *my_tuner;
 				    /**< tuner instance,if NULL then baseband */
 		struct i2c_device_addr *my_i2c_dev_addr;
 				    /**< i2c address and device identifier    */
-		pdrx_common_attr_t my_common_attr;
+		struct drx_common_attr *my_common_attr;
 				    /**< common DRX attributes                */
 		void *my_ext_attr;    /**< device specific attributes           */
 		/* generic demodulator data */
-	} drx_demod_instance_t;
+	};
 
 /*-------------------------------------------------------------------------
 MACROS
@@ -2828,7 +2722,7 @@ Access macros
 
 #define DRX_ACCESSMACRO_SET(demod, value, cfg_name, data_type)             \
    do {                                                                    \
-      drx_cfg_t config;                                                     \
+      struct drx_cfg config;                                                     \
       data_type cfg_data;                                                    \
       config.cfg_type = cfg_name;                                            \
       config.cfg_data = &cfg_data;                                           \
@@ -2839,7 +2733,7 @@ Access macros
 #define DRX_ACCESSMACRO_GET(demod, value, cfg_name, data_type, error_value) \
    do {                                                                    \
       int cfg_status;                                               \
-      drx_cfg_t    config;                                                  \
+      struct drx_cfg config;                                                  \
       data_type    cfg_data;                                                 \
       config.cfg_type = cfg_name;                                            \
       config.cfg_data = &cfg_data;                                           \
@@ -2869,21 +2763,21 @@ Access macros
    DRX_ACCESSMACRO_GET((d), (x), DRX_XS_CFG_PRESET, char*, "ERROR")
 
 #define DRX_SET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_SET((d), (x), \
-	 DRX_XS_CFG_AUD_BTSC_DETECT, drx_aud_btsc_detect_t)
+	 DRX_XS_CFG_AUD_BTSC_DETECT, enum drx_aud_btsc_detect)
 #define DRX_GET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_GET((d), (x), \
-	 DRX_XS_CFG_AUD_BTSC_DETECT, drx_aud_btsc_detect_t, DRX_UNKNOWN)
+	 DRX_XS_CFG_AUD_BTSC_DETECT, enum drx_aud_btsc_detect, DRX_UNKNOWN)
 
 #define DRX_SET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_SET((d), (x), \
-	 DRX_XS_CFG_QAM_LOCKRANGE, drx_qam_lock_range_t)
+	 DRX_XS_CFG_QAM_LOCKRANGE, enum drx_qam_lock_range)
 #define DRX_GET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_GET((d), (x), \
-	 DRX_XS_CFG_QAM_LOCKRANGE, drx_qam_lock_range_t, DRX_UNKNOWN)
+	 DRX_XS_CFG_QAM_LOCKRANGE, enum drx_qam_lock_range, DRX_UNKNOWN)
 
 /**
 * \brief Macro to check if std is an ATV standard
 * \retval true std is an ATV standard
 * \retval false std is an ATV standard
 */
-#define DRX_ISATVSTD(std) (( (std) == DRX_STANDARD_PAL_SECAM_BG) || \
+#define DRX_ISATVSTD(std) (((std) == DRX_STANDARD_PAL_SECAM_BG) || \
 			      ((std) == DRX_STANDARD_PAL_SECAM_DK) || \
 			      ((std) == DRX_STANDARD_PAL_SECAM_I) || \
 			      ((std) == DRX_STANDARD_PAL_SECAM_L) || \
@@ -2896,7 +2790,7 @@ Access macros
 * \retval true std is an QAM standards
 * \retval false std is an QAM standards
 */
-#define DRX_ISQAMSTD(std) (( (std) == DRX_STANDARD_ITU_A) || \
+#define DRX_ISQAMSTD(std) (((std) == DRX_STANDARD_ITU_A) || \
 			      ((std) == DRX_STANDARD_ITU_B) || \
 			      ((std) == DRX_STANDARD_ITU_C) || \
 			      ((std) == DRX_STANDARD_ITU_D))
@@ -2919,15 +2813,15 @@ Access macros
 Exported FUNCTIONS
 -------------------------------------------------------------------------*/
 
-	int drx_init(pdrx_demod_instance_t demods[]);
+	int drx_init(struct drx_demod_instance *demods[]);
 
 	int drx_term(void);
 
-	int drx_open(pdrx_demod_instance_t demod);
+	int drx_open(struct drx_demod_instance *demod);
 
-	int drx_close(pdrx_demod_instance_t demod);
+	int drx_close(struct drx_demod_instance *demod);
 
-	int drx_ctrl(pdrx_demod_instance_t demod,
+	int drx_ctrl(struct drx_demod_instance *demod,
 			     u32 ctrl, void *ctrl_data);
 
 /*-------------------------------------------------------------------------
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 24f84e5d5bd0..fc727d9b99c3 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -586,9 +586,9 @@ DEFINES
 /*-----------------------------------------------------------------------------
 STATIC VARIABLES
 ----------------------------------------------------------------------------*/
-int drxj_open(pdrx_demod_instance_t demod);
-int drxj_close(pdrx_demod_instance_t demod);
-int drxj_ctrl(pdrx_demod_instance_t demod,
+int drxj_open(struct drx_demod_instance *demod);
+int drxj_close(struct drx_demod_instance *demod);
+int drxj_ctrl(struct drx_demod_instance *demod,
 		      u32 ctrl, void *ctrl_data);
 
 /*-----------------------------------------------------------------------------
@@ -599,59 +599,59 @@ GLOBAL VARIABLES
  */
 
 static int drxj_dap_read_block(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
+				      u32 addr,
 				      u16 datasize,
-				      u8 *data, dr_xflags_t flags);
+				      u8 *data, u32 flags);
 
 static int drxj_dap_read_modify_write_reg8(struct i2c_device_addr *dev_addr,
-						dr_xaddr_t waddr,
-						dr_xaddr_t raddr,
+						u32 waddr,
+						u32 raddr,
 						u8 wdata, u8 *rdata);
 
 static int drxj_dap_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
-						 dr_xaddr_t waddr,
-						 dr_xaddr_t raddr,
+						 u32 waddr,
+						 u32 raddr,
 						 u16 wdata, u16 *rdata);
 
 static int drxj_dap_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
-						 dr_xaddr_t waddr,
-						 dr_xaddr_t raddr,
+						 u32 waddr,
+						 u32 raddr,
 						 u32 wdata, u32 *rdata);
 
 static int drxj_dap_read_reg8(struct i2c_device_addr *dev_addr,
-				     dr_xaddr_t addr,
-				     u8 *data, dr_xflags_t flags);
+				     u32 addr,
+				     u8 *data, u32 flags);
 
 static int drxj_dap_read_reg16(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
-				      u16 *data, dr_xflags_t flags);
+				      u32 addr,
+				      u16 *data, u32 flags);
 
 static int drxj_dap_read_reg32(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
-				      u32 *data, dr_xflags_t flags);
+				      u32 addr,
+				      u32 *data, u32 flags);
 
 static int drxj_dap_write_block(struct i2c_device_addr *dev_addr,
-				       dr_xaddr_t addr,
+				       u32 addr,
 				       u16 datasize,
-				       u8 *data, dr_xflags_t flags);
+				       u8 *data, u32 flags);
 
 static int drxj_dap_write_reg8(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
-				      u8 data, dr_xflags_t flags);
+				      u32 addr,
+				      u8 data, u32 flags);
 
 static int drxj_dap_write_reg16(struct i2c_device_addr *dev_addr,
-				       dr_xaddr_t addr,
-				       u16 data, dr_xflags_t flags);
+				       u32 addr,
+				       u16 data, u32 flags);
 
 static int drxj_dap_write_reg32(struct i2c_device_addr *dev_addr,
-				       dr_xaddr_t addr,
-				       u32 data, dr_xflags_t flags);
+				       u32 addr,
+				       u32 data, u32 flags);
 
 /* The version structure of this protocol implementation */
 char drx_dap_drxj_module_name[] = "DRXJ Data Access Protocol";
 char drx_dap_drxj_version_text[] = "0.0.0";
 
-drx_version_t drx_dap_drxj_version = {
+struct drx_version drx_dap_drxj_version = {
 	DRX_MODULE_DAP,	      /**< type identifier of the module  */
 	drx_dap_drxj_module_name, /**< name or description of module  */
 
@@ -662,7 +662,7 @@ drx_version_t drx_dap_drxj_version = {
 };
 
 /* The structure containing the protocol interface */
-drx_access_func_t drx_dap_drxj_funct_g = {
+struct drx_access_func drx_dap_drxj_funct_g = {
 	&drx_dap_drxj_version,
 	drxj_dap_write_block,	/* Supported       */
 	drxj_dap_read_block,	/* Supported       */
@@ -681,7 +681,7 @@ drx_access_func_t drx_dap_drxj_funct_g = {
 * /var DRXJ_Func_g
 * /brief The driver functions of the drxj
 */
-drx_demod_func_t drxj_functions_g = {
+struct drx_demod_func drxj_functions_g = {
 	DRXJ_TYPE_ID,
 	drxj_open,
 	drxj_close,
@@ -848,7 +848,7 @@ drxj_data_t drxj_data_g = {
 	 "01234567890"		/* human readable version device specific code  */
 	 },
 	{
-	 {			/* drx_version_t for microcode                   */
+	 {			/* struct drx_version for microcode                   */
 	  DRX_MODULE_UNKNOWN,
 	  (char *)(NULL),
 	  0,
@@ -856,7 +856,7 @@ drxj_data_t drxj_data_g = {
 	  0,
 	  (char *)(NULL)
 	  },
-	 {			/* drx_version_t for device specific code */
+	 {			/* struct drx_version for device specific code */
 	  DRX_MODULE_UNKNOWN,
 	  (char *)(NULL),
 	  0,
@@ -866,13 +866,13 @@ drxj_data_t drxj_data_g = {
 	  }
 	 },
 	{
-	 {			/* drx_version_list_t for microcode */
-	  (pdrx_version_t) (NULL),
-	  (p_drx_version_list_t) (NULL)
+	 {			/* struct drx_version_list for microcode */
+	  (struct drx_version *) (NULL),
+	  (struct drx_version_list *) (NULL)
 	  },
-	 {			/* drx_version_list_t for device specific code */
-	  (pdrx_version_t) (NULL),
-	  (p_drx_version_list_t) (NULL)
+	 {			/* struct drx_version_list for device specific code */
+	  (struct drx_version *) (NULL),
+	  (struct drx_version_list *) (NULL)
 	  }
 	 },
 #endif
@@ -949,7 +949,7 @@ struct i2c_device_addr drxj_default_addr_g = {
 * \var drxj_default_comm_attr_g
 * \brief Default common attributes of a drxj demodulator instance.
 */
-drx_common_attr_t drxj_default_comm_attr_g = {
+struct drx_common_attr drxj_default_comm_attr_g = {
 	(u8 *)NULL,		/* ucode ptr            */
 	0,			/* ucode size           */
 	true,			/* ucode verify switch  */
@@ -1021,7 +1021,7 @@ drx_common_attr_t drxj_default_comm_attr_g = {
 * \var drxj_default_demod_g
 * \brief Default drxj demodulator instance.
 */
-drx_demod_instance_t drxj_default_demod_g = {
+struct drx_demod_instance drxj_default_demod_g = {
 	&drxj_functions_g,	/* demod functions */
 	&DRXJ_DAP,		/* data access protocol functions */
 	NULL,			/* tuner instance */
@@ -1036,7 +1036,7 @@ drx_demod_instance_t drxj_default_demod_g = {
 * This structure is DRXK specific.
 *
 */
-drx_aud_data_t drxj_default_aud_data_g = {
+struct drx_aud_data drxj_default_aud_data_g = {
 	false,			/* audio_is_active */
 	DRX_AUD_STANDARD_AUTO,	/* audio_standard  */
 
@@ -1150,31 +1150,31 @@ hi_command(struct i2c_device_addr *dev_addr,
 	   const pdrxj_hi_cmd_t cmd, u16 *result);
 
 static int
-ctrl_lock_status(pdrx_demod_instance_t demod, pdrx_lock_status_t lock_stat);
+ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_stat);
 
 static int
-ctrl_power_mode(pdrx_demod_instance_t demod, pdrx_power_mode_t mode);
+ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode);
 
-static int power_down_aud(pdrx_demod_instance_t demod);
+static int power_down_aud(struct drx_demod_instance *demod);
 
 #ifndef DRXJ_DIGITAL_ONLY
-static int power_up_aud(pdrx_demod_instance_t demod, bool set_standard);
+static int power_up_aud(struct drx_demod_instance *demod, bool set_standard);
 #endif
 
 static int
-aud_ctrl_set_standard(pdrx_demod_instance_t demod, pdrx_aud_standard_t standard);
+aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *standard);
 
 static int
-ctrl_set_cfg_pre_saw(pdrx_demod_instance_t demod, p_drxj_cfg_pre_saw_t pre_saw);
+ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, p_drxj_cfg_pre_saw_t pre_saw);
 
 static int
-ctrl_set_cfg_afe_gain(pdrx_demod_instance_t demod, p_drxj_cfg_afe_gain_t afe_gain);
+ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, p_drxj_cfg_afe_gain_t afe_gain);
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 static int
-ctrl_u_codeUpload(pdrx_demod_instance_t demod,
-		  p_drxu_code_info_t mc_info,
-		drxu_code_action_t action, bool audio_mc_upload);
+ctrl_u_codeUpload(struct drx_demod_instance *demod,
+		  struct drxu_code_info *mc_info,
+		enum drxu_code_actionaction, bool audio_mc_upload);
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
 /*============================================================================*/
@@ -1688,7 +1688,7 @@ static const u16 nicam_presc_table_val[43] =
 /*============================================================================*/
 
 /**
-* \fn bool is_handled_by_aud_tr_if( dr_xaddr_t addr )
+* \fn bool is_handled_by_aud_tr_if( u32 addr )
 * \brief Check if this address is handled by the audio token ring interface.
 * \param addr
 * \return bool
@@ -1697,7 +1697,7 @@ static const u16 nicam_presc_table_val[43] =
 *
 */
 static
-bool is_handled_by_aud_tr_if(dr_xaddr_t addr)
+bool is_handled_by_aud_tr_if(u32 addr)
 {
 	bool retval = false;
 
@@ -1713,9 +1713,9 @@ bool is_handled_by_aud_tr_if(dr_xaddr_t addr)
 /*============================================================================*/
 
 static int drxj_dap_read_block(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
+				      u32 addr,
 				      u16 datasize,
-				      u8 *data, dr_xflags_t flags)
+				      u8 *data, u32 flags)
 {
 	return drx_dap_fasi_funct_g.read_block_func(dev_addr,
 					       addr, datasize, data, flags);
@@ -1724,8 +1724,8 @@ static int drxj_dap_read_block(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_read_modify_write_reg8(struct i2c_device_addr *dev_addr,
-						dr_xaddr_t waddr,
-						dr_xaddr_t raddr,
+						u32 waddr,
+						u32 raddr,
 						u8 wdata, u8 *rdata)
 {
 	return drx_dap_fasi_funct_g.read_modify_write_reg8func(dev_addr,
@@ -1757,8 +1757,8 @@ static int drxj_dap_read_modify_write_reg8(struct i2c_device_addr *dev_addr,
    See comments drxj_dap_read_modify_write_reg16 */
 #if (DRXDAPFASI_LONG_ADDR_ALLOWED == 0)
 static int drxj_dap_rm_write_reg16short(struct i2c_device_addr *dev_addr,
-					      dr_xaddr_t waddr,
-					      dr_xaddr_t raddr,
+					      u32 waddr,
+					      u32 raddr,
 					      u16 wdata, u16 *rdata)
 {
 	int rc;
@@ -1796,8 +1796,8 @@ static int drxj_dap_rm_write_reg16short(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
-						 dr_xaddr_t waddr,
-						 dr_xaddr_t raddr,
+						 u32 waddr,
+						 u32 raddr,
 						 u16 wdata, u16 *rdata)
 {
 	/* TODO: correct short/long addressing format decision,
@@ -1815,8 +1815,8 @@ static int drxj_dap_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
-						 dr_xaddr_t waddr,
-						 dr_xaddr_t raddr,
+						 u32 waddr,
+						 u32 raddr,
 						 u32 wdata, u32 *rdata)
 {
 	return drx_dap_fasi_funct_g.read_modify_write_reg32func(dev_addr,
@@ -1827,8 +1827,8 @@ static int drxj_dap_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_read_reg8(struct i2c_device_addr *dev_addr,
-				     dr_xaddr_t addr,
-				     u8 *data, dr_xflags_t flags)
+				     u32 addr,
+				     u8 *data, u32 flags)
 {
 	return drx_dap_fasi_funct_g.read_reg8func(dev_addr, addr, data, flags);
 }
@@ -1849,7 +1849,7 @@ static int drxj_dap_read_reg8(struct i2c_device_addr *dev_addr,
 *
 */
 static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
-					 dr_xaddr_t addr, u16 *data)
+					 u32 addr, u16 *data)
 {
 	u32 start_timer = 0;
 	u32 current_timer = 0;
@@ -1861,7 +1861,7 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 	if (DRXDAP_FASI_ADDR2BANK(addr) == 3) {
 		stat = DRX_STS_INVALID_ARG;
 	} else {
-		const dr_xaddr_t write_bit = ((dr_xaddr_t) 1) << 16;
+		const u32 write_bit = ((dr_xaddr_t) 1) << 16;
 
 		/* Force reset write bit */
 		addr &= (~write_bit);
@@ -1929,8 +1929,8 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_read_reg16(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
-				      u16 *data, dr_xflags_t flags)
+				      u32 addr,
+				      u16 *data, u32 flags)
 {
 	int stat = DRX_STS_ERROR;
 
@@ -1952,8 +1952,8 @@ static int drxj_dap_read_reg16(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_read_reg32(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
-				      u32 *data, dr_xflags_t flags)
+				      u32 addr,
+				      u32 *data, u32 flags)
 {
 	return drx_dap_fasi_funct_g.read_reg32func(dev_addr, addr, data, flags);
 }
@@ -1961,9 +1961,9 @@ static int drxj_dap_read_reg32(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_write_block(struct i2c_device_addr *dev_addr,
-				       dr_xaddr_t addr,
+				       u32 addr,
 				       u16 datasize,
-				       u8 *data, dr_xflags_t flags)
+				       u8 *data, u32 flags)
 {
 	return drx_dap_fasi_funct_g.write_block_func(dev_addr,
 						addr, datasize, data, flags);
@@ -1972,8 +1972,8 @@ static int drxj_dap_write_block(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_write_reg8(struct i2c_device_addr *dev_addr,
-				      dr_xaddr_t addr,
-				      u8 data, dr_xflags_t flags)
+				      u32 addr,
+				      u8 data, u32 flags)
 {
 	return drx_dap_fasi_funct_g.write_reg8func(dev_addr, addr, data, flags);
 }
@@ -1994,7 +1994,7 @@ static int drxj_dap_write_reg8(struct i2c_device_addr *dev_addr,
 *
 */
 static int drxj_dap_write_aud_reg16(struct i2c_device_addr *dev_addr,
-					  dr_xaddr_t addr, u16 data)
+					  u32 addr, u16 data)
 {
 	int stat = DRX_STS_ERROR;
 
@@ -2006,7 +2006,7 @@ static int drxj_dap_write_aud_reg16(struct i2c_device_addr *dev_addr,
 		u32 current_timer = 0;
 		u32 delta_timer = 0;
 		u16 tr_status = 0;
-		const dr_xaddr_t write_bit = ((dr_xaddr_t) 1) << 16;
+		const u32 write_bit = ((dr_xaddr_t) 1) << 16;
 
 		/* Force write bit */
 		addr |= write_bit;
@@ -2041,8 +2041,8 @@ static int drxj_dap_write_aud_reg16(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_write_reg16(struct i2c_device_addr *dev_addr,
-				       dr_xaddr_t addr,
-				       u16 data, dr_xflags_t flags)
+				       u32 addr,
+				       u16 data, u32 flags)
 {
 	int stat = DRX_STS_ERROR;
 
@@ -2064,8 +2064,8 @@ static int drxj_dap_write_reg16(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 
 static int drxj_dap_write_reg32(struct i2c_device_addr *dev_addr,
-				       dr_xaddr_t addr,
-				       u32 data, dr_xflags_t flags)
+				       u32 addr,
+				       u32 data, u32 flags)
 {
 	return drx_dap_fasi_funct_g.write_reg32func(dev_addr, addr, data, flags);
 }
@@ -2095,7 +2095,7 @@ static int drxj_dap_write_reg32(struct i2c_device_addr *dev_addr,
 */
 static
 int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
-					  dr_xaddr_t addr,
+					  u32 addr,
 					  u16 datasize,
 					  u8 *data, bool read_flag)
 {
@@ -2169,8 +2169,8 @@ rw_error:
 */
 static
 int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
-				     dr_xaddr_t addr,
-				     u32 *data, dr_xflags_t flags)
+				     u32 addr,
+				     u32 *data, u32 flags)
 {
 	u8 buf[sizeof(*data)];
 	int rc = DRX_STS_ERROR;
@@ -2219,7 +2219,7 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 * enable/disable should not need re-configuration of the HI.
 *
 */
-static int hi_cfg_command(const pdrx_demod_instance_t demod)
+static int hi_cfg_command(const struct drx_demod_instance *demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	drxj_hi_cmd_t hi_cmd;
@@ -2322,7 +2322,7 @@ rw_error:
 }
 
 /**
-* \fn int init_hi( const pdrx_demod_instance_t demod )
+* \fn int init_hi( const struct drx_demod_instance *demod )
 * \brief Initialise and configurate HI.
 * \param demod pointer to demod data.
 * \return int Return status.
@@ -2334,14 +2334,14 @@ rw_error:
 * bridging is controlled.
 *
 */
-static int init_hi(const pdrx_demod_instance_t demod)
+static int init_hi(const struct drx_demod_instance *demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
 	/* PATCH for bug 5003, HI ucode v3.1.0 */
@@ -2411,16 +2411,16 @@ rw_error:
 *  * ext_attr->has_oob
 *
 */
-static int get_device_capabilities(pdrx_demod_instance_t demod)
+static int get_device_capabilities(struct drx_demod_instance *demod)
 {
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 sio_pdr_ohw_cfg = 0;
 	u32 sio_top_jtagid_lo = 0;
 	u16 bid = 0;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
@@ -2586,7 +2586,7 @@ rw_error:
 #define DRXJ_MAX_RETRIES_POWERUP 10
 #endif
 
-static int power_up_device(pdrx_demod_instance_t demod)
+static int power_up_device(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u8 data = 0;
@@ -2636,11 +2636,11 @@ static int power_up_device(pdrx_demod_instance_t demod)
 *
 */
 static int
-ctrl_set_cfg_mpeg_output(pdrx_demod_instance_t demod, pdrx_cfg_mpeg_output_t cfg_data)
+ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_output *cfg_data)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	u16 fec_oc_reg_mode = 0;
 	u16 fec_oc_reg_ipr_mode = 0;
 	u16 fec_oc_reg_ipr_invert = 0;
@@ -2661,7 +2661,7 @@ ctrl_set_cfg_mpeg_output(pdrx_demod_instance_t demod, pdrx_cfg_mpeg_output_t cfg
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	if (cfg_data->enable_mpeg_output == true) {
 		/* quick and dirty patch to set MPEG incase current std is not
@@ -3038,11 +3038,11 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_mpeg_output(pdrx_demod_instance_t demod, pdrx_cfg_mpeg_output_t cfg_data)
+ctrl_get_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_output *cfg_data)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
-	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
+	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	u32 rate_reg = 0;
 	u32 data64hi = 0;
 	u32 data64lo = 0;
@@ -3095,7 +3095,7 @@ rw_error:
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static int set_mpegtei_handling(pdrx_demod_instance_t demod)
+static int set_mpegtei_handling(struct drx_demod_instance *demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
@@ -3143,7 +3143,7 @@ rw_error:
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static int bit_reverse_mpeg_output(pdrx_demod_instance_t demod)
+static int bit_reverse_mpeg_output(struct drx_demod_instance *demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
@@ -3179,7 +3179,7 @@ rw_error:
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static int set_mpeg_output_clock_rate(pdrx_demod_instance_t demod)
+static int set_mpeg_output_clock_rate(struct drx_demod_instance *demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
@@ -3207,12 +3207,12 @@ rw_error:
 * This routine should be called during a set channel of QAM/VSB
 *
 */
-static int set_mpeg_start_width(pdrx_demod_instance_t demod)
+static int set_mpeg_start_width(struct drx_demod_instance *demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 fec_oc_comm_mb = 0;
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) NULL;
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
@@ -3246,7 +3246,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_mpeg_output_misc(pdrx_demod_instance_t demod,
+ctrl_set_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 			      p_drxj_cfg_mpeg_output_misc_t cfg_data)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
@@ -3296,7 +3296,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_mpeg_output_misc(pdrx_demod_instance_t demod,
+ctrl_get_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 			      p_drxj_cfg_mpeg_output_misc_t cfg_data)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
@@ -3338,7 +3338,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_hw_cfg(pdrx_demod_instance_t demod, p_drxj_cfg_hw_cfg_t cfg_data)
+ctrl_get_cfg_hw_cfg(struct drx_demod_instance *demod, p_drxj_cfg_hw_cfg_t cfg_data)
 {
 	u16 data = 0;
 
@@ -3371,7 +3371,7 @@ rw_error:
 * \param uio_cfg Pointer to a configuration setting for a certain UIO.
 * \return int.
 */
-static int ctrl_set_uio_cfg(pdrx_demod_instance_t demod, pdrxuio_cfg_t uio_cfg)
+static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *uio_cfg)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 
@@ -3484,11 +3484,11 @@ rw_error:
 * \param uio_cfg Pointer to a configuration setting for a certain UIO.
 * \return int.
 */
-static int CtrlGetuio_cfg(pdrx_demod_instance_t demod, pdrxuio_cfg_t uio_cfg)
+static int CtrlGetuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *uio_cfg)
 {
 
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
-	pdrxuio_mode_t uio_mode[4] = { NULL };
+	enum drxuio_mode *uio_mode[4] = { NULL };
 	bool *uio_available[4] = { NULL };
 
 	ext_attr = demod->my_ext_attr;
@@ -3528,7 +3528,7 @@ static int CtrlGetuio_cfg(pdrx_demod_instance_t demod, pdrxuio_cfg_t uio_cfg)
 * \return int.
 */
 static int
-ctrl_uio_write(pdrx_demod_instance_t demod, pdrxuio_data_t uio_data)
+ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	u16 pin_cfg_value = 0;
@@ -3673,7 +3673,7 @@ rw_error:
 * \param uio_data Pointer to data container for a certain UIO.
 * \return int.
 */
-static int ctrl_uio_read(pdrx_demod_instance_t demod, pdrxuio_data_t uio_data)
+static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	u16 pin_cfg_value = 0;
@@ -3820,7 +3820,7 @@ rw_error:
 
 */
 static int
-ctrl_i2c_bridge(pdrx_demod_instance_t demod, bool *bridge_closed)
+ctrl_i2c_bridge(struct drx_demod_instance *demod, bool *bridge_closed)
 {
 	drxj_hi_cmd_t hi_cmd;
 	u16 result = 0;
@@ -3851,16 +3851,16 @@ ctrl_i2c_bridge(pdrx_demod_instance_t demod, bool *bridge_closed)
 /**
 * \fn int smart_ant_init()
 * \brief Initialize Smart Antenna.
-* \param pointer to drx_demod_instance_t.
+* \param pointer to struct drx_demod_instance.
 * \return int.
 *
 */
-static int smart_ant_init(pdrx_demod_instance_t demod)
+static int smart_ant_init(struct drx_demod_instance *demod)
 {
 	u16 data = 0;
 	pdrxj_data_t ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
-	drxuio_cfg_t uio_cfg = { DRX_UIO1, DRX_UIO_MODE_FIRMWARE_SMA };
+	struct drxuio_cfg uio_cfg = { DRX_UIO1, DRX_UIO_MODE_FIRMWARE_SMA };
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
@@ -3899,7 +3899,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_smart_ant(pdrx_demod_instance_t demod, p_drxj_cfg_smart_ant_t smart_ant)
+ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, p_drxj_cfg_smart_ant_t smart_ant)
 {
 	pdrxj_data_t ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
@@ -4092,7 +4092,7 @@ rw_error:
 */
 #define ADDR_AT_SCU_SPACE(x) ((x - 0x82E000) * 2)
 static
-int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, dr_xaddr_t addr, u16 datasize,	/* max 30 bytes because the limit of SCU parameter */
+int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 addr, u16 datasize,	/* max 30 bytes because the limit of SCU parameter */
 					      u8 *data, bool read_flag)
 {
 	drxjscu_cmd_t scu_cmd;
@@ -4154,8 +4154,8 @@ rw_error:
 */
 static
 int drxj_dap_scu_atomic_read_reg16(struct i2c_device_addr *dev_addr,
-					 dr_xaddr_t addr,
-					 u16 *data, dr_xflags_t flags)
+					 u32 addr,
+					 u16 *data, u32 flags)
 {
 	u8 buf[2];
 	int rc = DRX_STS_ERROR;
@@ -4181,8 +4181,8 @@ int drxj_dap_scu_atomic_read_reg16(struct i2c_device_addr *dev_addr,
 */
 static
 int drxj_dap_scu_atomic_write_reg16(struct i2c_device_addr *dev_addr,
-					  dr_xaddr_t addr,
-					  u16 data, dr_xflags_t flags)
+					  u32 addr,
+					  u16 data, u32 flags)
 {
 	u8 buf[2];
 	int rc = DRX_STS_ERROR;
@@ -4196,7 +4196,7 @@ int drxj_dap_scu_atomic_write_reg16(struct i2c_device_addr *dev_addr,
 }
 
 static int
-ctrl_i2c_write_read(pdrx_demod_instance_t demod, pdrxi2c_data_t i2c_data)
+ctrl_i2c_write_read(struct drx_demod_instance *demod, struct drxi2c_data *i2c_data)
 {
 	return (DRX_STS_FUNC_NOT_AVAILABLE);
 }
@@ -4211,7 +4211,7 @@ ctrl_i2c_write_read(pdrx_demod_instance_t demod, pdrxi2c_data_t i2c_data)
 * \retval DRX_STS_ERROR Failure: I2C error
 *
 */
-static int adc_sync_measurement(pdrx_demod_instance_t demod, u16 *count)
+static int adc_sync_measurement(struct drx_demod_instance *demod, u16 *count)
 {
 	u16 data = 0;
 	struct i2c_device_addr *dev_addr = NULL;
@@ -4256,7 +4256,7 @@ rw_error:
 *
 */
 
-static int adc_synchronization(pdrx_demod_instance_t demod)
+static int adc_synchronization(struct drx_demod_instance *demod)
 {
 	u16 count = 0;
 	struct i2c_device_addr *dev_addr = NULL;
@@ -4293,7 +4293,7 @@ rw_error:
 * \param active
 * \return int.
 */
-static int iqm_set_af(pdrx_demod_instance_t demod, bool active)
+static int iqm_set_af(struct drx_demod_instance *demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
@@ -4323,7 +4323,7 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 static int
-ctrl_set_cfg_atv_output(pdrx_demod_instance_t demod, p_drxj_cfg_atv_output_t output_cfg);
+ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_t output_cfg);
 
 /**
 * \brief set configuration of pin-safe mode
@@ -4332,7 +4332,7 @@ ctrl_set_cfg_atv_output(pdrx_demod_instance_t demod, p_drxj_cfg_atv_output_t out
 * \return int.
 */
 static int
-ctrl_set_cfg_pdr_safe_mode(pdrx_demod_instance_t demod, bool *enable)
+ctrl_set_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enable)
 {
 	pdrxj_data_t ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
@@ -4455,7 +4455,7 @@ rw_error:
 * \return int.
 */
 static int
-ctrl_get_cfg_pdr_safe_mode(pdrx_demod_instance_t demod, bool *enabled)
+ctrl_get_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enabled)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
@@ -4474,7 +4474,7 @@ ctrl_get_cfg_pdr_safe_mode(pdrx_demod_instance_t demod, bool *enabled)
 * \param demod Demodulator instance.
 * \return int.
 */
-static int ctrl_validate_u_code(pdrx_demod_instance_t demod)
+static int ctrl_validate_u_code(struct drx_demod_instance *demod)
 {
 	u32 mc_dev, mc_patch;
 	u16 ver_type;
@@ -4522,10 +4522,10 @@ static int ctrl_validate_u_code(pdrx_demod_instance_t demod)
 * \param channel pointer to channel data.
 * \return int.
 */
-static int init_agc(pdrx_demod_instance_t demod)
+static int init_agc(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 	p_drxj_cfg_agc_t p_agc_rf_settings = NULL;
 	p_drxj_cfg_agc_t p_agc_if_settings = NULL;
@@ -4545,7 +4545,7 @@ static int init_agc(pdrx_demod_instance_t demod)
 	u16 agc_rf = 0;
 	u16 agc_if = 0;
 	dev_addr = demod->my_i2c_dev_addr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	switch (ext_attr->standard) {
@@ -4730,8 +4730,8 @@ rw_error:
 * \return int.
 */
 static int
-set_frequency(pdrx_demod_instance_t demod,
-	      pdrx_channel_t channel, s32 tuner_freq_offset)
+set_frequency(struct drx_demod_instance *demod,
+	      struct drx_channel *channel, s32 tuner_freq_offset)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	pdrxj_data_t ext_attr = demod->my_ext_attr;
@@ -4833,7 +4833,7 @@ rw_error:
 #define DRXJ_RFAGC_MAX  0x3fff
 #define DRXJ_RFAGC_MIN  0x800
 
-static int get_sig_strength(pdrx_demod_instance_t demod, u16 *sig_strength)
+static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	u16 rf_gain = 0;
@@ -4888,7 +4888,7 @@ rw_error:
 * \retval DRX_STS_ERROR Erroneous data, sig_strength contains invalid data.
 */
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
-static int get_acc_pkt_err(pdrx_demod_instance_t demod, u16 *packet_err)
+static int get_acc_pkt_err(struct drx_demod_instance *demod, u16 *packet_err)
 {
 	static u16 pkt_err;
 	static u16 last_pkt_err;
@@ -4929,7 +4929,7 @@ rw_error:
 * \retval DRX_STS_OK.
 * \retval DRX_STS_ERROR Erroneous data.
 */
-static int ctrl_set_cfg_reset_pkt_err(pdrx_demod_instance_t demod)
+static int ctrl_set_cfg_reset_pkt_err(struct drx_demod_instance *demod)
 {
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
 	pdrxj_data_t ext_attr = NULL;
@@ -4951,7 +4951,7 @@ rw_error:
 * \brief Get symbol rate offset in QAM & 8VSB mode
 * \return Error code
 */
-static int get_str_freq_offset(pdrx_demod_instance_t demod, s32 *str_freq)
+static int get_str_freq_offset(struct drx_demod_instance *demod, s32 *str_freq)
 {
 	u32 symbol_frequency_ratio = 0;
 	u32 symbol_nom_frequency_ratio = 0;
@@ -4984,7 +4984,7 @@ rw_error:
 * \brief Get the value of ctl_freq in QAM & ATSC mode
 * \return Error code
 */
-static int get_ctl_freq_offset(pdrx_demod_instance_t demod, s32 *ctl_freq)
+static int get_ctl_freq_offset(struct drx_demod_instance *demod, s32 *ctl_freq)
 {
 	s32 sampling_frequency = 0;
 	s32 current_frequency = 0;
@@ -4994,12 +4994,12 @@ static int get_ctl_freq_offset(pdrx_demod_instance_t demod, s32 *ctl_freq)
 	u32 data64hi = 0;
 	u32 data64lo = 0;
 	pdrxj_data_t ext_attr = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	sampling_frequency = common_attr->sys_clock_freq / 3;
 
@@ -5041,16 +5041,16 @@ rw_error:
 * \return int.
 */
 static int
-set_agc_rf(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings, bool atomic)
+set_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings, bool atomic)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 	p_drxj_cfg_agc_t p_agc_settings = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	drx_write_reg16func_t scu_wr16 = NULL;
 	drx_read_reg16func_t scu_rr16 = NULL;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
@@ -5219,7 +5219,7 @@ rw_error:
 * \return int.
 */
 static int
-get_agc_rf(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
+get_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -5280,16 +5280,16 @@ rw_error:
 * \return int.
 */
 static int
-set_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings, bool atomic)
+set_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings, bool atomic)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 	p_drxj_cfg_agc_t p_agc_settings = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	drx_write_reg16func_t scu_wr16 = NULL;
 	drx_read_reg16func_t scu_rr16 = NULL;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
@@ -5471,7 +5471,7 @@ rw_error:
 * \return int.
 */
 static int
-get_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
+get_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -5532,7 +5532,7 @@ rw_error:
 * \param active
 * \return int.
 */
-static int set_iqm_af(pdrx_demod_instance_t demod, bool active)
+static int set_iqm_af(struct drx_demod_instance *demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *dev_addr = NULL;
@@ -5580,7 +5580,7 @@ rw_error:
 * \param channel pointer to channel data.
 * \return int.
 */
-static int power_down_vsb(pdrx_demod_instance_t demod, bool primary)
+static int power_down_vsb(struct drx_demod_instance *demod, bool primary)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	drxjscu_cmd_t cmd_scu = { /* command     */ 0,
@@ -5590,7 +5590,7 @@ static int power_down_vsb(pdrx_demod_instance_t demod, bool primary)
 		/* *result      */ NULL
 	};
 	u16 cmd_result = 0;
-	drx_cfg_mpeg_output_t cfg_mpeg_output;
+	struct drx_cfg_mpeg_output cfg_mpeg_output;
 
 	/*
 	   STOP demodulator
@@ -5632,7 +5632,7 @@ rw_error:
 * \param demod instance of demodulator.
 * \return int.
 */
-static int set_vsb_leak_n_gain(pdrx_demod_instance_t demod)
+static int set_vsb_leak_n_gain(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 
@@ -5842,12 +5842,12 @@ rw_error:
 * \return int.
 *
 */
-static int set_vsb(pdrx_demod_instance_t demod)
+static int set_vsb(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	u16 cmd_result = 0;
 	u16 cmd_param = 0;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	drxjscu_cmd_t cmd_scu;
 	pdrxj_data_t ext_attr = NULL;
 	const u8 vsb_taps_re[] = {
@@ -5882,7 +5882,7 @@ static int set_vsb(pdrx_demod_instance_t demod)
 	};
 
 	dev_addr = demod->my_i2c_dev_addr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* stop all comm_exec */
@@ -6003,7 +6003,7 @@ static int set_vsb(pdrx_demod_instance_t demod)
 	{
 		/* TODO: move to set_standard after hardware reset value problem is solved */
 		/* Configure initial MPEG output */
-		drx_cfg_mpeg_output_t cfg_mpeg_output;
+		struct drx_cfg_mpeg_output cfg_mpeg_output;
 		cfg_mpeg_output.enable_mpeg_output = true;
 		cfg_mpeg_output.insert_rs_byte = common_attr->mpeg_cfg.insert_rs_byte;
 		cfg_mpeg_output.enable_parallel =
@@ -6202,7 +6202,7 @@ rw_error:
 * \return int.
 */
 static int
-ctrl_get_vsb_constel(pdrx_demod_instance_t demod, pdrx_complex_t complex_nr)
+ctrl_get_vsb_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 				       /**< device address                    */
@@ -6266,7 +6266,7 @@ rw_error:
 * \param channel pointer to channel data.
 * \return int.
 */
-static int power_down_qam(pdrx_demod_instance_t demod, bool primary)
+static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 {
 	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
@@ -6276,7 +6276,7 @@ static int power_down_qam(pdrx_demod_instance_t demod, bool primary)
 	};
 	u16 cmd_result = 0;
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
-	drx_cfg_mpeg_output_t cfg_mpeg_output;
+	struct drx_cfg_mpeg_output cfg_mpeg_output;
 
 	/*
 	   STOP demodulator
@@ -6333,7 +6333,7 @@ rw_error:
 */
 #ifndef DRXJ_VSB_ONLY
 static int
-set_qam_measurement(pdrx_demod_instance_t demod,
+set_qam_measurement(struct drx_demod_instance *demod,
 		    enum drx_modulation constellation, u32 symbol_rate)
 {
 	struct i2c_device_addr *dev_addr = NULL;	/* device address for I2C writes */
@@ -6495,7 +6495,7 @@ rw_error:
 * \param demod instance of demod.
 * \return int.
 */
-static int set_qam16(pdrx_demod_instance_t demod)
+static int set_qam16(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	const u8 qam_dq_qual_fun[] = {
@@ -6575,7 +6575,7 @@ rw_error:
 * \param demod instance of demod.
 * \return int.
 */
-static int set_qam32(pdrx_demod_instance_t demod)
+static int set_qam32(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	const u8 qam_dq_qual_fun[] = {
@@ -6655,7 +6655,7 @@ rw_error:
 * \param demod instance of demod.
 * \return int.
 */
-static int set_qam64(pdrx_demod_instance_t demod)
+static int set_qam64(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	const u8 qam_dq_qual_fun[] = {	/* this is hw reset value. no necessary to re-write */
@@ -6735,7 +6735,7 @@ rw_error:
 * \param demod: instance of demod.
 * \return int.
 */
-static int set_qam128(pdrx_demod_instance_t demod)
+static int set_qam128(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	const u8 qam_dq_qual_fun[] = {
@@ -6815,7 +6815,7 @@ rw_error:
 * \param demod: instance of demod.
 * \return int.
 */
-static int set_qam256(pdrx_demod_instance_t demod)
+static int set_qam256(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	const u8 qam_dq_qual_fun[] = {
@@ -6900,12 +6900,12 @@ rw_error:
 * \return int.
 */
 static int
-set_qam(pdrx_demod_instance_t demod,
-	pdrx_channel_t channel, s32 tuner_freq_offset, u32 op)
+set_qam(struct drx_demod_instance *demod,
+	struct drx_channel *channel, s32 tuner_freq_offset, u32 op)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	u16 cmd_result = 0;
 	u32 adc_frequency = 0;
 	u32 iqm_rc_rate = 0;
@@ -7042,7 +7042,7 @@ set_qam(pdrx_demod_instance_t demod,
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	if ((op & QAM_SET_OP_ALL) || (op & QAM_SET_OP_CONSTELLATION)) {
 		if (ext_attr->standard == DRX_STANDARD_ITU_B) {
@@ -7321,7 +7321,7 @@ set_qam(pdrx_demod_instance_t demod,
 		{
 			/* TODO: move to set_standard after hardware reset value problem is solved */
 			/* Configure initial MPEG output */
-			drx_cfg_mpeg_output_t cfg_mpeg_output;
+			struct drx_cfg_mpeg_output cfg_mpeg_output;
 
 			cfg_mpeg_output.enable_mpeg_output = true;
 			cfg_mpeg_output.insert_rs_byte =
@@ -7363,8 +7363,8 @@ rw_error:
 
 /*============================================================================*/
 static int
-ctrl_get_qam_sig_quality(pdrx_demod_instance_t demod, pdrx_sig_quality_t sig_quality);
-static int qam_flip_spec(pdrx_demod_instance_t demod, pdrx_channel_t channel)
+ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality);
+static int qam_flip_spec(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
 	u32 iqm_fs_rate_ofs = 0;
 	u32 iqm_fs_rate_lo = 0;
@@ -7461,11 +7461,11 @@ rw_error:
 * \return int.
 */
 static int
-qam64auto(pdrx_demod_instance_t demod,
-	  pdrx_channel_t channel,
-	  s32 tuner_freq_offset, pdrx_lock_status_t lock_status)
+qam64auto(struct drx_demod_instance *demod,
+	  struct drx_channel *channel,
+	  s32 tuner_freq_offset, enum drx_lock_status *lock_status)
 {
-	drx_sig_quality_t sig_quality;
+	struct drx_sig_quality sig_quality;
 	u16 data = 0;
 	u32 state = NO_LOCK;
 	u32 start_time = 0;
@@ -7575,11 +7575,11 @@ rw_error:
 * \return int.
 */
 static int
-qam256auto(pdrx_demod_instance_t demod,
-	   pdrx_channel_t channel,
-	   s32 tuner_freq_offset, pdrx_lock_status_t lock_status)
+qam256auto(struct drx_demod_instance *demod,
+	   struct drx_channel *channel,
+	   s32 tuner_freq_offset, enum drx_lock_status *lock_status)
 {
-	drx_sig_quality_t sig_quality;
+	struct drx_sig_quality sig_quality;
 	u32 state = NO_LOCK;
 	u32 start_time = 0;
 	u32 d_locked_time = 0;
@@ -7644,10 +7644,10 @@ rw_error:
 * \return int.
 */
 static int
-set_qamChannel(pdrx_demod_instance_t demod,
-	       pdrx_channel_t channel, s32 tuner_freq_offset)
+set_qamChannel(struct drx_demod_instance *demod,
+	       struct drx_channel *channel, s32 tuner_freq_offset)
 {
-	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
+	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	pdrxj_data_t ext_attr = NULL;
 	bool auto_flag = false;
 
@@ -7848,7 +7848,7 @@ rw_error:
 *  Pre-condition: Device must be started and in lock.
 */
 static int
-ctrl_get_qam_sig_quality(pdrx_demod_instance_t demod, pdrx_sig_quality_t sig_quality)
+ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -8030,7 +8030,7 @@ rw_error:
 * \return int.
 */
 static int
-ctrl_get_qam_constel(pdrx_demod_instance_t demod, pdrx_complex_t complex_nr)
+ctrl_get_qam_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 {
 	u16 fec_oc_ocr_mode = 0;
 			      /**< FEC OCR grabber configuration        */
@@ -8220,7 +8220,7 @@ static int atv_equ_coef_index(enum drx_standard standard, int *index)
 *
 */
 static int
-atv_update_config(pdrx_demod_instance_t demod, bool force_update)
+atv_update_config(struct drx_demod_instance *demod, bool force_update)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -8328,7 +8328,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_atv_output(pdrx_demod_instance_t demod, p_drxj_cfg_atv_output_t output_cfg)
+ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_t output_cfg)
 {
 	pdrxj_data_t ext_attr = NULL;
 
@@ -8385,7 +8385,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_atv_equ_coef(pdrx_demod_instance_t demod, p_drxj_cfg_atv_equ_coef_t coef)
+ctrl_set_cfg_atv_equ_coef(struct drx_demod_instance *demod, p_drxj_cfg_atv_equ_coef_t coef)
 {
 	pdrxj_data_t ext_attr = NULL;
 	int index;
@@ -8439,7 +8439,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_atv_equ_coef(pdrx_demod_instance_t demod, p_drxj_cfg_atv_equ_coef_t coef)
+ctrl_get_cfg_atv_equ_coef(struct drx_demod_instance *demod, p_drxj_cfg_atv_equ_coef_t coef)
 {
 	pdrxj_data_t ext_attr = NULL;
 	int index = 0;
@@ -8477,7 +8477,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_atv_misc(pdrx_demod_instance_t demod, p_drxj_cfg_atv_misc_t settings)
+ctrl_set_cfg_atv_misc(struct drx_demod_instance *demod, p_drxj_cfg_atv_misc_t settings)
 {
 	pdrxj_data_t ext_attr = NULL;
 
@@ -8522,7 +8522,7 @@ rw_error:
 * regitsers.
 */
 static int
-ctrl_get_cfg_atv_misc(pdrx_demod_instance_t demod, p_drxj_cfg_atv_misc_t settings)
+ctrl_get_cfg_atv_misc(struct drx_demod_instance *demod, p_drxj_cfg_atv_misc_t settings)
 {
 	pdrxj_data_t ext_attr = NULL;
 
@@ -8551,7 +8551,7 @@ ctrl_get_cfg_atv_misc(pdrx_demod_instance_t demod, p_drxj_cfg_atv_misc_t setting
 *
 */
 static int
-ctrl_get_cfg_atv_output(pdrx_demod_instance_t demod, p_drxj_cfg_atv_output_t output_cfg)
+ctrl_get_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_t output_cfg)
 {
 	u16 data = 0;
 
@@ -8590,7 +8590,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_atv_agc_status(pdrx_demod_instance_t demod,
+ctrl_get_cfg_atv_agc_status(struct drx_demod_instance *demod,
 			    p_drxj_cfg_atv_agc_status_t agc_status)
 {
 	struct i2c_device_addr *dev_addr = NULL;
@@ -8691,7 +8691,7 @@ rw_error:
 * * Starts ATV and IQM
 * * AUdio already started during standard init for ATV.
 */
-static int power_up_atv(pdrx_demod_instance_t demod, enum drx_standard standard)
+static int power_up_atv(struct drx_demod_instance *demod, enum drx_standard standard)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 
@@ -8725,7 +8725,7 @@ rw_error:
 *  Calls audio power down
 */
 static int
-power_down_atv(pdrx_demod_instance_t demod, enum drx_standard standard, bool primary)
+power_down_atv(struct drx_demod_instance *demod, enum drx_standard standard, bool primary)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
@@ -8783,7 +8783,7 @@ rw_error:
 #ifndef DRXJ_DIGITAL_ONLY
 #define SCU_RAM_ATV_ENABLE_IIR_WA__A 0x831F6D	/* TODO remove after done with reg import */
 static int
-set_atv_standard(pdrx_demod_instance_t demod, enum drx_standard *standard)
+set_atv_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 {
 /* TODO: enable alternative for tap settings via external file
 
@@ -9052,8 +9052,8 @@ trouble ?
 	u16 cmd_result = 0;
 	u16 cmd_param = 0;
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
-	drxu_code_info_t ucode_info;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drxu_code_info ucode_info;
+	struct drx_common_attr *common_attr = NULL;
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 	pdrxj_data_t ext_attr = NULL;
 
@@ -9398,9 +9398,9 @@ rw_error:
 *
 */
 static int
-set_atv_channel(pdrx_demod_instance_t demod,
+set_atv_channel(struct drx_demod_instance *demod,
 		s32 tuner_freq_offset,
-	      pdrx_channel_t channel, enum drx_standard standard)
+	      struct drx_channel *channel, enum drx_standard standard)
 {
 	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
@@ -9465,8 +9465,8 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-get_atv_channel(pdrx_demod_instance_t demod,
-		pdrx_channel_t channel, enum drx_standard standard)
+get_atv_channel(struct drx_demod_instance *demod,
+		struct drx_channel *channel, enum drx_standard standard)
 {
 	s32 offset = 0;
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
@@ -9548,7 +9548,7 @@ rw_error:
 *         is not used ?
 */
 static int
-get_atv_sig_strength(pdrx_demod_instance_t demod, u16 *sig_strength)
+get_atv_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -9657,7 +9657,7 @@ rw_error:
 *
 */
 static int
-atv_sig_quality(pdrx_demod_instance_t demod, pdrx_sig_quality_t sig_quality)
+atv_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	u16 quality_indicator = 0;
@@ -9715,9 +9715,9 @@ rw_error:
 * \return int.
 *
 */
-static int power_up_aud(pdrx_demod_instance_t demod, bool set_standard)
+static int power_up_aud(struct drx_demod_instance *demod, bool set_standard)
 {
-	drx_aud_standard_t aud_standard = DRX_AUD_STANDARD_AUTO;
+	enum drx_aud_standard aud_standard = DRX_AUD_STANDARD_AUTO;
 	struct i2c_device_addr *dev_addr = NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
@@ -9744,7 +9744,7 @@ rw_error:
 * \return int.
 *
 */
-static int power_down_aud(pdrx_demod_instance_t demod)
+static int power_down_aud(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -9769,7 +9769,7 @@ rw_error:
 * \return int.
 *
 */
-static int aud_get_modus(pdrx_demod_instance_t demod, u16 *modus)
+static int aud_get_modus(struct drx_demod_instance *demod, u16 *modus)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -9810,12 +9810,11 @@ rw_error:
 /**
 * \brief Get audio RDS dat
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_aud_rds_t
-* \return int.
+* \param pointer to struct drx_cfg_aud_rds * \return int.
 *
 */
 static int
-aud_ctrl_get_cfg_rds(pdrx_demod_instance_t demod, pdrx_cfg_aud_rds_t status)
+aud_ctrl_get_cfg_rds(struct drx_demod_instance *demod, struct drx_cfg_aud_rds *status)
 {
 	struct i2c_device_addr *addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -9885,7 +9884,7 @@ rw_error:
 *
 */
 static int
-aud_ctrl_get_carrier_detect_status(pdrx_demod_instance_t demod, pdrx_aud_status_t status)
+aud_ctrl_get_carrier_detect_status(struct drx_demod_instance *demod, struct drx_aud_status *status)
 {
 	pdrxj_data_t ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
@@ -9963,11 +9962,11 @@ rw_error:
 *
 */
 static int
-aud_ctrl_get_status(pdrx_demod_instance_t demod, pdrx_aud_status_t status)
+aud_ctrl_get_status(struct drx_demod_instance *demod, struct drx_aud_status *status)
 {
 	pdrxj_data_t ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
-	drx_cfg_aud_rds_t rds = { false, {0} };
+	struct drx_cfg_aud_rds rds = { false, {0} };
 	u16 r_data = 0;
 
 	if (status == NULL) {
@@ -9999,12 +9998,11 @@ rw_error:
 /**
 * \brief Get the current volume settings
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_aud_volume_t
-* \return int.
+* \param pointer to struct drx_cfg_aud_volume * \return int.
 *
 */
 static int
-aud_ctrl_get_cfg_volume(pdrx_demod_instance_t demod, pdrx_cfg_aud_volume_t volume)
+aud_ctrl_get_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_volume *volume)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -10133,12 +10131,11 @@ rw_error:
 /**
 * \brief Set the current volume settings
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_aud_volume_t
-* \return int.
+* \param pointer to struct drx_cfg_aud_volume * \return int.
 *
 */
 static int
-aud_ctrl_set_cfg_volume(pdrx_demod_instance_t demod, pdrx_cfg_aud_volume_t volume)
+aud_ctrl_set_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_volume *volume)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -10268,12 +10265,11 @@ rw_error:
 /**
 * \brief Get the I2S settings
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_i2s_output_t
-* \return int.
+* \param pointer to struct drx_cfg_i2s_output * \return int.
 *
 */
 static int
-aud_ctrl_get_cfg_output_i2s(pdrx_demod_instance_t demod, pdrx_cfg_i2s_output_t output)
+aud_ctrl_get_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s_output *output)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -10371,12 +10367,11 @@ rw_error:
 /**
 * \brief Set the I2S settings
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_i2s_output_t
-* \return int.
+* \param pointer to struct drx_cfg_i2s_output * \return int.
 *
 */
 static int
-aud_ctrl_set_cfg_output_i2s(pdrx_demod_instance_t demod, pdrx_cfg_i2s_output_t output)
+aud_ctrl_set_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s_output *output)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -10531,8 +10526,8 @@ rw_error:
 *
 */
 static int
-aud_ctrl_get_cfg_auto_sound(pdrx_demod_instance_t demod,
-			    pdrx_cfg_aud_auto_sound_t auto_sound)
+aud_ctrl_get_cfg_auto_sound(struct drx_demod_instance *demod,
+			    enum drx_cfg_aud_auto_sound *auto_sound)
 {
 	pdrxj_data_t ext_attr = NULL;
 	u16 r_modus = 0;
@@ -10584,8 +10579,8 @@ rw_error:
 *
 */
 static int
-aud_ctr_setl_cfg_auto_sound(pdrx_demod_instance_t demod,
-			    pdrx_cfg_aud_auto_sound_t auto_sound)
+aud_ctr_setl_cfg_auto_sound(struct drx_demod_instance *demod,
+			    enum drx_cfg_aud_auto_sound *auto_sound)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -10650,7 +10645,7 @@ rw_error:
 *
 */
 static int
-aud_ctrl_get_cfg_ass_thres(pdrx_demod_instance_t demod, pdrx_cfg_aud_ass_thres_t thres)
+aud_ctrl_get_cfg_ass_thres(struct drx_demod_instance *demod, struct drx_cfg_aud_ass_thres *thres)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -10694,7 +10689,7 @@ rw_error:
 *
 */
 static int
-aud_ctrl_set_cfg_ass_thres(pdrx_demod_instance_t demod, pdrx_cfg_aud_ass_thres_t thres)
+aud_ctrl_set_cfg_ass_thres(struct drx_demod_instance *demod, struct drx_cfg_aud_ass_thres *thres)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -10728,12 +10723,11 @@ rw_error:
 /**
 * \brief Get Audio Carrier settings
 * \param demod instance of demodulator
-* \param pointer to pdrx_aud_carrier_t
-* \return int.
+* \param pointer to struct drx_aud_carrier ** \return int.
 *
 */
 static int
-aud_ctrl_get_cfg_carrier(pdrx_demod_instance_t demod, pdrx_cfg_aud_carriers_t carriers)
+aud_ctrl_get_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_carriers *carriers)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -10833,12 +10827,11 @@ rw_error:
 /**
 * \brief Set Audio Carrier settings
 * \param demod instance of demodulator
-* \param pointer to pdrx_aud_carrier_t
-* \return int.
+* \param pointer to struct drx_aud_carrier ** \return int.
 *
 */
 static int
-aud_ctrl_set_cfg_carrier(pdrx_demod_instance_t demod, pdrx_cfg_aud_carriers_t carriers)
+aud_ctrl_set_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_carriers *carriers)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -10938,7 +10931,7 @@ rw_error:
 *
 */
 static int
-aud_ctrl_get_cfg_mixer(pdrx_demod_instance_t demod, pdrx_cfg_aud_mixer_t mixer)
+aud_ctrl_get_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixer *mixer)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11033,7 +11026,7 @@ rw_error:
 *
 */
 static int
-aud_ctrl_set_cfg_mixer(pdrx_demod_instance_t demod, pdrx_cfg_aud_mixer_t mixer)
+aud_ctrl_set_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixer *mixer)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11141,7 +11134,7 @@ rw_error:
 *
 */
 static int
-aud_ctrl_set_cfg_av_sync(pdrx_demod_instance_t demod, pdrx_cfg_aud_av_sync_t av_sync)
+aud_ctrl_set_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_sync *av_sync)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11206,7 +11199,7 @@ rw_error:
 *
 */
 static int
-aud_ctrl_get_cfg_av_sync(pdrx_demod_instance_t demod, pdrx_cfg_aud_av_sync_t av_sync)
+aud_ctrl_get_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_sync *av_sync)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11258,12 +11251,11 @@ rw_error:
 /**
 * \brief Get deviation mode
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_aud_deviation_t
-* \return int.
+* \param pointer to enum drx_cfg_aud_deviation * \return int.
 *
 */
 static int
-aud_ctrl_get_cfg_dev(pdrx_demod_instance_t demod, pdrx_cfg_aud_deviation_t dev)
+aud_ctrl_get_cfg_dev(struct drx_demod_instance *demod, enum drx_cfg_aud_deviation *dev)
 {
 	u16 r_modus = 0;
 
@@ -11292,12 +11284,11 @@ rw_error:
 /**
 * \brief Get deviation mode
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_aud_deviation_t
-* \return int.
+* \param pointer to enum drx_cfg_aud_deviation * \return int.
 *
 */
 static int
-aud_ctrl_set_cfg_dev(pdrx_demod_instance_t demod, pdrx_cfg_aud_deviation_t dev)
+aud_ctrl_set_cfg_dev(struct drx_demod_instance *demod, enum drx_cfg_aud_deviation *dev)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11345,12 +11336,11 @@ rw_error:
 /**
 * \brief Get Prescaler settings
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_aud_prescale_t
-* \return int.
+* \param pointer to struct drx_cfg_aud_prescale * \return int.
 *
 */
 static int
-aud_ctrl_get_cfg_prescale(pdrx_demod_instance_t demod, pdrx_cfg_aud_prescale_t presc)
+aud_ctrl_get_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_prescale *presc)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11420,12 +11410,11 @@ rw_error:
 /**
 * \brief Set Prescaler settings
 * \param demod instance of demodulator
-* \param pointer to drx_cfg_aud_prescale_t
-* \return int.
+* \param pointer to struct drx_cfg_aud_prescale * \return int.
 *
 */
 static int
-aud_ctrl_set_cfg_prescale(pdrx_demod_instance_t demod, pdrx_cfg_aud_prescale_t presc)
+aud_ctrl_set_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_prescale *presc)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11503,11 +11492,10 @@ rw_error:
 /**
 * \brief Beep
 * \param demod instance of demodulator
-* \param pointer to drx_aud_beep_t
-* \return int.
+* \param pointer to struct drx_aud_beep * \return int.
 *
 */
-static int aud_ctrl_beep(pdrx_demod_instance_t demod, pdrx_aud_beep_t beep)
+static int aud_ctrl_beep(struct drx_demod_instance *demod, struct drx_aud_beep *beep)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
@@ -11561,12 +11549,11 @@ rw_error:
 /**
 * \brief Set an audio standard
 * \param demod instance of demodulator
-* \param pointer to drx_aud_standard_t
-* \return int.
+* \param pointer to enum drx_aud_standard * \return int.
 *
 */
 static int
-aud_ctrl_set_standard(pdrx_demod_instance_t demod, pdrx_aud_standard_t standard)
+aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *standard)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -11739,12 +11726,11 @@ rw_error:
 /**
 * \brief Get the current audio standard
 * \param demod instance of demodulator
-* \param pointer to drx_aud_standard_t
-* \return int.
+* \param pointer to enum drx_aud_standard * \return int.
 *
 */
 static int
-aud_ctrl_get_standard(pdrx_demod_instance_t demod, pdrx_aud_standard_t standard)
+aud_ctrl_get_standard(struct drx_demod_instance *demod, enum drx_aud_standard *standard)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -11851,9 +11837,9 @@ rw_error:
 *
 */
 static int
-fm_lock_status(pdrx_demod_instance_t demod, pdrx_lock_status_t lock_stat)
+fm_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_stat)
 {
-	drx_aud_status_t status;
+	struct drx_aud_status status;
 
 	/* Check detection of audio carriers */
 	CHK_ERROR(aud_ctrl_get_carrier_detect_status(demod, &status));
@@ -11883,9 +11869,9 @@ rw_error:
 *
 */
 static int
-fm_sig_quality(pdrx_demod_instance_t demod, pdrx_sig_quality_t sig_quality)
+fm_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
 {
-	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
+	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 
 	CHK_ERROR(fm_lock_status(demod, &lock_status));
 	if (lock_status == DRX_LOCKED) {
@@ -11923,8 +11909,8 @@ rw_error:
 *
 */
 static int
-get_oob_lock_status(pdrx_demod_instance_t demod,
-		    struct i2c_device_addr *dev_addr, pdrx_lock_status_t oob_lock)
+get_oob_lock_status(struct drx_demod_instance *demod,
+		    struct i2c_device_addr *dev_addr, enum drx_lock_status *oob_lock)
 {
 	drxjscu_cmd_t scu_cmd;
 	u16 cmd_result[2];
@@ -12059,7 +12045,7 @@ rw_error:
 *
 */
 static int
-get_oob_freq_offset(pdrx_demod_instance_t demod, s32 *freq_offset)
+get_oob_freq_offset(struct drx_demod_instance *demod, s32 *freq_offset)
 {
 	u16 data = 0;
 	u16 rot = 0;
@@ -12072,7 +12058,7 @@ get_oob_freq_offset(pdrx_demod_instance_t demod, s32 *freq_offset)
 	u32 data64hi = 0;
 	u32 data64lo = 0;
 	u32 temp_freq_offset = 0;
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	struct i2c_device_addr *dev_addr = NULL;
 
 	/* check arguments */
@@ -12081,7 +12067,7 @@ get_oob_freq_offset(pdrx_demod_instance_t demod, s32 *freq_offset)
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	*freq_offset = 0;
 
@@ -12160,7 +12146,7 @@ rw_error:
 *
 */
 static int
-get_oob_frequency(pdrx_demod_instance_t demod, s32 *frequency)
+get_oob_frequency(struct drx_demod_instance *demod, s32 *frequency)
 {
 	u16 data = 0;
 	s32 freq_offset = 0;
@@ -12335,7 +12321,7 @@ rw_error:
 * \param active
 * \return int.
 */
-static int set_orx_nsu_aox(pdrx_demod_instance_t demod, bool active)
+static int set_orx_nsu_aox(struct drx_demod_instance *demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
@@ -12394,7 +12380,7 @@ rw_error:
 /* Coefficients for the nyquist fitler (total: 27 taps) */
 #define NYQFILTERLEN 27
 
-static int ctrl_set_oob(pdrx_demod_instance_t demod, p_drxoob_t oob_param)
+static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_param)
 {
 #ifndef DRXJ_DIGITAL_ONLY
 	s32 freq = 0;	/* KHz */
@@ -12667,7 +12653,7 @@ rw_error:
 * \return int.
 */
 static int
-ctrl_get_oob(pdrx_demod_instance_t demod, pdrxoob_status_t oob_status)
+ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 {
 #ifndef DRXJ_DIGITAL_ONLY
 	struct i2c_device_addr *dev_addr = NULL;
@@ -12711,7 +12697,7 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_set_cfg_oob_pre_saw(pdrx_demod_instance_t demod, u16 *cfg_data)
+ctrl_set_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -12738,7 +12724,7 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_get_cfg_oob_pre_saw(pdrx_demod_instance_t demod, u16 *cfg_data)
+ctrl_get_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 {
 	pdrxj_data_t ext_attr = NULL;
 
@@ -12761,7 +12747,7 @@ ctrl_get_cfg_oob_pre_saw(pdrx_demod_instance_t demod, u16 *cfg_data)
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_set_cfg_oob_lo_power(pdrx_demod_instance_t demod, p_drxj_cfg_oob_lo_power_t cfg_data)
+ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, p_drxj_cfg_oob_lo_power_t cfg_data)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -12788,7 +12774,7 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_get_cfg_oob_lo_power(pdrx_demod_instance_t demod, p_drxj_cfg_oob_lo_power_t cfg_data)
+ctrl_get_cfg_oob_lo_power(struct drx_demod_instance *demod, p_drxj_cfg_oob_lo_power_t cfg_data)
 {
 	pdrxj_data_t ext_attr = NULL;
 
@@ -12825,7 +12811,7 @@ ctrl_get_cfg_oob_lo_power(pdrx_demod_instance_t demod, p_drxj_cfg_oob_lo_power_t
 *
 */
 static int
-ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
+ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
 
 	s32 tuner_set_freq = 0;
@@ -12836,7 +12822,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 	struct i2c_device_addr *dev_addr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	u32 tuner_mode = 0;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	bool bridge_closed = false;
 #ifndef DRXJ_VSB_ONLY
 	u32 min_symbol_rate = 0;
@@ -12849,7 +12835,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	standard = ext_attr->standard;
@@ -12931,7 +12917,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 #ifndef DRXJ_VSB_ONLY
 	if ((standard == DRX_STANDARD_ITU_A) ||
 	    (standard == DRX_STANDARD_ITU_C)) {
-		drxuio_cfg_t uio_cfg = { DRX_UIO1, DRX_UIO_MODE_FIRMWARE_SAW };
+		struct drxuio_cfg uio_cfg = { DRX_UIO1, DRX_UIO_MODE_FIRMWARE_SAW };
 		int bw_rolloff_factor = 0;
 
 		bw_rolloff_factor = (standard == DRX_STANDARD_ITU_A) ? 115 : 113;
@@ -13013,7 +12999,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 
 	if ((ext_attr->uio_sma_tx_mode) == DRX_UIO_MODE_FIRMWARE_SAW) {
 		/* SAW SW, user UIO is used for switchable SAW */
-		drxuio_data_t uio1 = { DRX_UIO1, false };
+		struct drxuio_data uio1 = { DRX_UIO1, false };
 
 		switch (channel->bandwidth) {
 		case DRX_BANDWIDTH_8MHZ:
@@ -13207,13 +13193,13 @@ rw_error:
 * \return int.
 */
 static int
-ctrl_get_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
+ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
-	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
+	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	s32 intermediate_freq = 0;
 	s32 ctl_freq_offset = 0;
 	u32 iqm_rc_rateLo = 0;
@@ -13231,7 +13217,7 @@ ctrl_get_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	standard = ext_attr->standard;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	/* initialize channel fields */
 	channel->mirror = DRX_MIRROR_UNKNOWN;
@@ -13458,12 +13444,12 @@ mer2indicator(u16 mer, u16 min_mer, u16 threshold_mer, u16 max_mer)
 
 */
 static int
-ctrl_sig_quality(pdrx_demod_instance_t demod, pdrx_sig_quality_t sig_quality)
+ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
+	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	u16 min_mer = 0;
 	u16 max_mer = 0;
 	u16 threshold_mer = 0;
@@ -13592,7 +13578,7 @@ rw_error:
 *
 */
 static int
-ctrl_lock_status(pdrx_demod_instance_t demod, pdrx_lock_status_t lock_stat)
+ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_stat)
 {
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	pdrxj_data_t ext_attr = NULL;
@@ -13689,7 +13675,7 @@ rw_error:
 * \return int.
 */
 static int
-ctrl_constel(pdrx_demod_instance_t demod, pdrx_complex_t complex_nr)
+ctrl_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 {
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 						     /**< active standard */
@@ -13737,7 +13723,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_standard(pdrx_demod_instance_t demod, enum drx_standard *standard)
+ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 {
 	pdrxj_data_t ext_attr = NULL;
 	enum drx_standard prev_standard;
@@ -13837,7 +13823,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_standard(pdrx_demod_instance_t demod, enum drx_standard *standard)
+ctrl_get_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 {
 	pdrxj_data_t ext_attr = NULL;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
@@ -13864,7 +13850,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_symbol_clock_offset(pdrx_demod_instance_t demod, s32 *rate_offset)
+ctrl_get_cfg_symbol_clock_offset(struct drx_demod_instance *demod, s32 *rate_offset)
 {
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	pdrxj_data_t ext_attr = NULL;
@@ -13911,14 +13897,14 @@ rw_error:
 *
 */
 static int
-ctrl_power_mode(pdrx_demod_instance_t demod, pdrx_power_mode_t mode)
+ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 {
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) NULL;
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	u16 sio_cc_pwd_mode = 0;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
@@ -14039,11 +14025,11 @@ rw_error:
 *
 */
 static int
-ctrl_version(pdrx_demod_instance_t demod, p_drx_version_list_t *version_list)
+ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version_list)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	u16 ucode_major_minor = 0;	/* BCD Ma:Ma:Ma:Mi */
 	u16 ucode_patch = 0;	/* BCD Pa:Pa:Pa:Pa */
 	u16 major = 0;
@@ -14061,7 +14047,7 @@ ctrl_version(pdrx_demod_instance_t demod, p_drx_version_list_t *version_list)
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	/* Microcode version *************************************** */
 
@@ -14163,14 +14149,14 @@ ctrl_version(pdrx_demod_instance_t demod, p_drx_version_list_t *version_list)
 	}
 
 	ext_attr->v_list_elements[1].version = &(ext_attr->v_version[1]);
-	ext_attr->v_list_elements[1].next = (p_drx_version_list_t) (NULL);
+	ext_attr->v_list_elements[1].next = (struct drx_version_list *) (NULL);
 
 	*version_list = &(ext_attr->v_list_elements[0]);
 
 	return (DRX_STS_OK);
 
 rw_error:
-	*version_list = (p_drx_version_list_t) (NULL);
+	*version_list = (struct drx_version_list *) (NULL);
 	return (DRX_STS_ERROR);
 
 }
@@ -14189,18 +14175,18 @@ rw_error:
 *
 */
 
-static int ctrl_probe_device(pdrx_demod_instance_t demod)
+static int ctrl_probe_device(struct drx_demod_instance *demod)
 {
-	drx_power_mode_t org_power_mode = DRX_POWER_UP;
+	enum drx_power_mode org_power_mode = DRX_POWER_UP;
 	int ret_status = DRX_STS_OK;
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
+	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	if (common_attr->is_opened == false
 	    || common_attr->current_power_mode != DRX_POWER_UP) {
 		struct i2c_device_addr *dev_addr = NULL;
-		drx_power_mode_t power_mode = DRX_POWER_UP;
+		enum drx_power_mode power_mode = DRX_POWER_UP;
 		u32 jtag = 0;
 
 		dev_addr = demod->my_i2c_dev_addr;
@@ -14287,9 +14273,9 @@ bool is_mc_block_audio(u32 addr)
 * \return int.
 */
 static int
-ctrl_u_codeUpload(pdrx_demod_instance_t demod,
-		  p_drxu_code_info_t mc_info,
-		drxu_code_action_t action, bool upload_audio_mc)
+ctrl_u_codeUpload(struct drx_demod_instance *demod,
+		  struct drxu_code_info *mc_info,
+		enum drxu_code_actionaction, bool upload_audio_mc)
 {
 	u16 i = 0;
 	u16 mc_nr_of_blks = 0;
@@ -14379,7 +14365,7 @@ ctrl_u_codeUpload(pdrx_demod_instance_t demod,
 					    [DRXJ_UCODE_MAX_BUF_SIZE];
 					u32 bytes_to_compare = 0;
 					u32 bytes_left_to_compare = 0;
-					dr_xaddr_t curr_addr = (dr_xaddr_t) 0;
+					u32 curr_addr = (dr_xaddr_t) 0;
 					u8 *curr_ptr = NULL;
 
 					bytes_left_to_compare = mc_block_nr_bytes;
@@ -14468,7 +14454,7 @@ ctrl_u_codeUpload(pdrx_demod_instance_t demod,
 
 */
 static int
-ctrl_sig_strength(pdrx_demod_instance_t demod, u16 *sig_strength)
+ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 {
 	pdrxj_data_t ext_attr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
@@ -14525,7 +14511,7 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_get_cfg_oob_misc(pdrx_demod_instance_t demod, p_drxj_cfg_oob_misc_t misc)
+ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, p_drxj_cfg_oob_misc_t misc)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	u16 lock = 0U;
@@ -14577,7 +14563,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_vsb_misc(pdrx_demod_instance_t demod, p_drxj_cfg_vsb_misc_t misc)
+ctrl_get_cfg_vsb_misc(struct drx_demod_instance *demod, p_drxj_cfg_vsb_misc_t misc)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 
@@ -14608,7 +14594,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14664,7 +14650,7 @@ ctrl_set_cfg_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
 *
 */
 static int
-ctrl_get_cfg_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14711,7 +14697,7 @@ ctrl_get_cfg_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
 *
 */
 static int
-ctrl_set_cfg_agc_rf(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14767,7 +14753,7 @@ ctrl_set_cfg_agc_rf(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
 *
 */
 static int
-ctrl_get_cfg_agc_rf(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14814,10 +14800,10 @@ ctrl_get_cfg_agc_rf(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings)
 *
 */
 static int
-ctrl_get_cfg_agc_internal(pdrx_demod_instance_t demod, u16 *agc_internal)
+ctrl_get_cfg_agc_internal(struct drx_demod_instance *demod, u16 *agc_internal)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
+	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	pdrxj_data_t ext_attr = NULL;
 	u16 iqm_cf_scale_sh = 0;
 	u16 iqm_cf_power = 0;
@@ -14897,7 +14883,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_pre_saw(pdrx_demod_instance_t demod, p_drxj_cfg_pre_saw_t pre_saw)
+ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, p_drxj_cfg_pre_saw_t pre_saw)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -14966,7 +14952,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_afe_gain(pdrx_demod_instance_t demod, p_drxj_cfg_afe_gain_t afe_gain)
+ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, p_drxj_cfg_afe_gain_t afe_gain)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -15042,7 +15028,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_pre_saw(pdrx_demod_instance_t demod, p_drxj_cfg_pre_saw_t pre_saw)
+ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, p_drxj_cfg_pre_saw_t pre_saw)
 {
 	pdrxj_data_t ext_attr = NULL;
 
@@ -15099,7 +15085,7 @@ ctrl_get_cfg_pre_saw(pdrx_demod_instance_t demod, p_drxj_cfg_pre_saw_t pre_saw)
 *
 */
 static int
-ctrl_get_cfg_afe_gain(pdrx_demod_instance_t demod, p_drxj_cfg_afe_gain_t afe_gain)
+ctrl_get_cfg_afe_gain(struct drx_demod_instance *demod, p_drxj_cfg_afe_gain_t afe_gain)
 {
 	pdrxj_data_t ext_attr = NULL;
 
@@ -15141,7 +15127,7 @@ ctrl_get_cfg_afe_gain(pdrx_demod_instance_t demod, p_drxj_cfg_afe_gain_t afe_gai
 *
 */
 static int
-ctrl_get_fec_meas_seq_count(pdrx_demod_instance_t demod, u16 *fec_meas_seq_count)
+ctrl_get_fec_meas_seq_count(struct drx_demod_instance *demod, u16 *fec_meas_seq_count)
 {
 	/* check arguments */
 	if (fec_meas_seq_count == NULL) {
@@ -15169,7 +15155,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_accum_cr_rs_cw_err(pdrx_demod_instance_t demod, u32 *accum_cr_rs_cw_err)
+ctrl_get_accum_cr_rs_cw_err(struct drx_demod_instance *demod, u32 *accum_cr_rs_cw_err)
 {
 	if (accum_cr_rs_cw_err == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -15191,7 +15177,7 @@ rw_error:
 * \return int.
 
 */
-static int ctrl_set_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
+static int ctrl_set_cfg(struct drx_demod_instance *demod, struct drx_cfg *config)
 {
 	if (config == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -15201,7 +15187,7 @@ static int ctrl_set_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 	switch (config->cfg_type) {
 	case DRX_CFG_MPEG_OUTPUT:
 		return ctrl_set_cfg_mpeg_output(demod,
-					    (pdrx_cfg_mpeg_output_t) config->
+					    (struct drx_cfg_mpeg_output *) config->
 					    cfg_data);
 	case DRX_CFG_PINS_SAFE_MODE:
 		return ctrl_set_cfg_pdr_safe_mode(demod, (bool *)config->cfg_data);
@@ -15247,36 +15233,36 @@ static int ctrl_set_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 #ifndef DRXJ_EXCLUDE_AUDIO
 	case DRX_CFG_AUD_VOLUME:
 		return aud_ctrl_set_cfg_volume(demod,
-					   (pdrx_cfg_aud_volume_t) config->
+					   (struct drx_cfg_aud_volume *) config->
 					   cfg_data);
 	case DRX_CFG_I2S_OUTPUT:
 		return aud_ctrl_set_cfg_output_i2s(demod,
-					      (pdrx_cfg_i2s_output_t) config->
+					      (struct drx_cfg_i2s_output *) config->
 					      cfg_data);
 	case DRX_CFG_AUD_AUTOSOUND:
-		return aud_ctr_setl_cfg_auto_sound(demod, (pdrx_cfg_aud_auto_sound_t)
+		return aud_ctr_setl_cfg_auto_sound(demod, (enum drx_cfg_aud_auto_sound *)
 					      config->cfg_data);
 	case DRX_CFG_AUD_ASS_THRES:
-		return aud_ctrl_set_cfg_ass_thres(demod, (pdrx_cfg_aud_ass_thres_t)
+		return aud_ctrl_set_cfg_ass_thres(demod, (struct drx_cfg_aud_ass_thres *)
 					     config->cfg_data);
 	case DRX_CFG_AUD_CARRIER:
 		return aud_ctrl_set_cfg_carrier(demod,
-					    (pdrx_cfg_aud_carriers_t) config->
+					    (struct drx_cfg_aud_carriers *) config->
 					    cfg_data);
 	case DRX_CFG_AUD_DEVIATION:
 		return aud_ctrl_set_cfg_dev(demod,
-					(pdrx_cfg_aud_deviation_t) config->
+					(enum drx_cfg_aud_deviation *) config->
 					cfg_data);
 	case DRX_CFG_AUD_PRESCALE:
 		return aud_ctrl_set_cfg_prescale(demod,
-					     (pdrx_cfg_aud_prescale_t) config->
+					     (struct drx_cfg_aud_prescale *) config->
 					     cfg_data);
 	case DRX_CFG_AUD_MIXER:
 		return aud_ctrl_set_cfg_mixer(demod,
-					  (pdrx_cfg_aud_mixer_t) config->cfg_data);
+					  (struct drx_cfg_aud_mixer *) config->cfg_data);
 	case DRX_CFG_AUD_AVSYNC:
 		return aud_ctrl_set_cfg_av_sync(demod,
-					   (pdrx_cfg_aud_av_sync_t) config->
+					   (enum drx_cfg_aud_av_sync *) config->
 					   cfg_data);
 
 #endif
@@ -15299,7 +15285,7 @@ rw_error:
 * \return int.
 */
 
-static int ctrl_get_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
+static int ctrl_get_cfg(struct drx_demod_instance *demod, struct drx_cfg *config)
 {
 	if (config == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -15310,7 +15296,7 @@ static int ctrl_get_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 	switch (config->cfg_type) {
 	case DRX_CFG_MPEG_OUTPUT:
 		return ctrl_get_cfg_mpeg_output(demod,
-					    (pdrx_cfg_mpeg_output_t) config->
+					    (struct drx_cfg_mpeg_output *) config->
 					    cfg_data);
 	case DRX_CFG_PINS_SAFE_MODE:
 		return ctrl_get_cfg_pdr_safe_mode(demod, (bool *)config->cfg_data);
@@ -15372,42 +15358,42 @@ static int ctrl_get_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 #ifndef DRXJ_EXCLUDE_AUDIO
 	case DRX_CFG_AUD_VOLUME:
 		return aud_ctrl_get_cfg_volume(demod,
-					   (pdrx_cfg_aud_volume_t) config->
+					   (struct drx_cfg_aud_volume *) config->
 					   cfg_data);
 	case DRX_CFG_I2S_OUTPUT:
 		return aud_ctrl_get_cfg_output_i2s(demod,
-					      (pdrx_cfg_i2s_output_t) config->
+					      (struct drx_cfg_i2s_output *) config->
 					      cfg_data);
 
 	case DRX_CFG_AUD_RDS:
 		return aud_ctrl_get_cfg_rds(demod,
-					(pdrx_cfg_aud_rds_t) config->cfg_data);
+					(struct drx_cfg_aud_rds *) config->cfg_data);
 	case DRX_CFG_AUD_AUTOSOUND:
 		return aud_ctrl_get_cfg_auto_sound(demod,
-					      (pdrx_cfg_aud_auto_sound_t) config->
+					      (enum drx_cfg_aud_auto_sound *) config->
 					      cfg_data);
 	case DRX_CFG_AUD_ASS_THRES:
 		return aud_ctrl_get_cfg_ass_thres(demod,
-					     (pdrx_cfg_aud_ass_thres_t) config->
+					     (struct drx_cfg_aud_ass_thres *) config->
 					     cfg_data);
 	case DRX_CFG_AUD_CARRIER:
 		return aud_ctrl_get_cfg_carrier(demod,
-					    (pdrx_cfg_aud_carriers_t) config->
+					    (struct drx_cfg_aud_carriers *) config->
 					    cfg_data);
 	case DRX_CFG_AUD_DEVIATION:
 		return aud_ctrl_get_cfg_dev(demod,
-					(pdrx_cfg_aud_deviation_t) config->
+					(enum drx_cfg_aud_deviation *) config->
 					cfg_data);
 	case DRX_CFG_AUD_PRESCALE:
 		return aud_ctrl_get_cfg_prescale(demod,
-					     (pdrx_cfg_aud_prescale_t) config->
+					     (struct drx_cfg_aud_prescale *) config->
 					     cfg_data);
 	case DRX_CFG_AUD_MIXER:
 		return aud_ctrl_get_cfg_mixer(demod,
-					  (pdrx_cfg_aud_mixer_t) config->cfg_data);
+					  (struct drx_cfg_aud_mixer *) config->cfg_data);
 	case DRX_CFG_AUD_AVSYNC:
 		return aud_ctrl_get_cfg_av_sync(demod,
-					   (pdrx_cfg_aud_av_sync_t) config->
+					   (enum drx_cfg_aud_av_sync *) config->
 					   cfg_data);
 #endif
 
@@ -15432,14 +15418,14 @@ rw_error:
 * rely on SCU or AUD ucode to be present.
 *
 */
-int drxj_open(pdrx_demod_instance_t demod)
+int drxj_open(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct drx_common_attr *common_attr = NULL;
 	u32 driver_version = 0;
-	drxu_code_info_t ucode_info;
-	drx_cfg_mpeg_output_t cfg_mpeg_output;
+	struct drxu_code_info ucode_info;
+	struct drx_cfg_mpeg_output cfg_mpeg_output;
 
 	/* Check arguments */
 	if (demod->my_ext_attr == NULL) {
@@ -15448,7 +15434,7 @@ int drxj_open(pdrx_demod_instance_t demod)
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
+	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	CHK_ERROR(power_up_device(demod));
 	common_attr->current_power_mode = DRX_POWER_UP;
@@ -15649,11 +15635,11 @@ rw_error:
 * \return Status_t Return status.
 *
 */
-int drxj_close(pdrx_demod_instance_t demod)
+int drxj_close(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
-	pdrx_common_attr_t common_attr = demod->my_common_attr;
-	drx_power_mode_t power_mode = DRX_POWER_UP;
+	struct drx_common_attr *common_attr = demod->my_common_attr;
+	enum drx_power_mode power_mode = DRX_POWER_UP;
 
 	/* power up */
 	CHK_ERROR(ctrl_power_mode(demod, &power_mode));
@@ -15687,26 +15673,26 @@ rw_error:
 * \return Status_t Return status.
 */
 int
-drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
+drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 {
 	switch (ctrl) {
       /*======================================================================*/
 	case DRX_CTRL_SET_CHANNEL:
 		{
-			return ctrl_set_channel(demod, (pdrx_channel_t) ctrl_data);
+			return ctrl_set_channel(demod, (struct drx_channel *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_CHANNEL:
 		{
-			return ctrl_get_channel(demod, (pdrx_channel_t) ctrl_data);
+			return ctrl_get_channel(demod, (struct drx_channel *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_SIG_QUALITY:
 		{
 			return ctrl_sig_quality(demod,
-					      (pdrx_sig_quality_t) ctrl_data);
+					      (struct drx_sig_quality *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -15718,19 +15704,19 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_CONSTEL:
 		{
-			return ctrl_constel(demod, (pdrx_complex_t) ctrl_data);
+			return ctrl_constel(demod, (struct drx_complex *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_SET_CFG:
 		{
-			return ctrl_set_cfg(demod, (pdrx_cfg_t) ctrl_data);
+			return ctrl_set_cfg(demod, (struct drx_cfg *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_CFG:
 		{
-			return ctrl_get_cfg(demod, (pdrx_cfg_t) ctrl_data);
+			return ctrl_get_cfg(demod, (struct drx_cfg *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -15743,7 +15729,7 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 	case DRX_CTRL_LOCK_STATUS:
 		{
 			return ctrl_lock_status(demod,
-					      (pdrx_lock_status_t) ctrl_data);
+					      (enum drx_lock_status *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -15763,14 +15749,14 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_POWER_MODE:
 		{
-			return ctrl_power_mode(demod, (pdrx_power_mode_t) ctrl_data);
+			return ctrl_power_mode(demod, (enum drx_power_mode *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_VERSION:
 		{
 			return ctrl_version(demod,
-					   (p_drx_version_list_t *)ctrl_data);
+					   (struct drx_version_list **)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -15782,64 +15768,64 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_SET_OOB:
 		{
-			return ctrl_set_oob(demod, (p_drxoob_t) ctrl_data);
+			return ctrl_set_oob(demod, (struct drxoob *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_OOB:
 		{
-			return ctrl_get_oob(demod, (pdrxoob_status_t) ctrl_data);
+			return ctrl_get_oob(demod, (struct drxoob_status *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_SET_UIO_CFG:
 		{
-			return ctrl_set_uio_cfg(demod, (pdrxuio_cfg_t) ctrl_data);
+			return ctrl_set_uio_cfg(demod, (struct drxuio_cfg *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_UIO_CFG:
 		{
-			return CtrlGetuio_cfg(demod, (pdrxuio_cfg_t) ctrl_data);
+			return CtrlGetuio_cfg(demod, (struct drxuio_cfg *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_UIO_READ:
 		{
-			return ctrl_uio_read(demod, (pdrxuio_data_t) ctrl_data);
+			return ctrl_uio_read(demod, (struct drxuio_data *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_UIO_WRITE:
 		{
-			return ctrl_uio_write(demod, (pdrxuio_data_t) ctrl_data);
+			return ctrl_uio_write(demod, (struct drxuio_data *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_AUD_SET_STANDARD:
 		{
 			return aud_ctrl_set_standard(demod,
-						  (pdrx_aud_standard_t) ctrl_data);
+						  (enum drx_aud_standard *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_AUD_GET_STANDARD:
 		{
 			return aud_ctrl_get_standard(demod,
-						  (pdrx_aud_standard_t) ctrl_data);
+						  (enum drx_aud_standard *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_AUD_GET_STATUS:
 		{
 			return aud_ctrl_get_status(demod,
-						(pdrx_aud_status_t) ctrl_data);
+						(struct drx_aud_status *) ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_AUD_BEEP:
 		{
-			return aud_ctrl_beep(demod, (pdrx_aud_beep_t) ctrl_data);
+			return aud_ctrl_beep(demod, (struct drx_aud_beep *) ctrl_data);
 		}
 		break;
 
@@ -15847,7 +15833,7 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 	case DRX_CTRL_I2C_READWRITE:
 		{
 			return ctrl_i2c_write_read(demod,
-						(pdrxi2c_data_t) ctrl_data);
+						(struct drxi2c_data *) ctrl_data);
 		}
 		break;
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index d882f2279619..91272f100128 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -489,10 +489,10 @@ TYPEDEFS
 		u16 hi_cfg_transmit;	  /**< HI Configure() parameter 6                       */
 
 		/* UIO configuartion */
-		drxuio_mode_t uio_sma_rx_mode;/**< current mode of SmaRx pin                        */
-		drxuio_mode_t uio_sma_tx_mode;/**< current mode of SmaTx pin                        */
-		drxuio_mode_t uio_gpio_mode; /**< current mode of ASEL pin                         */
-		drxuio_mode_t uio_irqn_mode; /**< current mode of IRQN pin                         */
+		enum drxuio_mode uio_sma_rx_mode;/**< current mode of SmaRx pin                        */
+		enum drxuio_mode uio_sma_tx_mode;/**< current mode of SmaTx pin                        */
+		enum drxuio_mode uio_gpio_mode; /**< current mode of ASEL pin                         */
+		enum drxuio_mode uio_irqn_mode; /**< current mode of IRQN pin                         */
 
 		/* IQM fs frequecy shift and inversion */
 		u32 iqm_fs_rate_ofs;	   /**< frequency shifter setting after setchannel      */
@@ -531,8 +531,8 @@ TYPEDEFS
 
 		/* Version information */
 		char v_text[2][12];	  /**< allocated text versions */
-		drx_version_t v_version[2]; /**< allocated versions structs */
-		drx_version_list_t v_list_elements[2];
+		struct drx_version v_version[2]; /**< allocated versions structs */
+		struct drx_version_list v_list_elements[2];
 					  /**< allocated version list */
 
 		/* smart antenna configuration */
@@ -571,7 +571,7 @@ TYPEDEFS
 		u16 oob_pre_saw;
 		drxj_cfg_oob_lo_power_t oob_lo_pow;
 
-		drx_aud_data_t aud_data;
+		struct drx_aud_data aud_data;
 				    /**< audio storage                  */
 
 	} drxj_data_t, *pdrxj_data_t;
@@ -723,20 +723,20 @@ STRUCTS
 Exported FUNCTIONS
 -------------------------------------------------------------------------*/
 
-	int drxj_open(pdrx_demod_instance_t demod);
-	int drxj_close(pdrx_demod_instance_t demod);
-	int drxj_ctrl(pdrx_demod_instance_t demod,
+	int drxj_open(struct drx_demod_instance *demod);
+	int drxj_close(struct drx_demod_instance *demod);
+	int drxj_ctrl(struct drx_demod_instance *demod,
 				     u32 ctrl, void *ctrl_data);
 
 /*-------------------------------------------------------------------------
 Exported GLOBAL VARIABLES
 -------------------------------------------------------------------------*/
-	extern drx_access_func_t drx_dap_drxj_funct_g;
-	extern drx_demod_func_t drxj_functions_g;
+	extern struct drx_access_func drx_dap_drxj_funct_g;
+	extern struct drx_demod_func drxj_functions_g;
 	extern drxj_data_t drxj_data_g;
 	extern struct i2c_device_addr drxj_default_addr_g;
-	extern drx_common_attr_t drxj_default_comm_attr_g;
-	extern drx_demod_instance_t drxj_default_demod_g;
+	extern struct drx_common_attr drxj_default_comm_attr_g;
+	extern struct drx_demod_instance drxj_default_demod_g;
 
 /*-------------------------------------------------------------------------
 THE END
-- 
1.8.5.3

