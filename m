Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:47591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0KIPKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 10:10:04 -0500
Message-ID: <4CD96444.4080404@infradead.org>
Date: Tue, 09 Nov 2010 13:09:56 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [GIT PATCHES FOR 2.6.37] Various gspca patches
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-10-2010 10:35, Hans de Goede escreveu:
> Hi Mauro,
> 
> Please pull from:
> http://linuxtv.org/hg/~hgoede/ibmcam3
> 
> Starting at the commit titled:
> gspca: submit interrupt urbs *after* isoc urbs
> 
> This pull consists of the following commits:
> gspca: submit interrupt urbs *after* isoc urbs
> gspca: only set gspca->int_urb if submitting it succeeds
> gspca-stv06xx: support bandwidth changing
> gspca_xirlink_cit: various usb bandwidth allocation improvements / fixes
> gspca_xirlink_cit: Frames have a 4 byte footer
> gspca_xirlink_cit: Add support camera button
> gspca_ov519: generate release button event on stream stop if needed
> 
> Note that since the hg v4l-dvb tree is a bit out of data, pulling from
> my hg tree won't apply cleanly though. So to make things easier for you
> I'm in the process of switching over to git. This mail will be followed
> by the 7 patches from this pull request in git format-patch format, rebased
> on top of the master branch of your git tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
> 
> The reason I'm not sending a git pull request is because I don't
> have a git tree, and I could not find documentation for creating
> a git tree @ git.linuxtv.org. Can you help me with this?
> 
> Also this wiki page:
> http://linuxtv.org/wiki/index.php/Maintaining_Git_trees
> Points to the obsolete: git://linuxtv.org/v4l-dvb.git
> Repository, please update it.
> 
> Thanks & Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

All patches but one applied fine. I had to do one trivial merge conflict fix.

This one, however, has a more complex conflict, so I prefer if you could fix
and re-send. Feel free to resend via email, if you were not able to create your
git tree yet.

Thanks,
Mauro.


From: Hans de Goede  <hdegoede@redhat.com>
Commiter: Hans de Goede <hdegoede@redhat.com>
Date: Tue Oct 26 14:43:35 2010 +0200
Subject: gspca-stv06xx: support bandwidth changing

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

Priority: normal

Signed-off-by: Lee Jones <lee.jones@canonical.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---

diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx.c linux/drivers/media/video/gspca/stv06xx/stv06xx.c
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx.c	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx.c	2010-11-09 12:41:24.000000000 -0200
@@ -263,7 +263,21 @@ static int stv06xx_init(struct gspca_dev
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
 #ifdef CONFIG_INPUT
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	2010-11-09 12:41:24.000000000 -0200
@@ -146,6 +146,11 @@ const struct stv06xx_sensor stv06xx_sens
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
@@ -160,6 +165,11 @@ const struct stv06xx_sensor stv06xx_sens
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
@@ -177,7 +187,6 @@ static const u16 stv_bridge_init[][2] = 
 	{STV_REG04, 0x07},
 
 	{STV_SCAN_RATE, 0x20},
-	{STV_ISO_SIZE_L, 847},
 	{STV_Y_CTRL, 0x01},
 	{STV_X_CTRL, 0x0a}
 };
diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c linux/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c	2010-11-09 12:41:24.000000000 -0200
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
diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h linux/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h	2010-11-09 12:41:24.000000000 -0200
@@ -138,6 +138,9 @@ const struct stv06xx_sensor stv06xx_sens
 	.i2c_addr = 0xba,
 	.i2c_len = 2,
 
+	.min_packet_size = { 635, 847 },
+	.max_packet_size = { 847, 923 },
+
 	.init = pb0100_init,
 	.probe = pb0100_probe,
 	.start = pb0100_start,
diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h linux/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h	2010-11-09 12:41:24.000000000 -0200
@@ -53,6 +53,10 @@ struct stv06xx_sensor {
 	/* length of an i2c word */
 	u8 i2c_len;
 
+	/* Isoc packet size (per mode) */
+	int min_packet_size[4];
+	int max_packet_size[4];
+
 	/* Probes if the sensor is connected */
 	int (*probe)(struct sd *sd);
 
diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c linux/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c	2010-11-09 12:41:24.000000000 -0200
@@ -213,7 +213,6 @@ static int st6422_init(struct sd *sd)
 		{ 0x150e, 0x8e },
 		{ 0x150f, 0x37 },
 		{ 0x15c0, 0x00 },
-		{ 0x15c1, 1023 }, /* 160x120, ISOC_PACKET_SIZE */
 		{ 0x15c3, 0x08 },	/* 0x04/0x14 ... test pictures ??? */
 
 
@@ -237,23 +236,9 @@ static void st6422_disconnect(struct sd 
 
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
-		PDEBUG(D_ERR, "Couldn't get altsetting");
-		return -EIO;
-	}
-
-	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
-	err = stv06xx_write_bridge(sd, 0x15c1, packet_size);
-	if (err < 0)
-		return err;
 
 	if (cam->cam_mode[sd->gspca_dev.curr_mode].priv)
 		err = stv06xx_write_bridge(sd, 0x1505, 0x0f);
diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h linux/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h	2010-11-09 12:41:24.000000000 -0200
@@ -49,6 +49,9 @@ static int st6422_set_exposure(struct gs
 
 const struct stv06xx_sensor stv06xx_sensor_st6422 = {
 	.name = "ST6422",
+	/* No known way to lower framerate in case of less bandwidth */
+	.min_packet_size = { 300, 847 },
+	.max_packet_size = { 300, 847 },
 	.init = st6422_init,
 	.probe = st6422_probe,
 	.start = st6422_start,
diff -upNr oldtree/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h linux/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
--- oldtree/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h	2010-11-09 12:41:28.000000000 -0200
+++ linux/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h	2010-11-09 12:41:24.000000000 -0200
@@ -197,6 +197,10 @@ const struct stv06xx_sensor stv06xx_sens
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
@@ -220,10 +224,6 @@ static const u8 x1536[] = {	/* 0x1536 - 
 	0x02, 0x00, 0x60, 0x01, 0x20, 0x01
 };
 
-static const u8 x15c1[] = {	/* 0x15c1 - 0x15c2 */
-	0xff, 0x03 /* Output word 0x03ff = 1023 (ISO size) */
-};
-
 static const struct stv_init stv_bridge_init[] = {
 	/* This reg is written twice. Some kind of reset? */
 	{NULL,  0x1620, 0x80},
@@ -232,7 +232,6 @@ static const struct stv_init stv_bridge_
 	{NULL,  0x1423, 0x04},
 	{x1500, 0x1500, ARRAY_SIZE(x1500)},
 	{x1536, 0x1536, ARRAY_SIZE(x1536)},
-	{x15c1, 0x15c1, ARRAY_SIZE(x15c1)}
 };
 
 static const u8 vv6410_sensor_init[][2] = {
