Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39643 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753352AbdK2Kqk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:40 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Andi Shyti <andi.shyti@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/12] media: rc: fix lots of documentation warnings
Date: Wed, 29 Nov 2017 05:46:23 -0500
Message-Id: <f67f366c69c8e2287cfe32a3b2406ff706b43075.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building the driver with gcc 7.2.1 and:
	make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' M=drivers/media

now produces a lot of warnings:
	drivers/media/rc/rc-main.c:278: warning: No description found for parameter 'new_keycode'
	drivers/media/rc/rc-main.c:278: warning: Excess function parameter 'keycode' description in 'ir_update_mapping'
	drivers/media/rc/rc-main.c:387: warning: No description found for parameter 'ke'
	drivers/media/rc/rc-main.c:387: warning: No description found for parameter 'old_keycode'
	drivers/media/rc/rc-main.c:387: warning: Excess function parameter 'scancode' description in 'ir_setkeycode'
	drivers/media/rc/rc-main.c:387: warning: Excess function parameter 'keycode' description in 'ir_setkeycode'
	drivers/media/rc/rc-main.c:433: warning: Excess function parameter 'to' description in 'ir_setkeytable'
	drivers/media/rc/rc-main.c:506: warning: No description found for parameter 'ke'
	drivers/media/rc/rc-main.c:506: warning: Excess function parameter 'scancode' description in 'ir_getkeycode'
	drivers/media/rc/rc-main.c:506: warning: Excess function parameter 'keycode' description in 'ir_getkeycode'
	drivers/media/rc/rc-main.c:634: warning: No description found for parameter 't'
	drivers/media/rc/rc-main.c:634: warning: Excess function parameter 'cookie' description in 'ir_timer_keyup'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/rc-main.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 17950e29d4e3..c4b0217bd169 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -170,10 +170,11 @@ static struct rc_map_list empty_map = {
  * @name:	name to assign to the table
  * @rc_proto:	ir type to assign to the new table
  * @size:	initial size of the table
- * @return:	zero on success or a negative error code
  *
  * This routine will initialize the rc_map and will allocate
  * memory to hold at least the specified number of elements.
+ *
+ * return:	zero on success or a negative error code
  */
 static int ir_create_table(struct rc_map *rc_map,
 			   const char *name, u64 rc_proto, size_t size)
@@ -216,10 +217,11 @@ static void ir_free_table(struct rc_map *rc_map)
  * ir_resize_table() - resizes a scancode table if necessary
  * @rc_map:	the rc_map to resize
  * @gfp_flags:	gfp flags to use when allocating memory
- * @return:	zero on success or a negative error code
  *
  * This routine will shrink the rc_map if it has lots of
  * unused entries and grow it if it is full.
+ *
+ * return:	zero on success or a negative error code
  */
 static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
 {
@@ -265,11 +267,13 @@ static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
  * @dev:	the struct rc_dev device descriptor
  * @rc_map:	scancode table to be adjusted
  * @index:	index of the mapping that needs to be updated
- * @keycode:	the desired keycode
- * @return:	previous keycode assigned to the mapping
+ * @new_keycode: the desired keycode
  *
  * This routine is used to update scancode->keycode mapping at given
  * position.
+ *
+ * return:	previous keycode assigned to the mapping
+ *
  */
 static unsigned int ir_update_mapping(struct rc_dev *dev,
 				      struct rc_map *rc_map,
@@ -320,12 +324,13 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
  * @scancode:	the desired scancode
  * @resize:	controls whether we allowed to resize the table to
  *		accommodate not yet present scancodes
- * @return:	index of the mapping containing scancode in question
- *		or -1U in case of failure.
  *
  * This routine is used to locate given scancode in rc_map.
  * If scancode is not yet present the routine will allocate a new slot
  * for it.
+ *
+ * return:	index of the mapping containing scancode in question
+ *		or -1U in case of failure.
  */
 static unsigned int ir_establish_scancode(struct rc_dev *dev,
 					  struct rc_map *rc_map,
@@ -375,11 +380,12 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 /**
  * ir_setkeycode() - set a keycode in the scancode->keycode table
  * @idev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	result
- * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ * @ke:		Input keymap entry
+ * @old_keycode: result
  *
  * This routine is used to handle evdev EVIOCSKEY ioctl.
+ *
+ * return:	-EINVAL if the keycode could not be inserted, otherwise zero.
  */
 static int ir_setkeycode(struct input_dev *idev,
 			 const struct input_keymap_entry *ke,
@@ -422,11 +428,11 @@ static int ir_setkeycode(struct input_dev *idev,
 /**
  * ir_setkeytable() - sets several entries in the scancode->keycode table
  * @dev:	the struct rc_dev device descriptor
- * @to:		the struct rc_map to copy entries to
  * @from:	the struct rc_map to copy entries from
- * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
  *
  * This routine is used to handle table initialization.
+ *
+ * return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
  */
 static int ir_setkeytable(struct rc_dev *dev,
 			  const struct rc_map *from)
@@ -474,10 +480,11 @@ static int rc_map_cmp(const void *key, const void *elt)
  * ir_lookup_by_scancode() - locate mapping by scancode
  * @rc_map:	the struct rc_map to search
  * @scancode:	scancode to look for in the table
- * @return:	index in the table, -1U if not found
  *
  * This routine performs binary search in RC keykeymap table for
  * given scancode.
+ *
+ * return:	index in the table, -1U if not found
  */
 static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
 					  unsigned int scancode)
@@ -495,11 +502,11 @@ static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
 /**
  * ir_getkeycode() - get a keycode from the scancode->keycode table
  * @idev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	used to return the keycode, if found, or KEY_RESERVED
- * @return:	always returns zero.
+ * @ke:		Input keymap entry
  *
  * This routine is used to handle evdev EVIOCGKEY ioctl.
+ *
+ * return:	always returns zero.
  */
 static int ir_getkeycode(struct input_dev *idev,
 			 struct input_keymap_entry *ke)
@@ -556,11 +563,12 @@ static int ir_getkeycode(struct input_dev *idev,
  * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
  * @dev:	the struct rc_dev descriptor of the device
  * @scancode:	the scancode to look for
- * @return:	the corresponding keycode, or KEY_RESERVED
  *
  * This routine is used by drivers which need to convert a scancode to a
  * keycode. Normally it should not be used since drivers should have no
  * interest in keycodes.
+ *
+ * return:	the corresponding keycode, or KEY_RESERVED
  */
 u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 {
@@ -625,7 +633,8 @@ EXPORT_SYMBOL_GPL(rc_keyup);
 
 /**
  * ir_timer_keyup() - generates a keyup event after a timeout
- * @cookie:	a pointer to the struct rc_dev for the device
+ *
+ * @t:		a pointer to the struct timer_list
  *
  * This routine will generate a keyup event some time after a keydown event
  * is generated when no further activity has been detected.
@@ -780,7 +789,8 @@ EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
  *			  provides sensible defaults
  * @dev:	the struct rc_dev descriptor of the device
  * @filter:	the scancode and mask
- * @return:	0 or -EINVAL if the filter is not valid
+ *
+ * return:	0 or -EINVAL if the filter is not valid
  */
 static int rc_validate_filter(struct rc_dev *dev,
 			      struct rc_scancode_filter *filter)
-- 
2.14.3
