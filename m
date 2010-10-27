Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761105Ab0J0Mbi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:38 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/7] gspca-stv06xx: support bandwidth changing
Date: Wed, 27 Oct 2010 14:35:22 +0200
Message-Id: <1288182926-25400-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

stv06xx devices have only one altsetting, but the actual used
bandwidth can be programmed through a register. We were already
setting this register lower then the max packetsize of the altsetting
indicates. This patch makes the gspca-stv06xx update the usb descriptor
for the alt setting to reflect the actual packetsize in use, so that
the usb subsystem uses the correct information for scheduling usb transfers.

This patch also tries to fallback to lower speeds in case a ENOSPC error
is received when submitting urbs, but currently this is only supported
with stv06xx cams with the pb0100 sensor, as this is the only one for
which we know how to change the framerate.

This patch is based on an initial incomplete patch by
Lee Jones <lee.jones@canonical.com>

Signed-off-by: Lee Jones <lee.jones@canonical.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   55 +++++++++++++++++++-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |   11 ++++-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |   18 +++++--
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h |    3 +
 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |    4 ++
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |   17 +------
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.h |    3 +
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    9 ++--
 8 files changed, 93 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c b/drivers/media/video/gspca/stv06xx/stv06xx.c
index 086de44..ca86762 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
@@ -263,7 +263,21 @@ static int stv06xx_init(struct gspca_dev *gspca_dev)
 static int stv06xx_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int err;
+	struct usb_host_interface *alt;
+	struct usb_interface *intf;
+	int err, packet_size;
+
+	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
+	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
+	if (!alt) {
+		PDEBUG(D_ERR, "Couldn't get altsetting");
+		return -EIO;
+	}
+
+	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
+	err = stv06xx_write_bridge(sd, STV_ISO_SIZE_L, packet_size);
+	if (err < 0)
+		return err;
 
 	/* Prepare the sensor for start */
 	err = sd->sensor->start(sd);
@@ -282,6 +296,43 @@ out:
 	return (err < 0) ? err : 0;
 }
 
+static int stv06xx_isoc_init(struct gspca_dev *gspca_dev)
+{
+	struct usb_host_interface *alt;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	/* Start isoc bandwidth "negotiation" at max isoc bandwidth */
+	alt = &gspca_dev->dev->config->intf_cache[0]->altsetting[1];
+	alt->endpoint[0].desc.wMaxPacketSize =
+		cpu_to_le16(sd->sensor->max_packet_size[gspca_dev->curr_mode]);
+
+	return 0;
+}
+
+static int stv06xx_isoc_nego(struct gspca_dev *gspca_dev)
+{
+	int ret, packet_size, min_packet_size;
+	struct usb_host_interface *alt;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	alt = &gspca_dev->dev->config->intf_cache[0]->altsetting[1];
+	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
+	min_packet_size = sd->sensor->min_packet_size[gspca_dev->curr_mode];
+	if (packet_size <= min_packet_size)
+		return -EIO;
+
+	packet_size -= 100;
+	if (packet_size < min_packet_size)
+		packet_size = min_packet_size;
+	alt->endpoint[0].desc.wMaxPacketSize = cpu_to_le16(packet_size);
+
+	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 1);
+	if (ret < 0)
+		PDEBUG(D_ERR|D_STREAM, "set alt 1 err %d", ret);
+
+	return ret;
+}
+
 static void stv06xx_stopN(struct gspca_dev *gspca_dev)
 {
 	int err;
@@ -462,6 +513,8 @@ static const struct sd_desc sd_desc = {
 	.start = stv06xx_start,
 	.stopN = stv06xx_stopN,
 	.pkt_scan = stv06xx_pkt_scan,
+	.isoc_init = stv06xx_isoc_init,
+	.isoc_nego = stv06xx_isoc_nego,
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
index cf3d0cc..b538dce 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
@@ -146,6 +146,11 @@ const struct stv06xx_sensor stv06xx_sensor_hdcs1x00 = {
 	.i2c_addr = (0x55 << 1),
 	.i2c_len = 1,
 
+	/* FIXME (see if we can lower min_packet_size, needs testing, and also
+	   adjusting framerate when the bandwidth gets lower) */
+	.min_packet_size = { 847 },
+	.max_packet_size = { 847 },
+
 	.init = hdcs_init,
 	.probe = hdcs_probe_1x00,
 	.start = hdcs_start,
@@ -160,6 +165,11 @@ const struct stv06xx_sensor stv06xx_sensor_hdcs1020 = {
 	.i2c_addr = (0x55 << 1),
 	.i2c_len = 1,
 
+	/* FIXME (see if we can lower min_packet_size, needs testing, and also
+	   adjusting framerate when the bandwidthm gets lower) */
+	.min_packet_size = { 847 },
+	.max_packet_size = { 847 },
+
 	.init = hdcs_init,
 	.probe = hdcs_probe_1020,
 	.start = hdcs_start,
@@ -177,7 +187,6 @@ static const u16 stv_bridge_init[][2] = {
 	{STV_REG04, 0x07},
 
 	{STV_SCAN_RATE, 0x20},
-	{STV_ISO_SIZE_L, 847},
 	{STV_Y_CTRL, 0x01},
 	{STV_X_CTRL, 0x0a}
 };
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
index 285221e..ac47b4c 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
@@ -208,11 +208,24 @@ static int pb0100_probe(struct sd *sd)
 
 static int pb0100_start(struct sd *sd)
 {
-	int err;
+	int err, packet_size, max_packet_size;
+	struct usb_host_interface *alt;
+	struct usb_interface *intf;
 	struct cam *cam = &sd->gspca_dev.cam;
 	s32 *sensor_settings = sd->sensor_priv;
 	u32 mode = cam->cam_mode[sd->gspca_dev.curr_mode].priv;
 
+	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
+	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
+	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
+
+	/* If we don't have enough bandwidth use a lower framerate */
+	max_packet_size = sd->sensor->max_packet_size[sd->gspca_dev.curr_mode];
+	if (packet_size < max_packet_size)
+		stv06xx_write_sensor(sd, PB_ROWSPEED, BIT(4)|BIT(3)|BIT(1));
+	else
+		stv06xx_write_sensor(sd, PB_ROWSPEED, BIT(5)|BIT(3)|BIT(1));
+
 	/* Setup sensor window */
 	if (mode & PB0100_CROP_TO_VGA) {
 		stv06xx_write_sensor(sd, PB_RSTART, 30);
@@ -328,9 +341,6 @@ static int pb0100_init(struct sd *sd)
 	stv06xx_write_bridge(sd, STV_REG03, 0x45);
 	stv06xx_write_bridge(sd, STV_REG04, 0x07);
 
-	/* ISO-Size (0x27b: 635... why? - HDCS uses 847) */
-	stv06xx_write_bridge(sd, STV_ISO_SIZE_L, 847);
-
 	/* Scan/timing for the sensor */
 	stv06xx_write_sensor(sd, PB_ROWSPEED, BIT(4)|BIT(3)|BIT(1));
 	stv06xx_write_sensor(sd, PB_CFILLIN, 14);
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
index 4de4fa5..757de24 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
@@ -138,6 +138,9 @@ const struct stv06xx_sensor stv06xx_sensor_pb0100 = {
 	.i2c_addr = 0xba,
 	.i2c_len = 2,
 
+	.min_packet_size = { 635, 847 },
+	.max_packet_size = { 847, 923 },
+
 	.init = pb0100_init,
 	.probe = pb0100_probe,
 	.start = pb0100_start,
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h b/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
index 934b9ce..fb229d8 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
@@ -53,6 +53,10 @@ struct stv06xx_sensor {
 	/* length of an i2c word */
 	u8 i2c_len;
 
+	/* Isoc packet size (per mode) */
+	int min_packet_size[4];
+	int max_packet_size[4];
+
 	/* Probes if the sensor is connected */
 	int (*probe)(struct sd *sd);
 
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
index 3af5326..42390bd 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
@@ -213,7 +213,6 @@ static int st6422_init(struct sd *sd)
 		{ 0x150e, 0x8e },
 		{ 0x150f, 0x37 },
 		{ 0x15c0, 0x00 },
-		{ 0x15c1, 1023 }, /* 160x120, ISOC_PACKET_SIZE */
 		{ 0x15c3, 0x08 },	/* 0x04/0x14 ... test pictures ??? */
 
 
@@ -237,23 +236,9 @@ static void st6422_disconnect(struct sd *sd)
 
 static int st6422_start(struct sd *sd)
 {
-	int err, packet_size;
+	int err;
 	struct cam *cam = &sd->gspca_dev.cam;
 	s32 *sensor_settings = sd->sensor_priv;
-	struct usb_host_interface *alt;
-	struct usb_interface *intf;
-
-	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
-	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
-	if (!alt) {
-		err("Couldn't get altsetting");
-		return -EIO;
-	}
-
-	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
-	err = stv06xx_write_bridge(sd, 0x15c1, packet_size);
-	if (err < 0)
-		return err;
 
 	if (cam->cam_mode[sd->gspca_dev.curr_mode].priv)
 		err = stv06xx_write_bridge(sd, 0x1505, 0x0f);
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
index b2d45fe..12608ae 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
@@ -49,6 +49,9 @@ static int st6422_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
 
 const struct stv06xx_sensor stv06xx_sensor_st6422 = {
 	.name = "ST6422",
+	/* No known way to lower framerate in case of less bandwidth */
+	.min_packet_size = { 300, 847 },
+	.max_packet_size = { 300, 847 },
 	.init = st6422_init,
 	.probe = st6422_probe,
 	.start = st6422_start,
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
index b3b5508..7fe3587 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
@@ -197,6 +197,10 @@ const struct stv06xx_sensor stv06xx_sensor_vv6410 = {
 	.i2c_flush = 5,
 	.i2c_addr = 0x20,
 	.i2c_len = 1,
+	/* FIXME (see if we can lower packet_size-s, needs testing, and also
+	   adjusting framerate when the bandwidth gets lower) */
+	.min_packet_size = { 1023 },
+	.max_packet_size = { 1023 },
 	.init = vv6410_init,
 	.probe = vv6410_probe,
 	.start = vv6410_start,
@@ -220,10 +224,6 @@ static const u8 x1536[] = {	/* 0x1536 - 0x153b */
 	0x02, 0x00, 0x60, 0x01, 0x20, 0x01
 };
 
-static const u8 x15c1[] = {	/* 0x15c1 - 0x15c2 */
-	0xff, 0x03 /* Output word 0x03ff = 1023 (ISO size) */
-};
-
 static const struct stv_init stv_bridge_init[] = {
 	/* This reg is written twice. Some kind of reset? */
 	{NULL,  0x1620, 0x80},
@@ -232,7 +232,6 @@ static const struct stv_init stv_bridge_init[] = {
 	{NULL,  0x1423, 0x04},
 	{x1500, 0x1500, ARRAY_SIZE(x1500)},
 	{x1536, 0x1536, ARRAY_SIZE(x1536)},
-	{x15c1, 0x15c1, ARRAY_SIZE(x15c1)}
 };
 
 static const u8 vv6410_sensor_init[][2] = {
-- 
1.7.3.1

