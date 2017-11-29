Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60481 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbdK2MIQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 07:08:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>
Subject: [PATCH 7/7] media: m5mols: fix some kernel-doc markups
Date: Wed, 29 Nov 2017 07:08:10 -0500
Message-Id: <c1abf81b6489858c7acfa13570eaec910f4ea409.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those warnings:
	drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'addr_num'
	drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'addr_den'
	drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'val'
	drivers/media/i2c/m5mols/m5mols_capture.c:60: warning: No description found for parameter 'info'
	drivers/media/i2c/m5mols/m5mols_controls.c:134: warning: No description found for parameter 'info'
	drivers/media/i2c/m5mols/m5mols_core.c:124: warning: No description found for parameter 'data'
	drivers/media/i2c/m5mols/m5mols_core.c:124: warning: No description found for parameter 'length'
	drivers/media/i2c/m5mols/m5mols_core.c:124: warning: Excess function parameter 'size' description in 'm5mols_swap_byte'
	drivers/media/i2c/m5mols/m5mols_core.c:142: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:241: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:299: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:324: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:324: warning: No description found for parameter 'reg'
	drivers/media/i2c/m5mols/m5mols_core.c:357: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:357: warning: No description found for parameter 'mode'
	drivers/media/i2c/m5mols/m5mols_core.c:374: warning: No description found for parameter 'info'
	drivers/media/i2c/m5mols/m5mols_core.c:429: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:503: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:671: warning: No description found for parameter 'info'
	drivers/media/i2c/m5mols/m5mols_core.c:694: warning: No description found for parameter 'info'
	drivers/media/i2c/m5mols/m5mols_core.c:798: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:853: warning: No description found for parameter 'sd'
	drivers/media/i2c/m5mols/m5mols_core.c:853: warning: No description found for parameter 'on'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/m5mols/m5mols_capture.c  |  5 +++++
 drivers/media/i2c/m5mols/m5mols_controls.c |  1 +
 drivers/media/i2c/m5mols/m5mols_core.c     | 20 ++++++++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_capture.c b/drivers/media/i2c/m5mols/m5mols_capture.c
index a0cd6dc32eb0..0fb457f57995 100644
--- a/drivers/media/i2c/m5mols/m5mols_capture.c
+++ b/drivers/media/i2c/m5mols/m5mols_capture.c
@@ -33,6 +33,10 @@
 
 /**
  * m5mols_read_rational - I2C read of a rational number
+ * @sd: sub-device, as pointed by struct v4l2_subdev
+ * @addr_num: numerator register
+ * @addr_den: denominator register
+ * @val: place to store the division result
  *
  * Read numerator and denominator from registers @addr_num and @addr_den
  * respectively and return the division result in @val.
@@ -53,6 +57,7 @@ static int m5mols_read_rational(struct v4l2_subdev *sd, u32 addr_num,
 
 /**
  * m5mols_capture_info - Gather captured image information
+ * @info: M-5MOLS driver data structure
  *
  * For now it gathers only EXIF information and file size.
  */
diff --git a/drivers/media/i2c/m5mols/m5mols_controls.c b/drivers/media/i2c/m5mols/m5mols_controls.c
index c2218c0a9e6f..82eab7c2bc8c 100644
--- a/drivers/media/i2c/m5mols/m5mols_controls.c
+++ b/drivers/media/i2c/m5mols/m5mols_controls.c
@@ -126,6 +126,7 @@ static struct m5mols_scenemode m5mols_default_scenemode[] = {
 
 /**
  * m5mols_do_scenemode() - Change current scenemode
+ * @info: M-5MOLS driver data structure
  * @mode:	Desired mode of the scenemode
  *
  * WARNING: The execution order is important. Do not change the order.
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 463534d44756..12e79f9e32d5 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -114,7 +114,8 @@ static const struct m5mols_resolution m5mols_reg_res[] = {
 
 /**
  * m5mols_swap_byte - an byte array to integer conversion function
- * @size: size in bytes of I2C packet defined in the M-5MOLS datasheet
+ * @data: byte array
+ * @length: size in bytes of I2C packet defined in the M-5MOLS datasheet
  *
  * Convert I2C data byte array with performing any required byte
  * reordering to assure proper values for each data type, regardless
@@ -132,8 +133,9 @@ static u32 m5mols_swap_byte(u8 *data, u8 length)
 
 /**
  * m5mols_read -  I2C read function
- * @reg: combination of size, category and command for the I2C packet
+ * @sd: sub-device, as pointed by struct v4l2_subdev
  * @size: desired size of I2C packet
+ * @reg: combination of size, category and command for the I2C packet
  * @val: read value
  *
  * Returns 0 on success, or else negative errno.
@@ -232,6 +234,7 @@ int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg, u32 *val)
 
 /**
  * m5mols_write - I2C command write function
+ * @sd: sub-device, as pointed by struct v4l2_subdev
  * @reg: combination of size, category and command for the I2C packet
  * @val: value to write
  *
@@ -284,6 +287,7 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 
 /**
  * m5mols_busy_wait - Busy waiting with I2C register polling
+ * @sd: sub-device, as pointed by struct v4l2_subdev
  * @reg: the I2C_REG() address of an 8-bit status register to check
  * @value: expected status register value
  * @mask: bit mask for the read status register value
@@ -316,6 +320,8 @@ int m5mols_busy_wait(struct v4l2_subdev *sd, u32 reg, u32 value, u32 mask,
 
 /**
  * m5mols_enable_interrupt - Clear interrupt pending bits and unmask interrupts
+ * @sd: sub-device, as pointed by struct v4l2_subdev
+ * @reg: combination of size, category and command for the I2C packet
  *
  * Before writing desired interrupt value the INT_FACTOR register should
  * be read to clear pending interrupts.
@@ -349,6 +355,8 @@ int m5mols_wait_interrupt(struct v4l2_subdev *sd, u8 irq_mask, u32 timeout)
 
 /**
  * m5mols_reg_mode - Write the mode and check busy status
+ * @sd: sub-device, as pointed by struct v4l2_subdev
+ * @mode: the required operation mode
  *
  * It always accompanies a little delay changing the M-5MOLS mode, so it is
  * needed checking current busy status to guarantee right mode.
@@ -364,6 +372,7 @@ static int m5mols_reg_mode(struct v4l2_subdev *sd, u8 mode)
 
 /**
  * m5mols_set_mode - set the M-5MOLS controller mode
+ * @info: M-5MOLS driver data structure
  * @mode: the required operation mode
  *
  * The commands of M-5MOLS are grouped into specific modes. Each functionality
@@ -421,6 +430,7 @@ int m5mols_set_mode(struct m5mols_info *info, u8 mode)
 
 /**
  * m5mols_get_version - retrieve full revisions information of M-5MOLS
+ * @sd: sub-device, as pointed by struct v4l2_subdev
  *
  * The version information includes revisions of hardware and firmware,
  * AutoFocus alghorithm version and the version string.
@@ -489,6 +499,7 @@ static enum m5mols_restype __find_restype(u32 code)
 
 /**
  * __find_resolution - Lookup preset and type of M-5MOLS's resolution
+ * @sd: sub-device, as pointed by struct v4l2_subdev
  * @mf: pixel format to find/negotiate the resolution preset for
  * @type: M-5MOLS resolution type
  * @resolution:	M-5MOLS resolution preset register value
@@ -662,6 +673,7 @@ static const struct v4l2_subdev_pad_ops m5mols_pad_ops = {
 
 /**
  * m5mols_restore_controls - Apply current control values to the registers
+ * @info: M-5MOLS driver data structure
  *
  * m5mols_do_scenemode() handles all parameters for which there is yet no
  * individual control. It should be replaced at some point by setting each
@@ -686,6 +698,7 @@ int m5mols_restore_controls(struct m5mols_info *info)
 
 /**
  * m5mols_start_monitor - Start the monitor mode
+ * @info: M-5MOLS driver data structure
  *
  * Before applying the controls setup the resolution and frame rate
  * in PARAMETER mode, and then switch over to MONITOR mode.
@@ -789,6 +802,7 @@ int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
 
 /**
  * m5mols_fw_start - M-5MOLS internal ARM controller initialization
+ * @sd: sub-device, as pointed by struct v4l2_subdev
  *
  * Execute the M-5MOLS internal ARM controller initialization sequence.
  * This function should be called after the supply voltage has been
@@ -844,6 +858,8 @@ static int m5mols_auto_focus_stop(struct m5mols_info *info)
 
 /**
  * m5mols_s_power - Main sensor power control function
+ * @sd: sub-device, as pointed by struct v4l2_subdev
+ * @on: if true, powers on the device; powers off otherwise.
  *
  * To prevent breaking the lens when the sensor is powered off the Soft-Landing
  * algorithm is called where available. The Soft-Landing algorithm availability
-- 
2.14.3
