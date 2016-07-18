Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:53230 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcGRVS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 17:18:26 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	Nick Dyer <nick@shmanahar.org>
Subject: [PATCH v8 03/10] Input: atmel_mxt_ts - add support for T37 diagnostic data
Date: Mon, 18 Jul 2016 22:10:31 +0100
Message-Id: <1468876238-24599-4-git-send-email-nick@shmanahar.org>
In-Reply-To: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Atmel maXTouch devices have a T37 object which can be used to read raw
touch deltas from the device. This consists of an array of 16-bit
integers, one for each node on the touchscreen matrix.

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 drivers/input/touchscreen/Kconfig        |    6 ++
 drivers/input/touchscreen/atmel_mxt_ts.c |  159 ++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 8ecdc38..da96ecf 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -115,6 +115,12 @@ config TOUCHSCREEN_ATMEL_MXT
 	  To compile this driver as a module, choose M here: the
 	  module will be called atmel_mxt_ts.
 
+config TOUCHSCREEN_ATMEL_MXT_T37
+	bool "Support T37 Diagnostic Data"
+	depends on TOUCHSCREEN_ATMEL_MXT
+	help
+	  Say Y here if you want support for the T37 Diagnostic Data object.
+
 config TOUCHSCREEN_AUO_PIXCIR
 	tristate "AUO in-cell touchscreen using Pixcir ICs"
 	depends on I2C
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5af7907..0048233 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -124,6 +124,19 @@ struct t9_range {
 #define MXT_COMMS_CTRL		0
 #define MXT_COMMS_CMD		1
 
+/* MXT_DEBUG_DIAGNOSTIC_T37 */
+#define MXT_DIAGNOSTIC_PAGEUP	0x01
+#define MXT_DIAGNOSTIC_DELTAS	0x10
+#define MXT_DIAGNOSTIC_SIZE	128
+
+struct t37_debug {
+#ifdef CONFIG_TOUCHSCREEN_ATMEL_MXT_T37
+	u8 mode;
+	u8 page;
+	u8 data[MXT_DIAGNOSTIC_SIZE];
+#endif
+};
+
 /* Define for MXT_GEN_COMMAND_T6 */
 #define MXT_BOOT_VALUE		0xa5
 #define MXT_RESET_VALUE		0x01
@@ -205,6 +218,14 @@ struct mxt_object {
 	u8 num_report_ids;
 } __packed;
 
+struct mxt_dbg {
+	u16 t37_address;
+	u16 diag_cmd_address;
+	struct t37_debug *t37_buf;
+	unsigned int t37_pages;
+	unsigned int t37_nodes;
+};
+
 /* Each client has this additional data */
 struct mxt_data {
 	struct i2c_client *client;
@@ -233,6 +254,7 @@ struct mxt_data {
 	u8 num_touchids;
 	u8 multitouch;
 	struct t7_config t7_cfg;
+	struct mxt_dbg dbg;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -2043,6 +2065,141 @@ recheck:
 	return 0;
 }
 
+#ifdef CONFIG_TOUCHSCREEN_ATMEL_MXT_T37
+static u16 mxt_get_debug_value(struct mxt_data *data, unsigned int x,
+			       unsigned int y)
+{
+	struct mxt_dbg *dbg = &data->dbg;
+	unsigned int ofs, page;
+
+	ofs = (y + (x * data->info.matrix_ysize)) * sizeof(u16);
+	page = ofs / MXT_DIAGNOSTIC_SIZE;
+	ofs %= MXT_DIAGNOSTIC_SIZE;
+
+	return get_unaligned_le16(&dbg->t37_buf[page].data[ofs]);
+}
+
+static int mxt_convert_debug_pages(struct mxt_data *data, u16 *outbuf)
+{
+	struct mxt_dbg *dbg = &data->dbg;
+	unsigned int x = 0;
+	unsigned int y = 0;
+	unsigned int i;
+
+	for (i = 0; i < dbg->t37_nodes; i++) {
+		outbuf[i] = mxt_get_debug_value(data, x, y);
+
+		/* Next value */
+		if (++x >= data->info.matrix_xsize) {
+			x = 0;
+			y++;
+		}
+	}
+
+	return 0;
+}
+
+static int mxt_read_diagnostic_debug(struct mxt_data *data, u8 mode,
+				     u16 *outbuf)
+{
+	struct mxt_dbg *dbg = &data->dbg;
+	int retries = 0;
+	int page;
+	int ret;
+	u8 cmd = mode;
+	struct t37_debug *p;
+	u8 cmd_poll;
+
+	for (page = 0; page < dbg->t37_pages; page++) {
+		p = dbg->t37_buf + page;
+
+		ret = mxt_write_reg(data->client, dbg->diag_cmd_address,
+				    cmd);
+		if (ret)
+			return ret;
+
+		retries = 0;
+		msleep(20);
+wait_cmd:
+		/* Read back command byte */
+		ret = __mxt_read_reg(data->client, dbg->diag_cmd_address,
+				     sizeof(cmd_poll), &cmd_poll);
+		if (ret)
+			return ret;
+
+		/* Field is cleared once the command has been processed */
+		if (cmd_poll) {
+			if (retries++ > 100)
+				return -EINVAL;
+
+			msleep(20);
+			goto wait_cmd;
+		}
+
+		/* Read T37 page */
+		ret = __mxt_read_reg(data->client, dbg->t37_address,
+				     sizeof(struct t37_debug), p);
+		if (ret)
+			return ret;
+
+		if (p->mode != mode || p->page != page) {
+			dev_err(&data->client->dev, "T37 page mismatch\n");
+			return -EINVAL;
+		}
+
+		dev_dbg(&data->client->dev, "%s page:%d retries:%d\n",
+			__func__, page, retries);
+
+		/* For remaining pages, write PAGEUP rather than mode */
+		cmd = MXT_DIAGNOSTIC_PAGEUP;
+	}
+
+	return mxt_convert_debug_pages(data, outbuf);
+}
+
+static void mxt_debug_init(struct mxt_data *data)
+{
+	struct mxt_dbg *dbg = &data->dbg;
+	struct mxt_object *object;
+
+	object = mxt_get_object(data, MXT_GEN_COMMAND_T6);
+	if (!object)
+		goto error;
+
+	dbg->diag_cmd_address = object->start_address + MXT_COMMAND_DIAGNOSTIC;
+
+	object = mxt_get_object(data, MXT_DEBUG_DIAGNOSTIC_T37);
+	if (!object)
+		goto error;
+
+	if (mxt_obj_size(object) != sizeof(struct t37_debug)) {
+		dev_warn(&data->client->dev, "Bad T37 size");
+		goto error;
+	}
+
+	dbg->t37_address = object->start_address;
+
+	/* Calculate size of data and allocate buffer */
+	dbg->t37_nodes = data->info.matrix_xsize * data->info.matrix_ysize;
+	dbg->t37_pages = DIV_ROUND_UP(dbg->t37_nodes * sizeof(u16),
+				      sizeof(dbg->t37_buf->data));
+
+	dbg->t37_buf = devm_kmalloc_array(&data->client->dev, dbg->t37_pages,
+					  sizeof(struct t37_debug), GFP_KERNEL);
+	if (!dbg->t37_buf)
+		goto error;
+
+	return;
+
+error:
+	dev_warn(&data->client->dev, "Error initializing T37\n");
+}
+#else
+static void mxt_debug_init(struct mxt_data *data)
+{
+}
+#endif
+
 static int mxt_configure_objects(struct mxt_data *data,
 				 const struct firmware *cfg)
 {
@@ -2070,6 +2227,8 @@ static int mxt_configure_objects(struct mxt_data *data,
 		dev_warn(dev, "No touch object detected\n");
 	}
 
+	mxt_debug_init(data);
+
 	dev_info(dev,
 		 "Family: %u Variant: %u Firmware V%u.%u.%02X Objects: %u\n",
 		 info->family_id, info->variant_id, info->version >> 4,
-- 
1.7.9.5

