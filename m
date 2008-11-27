Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAR7QOQK012592
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 02:26:24 -0500
Received: from smtps.ntu.edu.tw (smtps.ntu.edu.tw [140.112.2.142])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAR7QBdX005029
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 02:26:12 -0500
Date: Thu, 27 Nov 2008 15:26:18 +0800
From: Chia-I Wu <olvaffe@gmail.com>
To: Erik =?iso-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Message-ID: <20081127072618.GA19421@m500.domain>
References: <20081126074633.GA11305@m500.domain>
	<62e5edd40811260110pacffdf7v15e4ddabc587399@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62e5edd40811260110pacffdf7v15e4ddabc587399@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca-stv06xx: Overhaul the HDCS driver.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 26, 2008 at 10:10:37AM +0100, Erik Andrén wrote:
> Thanks, I'll review and commit it ASAP.
> Do you still get a black and white image or does it work in color?
Another two patches to fix the color issue and add controls.  The
colors should be correct now.

I was testing with

$ gst-launch-0.10 v4l2src \! xvimagesink

and things work.  Somehow, ekiga does not work.  I will look into it.
Probably just wrong gstreamer version is used on my machine.  Other than
that, I plan to go on to fix issues like, re-connect of device requires
re-init, removal of the global struct hdcs, and etc.

-- 
Regards,
olv

--h31gzZEtNLTqOjlF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="wrong-fourcc-advertised-in-hdcs-driver.patch"

Wrong fourcc advertised in HDCS driver.

From: Chia-I Wu <olvaffe@gmail.com>

The raw format of HDCS 1x00 and 1020 is Bayer GRBG.  Advertise it correctly.

Priority: normal

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>

diff -r 8ea65863e5b9 linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	Wed Nov 26 15:36:38 2008 +0800
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	Thu Nov 27 15:11:40 2008 +0800
@@ -145,7 +145,7 @@
 	{
 		HDCS_1X00_DEF_WIDTH,
 		HDCS_1X00_DEF_HEIGHT,
-		V4L2_PIX_FMT_SBGGR8,
+		V4L2_PIX_FMT_SGRBG8,
 		V4L2_FIELD_NONE,
 		.sizeimage =
 			HDCS_1X00_DEF_WIDTH * HDCS_1X00_DEF_HEIGHT,
@@ -176,7 +176,7 @@
 	{
 		HDCS_1020_DEF_WIDTH,
 		HDCS_1020_DEF_HEIGHT,
-		V4L2_PIX_FMT_SBGGR8,
+		V4L2_PIX_FMT_SGRBG8,
 		V4L2_FIELD_NONE,
 		.sizeimage =
 			HDCS_1020_DEF_WIDTH * HDCS_1020_DEF_HEIGHT,


--h31gzZEtNLTqOjlF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="add-controls-to-hdcs-driver.patch"

Add controls to HDCS driver.

From: Chia-I Wu <olvaffe@gmail.com>

The exposure and gains are dynamically adjustable.  Export them as controls.

Priority: normal

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>

diff -r 8ea65863e5b9 linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	Wed Nov 26 15:36:38 2008 +0800
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	Thu Nov 27 15:11:40 2008 +0800
@@ -38,6 +38,13 @@
 	HDCS_STATE_SLEEP,
 	HDCS_STATE_IDLE,
 	HDCS_STATE_RUN,
+	N_HDCS_STATES
+};
+
+enum {
+	HDCS_CTRL_EXPOSURE,
+	HDCS_CTRL_GAIN,
+	N_HDCS_CTRLS
 };
 
 /* no lock? */
@@ -49,6 +56,9 @@
 	char is_870:1;
 	int state;
 	int w, h;
+	int exposure;
+	/* GRBG */
+	int gains[4];
 
 	/* visible area of the sensor array */
 	struct {
@@ -253,28 +263,38 @@
 			ret = hdcs_reg_write(hdcs, HDCS_STATUS, BIT(4));
 	}
 
+	if (!ret)
+		hdcs->exposure = us;
+
 	return ret;
 }
 
 static int hdcs_set_gains(struct hdcs *hdcs, u8 r, u8 g, u8 b)
 {
 	u8 gains[4];
+	int i, ret;
 
 	/* the voltage gain Av = (1 + 19 * val / 127) * (1 + bit7) */
-
-	if (r > 127)
-		r = 0x80 | (r / 2);
-	if (g > 127)
-		g = 0x80 | (g / 2);
-	if (b > 127)
-		b = 0x80 | (b / 2);
 
 	gains[0] = g;
 	gains[1] = r;
 	gains[2] = b;
 	gains[3] = g;
 
-	return hdcs_reg_write_seq(hdcs, HDCS_ERECPGA, gains, 4);
+	for (i = 0; i < 4; i++) {
+		if (gains[i] > 127)
+			gains[i] = 0x80 | (gains[i] / 2);
+	}
+
+	ret = hdcs_reg_write_seq(hdcs, HDCS_ERECPGA, gains, 4);
+	if (!ret) {
+		hdcs->gains[0] = g;
+		hdcs->gains[1] = r;
+		hdcs->gains[2] = b;
+		hdcs->gains[3] = g;
+	}
+
+	return ret;
 }
 
 static int hdcs_set_size(struct hdcs *hdcs,
@@ -319,6 +339,100 @@
 	return ret;
 }
 
+static int hdcs_ctrl_set_gain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct hdcs *hdcs = to_hdcs((struct sd *) gspca_dev);
+	int orig_state, ret;
+	u8 r, g, b;
+
+	orig_state = hdcs->state;
+
+	if (orig_state == HDCS_STATE_SLEEP) {
+		ret = hdcs_set_state(hdcs, HDCS_STATE_IDLE);
+		if (ret)
+			goto fail;
+	}
+
+	r = (val >> 16) & 0xff;
+	g = (val >> 8) & 0xff;
+	b = val & 0xff;
+
+	ret = hdcs_set_gains(hdcs, r, g, b);
+
+fail:
+	hdcs_set_state(hdcs, orig_state);
+
+	return ret;
+}
+
+static int hdcs_ctrl_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct hdcs *hdcs = to_hdcs((struct sd *) gspca_dev);
+
+	*val = (hdcs->gains[1] << 16) | (hdcs->gains[0] << 8) | hdcs->gains[2];
+
+	return 0;
+}
+
+static int hdcs_ctrl_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct hdcs *hdcs = to_hdcs((struct sd *) gspca_dev);
+	int orig_state, ret;
+
+	orig_state = hdcs->state;
+
+	ret = hdcs_set_state(hdcs, HDCS_STATE_IDLE);
+	if (ret)
+		goto fail;
+
+	ret = hdcs_set_exposure(hdcs, val);
+
+fail:
+	hdcs_set_state(hdcs, orig_state);
+
+	return ret;
+}
+
+static int hdcs_ctrl_get_exposure(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct hdcs *hdcs = to_hdcs((struct sd *) gspca_dev);
+
+	*val = hdcs->exposure;
+
+	return 0;
+}
+
+static struct ctrl hdcs_ctrls[N_HDCS_CTRLS] = {
+	[HDCS_CTRL_EXPOSURE] = {
+		.qctrl = {
+			.id = V4L2_CID_EXPOSURE,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Exposure",
+			.minimum = 1000,
+			.maximum = 10000,
+			.step = 1000,
+			.default_value = 5000,
+			.flags = 0,
+		},
+		.set = hdcs_ctrl_set_exposure,
+		.get = hdcs_ctrl_get_exposure,
+	},
+	[HDCS_CTRL_GAIN] = {
+		.qctrl = {
+			.id = V4L2_CID_GAIN,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Gain",
+			.minimum = 0x00000000,
+			.maximum = 0x00ffffff,
+			.step = 1,
+			.default_value = 0x00808080,
+			.flags = 0,
+		},
+		.set = hdcs_ctrl_set_gain,
+		.get = hdcs_ctrl_get_gain,
+	},
+};
+
 int hdcs_probe_1x00(struct sd *sd)
 {
 	struct hdcs *hdcs;
@@ -339,8 +453,8 @@
 
 	sd->gspca_dev.cam.cam_mode = stv06xx_sensor_hdcs1x00.modes;
 	sd->gspca_dev.cam.nmodes = stv06xx_sensor_hdcs1x00.nmodes;
-	sd->desc->ctrls = stv06xx_sensor_hdcs1x00.ctrls;
-	sd->desc->nctrls = stv06xx_sensor_hdcs1x00.nctrls;
+	sd->desc->ctrls = hdcs_ctrls;
+	sd->desc->nctrls = ARRAY_SIZE(hdcs_ctrls);
 
 	hdcs->sd = sd;
 
@@ -407,8 +521,8 @@
 
 	sd->gspca_dev.cam.cam_mode = stv06xx_sensor_hdcs1020.modes;
 	sd->gspca_dev.cam.nmodes = stv06xx_sensor_hdcs1020.nmodes;
-	sd->desc->ctrls = stv06xx_sensor_hdcs1020.ctrls;
-	sd->desc->nctrls = stv06xx_sensor_hdcs1020.nctrls;
+	sd->desc->ctrls = hdcs_ctrls;
+	sd->desc->nctrls = ARRAY_SIZE(hdcs_ctrls);
 
 	hdcs->sd = sd;
 

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--h31gzZEtNLTqOjlF--
