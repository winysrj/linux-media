Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58292 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbbFGKc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 06:32:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] adv7511: log the currently set infoframes
Date: Sun,  7 Jun 2015 12:32:32 +0200
Message-Id: <1433673155-20179-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
References: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The adv7511 sets up InfoFrames that are used when transmitting video.
Log the contents of those InfoFrames so it is possible to see exactly what
the transmitter is sending.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig                |   1 +
 drivers/media/i2c/adv7511.c              | 123 ++++++++++++++++++++++++++++++-
 drivers/media/pci/cobalt/cobalt-driver.c |   1 +
 include/media/adv7511.h                  |   1 +
 4 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 36f5563..c92180d 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -424,6 +424,7 @@ config VIDEO_ADV7393
 config VIDEO_ADV7511
 	tristate "Analog Devices ADV7511 encoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	select HDMI
 	---help---
 	  Support for the Analog Devices ADV7511 video encoder.
 
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index d9bb90b..95bcd40 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -91,6 +91,7 @@ struct adv7511_state {
 	int chip_revision;
 	u8 i2c_edid_addr;
 	u8 i2c_cec_addr;
+	u8 i2c_pktmem_addr;
 	/* Is the adv7511 powered on? */
 	bool power_on;
 	/* Did we receive hotplug and rx-sense signals? */
@@ -109,6 +110,7 @@ struct adv7511_state {
 	struct v4l2_ctrl *have_edid0_ctrl;
 	struct v4l2_ctrl *rgb_quantization_range_ctrl;
 	struct i2c_client *i2c_edid;
+	struct i2c_client *i2c_pktmem;
 	struct adv7511_state_edid edid;
 	/* Running counter of the number of detected EDIDs (for debugging) */
 	unsigned edid_detect_counter;
@@ -238,6 +240,35 @@ static inline void adv7511_edid_rd(struct v4l2_subdev *sd, u16 len, u8 *buf)
 		v4l2_err(sd, "%s: i2c read error\n", __func__);
 }
 
+static int adv7511_pktmem_rd(struct v4l2_subdev *sd, u8 reg)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+
+	return adv_smbus_read_byte_data(state->i2c_pktmem, reg);
+}
+
+static int adv7511_pktmem_wr(struct v4l2_subdev *sd, u8 reg, u8 val)
+{
+	struct adv7511_state *state = get_adv7511_state(sd);
+	int ret;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		ret = i2c_smbus_write_byte_data(state->i2c_pktmem, reg, val);
+		if (ret == 0)
+			return 0;
+	}
+	v4l2_err(sd, "%s: i2c write error\n", __func__);
+	return ret;
+}
+
+/* To set specific bits in the register, a clear-mask is given (to be AND-ed),
+   and then the value-mask (to be OR-ed). */
+static inline void adv7511_pktmem_wr_and_or(struct v4l2_subdev *sd, u8 reg, u8 clr_mask, u8 val_mask)
+{
+	adv7511_pktmem_wr(sd, reg, (adv7511_pktmem_rd(sd, reg) & clr_mask) | val_mask);
+}
+
 static inline bool adv7511_have_hotplug(struct v4l2_subdev *sd)
 {
 	return adv7511_rd(sd, 0x42) & MASK_ADV7511_HPD_DETECT;
@@ -415,6 +446,80 @@ static int adv7511_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 }
 #endif
 
+struct adv7511_cfg_read_infoframe {
+	const char *desc;
+	u8 present_reg;
+	u8 present_mask;
+	u8 header[3];
+	u16 payload_addr;
+};
+
+static u8 hdmi_infoframe_checksum(u8 *ptr, size_t size)
+{
+	u8 csum = 0;
+	size_t i;
+
+	/* compute checksum */
+	for (i = 0; i < size; i++)
+		csum += ptr[i];
+
+	return 256 - csum;
+}
+
+static void log_infoframe(struct v4l2_subdev *sd, const struct adv7511_cfg_read_infoframe *cri)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	union hdmi_infoframe frame;
+	u8 buffer[32];
+	u8 len;
+	int i;
+
+	if (!(adv7511_rd(sd, cri->present_reg) & cri->present_mask)) {
+		v4l2_info(sd, "%s infoframe not transmitted\n", cri->desc);
+		return;
+	}
+
+	memcpy(buffer, cri->header, sizeof(cri->header));
+
+	len = buffer[2];
+
+	if (len + 4 > sizeof(buffer)) {
+		v4l2_err(sd, "%s: invalid %s infoframe length %d\n", __func__, cri->desc, len);
+		return;
+	}
+
+	if (cri->payload_addr >= 0x100) {
+		for (i = 0; i < len; i++)
+			buffer[i + 4] = adv7511_pktmem_rd(sd, cri->payload_addr + i - 0x100);
+	} else {
+		for (i = 0; i < len; i++)
+			buffer[i + 4] = adv7511_rd(sd, cri->payload_addr + i);
+	}
+	buffer[3] = 0;
+	buffer[3] = hdmi_infoframe_checksum(buffer, len + 4);
+
+	if (hdmi_infoframe_unpack(&frame, buffer) < 0) {
+		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__, cri->desc);
+		return;
+	}
+
+	hdmi_infoframe_log(KERN_INFO, dev, &frame);
+}
+
+static void adv7511_log_infoframes(struct v4l2_subdev *sd)
+{
+	static const struct adv7511_cfg_read_infoframe cri[] = {
+		{ "AVI", 0x44, 0x10, { 0x82, 2, 13 }, 0x55 },
+		{ "Audio", 0x44, 0x08, { 0x84, 1, 10 }, 0x73 },
+		{ "SDP", 0x40, 0x40, { 0x83, 1, 25 }, 0x103 },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cri); i++)
+		log_infoframe(sd, &cri[i]);
+}
+
 static int adv7511_log_status(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
@@ -480,6 +585,7 @@ static int adv7511_log_status(struct v4l2_subdev *sd)
 			  manual_cts ? "manual" : "automatic", N, CTS);
 		v4l2_info(sd, "VIC: detected %d, sent %d\n",
 			  vic_detect, vic_sent);
+		adv7511_log_infoframes(sd);
 	}
 	if (state->dv_timings.type == V4L2_DV_BT_656_1120)
 		v4l2_print_dv_timings(sd->name, "timings: ",
@@ -488,6 +594,7 @@ static int adv7511_log_status(struct v4l2_subdev *sd)
 		v4l2_info(sd, "no timings set\n");
 	v4l2_info(sd, "i2c edid addr: 0x%x\n", state->i2c_edid_addr);
 	v4l2_info(sd, "i2c cec addr: 0x%x\n", state->i2c_cec_addr);
+	v4l2_info(sd, "i2c pktmem addr: 0x%x\n", state->i2c_pktmem_addr);
 	return 0;
 }
 
@@ -537,6 +644,7 @@ static int adv7511_s_power(struct v4l2_subdev *sd, int on)
 	adv7511_wr(sd, 0xf9, 0x00);
 
 	adv7511_wr(sd, 0x43, state->i2c_edid_addr);
+	adv7511_wr(sd, 0x45, state->i2c_pktmem_addr);
 
 	/* Set number of attempts to read the EDID */
 	adv7511_wr(sd, 0xc9, 0xf);
@@ -1381,6 +1489,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 	/* EDID and CEC i2c addr */
 	state->i2c_edid_addr = state->pdata.i2c_edid << 1;
 	state->i2c_cec_addr = state->pdata.i2c_cec << 1;
+	state->i2c_pktmem_addr = state->pdata.i2c_pktmem << 1;
 
 	state->chip_revision = adv7511_rd(sd, 0x0);
 	chip_id[0] = adv7511_rd(sd, 0xf5);
@@ -1398,12 +1507,19 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 		goto err_entity;
 	}
 
+	state->i2c_pktmem = i2c_new_dummy(client->adapter, state->i2c_pktmem_addr >> 1);
+	if (state->i2c_pktmem == NULL) {
+		v4l2_err(sd, "failed to register pktmem i2c client\n");
+		err = -ENOMEM;
+		goto err_unreg_edid;
+	}
+
 	adv7511_wr(sd, 0xe2, 0x01); /* power down cec section */
 	state->work_queue = create_singlethread_workqueue(sd->name);
 	if (state->work_queue == NULL) {
 		v4l2_err(sd, "could not create workqueue\n");
 		err = -ENOMEM;
-		goto err_unreg_cec;
+		goto err_unreg_pktmem;
 	}
 
 	INIT_DELAYED_WORK(&state->edid_handler, adv7511_edid_handler);
@@ -1416,7 +1532,9 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 			  client->addr << 1, client->adapter->name);
 	return 0;
 
-err_unreg_cec:
+err_unreg_pktmem:
+	i2c_unregister_device(state->i2c_pktmem);
+err_unreg_edid:
 	i2c_unregister_device(state->i2c_edid);
 err_entity:
 	media_entity_cleanup(&sd->entity);
@@ -1440,6 +1558,7 @@ static int adv7511_remove(struct i2c_client *client)
 	adv7511_init_setup(sd);
 	cancel_delayed_work(&state->edid_handler);
 	i2c_unregister_device(state->i2c_edid);
+	i2c_unregister_device(state->i2c_pktmem);
 	destroy_workqueue(state->work_queue);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index c2974e6..b994b8e 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -602,6 +602,7 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 	static struct adv7511_platform_data adv7511_pdata = {
 		.i2c_edid = 0x7e >> 1,
 		.i2c_cec = 0x7c >> 1,
+		.i2c_pktmem = 0x70 >> 1,
 		.cec_clk = 12000000,
 	};
 	static struct i2c_board_info adv7511_info = {
diff --git a/include/media/adv7511.h b/include/media/adv7511.h
index f351eff..d83b91d 100644
--- a/include/media/adv7511.h
+++ b/include/media/adv7511.h
@@ -42,6 +42,7 @@ struct adv7511_cec_arg {
 struct adv7511_platform_data {
 	u8 i2c_edid;
 	u8 i2c_cec;
+	u8 i2c_pktmem;
 	u32 cec_clk;
 };
 
-- 
2.1.4

