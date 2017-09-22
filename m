Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:42587 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751795AbdIVTUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 15:20:50 -0400
From: Joe Perches <joe@perches.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, Frank Zago <frank@zago.net>,
        Olivier Lorin <o.lorin@laposte.net>,
        Erik Andren <erik.andren@gmail.com>,
        Brian Johnson <brijohn@gmail.com>,
        Leandro Costantino <lcostantino@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gspca: Convert PDEBUG to gspca_dbg
Date: Fri, 22 Sep 2017 12:20:33 -0700
Message-Id: <8fae7c060947673ea69a07daecb6218cfe46844a.1506108002.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a more typical logging style.

The current macro hides the gspca_dev argument so add it to the
macro uses instead.

Miscellanea:

o Add missing '\n' terminations to formats
o Realign arguments to open parenthesis
o Remove commented out uses of PDEBUG

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/usb/gspca/autogain_functions.c     |  16 +--
 drivers/media/usb/gspca/benq.c                   |   2 +-
 drivers/media/usb/gspca/conex.c                  |   7 +-
 drivers/media/usb/gspca/cpia1.c                  |  50 ++++-----
 drivers/media/usb/gspca/dtcs033.c                |  16 +--
 drivers/media/usb/gspca/etoms.c                  |  34 +++---
 drivers/media/usb/gspca/finepix.c                |   4 +-
 drivers/media/usb/gspca/gl860/gl860.c            |  35 ++++---
 drivers/media/usb/gspca/gspca.c                  | 127 ++++++++++++-----------
 drivers/media/usb/gspca/gspca.h                  |   5 +-
 drivers/media/usb/gspca/jeilinj.c                |  17 +--
 drivers/media/usb/gspca/jl2005bcd.c              |  45 ++++----
 drivers/media/usb/gspca/kinect.c                 |  11 +-
 drivers/media/usb/gspca/konica.c                 |   2 +-
 drivers/media/usb/gspca/m5602/m5602_core.c       |  32 +++---
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c    |  21 ++--
 drivers/media/usb/gspca/m5602/m5602_ov7660.c     |  11 +-
 drivers/media/usb/gspca/m5602/m5602_ov9650.c     |  26 ++---
 drivers/media/usb/gspca/m5602/m5602_po1030.c     |  27 ++---
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.c     |  16 +--
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c     |   2 +-
 drivers/media/usb/gspca/mars.c                   |   4 +-
 drivers/media/usb/gspca/mr97310a.c               |  23 ++--
 drivers/media/usb/gspca/nw80x.c                  |  24 +++--
 drivers/media/usb/gspca/ov519.c                  |  90 ++++++++--------
 drivers/media/usb/gspca/ov534.c                  |  21 ++--
 drivers/media/usb/gspca/ov534_9.c                |  23 ++--
 drivers/media/usb/gspca/pac207.c                 |  16 +--
 drivers/media/usb/gspca/pac_common.h             |   7 +-
 drivers/media/usb/gspca/sn9c2028.c               |  30 +++---
 drivers/media/usb/gspca/sn9c2028.h               |   7 +-
 drivers/media/usb/gspca/sn9c20x.c                |   2 +-
 drivers/media/usb/gspca/sonixj.c                 |  54 +++++-----
 drivers/media/usb/gspca/spca1528.c               |  13 +--
 drivers/media/usb/gspca/spca500.c                |  30 +++---
 drivers/media/usb/gspca/spca501.c                |   6 +-
 drivers/media/usb/gspca/spca505.c                |   4 +-
 drivers/media/usb/gspca/spca506.c                |  16 +--
 drivers/media/usb/gspca/spca508.c                |  17 +--
 drivers/media/usb/gspca/spca561.c                |  20 ++--
 drivers/media/usb/gspca/sq905.c                  |  14 +--
 drivers/media/usb/gspca/sq905c.c                 |  31 +++---
 drivers/media/usb/gspca/sq930x.c                 |  27 ++---
 drivers/media/usb/gspca/stk014.c                 |   6 +-
 drivers/media/usb/gspca/stk1135.c                |  15 +--
 drivers/media/usb/gspca/stv0680.c                |  20 ++--
 drivers/media/usb/gspca/stv06xx/stv06xx.c        |  64 ++++++------
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c   |  10 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |  23 ++--
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c |   2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c |  16 +--
 drivers/media/usb/gspca/sunplus.c                |  34 +++---
 drivers/media/usb/gspca/t613.c                   |  24 ++---
 drivers/media/usb/gspca/topro.c                  |   6 +-
 drivers/media/usb/gspca/touptek.c                |  51 ++++-----
 drivers/media/usb/gspca/vc032x.c                 |  51 ++++-----
 drivers/media/usb/gspca/w996Xcf.c                |   7 +-
 drivers/media/usb/gspca/xirlink_cit.c            |  32 +++---
 drivers/media/usb/gspca/zc3xx.c                  |  83 ++++++++-------
 59 files changed, 742 insertions(+), 687 deletions(-)

diff --git a/drivers/media/usb/gspca/autogain_functions.c b/drivers/media/usb/gspca/autogain_functions.c
index 427db745e027..f721e83596be 100644
--- a/drivers/media/usb/gspca/autogain_functions.c
+++ b/drivers/media/usb/gspca/autogain_functions.c
@@ -41,8 +41,8 @@ int gspca_expo_autogain(
 	   desired lumination fast (with the risc of a slight overshoot) */
 	steps = abs(desired_avg_lum - avg_lum) / deadzone;
 
-	PDEBUG(D_FRAM, "autogain: lum: %d, desired: %d, steps: %d",
-		avg_lum, desired_avg_lum, steps);
+	gspca_dbg(gspca_dev, D_FRAM, "autogain: lum: %d, desired: %d, steps: %d\n",
+		  avg_lum, desired_avg_lum, steps);
 
 	for (i = 0; i < steps; i++) {
 		if (avg_lum > desired_avg_lum) {
@@ -84,8 +84,8 @@ int gspca_expo_autogain(
 	}
 
 	if (retval)
-		PDEBUG(D_FRAM, "autogain: changed gain: %d, expo: %d",
-			gain, exposure);
+		gspca_dbg(gspca_dev, D_FRAM, "autogain: changed gain: %d, expo: %d\n",
+			  gain, exposure);
 	return retval;
 }
 EXPORT_SYMBOL(gspca_expo_autogain);
@@ -126,8 +126,8 @@ int gspca_coarse_grained_expo_autogain(
 	   desired lumination fast (with the risc of a slight overshoot) */
 	steps = (desired_avg_lum - avg_lum) / deadzone;
 
-	PDEBUG(D_FRAM, "autogain: lum: %d, desired: %d, steps: %d",
-		avg_lum, desired_avg_lum, steps);
+	gspca_dbg(gspca_dev, D_FRAM, "autogain: lum: %d, desired: %d, steps: %d\n",
+		  avg_lum, desired_avg_lum, steps);
 
 	if ((gain + steps) > gain_high &&
 	    exposure < gspca_dev->exposure->maximum) {
@@ -167,8 +167,8 @@ int gspca_coarse_grained_expo_autogain(
 	}
 
 	if (retval)
-		PDEBUG(D_FRAM, "autogain: changed gain: %d, expo: %d",
-			gain, exposure);
+		gspca_dbg(gspca_dev, D_FRAM, "autogain: changed gain: %d, expo: %d\n",
+			  gain, exposure);
 	return retval;
 }
 EXPORT_SYMBOL(gspca_coarse_grained_expo_autogain);
diff --git a/drivers/media/usb/gspca/benq.c b/drivers/media/usb/gspca/benq.c
index b5955bf0d0fc..8a8db5eb6d5f 100644
--- a/drivers/media/usb/gspca/benq.c
+++ b/drivers/media/usb/gspca/benq.c
@@ -152,7 +152,7 @@ static void sd_isoc_irq(struct urb *urb)
 	u8 *data;
 	int i, st;
 
-	PDEBUG(D_PACK, "sd isoc irq");
+	gspca_dbg(gspca_dev, D_PACK, "sd isoc irq\n");
 	if (!gspca_dev->streaming)
 		return;
 	if (urb->status != 0) {
diff --git a/drivers/media/usb/gspca/conex.c b/drivers/media/usb/gspca/conex.c
index 0223b33156dd..6df4e204e291 100644
--- a/drivers/media/usb/gspca/conex.c
+++ b/drivers/media/usb/gspca/conex.c
@@ -81,8 +81,8 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			0,
 			index, gspca_dev->usb_buf, len,
 			500);
-	PDEBUG(D_USBI, "reg read [%02x] -> %02x ..",
-			index, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "reg read [%02x] -> %02x ..\n",
+		  index, gspca_dev->usb_buf[0]);
 }
 
 /* the bytes to write are in gspca_dev->usb_buf */
@@ -112,7 +112,8 @@ static void reg_w(struct gspca_dev *gspca_dev,
 		gspca_err(gspca_dev, "reg_w: buffer overflow\n");
 		return;
 	}
-	PDEBUG(D_USBO, "reg write [%02x] = %02x..", index, *buffer);
+	gspca_dbg(gspca_dev, D_USBO, "reg write [%02x] = %02x..\n",
+		  index, *buffer);
 
 	memcpy(gspca_dev->usb_buf, buffer, len);
 	usb_control_msg(dev,
diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index 99b456d64729..8d41cd46a79d 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -701,11 +701,11 @@ static void reset_camera_params(struct gspca_dev *gspca_dev)
 
 static void printstatus(struct gspca_dev *gspca_dev, struct cam_params *params)
 {
-	PDEBUG(D_PROBE, "status: %02x %02x %02x %02x %02x %02x %02x %02x",
-	       params->status.systemState, params->status.grabState,
-	       params->status.streamState, params->status.fatalError,
-	       params->status.cmdError, params->status.debugFlags,
-	       params->status.vpStatus, params->status.errorCode);
+	gspca_dbg(gspca_dev, D_PROBE, "status: %02x %02x %02x %02x %02x %02x %02x %02x\n",
+		  params->status.systemState, params->status.grabState,
+		  params->status.streamState, params->status.fatalError,
+		  params->status.cmdError, params->status.debugFlags,
+		  params->status.vpStatus, params->status.errorCode);
 }
 
 static int goto_low_power(struct gspca_dev *gspca_dev)
@@ -730,7 +730,7 @@ static int goto_low_power(struct gspca_dev *gspca_dev)
 		return -EIO;
 	}
 
-	PDEBUG(D_CONF, "camera now in LOW power state");
+	gspca_dbg(gspca_dev, D_CONF, "camera now in LOW power state\n");
 	return 0;
 }
 
@@ -759,7 +759,7 @@ static int goto_high_power(struct gspca_dev *gspca_dev)
 		return -EIO;
 	}
 
-	PDEBUG(D_CONF, "camera now in HIGH power state");
+	gspca_dbg(gspca_dev, D_CONF, "camera now in HIGH power state\n");
 	return 0;
 }
 
@@ -1302,7 +1302,7 @@ static void monitor_exposure(struct gspca_dev *gspca_dev)
 			sd->params.exposure.coarseExpHi = new_exposure >> 8;
 			setexp = 1;
 			sd->exposure_status = EXPOSURE_NORMAL;
-			PDEBUG(D_CONF, "Automatically decreasing sensor_fps");
+			gspca_dbg(gspca_dev, D_CONF, "Automatically decreasing sensor_fps\n");
 
 		} else if ((sd->exposure_status == EXPOSURE_VERY_LIGHT ||
 			    sd->exposure_status == EXPOSURE_LIGHT) &&
@@ -1331,7 +1331,7 @@ static void monitor_exposure(struct gspca_dev *gspca_dev)
 			sd->params.exposure.coarseExpHi = new_exposure >> 8;
 			setexp = 1;
 			sd->exposure_status = EXPOSURE_NORMAL;
-			PDEBUG(D_CONF, "Automatically increasing sensor_fps");
+			gspca_dbg(gspca_dev, D_CONF, "Automatically increasing sensor_fps\n");
 		}
 	} else {
 		/* Flicker control off */
@@ -1349,7 +1349,7 @@ static void monitor_exposure(struct gspca_dev *gspca_dev)
 				setexp = 1;
 			}
 			sd->exposure_status = EXPOSURE_NORMAL;
-			PDEBUG(D_CONF, "Automatically decreasing sensor_fps");
+			gspca_dbg(gspca_dev, D_CONF, "Automatically decreasing sensor_fps\n");
 
 		} else if ((sd->exposure_status == EXPOSURE_VERY_LIGHT ||
 			    sd->exposure_status == EXPOSURE_LIGHT) &&
@@ -1366,7 +1366,7 @@ static void monitor_exposure(struct gspca_dev *gspca_dev)
 				setexp = 1;
 			}
 			sd->exposure_status = EXPOSURE_NORMAL;
-			PDEBUG(D_CONF, "Automatically increasing sensor_fps");
+			gspca_dbg(gspca_dev, D_CONF, "Automatically increasing sensor_fps\n");
 		}
 	}
 
@@ -1434,8 +1434,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	sd->mainsFreq = FREQ_DEF == V4L2_CID_POWER_LINE_FREQUENCY_60HZ;
 	reset_camera_params(gspca_dev);
 
-	PDEBUG(D_PROBE, "cpia CPiA camera detected (vid/pid 0x%04X:0x%04X)",
-	       id->idVendor, id->idProduct);
+	gspca_dbg(gspca_dev, D_PROBE, "cpia CPiA camera detected (vid/pid 0x%04X:0x%04X)\n",
+		  id->idVendor, id->idProduct);
 
 	cam = &gspca_dev->cam;
 	cam->cam_mode = mode;
@@ -1669,18 +1669,18 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	sd_stopN(gspca_dev);
 
-	PDEBUG(D_PROBE, "CPIA Version:             %d.%02d (%d.%d)",
-			sd->params.version.firmwareVersion,
-			sd->params.version.firmwareRevision,
-			sd->params.version.vcVersion,
-			sd->params.version.vcRevision);
-	PDEBUG(D_PROBE, "CPIA PnP-ID:              %04x:%04x:%04x",
-			sd->params.pnpID.vendor, sd->params.pnpID.product,
-			sd->params.pnpID.deviceRevision);
-	PDEBUG(D_PROBE, "VP-Version:               %d.%d %04x",
-			sd->params.vpVersion.vpVersion,
-			sd->params.vpVersion.vpRevision,
-			sd->params.vpVersion.cameraHeadID);
+	gspca_dbg(gspca_dev, D_PROBE, "CPIA Version:             %d.%02d (%d.%d)\n",
+		  sd->params.version.firmwareVersion,
+		  sd->params.version.firmwareRevision,
+		  sd->params.version.vcVersion,
+		  sd->params.version.vcRevision);
+	gspca_dbg(gspca_dev, D_PROBE, "CPIA PnP-ID:              %04x:%04x:%04x",
+		  sd->params.pnpID.vendor, sd->params.pnpID.product,
+		  sd->params.pnpID.deviceRevision);
+	gspca_dbg(gspca_dev, D_PROBE, "VP-Version:               %d.%d %04x",
+		  sd->params.vpVersion.vpVersion,
+		  sd->params.vpVersion.vpRevision,
+		  sd->params.vpVersion.cameraHeadID);
 
 	return 0;
 }
diff --git a/drivers/media/usb/gspca/dtcs033.c b/drivers/media/usb/gspca/dtcs033.c
index b4d42940d5de..cdf27cf0112a 100644
--- a/drivers/media/usb/gspca/dtcs033.c
+++ b/drivers/media/usb/gspca/dtcs033.c
@@ -75,14 +75,14 @@ static int reg_reqs(struct gspca_dev *gspca_dev,
 				  i, n_reqs);
 		} else if (preq->bRequestType & USB_DIR_IN) {
 
-			PDEBUG(D_STREAM,
-			"USB IN (%d) returned[%d] %02X %02X %02X %s",
-				i,
-				preq->wLength,
-				gspca_dev->usb_buf[0],
-				gspca_dev->usb_buf[1],
-				gspca_dev->usb_buf[2],
-				preq->wLength > 3 ? "...\n" : "\n");
+			gspca_dbg(gspca_dev, D_STREAM,
+				  "USB IN (%d) returned[%d] %02X %02X %02X %s\n",
+				  i,
+				  preq->wLength,
+				  gspca_dev->usb_buf[0],
+				  gspca_dev->usb_buf[1],
+				  gspca_dev->usb_buf[2],
+				  preq->wLength > 3 ? "...\n" : "\n");
 		}
 
 		i++;
diff --git a/drivers/media/usb/gspca/etoms.c b/drivers/media/usb/gspca/etoms.c
index a88ae69d6c1e..48b28897051f 100644
--- a/drivers/media/usb/gspca/etoms.c
+++ b/drivers/media/usb/gspca/etoms.c
@@ -170,8 +170,8 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			0,
 			index, gspca_dev->usb_buf, len, 500);
-	PDEBUG(D_USBI, "reg read [%02x] -> %02x ..",
-			index, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "reg read [%02x] -> %02x ..\n",
+		  index, gspca_dev->usb_buf[0]);
 }
 
 static void reg_w_val(struct gspca_dev *gspca_dev,
@@ -200,7 +200,8 @@ static void reg_w(struct gspca_dev *gspca_dev,
 		pr_err("reg_w: buffer overflow\n");
 		return;
 	}
-	PDEBUG(D_USBO, "reg write [%02x] = %02x..", index, *buffer);
+	gspca_dbg(gspca_dev, D_USBO, "reg write [%02x] = %02x..\n",
+		  index, *buffer);
 
 	memcpy(gspca_dev->usb_buf, buffer, len);
 	usb_control_msg(dev,
@@ -277,7 +278,7 @@ static void Et_init2(struct gspca_dev *gspca_dev)
 	__u8 value;
 	static const __u8 FormLine[] = { 0x84, 0x03, 0x14, 0xf4, 0x01, 0x05 };
 
-	PDEBUG(D_STREAM, "Open Init2 ET");
+	gspca_dbg(gspca_dev, D_STREAM, "Open Init2 ET\n");
 	reg_w_val(gspca_dev, ET_GPIO_DIR_CTRL, 0x2f);
 	reg_w_val(gspca_dev, ET_GPIO_OUT, 0x10);
 	reg_r(gspca_dev, ET_GPIO_IN, 1);
@@ -416,8 +417,6 @@ static void setcolors(struct gspca_dev *gspca_dev, s32 val)
 		i2c_w(gspca_dev, PAS106_REG13, &i2cflags, 1, 3);
 		i2c_w(gspca_dev, PAS106_REG9, I2cc, sizeof I2cc, 1);
 	}
-/*	PDEBUG(D_CONF , "Etoms red %d blue %d green %d",
-		I2cc[3], I2cc[0], green); */
 }
 
 static s32 getcolors(struct gspca_dev *gspca_dev)
@@ -451,7 +450,7 @@ static void Et_init1(struct gspca_dev *gspca_dev)
 /*	__u8 I2c0 [] = {0x0a, 0x12, 0x05, 0xfe, 0xfe, 0xc0, 0x01, 0x00};
 						 * 1/60000 hmm ?? */
 
-	PDEBUG(D_STREAM, "Open Init1 ET");
+	gspca_dbg(gspca_dev, D_STREAM, "Open Init1 ET\n\n");
 	reg_w_val(gspca_dev, ET_GPIO_DIR_CTRL, 7);
 	reg_r(gspca_dev, ET_GPIO_IN, 1);
 	reg_w_val(gspca_dev, ET_RESET_ALL, 1);
@@ -463,9 +462,9 @@ static void Et_init1(struct gspca_dev *gspca_dev)
 		value = ET_COMP_VAL1;
 	else
 		value = ET_COMP_VAL0;
-	PDEBUG(D_STREAM, "Open mode %d Compression %d",
-	       gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv,
-	       value);
+	gspca_dbg(gspca_dev, D_STREAM, "Open mode %d Compression %d\n",
+		  gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv,
+		  value);
 	reg_w_val(gspca_dev, ET_COMP, value);
 	reg_w_val(gspca_dev, ET_MAXQt, 0x1d);
 	reg_w_val(gspca_dev, ET_MINQt, 0x02);
@@ -604,7 +603,8 @@ static __u8 Et_getgainG(struct gspca_dev *gspca_dev)
 
 	if (sd->sensor == SENSOR_PAS106) {
 		i2c_r(gspca_dev, PAS106_REG0e);
-		PDEBUG(D_CONF, "Etoms gain G %d", gspca_dev->usb_buf[0]);
+		gspca_dbg(gspca_dev, D_CONF, "Etoms gain G %d\n",
+			  gspca_dev->usb_buf[0]);
 		return gspca_dev->usb_buf[0];
 	}
 	return 0x1f;
@@ -652,11 +652,11 @@ static void do_autogain(struct gspca_dev *gspca_dev)
 	b = ((b << 7) >> 10);
 	g = ((g << 9) + (g << 7) + (g << 5)) >> 10;
 	luma = LIMIT(r + g + b);
-	PDEBUG(D_FRAM, "Etoms luma G %d", luma);
+	gspca_dbg(gspca_dev, D_FRAM, "Etoms luma G %d\n", luma);
 	if (luma < luma_mean - luma_delta || luma > luma_mean + luma_delta) {
 		Gbright += (luma_mean - luma) >> spring;
 		Gbright = BLIMIT(Gbright);
-		PDEBUG(D_FRAM, "Etoms Gbright %d", Gbright);
+		gspca_dbg(gspca_dev, D_FRAM, "Etoms Gbright %d\n", Gbright);
 		Et_setgainG(gspca_dev, (__u8) Gbright);
 	}
 }
@@ -673,10 +673,10 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	seqframe = data[0] & 0x3f;
 	len = (int) (((data[0] & 0xc0) << 2) | data[1]);
 	if (seqframe == 0x3f) {
-		PDEBUG(D_FRAM,
-		       "header packet found datalength %d !!", len);
-		PDEBUG(D_FRAM, "G %d R %d G %d B %d",
-		       data[2], data[3], data[4], data[5]);
+		gspca_dbg(gspca_dev, D_FRAM,
+			  "header packet found datalength %d !!\n", len);
+		gspca_dbg(gspca_dev, D_FRAM, "G %d R %d G %d B %d",
+			  data[2], data[3], data[4], data[5]);
 		data += 30;
 		/* don't change datalength as the chips provided it */
 		gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
diff --git a/drivers/media/usb/gspca/finepix.c b/drivers/media/usb/gspca/finepix.c
index 7bb469aa61a7..1ef1239eb3db 100644
--- a/drivers/media/usb/gspca/finepix.c
+++ b/drivers/media/usb/gspca/finepix.c
@@ -89,7 +89,7 @@ static void dostream(struct work_struct *work)
 	int ret = 0;
 	int len;
 
-	PDEBUG(D_STREAM, "dostream started");
+	gspca_dbg(gspca_dev, D_STREAM, "dostream started\n");
 
 	/* loop reading a frame */
 again:
@@ -160,7 +160,7 @@ static void dostream(struct work_struct *work)
 	}
 
 out:
-	PDEBUG(D_STREAM, "dostream stopped");
+	gspca_dbg(gspca_dev, D_STREAM, "dostream stopped\n");
 }
 
 /* this function is called at probe time */
diff --git a/drivers/media/usb/gspca/gl860/gl860.c b/drivers/media/usb/gspca/gl860/gl860.c
index add298cc9ab2..262200af76a3 100644
--- a/drivers/media/usb/gspca/gl860/gl860.c
+++ b/drivers/media/usb/gspca/gl860/gl860.c
@@ -661,7 +661,7 @@ static int gl860_guess_sensor(struct gspca_dev *gspca_dev,
 		ctrl_out(gspca_dev, 0x40, 1, 0x006a, 0x000d, 0, NULL);
 		msleep(56);
 
-		PDEBUG(D_PROBE, "probing for sensor MI2020 or OVXXXX");
+		gspca_dbg(gspca_dev, D_PROBE, "probing for sensor MI2020 or OVXXXX\n");
 		nOV = 0;
 		for (ntry = 0; ntry < 4; ntry++) {
 			ctrl_out(gspca_dev, 0x40, 1, 0x0040, 0x0000, 0, NULL);
@@ -671,14 +671,14 @@ static int gl860_guess_sensor(struct gspca_dev *gspca_dev,
 			ctrl_out(gspca_dev, 0x40, 1, 0x7a00, 0x8030, 0, NULL);
 			msleep(10);
 			ctrl_in(gspca_dev, 0xc0, 2, 0x7a00, 0x8030, 1, &probe);
-			PDEBUG(D_PROBE, "probe=0x%02x", probe);
+			gspca_dbg(gspca_dev, D_PROBE, "probe=0x%02x\n", probe);
 			if (probe == 0xff)
 				nOV++;
 		}
 
 		if (nOV) {
-			PDEBUG(D_PROBE, "0xff -> OVXXXX");
-			PDEBUG(D_PROBE, "probing for sensor OV2640 or OV9655");
+			gspca_dbg(gspca_dev, D_PROBE, "0xff -> OVXXXX\n");
+			gspca_dbg(gspca_dev, D_PROBE, "probing for sensor OV2640 or OV9655");
 
 			nb26 = nb96 = 0;
 			for (ntry = 0; ntry < 4; ntry++) {
@@ -694,22 +694,23 @@ static int gl860_guess_sensor(struct gspca_dev *gspca_dev,
 						1, &probe);
 
 				if (probe == 0x26 || probe == 0x40) {
-					PDEBUG(D_PROBE,
-						"probe=0x%02x -> OV2640",
-						probe);
+					gspca_dbg(gspca_dev, D_PROBE,
+						  "probe=0x%02x -> OV2640\n",
+						  probe);
 					sd->sensor = ID_OV2640;
 					nb26 += 4;
 					break;
 				}
 				if (probe == 0x96 || probe == 0x55) {
-					PDEBUG(D_PROBE,
-						"probe=0x%02x -> OV9655",
-						probe);
+					gspca_dbg(gspca_dev, D_PROBE,
+						  "probe=0x%02x -> OV9655\n",
+						  probe);
 					sd->sensor = ID_OV9655;
 					nb96 += 4;
 					break;
 				}
-				PDEBUG(D_PROBE, "probe=0x%02x", probe);
+				gspca_dbg(gspca_dev, D_PROBE, "probe=0x%02x\n",
+					  probe);
 				if (probe == 0x00)
 					nb26++;
 				if (probe == 0xff)
@@ -719,21 +720,21 @@ static int gl860_guess_sensor(struct gspca_dev *gspca_dev,
 			if (nb26 < 4 && nb96 < 4)
 				return -1;
 		} else {
-			PDEBUG(D_PROBE, "Not any 0xff -> MI2020");
+			gspca_dbg(gspca_dev, D_PROBE, "Not any 0xff -> MI2020\n");
 			sd->sensor = ID_MI2020;
 		}
 	}
 
 	if (_MI1320_) {
-		PDEBUG(D_PROBE, "05e3:f191 sensor MI1320 (1.3M)");
+		gspca_dbg(gspca_dev, D_PROBE, "05e3:f191 sensor MI1320 (1.3M)\n");
 	} else if (_MI2020_) {
-		PDEBUG(D_PROBE, "05e3:0503 sensor MI2020 (2.0M)");
+		gspca_dbg(gspca_dev, D_PROBE, "05e3:0503 sensor MI2020 (2.0M)\n");
 	} else if (_OV9655_) {
-		PDEBUG(D_PROBE, "05e3:0503 sensor OV9655 (1.3M)");
+		gspca_dbg(gspca_dev, D_PROBE, "05e3:0503 sensor OV9655 (1.3M)\n");
 	} else if (_OV2640_) {
-		PDEBUG(D_PROBE, "05e3:0503 sensor OV2640 (2.0M)");
+		gspca_dbg(gspca_dev, D_PROBE, "05e3:0503 sensor OV2640 (2.0M)\n");
 	} else {
-		PDEBUG(D_PROBE, "***** Unknown sensor *****");
+		gspca_dbg(gspca_dev, D_PROBE, "***** Unknown sensor *****\n");
 		return -1;
 	}
 
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index ebbe301dc80d..73748716ce4e 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -63,18 +63,18 @@ static void PDEBUG_MODE(struct gspca_dev *gspca_dev, int debug, char *txt,
 			__u32 pixfmt, int w, int h)
 {
 	if ((pixfmt >> 24) >= '0' && (pixfmt >> 24) <= 'z') {
-		PDEBUG(debug, "%s %c%c%c%c %dx%d",
-			txt,
-			pixfmt & 0xff,
-			(pixfmt >> 8) & 0xff,
-			(pixfmt >> 16) & 0xff,
-			pixfmt >> 24,
-			w, h);
+		gspca_dbg(gspca_dev, debug, "%s %c%c%c%c %dx%d\n",
+			  txt,
+			  pixfmt & 0xff,
+			  (pixfmt >> 8) & 0xff,
+			  (pixfmt >> 16) & 0xff,
+			  pixfmt >> 24,
+			  w, h);
 	} else {
-		PDEBUG(debug, "%s 0x%08x %dx%d",
-			txt,
-			pixfmt,
-			w, h);
+		gspca_dbg(gspca_dev, debug, "%s 0x%08x %dx%d\n",
+			  txt,
+			  pixfmt,
+			  w, h);
 	}
 }
 
@@ -198,8 +198,8 @@ static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
 
 	buffer_len = le16_to_cpu(ep->wMaxPacketSize);
 	interval = ep->bInterval;
-	PDEBUG(D_CONF, "found int in endpoint: 0x%x, buffer_len=%u, interval=%u",
-		ep->bEndpointAddress, buffer_len, interval);
+	gspca_dbg(gspca_dev, D_CONF, "found int in endpoint: 0x%x, buffer_len=%u, interval=%u\n",
+		  ep->bEndpointAddress, buffer_len, interval);
 
 	dev = gspca_dev->dev;
 
@@ -332,8 +332,8 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 		}
 
 		/* let the packet be analyzed by the subdriver */
-		PDEBUG(D_PACK, "packet [%d] o:%d l:%d",
-			i, urb->iso_frame_desc[i].offset, len);
+		gspca_dbg(gspca_dev, D_PACK, "packet [%d] o:%d l:%d\n",
+			  i, urb->iso_frame_desc[i].offset, len);
 		data = (u8 *) urb->transfer_buffer
 					+ urb->iso_frame_desc[i].offset;
 		pkt_scan(gspca_dev, data, len);
@@ -355,7 +355,7 @@ static void isoc_irq(struct urb *urb)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
 
-	PDEBUG(D_PACK, "isoc irq");
+	gspca_dbg(gspca_dev, D_PACK, "isoc irq\n");
 	if (!gspca_dev->streaming)
 		return;
 	fill_frame(gspca_dev, urb);
@@ -369,7 +369,7 @@ static void bulk_irq(struct urb *urb)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
 	int st;
 
-	PDEBUG(D_PACK, "bulk irq");
+	gspca_dbg(gspca_dev, D_PACK, "bulk irq\n");
 	if (!gspca_dev->streaming)
 		return;
 	switch (urb->status) {
@@ -387,7 +387,7 @@ static void bulk_irq(struct urb *urb)
 		goto resubmit;
 	}
 
-	PDEBUG(D_PACK, "packet l:%d", urb->actual_length);
+	gspca_dbg(gspca_dev, D_PACK, "packet l:%d\n", urb->actual_length);
 	gspca_dev->sd_desc->pkt_scan(gspca_dev,
 				urb->transfer_buffer,
 				urb->actual_length);
@@ -420,7 +420,7 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 	struct gspca_frame *frame;
 	int i, j;
 
-	PDEBUG(D_PACK, "add t:%d l:%d",	packet_type, len);
+	gspca_dbg(gspca_dev, D_PACK, "add t:%d l:%d\n",	packet_type, len);
 
 	if (packet_type == FIRST_PACKET) {
 		i = atomic_read(&gspca_dev->fr_i);
@@ -486,8 +486,8 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 		i = (i + 1) % GSPCA_MAX_FRAMES;
 		atomic_set(&gspca_dev->fr_i, i);
 		wake_up_interruptible(&gspca_dev->wq);	/* event = new frame */
-		PDEBUG(D_FRAM, "frame complete len:%d",
-			frame->v4l2_buf.bytesused);
+		gspca_dbg(gspca_dev, D_FRAM, "frame complete len:%d\n",
+			  frame->v4l2_buf.bytesused);
 		gspca_dev->image = NULL;
 		gspca_dev->image_len = 0;
 	}
@@ -502,7 +502,7 @@ static int frame_alloc(struct gspca_dev *gspca_dev, struct file *file,
 	int i;
 
 	frsz = gspca_dev->pixfmt.sizeimage;
-	PDEBUG(D_STREAM, "frame alloc frsz: %d", frsz);
+	gspca_dbg(gspca_dev, D_STREAM, "frame alloc frsz: %d\n", frsz);
 	frsz = PAGE_ALIGN(frsz);
 	if (count >= GSPCA_MAX_FRAMES)
 		count = GSPCA_MAX_FRAMES - 1;
@@ -537,7 +537,7 @@ static void frame_free(struct gspca_dev *gspca_dev)
 {
 	int i;
 
-	PDEBUG(D_STREAM, "frame free");
+	gspca_dbg(gspca_dev, D_STREAM, "frame free\n");
 	if (gspca_dev->frbuf != NULL) {
 		vfree(gspca_dev->frbuf);
 		gspca_dev->frbuf = NULL;
@@ -555,7 +555,7 @@ static void destroy_urbs(struct gspca_dev *gspca_dev)
 	struct urb *urb;
 	unsigned int i;
 
-	PDEBUG(D_STREAM, "kill transfer");
+	gspca_dbg(gspca_dev, D_STREAM, "kill transfer\n");
 	for (i = 0; i < MAX_NURBS; i++) {
 		urb = gspca_dev->urb[i];
 		if (urb == NULL)
@@ -596,7 +596,7 @@ static void gspca_stream_off(struct gspca_dev *gspca_dev)
 	gspca_input_create_urb(gspca_dev);
 	if (gspca_dev->sd_desc->stop0)
 		gspca_dev->sd_desc->stop0(gspca_dev);
-	PDEBUG(D_STREAM, "stream off OK");
+	gspca_dbg(gspca_dev, D_STREAM, "stream off OK\n");
 }
 
 /*
@@ -655,7 +655,7 @@ static u32 which_bandwidth(struct gspca_dev *gspca_dev)
 			bandwidth *= 30;		/* 30 fps */
 	}
 
-	PDEBUG(D_STREAM, "min bandwidth: %d", bandwidth);
+	gspca_dbg(gspca_dev, D_STREAM, "min bandwidth: %d\n", bandwidth);
 	return bandwidth;
 }
 
@@ -715,8 +715,8 @@ static int build_isoc_ep_tb(struct gspca_dev *gspca_dev,
 		}
 		if (!found)
 			break;
-		PDEBUG(D_STREAM, "alt %d bandwidth %d",
-				ep_tb->alt, ep_tb->bandwidth);
+		gspca_dbg(gspca_dev, D_STREAM, "alt %d bandwidth %d\n",
+			  ep_tb->alt, ep_tb->bandwidth);
 		last_bw = ep_tb->bandwidth;
 		i++;
 		ep_tb++;
@@ -734,7 +734,7 @@ static int build_isoc_ep_tb(struct gspca_dev *gspca_dev,
 			gspca_dev->dev->speed == USB_SPEED_FULL &&
 			last_bw >= 1000000 &&
 			i > 1) {
-		PDEBUG(D_STREAM, "dev has usb audio, skipping highest alt");
+		gspca_dbg(gspca_dev, D_STREAM, "dev has usb audio, skipping highest alt\n");
 		i--;
 		ep_tb--;
 	}
@@ -774,16 +774,16 @@ static int create_urbs(struct gspca_dev *gspca_dev,
 		if (npkt == 0)
 			npkt = 32;		/* default value */
 		bsize = psize * npkt;
-		PDEBUG(D_STREAM,
-			"isoc %d pkts size %d = bsize:%d",
-			npkt, psize, bsize);
+		gspca_dbg(gspca_dev, D_STREAM,
+			  "isoc %d pkts size %d = bsize:%d\n",
+			  npkt, psize, bsize);
 		nurbs = DEF_NURBS;
 	} else {				/* bulk */
 		npkt = 0;
 		bsize = gspca_dev->cam.bulk_size;
 		if (bsize == 0)
 			bsize = psize;
-		PDEBUG(D_STREAM, "bulk bsize:%d", bsize);
+		gspca_dbg(gspca_dev, D_STREAM, "bulk bsize:%d\n", bsize);
 		if (gspca_dev->cam.bulk_nurbs != 0)
 			nurbs = gspca_dev->cam.bulk_nurbs;
 		else
@@ -902,7 +902,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 			}
 		}
 		if (!gspca_dev->cam.no_urb_create) {
-			PDEBUG(D_STREAM, "init transfer alt %d", alt);
+			gspca_dbg(gspca_dev, D_STREAM, "init transfer alt %d\n",
+				  alt);
 			ret = create_urbs(gspca_dev,
 				alt_xfer(&intf->altsetting[alt], xfer,
 					 gspca_dev->xfer_ep));
@@ -1286,7 +1287,7 @@ static int dev_open(struct file *file)
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
-	PDEBUG(D_STREAM, "[%s] open", current->comm);
+	gspca_dbg(gspca_dev, D_STREAM, "[%s] open\n", current->comm);
 
 	/* protect the subdriver against rmmod */
 	if (!try_module_get(gspca_dev->module))
@@ -1302,7 +1303,7 @@ static int dev_close(struct file *file)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
-	PDEBUG(D_STREAM, "[%s] close", current->comm);
+	gspca_dbg(gspca_dev, D_STREAM, "[%s] close\n", current->comm);
 
 	/* Needed for gspca_stream_off, always lock before queue_lock! */
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
@@ -1323,7 +1324,7 @@ static int dev_close(struct file *file)
 	mutex_unlock(&gspca_dev->queue_lock);
 	mutex_unlock(&gspca_dev->usb_lock);
 
-	PDEBUG(D_STREAM, "close done");
+	gspca_dbg(gspca_dev, D_STREAM, "close done\n");
 
 	return v4l2_fh_release(file);
 }
@@ -1444,7 +1445,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 	}
 out:
 	mutex_unlock(&gspca_dev->queue_lock);
-	PDEBUG(D_STREAM, "reqbufs st:%d c:%d", ret, rb->count);
+	gspca_dbg(gspca_dev, D_STREAM, "reqbufs st:%d c:%d\n", ret, rb->count);
 	return ret;
 }
 
@@ -1602,7 +1603,8 @@ static int dev_mmap(struct file *file, struct vm_area_struct *vma)
 
 	start = vma->vm_start;
 	size = vma->vm_end - vma->vm_start;
-	PDEBUG(D_STREAM, "mmap start:%08x size:%d", (int) start, (int) size);
+	gspca_dbg(gspca_dev, D_STREAM, "mmap start:%08x size:%d\n",
+		  (int) start, (int)size);
 
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
 		return -ERESTARTSYS;
@@ -1614,7 +1616,7 @@ static int dev_mmap(struct file *file, struct vm_area_struct *vma)
 	frame = NULL;
 	for (i = 0; i < gspca_dev->nframes; ++i) {
 		if (gspca_dev->frame[i].v4l2_buf.memory != V4L2_MEMORY_MMAP) {
-			PDEBUG(D_STREAM, "mmap bad memory type");
+			gspca_dbg(gspca_dev, D_STREAM, "mmap bad memory type\n");
 			break;
 		}
 		if ((gspca_dev->frame[i].v4l2_buf.m.offset >> PAGE_SHIFT)
@@ -1624,12 +1626,12 @@ static int dev_mmap(struct file *file, struct vm_area_struct *vma)
 		}
 	}
 	if (frame == NULL) {
-		PDEBUG(D_STREAM, "mmap no frame buffer found");
+		gspca_dbg(gspca_dev, D_STREAM, "mmap no frame buffer found\n");
 		ret = -EINVAL;
 		goto out;
 	}
 	if (size != frame->v4l2_buf.length) {
-		PDEBUG(D_STREAM, "mmap bad size");
+		gspca_dbg(gspca_dev, D_STREAM, "mmap bad size\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1697,7 +1699,7 @@ static int vidioc_dqbuf(struct file *file, void *priv,
 	struct gspca_frame *frame;
 	int i, j, ret;
 
-	PDEBUG(D_FRAM, "dqbuf");
+	gspca_dbg(gspca_dev, D_FRAM, "dqbuf\n");
 
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
 		return -ERESTARTSYS;
@@ -1735,7 +1737,7 @@ static int vidioc_dqbuf(struct file *file, void *priv,
 
 	frame->v4l2_buf.flags &= ~V4L2_BUF_FLAG_DONE;
 	memcpy(v4l2_buf, &frame->v4l2_buf, sizeof *v4l2_buf);
-	PDEBUG(D_FRAM, "dqbuf %d", j);
+	gspca_dbg(gspca_dev, D_FRAM, "dqbuf %d\n", j);
 	ret = 0;
 
 	if (gspca_dev->memory == V4L2_MEMORY_USERPTR) {
@@ -1773,27 +1775,27 @@ static int vidioc_qbuf(struct file *file, void *priv,
 	struct gspca_frame *frame;
 	int i, index, ret;
 
-	PDEBUG(D_FRAM, "qbuf %d", v4l2_buf->index);
+	gspca_dbg(gspca_dev, D_FRAM, "qbuf %d\n", v4l2_buf->index);
 
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
 		return -ERESTARTSYS;
 
 	index = v4l2_buf->index;
 	if ((unsigned) index >= gspca_dev->nframes) {
-		PDEBUG(D_FRAM,
-			"qbuf idx %d >= %d", index, gspca_dev->nframes);
+		gspca_dbg(gspca_dev, D_FRAM,
+			  "qbuf idx %d >= %d\n", index, gspca_dev->nframes);
 		ret = -EINVAL;
 		goto out;
 	}
 	if (v4l2_buf->memory != gspca_dev->memory) {
-		PDEBUG(D_FRAM, "qbuf bad memory type");
+		gspca_dbg(gspca_dev, D_FRAM, "qbuf bad memory type\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	frame = &gspca_dev->frame[index];
 	if (frame->v4l2_buf.flags & BUF_ALL_FLAGS) {
-		PDEBUG(D_FRAM, "qbuf bad state");
+		gspca_dbg(gspca_dev, D_FRAM, "qbuf bad state\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1827,7 +1829,7 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 	struct v4l2_buffer v4l2_buf;
 	int i, ret;
 
-	PDEBUG(D_STREAM, "read alloc");
+	gspca_dbg(gspca_dev, D_STREAM, "read alloc\n");
 
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 		return -ERESTARTSYS;
@@ -1841,7 +1843,8 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 		rb.memory = GSPCA_MEMORY_READ;
 		ret = vidioc_reqbufs(file, gspca_dev, &rb);
 		if (ret != 0) {
-			PDEBUG(D_STREAM, "read reqbuf err %d", ret);
+			gspca_dbg(gspca_dev, D_STREAM, "read reqbuf err %d\n",
+				  ret);
 			goto out;
 		}
 		memset(&v4l2_buf, 0, sizeof v4l2_buf);
@@ -1851,7 +1854,8 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 			v4l2_buf.index = i;
 			ret = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
 			if (ret != 0) {
-				PDEBUG(D_STREAM, "read qbuf err: %d", ret);
+				gspca_dbg(gspca_dev, D_STREAM, "read qbuf err: %d\n",
+					  ret);
 				goto out;
 			}
 		}
@@ -1860,7 +1864,7 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 	/* start streaming */
 	ret = vidioc_streamon(file, gspca_dev, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (ret != 0)
-		PDEBUG(D_STREAM, "read streamon err %d", ret);
+		gspca_dbg(gspca_dev, D_STREAM, "read streamon err %d\n", ret);
 out:
 	mutex_unlock(&gspca_dev->usb_lock);
 	return ret;
@@ -1872,7 +1876,7 @@ static unsigned int dev_poll(struct file *file, poll_table *wait)
 	unsigned long req_events = poll_requested_events(wait);
 	int ret = 0;
 
-	PDEBUG(D_FRAM, "poll");
+	gspca_dbg(gspca_dev, D_FRAM, "poll\n");
 
 	if (req_events & POLLPRI)
 		ret |= v4l2_ctrl_poll(file, wait);
@@ -1914,7 +1918,7 @@ static ssize_t dev_read(struct file *file, char __user *data,
 	struct timeval timestamp;
 	int n, ret, ret2;
 
-	PDEBUG(D_FRAM, "read (%zd)", count);
+	gspca_dbg(gspca_dev, D_FRAM, "read (%zd)\n", count);
 	if (gspca_dev->memory == GSPCA_MEMORY_NO) { /* first time ? */
 		ret = read_alloc(gspca_dev, file);
 		if (ret != 0)
@@ -1931,7 +1935,8 @@ static ssize_t dev_read(struct file *file, char __user *data,
 		v4l2_buf.memory = GSPCA_MEMORY_READ;
 		ret = vidioc_dqbuf(file, gspca_dev, &v4l2_buf);
 		if (ret != 0) {
-			PDEBUG(D_STREAM, "read dqbuf err %d", ret);
+			gspca_dbg(gspca_dev, D_STREAM, "read dqbuf err %d\n",
+				  ret);
 			return ret;
 		}
 
@@ -1944,7 +1949,8 @@ static ssize_t dev_read(struct file *file, char __user *data,
 			break;
 		ret = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
 		if (ret != 0) {
-			PDEBUG(D_STREAM, "read qbuf err %d", ret);
+			gspca_dbg(gspca_dev, D_STREAM, "read qbuf err %d\n",
+				  ret);
 			return ret;
 		}
 	}
@@ -2133,7 +2139,8 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	}
 
 	usb_set_intfdata(intf, gspca_dev);
-	PDEBUG(D_PROBE, "%s created", video_device_node_name(&gspca_dev->vdev));
+	gspca_dbg(gspca_dev, D_PROBE, "%s created\n",
+		  video_device_node_name(&gspca_dev->vdev));
 
 	gspca_input_create_urb(gspca_dev);
 
@@ -2188,8 +2195,8 @@ void gspca_disconnect(struct usb_interface *intf)
 	struct input_dev *input_dev;
 #endif
 
-	PDEBUG(D_PROBE, "%s disconnect",
-		video_device_node_name(&gspca_dev->vdev));
+	gspca_dbg(gspca_dev, D_PROBE, "%s disconnect\n",
+		  video_device_node_name(&gspca_dev->vdev));
 
 	mutex_lock(&gspca_dev->usb_lock);
 
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index 635976706f35..684a75888cb5 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -25,8 +25,9 @@
 extern int gspca_debug;
 
 
-#define PDEBUG(level, fmt, ...) \
-	v4l2_dbg(level, gspca_debug, &gspca_dev->v4l2_dev, fmt, ##__VA_ARGS__)
+#define gspca_dbg(gspca_dev, level, fmt, ...)			\
+	v4l2_dbg(level, gspca_debug, &(gspca_dev)->v4l2_dev,	\
+		 fmt, ##__VA_ARGS__)
 
 #define gspca_err(gspca_dev, fmt, ...)				\
 	v4l2_err(&(gspca_dev)->v4l2_dev, fmt, ##__VA_ARGS__)
diff --git a/drivers/media/usb/gspca/jeilinj.c b/drivers/media/usb/gspca/jeilinj.c
index 7215c6879070..86d0a0a45631 100644
--- a/drivers/media/usb/gspca/jeilinj.c
+++ b/drivers/media/usb/gspca/jeilinj.c
@@ -273,17 +273,18 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	int packet_type;
 	u32 header_marker;
 
-	PDEBUG(D_STREAM, "Got %d bytes out of %d for Block 0",
-			len, JEILINJ_MAX_TRANSFER);
+	gspca_dbg(gspca_dev, D_STREAM, "Got %d bytes out of %d for Block 0\n",
+		  len, JEILINJ_MAX_TRANSFER);
 	if (len != JEILINJ_MAX_TRANSFER) {
-		PDEBUG(D_PACK, "bad length");
+		gspca_dbg(gspca_dev, D_PACK, "bad length\n");
 		goto discard;
 	}
 	/* check if it's start of frame */
 	header_marker = ((u32 *)data)[0];
 	if (header_marker == FRAME_START) {
 		sd->blocks_left = data[0x0a] - 1;
-		PDEBUG(D_STREAM, "blocks_left = 0x%x", sd->blocks_left);
+		gspca_dbg(gspca_dev, D_STREAM, "blocks_left = 0x%x\n",
+			  sd->blocks_left);
 		/* Start a new frame, and add the JPEG header, first thing */
 		gspca_frame_add(gspca_dev, FIRST_PACKET,
 				sd->jpeg_hdr, JPEG_HDR_SZ);
@@ -292,8 +293,8 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 				data + FRAME_HEADER_LEN,
 				JEILINJ_MAX_TRANSFER - FRAME_HEADER_LEN);
 	} else if (sd->blocks_left > 0) {
-		PDEBUG(D_STREAM, "%d blocks remaining for frame",
-				sd->blocks_left);
+		gspca_dbg(gspca_dev, D_STREAM, "%d blocks remaining for frame\n",
+			  sd->blocks_left);
 		sd->blocks_left -= 1;
 		if (sd->blocks_left == 0)
 			packet_type = LAST_PACKET;
@@ -378,8 +379,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 			gspca_dev->pixfmt.width,
 			0x21);          /* JPEG 422 */
 	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
-	PDEBUG(D_STREAM, "Start streaming at %dx%d",
-		gspca_dev->pixfmt.height, gspca_dev->pixfmt.width);
+	gspca_dbg(gspca_dev, D_STREAM, "Start streaming at %dx%d\n",
+		  gspca_dev->pixfmt.height, gspca_dev->pixfmt.width);
 	jlj_start(gspca_dev);
 	return gspca_dev->usb_err;
 }
diff --git a/drivers/media/usb/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
index 17c7a953564c..d668589598d6 100644
--- a/drivers/media/usb/gspca/jl2005bcd.c
+++ b/drivers/media/usb/gspca/jl2005bcd.c
@@ -149,7 +149,8 @@ static int jl2005c_start_new_frame(struct gspca_dev *gspca_dev)
 			return retval;
 		i++;
 	}
-	PDEBUG(D_FRAM, "frame_brightness is 0x%02x", gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_FRAM, "frame_brightness is 0x%02x\n",
+		  gspca_dev->usb_buf[0]);
 	return retval;
 }
 
@@ -176,10 +177,11 @@ static int jl2005c_get_firmware_id(struct gspca_dev *gspca_dev)
 	int retval = -1;
 	unsigned char regs_to_read[] = {0x57, 0x02, 0x03, 0x5d, 0x5e, 0x5f};
 
-	PDEBUG(D_PROBE, "Running jl2005c_get_firmware_id");
+	gspca_dbg(gspca_dev, D_PROBE, "Running jl2005c_get_firmware_id\n");
 	/* Read the first ID byte once for warmup */
 	retval = jl2005c_read_reg(gspca_dev, regs_to_read[0]);
-	PDEBUG(D_PROBE, "response is %02x", gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_PROBE, "response is %02x\n",
+		  gspca_dev->usb_buf[0]);
 	if (retval < 0)
 		return retval;
 	/* Now actually get the ID string */
@@ -189,13 +191,13 @@ static int jl2005c_get_firmware_id(struct gspca_dev *gspca_dev)
 			return retval;
 		sd->firmware_id[i] = gspca_dev->usb_buf[0];
 	}
-	PDEBUG(D_PROBE, "firmware ID is %02x%02x%02x%02x%02x%02x",
-						sd->firmware_id[0],
-						sd->firmware_id[1],
-						sd->firmware_id[2],
-						sd->firmware_id[3],
-						sd->firmware_id[4],
-						sd->firmware_id[5]);
+	gspca_dbg(gspca_dev, D_PROBE, "firmware ID is %02x%02x%02x%02x%02x%02x\n",
+		  sd->firmware_id[0],
+		  sd->firmware_id[1],
+		  sd->firmware_id[2],
+		  sd->firmware_id[3],
+		  sd->firmware_id[4],
+		  sd->firmware_id[5]);
 	return 0;
 }
 
@@ -341,9 +343,9 @@ static void jl2005c_dostream(struct work_struct *work)
 				usb_rcvbulkpipe(gspca_dev->dev, 0x82),
 				buffer, JL2005C_MAX_TRANSFER, &act_len,
 				JL2005C_DATA_TIMEOUT);
-			PDEBUG(D_PACK,
-				"Got %d bytes out of %d for header",
-					act_len, JL2005C_MAX_TRANSFER);
+			gspca_dbg(gspca_dev, D_PACK,
+				  "Got %d bytes out of %d for header\n",
+				  act_len, JL2005C_MAX_TRANSFER);
 			if (ret < 0 || act_len < JL2005C_MAX_TRANSFER)
 				goto quit_stream;
 			/* Check whether we actually got the first blodk */
@@ -354,7 +356,8 @@ static void jl2005c_dostream(struct work_struct *work)
 			/* total size to fetch is byte 7, times blocksize
 			 * of which we already got act_len */
 			bytes_left = buffer[0x07] * dev->block_size - act_len;
-			PDEBUG(D_PACK, "bytes_left = 0x%x", bytes_left);
+			gspca_dbg(gspca_dev, D_PACK, "bytes_left = 0x%x\n",
+				  bytes_left);
 			/* We keep the header. It has other information, too.*/
 			packet_type = FIRST_PACKET;
 			gspca_frame_add(gspca_dev, packet_type,
@@ -370,9 +373,9 @@ static void jl2005c_dostream(struct work_struct *work)
 				JL2005C_DATA_TIMEOUT);
 			if (ret < 0 || act_len < data_len)
 				goto quit_stream;
-			PDEBUG(D_PACK,
-				"Got %d bytes out of %d for frame",
-						data_len, bytes_left);
+			gspca_dbg(gspca_dev, D_PACK,
+				  "Got %d bytes out of %d for frame\n",
+				  data_len, bytes_left);
 			bytes_left -= data_len;
 			if (bytes_left == 0) {
 				packet_type = LAST_PACKET;
@@ -449,19 +452,19 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	switch (gspca_dev->pixfmt.width) {
 	case 640:
-		PDEBUG(D_STREAM, "Start streaming at vga resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at vga resolution\n");
 		jl2005c_stream_start_vga_lg(gspca_dev);
 		break;
 	case 320:
-		PDEBUG(D_STREAM, "Start streaming at qvga resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at qvga resolution\n");
 		jl2005c_stream_start_vga_small(gspca_dev);
 		break;
 	case 352:
-		PDEBUG(D_STREAM, "Start streaming at cif resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at cif resolution\n");
 		jl2005c_stream_start_cif_lg(gspca_dev);
 		break;
 	case 176:
-		PDEBUG(D_STREAM, "Start streaming at qcif resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at qcif resolution\n");
 		jl2005c_stream_start_cif_small(gspca_dev);
 		break;
 	default:
diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 2f28b38c5479..0cfdf8a1e19d 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -151,8 +151,9 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	memcpy(obuf+sizeof(*chdr), cmdbuf, cmd_len);
 
 	res = kinect_write(udev, obuf, cmd_len + sizeof(*chdr));
-	PDEBUG(D_USBO, "Control cmd=%04x tag=%04x len=%04x: %d", cmd,
-		sd->cam_tag, cmd_len, res);
+	gspca_dbg(gspca_dev, D_USBO, "Control cmd=%04x tag=%04x len=%04x: %d\n",
+		  cmd,
+		  sd->cam_tag, cmd_len, res);
 	if (res < 0) {
 		pr_err("send_cmd: Output control transfer failed (%d)\n", res);
 		return res;
@@ -161,7 +162,7 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
 	do {
 		actual_len = kinect_read(udev, ibuf, 0x200);
 	} while (actual_len == 0);
-	PDEBUG(D_USBO, "Control reply: %d", actual_len);
+	gspca_dbg(gspca_dev, D_USBO, "Control reply: %d\n", actual_len);
 	if (actual_len < sizeof(*rhdr)) {
 		pr_err("send_cmd: Input control transfer failed (%d)\n",
 		       actual_len);
@@ -213,7 +214,7 @@ static int write_register(struct gspca_dev *gspca_dev, uint16_t reg,
 	cmd[0] = cpu_to_le16(reg);
 	cmd[1] = cpu_to_le16(data);
 
-	PDEBUG(D_USBO, "Write Reg 0x%04x <= 0x%02x", reg, data);
+	gspca_dbg(gspca_dev, D_USBO, "Write Reg 0x%04x <= 0x%02x\n", reg, data);
 	res = send_cmd(gspca_dev, 0x03, cmd, 4, reply, 4);
 	if (res < 0)
 		return res;
@@ -274,7 +275,7 @@ static int sd_config_depth(struct gspca_dev *gspca_dev,
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	PDEBUG(D_PROBE, "Kinect Camera device.");
+	gspca_dbg(gspca_dev, D_PROBE, "Kinect Camera device.\n");
 
 	return 0;
 }
diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/konica.c
index d51aca01167f..989ae997f66d 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -263,7 +263,7 @@ static void sd_isoc_irq(struct urb *urb)
 	u8 *data;
 	int i, st;
 
-	PDEBUG(D_PACK, "sd isoc irq");
+	gspca_dbg(gspca_dev, D_PACK, "sd isoc irq\n");
 	if (!gspca_dev->streaming)
 		return;
 
diff --git a/drivers/media/usb/gspca/m5602/m5602_core.c b/drivers/media/usb/gspca/m5602/m5602_core.c
index 4aab17efa4cc..b83ec4285a0b 100644
--- a/drivers/media/usb/gspca/m5602/m5602_core.c
+++ b/drivers/media/usb/gspca/m5602/m5602_core.c
@@ -66,8 +66,8 @@ int m5602_read_bridge(struct sd *sd, const u8 address, u8 *i2c_data)
 			      1, M5602_URB_MSG_TIMEOUT);
 	*i2c_data = buf[0];
 
-	PDEBUG(D_CONF, "Reading bridge register 0x%x containing 0x%x",
-	       address, *i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Reading bridge register 0x%x containing 0x%x\n",
+		  address, *i2c_data);
 
 	/* usb_control_msg(...) returns the number of bytes sent upon success,
 	mask that and return zero instead*/
@@ -82,8 +82,8 @@ int m5602_write_bridge(struct sd *sd, const u8 address, const u8 i2c_data)
 	struct usb_device *udev = sd->gspca_dev.dev;
 	__u8 *buf = sd->gspca_dev.usb_buf;
 
-	PDEBUG(D_CONF, "Writing bridge register 0x%x with 0x%x",
-	       address, i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Writing bridge register 0x%x with 0x%x\n",
+		  address, i2c_data);
 
 	memcpy(buf, bridge_urb_skeleton,
 	       sizeof(bridge_urb_skeleton));
@@ -154,8 +154,8 @@ int m5602_read_sensor(struct sd *sd, const u8 address,
 
 		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
 
-		PDEBUG(D_CONF, "Reading sensor register 0x%x containing 0x%x ",
-		       address, *i2c_data);
+		gspca_dbg(gspca_dev, D_CONF, "Reading sensor register 0x%x containing 0x%x\n",
+			  address, *i2c_data);
 	}
 	return err;
 }
@@ -187,8 +187,8 @@ int m5602_write_sensor(struct sd *sd, const u8 address,
 		memcpy(p, sensor_urb_skeleton + 16, 4);
 		p[3] = i2c_data[i];
 		p += 4;
-		PDEBUG(D_CONF, "Writing sensor register 0x%x with 0x%x",
-		       address, i2c_data[i]);
+		gspca_dbg(gspca_dev, D_CONF, "Writing sensor register 0x%x with 0x%x\n",
+			  address, i2c_data[i]);
 	}
 
 	/* Copy the tailer */
@@ -264,7 +264,7 @@ static int m5602_init(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	int err;
 
-	PDEBUG(D_CONF, "Initializing ALi m5602 webcam");
+	gspca_dbg(gspca_dev, D_CONF, "Initializing ALi m5602 webcam\n");
 	/* Run the init sequence */
 	err = sd->sensor->init(sd);
 
@@ -299,7 +299,7 @@ static int m5602_start_transfer(struct gspca_dev *gspca_dev)
 			      0x04, 0x40, 0x19, 0x0000, buf,
 			      sizeof(buffer), M5602_URB_MSG_TIMEOUT);
 
-	PDEBUG(D_STREAM, "Transfer started");
+	gspca_dbg(gspca_dev, D_STREAM, "Transfer started\n");
 	return (err < 0) ? err : 0;
 }
 
@@ -309,14 +309,14 @@ static void m5602_urb_complete(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	if (len < 6) {
-		PDEBUG(D_PACK, "Packet is less than 6 bytes");
+		gspca_dbg(gspca_dev, D_PACK, "Packet is less than 6 bytes\n");
 		return;
 	}
 
 	/* Frame delimiter: ff xx xx xx ff ff */
 	if (data[0] == 0xff && data[4] == 0xff && data[5] == 0xff &&
 	    data[2] != sd->frame_id) {
-		PDEBUG(D_FRAM, "Frame delimiter detected");
+		gspca_dbg(gspca_dev, D_FRAM, "Frame delimiter detected\n");
 		sd->frame_id = data[2];
 
 		/* Remove the extra fluff appended on each header */
@@ -331,8 +331,8 @@ static void m5602_urb_complete(struct gspca_dev *gspca_dev,
 		/* Create a new frame */
 		gspca_frame_add(gspca_dev, FIRST_PACKET, data, len);
 
-		PDEBUG(D_FRAM, "Starting new frame %d",
-		       sd->frame_count);
+		gspca_dbg(gspca_dev, D_FRAM, "Starting new frame %d\n",
+			  sd->frame_count);
 
 	} else {
 		int cur_frame_len;
@@ -343,8 +343,8 @@ static void m5602_urb_complete(struct gspca_dev *gspca_dev,
 		len -= 4;
 
 		if (cur_frame_len + len <= gspca_dev->frsz) {
-			PDEBUG(D_FRAM, "Continuing frame %d copying %d bytes",
-			       sd->frame_count, len);
+			gspca_dbg(gspca_dev, D_FRAM, "Continuing frame %d copying %d bytes\n",
+				  sd->frame_count, len);
 
 			gspca_frame_add(gspca_dev, INTER_PACKET,
 					data, len);
diff --git a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
index 7d01ddd7ed01..c9947c4a0f63 100644
--- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
+++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
@@ -212,7 +212,7 @@ int mt9m111_probe(struct sd *sd)
 		return -ENODEV;
 	}
 
-	PDEBUG(D_PROBE, "Probing for a mt9m111 sensor");
+	gspca_dbg(gspca_dev, D_PROBE, "Probing for a mt9m111 sensor\n");
 
 	/* Do the preinit */
 	for (i = 0; i < ARRAY_SIZE(preinit_mt9m111); i++) {
@@ -375,11 +375,11 @@ int mt9m111_start(struct sd *sd)
 
 	switch (width) {
 	case 640:
-		PDEBUG(D_CONF, "Configuring camera for VGA mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for VGA mode\n");
 		break;
 
 	case 320:
-		PDEBUG(D_CONF, "Configuring camera for QVGA mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for QVGA mode\n");
 		break;
 	}
 	return err;
@@ -398,7 +398,8 @@ static int mt9m111_set_hvflip(struct gspca_dev *gspca_dev)
 	int hflip;
 	int vflip;
 
-	PDEBUG(D_CONF, "Set hvflip to %d %d", sd->hflip->val, sd->vflip->val);
+	gspca_dbg(gspca_dev, D_CONF, "Set hvflip to %d %d\n",
+		  sd->hflip->val, sd->vflip->val);
 
 	/* The mt9m111 is flipped by default */
 	hflip = !sd->hflip->val;
@@ -439,7 +440,7 @@ static int mt9m111_set_auto_white_balance(struct gspca_dev *gspca_dev,
 
 	err = m5602_write_sensor(sd, MT9M111_CP_OPERATING_MODE_CTL, data, 2);
 
-	PDEBUG(D_CONF, "Set auto white balance %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto white balance %d\n", val);
 	return err;
 }
 
@@ -472,8 +473,8 @@ static int mt9m111_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 
 	data[1] = (tmp & 0xff);
 	data[0] = (tmp & 0xff00) >> 8;
-	PDEBUG(D_CONF, "tmp=%d, data[1]=%d, data[0]=%d", tmp,
-	       data[1], data[0]);
+	gspca_dbg(gspca_dev, D_CONF, "tmp=%d, data[1]=%d, data[0]=%d\n", tmp,
+		  data[1], data[0]);
 
 	err = m5602_write_sensor(sd, MT9M111_SC_GLOBAL_GAIN,
 				   data, 2);
@@ -490,7 +491,7 @@ static int mt9m111_set_green_balance(struct gspca_dev *gspca_dev, __s32 val)
 	data[1] = (val & 0xff);
 	data[0] = (val & 0xff00) >> 8;
 
-	PDEBUG(D_CONF, "Set green balance %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set green balance %d\n", val);
 	err = m5602_write_sensor(sd, MT9M111_SC_GREEN_1_GAIN,
 				 data, 2);
 	if (err < 0)
@@ -508,7 +509,7 @@ static int mt9m111_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
 	data[1] = (val & 0xff);
 	data[0] = (val & 0xff00) >> 8;
 
-	PDEBUG(D_CONF, "Set blue balance %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set blue balance %d\n", val);
 
 	return m5602_write_sensor(sd, MT9M111_SC_BLUE_GAIN,
 				  data, 2);
@@ -522,7 +523,7 @@ static int mt9m111_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
 	data[1] = (val & 0xff);
 	data[0] = (val & 0xff00) >> 8;
 
-	PDEBUG(D_CONF, "Set red balance %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set red balance %d\n", val);
 
 	return m5602_write_sensor(sd, MT9M111_SC_RED_GAIN,
 				  data, 2);
diff --git a/drivers/media/usb/gspca/m5602/m5602_ov7660.c b/drivers/media/usb/gspca/m5602/m5602_ov7660.c
index 672b7a520695..aa1f569c82fd 100644
--- a/drivers/media/usb/gspca/m5602/m5602_ov7660.c
+++ b/drivers/media/usb/gspca/m5602/m5602_ov7660.c
@@ -330,7 +330,7 @@ static int ov7660_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data = val;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Setting gain to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Setting gain to %d\n", val);
 
 	err = m5602_write_sensor(sd, OV7660_GAIN, &i2c_data, 1);
 	return err;
@@ -343,7 +343,7 @@ static int ov7660_set_auto_white_balance(struct gspca_dev *gspca_dev,
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set auto white balance to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto white balance to %d\n", val);
 
 	err = m5602_read_sensor(sd, OV7660_COM8, &i2c_data, 1);
 	if (err < 0)
@@ -361,7 +361,7 @@ static int ov7660_set_auto_gain(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set auto gain control to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto gain control to %d\n", val);
 
 	err = m5602_read_sensor(sd, OV7660_COM8, &i2c_data, 1);
 	if (err < 0)
@@ -379,7 +379,7 @@ static int ov7660_set_auto_exposure(struct gspca_dev *gspca_dev,
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set auto exposure control to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto exposure control to %d\n", val);
 
 	err = m5602_read_sensor(sd, OV7660_COM8, &i2c_data, 1);
 	if (err < 0)
@@ -397,7 +397,8 @@ static int ov7660_set_hvflip(struct gspca_dev *gspca_dev)
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set hvflip to %d, %d", sd->hflip->val, sd->vflip->val);
+	gspca_dbg(gspca_dev, D_CONF, "Set hvflip to %d, %d\n",
+		  sd->hflip->val, sd->vflip->val);
 
 	i2c_data = (sd->hflip->val << 5) | (sd->vflip->val << 4);
 
diff --git a/drivers/media/usb/gspca/m5602/m5602_ov9650.c b/drivers/media/usb/gspca/m5602/m5602_ov9650.c
index 4544d3a1ad58..2ffbb54e89f9 100644
--- a/drivers/media/usb/gspca/m5602/m5602_ov9650.c
+++ b/drivers/media/usb/gspca/m5602/m5602_ov9650.c
@@ -311,7 +311,7 @@ int ov9650_probe(struct sd *sd)
 		return -ENODEV;
 	}
 
-	PDEBUG(D_PROBE, "Probing for an ov9650 sensor");
+	gspca_dbg(gspca_dev, D_PROBE, "Probing for an ov9650 sensor\n");
 
 	/* Run the pre-init before probing the sensor */
 	for (i = 0; i < ARRAY_SIZE(preinit_ov9650) && !err; i++) {
@@ -505,7 +505,7 @@ int ov9650_start(struct sd *sd)
 
 	switch (width) {
 	case 640:
-		PDEBUG(D_CONF, "Configuring camera for VGA mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for VGA mode\n");
 
 		data = OV9650_VGA_SELECT | OV9650_RGB_SELECT |
 		       OV9650_RAW_RGB_SELECT;
@@ -513,7 +513,7 @@ int ov9650_start(struct sd *sd)
 		break;
 
 	case 352:
-		PDEBUG(D_CONF, "Configuring camera for CIF mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for CIF mode\n");
 
 		data = OV9650_CIF_SELECT | OV9650_RGB_SELECT |
 				OV9650_RAW_RGB_SELECT;
@@ -521,7 +521,7 @@ int ov9650_start(struct sd *sd)
 		break;
 
 	case 320:
-		PDEBUG(D_CONF, "Configuring camera for QVGA mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for QVGA mode\n");
 
 		data = OV9650_QVGA_SELECT | OV9650_RGB_SELECT |
 				OV9650_RAW_RGB_SELECT;
@@ -529,7 +529,7 @@ int ov9650_start(struct sd *sd)
 		break;
 
 	case 176:
-		PDEBUG(D_CONF, "Configuring camera for QCIF mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for QCIF mode\n");
 
 		data = OV9650_QCIF_SELECT | OV9650_RGB_SELECT |
 			OV9650_RAW_RGB_SELECT;
@@ -558,7 +558,7 @@ static int ov9650_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data;
 	int err;
 
-	PDEBUG(D_CONF, "Set exposure to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set exposure to %d\n", val);
 
 	/* The 6 MSBs */
 	i2c_data = (val >> 10) & 0x3f;
@@ -586,7 +586,7 @@ static int ov9650_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Setting gain to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Setting gain to %d\n", val);
 
 	/* The 2 MSB */
 	/* Read the OV9650_VREF register first to avoid
@@ -614,7 +614,7 @@ static int ov9650_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set red gain to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set red gain to %d\n", val);
 
 	i2c_data = val & 0xff;
 	err = m5602_write_sensor(sd, OV9650_RED, &i2c_data, 1);
@@ -627,7 +627,7 @@ static int ov9650_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set blue gain to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set blue gain to %d\n", val);
 
 	i2c_data = val & 0xff;
 	err = m5602_write_sensor(sd, OV9650_BLUE, &i2c_data, 1);
@@ -642,7 +642,7 @@ static int ov9650_set_hvflip(struct gspca_dev *gspca_dev)
 	int hflip = sd->hflip->val;
 	int vflip = sd->vflip->val;
 
-	PDEBUG(D_CONF, "Set hvflip to %d %d", hflip, vflip);
+	gspca_dbg(gspca_dev, D_CONF, "Set hvflip to %d %d\n", hflip, vflip);
 
 	if (dmi_check_system(ov9650_flip_dmi_table))
 		vflip = !vflip;
@@ -666,7 +666,7 @@ static int ov9650_set_auto_exposure(struct gspca_dev *gspca_dev,
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set auto exposure control to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto exposure control to %d\n", val);
 
 	err = m5602_read_sensor(sd, OV9650_COM8, &i2c_data, 1);
 	if (err < 0)
@@ -685,7 +685,7 @@ static int ov9650_set_auto_white_balance(struct gspca_dev *gspca_dev,
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set auto white balance to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto white balance to %d\n", val);
 
 	err = m5602_read_sensor(sd, OV9650_COM8, &i2c_data, 1);
 	if (err < 0)
@@ -703,7 +703,7 @@ static int ov9650_set_auto_gain(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set auto gain control to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto gain control to %d\n", val);
 
 	err = m5602_read_sensor(sd, OV9650_COM8, &i2c_data, 1);
 	if (err < 0)
diff --git a/drivers/media/usb/gspca/m5602/m5602_po1030.c b/drivers/media/usb/gspca/m5602/m5602_po1030.c
index a0a90dd34ca8..37d2891e5f5b 100644
--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c
+++ b/drivers/media/usb/gspca/m5602/m5602_po1030.c
@@ -171,7 +171,7 @@ int po1030_probe(struct sd *sd)
 		return -ENODEV;
 	}
 
-	PDEBUG(D_PROBE, "Probing for a po1030 sensor");
+	gspca_dbg(gspca_dev, D_PROBE, "Probing for a po1030 sensor\n");
 
 	/* Run the pre-init to actually probe the unit */
 	for (i = 0; i < ARRAY_SIZE(preinit_po1030); i++) {
@@ -410,11 +410,11 @@ static int po1030_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 	u8 i2c_data;
 	int err;
 
-	PDEBUG(D_CONF, "Set exposure to %d", val & 0xffff);
+	gspca_dbg(gspca_dev, D_CONF, "Set exposure to %d\n", val & 0xffff);
 
 	i2c_data = ((val & 0xff00) >> 8);
-	PDEBUG(D_CONF, "Set exposure to high byte to 0x%x",
-	       i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Set exposure to high byte to 0x%x\n",
+		  i2c_data);
 
 	err = m5602_write_sensor(sd, PO1030_INTEGLINES_H,
 				  &i2c_data, 1);
@@ -422,8 +422,8 @@ static int po1030_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 		return err;
 
 	i2c_data = (val & 0xff);
-	PDEBUG(D_CONF, "Set exposure to low byte to 0x%x",
-	       i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Set exposure to low byte to 0x%x\n",
+		  i2c_data);
 	err = m5602_write_sensor(sd, PO1030_INTEGLINES_M,
 				  &i2c_data, 1);
 
@@ -437,7 +437,7 @@ static int po1030_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 	int err;
 
 	i2c_data = val & 0xff;
-	PDEBUG(D_CONF, "Set global gain to %d", i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Set global gain to %d\n", i2c_data);
 	err = m5602_write_sensor(sd, PO1030_GLOBALGAIN,
 				 &i2c_data, 1);
 	return err;
@@ -449,7 +449,8 @@ static int po1030_set_hvflip(struct gspca_dev *gspca_dev)
 	u8 i2c_data;
 	int err;
 
-	PDEBUG(D_CONF, "Set hvflip %d %d", sd->hflip->val, sd->vflip->val);
+	gspca_dbg(gspca_dev, D_CONF, "Set hvflip %d %d\n",
+		  sd->hflip->val, sd->vflip->val);
 	err = m5602_read_sensor(sd, PO1030_CONTROL2, &i2c_data, 1);
 	if (err < 0)
 		return err;
@@ -470,7 +471,7 @@ static int po1030_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
 	int err;
 
 	i2c_data = val & 0xff;
-	PDEBUG(D_CONF, "Set red gain to %d", i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Set red gain to %d\n", i2c_data);
 	err = m5602_write_sensor(sd, PO1030_RED_GAIN,
 				  &i2c_data, 1);
 	return err;
@@ -483,7 +484,7 @@ static int po1030_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
 	int err;
 
 	i2c_data = val & 0xff;
-	PDEBUG(D_CONF, "Set blue gain to %d", i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Set blue gain to %d\n", i2c_data);
 	err = m5602_write_sensor(sd, PO1030_BLUE_GAIN,
 				  &i2c_data, 1);
 
@@ -497,7 +498,7 @@ static int po1030_set_green_balance(struct gspca_dev *gspca_dev, __s32 val)
 	int err;
 
 	i2c_data = val & 0xff;
-	PDEBUG(D_CONF, "Set green gain to %d", i2c_data);
+	gspca_dbg(gspca_dev, D_CONF, "Set green gain to %d\n", i2c_data);
 
 	err = m5602_write_sensor(sd, PO1030_GREEN_1_GAIN,
 			   &i2c_data, 1);
@@ -519,7 +520,7 @@ static int po1030_set_auto_white_balance(struct gspca_dev *gspca_dev,
 	if (err < 0)
 		return err;
 
-	PDEBUG(D_CONF, "Set auto white balance to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto white balance to %d\n", val);
 	i2c_data = (i2c_data & 0xfe) | (val & 0x01);
 	err = m5602_write_sensor(sd, PO1030_AUTOCTRL1, &i2c_data, 1);
 	return err;
@@ -536,7 +537,7 @@ static int po1030_set_auto_exposure(struct gspca_dev *gspca_dev,
 	if (err < 0)
 		return err;
 
-	PDEBUG(D_CONF, "Set auto exposure to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set auto exposure to %d\n", val);
 	val = (val == V4L2_EXPOSURE_AUTO);
 	i2c_data = (i2c_data & 0xfd) | ((val & 0x01) << 1);
 	return m5602_write_sensor(sd, PO1030_AUTOCTRL1, &i2c_data, 1);
diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k4aa.c b/drivers/media/usb/gspca/m5602/m5602_s5k4aa.c
index 8447b9c5f8e0..cec4a5838aec 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k4aa.c
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k4aa.c
@@ -357,7 +357,7 @@ int s5k4aa_probe(struct sd *sd)
 		return -ENODEV;
 	}
 
-	PDEBUG(D_PROBE, "Probing for a s5k4aa sensor");
+	gspca_dbg(gspca_dev, D_PROBE, "Probing for a s5k4aa sensor\n");
 
 	/* Preinit the sensor */
 	for (i = 0; i < ARRAY_SIZE(preinit_s5k4aa) && !err; i++) {
@@ -419,7 +419,7 @@ int s5k4aa_start(struct sd *sd)
 
 	switch (cam->cam_mode[sd->gspca_dev.curr_mode].width) {
 	case 1280:
-		PDEBUG(D_CONF, "Configuring camera for SXGA mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for SXGA mode\n");
 
 		for (i = 0; i < ARRAY_SIZE(SXGA_s5k4aa); i++) {
 			switch (SXGA_s5k4aa[i][0]) {
@@ -452,7 +452,7 @@ int s5k4aa_start(struct sd *sd)
 		break;
 
 	case 640:
-		PDEBUG(D_CONF, "Configuring camera for VGA mode");
+		gspca_dbg(gspca_dev, D_CONF, "Configuring camera for VGA mode\n");
 
 		for (i = 0; i < ARRAY_SIZE(VGA_s5k4aa); i++) {
 			switch (VGA_s5k4aa[i][0]) {
@@ -568,7 +568,7 @@ static int s5k4aa_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 	u8 data = S5K4AA_PAGE_MAP_2;
 	int err;
 
-	PDEBUG(D_CONF, "Set exposure to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set exposure to %d\n", val);
 	err = m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
 	if (err < 0)
 		return err;
@@ -590,7 +590,7 @@ static int s5k4aa_set_hvflip(struct gspca_dev *gspca_dev)
 	int hflip = sd->hflip->val;
 	int vflip = sd->vflip->val;
 
-	PDEBUG(D_CONF, "Set hvflip %d %d", hflip, vflip);
+	gspca_dbg(gspca_dev, D_CONF, "Set hvflip %d %d\n", hflip, vflip);
 	err = m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
 	if (err < 0)
 		return err;
@@ -640,7 +640,7 @@ static int s5k4aa_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 	u8 data = S5K4AA_PAGE_MAP_2;
 	int err;
 
-	PDEBUG(D_CONF, "Set gain to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set gain to %d\n", val);
 	err = m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
 	if (err < 0)
 		return err;
@@ -657,7 +657,7 @@ static int s5k4aa_set_brightness(struct gspca_dev *gspca_dev, __s32 val)
 	u8 data = S5K4AA_PAGE_MAP_2;
 	int err;
 
-	PDEBUG(D_CONF, "Set brightness to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set brightness to %d\n", val);
 	err = m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
 	if (err < 0)
 		return err;
@@ -672,7 +672,7 @@ static int s5k4aa_set_noise(struct gspca_dev *gspca_dev, __s32 val)
 	u8 data = S5K4AA_PAGE_MAP_2;
 	int err;
 
-	PDEBUG(D_CONF, "Set noise to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set noise to %d\n", val);
 	err = m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
 	if (err < 0)
 		return err;
diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
index 6ad8d4849680..3d8ab18138aa 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
@@ -187,7 +187,7 @@ int s5k83a_probe(struct sd *sd)
 		return -ENODEV;
 	}
 
-	PDEBUG(D_PROBE, "Probing for a s5k83a sensor");
+	gspca_dbg(gspca_dev, D_PROBE, "Probing for a s5k83a sensor\n");
 
 	/* Preinit the sensor */
 	for (i = 0; i < ARRAY_SIZE(preinit_s5k83a) && !err; i++) {
diff --git a/drivers/media/usb/gspca/mars.c b/drivers/media/usb/gspca/mars.c
index 25df55e840c7..a537cb195c46 100644
--- a/drivers/media/usb/gspca/mars.c
+++ b/drivers/media/usb/gspca/mars.c
@@ -378,8 +378,8 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			    || data[5 + p] == 0x65
 			    || data[5 + p] == 0x66
 			    || data[5 + p] == 0x67) {
-				PDEBUG(D_PACK, "sof offset: %d len: %d",
-					p, len);
+				gspca_dbg(gspca_dev, D_PACK, "sof offset: %d len: %d\n",
+					  p, len);
 				gspca_frame_add(gspca_dev, LAST_PACKET,
 						data, p);
 
diff --git a/drivers/media/usb/gspca/mr97310a.c b/drivers/media/usb/gspca/mr97310a.c
index 34aacaee4453..bea196361215 100644
--- a/drivers/media/usb/gspca/mr97310a.c
+++ b/drivers/media/usb/gspca/mr97310a.c
@@ -221,10 +221,11 @@ static int cam_get_response16(struct gspca_dev *gspca_dev, u8 reg, int verbose)
 		return err_code;
 
 	if (verbose)
-		PDEBUG(D_PROBE, "Register: %02x reads %02x%02x%02x", reg,
-		       gspca_dev->usb_buf[0],
-		       gspca_dev->usb_buf[1],
-		       gspca_dev->usb_buf[2]);
+		gspca_dbg(gspca_dev, D_PROBE, "Register: %02x reads %02x%02x%02x\n",
+			  reg,
+			  gspca_dev->usb_buf[0],
+			  gspca_dev->usb_buf[1],
+			  gspca_dev->usb_buf[2]);
 
 	return 0;
 }
@@ -413,8 +414,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 			       gspca_dev->usb_buf[1]);
 			return -ENODEV;
 		}
-		PDEBUG(D_PROBE, "MR97310A CIF camera detected, sensor: %d",
-		       sd->sensor_type);
+		gspca_dbg(gspca_dev, D_PROBE, "MR97310A CIF camera detected, sensor: %d\n",
+			  sd->sensor_type);
 	} else {
 		sd->cam_type = CAM_TYPE_VGA;
 
@@ -458,7 +459,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 			switch (gspca_dev->usb_buf[1]) {
 			case 0x50:
 				sd->sensor_type = 0;
-				PDEBUG(D_PROBE, "sensor_type corrected to 0");
+				gspca_dbg(gspca_dev, D_PROBE, "sensor_type corrected to 0\n");
 				break;
 			case 0x20:
 				/* Nothing to do here. */
@@ -470,16 +471,16 @@ static int sd_config(struct gspca_dev *gspca_dev,
 				pr_err("Please report this\n");
 			}
 		}
-		PDEBUG(D_PROBE, "MR97310A VGA camera detected, sensor: %d",
-		       sd->sensor_type);
+		gspca_dbg(gspca_dev, D_PROBE, "MR97310A VGA camera detected, sensor: %d\n",
+			  sd->sensor_type);
 	}
 	/* Stop streaming as we've started it only to probe the sensor type. */
 	sd_stopN(gspca_dev);
 
 	if (force_sensor_type != -1) {
 		sd->sensor_type = !!force_sensor_type;
-		PDEBUG(D_PROBE, "Forcing sensor type to: %d",
-		       sd->sensor_type);
+		gspca_dbg(gspca_dev, D_PROBE, "Forcing sensor type to: %d\n",
+			  sd->sensor_type);
 	}
 
 	return 0;
diff --git a/drivers/media/usb/gspca/nw80x.c b/drivers/media/usb/gspca/nw80x.c
index 5d2d0bcb038d..bedc04a72e97 100644
--- a/drivers/media/usb/gspca/nw80x.c
+++ b/drivers/media/usb/gspca/nw80x.c
@@ -1543,10 +1543,11 @@ static void reg_w(struct gspca_dev *gspca_dev,
 	if (gspca_dev->usb_err < 0)
 		return;
 	if (len == 1)
-		PDEBUG(D_USBO, "SET 00 0000 %04x %02x", index, *data);
+		gspca_dbg(gspca_dev, D_USBO, "SET 00 0000 %04x %02x\n",
+			  index, *data);
 	else
-		PDEBUG(D_USBO, "SET 00 0000 %04x %02x %02x ...",
-				index, *data, data[1]);
+		gspca_dbg(gspca_dev, D_USBO, "SET 00 0000 %04x %02x %02x ...\n",
+			  index, *data, data[1]);
 	memcpy(gspca_dev->usb_buf, data, len);
 	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 			0x00,
@@ -1583,12 +1584,12 @@ static void reg_r(struct gspca_dev *gspca_dev,
 		return;
 	}
 	if (len == 1)
-		PDEBUG(D_USBI, "GET 00 0000 %04x %02x",
-				index, gspca_dev->usb_buf[0]);
+		gspca_dbg(gspca_dev, D_USBI, "GET 00 0000 %04x %02x\n",
+			  index, gspca_dev->usb_buf[0]);
 	else
-		PDEBUG(D_USBI, "GET 00 0000 %04x %02x %02x ..",
-				index, gspca_dev->usb_buf[0],
-				gspca_dev->usb_buf[1]);
+		gspca_dbg(gspca_dev, D_USBI, "GET 00 0000 %04x %02x %02x ..\n",
+			  index, gspca_dev->usb_buf[0],
+			  gspca_dev->usb_buf[1]);
 }
 
 static void i2c_w(struct gspca_dev *gspca_dev,
@@ -1762,8 +1763,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 			sd->webcam = P35u;
 	} else if (id->idVendor == 0x06a5 && id->idProduct == 0xd800) {
 		reg_r(gspca_dev, 0x0403, 1);		/* GPIO */
-		PDEBUG(D_PROBE, "et31x110 sensor type %02x",
-				gspca_dev->usb_buf[0]);
+		gspca_dbg(gspca_dev, D_PROBE, "et31x110 sensor type %02x\n",
+			  gspca_dev->usb_buf[0]);
 		switch (gspca_dev->usb_buf[0] >> 1) {
 		case 0x00:				/* ?? */
 			if (sd->webcam == Generic800)
@@ -1785,7 +1786,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		gspca_dev->usb_err = -ENODEV;
 		return gspca_dev->usb_err;
 	}
-	PDEBUG(D_PROBE, "Bridge nw80%d - type: %d", sd->bridge, sd->webcam);
+	gspca_dbg(gspca_dev, D_PROBE, "Bridge nw80%d - type: %d\n",
+		  sd->bridge, sd->webcam);
 
 	if (sd->bridge == BRIDGE_NW800) {
 		switch (sd->webcam) {
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index fa541dfbe3a8..383674f8115d 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2016,8 +2016,8 @@ static void reg_w(struct sd *sd, u16 index, u16 value)
 		req = 0x0a;
 		/* fall through */
 	case BRIDGE_W9968CF:
-		PDEBUG(D_USBO, "SET %02x %04x %04x",
-				req, value, index);
+		gspca_dbg(gspca_dev, D_USBO, "SET %02x %04x %04x\n",
+			  req, value, index);
 		ret = usb_control_msg(sd->gspca_dev.dev,
 			usb_sndctrlpipe(sd->gspca_dev.dev, 0),
 			req,
@@ -2028,8 +2028,8 @@ static void reg_w(struct sd *sd, u16 index, u16 value)
 		req = 1;
 	}
 
-	PDEBUG(D_USBO, "SET %02x 0000 %04x %02x",
-			req, index, value);
+	gspca_dbg(gspca_dev, D_USBO, "SET %02x 0000 %04x %02x\n",
+		  req, index, value);
 	sd->gspca_dev.usb_buf[0] = value;
 	ret = usb_control_msg(sd->gspca_dev.dev,
 			usb_sndctrlpipe(sd->gspca_dev.dev, 0),
@@ -2078,8 +2078,8 @@ static int reg_r(struct sd *sd, u16 index)
 
 	if (ret >= 0) {
 		ret = sd->gspca_dev.usb_buf[0];
-		PDEBUG(D_USBI, "GET %02x 0000 %04x %02x",
-			req, index, ret);
+		gspca_dbg(gspca_dev, D_USBI, "GET %02x 0000 %04x %02x\n",
+			  req, index, ret);
 	} else {
 		gspca_err(gspca_dev, "reg_r %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
@@ -2175,7 +2175,7 @@ static void ov511_i2c_w(struct sd *sd, u8 reg, u8 value)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 	int rc, retries;
 
-	PDEBUG(D_USBO, "ov511_i2c_w %02x %02x", reg, value);
+	gspca_dbg(gspca_dev, D_USBO, "ov511_i2c_w %02x %02x\n", reg, value);
 
 	/* Three byte write cycle */
 	for (retries = 6; ; ) {
@@ -2198,7 +2198,7 @@ static void ov511_i2c_w(struct sd *sd, u8 reg, u8 value)
 		if ((rc & 2) == 0) /* Ack? */
 			break;
 		if (--retries < 0) {
-			PDEBUG(D_USBO, "i2c write retries exhausted");
+			gspca_dbg(gspca_dev, D_USBO, "i2c write retries exhausted\n");
 			return;
 		}
 	}
@@ -2231,7 +2231,7 @@ static int ov511_i2c_r(struct sd *sd, u8 reg)
 		reg_w(sd, R511_I2C_CTL, 0x10);
 
 		if (--retries < 0) {
-			PDEBUG(D_USBI, "i2c write retries exhausted");
+			gspca_dbg(gspca_dev, D_USBI, "i2c write retries exhausted\n");
 			return -1;
 		}
 	}
@@ -2255,14 +2255,14 @@ static int ov511_i2c_r(struct sd *sd, u8 reg)
 		reg_w(sd, R511_I2C_CTL, 0x10);
 
 		if (--retries < 0) {
-			PDEBUG(D_USBI, "i2c read retries exhausted");
+			gspca_dbg(gspca_dev, D_USBI, "i2c read retries exhausted\n");
 			return -1;
 		}
 	}
 
 	value = reg_r(sd, R51x_I2C_DATA);
 
-	PDEBUG(D_USBI, "ov511_i2c_r %02x %02x", reg, value);
+	gspca_dbg(gspca_dev, D_USBI, "ov511_i2c_r %02x %02x\n", reg, value);
 
 	/* This is needed to make i2c_w() work */
 	reg_w(sd, R511_I2C_CTL, 0x05);
@@ -2281,7 +2281,7 @@ static void ov518_i2c_w(struct sd *sd,
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
-	PDEBUG(D_USBO, "ov518_i2c_w %02x %02x", reg, value);
+	gspca_dbg(gspca_dev, D_USBO, "ov518_i2c_w %02x %02x\n", reg, value);
 
 	/* Select camera register */
 	reg_w(sd, R51x_I2C_SADDR_3, reg);
@@ -2321,7 +2321,7 @@ static int ov518_i2c_r(struct sd *sd, u8 reg)
 	reg_r8(sd, R518_I2C_CTL);
 
 	value = reg_r(sd, R51x_I2C_DATA);
-	PDEBUG(D_USBI, "ov518_i2c_r %02x %02x", reg, value);
+	gspca_dbg(gspca_dev, D_USBI, "ov518_i2c_r %02x %02x\n", reg, value);
 	return value;
 }
 
@@ -2344,7 +2344,7 @@ static void ovfx2_i2c_w(struct sd *sd, u8 reg, u8 value)
 		sd->gspca_dev.usb_err = ret;
 	}
 
-	PDEBUG(D_USBO, "ovfx2_i2c_w %02x %02x", reg, value);
+	gspca_dbg(gspca_dev, D_USBO, "ovfx2_i2c_w %02x %02x\n", reg, value);
 }
 
 static int ovfx2_i2c_r(struct sd *sd, u8 reg)
@@ -2363,7 +2363,8 @@ static int ovfx2_i2c_r(struct sd *sd, u8 reg)
 
 	if (ret >= 0) {
 		ret = sd->gspca_dev.usb_buf[0];
-		PDEBUG(D_USBI, "ovfx2_i2c_r %02x %02x", reg, ret);
+		gspca_dbg(gspca_dev, D_USBI, "ovfx2_i2c_r %02x %02x\n",
+			  reg, ret);
 	} else {
 		gspca_err(gspca_dev, "ovfx2_i2c_r %02x failed %d\n", reg, ret);
 		sd->gspca_dev.usb_err = ret;
@@ -2464,7 +2465,7 @@ static inline void ov51x_stop(struct sd *sd)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
-	PDEBUG(D_STREAM, "stopping");
+	gspca_dbg(gspca_dev, D_STREAM, "stopping\n");
 	sd->stopped = 1;
 	switch (sd->bridge) {
 	case BRIDGE_OV511:
@@ -2495,7 +2496,7 @@ static inline void ov51x_restart(struct sd *sd)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
-	PDEBUG(D_STREAM, "restarting");
+	gspca_dbg(gspca_dev, D_STREAM, "restarting\n");
 	if (!sd->stopped)
 		return;
 	sd->stopped = 0;
@@ -2546,7 +2547,8 @@ static int init_ov_sensor(struct sd *sd, u8 slave)
 	for (i = 0; i < i2c_detect_tries; i++) {
 		if (i2c_r(sd, OV7610_REG_ID_HIGH) == 0x7f &&
 		    i2c_r(sd, OV7610_REG_ID_LOW) == 0xa2) {
-			PDEBUG(D_PROBE, "I2C synced in %d attempt(s)", i);
+			gspca_dbg(gspca_dev, D_PROBE, "I2C synced in %d attempt(s)\n",
+				  i);
 			return 0;
 		}
 
@@ -2621,7 +2623,7 @@ static void ov_hires_configure(struct sd *sd)
 		return;
 	}
 
-	PDEBUG(D_PROBE, "starting ov hires configuration");
+	gspca_dbg(gspca_dev, D_PROBE, "starting ov hires configuration\n");
 
 	/* Detect sensor (sub)type */
 	high = i2c_r(sd, 0x0a);
@@ -2631,22 +2633,22 @@ static void ov_hires_configure(struct sd *sd)
 	case 0x96:
 		switch (low) {
 		case 0x40:
-			PDEBUG(D_PROBE, "Sensor is a OV2610");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is a OV2610\n");
 			sd->sensor = SEN_OV2610;
 			return;
 		case 0x41:
-			PDEBUG(D_PROBE, "Sensor is a OV2610AE");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is a OV2610AE\n");
 			sd->sensor = SEN_OV2610AE;
 			return;
 		case 0xb1:
-			PDEBUG(D_PROBE, "Sensor is a OV9600");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is a OV9600\n");
 			sd->sensor = SEN_OV9600;
 			return;
 		}
 		break;
 	case 0x36:
 		if ((low & 0x0f) == 0x00) {
-			PDEBUG(D_PROBE, "Sensor is a OV3610");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is a OV3610\n");
 			sd->sensor = SEN_OV3610;
 			return;
 		}
@@ -2664,7 +2666,7 @@ static void ov8xx0_configure(struct sd *sd)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 	int rc;
 
-	PDEBUG(D_PROBE, "starting ov8xx0 configuration");
+	gspca_dbg(gspca_dev, D_PROBE, "starting ov8xx0 configuration\n");
 
 	/* Detect sensor (sub)type */
 	rc = i2c_r(sd, OV7610_REG_COM_I);
@@ -2687,7 +2689,7 @@ static void ov7xx0_configure(struct sd *sd)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 	int rc, high, low;
 
-	PDEBUG(D_PROBE, "starting OV7xx0 configuration");
+	gspca_dbg(gspca_dev, D_PROBE, "starting OV7xx0 configuration\n");
 
 	/* Detect sensor (sub)type */
 	rc = i2c_r(sd, OV7610_REG_COM_I);
@@ -2704,19 +2706,20 @@ static void ov7xx0_configure(struct sd *sd)
 		low = i2c_r(sd, 0x0b);
 		/* info("%x, %x", high, low); */
 		if (high == 0x76 && (low & 0xf0) == 0x70) {
-			PDEBUG(D_PROBE, "Sensor is an OV76%02x", low);
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV76%02x\n",
+				  low);
 			sd->sensor = SEN_OV7670;
 		} else {
-			PDEBUG(D_PROBE, "Sensor is an OV7610");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV7610\n");
 			sd->sensor = SEN_OV7610;
 		}
 	} else if ((rc & 3) == 1) {
 		/* I don't know what's different about the 76BE yet. */
 		if (i2c_r(sd, 0x15) & 1) {
-			PDEBUG(D_PROBE, "Sensor is an OV7620AE");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV7620AE\n");
 			sd->sensor = SEN_OV7620AE;
 		} else {
-			PDEBUG(D_PROBE, "Sensor is an OV76BE");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV76BE\n");
 			sd->sensor = SEN_OV76BE;
 		}
 	} else if ((rc & 3) == 0) {
@@ -2738,19 +2741,19 @@ static void ov7xx0_configure(struct sd *sd)
 				gspca_err(gspca_dev, "7630 is not supported by this driver\n");
 				return;
 			case 0x40:
-				PDEBUG(D_PROBE, "Sensor is an OV7645");
+				gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV7645\n");
 				sd->sensor = SEN_OV7640; /* FIXME */
 				break;
 			case 0x45:
-				PDEBUG(D_PROBE, "Sensor is an OV7645B");
+				gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV7645B\n");
 				sd->sensor = SEN_OV7640; /* FIXME */
 				break;
 			case 0x48:
-				PDEBUG(D_PROBE, "Sensor is an OV7648");
+				gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV7648\n");
 				sd->sensor = SEN_OV7648;
 				break;
 			case 0x60:
-				PDEBUG(D_PROBE, "Sensor is a OV7660");
+				gspca_dbg(gspca_dev, D_PROBE, "Sensor is a OV7660\n");
 				sd->sensor = SEN_OV7660;
 				break;
 			default:
@@ -2759,7 +2762,7 @@ static void ov7xx0_configure(struct sd *sd)
 				return;
 			}
 		} else {
-			PDEBUG(D_PROBE, "Sensor is an OV7620");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV7620\n");
 			sd->sensor = SEN_OV7620;
 		}
 	} else {
@@ -2774,7 +2777,7 @@ static void ov6xx0_configure(struct sd *sd)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 	int rc;
 
-	PDEBUG(D_PROBE, "starting OV6xx0 configuration");
+	gspca_dbg(gspca_dev, D_PROBE, "starting OV6xx0 configuration\n");
 
 	/* Detect sensor (sub)type */
 	rc = i2c_r(sd, OV7610_REG_COM_I);
@@ -2793,15 +2796,15 @@ static void ov6xx0_configure(struct sd *sd)
 		break;
 	case 0x01:
 		sd->sensor = SEN_OV6620;
-		PDEBUG(D_PROBE, "Sensor is an OV6620");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV6620\n");
 		break;
 	case 0x02:
 		sd->sensor = SEN_OV6630;
-		PDEBUG(D_PROBE, "Sensor is an OV66308AE");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV66308AE\n");
 		break;
 	case 0x03:
 		sd->sensor = SEN_OV66308AF;
-		PDEBUG(D_PROBE, "Sensor is an OV66308AF");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor is an OV66308AF\n");
 		break;
 	case 0x90:
 		sd->sensor = SEN_OV6630;
@@ -2911,7 +2914,7 @@ static void ov51x_upload_quan_tables(struct sd *sd)
 	unsigned char val0, val1;
 	int i, size, reg = R51x_COMP_LUT_BEGIN;
 
-	PDEBUG(D_PROBE, "Uploading quantization tables");
+	gspca_dbg(gspca_dev, D_PROBE, "Uploading quantization tables\n");
 
 	if (sd->bridge == BRIDGE_OV511 || sd->bridge == BRIDGE_OV511PLUS) {
 		pYTable = yQuanTable511;
@@ -2989,7 +2992,8 @@ static void ov511_configure(struct gspca_dev *gspca_dev)
 		{ 0x77, 0x04 },
 	};
 
-	PDEBUG(D_PROBE, "Device custom id %x", reg_r(sd, R51x_SYS_CUST_ID));
+	gspca_dbg(gspca_dev, D_PROBE, "Device custom id %x\n",
+		  reg_r(sd, R51x_SYS_CUST_ID));
 
 	write_regvals(sd, init_511, ARRAY_SIZE(init_511));
 
@@ -3059,7 +3063,7 @@ static void ov518_configure(struct gspca_dev *gspca_dev)
 
 	/* First 5 bits of custom ID reg are a revision ID on OV518 */
 	sd->revision = reg_r(sd, R51x_SYS_CUST_ID) & 0x1f;
-	PDEBUG(D_PROBE, "Device revision %d", sd->revision);
+	gspca_dbg(gspca_dev, D_PROBE, "Device revision %d\n", sd->revision);
 
 	write_regvals(sd, init_518, ARRAY_SIZE(init_518));
 
@@ -3866,8 +3870,8 @@ static void ov519_mode_init_regs(struct sd *sd)
 		}
 		break;
 	case SEN_OV7670:		/* guesses, based on 7640 */
-		PDEBUG(D_STREAM, "Setting framerate to %d fps",
-				 (sd->frame_rate == 0) ? 15 : sd->frame_rate);
+		gspca_dbg(gspca_dev, D_STREAM, "Setting framerate to %d fps\n",
+			  (sd->frame_rate == 0) ? 15 : sd->frame_rate);
 		reg_w(sd, 0xa4, 0x10);
 		switch (sd->frame_rate) {
 		case 30:
diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index bba2c5ce331c..f293921a1f2b 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -612,7 +612,7 @@ static void ov534_reg_write(struct gspca_dev *gspca_dev, u16 reg, u8 val)
 	if (gspca_dev->usb_err < 0)
 		return;
 
-	PDEBUG(D_USBO, "SET 01 0000 %04x %02x", reg, val);
+	gspca_dbg(gspca_dev, D_USBO, "SET 01 0000 %04x %02x\n", reg, val);
 	gspca_dev->usb_buf[0] = val;
 	ret = usb_control_msg(udev,
 			      usb_sndctrlpipe(udev, 0),
@@ -637,7 +637,8 @@ static u8 ov534_reg_read(struct gspca_dev *gspca_dev, u16 reg)
 			      0x01,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x00, reg, gspca_dev->usb_buf, 1, CTRL_TIMEOUT);
-	PDEBUG(D_USBI, "GET 01 0000 %04x %02x", reg, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "GET 01 0000 %04x %02x\n",
+		  reg, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
 		pr_err("read failed %d\n", ret);
 		gspca_dev->usb_err = ret;
@@ -651,7 +652,7 @@ static void ov534_set_led(struct gspca_dev *gspca_dev, int status)
 {
 	u8 data;
 
-	PDEBUG(D_CONF, "led status: %d", status);
+	gspca_dbg(gspca_dev, D_CONF, "led status: %d\n", status);
 
 	data = ov534_reg_read(gspca_dev, 0x21);
 	data |= 0x80;
@@ -698,7 +699,7 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
 
 static void sccb_reg_write(struct gspca_dev *gspca_dev, u8 reg, u8 val)
 {
-	PDEBUG(D_USBO, "sccb write: %02x %02x", reg, val);
+	gspca_dbg(gspca_dev, D_USBO, "sccb write: %02x %02x\n", reg, val);
 	ov534_reg_write(gspca_dev, OV534_REG_SUBADDR, reg);
 	ov534_reg_write(gspca_dev, OV534_REG_WRITE, val);
 	ov534_reg_write(gspca_dev, OV534_REG_OPERATION, OV534_OP_WRITE_3);
@@ -800,7 +801,7 @@ static void set_frame_rate(struct gspca_dev *gspca_dev)
 	sccb_reg_write(gspca_dev, 0x0d, r->r0d);
 	ov534_reg_write(gspca_dev, 0xe5, r->re5);
 
-	PDEBUG(D_PROBE, "frame_rate: %d", r->fps);
+	gspca_dbg(gspca_dev, D_PROBE, "frame_rate: %d\n", r->fps);
 }
 
 static void sethue(struct gspca_dev *gspca_dev, s32 val)
@@ -1283,7 +1284,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	sensor_id = sccb_reg_read(gspca_dev, 0x0a) << 8;
 	sccb_reg_read(gspca_dev, 0x0b);
 	sensor_id |= sccb_reg_read(gspca_dev, 0x0b);
-	PDEBUG(D_PROBE, "Sensor ID: %04x", sensor_id);
+	gspca_dbg(gspca_dev, D_PROBE, "Sensor ID: %04x\n", sensor_id);
 
 	if ((sensor_id & 0xfff0) == 0x7670) {
 		sd->sensor = SENSOR_OV767x;
@@ -1407,19 +1408,19 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 
 		/* Verify UVC header.  Header length is always 12 */
 		if (data[0] != 12 || len < 12) {
-			PDEBUG(D_PACK, "bad header");
+			gspca_dbg(gspca_dev, D_PACK, "bad header\n");
 			goto discard;
 		}
 
 		/* Check errors */
 		if (data[1] & UVC_STREAM_ERR) {
-			PDEBUG(D_PACK, "payload error");
+			gspca_dbg(gspca_dev, D_PACK, "payload error\n");
 			goto discard;
 		}
 
 		/* Extract PTS and FID */
 		if (!(data[1] & UVC_STREAM_PTS)) {
-			PDEBUG(D_PACK, "PTS not present");
+			gspca_dbg(gspca_dev, D_PACK, "PTS not present\n");
 			goto discard;
 		}
 		this_pts = (data[5] << 24) | (data[4] << 16)
@@ -1442,7 +1443,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			 && gspca_dev->image_len + len - 12 !=
 				   gspca_dev->pixfmt.width *
 					gspca_dev->pixfmt.height * 2) {
-				PDEBUG(D_PACK, "wrong sized frame");
+				gspca_dbg(gspca_dev, D_PACK, "wrong sized frame\n");
 				goto discard;
 			}
 			gspca_frame_add(gspca_dev, LAST_PACKET,
diff --git a/drivers/media/usb/gspca/ov534_9.c b/drivers/media/usb/gspca/ov534_9.c
index b2a92e518118..3d1364d2f83e 100644
--- a/drivers/media/usb/gspca/ov534_9.c
+++ b/drivers/media/usb/gspca/ov534_9.c
@@ -1133,7 +1133,7 @@ static void reg_w_i(struct gspca_dev *gspca_dev, u16 reg, u8 val)
 
 static void reg_w(struct gspca_dev *gspca_dev, u16 reg, u8 val)
 {
-	PDEBUG(D_USBO, "reg_w [%04x] = %02x", reg, val);
+	gspca_dbg(gspca_dev, D_USBO, "reg_w [%04x] = %02x\n", reg, val);
 	reg_w_i(gspca_dev, reg, val);
 }
 
@@ -1149,7 +1149,8 @@ static u8 reg_r(struct gspca_dev *gspca_dev, u16 reg)
 			      0x01,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x00, reg, gspca_dev->usb_buf, 1, CTRL_TIMEOUT);
-	PDEBUG(D_USBI, "reg_r [%04x] -> %02x", reg, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "reg_r [%04x] -> %02x\n",
+		  reg, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
@@ -1174,9 +1175,9 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
 		case 0x03:
 			break;
 		default:
-			PDEBUG(D_USBI|D_USBO,
-				"sccb status 0x%02x, attempt %d/5",
-				data, i + 1);
+			gspca_dbg(gspca_dev, D_USBI|D_USBO,
+				  "sccb status 0x%02x, attempt %d/5\n",
+				  data, i + 1);
 		}
 	}
 	return 0;
@@ -1184,7 +1185,7 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
 
 static void sccb_write(struct gspca_dev *gspca_dev, u8 reg, u8 val)
 {
-	PDEBUG(D_USBO, "sccb_write [%02x] = %02x", reg, val);
+	gspca_dbg(gspca_dev, D_USBO, "sccb_write [%02x] = %02x\n", reg, val);
 	reg_w_i(gspca_dev, OV534_REG_SUBADDR, reg);
 	reg_w_i(gspca_dev, OV534_REG_WRITE, val);
 	reg_w_i(gspca_dev, OV534_REG_OPERATION, OV534_OP_WRITE_3);
@@ -1238,7 +1239,7 @@ static void set_led(struct gspca_dev *gspca_dev, int status)
 {
 	u8 data;
 
-	PDEBUG(D_CONF, "led status: %d", status);
+	gspca_dbg(gspca_dev, D_CONF, "led status: %d\n", status);
 
 	data = reg_r(gspca_dev, 0x21);
 	data |= 0x80;
@@ -1423,7 +1424,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	sensor_id = sccb_read(gspca_dev, 0x0a) << 8;
 	sccb_read(gspca_dev, 0x0b);
 	sensor_id |= sccb_read(gspca_dev, 0x0b);
-	PDEBUG(D_PROBE, "Sensor ID: %04x", sensor_id);
+	gspca_dbg(gspca_dev, D_PROBE, "Sensor ID: %04x\n", sensor_id);
 
 	/* initialize */
 	if ((sensor_id & 0xfff0) == 0x9650) {
@@ -1651,19 +1652,19 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 
 		/* Verify UVC header.  Header length is always 12 */
 		if (data[0] != 12 || len < 12) {
-			PDEBUG(D_PACK, "bad header");
+			gspca_dbg(gspca_dev, D_PACK, "bad header\n");
 			goto discard;
 		}
 
 		/* Check errors */
 		if (data[1] & UVC_STREAM_ERR) {
-			PDEBUG(D_PACK, "payload error");
+			gspca_dbg(gspca_dev, D_PACK, "payload error\n");
 			goto discard;
 		}
 
 		/* Extract PTS and FID */
 		if (!(data[1] & UVC_STREAM_PTS)) {
-			PDEBUG(D_PACK, "PTS not present");
+			gspca_dbg(gspca_dev, D_PACK, "PTS not present\n");
 			goto discard;
 		}
 		this_pts = (data[5] << 24) | (data[4] << 16)
diff --git a/drivers/media/usb/gspca/pac207.c b/drivers/media/usb/gspca/pac207.c
index 01c185d367e5..a1df7af8fef5 100644
--- a/drivers/media/usb/gspca/pac207.c
+++ b/drivers/media/usb/gspca/pac207.c
@@ -166,17 +166,17 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	idreg[1] = pac207_read_reg(gspca_dev, 0x0001);
 	idreg[0] = ((idreg[0] & 0x0f) << 4) | ((idreg[1] & 0xf0) >> 4);
 	idreg[1] = idreg[1] & 0x0f;
-	PDEBUG(D_PROBE, "Pixart Sensor ID 0x%02X Chips ID 0x%02X",
-		idreg[0], idreg[1]);
+	gspca_dbg(gspca_dev, D_PROBE, "Pixart Sensor ID 0x%02X Chips ID 0x%02X\n",
+		  idreg[0], idreg[1]);
 
 	if (idreg[0] != 0x27) {
-		PDEBUG(D_PROBE, "Error invalid sensor ID!");
+		gspca_dbg(gspca_dev, D_PROBE, "Error invalid sensor ID!\n");
 		return -ENODEV;
 	}
 
-	PDEBUG(D_PROBE,
-		"Pixart PAC207BCA Image Processor and Control Chip detected (vid/pid 0x%04X:0x%04X)",
-		id->idVendor, id->idProduct);
+	gspca_dbg(gspca_dev, D_PROBE,
+		  "Pixart PAC207BCA Image Processor and Control Chip detected (vid/pid 0x%04X:0x%04X)\n",
+		  id->idVendor, id->idProduct);
 
 	cam = &gspca_dev->cam;
 	cam->cam_mode = sif_mode;
@@ -315,9 +315,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		mode = 0x02;
 	if (gspca_dev->pixfmt.width == 176) {	/* 176x144 */
 		mode |= 0x01;
-		PDEBUG(D_STREAM, "pac207_start mode 176x144");
+		gspca_dbg(gspca_dev, D_STREAM, "pac207_start mode 176x144\n");
 	} else {				/* 352x288 */
-		PDEBUG(D_STREAM, "pac207_start mode 352x288");
+		gspca_dbg(gspca_dev, D_STREAM, "pac207_start mode 352x288\n");
 	}
 	pac207_write_reg(gspca_dev, 0x41, mode);
 
diff --git a/drivers/media/usb/gspca/pac_common.h b/drivers/media/usb/gspca/pac_common.h
index 4047bcb6c2b5..31f2a42af4dd 100644
--- a/drivers/media/usb/gspca/pac_common.h
+++ b/drivers/media/usb/gspca/pac_common.h
@@ -107,10 +107,9 @@ static unsigned char *pac_find_sof(struct gspca_dev *gspca_dev, u8 *sof_read,
 			switch (m[i]) {
 			case 0x96:
 				/* Pattern found */
-				PDEBUG(D_FRAM,
-					"SOF found, bytes to analyze: %u."
-					" Frame starts at byte #%u",
-					len, i + 1);
+				gspca_dbg(gspca_dev, D_FRAM,
+					  "SOF found, bytes to analyze: %u - Frame starts at byte #%u\n",
+					  len, i + 1);
 				*sof_read = 0;
 				return m + i + 1;
 				break;
diff --git a/drivers/media/usb/gspca/sn9c2028.c b/drivers/media/usb/gspca/sn9c2028.c
index 469bc2ced1a3..a1f7189545e1 100644
--- a/drivers/media/usb/gspca/sn9c2028.c
+++ b/drivers/media/usb/gspca/sn9c2028.c
@@ -69,8 +69,9 @@ static int sn9c2028_command(struct gspca_dev *gspca_dev, u8 *command)
 {
 	int rc;
 
-	PDEBUG(D_USBO, "sending command %02x%02x%02x%02x%02x%02x", command[0],
-	       command[1], command[2], command[3], command[4], command[5]);
+	gspca_dbg(gspca_dev, D_USBO, "sending command %02x%02x%02x%02x%02x%02x\n",
+		  command[0], command[1], command[2],
+		  command[3], command[4], command[5]);
 
 	memcpy(gspca_dev->usb_buf, command, 6);
 	rc = usb_control_msg(gspca_dev->dev,
@@ -100,7 +101,8 @@ static int sn9c2028_read1(struct gspca_dev *gspca_dev)
 		pr_err("read1 error %d\n", rc);
 		return (rc < 0) ? rc : -EIO;
 	}
-	PDEBUG(D_USBI, "read1 response %02x", gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "read1 response %02x\n",
+		  gspca_dev->usb_buf[0]);
 	return gspca_dev->usb_buf[0];
 }
 
@@ -117,8 +119,8 @@ static int sn9c2028_read4(struct gspca_dev *gspca_dev, u8 *reading)
 		return (rc < 0) ? rc : -EIO;
 	}
 	memcpy(reading, gspca_dev->usb_buf, 4);
-	PDEBUG(D_USBI, "read4 response %02x%02x%02x%02x", reading[0],
-	       reading[1], reading[2], reading[3]);
+	gspca_dbg(gspca_dev, D_USBI, "read4 response %02x%02x%02x%02x\n",
+		  reading[0], reading[1], reading[2], reading[3]);
 	return rc;
 }
 
@@ -175,32 +177,32 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct cam *cam = &gspca_dev->cam;
 
-	PDEBUG(D_PROBE, "SN9C2028 camera detected (vid/pid 0x%04X:0x%04X)",
-	       id->idVendor, id->idProduct);
+	gspca_dbg(gspca_dev, D_PROBE, "SN9C2028 camera detected (vid/pid 0x%04X:0x%04X)\n",
+		  id->idVendor, id->idProduct);
 
 	sd->model = id->idProduct;
 
 	switch (sd->model) {
 	case 0x7005:
-		PDEBUG(D_PROBE, "Genius Smart 300 camera");
+		gspca_dbg(gspca_dev, D_PROBE, "Genius Smart 300 camera\n");
 		break;
 	case 0x7003:
-		PDEBUG(D_PROBE, "Genius Videocam Live v2");
+		gspca_dbg(gspca_dev, D_PROBE, "Genius Videocam Live v2\n");
 		break;
 	case 0x8000:
-		PDEBUG(D_PROBE, "DC31VC");
+		gspca_dbg(gspca_dev, D_PROBE, "DC31VC\n");
 		break;
 	case 0x8001:
-		PDEBUG(D_PROBE, "Spy camera");
+		gspca_dbg(gspca_dev, D_PROBE, "Spy camera\n");
 		break;
 	case 0x8003:
-		PDEBUG(D_PROBE, "CIF camera");
+		gspca_dbg(gspca_dev, D_PROBE, "CIF camera\n");
 		break;
 	case 0x8008:
-		PDEBUG(D_PROBE, "Mini-Shotz ms-350 camera");
+		gspca_dbg(gspca_dev, D_PROBE, "Mini-Shotz ms-350 camera\n");
 		break;
 	case 0x800a:
-		PDEBUG(D_PROBE, "Vivitar 3350b type camera");
+		gspca_dbg(gspca_dev, D_PROBE, "Vivitar 3350b type camera\n");
 		cam->input_flags = V4L2_IN_ST_VFLIP | V4L2_IN_ST_HFLIP;
 		break;
 	}
diff --git a/drivers/media/usb/gspca/sn9c2028.h b/drivers/media/usb/gspca/sn9c2028.h
index 85761aa7c8b2..29f1571f9242 100644
--- a/drivers/media/usb/gspca/sn9c2028.h
+++ b/drivers/media/usb/gspca/sn9c2028.h
@@ -43,10 +43,9 @@ static unsigned char *sn9c2028_find_sof(struct gspca_dev *gspca_dev,
 			if (sd->sof_read == 12)
 				sd->avg_lum = (m[i] << 8) + sd->avg_lum_l;
 			if (sd->sof_read == sizeof(sn9c2028_sof_marker)) {
-				PDEBUG(D_FRAM,
-					"SOF found, bytes to analyze: %u."
-					" Frame starts at byte #%u",
-					len, i + 1);
+				gspca_dbg(gspca_dev, D_FRAM,
+					  "SOF found, bytes to analyze: %u - Frame starts at byte #%u\n",
+					  len, i + 1);
 				sd->sof_read = 0;
 				return m + i + 1;
 			}
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index c605f78d6186..cfa2a04d9f3f 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -2153,7 +2153,7 @@ static void qual_upd(struct work_struct *work)
 
 	/* To protect gspca_dev->usb_buf and gspca_dev->usb_err */
 	mutex_lock(&gspca_dev->usb_lock);
-	PDEBUG(D_STREAM, "qual_upd %d%%", qual);
+	gspca_dbg(gspca_dev, D_STREAM, "qual_upd %d%%\n", qual);
 	gspca_dev->usb_err = 0;
 	set_quality(gspca_dev, qual);
 	mutex_unlock(&gspca_dev->usb_lock);
diff --git a/drivers/media/usb/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
index 9d7c3d8c226f..df8d8482b795 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -1166,7 +1166,8 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			value, 0,
 			gspca_dev->usb_buf, len,
 			500);
-	PDEBUG(D_USBI, "reg_r [%02x] -> %02x", value, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "reg_r [%02x] -> %02x\n",
+		  value, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
@@ -1181,7 +1182,7 @@ static void reg_w1(struct gspca_dev *gspca_dev,
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "reg_w1 [%04x] = %02x", value, data);
+	gspca_dbg(gspca_dev, D_USBO, "reg_w1 [%04x] = %02x\n", value, data);
 	gspca_dev->usb_buf[0] = data;
 	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
@@ -1205,8 +1206,8 @@ static void reg_w(struct gspca_dev *gspca_dev,
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "reg_w [%04x] = %02x %02x ..",
-		value, buffer[0], buffer[1]);
+	gspca_dbg(gspca_dev, D_USBO, "reg_w [%04x] = %02x %02x ..\n",
+		  value, buffer[0], buffer[1]);
 
 	if (len > USB_BUF_SZ) {
 		gspca_err(gspca_dev, "reg_w: buffer overflow\n");
@@ -1235,7 +1236,7 @@ static void i2c_w1(struct gspca_dev *gspca_dev, u8 reg, u8 val)
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "i2c_w1 [%02x] = %02x", reg, val);
+	gspca_dbg(gspca_dev, D_USBO, "i2c_w1 [%02x] = %02x\n", reg, val);
 	switch (sd->sensor) {
 	case SENSOR_ADCM1700:
 	case SENSOR_OM6802:
@@ -1276,8 +1277,8 @@ static void i2c_w8(struct gspca_dev *gspca_dev,
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "i2c_w8 [%02x] = %02x ..",
-		buffer[2], buffer[3]);
+	gspca_dbg(gspca_dev, D_USBO, "i2c_w8 [%02x] = %02x ..\n",
+		  buffer[2], buffer[3]);
 	memcpy(gspca_dev->usb_buf, buffer, 8);
 	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
@@ -1349,7 +1350,7 @@ static void hv7131r_probe(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_buf[0] == 0x02	/* chip ID (02 is R) */
 	    && gspca_dev->usb_buf[1] == 0x09
 	    && gspca_dev->usb_buf[2] == 0x01) {
-		PDEBUG(D_PROBE, "Sensor HV7131R found");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor HV7131R found\n");
 		return;
 	}
 	pr_warn("Erroneous HV7131R ID 0x%02x 0x%02x 0x%02x\n",
@@ -1396,18 +1397,19 @@ static void mi0360_probe(struct gspca_dev *gspca_dev)
 		return;
 	switch (val) {
 	case 0x8221:
-		PDEBUG(D_PROBE, "Sensor mi0360b");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor mi0360b\n");
 		sd->sensor = SENSOR_MI0360B;
 		break;
 	case 0x823a:
-		PDEBUG(D_PROBE, "Sensor mt9v111");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor mt9v111\n");
 		sd->sensor = SENSOR_MT9V111;
 		break;
 	case 0x8243:
-		PDEBUG(D_PROBE, "Sensor mi0360");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor mi0360\n");
 		break;
 	default:
-		PDEBUG(D_PROBE, "Unknown sensor %04x - forced to mi0360", val);
+		gspca_dbg(gspca_dev, D_PROBE, "Unknown sensor %04x - forced to mi0360\n",
+			  val);
 		break;
 	}
 }
@@ -1432,10 +1434,10 @@ static void ov7630_probe(struct gspca_dev *gspca_dev)
 /*fixme: only valid for 0c45:613e?*/
 		gspca_dev->cam.input_flags =
 				V4L2_IN_ST_VFLIP | V4L2_IN_ST_HFLIP;
-		PDEBUG(D_PROBE, "Sensor soi768");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor soi768\n");
 		return;
 	}
-	PDEBUG(D_PROBE, "Sensor ov%04x", val);
+	gspca_dbg(gspca_dev, D_PROBE, "Sensor ov%04x\n", val);
 }
 
 static void ov7648_probe(struct gspca_dev *gspca_dev)
@@ -1452,7 +1454,7 @@ static void ov7648_probe(struct gspca_dev *gspca_dev)
 	reg_w1(gspca_dev, 0x01, 0x29);
 	reg_w1(gspca_dev, 0x17, 0x42);
 	if ((val & 0xff00) == 0x7600) {		/* ov76xx */
-		PDEBUG(D_PROBE, "Sensor ov%04x", val);
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor ov%04x\n", val);
 		return;
 	}
 
@@ -1467,7 +1469,7 @@ static void ov7648_probe(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		return;
 	if (val == 0x1030) {			/* po1030 */
-		PDEBUG(D_PROBE, "Sensor po1030");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor po1030\n");
 		sd->sensor = SENSOR_PO1030;
 		return;
 	}
@@ -1490,7 +1492,7 @@ static void po2030n_probe(struct gspca_dev *gspca_dev)
 	reg_w1(gspca_dev, 0x01, 0x29);		/* reset */
 	reg_w1(gspca_dev, 0x17, 0x42);
 	if (val == 0x99) {			/* gc0307 (?) */
-		PDEBUG(D_PROBE, "Sensor gc0307");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor gc0307\n");
 		sd->sensor = SENSOR_GC0307;
 		return;
 	}
@@ -1506,7 +1508,7 @@ static void po2030n_probe(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		return;
 	if (val == 0x2030) {
-		PDEBUG(D_PROBE, "Sensor po2030n");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor po2030n\n");
 /*		sd->sensor = SENSOR_PO2030N; */
 	} else {
 		pr_err("Unknown sensor ID %04x\n", val);
@@ -1558,7 +1560,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	regF1 = gspca_dev->usb_buf[0];
 	if (gspca_dev->usb_err < 0)
 		return gspca_dev->usb_err;
-	PDEBUG(D_PROBE, "Sonix chip id: %02x", regF1);
+	gspca_dbg(gspca_dev, D_PROBE, "Sonix chip id: %02x\n", regF1);
 	if (gspca_dev->audio)
 		regGpio[1] |= 0x04;		/* with audio */
 	switch (sd->bridge) {
@@ -1758,10 +1760,10 @@ static u32 expo_adjust(struct gspca_dev *gspca_dev,
 				| ((expo & 0x0003) << 4);
 		i2c_w8(gspca_dev, expoMo10);
 		i2c_w8(gspca_dev, gainMo);
-		PDEBUG(D_FRAM, "set exposure %d",
-			((expoMo10[3] & 0x07) << 10)
-			| (expoMof[3] << 2)
-			| ((expoMo10[3] & 0x30) >> 4));
+		gspca_dbg(gspca_dev, D_FRAM, "set exposure %d\n",
+			  ((expoMo10[3] & 0x07) << 10)
+			  | (expoMof[3] << 2)
+			  | ((expoMo10[3] & 0x30) >> 4));
 		break;
 	    }
 	case SENSOR_MT9V111: {
@@ -1789,7 +1791,7 @@ static u32 expo_adjust(struct gspca_dev *gspca_dev,
 		gainOm[3] = expo >> 2;
 		i2c_w8(gspca_dev, gainOm);
 		reg_w1(gspca_dev, 0x96, expo >> 5);
-		PDEBUG(D_FRAM, "set exposure %d", gainOm[3]);
+		gspca_dbg(gspca_dev, D_FRAM, "set exposure %d\n", gainOm[3]);
 		break;
 	    }
 	}
@@ -2162,7 +2164,7 @@ static void qual_upd(struct work_struct *work)
 
 	/* To protect gspca_dev->usb_buf and gspca_dev->usb_err */
 	mutex_lock(&gspca_dev->usb_lock);
-	PDEBUG(D_STREAM, "qual_upd %d%%", sd->quality);
+	gspca_dbg(gspca_dev, D_STREAM, "qual_upd %d%%\n", sd->quality);
 	gspca_dev->usb_err = 0;
 	setjpegqual(gspca_dev);
 	mutex_unlock(&gspca_dev->usb_lock);
@@ -2584,7 +2586,7 @@ static void do_autogain(struct gspca_dev *gspca_dev)
 	sd->ag_cnt = AG_CNT_START;
 
 	delta = atomic_read(&sd->avg_lum);
-	PDEBUG(D_FRAM, "mean lum %d", delta);
+	gspca_dbg(gspca_dev, D_FRAM, "mean lum %d\n", delta);
 
 	if (sd->sensor == SENSOR_PO2030N) {
 		gspca_expo_autogain(gspca_dev, delta, luma_mean, luma_delta,
diff --git a/drivers/media/usb/gspca/spca1528.c b/drivers/media/usb/gspca/spca1528.c
index e53dd3c7066c..d25924e430f3 100644
--- a/drivers/media/usb/gspca/spca1528.c
+++ b/drivers/media/usb/gspca/spca1528.c
@@ -75,8 +75,8 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			index,
 			gspca_dev->usb_buf, len,
 			500);
-	PDEBUG(D_USBI, "GET %02x 0000 %04x %02x", req, index,
-			 gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "GET %02x 0000 %04x %02x\n", req, index,
+		  gspca_dev->usb_buf[0]);
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
@@ -93,7 +93,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "SET %02x %04x %04x", req, value, index);
+	gspca_dbg(gspca_dev, D_USBO, "SET %02x %04x %04x\n", req, value, index);
 	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 			req,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -116,7 +116,8 @@ static void reg_wb(struct gspca_dev *gspca_dev,
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "SET %02x %04x %04x %02x", req, value, index, byte);
+	gspca_dbg(gspca_dev, D_USBO, "SET %02x %04x %04x %02x\n",
+		  req, value, index, byte);
 	gspca_dev->usb_buf[0] = byte;
 	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 			req,
@@ -216,8 +217,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	reg_r(gspca_dev, 0x20, 0x0000, 1);
 	reg_r(gspca_dev, 0x20, 0x0000, 5);
 	reg_r(gspca_dev, 0x23, 0x0000, 64);
-	PDEBUG(D_PROBE, "%s%s", &gspca_dev->usb_buf[0x1c],
-				&gspca_dev->usb_buf[0x30]);
+	gspca_dbg(gspca_dev, D_PROBE, "%s%s\n", &gspca_dev->usb_buf[0x1c],
+		  &gspca_dev->usb_buf[0x30]);
 	reg_r(gspca_dev, 0x23, 0x0001, 64);
 	return gspca_dev->usb_err;
 }
diff --git a/drivers/media/usb/gspca/spca500.c b/drivers/media/usb/gspca/spca500.c
index b25960643f7b..e90d2f3b4a67 100644
--- a/drivers/media/usb/gspca/spca500.c
+++ b/drivers/media/usb/gspca/spca500.c
@@ -328,7 +328,8 @@ static int reg_w(struct gspca_dev *gspca_dev,
 {
 	int ret;
 
-	PDEBUG(D_USBO, "reg write: [0x%02x] = 0x%02x", index, value);
+	gspca_dbg(gspca_dev, D_USBO, "reg write: [0x%02x] = 0x%02x\n",
+		  index, value);
 	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			req,
@@ -423,15 +424,15 @@ static int spca50x_setup_qtable(struct gspca_dev *gspca_dev,
 static void spca500_ping310(struct gspca_dev *gspca_dev)
 {
 	reg_r(gspca_dev, 0x0d04, 2);
-	PDEBUG(D_STREAM, "ClickSmart310 ping 0x0d04 0x%02x 0x%02x",
-		gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
+	gspca_dbg(gspca_dev, D_STREAM, "ClickSmart310 ping 0x0d04 0x%02x 0x%02x\n",
+		  gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
 }
 
 static void spca500_clksmart310_init(struct gspca_dev *gspca_dev)
 {
 	reg_r(gspca_dev, 0x0d05, 2);
-	PDEBUG(D_STREAM, "ClickSmart310 init 0x0d05 0x%02x 0x%02x",
-		gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
+	gspca_dbg(gspca_dev, D_STREAM, "ClickSmart310 init 0x0d05 0x%02x 0x%02x\n",
+		  gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
 	reg_w(gspca_dev, 0x00, 0x8167, 0x5a);
 	spca500_ping310(gspca_dev);
 
@@ -509,7 +510,8 @@ static int spca500_synch310(struct gspca_dev *gspca_dev)
 	reg_r(gspca_dev, 0x0d00, 1);
 
 	/* need alt setting here */
-	PDEBUG(D_PACK, "ClickSmart310 sync alt: %d", gspca_dev->alt);
+	gspca_dbg(gspca_dev, D_PACK, "ClickSmart310 sync alt: %d\n",
+		  gspca_dev->alt);
 
 	/* Windoze use pipe with altsetting 6 why 7 here */
 	if (usb_set_interface(gspca_dev->dev,
@@ -587,12 +589,12 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	/* initialisation of spca500 based cameras is deferred */
-	PDEBUG(D_STREAM, "SPCA500 init");
+	gspca_dbg(gspca_dev, D_STREAM, "SPCA500 init\n");
 	if (sd->subtype == LogitechClickSmart310)
 		spca500_clksmart310_init(gspca_dev);
 /*	else
 		spca500_initialise(gspca_dev); */
-	PDEBUG(D_STREAM, "SPCA500 init done");
+	gspca_dbg(gspca_dev, D_STREAM, "SPCA500 init done\n");
 	return 0;
 }
 
@@ -619,10 +621,10 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* is there a sensor here ? */
 	reg_r(gspca_dev, 0x8a04, 1);
-	PDEBUG(D_STREAM, "Spca500 Sensor Address 0x%02x",
-		gspca_dev->usb_buf[0]);
-	PDEBUG(D_STREAM, "Spca500 curr_mode: %d Xmult: 0x%02x, Ymult: 0x%02x",
-		gspca_dev->curr_mode, xmult, ymult);
+	gspca_dbg(gspca_dev, D_STREAM, "Spca500 Sensor Address 0x%02x\n",
+		  gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_STREAM, "Spca500 curr_mode: %d Xmult: 0x%02x, Ymult: 0x%02x",
+		  gspca_dev->curr_mode, xmult, ymult);
 
 	/* setup qtable */
 	switch (sd->subtype) {
@@ -820,8 +822,8 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 	/* switch to video camera mode */
 	reg_w(gspca_dev, 0x00, 0x8000, 0x0004);
 	reg_r(gspca_dev, 0x8000, 1);
-	PDEBUG(D_STREAM, "stop SPCA500 done reg8000: 0x%2x",
-		gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_STREAM, "stop SPCA500 done reg8000: 0x%2x\n",
+		  gspca_dev->usb_buf[0]);
 }
 
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
diff --git a/drivers/media/usb/gspca/spca501.c b/drivers/media/usb/gspca/spca501.c
index 29861588302f..2cce74b166d8 100644
--- a/drivers/media/usb/gspca/spca501.c
+++ b/drivers/media/usb/gspca/spca501.c
@@ -1763,8 +1763,8 @@ static int reg_write(struct gspca_dev *gspca_dev,
 			req,
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			value, index, NULL, 0, 500);
-	PDEBUG(D_USBO, "reg write: 0x%02x 0x%02x 0x%02x",
-		req, index, value);
+	gspca_dbg(gspca_dev, D_USBO, "reg write: 0x%02x 0x%02x 0x%02x\n",
+		  req, index, value);
 	if (ret < 0)
 		pr_err("reg write: error %d\n", ret);
 	return ret;
@@ -1852,7 +1852,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			goto error;
 		break;
 	}
-	PDEBUG(D_STREAM, "Initializing SPCA501 finished");
+	gspca_dbg(gspca_dev, D_STREAM, "Initializing SPCA501 finished\n");
 	return 0;
 error:
 	return -EINVAL;
diff --git a/drivers/media/usb/gspca/spca505.c b/drivers/media/usb/gspca/spca505.c
index 02b5e2d81c64..07aae9cd5a30 100644
--- a/drivers/media/usb/gspca/spca505.c
+++ b/drivers/media/usb/gspca/spca505.c
@@ -551,8 +551,8 @@ static int reg_write(struct gspca_dev *gspca_dev,
 			req,
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			value, index, NULL, 0, 500);
-	PDEBUG(D_USBO, "reg write: 0x%02x,0x%02x:0x%02x, %d",
-		req, index, value, ret);
+	gspca_dbg(gspca_dev, D_USBO, "reg write: 0x%02x,0x%02x:0x%02x, %d\n",
+		  req, index, value, ret);
 	if (ret < 0)
 		pr_err("reg write: error %d\n", ret);
 	return ret;
diff --git a/drivers/media/usb/gspca/spca506.c b/drivers/media/usb/gspca/spca506.c
index 843c93f5acf3..6332b3f0b918 100644
--- a/drivers/media/usb/gspca/spca506.c
+++ b/drivers/media/usb/gspca/spca506.c
@@ -126,7 +126,7 @@ static void spca506_SetNormeInput(struct gspca_dev *gspca_dev,
 	__u8 setbit1 = 0x00;
 	__u8 videomask = 0x00;
 
-	PDEBUG(D_STREAM, "** Open Set Norme **");
+	gspca_dbg(gspca_dev, D_STREAM, "** Open Set Norme **\n");
 	spca506_Initi2c(gspca_dev);
 	/* NTSC bit0 -> 1(525 l) PAL SECAM bit0 -> 0 (625 l) */
 	/* Composite channel bit1 -> 1 S-video bit 1 -> 0 */
@@ -153,8 +153,9 @@ static void spca506_SetNormeInput(struct gspca_dev *gspca_dev,
 
 	sd->norme = norme;
 	sd->channel = channel;
-	PDEBUG(D_STREAM, "Set Video Byte to 0x%2x", videomask);
-	PDEBUG(D_STREAM, "Set Norme: %08x Channel %d", norme, channel);
+	gspca_dbg(gspca_dev, D_STREAM, "Set Video Byte to 0x%2x\n", videomask);
+	gspca_dbg(gspca_dev, D_STREAM, "Set Norme: %08x Channel %d",
+		  norme, channel);
 }
 
 static void spca506_GetNormeInput(struct gspca_dev *gspca_dev,
@@ -166,7 +167,8 @@ static void spca506_GetNormeInput(struct gspca_dev *gspca_dev,
 	   we use your own copy in spca50x struct */
 	*norme = sd->norme;
 	*channel = sd->channel;
-	PDEBUG(D_STREAM, "Get Norme: %d Channel %d", *norme, *channel);
+	gspca_dbg(gspca_dev, D_STREAM, "Get Norme: %d Channel %d\n",
+		  *norme, *channel);
 }
 
 static void spca506_Setsize(struct gspca_dev *gspca_dev, __u16 code,
@@ -174,7 +176,7 @@ static void spca506_Setsize(struct gspca_dev *gspca_dev, __u16 code,
 {
 	struct usb_device *dev = gspca_dev->dev;
 
-	PDEBUG(D_STREAM, "** SetSize **");
+	gspca_dbg(gspca_dev, D_STREAM, "** SetSize **\n");
 	reg_w(dev, 0x04, (0x18 | (code & 0x07)), 0x0000);
 	/* Soft snap 0x40 Hard 0x41 */
 	reg_w(dev, 0x04, 0x41, 0x0001);
@@ -317,7 +319,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	spca506_WriteI2c(gspca_dev, 0x00, 0x60);
 	spca506_WriteI2c(gspca_dev, 0x05, 0x61);
 	spca506_WriteI2c(gspca_dev, 0x9f, 0x62);
-	PDEBUG(D_STREAM, "** Close Init *");
+	gspca_dbg(gspca_dev, D_STREAM, "** Close Init *\n");
 	return 0;
 }
 
@@ -445,7 +447,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	reg_w(dev, 0x02, 0x01, 0x0000);
 	reg_w(dev, 0x03, 0x12, 0x0000);
 	reg_r(gspca_dev, 0x04, 0x0001, 2);
-	PDEBUG(D_STREAM, "webcam started");
+	gspca_dbg(gspca_dev, D_STREAM, "webcam started\n");
 	spca506_GetNormeInput(gspca_dev, &norme, &channel);
 	spca506_SetNormeInput(gspca_dev, norme, channel);
 	return 0;
diff --git a/drivers/media/usb/gspca/spca508.c b/drivers/media/usb/gspca/spca508.c
index aafffaf1d2b5..d80fd397eaf2 100644
--- a/drivers/media/usb/gspca/spca508.c
+++ b/drivers/media/usb/gspca/spca508.c
@@ -1247,8 +1247,8 @@ static int reg_write(struct gspca_dev *gspca_dev, u16 index, u16 value)
 			0,		/* request */
 			USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			value, index, NULL, 0, 500);
-	PDEBUG(D_USBO, "reg write i:0x%04x = 0x%02x",
-		index, value);
+	gspca_dbg(gspca_dev, D_USBO, "reg write i:0x%04x = 0x%02x\n",
+		  index, value);
 	if (ret < 0)
 		pr_err("reg write: error %d\n", ret);
 	return ret;
@@ -1269,8 +1269,8 @@ static int reg_read(struct gspca_dev *gspca_dev,
 			index,
 			gspca_dev->usb_buf, 1,
 			500);			/* timeout */
-	PDEBUG(D_USBI, "reg read i:%04x --> %02x",
-		index, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "reg read i:%04x --> %02x\n",
+		  index, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
 		pr_err("reg_read err %d\n", ret);
 		return ret;
@@ -1366,14 +1366,17 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	 * is a 508. */
 	data1 = reg_read(gspca_dev, 0x8104);
 	data2 = reg_read(gspca_dev, 0x8105);
-	PDEBUG(D_PROBE, "Webcam Vendor ID: 0x%02x%02x", data2, data1);
+	gspca_dbg(gspca_dev, D_PROBE, "Webcam Vendor ID: 0x%02x%02x\n",
+		  data2, data1);
 
 	data1 = reg_read(gspca_dev, 0x8106);
 	data2 = reg_read(gspca_dev, 0x8107);
-	PDEBUG(D_PROBE, "Webcam Product ID: 0x%02x%02x", data2, data1);
+	gspca_dbg(gspca_dev, D_PROBE, "Webcam Product ID: 0x%02x%02x\n",
+		  data2, data1);
 
 	data1 = reg_read(gspca_dev, 0x8621);
-	PDEBUG(D_PROBE, "Window 1 average luminance: %d", data1);
+	gspca_dbg(gspca_dev, D_PROBE, "Window 1 average luminance: %d\n",
+		  data1);
 
 	cam = &gspca_dev->cam;
 	cam->cam_mode = sif_mode;
diff --git a/drivers/media/usb/gspca/spca561.c b/drivers/media/usb/gspca/spca561.c
index a75bd90bd9e3..f389a8d0937d 100644
--- a/drivers/media/usb/gspca/spca561.c
+++ b/drivers/media/usb/gspca/spca561.c
@@ -290,7 +290,8 @@ static void reg_w_val(struct gspca_dev *gspca_dev, __u16 index, __u8 value)
 			      0,		/* request */
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      value, index, NULL, 0, 500);
-	PDEBUG(D_USBO, "reg write: 0x%02x:0x%02x", index, value);
+	gspca_dbg(gspca_dev, D_USBO, "reg write: 0x%02x:0x%02x\n",
+		  index, value);
 	if (ret < 0)
 		pr_err("reg write: error %d\n", ret);
 }
@@ -420,7 +421,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	data2 = gspca_dev->usb_buf[0];
 	product = (data2 << 8) | data1;
 	if (vendor != id->idVendor || product != id->idProduct) {
-		PDEBUG(D_PROBE, "Bad vendor / product from device");
+		gspca_dbg(gspca_dev, D_PROBE, "Bad vendor / product from device\n");
 		return -EINVAL;
 	}
 
@@ -442,13 +443,13 @@ static int sd_config(struct gspca_dev *gspca_dev,
 /* this function is called at probe and resume time */
 static int sd_init_12a(struct gspca_dev *gspca_dev)
 {
-	PDEBUG(D_STREAM, "Chip revision: 012a");
+	gspca_dbg(gspca_dev, D_STREAM, "Chip revision: 012a\n");
 	init_161rev12A(gspca_dev);
 	return 0;
 }
 static int sd_init_72a(struct gspca_dev *gspca_dev)
 {
-	PDEBUG(D_STREAM, "Chip revision: 072a");
+	gspca_dbg(gspca_dev, D_STREAM, "Chip revision: 072a\n");
 	write_vector(gspca_dev, rev72a_reset);
 	msleep(200);
 	write_vector(gspca_dev, rev72a_init_data1);
@@ -679,25 +680,16 @@ static void do_autogain(struct gspca_dev *gspca_dev)
 		y = (77 * R + 75 * (Gr + Gb) + 29 * B) >> 8;
 		/* u= (128*B-(43*(Gr+Gb+R))) >> 8; */
 		/* v= (128*R-(53*(Gr+Gb))-21*B) >> 8; */
-		/* PDEBUG(D_CONF,"reading Y %d U %d V %d ",y,u,v); */
 
 		if (y < luma_mean - luma_delta ||
 		    y > luma_mean + luma_delta) {
 			expotimes = i2c_read(gspca_dev, 0x09, 0x10);
 			pixelclk = 0x0800;
 			expotimes = expotimes & 0x07ff;
-			/* PDEBUG(D_PACK,
-				"Exposition Times 0x%03X Clock 0x%04X ",
-				expotimes,pixelclk); */
 			gainG = i2c_read(gspca_dev, 0x35, 0x10);
-			/* PDEBUG(D_PACK,
-				"reading Gain register %d", gainG); */
 
 			expotimes += (luma_mean - y) >> spring;
 			gainG += (luma_mean - y) / 50;
-			/* PDEBUG(D_PACK,
-				"compute expotimes %d gain %d",
-				expotimes,gainG); */
 
 			if (gainG > 0x3f)
 				gainG = 0x3f;
@@ -728,7 +720,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 
 		/* This should never happen */
 		if (len < 2) {
-			gspca_err(gspca_dev, "Short SOF packet, ignoring\n");
+			gspca_err(gspca_dev, "Short SOF packet, ignoring\n\n\n\n\n");
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			return;
 		}
diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index 948808305a6a..cc8ff41b8ab3 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -246,9 +246,9 @@ static void sq905_dostream(struct work_struct *work)
 			ret = sq905_read_data(gspca_dev, buffer, data_len, 1);
 			if (ret < 0)
 				goto quit_stream;
-			PDEBUG(D_PACK,
-				"Got %d bytes out of %d for frame",
-				data_len, bytes_left);
+			gspca_dbg(gspca_dev, D_PACK,
+				  "Got %d bytes out of %d for frame\n",
+				  data_len, bytes_left);
 			bytes_left -= data_len;
 			data = buffer;
 			if (!header_read) {
@@ -345,7 +345,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	ret = sq905_command(gspca_dev, SQ905_CLEAR);
 	if (ret < 0)
 		return ret;
-	PDEBUG(D_CONF, "SQ905 camera ID %08x detected", ident);
+	gspca_dbg(gspca_dev, D_CONF, "SQ905 camera ID %08x detected\n", ident);
 	gspca_dev->cam.cam_mode = sq905_mode;
 	gspca_dev->cam.nmodes = ARRAY_SIZE(sq905_mode);
 	if (!(ident & SQ905_HIRES_MASK))
@@ -369,15 +369,15 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	switch (gspca_dev->curr_mode) {
 	default:
 /*	case 2: */
-		PDEBUG(D_STREAM, "Start streaming at high resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at high resolution\n");
 		ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_HIGH);
 		break;
 	case 1:
-		PDEBUG(D_STREAM, "Start streaming at medium resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at medium resolution\n");
 		ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_MED);
 		break;
 	case 0:
-		PDEBUG(D_STREAM, "Start streaming at low resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at low resolution\n");
 		ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_LOW);
 	}
 
diff --git a/drivers/media/usb/gspca/sq905c.c b/drivers/media/usb/gspca/sq905c.c
index 4fbfcf366f71..5e1269eb7c50 100644
--- a/drivers/media/usb/gspca/sq905c.c
+++ b/drivers/media/usb/gspca/sq905c.c
@@ -154,15 +154,16 @@ static void sq905c_dostream(struct work_struct *work)
 				usb_rcvbulkpipe(gspca_dev->dev, 0x81),
 				buffer, FRAME_HEADER_LEN, &act_len,
 				SQ905C_DATA_TIMEOUT);
-		PDEBUG(D_STREAM,
-			"Got %d bytes out of %d for header",
-			act_len, FRAME_HEADER_LEN);
+		gspca_dbg(gspca_dev, D_STREAM,
+			  "Got %d bytes out of %d for header\n",
+			  act_len, FRAME_HEADER_LEN);
 		if (ret < 0 || act_len < FRAME_HEADER_LEN)
 			goto quit_stream;
 		/* size is read from 4 bytes starting 0x40, little endian */
 		bytes_left = buffer[0x40]|(buffer[0x41]<<8)|(buffer[0x42]<<16)
 					|(buffer[0x43]<<24);
-		PDEBUG(D_STREAM, "bytes_left = 0x%x", bytes_left);
+		gspca_dbg(gspca_dev, D_STREAM, "bytes_left = 0x%x\n",
+			  bytes_left);
 		/* We keep the header. It has other information, too. */
 		packet_type = FIRST_PACKET;
 		gspca_frame_add(gspca_dev, packet_type,
@@ -176,9 +177,9 @@ static void sq905c_dostream(struct work_struct *work)
 				SQ905C_DATA_TIMEOUT);
 			if (ret < 0 || act_len < data_len)
 				goto quit_stream;
-			PDEBUG(D_STREAM,
-				"Got %d bytes out of %d for frame",
-				data_len, bytes_left);
+			gspca_dbg(gspca_dev, D_STREAM,
+				  "Got %d bytes out of %d for frame\n",
+				  data_len, bytes_left);
 			bytes_left -= data_len;
 			if (bytes_left == 0)
 				packet_type = LAST_PACKET;
@@ -205,9 +206,9 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct sd *dev = (struct sd *) gspca_dev;
 	int ret;
 
-	PDEBUG(D_PROBE,
-	       "SQ9050 camera detected (vid/pid 0x%04X:0x%04X)",
-	       id->idVendor, id->idProduct);
+	gspca_dbg(gspca_dev, D_PROBE,
+		  "SQ9050 camera detected (vid/pid 0x%04X:0x%04X)\n",
+		  id->idVendor, id->idProduct);
 
 	ret = sq905c_command(gspca_dev, SQ905C_GET_ID, 0);
 	if (ret < 0) {
@@ -221,9 +222,9 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		return ret;
 	}
 	/* Note we leave out the usb id and the manufacturing date */
-	PDEBUG(D_PROBE,
-	       "SQ9050 ID string: %02x - %*ph",
-		gspca_dev->usb_buf[3], 6, gspca_dev->usb_buf + 14);
+	gspca_dbg(gspca_dev, D_PROBE,
+		  "SQ9050 ID string: %02x - %*ph\n",
+		  gspca_dev->usb_buf[3], 6, gspca_dev->usb_buf + 14);
 
 	cam->cam_mode = sq905c_mode;
 	cam->nmodes = 2;
@@ -267,13 +268,13 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* "Open the shutter" and set size, to start capture */
 	switch (gspca_dev->pixfmt.width) {
 	case 640:
-		PDEBUG(D_STREAM, "Start streaming at high resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at high resolution\n");
 		dev->cap_mode++;
 		ret = sq905c_command(gspca_dev, SQ905C_CAPTURE_HI,
 						SQ905C_CAPTURE_INDEX);
 		break;
 	default: /* 320 */
-	PDEBUG(D_STREAM, "Start streaming at medium resolution");
+		gspca_dbg(gspca_dev, D_STREAM, "Start streaming at medium resolution\n");
 		ret = sq905c_command(gspca_dev, SQ905C_CAPTURE_MED,
 						SQ905C_CAPTURE_INDEX);
 	}
diff --git a/drivers/media/usb/gspca/sq930x.c b/drivers/media/usb/gspca/sq930x.c
index af48bd6dbe8c..d7cbcf2b3947 100644
--- a/drivers/media/usb/gspca/sq930x.c
+++ b/drivers/media/usb/gspca/sq930x.c
@@ -443,7 +443,7 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "reg_w v: %04x i: %04x", value, index);
+	gspca_dbg(gspca_dev, D_USBO, "reg_w v: %04x i: %04x\n", value, index);
 	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x0c,			/* request */
@@ -464,8 +464,8 @@ static void reg_wb(struct gspca_dev *gspca_dev, u16 value, u16 index,
 
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "reg_wb v: %04x i: %04x %02x...%02x",
-			value, index, *data, data[len - 1]);
+	gspca_dbg(gspca_dev, D_USBO, "reg_wb v: %04x i: %04x %02x...%02x\n",
+		  value, index, *data, data[len - 1]);
 	memcpy(gspca_dev->usb_buf, data, len);
 	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
@@ -510,8 +510,8 @@ static void i2c_write(struct sd *sd,
 		*buf++ = cmd->val;
 	}
 
-	PDEBUG(D_USBO, "i2c_w v: %04x i: %04x %02x...%02x",
-			val, idx, gspca_dev->usb_buf[0], buf[-1]);
+	gspca_dbg(gspca_dev, D_USBO, "i2c_w v: %04x i: %04x %02x...%02x\n",
+		  val, idx, gspca_dev->usb_buf[0], buf[-1]);
 	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x0c,			/* request */
@@ -560,12 +560,12 @@ static void ucbus_write(struct gspca_dev *gspca_dev,
 			*buf++ = cmd->bw_data;
 		}
 		if (buf != gspca_dev->usb_buf)
-			PDEBUG(D_USBO, "ucbus v: %04x i: %04x %02x...%02x",
-					val, idx,
-					gspca_dev->usb_buf[0], buf[-1]);
+			gspca_dbg(gspca_dev, D_USBO, "ucbus v: %04x i: %04x %02x...%02x\n",
+				  val, idx,
+				  gspca_dev->usb_buf[0], buf[-1]);
 		else
-			PDEBUG(D_USBO, "ucbus v: %04x i: %04x",
-					val, idx);
+			gspca_dbg(gspca_dev, D_USBO, "ucbus v: %04x i: %04x\n",
+				  val, idx);
 		ret = usb_control_msg(gspca_dev->dev,
 				usb_sndctrlpipe(gspca_dev->dev, 0),
 				0x0c,			/* request */
@@ -691,7 +691,7 @@ static void mt9v111_init(struct gspca_dev *gspca_dev)
 			 || gspca_dev->usb_err != 0)
 				break;
 			if (--nwait < 0) {
-				PDEBUG(D_PROBE, "mt9v111_init timeout");
+				gspca_dbg(gspca_dev, D_PROBE, "mt9v111_init timeout\n");
 				gspca_dev->usb_err = -ETIME;
 				return;
 			}
@@ -857,7 +857,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
  * 6: c8 / c9 / ca / cf = mode webcam?, sensor? webcam?
  * 7: 00
  */
-	PDEBUG(D_PROBE, "info: %*ph", 8, gspca_dev->usb_buf);
+	gspca_dbg(gspca_dev, D_PROBE, "info: %*ph\n", 8, gspca_dev->usb_buf);
 
 	bridge_init(sd);
 
@@ -870,7 +870,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			cmos_probe(gspca_dev);
 	}
 	if (gspca_dev->usb_err >= 0) {
-		PDEBUG(D_PROBE, "Sensor %s", sensor_tb[sd->sensor].name);
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor %s\n",
+			  sensor_tb[sd->sensor].name);
 		global_init(sd, 1);
 	}
 	return gspca_dev->usb_err;
diff --git a/drivers/media/usb/gspca/stk014.c b/drivers/media/usb/gspca/stk014.c
index daf45db6c404..0d8f489ddef2 100644
--- a/drivers/media/usb/gspca/stk014.c
+++ b/drivers/media/usb/gspca/stk014.c
@@ -290,8 +290,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	set_par(gspca_dev, 0x01000000);
 	set_par(gspca_dev, 0x01000000);
 	if (gspca_dev->usb_err >= 0)
-		PDEBUG(D_STREAM, "camera started alt: 0x%02x",
-				gspca_dev->alt);
+		gspca_dbg(gspca_dev, D_STREAM, "camera started alt: 0x%02x\n",
+			  gspca_dev->alt);
 out:
 	return gspca_dev->usb_err;
 }
@@ -312,7 +312,7 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x0640, 0);
 	reg_w(gspca_dev, 0x0650, 0);
 	reg_w(gspca_dev, 0x0660, 0);
-	PDEBUG(D_STREAM, "camera stopped");
+	gspca_dbg(gspca_dev, D_STREAM, "camera stopped\n");
 }
 
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
diff --git a/drivers/media/usb/gspca/stk1135.c b/drivers/media/usb/gspca/stk1135.c
index 3ab5ec2ca4bd..6f52a480c2d8 100644
--- a/drivers/media/usb/gspca/stk1135.c
+++ b/drivers/media/usb/gspca/stk1135.c
@@ -67,7 +67,8 @@ static u8 reg_r(struct gspca_dev *gspca_dev, u16 index)
 			gspca_dev->usb_buf, 1,
 			500);
 
-	PDEBUG(D_USBI, "reg_r 0x%x=0x%02x", index, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_USBI, "reg_r 0x%x=0x%02x\n",
+		  index, gspca_dev->usb_buf[0]);
 	if (ret < 0) {
 		pr_err("reg_r 0x%x err %d\n", index, ret);
 		gspca_dev->usb_err = ret;
@@ -93,7 +94,7 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 index, u8 val)
 			NULL,
 			0,
 			500);
-	PDEBUG(D_USBO, "reg_w 0x%x:=0x%02x", index, val);
+	gspca_dbg(gspca_dev, D_USBO, "reg_w 0x%x:=0x%02x\n", index, val);
 	if (ret < 0) {
 		pr_err("reg_w 0x%x err %d\n", index, ret);
 		gspca_dev->usb_err = ret;
@@ -468,8 +469,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	reg_w_mask(gspca_dev, STK1135_REG_SCTRL, 0x80, 0x80);
 
 	if (gspca_dev->usb_err >= 0)
-		PDEBUG(D_STREAM, "camera started alt: 0x%02x",
-				gspca_dev->alt);
+		gspca_dbg(gspca_dev, D_STREAM, "camera started alt: 0x%02x\n",
+			  gspca_dev->alt);
 
 	sd->pkt_seq = 0;
 
@@ -484,7 +485,7 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 
 	stk1135_camera_disable(gspca_dev);
 
-	PDEBUG(D_STREAM, "camera stopped");
+	gspca_dbg(gspca_dev, D_STREAM, "camera stopped\n");
 }
 
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
@@ -499,7 +500,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	u8 seq;
 
 	if (len < 4) {
-		PDEBUG(D_PACK, "received short packet (less than 4 bytes)");
+		gspca_dbg(gspca_dev, D_PACK, "received short packet (less than 4 bytes)\n");
 		return;
 	}
 
@@ -515,7 +516,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	if (!(hdr->flags & STK1135_HDR_FRAME_START)) {
 		seq = hdr->seq & STK1135_HDR_SEQ_MASK;
 		if (seq != sd->pkt_seq) {
-			PDEBUG(D_PACK, "received out-of-sequence packet");
+			gspca_dbg(gspca_dev, D_PACK, "received out-of-sequence packet\n");
 			/* resync sequence and discard packet */
 			sd->pkt_seq = seq;
 			gspca_dev->last_packet_type = DISCARD_PACKET;
diff --git a/drivers/media/usb/gspca/stv0680.c b/drivers/media/usb/gspca/stv0680.c
index 4ff6ae18d8dd..3ff5ed74bd9f 100644
--- a/drivers/media/usb/gspca/stv0680.c
+++ b/drivers/media/usb/gspca/stv0680.c
@@ -167,13 +167,13 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		return -ENODEV;
 	}
 	if (gspca_dev->usb_buf[7] & 0x01)
-		PDEBUG(D_PROBE, "Camera supports CIF mode");
+		gspca_dbg(gspca_dev, D_PROBE, "Camera supports CIF mode\n");
 	if (gspca_dev->usb_buf[7] & 0x02)
-		PDEBUG(D_PROBE, "Camera supports VGA mode");
+		gspca_dbg(gspca_dev, D_PROBE, "Camera supports VGA mode\n");
 	if (gspca_dev->usb_buf[7] & 0x04)
-		PDEBUG(D_PROBE, "Camera supports QCIF mode");
+		gspca_dbg(gspca_dev, D_PROBE, "Camera supports QCIF mode\n");
 	if (gspca_dev->usb_buf[7] & 0x08)
-		PDEBUG(D_PROBE, "Camera supports QVGA mode");
+		gspca_dbg(gspca_dev, D_PROBE, "Camera supports QVGA mode\n");
 
 	if (gspca_dev->usb_buf[7] & 0x01)
 		sd->video_mode = 0x00; /* CIF */
@@ -181,12 +181,12 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		sd->video_mode = 0x03; /* QVGA */
 
 	/* FW rev, ASIC rev, sensor ID  */
-	PDEBUG(D_PROBE, "Firmware rev is %i.%i",
-	       gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
-	PDEBUG(D_PROBE, "ASIC rev is %i.%i",
-	       gspca_dev->usb_buf[2], gspca_dev->usb_buf[3]);
-	PDEBUG(D_PROBE, "Sensor ID is %i",
-	       (gspca_dev->usb_buf[4]*16) + (gspca_dev->usb_buf[5]>>4));
+	gspca_dbg(gspca_dev, D_PROBE, "Firmware rev is %i.%i\n",
+		  gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
+	gspca_dbg(gspca_dev, D_PROBE, "ASIC rev is %i.%i",
+		  gspca_dev->usb_buf[2], gspca_dev->usb_buf[3]);
+	gspca_dbg(gspca_dev, D_PROBE, "Sensor ID is %i",
+		  (gspca_dev->usb_buf[4]*16) + (gspca_dev->usb_buf[5]>>4));
 
 
 	ret = stv0680_get_video_mode(gspca_dev);
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index 3db1c24b3d6d..2715218fe436 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -51,8 +51,8 @@ int stv06xx_write_bridge(struct sd *sd, u16 address, u16 i2c_data)
 			      0x04, 0x40, address, 0, buf, len,
 			      STV06XX_URB_MSG_TIMEOUT);
 
-	PDEBUG(D_CONF, "Written 0x%x to address 0x%x, status: %d",
-	       i2c_data, address, err);
+	gspca_dbg(gspca_dev, D_CONF, "Written 0x%x to address 0x%x, status: %d\n",
+		  i2c_data, address, err);
 
 	return (err < 0) ? err : 0;
 }
@@ -70,8 +70,8 @@ int stv06xx_read_bridge(struct sd *sd, u16 address, u8 *i2c_data)
 
 	*i2c_data = buf[0];
 
-	PDEBUG(D_CONF, "Reading 0x%x from address 0x%x, status %d",
-	       *i2c_data, address, err);
+	gspca_dbg(gspca_dev, D_CONF, "Reading 0x%x from address 0x%x, status %d\n",
+		  *i2c_data, address, err);
 
 	return (err < 0) ? err : 0;
 }
@@ -113,15 +113,16 @@ int stv06xx_write_sensor_bytes(struct sd *sd, const u8 *data, u8 len)
 	struct usb_device *udev = sd->gspca_dev.dev;
 	__u8 *buf = sd->gspca_dev.usb_buf;
 
-	PDEBUG(D_CONF, "I2C: Command buffer contains %d entries", len);
+	gspca_dbg(gspca_dev, D_CONF, "I2C: Command buffer contains %d entries\n",
+		  len);
 	for (i = 0; i < len;) {
 		/* Build the command buffer */
 		memset(buf, 0, I2C_BUFFER_LENGTH);
 		for (j = 0; j < I2C_MAX_BYTES && i < len; j++, i++) {
 			buf[j] = data[2*i];
 			buf[0x10 + j] = data[2*i+1];
-			PDEBUG(D_CONF, "I2C: Writing 0x%02x to reg 0x%02x",
-			data[2*i+1], data[2*i]);
+			gspca_dbg(gspca_dev, D_CONF, "I2C: Writing 0x%02x to reg 0x%02x\n",
+				  data[2*i+1], data[2*i]);
 		}
 		buf[0x20] = sd->sensor->i2c_addr;
 		buf[0x21] = j - 1; /* Number of commands to send - 1 */
@@ -143,7 +144,8 @@ int stv06xx_write_sensor_words(struct sd *sd, const u16 *data, u8 len)
 	struct usb_device *udev = sd->gspca_dev.dev;
 	__u8 *buf = sd->gspca_dev.usb_buf;
 
-	PDEBUG(D_CONF, "I2C: Command buffer contains %d entries", len);
+	gspca_dbg(gspca_dev, D_CONF, "I2C: Command buffer contains %d entries\n",
+		  len);
 
 	for (i = 0; i < len;) {
 		/* Build the command buffer */
@@ -152,8 +154,8 @@ int stv06xx_write_sensor_words(struct sd *sd, const u16 *data, u8 len)
 			buf[j] = data[2*i];
 			buf[0x10 + j * 2] = data[2*i+1];
 			buf[0x10 + j * 2 + 1] = data[2*i+1] >> 8;
-			PDEBUG(D_CONF, "I2C: Writing 0x%04x to reg 0x%02x",
-				data[2*i+1], data[2*i]);
+			gspca_dbg(gspca_dev, D_CONF, "I2C: Writing 0x%04x to reg 0x%02x\n",
+				  data[2*i+1], data[2*i]);
 		}
 		buf[0x20] = sd->sensor->i2c_addr;
 		buf[0x21] = j - 1; /* Number of commands to send - 1 */
@@ -205,8 +207,8 @@ int stv06xx_read_sensor(struct sd *sd, const u8 address, u16 *value)
 	else
 		*value = buf[0];
 
-	PDEBUG(D_CONF, "I2C: Read 0x%x from address 0x%x, status: %d",
-	       *value, address, err);
+	gspca_dbg(gspca_dev, D_CONF, "I2C: Read 0x%x from address 0x%x, status: %d\n",
+		  *value, address, err);
 
 	return (err < 0) ? err : 0;
 }
@@ -249,7 +251,7 @@ static int stv06xx_init(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	int err;
 
-	PDEBUG(D_PROBE, "Initializing camera");
+	gspca_dbg(gspca_dev, D_PROBE, "Initializing camera\n");
 
 	/* Let the usb init settle for a bit
 	   before performing the initialization */
@@ -268,7 +270,7 @@ static int stv06xx_init_controls(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_PROBE, "Initializing controls");
+	gspca_dbg(gspca_dev, D_PROBE, "Initializing controls\n");
 
 	gspca_dev->vdev.ctrl_handler = &gspca_dev->ctrl_handler;
 	return sd->sensor->init_controls(sd);
@@ -304,9 +306,9 @@ static int stv06xx_start(struct gspca_dev *gspca_dev)
 
 out:
 	if (err < 0)
-		PDEBUG(D_STREAM, "Starting stream failed");
+		gspca_dbg(gspca_dev, D_STREAM, "Starting stream failed\n");
 	else
-		PDEBUG(D_STREAM, "Started streaming");
+		gspca_dbg(gspca_dev, D_STREAM, "Started streaming\n");
 
 	return (err < 0) ? err : 0;
 }
@@ -362,9 +364,9 @@ static void stv06xx_stopN(struct gspca_dev *gspca_dev)
 
 out:
 	if (err < 0)
-		PDEBUG(D_STREAM, "Failed to stop stream");
+		gspca_dbg(gspca_dev, D_STREAM, "Failed to stop stream\n");
 	else
-		PDEBUG(D_STREAM, "Stopped streaming");
+		gspca_dbg(gspca_dev, D_STREAM, "Stopped streaming\n");
 }
 
 /*
@@ -385,7 +387,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_PACK, "Packet of length %d arrived", len);
+	gspca_dbg(gspca_dev, D_PACK, "Packet of length %d arrived\n", len);
 
 	/* A packet may contain several frames
 	   loop until the whole packet is reached */
@@ -393,7 +395,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 		int id, chunk_len;
 
 		if (len < 4) {
-			PDEBUG(D_PACK, "Packet is smaller than 4 bytes");
+			gspca_dbg(gspca_dev, D_PACK, "Packet is smaller than 4 bytes\n");
 			return;
 		}
 
@@ -402,7 +404,8 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 
 		/* Capture the chunk length */
 		chunk_len = (data[2] << 8) | data[3];
-		PDEBUG(D_PACK, "Chunk id: %x, length: %d", id, chunk_len);
+		gspca_dbg(gspca_dev, D_PACK, "Chunk id: %x, length: %d\n",
+			  id, chunk_len);
 
 		data += 4;
 		len -= 4;
@@ -421,7 +424,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 		case 0x0200:
 		case 0x4200:
 frame_data:
-			PDEBUG(D_PACK, "Frame data packet detected");
+			gspca_dbg(gspca_dev, D_PACK, "Frame data packet detected\n");
 
 			if (sd->to_skip) {
 				int skip = (sd->to_skip < chunk_len) ?
@@ -440,7 +443,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 		case 0x8005:
 		case 0xc001:
 		case 0xc005:
-			PDEBUG(D_PACK, "Starting new frame");
+			gspca_dbg(gspca_dev, D_PACK, "Starting new frame\n");
 
 			/* Create a new frame, chunk length should be zero */
 			gspca_frame_add(gspca_dev, FIRST_PACKET,
@@ -456,7 +459,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 		case 0x8002:
 		case 0x8006:
 		case 0xc002:
-			PDEBUG(D_PACK, "End of frame detected");
+			gspca_dbg(gspca_dev, D_PACK, "End of frame detected\n");
 
 			/* Complete the last frame (if any) */
 			gspca_frame_add(gspca_dev, LAST_PACKET,
@@ -467,23 +470,24 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 			break;
 
 		case 0x0005:
-			PDEBUG(D_PACK, "Chunk 0x005 detected");
+			gspca_dbg(gspca_dev, D_PACK, "Chunk 0x005 detected\n");
 			/* Unknown chunk with 11 bytes of data,
 			   occurs just before end of each frame
 			   in compressed mode */
 			break;
 
 		case 0x0100:
-			PDEBUG(D_PACK, "Chunk 0x0100 detected");
+			gspca_dbg(gspca_dev, D_PACK, "Chunk 0x0100 detected\n");
 			/* Unknown chunk with 2 bytes of data,
 			   occurs 2-3 times per USB interrupt */
 			break;
 		case 0x42ff:
-			PDEBUG(D_PACK, "Chunk 0x42ff detected");
+			gspca_dbg(gspca_dev, D_PACK, "Chunk 0x42ff detected\n");
 			/* Special chunk seen sometimes on the ST6422 */
 			break;
 		default:
-			PDEBUG(D_PACK, "Unknown chunk 0x%04x detected", id);
+			gspca_dbg(gspca_dev, D_PACK, "Unknown chunk 0x%04x detected\n",
+				  id);
 			/* Unknown chunk */
 		}
 		data    += chunk_len;
@@ -539,7 +543,7 @@ static int stv06xx_config(struct gspca_dev *gspca_dev,
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_PROBE, "Configuring camera");
+	gspca_dbg(gspca_dev, D_PROBE, "Configuring camera\n");
 
 	sd->bridge = id->driver_info;
 	gspca_dev->sd_desc = &sd_desc;
@@ -598,7 +602,7 @@ static void sd_disconnect(struct usb_interface *intf)
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 	struct sd *sd = (struct sd *) gspca_dev;
 	void *priv = sd->sensor_priv;
-	PDEBUG(D_PROBE, "Disconnecting the stv06xx device");
+	gspca_dbg(gspca_dev, D_PROBE, "Disconnecting the stv06xx device\n");
 
 	sd->sensor = NULL;
 	gspca_disconnect(intf);
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
index 28252f6c4afd..d8db2c89718f 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
@@ -251,8 +251,8 @@ static int hdcs_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 		if (err < 0)
 			return err;
 	}
-	PDEBUG(D_CONF, "Writing exposure %d, rowexp %d, srowexp %d",
-	       val, rowexp, srowexp);
+	gspca_dbg(gspca_dev, D_CONF, "Writing exposure %d, rowexp %d, srowexp %d\n",
+		  val, rowexp, srowexp);
 	return err;
 }
 
@@ -276,7 +276,7 @@ static int hdcs_set_gains(struct sd *sd, u8 g)
 
 static int hdcs_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	PDEBUG(D_CONF, "Writing gain %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Writing gain %d\n", val);
 	return hdcs_set_gains((struct sd *) gspca_dev,
 			       val & 0xff);
 }
@@ -465,7 +465,7 @@ static int hdcs_start(struct sd *sd)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
-	PDEBUG(D_STREAM, "Starting stream");
+	gspca_dbg(gspca_dev, D_STREAM, "Starting stream\n");
 
 	return hdcs_set_state(sd, HDCS_STATE_RUN);
 }
@@ -474,7 +474,7 @@ static int hdcs_stop(struct sd *sd)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
-	PDEBUG(D_STREAM, "Halting stream");
+	gspca_dbg(gspca_dev, D_STREAM, "Halting stream\n");
 
 	return hdcs_set_state(sd, HDCS_STATE_SLEEP);
 }
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
index e1ce96e9405f..7374aeb0a67a 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
@@ -229,7 +229,7 @@ static int pb0100_start(struct sd *sd)
 	}
 
 	err = stv06xx_write_sensor(sd, PB_CONTROL, BIT(5)|BIT(3)|BIT(1));
-	PDEBUG(D_STREAM, "Started stream, status: %d", err);
+	gspca_dbg(gspca_dev, D_STREAM, "Started stream, status: %d\n", err);
 
 	return (err < 0) ? err : 0;
 }
@@ -247,7 +247,7 @@ static int pb0100_stop(struct sd *sd)
 	/* Set bit 1 to zero */
 	err = stv06xx_write_sensor(sd, PB_CONTROL, BIT(5)|BIT(3));
 
-	PDEBUG(D_STREAM, "Halting stream");
+	gspca_dbg(gspca_dev, D_STREAM, "Halting stream\n");
 out:
 	return (err < 0) ? err : 0;
 }
@@ -332,7 +332,8 @@ static int pb0100_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 	err = stv06xx_write_sensor(sd, PB_G1GAIN, val);
 	if (!err)
 		err = stv06xx_write_sensor(sd, PB_G2GAIN, val);
-	PDEBUG(D_CONF, "Set green gain to %d, status: %d", val, err);
+	gspca_dbg(gspca_dev, D_CONF, "Set green gain to %d, status: %d\n",
+		  val, err);
 
 	if (!err)
 		err = pb0100_set_red_balance(gspca_dev, ctrls->red->val);
@@ -355,7 +356,8 @@ static int pb0100_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
 		val = 255;
 
 	err = stv06xx_write_sensor(sd, PB_RGAIN, val);
-	PDEBUG(D_CONF, "Set red gain to %d, status: %d", val, err);
+	gspca_dbg(gspca_dev, D_CONF, "Set red gain to %d, status: %d\n",
+		  val, err);
 
 	return err;
 }
@@ -373,7 +375,8 @@ static int pb0100_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
 		val = 255;
 
 	err = stv06xx_write_sensor(sd, PB_BGAIN, val);
-	PDEBUG(D_CONF, "Set blue gain to %d, status: %d", val, err);
+	gspca_dbg(gspca_dev, D_CONF, "Set blue gain to %d, status: %d\n",
+		  val, err);
 
 	return err;
 }
@@ -384,7 +387,8 @@ static int pb0100_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 	int err;
 
 	err = stv06xx_write_sensor(sd, PB_RINTTIME, val);
-	PDEBUG(D_CONF, "Set exposure to %d, status: %d", val, err);
+	gspca_dbg(gspca_dev, D_CONF, "Set exposure to %d, status: %d\n",
+		  val, err);
 
 	return err;
 }
@@ -404,8 +408,8 @@ static int pb0100_set_autogain(struct gspca_dev *gspca_dev, __s32 val)
 		val = 0;
 
 	err = stv06xx_write_sensor(sd, PB_EXPGAIN, val);
-	PDEBUG(D_CONF, "Set autogain to %d (natural: %d), status: %d",
-	       val, ctrls->natural->val, err);
+	gspca_dbg(gspca_dev, D_CONF, "Set autogain to %d (natural: %d), status: %d\n",
+		  val, ctrls->natural->val, err);
 
 	return err;
 }
@@ -426,7 +430,8 @@ static int pb0100_set_autogain_target(struct gspca_dev *gspca_dev, __s32 val)
 	if (!err)
 		err = stv06xx_write_sensor(sd, PB_R22, darkpixels);
 
-	PDEBUG(D_CONF, "Set autogain target to %d, status: %d", val, err);
+	gspca_dbg(gspca_dev, D_CONF, "Set autogain target to %d, status: %d\n",
+		  val, err);
 
 	return err;
 }
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c b/drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c
index 4b76070515b5..51a135c2f9f7 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c
@@ -277,7 +277,7 @@ static int st6422_stop(struct sd *sd)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)sd;
 
-	PDEBUG(D_STREAM, "Halting stream");
+	gspca_dbg(gspca_dev, D_STREAM, "Halting stream\n");
 
 	return 0;
 }
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
index d265e6b00994..b2f16c2754fb 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
@@ -129,7 +129,7 @@ static int vv6410_start(struct sd *sd)
 	u32 priv = cam->cam_mode[sd->gspca_dev.curr_mode].priv;
 
 	if (priv & VV6410_SUBSAMPLE) {
-		PDEBUG(D_CONF, "Enabling subsampling");
+		gspca_dbg(gspca_dev, D_CONF, "Enabling subsampling\n");
 		stv06xx_write_bridge(sd, STV_Y_CTRL, 0x02);
 		stv06xx_write_bridge(sd, STV_X_CTRL, 0x06);
 
@@ -150,7 +150,7 @@ static int vv6410_start(struct sd *sd)
 	if (err < 0)
 		return err;
 
-	PDEBUG(D_STREAM, "Starting stream");
+	gspca_dbg(gspca_dev, D_STREAM, "Starting stream\n");
 
 	return 0;
 }
@@ -169,7 +169,7 @@ static int vv6410_stop(struct sd *sd)
 	if (err < 0)
 		return err;
 
-	PDEBUG(D_STREAM, "Halting stream");
+	gspca_dbg(gspca_dev, D_STREAM, "Halting stream\n");
 
 	return 0;
 }
@@ -203,7 +203,7 @@ static int vv6410_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
 	else
 		i2c_data &= ~VV6410_HFLIP;
 
-	PDEBUG(D_CONF, "Set horizontal flip to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set horizontal flip to %d\n", val);
 	err = stv06xx_write_sensor(sd, VV6410_DATAFORMAT, i2c_data);
 
 	return (err < 0) ? err : 0;
@@ -224,7 +224,7 @@ static int vv6410_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
 	else
 		i2c_data &= ~VV6410_VFLIP;
 
-	PDEBUG(D_CONF, "Set vertical flip to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set vertical flip to %d\n", val);
 	err = stv06xx_write_sensor(sd, VV6410_DATAFORMAT, i2c_data);
 
 	return (err < 0) ? err : 0;
@@ -235,7 +235,7 @@ static int vv6410_set_analog_gain(struct gspca_dev *gspca_dev, __s32 val)
 	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	PDEBUG(D_CONF, "Set analog gain to %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Set analog gain to %d\n", val);
 	err = stv06xx_write_sensor(sd, VV6410_ANALOGGAIN, 0xf0 | (val & 0xf));
 
 	return (err < 0) ? err : 0;
@@ -252,8 +252,8 @@ static int vv6410_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 	fine = val % VV6410_CIF_LINELENGTH;
 	coarse = min(512, val / VV6410_CIF_LINELENGTH);
 
-	PDEBUG(D_CONF, "Set coarse exposure to %d, fine exposure to %d",
-	       coarse, fine);
+	gspca_dbg(gspca_dev, D_CONF, "Set coarse exposure to %d, fine exposure to %d\n",
+		  coarse, fine);
 
 	err = stv06xx_write_sensor(sd, VV6410_FINEH, fine >> 8);
 	if (err < 0)
diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index 44b07344f0f7..437a3367ab97 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -311,8 +311,8 @@ static void reg_w_riv(struct gspca_dev *gspca_dev,
 		gspca_dev->usb_err = ret;
 		return;
 	}
-	PDEBUG(D_USBO, "reg_w_riv: 0x%02x,0x%04x:0x%04x",
-		req, index, value);
+	gspca_dbg(gspca_dev, D_USBO, "reg_w_riv: 0x%02x,0x%04x:0x%04x\n",
+		  req, index, value);
 }
 
 static void write_vector(struct gspca_dev *gspca_dev,
@@ -343,12 +343,14 @@ static void spca504_acknowledged_command(struct gspca_dev *gspca_dev,
 {
 	reg_w_riv(gspca_dev, req, idx, val);
 	reg_r(gspca_dev, 0x01, 0x0001, 1);
-	PDEBUG(D_FRAM, "before wait 0x%04x", gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_FRAM, "before wait 0x%04x\n",
+		  gspca_dev->usb_buf[0]);
 	reg_w_riv(gspca_dev, req, idx, val);
 
 	msleep(200);
 	reg_r(gspca_dev, 0x01, 0x0001, 1);
-	PDEBUG(D_FRAM, "after wait 0x%04x", gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_FRAM, "after wait 0x%04x\n",
+		  gspca_dev->usb_buf[0]);
 }
 
 static void spca504_read_info(struct gspca_dev *gspca_dev)
@@ -363,10 +365,10 @@ static void spca504_read_info(struct gspca_dev *gspca_dev)
 		reg_r(gspca_dev, 0, i, 1);
 		info[i] = gspca_dev->usb_buf[0];
 	}
-	PDEBUG(D_STREAM,
-		"Read info: %d %d %d %d %d %d. Should be 1,0,2,2,0,0",
-		info[0], info[1], info[2],
-		info[3], info[4], info[5]);
+	gspca_dbg(gspca_dev, D_STREAM,
+		  "Read info: %d %d %d %d %d %d. Should be 1,0,2,2,0,0\n",
+		  info[0], info[1], info[2],
+		  info[3], info[4], info[5]);
 }
 
 static void spca504A_acknowledged_command(struct gspca_dev *gspca_dev,
@@ -379,8 +381,8 @@ static void spca504A_acknowledged_command(struct gspca_dev *gspca_dev,
 	reg_r(gspca_dev, 0x01, 0x0001, 1);
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_FRAM, "Status 0x%02x Need 0x%02x",
-			gspca_dev->usb_buf[0], endcode);
+	gspca_dbg(gspca_dev, D_FRAM, "Status 0x%02x Need 0x%02x\n",
+		  gspca_dev->usb_buf[0], endcode);
 	if (!count)
 		return;
 	count = 200;
@@ -391,8 +393,8 @@ static void spca504A_acknowledged_command(struct gspca_dev *gspca_dev,
 		reg_r(gspca_dev, 0x01, 0x0001, 1);
 		status = gspca_dev->usb_buf[0];
 		if (status == endcode) {
-			PDEBUG(D_FRAM, "status 0x%04x after wait %d",
-				status, 200 - count);
+			gspca_dbg(gspca_dev, D_FRAM, "status 0x%04x after wait %d\n",
+				  status, 200 - count);
 				break;
 		}
 	}
@@ -435,8 +437,8 @@ static void spca50x_GetFirmware(struct gspca_dev *gspca_dev)
 
 	data = gspca_dev->usb_buf;
 	reg_r(gspca_dev, 0x20, 0, 5);
-	PDEBUG(D_STREAM, "FirmWare: %d %d %d %d %d",
-		data[0], data[1], data[2], data[3], data[4]);
+	gspca_dbg(gspca_dev, D_STREAM, "FirmWare: %d %d %d %d %d\n",
+		  data[0], data[1], data[2], data[3], data[4]);
 	reg_r(gspca_dev, 0x23, 0, 64);
 	reg_r(gspca_dev, 0x23, 1, 64);
 }
@@ -651,7 +653,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		spca504B_WaitCmdStatus(gspca_dev);
 		break;
 	case BRIDGE_SPCA504C:	/* pccam600 */
-		PDEBUG(D_STREAM, "Opening SPCA504 (PC-CAM 600)");
+		gspca_dbg(gspca_dev, D_STREAM, "Opening SPCA504 (PC-CAM 600)\n");
 		reg_w_riv(gspca_dev, 0xe0, 0x0000, 0x0000);
 		reg_w_riv(gspca_dev, 0xe0, 0x0000, 0x0001);	/* reset */
 		spca504_wait_status(gspca_dev);
@@ -666,7 +668,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		break;
 	default:
 /*	case BRIDGE_SPCA504: */
-		PDEBUG(D_STREAM, "Opening SPCA504");
+		gspca_dbg(gspca_dev, D_STREAM, "Opening SPCA504\n");
 		if (sd->subtype == AiptekMiniPenCam13) {
 			spca504_read_info(gspca_dev);
 
diff --git a/drivers/media/usb/gspca/t613.c b/drivers/media/usb/gspca/t613.c
index 46fb76349000..0ae557cd15ef 100644
--- a/drivers/media/usb/gspca/t613.c
+++ b/drivers/media/usb/gspca/t613.c
@@ -490,7 +490,7 @@ static void setcolors(struct gspca_dev *gspca_dev, s32 val)
 
 static void setgamma(struct gspca_dev *gspca_dev, s32 val)
 {
-	PDEBUG(D_CONF, "Gamma: %d", val);
+	gspca_dbg(gspca_dev, D_CONF, "Gamma: %d\n", val);
 	reg_w_ixbuf(gspca_dev, 0x90,
 		gamma_table[val], sizeof gamma_table[0]);
 }
@@ -592,19 +592,19 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			| reg_r(gspca_dev, 0x07);
 	switch (sensor_id & 0xff0f) {
 	case 0x0801:
-		PDEBUG(D_PROBE, "sensor tas5130a");
+		gspca_dbg(gspca_dev, D_PROBE, "sensor tas5130a\n");
 		sd->sensor = SENSOR_TAS5130A;
 		break;
 	case 0x0802:
-		PDEBUG(D_PROBE, "sensor lt168g");
+		gspca_dbg(gspca_dev, D_PROBE, "sensor lt168g\n");
 		sd->sensor = SENSOR_LT168G;
 		break;
 	case 0x0803:
-		PDEBUG(D_PROBE, "sensor 'other'");
+		gspca_dbg(gspca_dev, D_PROBE, "sensor 'other'\n");
 		sd->sensor = SENSOR_OTHER;
 		break;
 	case 0x0807:
-		PDEBUG(D_PROBE, "sensor om6802");
+		gspca_dbg(gspca_dev, D_PROBE, "sensor om6802\n");
 		sd->sensor = SENSOR_OM6802;
 		break;
 	default:
@@ -632,8 +632,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	i = 0;
 	while (read_indexs[i] != 0x00) {
 		test_byte = reg_r(gspca_dev, read_indexs[i]);
-		PDEBUG(D_STREAM, "Reg 0x%02x = 0x%02x", read_indexs[i],
-		       test_byte);
+		gspca_dbg(gspca_dev, D_STREAM, "Reg 0x%02x = 0x%02x\n",
+			  read_indexs[i], test_byte);
 		i++;
 	}
 
@@ -643,8 +643,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	if (sd->sensor == SENSOR_LT168G) {
 		test_byte = reg_r(gspca_dev, 0x80);
-		PDEBUG(D_STREAM, "Reg 0x%02x = 0x%02x", 0x80,
-		       test_byte);
+		gspca_dbg(gspca_dev, D_STREAM, "Reg 0x%02x = 0x%02x\n", 0x80,
+			  test_byte);
 		reg_w(gspca_dev, 0x6c80);
 	}
 
@@ -665,8 +665,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	if (sd->sensor == SENSOR_LT168G) {
 		test_byte = reg_r(gspca_dev, 0x80);
-		PDEBUG(D_STREAM, "Reg 0x%02x = 0x%02x", 0x80,
-		       test_byte);
+		gspca_dbg(gspca_dev, D_STREAM, "Reg 0x%02x = 0x%02x\n", 0x80,
+			  test_byte);
 		reg_w(gspca_dev, 0x6c80);
 	}
 
@@ -737,7 +737,7 @@ static void poll_sensor(struct gspca_dev *gspca_dev)
 		 0xa1, 0xb1, 0xda, 0x6b, 0xdb, 0x98, 0xdf, 0x0c,
 		 0xc2, 0x80, 0xc3, 0x10};
 
-	PDEBUG(D_STREAM, "[Sensor requires polling]");
+	gspca_dbg(gspca_dev, D_STREAM, "[Sensor requires polling]\n");
 	reg_w_buf(gspca_dev, poll1, sizeof poll1);
 	reg_w_buf(gspca_dev, poll2, sizeof poll2);
 	reg_w_buf(gspca_dev, noise03, sizeof noise03);
diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
index 983fc6b500af..82e2be14cad8 100644
--- a/drivers/media/usb/gspca/topro.c
+++ b/drivers/media/usb/gspca/topro.c
@@ -1453,7 +1453,7 @@ static void set_dqt(struct gspca_dev *gspca_dev, u8 q)
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	/* update the jpeg quantization tables */
-	PDEBUG(D_STREAM, "q %d -> %d", sd->quality, q);
+	gspca_dbg(gspca_dev, D_STREAM, "q %d -> %d\n", sd->quality, q);
 	sd->quality = q;
 	if (q > 16)
 		q = 16;
@@ -4053,7 +4053,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 				ARRAY_SIZE(tp6810_preinit));
 	msleep(15);
 	reg_r(gspca_dev, TP6800_R18_GPIO_DATA);
-	PDEBUG(D_PROBE, "gpio: %02x", gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_PROBE, "gpio: %02x\n", gspca_dev->usb_buf[0]);
 /* values:
  *	0x80: snapshot button
  *	0x40: LED
@@ -4627,7 +4627,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			if (*data == 0xaa || *data == 0x00)
 				return;
 			if (*data > 0xc0) {
-				PDEBUG(D_FRAM, "bad frame");
+				gspca_dbg(gspca_dev, D_FRAM, "bad frame\n");
 				gspca_dev->last_packet_type = DISCARD_PACKET;
 				return;
 			}
diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
index a1bb1704d339..d1b9032d7863 100644
--- a/drivers/media/usb/gspca/touptek.c
+++ b/drivers/media/usb/gspca/touptek.c
@@ -214,12 +214,12 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 	char *buff = gspca_dev->usb_buf;
 	int rc;
 
-	PDEBUG(D_USBO,
-		"reg_w bReq=0x0B, bReqT=0xC0, wVal=0x%04X, wInd=0x%04X\n",
-		value, index);
+	gspca_dbg(gspca_dev, D_USBO,
+		  "reg_w bReq=0x0B, bReqT=0xC0, wVal=0x%04X, wInd=0x%04X\n\n",
+		  value, index);
 	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
 		0x0B, 0xC0, value, index, buff, 1, 500);
-	PDEBUG(D_USBO, "rc=%d, ret={0x%02x}", rc, (int)buff[0]);
+	gspca_dbg(gspca_dev, D_USBO, "rc=%d, ret={0x%02x}\n", rc, (int)buff[0]);
 	if (rc < 0) {
 		gspca_err(gspca_dev, "Failed reg_w(0x0B, 0xC0, 0x%04X, 0x%04X) w/ rc %d\n",
 			  value, index, rc);
@@ -258,7 +258,7 @@ static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 		gspca_dev->usb_err = -EINVAL;
 		return;
 	}
-	PDEBUG(D_STREAM, "exposure: 0x%04X ms\n", value);
+	gspca_dbg(gspca_dev, D_STREAM, "exposure: 0x%04X ms\n\n", value);
 	/* Wonder if theres a good reason for sending it twice */
 	/* probably not but leave it in because...why not */
 	reg_w(gspca_dev, value, REG_COARSE_INTEGRATION_TIME_);
@@ -286,9 +286,9 @@ static void setggain(struct gspca_dev *gspca_dev, u16 global_gain)
 	u16 normalized;
 
 	normalized = gainify(global_gain);
-	PDEBUG(D_STREAM, "gain G1/G2 (0x%04X): 0x%04X (src 0x%04X)\n",
-		 REG_GREEN1_GAIN,
-		 normalized, global_gain);
+	gspca_dbg(gspca_dev, D_STREAM, "gain G1/G2 (0x%04X): 0x%04X (src 0x%04X)\n\n",
+		  REG_GREEN1_GAIN,
+		  normalized, global_gain);
 
 	reg_w(gspca_dev, normalized, REG_GREEN1_GAIN);
 	reg_w(gspca_dev, normalized, REG_GREEN2_GAIN);
@@ -302,13 +302,13 @@ static void setbgain(struct gspca_dev *gspca_dev,
 	normalized = global_gain +
 		((u32)global_gain) * gain / GAIN_MAX;
 	if (normalized > GAIN_MAX) {
-		PDEBUG(D_STREAM, "Truncating blue 0x%04X w/ value 0x%04X\n",
-			 GAIN_MAX, normalized);
+		gspca_dbg(gspca_dev, D_STREAM, "Truncating blue 0x%04X w/ value 0x%04X\n\n",
+			  GAIN_MAX, normalized);
 		normalized = GAIN_MAX;
 	}
 	normalized = gainify(normalized);
-	PDEBUG(D_STREAM, "gain B (0x%04X): 0x%04X w/ source 0x%04X\n",
-		 REG_BLUE_GAIN, normalized, gain);
+	gspca_dbg(gspca_dev, D_STREAM, "gain B (0x%04X): 0x%04X w/ source 0x%04X\n\n",
+		  REG_BLUE_GAIN, normalized, gain);
 
 	reg_w(gspca_dev, normalized, REG_BLUE_GAIN);
 }
@@ -321,13 +321,13 @@ static void setrgain(struct gspca_dev *gspca_dev,
 	normalized = global_gain +
 		((u32)global_gain) * gain / GAIN_MAX;
 	if (normalized > GAIN_MAX) {
-		PDEBUG(D_STREAM, "Truncating gain 0x%04X w/ value 0x%04X\n",
-			 GAIN_MAX, normalized);
+		gspca_dbg(gspca_dev, D_STREAM, "Truncating gain 0x%04X w/ value 0x%04X\n\n",
+			  GAIN_MAX, normalized);
 		normalized = GAIN_MAX;
 	}
 	normalized = gainify(normalized);
-	PDEBUG(D_STREAM, "gain R (0x%04X): 0x%04X w / source 0x%04X\n",
-		 REG_RED_GAIN, normalized, gain);
+	gspca_dbg(gspca_dev, D_STREAM, "gain R (0x%04X): 0x%04X w / source 0x%04X\n\n",
+		  REG_RED_GAIN, normalized, gain);
 
 	reg_w(gspca_dev, normalized, REG_RED_GAIN);
 }
@@ -336,7 +336,7 @@ static void configure_wh(struct gspca_dev *gspca_dev)
 {
 	unsigned int w = gspca_dev->pixfmt.width;
 
-	PDEBUG(D_STREAM, "configure_wh\n");
+	gspca_dbg(gspca_dev, D_STREAM, "configure_wh\n\n");
 
 	if (w == 800) {
 		static const struct cmd reg_init_res[] = {
@@ -425,14 +425,15 @@ static void configure_encrypted(struct gspca_dev *gspca_dev)
 		{0x0100, REG_MODE_SELECT},
 	};
 
-	PDEBUG(D_STREAM, "Encrypted begin, w = %u\n", gspca_dev->pixfmt.width);
+	gspca_dbg(gspca_dev, D_STREAM, "Encrypted begin, w = %u\n\n",
+		  gspca_dev->pixfmt.width);
 	reg_w_buf(gspca_dev, reg_init_begin, ARRAY_SIZE(reg_init_begin));
 	configure_wh(gspca_dev);
 	reg_w_buf(gspca_dev, reg_init_end, ARRAY_SIZE(reg_init_end));
 	reg_w(gspca_dev, 0x0100, REG_GROUPED_PARAMETER_HOLD);
 	reg_w(gspca_dev, 0x0000, REG_GROUPED_PARAMETER_HOLD);
 
-	PDEBUG(D_STREAM, "Encrypted end\n");
+	gspca_dbg(gspca_dev, D_STREAM, "Encrypted end\n\n");
 }
 
 static int configure(struct gspca_dev *gspca_dev)
@@ -440,7 +441,7 @@ static int configure(struct gspca_dev *gspca_dev)
 	int rc;
 	char *buff = gspca_dev->usb_buf;
 
-	PDEBUG(D_STREAM, "configure()\n");
+	gspca_dbg(gspca_dev, D_STREAM, "configure()\n\n");
 
 	/*
 	 * First driver sets a sort of encryption key
@@ -519,7 +520,7 @@ static int configure(struct gspca_dev *gspca_dev)
 		return rc;
 	}
 
-	PDEBUG(D_STREAM, "Configure complete\n");
+	gspca_dbg(gspca_dev, D_STREAM, "Configure complete\n\n");
 	return 0;
 }
 
@@ -567,13 +568,13 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 		/* can we finish a frame? */
 		if (sd->this_f + len == gspca_dev->pixfmt.sizeimage) {
 			gspca_frame_add(gspca_dev, LAST_PACKET, data, len);
-			PDEBUG(D_FRAM, "finish frame sz %u/%u w/ len %u\n",
-				 sd->this_f, gspca_dev->pixfmt.sizeimage, len);
+			gspca_dbg(gspca_dev, D_FRAM, "finish frame sz %u/%u w/ len %u\n\n",
+				  sd->this_f, gspca_dev->pixfmt.sizeimage, len);
 		/* lost some data, discard the frame */
 		} else {
 			gspca_frame_add(gspca_dev, DISCARD_PACKET, NULL, 0);
-			PDEBUG(D_FRAM, "abort frame sz %u/%u w/ len %u\n",
-				 sd->this_f, gspca_dev->pixfmt.sizeimage, len);
+			gspca_dbg(gspca_dev, D_FRAM, "abort frame sz %u/%u w/ len %u\n\n",
+				  sd->this_f, gspca_dev->pixfmt.sizeimage, len);
 		}
 		sd->this_f = 0;
 	} else {
diff --git a/drivers/media/usb/gspca/vc032x.c b/drivers/media/usb/gspca/vc032x.c
index b935febf7146..6b11597977c9 100644
--- a/drivers/media/usb/gspca/vc032x.c
+++ b/drivers/media/usb/gspca/vc032x.c
@@ -2926,11 +2926,12 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	if (gspca_dev->usb_err < 0)
 		return;
 	if (len == 1)
-		PDEBUG(D_USBI, "GET %02x 0001 %04x %02x", req, index,
-				gspca_dev->usb_buf[0]);
+		gspca_dbg(gspca_dev, D_USBI, "GET %02x 0001 %04x %02x\n",
+			  req, index,
+			  gspca_dev->usb_buf[0]);
 	else
-		PDEBUG(D_USBI, "GET %02x 0001 %04x %*ph",
-				req, index, 3, gspca_dev->usb_buf);
+		gspca_dbg(gspca_dev, D_USBI, "GET %02x 0001 %04x %*ph\n",
+			  req, index, 3, gspca_dev->usb_buf);
 }
 
 static void reg_w_i(struct gspca_dev *gspca_dev,
@@ -2960,7 +2961,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 {
 	if (gspca_dev->usb_err < 0)
 		return;
-	PDEBUG(D_USBO, "SET %02x %04x %04x", req, value, index);
+	gspca_dbg(gspca_dev, D_USBO, "SET %02x %04x %04x\n", req, value, index);
 	reg_w_i(gspca_dev, req, value, index);
 }
 
@@ -2992,8 +2993,8 @@ static u16 read_sensor_register(struct gspca_dev *gspca_dev,
 	reg_r(gspca_dev, 0xa1, 0xb33c, 1);
 	hdata = gspca_dev->usb_buf[0];
 	if (hdata != 0 && mdata != 0 && ldata != 0)
-		PDEBUG(D_PROBE, "Read Sensor %02x%02x %02x",
-			hdata, mdata, ldata);
+		gspca_dbg(gspca_dev, D_PROBE, "Read Sensor %02x%02x %02x\n",
+			  hdata, mdata, ldata);
 	reg_r(gspca_dev, 0xa1, 0xb334, 1);
 	if (gspca_dev->usb_buf[0] == 0x02)
 		return (hdata << 8) + mdata;
@@ -3015,8 +3016,8 @@ static int vc032x_probe_sensor(struct gspca_dev *gspca_dev)
 	}
 
 	reg_r(gspca_dev, 0xa1, 0xbfcf, 1);
-	PDEBUG(D_PROBE, "vc032%d check sensor header %02x",
-		sd->bridge == BRIDGE_VC0321 ? 1 : 3, gspca_dev->usb_buf[0]);
+	gspca_dbg(gspca_dev, D_PROBE, "vc032%d check sensor header %02x\n",
+		  sd->bridge == BRIDGE_VC0321 ? 1 : 3, gspca_dev->usb_buf[0]);
 	if (sd->bridge == BRIDGE_VC0321) {
 		ptsensor_info = vc0321_probe_data;
 		n = ARRAY_SIZE(vc0321_probe_data);
@@ -3036,7 +3037,8 @@ static int vc032x_probe_sensor(struct gspca_dev *gspca_dev)
 		if (value == 0 && ptsensor_info->IdAdd == 0x82)
 			value = read_sensor_register(gspca_dev, 0x83);
 		if (value != 0) {
-			PDEBUG(D_PROBE, "Sensor ID %04x (%d)", value, i);
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor ID %04x (%d)\n",
+				  value, i);
 			if (value == ptsensor_info->VpId)
 				return ptsensor_info->sensorId;
 
@@ -3063,9 +3065,10 @@ static void i2c_write(struct gspca_dev *gspca_dev,
 	if (gspca_dev->usb_err < 0)
 		return;
 	if (size == 1)
-		PDEBUG(D_USBO, "i2c_w %02x %02x", reg, *val);
+		gspca_dbg(gspca_dev, D_USBO, "i2c_w %02x %02x\n", reg, *val);
 	else
-		PDEBUG(D_USBO, "i2c_w %02x %02x%02x", reg, *val, val[1]);
+		gspca_dbg(gspca_dev, D_USBO, "i2c_w %02x %02x%02x\n",
+			  reg, *val, val[1]);
 	reg_r_i(gspca_dev, 0xa1, 0xb33f, 1);
 /*fixme:should check if (!(gspca_dev->usb_buf[0] & 0x02)) error*/
 	reg_w_i(gspca_dev, 0xa0, size, 0xb334);
@@ -3170,35 +3173,35 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		pr_err("Unknown sensor...\n");
 		return -EINVAL;
 	case SENSOR_HV7131R:
-		PDEBUG(D_PROBE, "Find Sensor HV7131R");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor HV7131R\n");
 		break;
 	case SENSOR_MI0360:
-		PDEBUG(D_PROBE, "Find Sensor MI0360");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor MI0360\n");
 		sd->bridge = BRIDGE_VC0323;
 		break;
 	case SENSOR_MI1310_SOC:
-		PDEBUG(D_PROBE, "Find Sensor MI1310_SOC");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor MI1310_SOC\n");
 		break;
 	case SENSOR_MI1320:
-		PDEBUG(D_PROBE, "Find Sensor MI1320");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor MI1320\n");
 		break;
 	case SENSOR_MI1320_SOC:
-		PDEBUG(D_PROBE, "Find Sensor MI1320_SOC");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor MI1320_SOC\n");
 		break;
 	case SENSOR_OV7660:
-		PDEBUG(D_PROBE, "Find Sensor OV7660");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor OV7660\n");
 		break;
 	case SENSOR_OV7670:
-		PDEBUG(D_PROBE, "Find Sensor OV7670");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor OV7670\n");
 		break;
 	case SENSOR_PO1200:
-		PDEBUG(D_PROBE, "Find Sensor PO1200");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor PO1200\n");
 		break;
 	case SENSOR_PO3130NC:
-		PDEBUG(D_PROBE, "Find Sensor PO3130NC");
+		gspca_dbg(gspca_dev, D_PROBE, "Find Sensor PO3130NC\n");
 		break;
 	case SENSOR_POxxxx:
-		PDEBUG(D_PROBE, "Sensor POxxxx");
+		gspca_dbg(gspca_dev, D_PROBE, "Sensor POxxxx\n");
 		break;
 	}
 	sd->sensor = sensor;
@@ -3624,8 +3627,8 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	if (data[0] == 0xff && data[1] == 0xd8) {
-		PDEBUG(D_PACK,
-			"vc032x header packet found len %d", len);
+		gspca_dbg(gspca_dev, D_PACK,
+			  "vc032x header packet found len %d\n", len);
 		gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
 		data += sd->image_offset;
 		len -= sd->image_offset;
diff --git a/drivers/media/usb/gspca/w996Xcf.c b/drivers/media/usb/gspca/w996Xcf.c
index d149cb7f0019..abfab3de1866 100644
--- a/drivers/media/usb/gspca/w996Xcf.c
+++ b/drivers/media/usb/gspca/w996Xcf.c
@@ -245,7 +245,7 @@ static void w9968cf_smbus_read_ack(struct sd *sd)
 	sda = w9968cf_read_sb(sd);
 	w9968cf_write_sb(sd, 0x0012); /* SDE=1, SDA=1, SCL=0 */
 	if (sda >= 0 && (sda & 0x08)) {
-		PDEBUG(D_USBI, "Did not receive i2c ACK");
+		gspca_dbg(gspca_dev, D_USBI, "Did not receive i2c ACK\n");
 		sd->gspca_dev.usb_err = -EIO;
 	}
 }
@@ -297,7 +297,7 @@ static void w9968cf_i2c_w(struct sd *sd, u8 reg, u8 value)
 
 	w9968cf_write_fsb(sd, data);
 
-	PDEBUG(D_USBO, "i2c 0x%02x -> [0x%02x]", value, reg);
+	gspca_dbg(gspca_dev, D_USBO, "i2c 0x%02x -> [0x%02x]\n", value, reg);
 }
 
 /* SMBus protocol: S Addr Wr [A] Subaddr [A] P S Addr+1 Rd [A] [Value] NA P */
@@ -331,7 +331,8 @@ static int w9968cf_i2c_r(struct sd *sd, u8 reg)
 
 	if (sd->gspca_dev.usb_err >= 0) {
 		ret = value;
-		PDEBUG(D_USBI, "i2c [0x%02X] -> 0x%02X", reg, value);
+		gspca_dbg(gspca_dev, D_USBI, "i2c [0x%02X] -> 0x%02X\n",
+			  reg, value);
 	} else
 		gspca_err(gspca_dev, "i2c read [0x%02x] failed\n", reg);
 
diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
index 68656e7986c7..58deb0c38826 100644
--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -704,7 +704,8 @@ static int cit_read_reg(struct gspca_dev *gspca_dev, u16 index, int verbose)
 	}
 
 	if (verbose)
-		PDEBUG(D_PROBE, "Register %04x value: %02x", index, buf[0]);
+		gspca_dbg(gspca_dev, D_PROBE, "Register %04x value: %02x\n",
+			  index, buf[0]);
 
 	return 0;
 }
@@ -1471,10 +1472,11 @@ static int cit_get_clock_div(struct gspca_dev *gspca_dev)
 			fps[clock_div - 1] * 3 / 2)
 		clock_div--;
 
-	PDEBUG(D_PROBE,
-	       "PacketSize: %d, res: %dx%d -> using clockdiv: %d (%d fps)",
-	       packet_size, gspca_dev->pixfmt.width, gspca_dev->pixfmt.height,
-	       clock_div, fps[clock_div]);
+	gspca_dbg(gspca_dev, D_PROBE,
+		  "PacketSize: %d, res: %dx%d -> using clockdiv: %d (%d fps)\n",
+		  packet_size,
+		  gspca_dev->pixfmt.width, gspca_dev->pixfmt.height,
+		  clock_div, fps[clock_div]);
 
 	return clock_div;
 }
@@ -2865,17 +2867,17 @@ static u8 *cit_find_sof(struct gspca_dev *gspca_dev, u8 *data, int len)
 				sd->sof_read = 0;
 				if (data[i] == 0xff) {
 					if (i >= 4)
-						PDEBUG(D_FRAM,
-						       "header found at offset: %d: %02x %02x 00 %3ph\n",
-						       i - 1,
-						       data[i - 4],
-						       data[i - 3],
-						       &data[i]);
+						gspca_dbg(gspca_dev, D_FRAM,
+							  "header found at offset: %d: %02x %02x 00 %3ph\n\n",
+							  i - 1,
+							  data[i - 4],
+							  data[i - 3],
+							  &data[i]);
 					else
-						PDEBUG(D_FRAM,
-						       "header found at offset: %d: 00 %3ph\n",
-						       i - 1,
-						       &data[i]);
+						gspca_dbg(gspca_dev, D_FRAM,
+							  "header found at offset: %d: 00 %3ph\n\n",
+							  i - 1,
+							  &data[i]);
 					return data + i + (sd->sof_len - 1);
 				}
 				break;
diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index e2d486bd8c28..25b4dbe8e049 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -6041,7 +6041,7 @@ static int sif_probe(struct gspca_dev *gspca_dev)
 	msleep(150);
 	checkword = ((i2c_read(gspca_dev, 0x00) & 0x0f) << 4)
 			| ((i2c_read(gspca_dev, 0x01) & 0xf0) >> 4);
-	PDEBUG(D_PROBE, "probe sif 0x%04x", checkword);
+	gspca_dbg(gspca_dev, D_PROBE, "probe sif 0x%04x\n", checkword);
 	if (checkword == 0x0007) {
 		send_unknown(gspca_dev, SENSOR_PAS106);
 		return 0x0f;			/* PAS106 */
@@ -6129,7 +6129,7 @@ static int vga_2wr_probe(struct gspca_dev *gspca_dev)
 	i2c_write(gspca_dev, 0x12, 0x80, 0x00);	/* sensor reset */
 	retword = i2c_read(gspca_dev, 0x0a) << 8;
 	retword |= i2c_read(gspca_dev, 0x0b);
-	PDEBUG(D_PROBE, "probe 2wr ov vga 0x%04x", retword);
+	gspca_dbg(gspca_dev, D_PROBE, "probe 2wr ov vga 0x%04x\n", retword);
 	switch (retword) {
 	case 0x7631:				/* OV7630C */
 		reg_w(gspca_dev, 0x06, 0x0010);
@@ -6186,7 +6186,7 @@ static int vga_3wr_probe(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x02, 0x0010);
 	retword = reg_r(gspca_dev, 0x000b) << 8;
 	retword |= reg_r(gspca_dev, 0x000a);
-	PDEBUG(D_PROBE, "probe 3wr vga 1 0x%04x", retword);
+	gspca_dbg(gspca_dev, D_PROBE, "probe 3wr vga 1 0x%04x\n", retword);
 	reg_r(gspca_dev, 0x0010);
 	if ((retword & 0xff00) == 0x6400)
 		return 0x02;		/* TAS5130C */
@@ -6206,7 +6206,7 @@ static int vga_3wr_probe(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x01, 0x0012);
 	retword = i2c_read(gspca_dev, 0x00);
 	if (retword != 0) {
-		PDEBUG(D_PROBE, "probe 3wr vga type 0a");
+		gspca_dbg(gspca_dev, D_PROBE, "probe 3wr vga type 0a\n");
 		return 0x0a;			/* PB0330 */
 	}
 
@@ -6220,7 +6220,8 @@ static int vga_3wr_probe(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x01, 0x0012);
 	retword = i2c_read(gspca_dev, 0x00);
 	if (retword != 0) {
-		PDEBUG(D_PROBE, "probe 3wr vga type %02x", retword);
+		gspca_dbg(gspca_dev, D_PROBE, "probe 3wr vga type %02x\n",
+			  retword);
 		if (retword == 0x0011)			/* gc0303 */
 			return 0x0303;
 		if (retword == 0x0029)			/* gc0305 */
@@ -6251,12 +6252,13 @@ static int vga_3wr_probe(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x05, 0x0012);
 	retword = i2c_read(gspca_dev, 0x00) << 8;	/* ID 0 */
 	retword |= i2c_read(gspca_dev, 0x01);		/* ID 1 */
-	PDEBUG(D_PROBE, "probe 3wr vga 2 0x%04x", retword);
+	gspca_dbg(gspca_dev, D_PROBE, "probe 3wr vga 2 0x%04x\n", retword);
 	if (retword == 0x2030) {
 		u8 retbyte;
 
 		retbyte = i2c_read(gspca_dev, 0x02);	/* revision number */
-		PDEBUG(D_PROBE, "sensor PO2030 rev 0x%02x", retbyte);
+		gspca_dbg(gspca_dev, D_PROBE, "sensor PO2030 rev 0x%02x\n",
+			  retbyte);
 
 		send_unknown(gspca_dev, SENSOR_PO2030);
 		return retword;
@@ -6272,7 +6274,8 @@ static int vga_3wr_probe(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0xd3, 0x008b);
 	retword = i2c_read(gspca_dev, 0x01);
 	if (retword != 0) {
-		PDEBUG(D_PROBE, "probe 3wr vga type 0a ? ret: %04x", retword);
+		gspca_dbg(gspca_dev, D_PROBE, "probe 3wr vga type 0a ? ret: %04x\n",
+			  retword);
 		return 0x16;			/* adcm2700 (6100/6200) */
 	}
 	return -1;
@@ -6490,19 +6493,20 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	sensor = zcxx_probeSensor(gspca_dev);
 	if (sensor >= 0)
-		PDEBUG(D_PROBE, "probe sensor -> %04x", sensor);
+		gspca_dbg(gspca_dev, D_PROBE, "probe sensor -> %04x\n", sensor);
 	if ((unsigned) force_sensor < SENSOR_MAX) {
 		sd->sensor = force_sensor;
-		PDEBUG(D_PROBE, "sensor forced to %d", force_sensor);
+		gspca_dbg(gspca_dev, D_PROBE, "sensor forced to %d\n",
+			  force_sensor);
 	} else {
 		switch (sensor) {
 		case -1:
 			switch (sd->sensor) {
 			case SENSOR_MC501CB:
-				PDEBUG(D_PROBE, "Sensor MC501CB");
+				gspca_dbg(gspca_dev, D_PROBE, "Sensor MC501CB\n");
 				break;
 			case SENSOR_GC0303:
-				PDEBUG(D_PROBE, "Sensor GC0303");
+				gspca_dbg(gspca_dev, D_PROBE, "Sensor GC0303\n");
 				break;
 			default:
 				pr_warn("Unknown sensor - set to TAS5130C\n");
@@ -6512,100 +6516,101 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		case 0:
 			/* check the sensor type */
 			sensor = i2c_read(gspca_dev, 0x00);
-			PDEBUG(D_PROBE, "Sensor hv7131 type %d", sensor);
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor hv7131 type %d\n",
+				  sensor);
 			switch (sensor) {
 			case 0:			/* hv7131b */
 			case 1:			/* hv7131e */
-				PDEBUG(D_PROBE, "Find Sensor HV7131B");
+				gspca_dbg(gspca_dev, D_PROBE, "Find Sensor HV7131B\n");
 				sd->sensor = SENSOR_HV7131B;
 				break;
 			default:
 /*			case 2:			 * hv7131r */
-				PDEBUG(D_PROBE, "Find Sensor HV7131R");
+				gspca_dbg(gspca_dev, D_PROBE, "Find Sensor HV7131R\n");
 				sd->sensor = SENSOR_HV7131R;
 				break;
 			}
 			break;
 		case 0x02:
-			PDEBUG(D_PROBE, "Sensor TAS5130C");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor TAS5130C\n");
 			sd->sensor = SENSOR_TAS5130C;
 			break;
 		case 0x04:
-			PDEBUG(D_PROBE, "Find Sensor CS2102");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor CS2102\n");
 			sd->sensor = SENSOR_CS2102;
 			break;
 		case 0x08:
-			PDEBUG(D_PROBE, "Find Sensor HDCS2020");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor HDCS2020\n");
 			sd->sensor = SENSOR_HDCS2020;
 			break;
 		case 0x0a:
-			PDEBUG(D_PROBE,
-				"Find Sensor PB0330. Chip revision %x",
-				sd->chip_revision);
+			gspca_dbg(gspca_dev, D_PROBE,
+				  "Find Sensor PB0330. Chip revision %x\n",
+				  sd->chip_revision);
 			sd->sensor = SENSOR_PB0330;
 			break;
 		case 0x0c:
-			PDEBUG(D_PROBE, "Find Sensor ICM105A");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor ICM105A\n");
 			sd->sensor = SENSOR_ICM105A;
 			break;
 		case 0x0e:
-			PDEBUG(D_PROBE, "Find Sensor PAS202B");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor PAS202B\n");
 			sd->sensor = SENSOR_PAS202B;
 			break;
 		case 0x0f:
-			PDEBUG(D_PROBE, "Find Sensor PAS106");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor PAS106\n");
 			sd->sensor = SENSOR_PAS106;
 			break;
 		case 0x10:
 		case 0x12:
-			PDEBUG(D_PROBE, "Find Sensor TAS5130C");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor TAS5130C\n");
 			sd->sensor = SENSOR_TAS5130C;
 			break;
 		case 0x11:
-			PDEBUG(D_PROBE, "Find Sensor HV7131R");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor HV7131R\n");
 			sd->sensor = SENSOR_HV7131R;
 			break;
 		case 0x13:
 		case 0x15:
-			PDEBUG(D_PROBE,
-				"Sensor MT9V111. Chip revision %04x",
-				sd->chip_revision);
+			gspca_dbg(gspca_dev, D_PROBE,
+				  "Sensor MT9V111. Chip revision %04x\n",
+				  sd->chip_revision);
 			sd->sensor = sd->bridge == BRIDGE_ZC301
 					? SENSOR_MT9V111_1
 					: SENSOR_MT9V111_3;
 			break;
 		case 0x14:
-			PDEBUG(D_PROBE,
-				"Find Sensor CS2102K?. Chip revision %x",
-				sd->chip_revision);
+			gspca_dbg(gspca_dev, D_PROBE,
+				  "Find Sensor CS2102K?. Chip revision %x\n",
+				  sd->chip_revision);
 			sd->sensor = SENSOR_CS2102K;
 			break;
 		case 0x16:
-			PDEBUG(D_PROBE, "Find Sensor ADCM2700");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor ADCM2700\n");
 			sd->sensor = SENSOR_ADCM2700;
 			break;
 		case 0x29:
-			PDEBUG(D_PROBE, "Find Sensor GC0305");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor GC0305\n");
 			sd->sensor = SENSOR_GC0305;
 			break;
 		case 0x0303:
-			PDEBUG(D_PROBE, "Sensor GC0303");
+			gspca_dbg(gspca_dev, D_PROBE, "Sensor GC0303\n");
 			sd->sensor =  SENSOR_GC0303;
 			break;
 		case 0x2030:
-			PDEBUG(D_PROBE, "Find Sensor PO2030");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor PO2030\n");
 			sd->sensor = SENSOR_PO2030;
 			break;
 		case 0x7620:
-			PDEBUG(D_PROBE, "Find Sensor OV7620");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor OV7620\n");
 			sd->sensor = SENSOR_OV7620;
 			break;
 		case 0x7631:
-			PDEBUG(D_PROBE, "Find Sensor OV7630C");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor OV7630C\n");
 			sd->sensor = SENSOR_OV7630C;
 			break;
 		case 0x7648:
-			PDEBUG(D_PROBE, "Find Sensor OV7648");
+			gspca_dbg(gspca_dev, D_PROBE, "Find Sensor OV7648\n");
 			sd->sensor = SENSOR_OV7620;	/* same sensor (?) */
 			break;
 		default:
-- 
2.10.0.rc2.1.g053435c
