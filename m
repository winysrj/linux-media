Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:42863 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751795AbdIVSdo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 14:33:44 -0400
From: Joe Perches <joe@perches.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Olivier Lorin <o.lorin@laposte.net>,
        Erik Andren <erik.andren@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gspca: Convert PERR to gspca_err
Date: Fri, 22 Sep 2017 11:33:35 -0700
Message-Id: <ba627dfeca07501d9dad07d21a447d6f2c294350.1506103226.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a more typical kernel logging style.

The current macro hides the gspca_dev argument so add it to the
macro uses instead.

Miscellanea:

o Add missing '\n' terminations to formats
o Realign arguments to open parenthesis

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/usb/gspca/benq.c             |  6 +--
 drivers/media/usb/gspca/conex.c            |  6 +--
 drivers/media/usb/gspca/cpia1.c            | 24 ++++++-----
 drivers/media/usb/gspca/dtcs033.c          | 12 +++---
 drivers/media/usb/gspca/etoms.c            |  4 +-
 drivers/media/usb/gspca/gl860/gl860.c      |  2 +-
 drivers/media/usb/gspca/gspca.c            | 26 +++++++-----
 drivers/media/usb/gspca/gspca.h            |  4 +-
 drivers/media/usb/gspca/jeilinj.c          |  2 +-
 drivers/media/usb/gspca/konica.c           | 26 ++++++------
 drivers/media/usb/gspca/m5602/m5602_core.c |  2 +-
 drivers/media/usb/gspca/mr97310a.c         |  6 +--
 drivers/media/usb/gspca/ov519.c            | 65 ++++++++++++++++--------------
 drivers/media/usb/gspca/ov534.c            |  4 +-
 drivers/media/usb/gspca/pac7302.c          |  2 +-
 drivers/media/usb/gspca/pac7311.c          |  2 +-
 drivers/media/usb/gspca/sn9c2028.c         |  4 +-
 drivers/media/usb/gspca/sonixj.c           |  4 +-
 drivers/media/usb/gspca/spca1528.c         |  4 +-
 drivers/media/usb/gspca/spca500.c          | 36 ++++++++---------
 drivers/media/usb/gspca/spca501.c          |  4 +-
 drivers/media/usb/gspca/spca505.c          |  2 +-
 drivers/media/usb/gspca/spca508.c          |  3 +-
 drivers/media/usb/gspca/spca561.c          |  2 +-
 drivers/media/usb/gspca/sq905.c            |  2 +-
 drivers/media/usb/gspca/sq905c.c           |  6 +--
 drivers/media/usb/gspca/sq930x.c           |  2 +-
 drivers/media/usb/gspca/stv0680.c          | 16 ++++----
 drivers/media/usb/gspca/stv06xx/stv06xx.c  | 10 ++---
 drivers/media/usb/gspca/sunplus.c          |  2 +-
 drivers/media/usb/gspca/touptek.c          | 38 +++++++++--------
 drivers/media/usb/gspca/w996Xcf.c          |  2 +-
 32 files changed, 174 insertions(+), 156 deletions(-)

diff --git a/drivers/media/usb/gspca/benq.c b/drivers/media/usb/gspca/benq.c
index 60a728203b3b..b5955bf0d0fc 100644
--- a/drivers/media/usb/gspca/benq.c
+++ b/drivers/media/usb/gspca/benq.c
@@ -180,9 +180,9 @@ static void sd_isoc_irq(struct urb *urb)
 		/* check the packet status and length */
 		if (urb0->iso_frame_desc[i].actual_length != SD_PKT_SZ
 		    || urb->iso_frame_desc[i].actual_length != SD_PKT_SZ) {
-			PERR("ISOC bad lengths %d / %d",
-				urb0->iso_frame_desc[i].actual_length,
-				urb->iso_frame_desc[i].actual_length);
+			gspca_err(gspca_dev, "ISOC bad lengths %d / %d\n",
+				  urb0->iso_frame_desc[i].actual_length,
+				  urb->iso_frame_desc[i].actual_length);
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			continue;
 		}
diff --git a/drivers/media/usb/gspca/conex.c b/drivers/media/usb/gspca/conex.c
index bdcdf7999c56..0223b33156dd 100644
--- a/drivers/media/usb/gspca/conex.c
+++ b/drivers/media/usb/gspca/conex.c
@@ -70,7 +70,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	struct usb_device *dev = gspca_dev->dev;
 
 	if (len > USB_BUF_SZ) {
-		PERR("reg_r: buffer overflow\n");
+		gspca_err(gspca_dev, "reg_r: buffer overflow\n");
 		return;
 	}
 
@@ -109,7 +109,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 	struct usb_device *dev = gspca_dev->dev;
 
 	if (len > USB_BUF_SZ) {
-		PERR("reg_w: buffer overflow\n");
+		gspca_err(gspca_dev, "reg_w: buffer overflow\n");
 		return;
 	}
 	PDEBUG(D_USBO, "reg write [%02x] = %02x..", index, *buffer);
@@ -683,7 +683,7 @@ static void cx11646_jpeg(struct gspca_dev*gspca_dev)
 		reg_w_val(gspca_dev, 0x0053, 0x00);
 	} while (--retry);
 	if (retry == 0)
-		PERR("Damned Errors sending jpeg Table");
+		gspca_err(gspca_dev, "Damned Errors sending jpeg Table\n");
 	/* send the qtable now */
 	reg_r(gspca_dev, 0x0001, 1);		/* -> 0x18 */
 	length = 8;
diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index e91d00762e94..99b456d64729 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -419,7 +419,8 @@ static int cpia_usb_transferCmd(struct gspca_dev *gspca_dev, u8 *command)
 		pipe = usb_sndctrlpipe(gspca_dev->dev, 0);
 		requesttype = USB_TYPE_VENDOR | USB_RECIP_DEVICE;
 	} else {
-		PERR("Unexpected first byte of command: %x", command[0]);
+		gspca_err(gspca_dev, "Unexpected first byte of command: %x\n",
+			  command[0]);
 		return -EINVAL;
 	}
 
@@ -722,8 +723,8 @@ static int goto_low_power(struct gspca_dev *gspca_dev)
 
 	if (sd->params.status.systemState != LO_POWER_STATE) {
 		if (sd->params.status.systemState != WARM_BOOT_STATE) {
-			PERR("unexpected state after lo power cmd: %02x",
-			     sd->params.status.systemState);
+			gspca_err(gspca_dev, "unexpected state after lo power cmd: %02x\n",
+				  sd->params.status.systemState);
 			printstatus(gspca_dev, &sd->params);
 		}
 		return -EIO;
@@ -752,8 +753,8 @@ static int goto_high_power(struct gspca_dev *gspca_dev)
 		return ret;
 
 	if (sd->params.status.systemState != HI_POWER_STATE) {
-		PERR("unexpected state after hi power cmd: %02x",
-		     sd->params.status.systemState);
+		gspca_err(gspca_dev, "unexpected state after hi power cmd: %02x\n",
+			  sd->params.status.systemState);
 		printstatus(gspca_dev, &sd->params);
 		return -EIO;
 	}
@@ -1445,8 +1446,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	sd->params.version.firmwareVersion = 0;
 	get_version_information(gspca_dev);
 	if (sd->params.version.firmwareVersion != 1) {
-		PERR("only firmware version 1 is supported (got: %d)",
-		     sd->params.version.firmwareVersion);
+		gspca_err(gspca_dev, "only firmware version 1 is supported (got: %d)\n",
+			  sd->params.version.firmwareVersion);
 		return -ENODEV;
 	}
 
@@ -1471,8 +1472,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* Start the camera in low power mode */
 	if (goto_low_power(gspca_dev)) {
 		if (sd->params.status.systemState != WARM_BOOT_STATE) {
-			PERR("unexpected systemstate: %02x",
-			     sd->params.status.systemState);
+			gspca_err(gspca_dev, "unexpected systemstate: %02x\n",
+				  sd->params.status.systemState);
 			printstatus(gspca_dev, &sd->params);
 			return -ENODEV;
 		}
@@ -1519,8 +1520,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		return ret;
 
 	if (sd->params.status.fatalError) {
-		PERR("fatal_error: %04x, vp_status: %04x",
-		     sd->params.status.fatalError, sd->params.status.vpStatus);
+		gspca_err(gspca_dev, "fatal_error: %04x, vp_status: %04x\n",
+			  sd->params.status.fatalError,
+			  sd->params.status.vpStatus);
 		return -EIO;
 	}
 
diff --git a/drivers/media/usb/gspca/dtcs033.c b/drivers/media/usb/gspca/dtcs033.c
index 96bfd4e0f0eb..b4d42940d5de 100644
--- a/drivers/media/usb/gspca/dtcs033.c
+++ b/drivers/media/usb/gspca/dtcs033.c
@@ -71,8 +71,8 @@ static int reg_reqs(struct gspca_dev *gspca_dev,
 
 		if (gspca_dev->usb_err < 0) {
 
-			PERR("usb error request no: %d / %d\n",
-				i, n_reqs);
+			gspca_err(gspca_dev, "usb error request no: %d / %d\n",
+				  i, n_reqs);
 		} else if (preq->bRequestType & USB_DIR_IN) {
 
 			PDEBUG(D_STREAM,
@@ -176,12 +176,12 @@ static void dtcs033_setexposure(struct gspca_dev *gspca_dev,
 	reg_rw(gspca_dev,
 		bRequestType, bRequest, wValue, wIndex, 0);
 	if (gspca_dev->usb_err < 0)
-		PERR("usb error in setexposure(gain) sequence.\n");
+		gspca_err(gspca_dev, "usb error in setexposure(gain) sequence\n");
 
 	reg_rw(gspca_dev,
 		bRequestType, bRequest, (xtimeVal<<4), 0x6300, 0);
 	if (gspca_dev->usb_err < 0)
-		PERR("usb error in setexposure(time) sequence.\n");
+		gspca_err(gspca_dev, "usb error in setexposure(time) sequence\n");
 }
 
 /* specific webcam descriptor */
@@ -239,8 +239,8 @@ static int dtcs033_init_controls(struct gspca_dev *gspca_dev)
 				V4L2_CID_GAIN,
 				14,  33,  1,  24);/* [dB] */
 	if (hdl->error) {
-		PERR("Could not initialize controls: %d\n",
-			hdl->error);
+		gspca_err(gspca_dev, "Could not initialize controls: %d\n",
+			  hdl->error);
 		return hdl->error;
 	}
 
diff --git a/drivers/media/usb/gspca/etoms.c b/drivers/media/usb/gspca/etoms.c
index 8f84292936e9..a88ae69d6c1e 100644
--- a/drivers/media/usb/gspca/etoms.c
+++ b/drivers/media/usb/gspca/etoms.c
@@ -160,7 +160,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	struct usb_device *dev = gspca_dev->dev;
 
 	if (len > USB_BUF_SZ) {
-		PERR("reg_r: buffer overflow\n");
+		gspca_err(gspca_dev, "reg_r: buffer overflow\n");
 		return;
 	}
 
@@ -268,7 +268,7 @@ static int et_video(struct gspca_dev *gspca_dev,
 		     : 0);		/* stopvideo */
 	ret = Et_WaitStatus(gspca_dev);
 	if (ret != 0)
-		PERR("timeout video on/off");
+		gspca_err(gspca_dev, "timeout video on/off\n");
 	return ret;
 }
 
diff --git a/drivers/media/usb/gspca/gl860/gl860.c b/drivers/media/usb/gspca/gl860/gl860.c
index cea8d7f51c3c..add298cc9ab2 100644
--- a/drivers/media/usb/gspca/gl860/gl860.c
+++ b/drivers/media/usb/gspca/gl860/gl860.c
@@ -582,7 +582,7 @@ int gl860_RTx(struct gspca_dev *gspca_dev,
 		pr_err("ctrl transfer failed %4d [p%02x r%d v%04x i%04x len%d]\n",
 		       r, pref, req, val, index, len);
 	else if (len > 1 && r < len)
-		PERR("short ctrl transfer %d/%d", r, len);
+		gspca_err(gspca_dev, "short ctrl transfer %d/%d\n", r, len);
 
 	msleep(1);
 
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 0f141762abf1..ebbe301dc80d 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -122,7 +122,7 @@ static void int_irq(struct urb *urb)
 	case 0:
 		if (gspca_dev->sd_desc->int_pkt_scan(gspca_dev,
 		    urb->transfer_buffer, urb->actual_length) < 0) {
-			PERR("Unknown packet received");
+			gspca_err(gspca_dev, "Unknown packet received\n");
 		}
 		break;
 
@@ -136,7 +136,8 @@ static void int_irq(struct urb *urb)
 		break;
 
 	default:
-		PERR("URB error %i, resubmitting", urb->status);
+		gspca_err(gspca_dev, "URB error %i, resubmitting\n",
+			  urb->status);
 		urb->status = 0;
 		ret = 0;
 	}
@@ -221,7 +222,8 @@ static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
-		PERR("submit int URB failed with error %i", ret);
+		gspca_err(gspca_dev, "submit int URB failed with error %i\n",
+			  ret);
 		goto error_submit;
 	}
 	gspca_dev->int_urb = urb;
@@ -307,7 +309,7 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 		if (gspca_dev->frozen)
 			return;
 #endif
-		PERR("urb status: %d", urb->status);
+		gspca_err(gspca_dev, "urb status: %d\n", urb->status);
 		urb->status = 0;
 		goto resubmit;
 	}
@@ -380,7 +382,7 @@ static void bulk_irq(struct urb *urb)
 		if (gspca_dev->frozen)
 			return;
 #endif
-		PERR("urb status: %d", urb->status);
+		gspca_err(gspca_dev, "urb status: %d\n", urb->status);
 		urb->status = 0;
 		goto resubmit;
 	}
@@ -452,9 +454,9 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 	/* append the packet to the frame buffer */
 	if (len > 0) {
 		if (gspca_dev->image_len + len > gspca_dev->frsz) {
-			PERR("frame overflow %d > %d",
-				gspca_dev->image_len + len,
-				gspca_dev->frsz);
+			gspca_err(gspca_dev, "frame overflow %d > %d\n",
+				  gspca_dev->image_len + len,
+				  gspca_dev->frsz);
 			packet_type = DISCARD_PACKET;
 		} else {
 /* !! image is NULL only when last pkt is LAST or DISCARD
@@ -952,7 +954,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 		/* the bandwidth is not wide enough
 		 * negotiate or try a lower alternate setting */
 retry:
-		PERR("alt %d - bandwidth not wide enough, trying again", alt);
+		gspca_err(gspca_dev, "alt %d - bandwidth not wide enough, trying again\n",
+			  alt);
 		msleep(20);	/* wait for kill complete */
 		if (gspca_dev->sd_desc->isoc_nego) {
 			ret = gspca_dev->sd_desc->isoc_nego(gspca_dev);
@@ -1739,7 +1742,7 @@ static int vidioc_dqbuf(struct file *file, void *priv,
 		if (copy_to_user((__u8 __user *) frame->v4l2_buf.m.userptr,
 				 frame->data,
 				 frame->v4l2_buf.bytesused)) {
-			PERR("dqbuf cp to user failed");
+			gspca_err(gspca_dev, "dqbuf cp to user failed\n");
 			ret = -EFAULT;
 		}
 	}
@@ -1951,7 +1954,8 @@ static ssize_t dev_read(struct file *file, char __user *data,
 		count = frame->v4l2_buf.bytesused;
 	ret = copy_to_user(data, frame->data, count);
 	if (ret != 0) {
-		PERR("read cp to user lack %d / %zd", ret, count);
+		gspca_err(gspca_dev, "read cp to user lack %d / %zd\n",
+			  ret, count);
 		ret = -EFAULT;
 		goto out;
 	}
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index d39adf90303b..635976706f35 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -28,8 +28,8 @@ extern int gspca_debug;
 #define PDEBUG(level, fmt, ...) \
 	v4l2_dbg(level, gspca_debug, &gspca_dev->v4l2_dev, fmt, ##__VA_ARGS__)
 
-#define PERR(fmt, ...) \
-	v4l2_err(&gspca_dev->v4l2_dev, fmt, ##__VA_ARGS__)
+#define gspca_err(gspca_dev, fmt, ...)				\
+	v4l2_err(&(gspca_dev)->v4l2_dev, fmt, ##__VA_ARGS__)
 
 #define GSPCA_MAX_FRAMES 16	/* maximum number of video frame buffers */
 /* image transfers */
diff --git a/drivers/media/usb/gspca/jeilinj.c b/drivers/media/usb/gspca/jeilinj.c
index 34e043b7d1bc..7215c6879070 100644
--- a/drivers/media/usb/gspca/jeilinj.c
+++ b/drivers/media/usb/gspca/jeilinj.c
@@ -262,7 +262,7 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 	msleep(2);
 	setfreq(gspca_dev, v4l2_ctrl_g_ctrl(sd->freq));
 	if (gspca_dev->usb_err < 0)
-		PERR("Start streaming command failed");
+		gspca_err(gspca_dev, "Start streaming command failed\n");
 	return gspca_dev->usb_err;
 }
 
diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/konica.c
index 31b2117e8f1d..d51aca01167f 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -274,7 +274,7 @@ static void sd_isoc_irq(struct urb *urb)
 		if (gspca_dev->frozen)
 			return;
 #endif
-		PERR("urb status: %d", urb->status);
+		gspca_err(gspca_dev, "urb status: %d\n", urb->status);
 		st = usb_submit_urb(urb, GFP_ATOMIC);
 		if (st < 0)
 			pr_err("resubmit urb error %d\n", st);
@@ -292,30 +292,31 @@ static void sd_isoc_irq(struct urb *urb)
 	sd->last_data_urb = NULL;
 
 	if (!data_urb || data_urb->start_frame != status_urb->start_frame) {
-		PERR("lost sync on frames");
+		gspca_err(gspca_dev, "lost sync on frames\n");
 		goto resubmit;
 	}
 
 	if (data_urb->number_of_packets != status_urb->number_of_packets) {
-		PERR("no packets does not match, data: %d, status: %d",
-		     data_urb->number_of_packets,
-		     status_urb->number_of_packets);
+		gspca_err(gspca_dev, "no packets does not match, data: %d, status: %d\n",
+			  data_urb->number_of_packets,
+			  status_urb->number_of_packets);
 		goto resubmit;
 	}
 
 	for (i = 0; i < status_urb->number_of_packets; i++) {
 		if (data_urb->iso_frame_desc[i].status ||
 		    status_urb->iso_frame_desc[i].status) {
-			PERR("pkt %d data-status %d, status-status %d", i,
-			     data_urb->iso_frame_desc[i].status,
-			     status_urb->iso_frame_desc[i].status);
+			gspca_err(gspca_dev, "pkt %d data-status %d, status-status %d\n",
+				  i,
+				  data_urb->iso_frame_desc[i].status,
+				  status_urb->iso_frame_desc[i].status);
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			continue;
 		}
 
 		if (status_urb->iso_frame_desc[i].actual_length != 1) {
-			PERR("bad status packet length %d",
-			     status_urb->iso_frame_desc[i].actual_length);
+			gspca_err(gspca_dev, "bad status packet length %d\n",
+				  status_urb->iso_frame_desc[i].actual_length);
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			continue;
 		}
@@ -360,11 +361,12 @@ static void sd_isoc_irq(struct urb *urb)
 	if (data_urb) {
 		st = usb_submit_urb(data_urb, GFP_ATOMIC);
 		if (st < 0)
-			PERR("usb_submit_urb(data_urb) ret %d", st);
+			gspca_err(gspca_dev, "usb_submit_urb(data_urb) ret %d\n",
+				  st);
 	}
 	st = usb_submit_urb(status_urb, GFP_ATOMIC);
 	if (st < 0)
-		PERR("usb_submit_urb(status_urb) ret %d\n", st);
+		gspca_err(gspca_dev, "usb_submit_urb(status_urb) ret %d\n", st);
 }
 
 static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/usb/gspca/m5602/m5602_core.c b/drivers/media/usb/gspca/m5602/m5602_core.c
index f1dcd9021983..4aab17efa4cc 100644
--- a/drivers/media/usb/gspca/m5602/m5602_core.c
+++ b/drivers/media/usb/gspca/m5602/m5602_core.c
@@ -397,7 +397,7 @@ static int m5602_configure(struct gspca_dev *gspca_dev,
 	return 0;
 
 fail:
-	PERR("ALi m5602 webcam failed");
+	gspca_err(gspca_dev, "ALi m5602 webcam failed\n");
 	cam->cam_mode = NULL;
 	cam->nmodes = 0;
 
diff --git a/drivers/media/usb/gspca/mr97310a.c b/drivers/media/usb/gspca/mr97310a.c
index 8b0e32a649ac..34aacaee4453 100644
--- a/drivers/media/usb/gspca/mr97310a.c
+++ b/drivers/media/usb/gspca/mr97310a.c
@@ -284,7 +284,7 @@ static int zero_the_pointer(struct gspca_dev *gspca_dev)
 			return err_code;
 	}
 	if (status != 0x0a)
-		PERR("status is %02x", status);
+		gspca_err(gspca_dev, "status is %02x\n", status);
 
 	tries = 0;
 	while (tries < 4) {
@@ -325,7 +325,7 @@ static void stream_stop(struct gspca_dev *gspca_dev)
 	gspca_dev->usb_buf[0] = 0x01;
 	gspca_dev->usb_buf[1] = 0x00;
 	if (mr_write(gspca_dev, 2) < 0)
-		PERR("Stream Stop failed");
+		gspca_err(gspca_dev, "Stream Stop failed\n");
 }
 
 static void lcd_stop(struct gspca_dev *gspca_dev)
@@ -333,7 +333,7 @@ static void lcd_stop(struct gspca_dev *gspca_dev)
 	gspca_dev->usb_buf[0] = 0x19;
 	gspca_dev->usb_buf[1] = 0x54;
 	if (mr_write(gspca_dev, 2) < 0)
-		PERR("LCD Stop failed");
+		gspca_err(gspca_dev, "LCD Stop failed\n");
 }
 
 static int isoc_enable(struct gspca_dev *gspca_dev)
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index cdb79c5f0c38..fa541dfbe3a8 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2039,7 +2039,7 @@ static void reg_w(struct sd *sd, u16 index, u16 value)
 			sd->gspca_dev.usb_buf, 1, 500);
 leave:
 	if (ret < 0) {
-		PERR("reg_w %02x failed %d\n", index, ret);
+		gspca_err(gspca_dev, "reg_w %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 		return;
 	}
@@ -2081,7 +2081,7 @@ static int reg_r(struct sd *sd, u16 index)
 		PDEBUG(D_USBI, "GET %02x 0000 %04x %02x",
 			req, index, ret);
 	} else {
-		PERR("reg_r %02x failed %d\n", index, ret);
+		gspca_err(gspca_dev, "reg_r %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2109,7 +2109,7 @@ static int reg_r8(struct sd *sd,
 	if (ret >= 0) {
 		ret = sd->gspca_dev.usb_buf[0];
 	} else {
-		PERR("reg_r8 %02x failed %d\n", index, ret);
+		gspca_err(gspca_dev, "reg_r8 %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2165,7 +2165,7 @@ static void ov518_reg_w32(struct sd *sd, u16 index, u32 value, int n)
 			0, index,
 			sd->gspca_dev.usb_buf, n, 500);
 	if (ret < 0) {
-		PERR("reg_w32 %02x failed %d\n", index, ret);
+		gspca_err(gspca_dev, "reg_w32 %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 }
@@ -2340,7 +2340,7 @@ static void ovfx2_i2c_w(struct sd *sd, u8 reg, u8 value)
 			(u16) value, (u16) reg, NULL, 0, 500);
 
 	if (ret < 0) {
-		PERR("ovfx2_i2c_w %02x failed %d\n", reg, ret);
+		gspca_err(gspca_dev, "ovfx2_i2c_w %02x failed %d\n", reg, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2365,7 +2365,7 @@ static int ovfx2_i2c_r(struct sd *sd, u8 reg)
 		ret = sd->gspca_dev.usb_buf[0];
 		PDEBUG(D_USBI, "ovfx2_i2c_r %02x %02x", reg, ret);
 	} else {
-		PERR("ovfx2_i2c_r %02x failed %d\n", reg, ret);
+		gspca_err(gspca_dev, "ovfx2_i2c_r %02x failed %d\n", reg, ret);
 		sd->gspca_dev.usb_err = ret;
 	}
 
@@ -2617,7 +2617,7 @@ static void ov_hires_configure(struct sd *sd)
 	int high, low;
 
 	if (sd->bridge != BRIDGE_OVFX2) {
-		PERR("error hires sensors only supported with ovfx2\n");
+		gspca_err(gspca_dev, "error hires sensors only supported with ovfx2\n");
 		return;
 	}
 
@@ -2652,7 +2652,8 @@ static void ov_hires_configure(struct sd *sd)
 		}
 		break;
 	}
-	PERR("Error unknown sensor type: %02x%02x\n", high, low);
+	gspca_err(gspca_dev, "Error unknown sensor type: %02x%02x\n",
+		  high, low);
 }
 
 /* This initializes the OV8110, OV8610 sensor. The OV8110 uses
@@ -2668,13 +2669,14 @@ static void ov8xx0_configure(struct sd *sd)
 	/* Detect sensor (sub)type */
 	rc = i2c_r(sd, OV7610_REG_COM_I);
 	if (rc < 0) {
-		PERR("Error detecting sensor type");
+		gspca_err(gspca_dev, "Error detecting sensor type\n");
 		return;
 	}
 	if ((rc & 3) == 1)
 		sd->sensor = SEN_OV8610;
 	else
-		PERR("Unknown image sensor version: %d\n", rc & 3);
+		gspca_err(gspca_dev, "Unknown image sensor version: %d\n",
+			  rc & 3);
 }
 
 /* This initializes the OV7610, OV7620, or OV76BE sensor. The OV76BE uses
@@ -2693,7 +2695,7 @@ static void ov7xx0_configure(struct sd *sd)
 	/* add OV7670 here
 	 * it appears to be wrongly detected as a 7610 by default */
 	if (rc < 0) {
-		PERR("Error detecting sensor type\n");
+		gspca_err(gspca_dev, "Error detecting sensor type\n");
 		return;
 	}
 	if ((rc & 3) == 3) {
@@ -2721,19 +2723,19 @@ static void ov7xx0_configure(struct sd *sd)
 		/* try to read product id registers */
 		high = i2c_r(sd, 0x0a);
 		if (high < 0) {
-			PERR("Error detecting camera chip PID\n");
+			gspca_err(gspca_dev, "Error detecting camera chip PID\n");
 			return;
 		}
 		low = i2c_r(sd, 0x0b);
 		if (low < 0) {
-			PERR("Error detecting camera chip VER\n");
+			gspca_err(gspca_dev, "Error detecting camera chip VER\n");
 			return;
 		}
 		if (high == 0x76) {
 			switch (low) {
 			case 0x30:
-				PERR("Sensor is an OV7630/OV7635\n");
-				PERR("7630 is not supported by this driver\n");
+				gspca_err(gspca_dev, "Sensor is an OV7630/OV7635\n");
+				gspca_err(gspca_dev, "7630 is not supported by this driver\n");
 				return;
 			case 0x40:
 				PDEBUG(D_PROBE, "Sensor is an OV7645");
@@ -2752,7 +2754,8 @@ static void ov7xx0_configure(struct sd *sd)
 				sd->sensor = SEN_OV7660;
 				break;
 			default:
-				PERR("Unknown sensor: 0x76%02x\n", low);
+				gspca_err(gspca_dev, "Unknown sensor: 0x76%02x\n",
+					  low);
 				return;
 			}
 		} else {
@@ -2760,7 +2763,8 @@ static void ov7xx0_configure(struct sd *sd)
 			sd->sensor = SEN_OV7620;
 		}
 	} else {
-		PERR("Unknown image sensor version: %d\n", rc & 3);
+		gspca_err(gspca_dev, "Unknown image sensor version: %d\n",
+			  rc & 3);
 	}
 }
 
@@ -2775,7 +2779,7 @@ static void ov6xx0_configure(struct sd *sd)
 	/* Detect sensor (sub)type */
 	rc = i2c_r(sd, OV7610_REG_COM_I);
 	if (rc < 0) {
-		PERR("Error detecting sensor type\n");
+		gspca_err(gspca_dev, "Error detecting sensor type\n");
 		return;
 	}
 
@@ -2804,7 +2808,8 @@ static void ov6xx0_configure(struct sd *sd)
 		pr_warn("WARNING: Sensor is an OV66307. Your camera may have been misdetected in previous driver versions.\n");
 		break;
 	default:
-		PERR("FATAL: Unknown sensor version: 0x%02x\n", rc);
+		gspca_err(gspca_dev, "FATAL: Unknown sensor version: 0x%02x\n",
+			  rc);
 		return;
 	}
 
@@ -3295,7 +3300,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	} else if (init_ov_sensor(sd, OV_HIRES_SID) >= 0) {
 		ov_hires_configure(sd);
 	} else {
-		PERR("Can't determine sensor slave IDs\n");
+		gspca_err(gspca_dev, "Can't determine sensor slave IDs\n");
 		goto error;
 	}
 
@@ -3428,7 +3433,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	}
 	return gspca_dev->usb_err;
 error:
-	PERR("OV519 Config failed");
+	gspca_err(gspca_dev, "OV519 Config failed\n");
 	return -EINVAL;
 }
 
@@ -3463,7 +3468,7 @@ static void ov511_mode_init_regs(struct sd *sd)
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt) {
-		PERR("Couldn't get altsetting\n");
+		gspca_err(gspca_dev, "Couldn't get altsetting\n");
 		sd->gspca_dev.usb_err = -EIO;
 		return;
 	}
@@ -3589,7 +3594,7 @@ static void ov518_mode_init_regs(struct sd *sd)
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt) {
-		PERR("Couldn't get altsetting\n");
+		gspca_err(gspca_dev, "Couldn't get altsetting\n");
 		sd->gspca_dev.usb_err = -EIO;
 		return;
 	}
@@ -4323,10 +4328,10 @@ static void ov511_pkt_scan(struct gspca_dev *gspca_dev,
 			/* Frame end */
 			if ((in[9] + 1) * 8 != gspca_dev->pixfmt.width ||
 			    (in[10] + 1) * 8 != gspca_dev->pixfmt.height) {
-				PERR("Invalid frame size, got: %dx%d, requested: %dx%d\n",
-					(in[9] + 1) * 8, (in[10] + 1) * 8,
-					gspca_dev->pixfmt.width,
-					gspca_dev->pixfmt.height);
+				gspca_err(gspca_dev, "Invalid frame size, got: %dx%d, requested: %dx%d\n",
+					  (in[9] + 1) * 8, (in[10] + 1) * 8,
+					  gspca_dev->pixfmt.width,
+					  gspca_dev->pixfmt.height);
 				gspca_dev->last_packet_type = DISCARD_PACKET;
 				return;
 			}
@@ -4374,8 +4379,8 @@ static void ov518_pkt_scan(struct gspca_dev *gspca_dev,
 		   except that they may contain part of the footer), are
 		   numbered 0 */
 		else if (sd->packet_nr == 0 || data[len]) {
-			PERR("Invalid packet nr: %d (expect: %d)",
-				(int)data[len], (int)sd->packet_nr);
+			gspca_err(gspca_dev, "Invalid packet nr: %d (expect: %d)\n",
+				  (int)data[len], (int)sd->packet_nr);
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			return;
 		}
@@ -4918,7 +4923,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 			QUALITY_MIN, QUALITY_MAX, 1, QUALITY_DEF);
 
 	if (hdl->error) {
-		PERR("Could not initialize controls\n");
+		gspca_err(gspca_dev, "Could not initialize controls\n");
 		return hdl->error;
 	}
 	if (gspca_dev->autogain)
diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 32849ff86b09..bba2c5ce331c 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -689,8 +689,8 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
 		case 0x03:
 			break;
 		default:
-			PERR("sccb status 0x%02x, attempt %d/5",
-			       data, i + 1);
+			gspca_err(gspca_dev, "sccb status 0x%02x, attempt %d/5\n",
+				  data, i + 1);
 		}
 	}
 	return 0;
diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 595535e143e6..b8ff201c7bb9 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -339,7 +339,7 @@ static void reg_w_var(struct gspca_dev *gspca_dev,
 			break;
 		default:
 			if (len > USB_BUF_SZ) {
-				PERR("Incorrect variable sequence");
+				gspca_err(gspca_dev, "Incorrect variable sequence\n");
 				return;
 			}
 			while (len > 0) {
diff --git a/drivers/media/usb/gspca/pac7311.c b/drivers/media/usb/gspca/pac7311.c
index 8bac2d9326bf..44db4f4afa22 100644
--- a/drivers/media/usb/gspca/pac7311.c
+++ b/drivers/media/usb/gspca/pac7311.c
@@ -258,7 +258,7 @@ static void reg_w_var(struct gspca_dev *gspca_dev,
 			break;
 		default:
 			if (len > USB_BUF_SZ) {
-				PERR("Incorrect variable sequence");
+				gspca_err(gspca_dev, "Incorrect variable sequence\n");
 				return;
 			}
 			while (len > 0) {
diff --git a/drivers/media/usb/gspca/sn9c2028.c b/drivers/media/usb/gspca/sn9c2028.c
index 5d32dd359d84..469bc2ced1a3 100644
--- a/drivers/media/usb/gspca/sn9c2028.c
+++ b/drivers/media/usb/gspca/sn9c2028.c
@@ -849,13 +849,13 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 
 	result = sn9c2028_read1(gspca_dev);
 	if (result < 0)
-		PERR("Camera Stop read failed");
+		gspca_err(gspca_dev, "Camera Stop read failed\n");
 
 	memset(data, 0, 6);
 	data[0] = 0x14;
 	result = sn9c2028_command(gspca_dev, data);
 	if (result < 0)
-		PERR("Camera Stop command failed");
+		gspca_err(gspca_dev, "Camera Stop command failed\n");
 }
 
 static void do_autogain(struct gspca_dev *gspca_dev, int avg_lum)
diff --git a/drivers/media/usb/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
index 5eeaf16ac5e8..9d7c3d8c226f 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -1155,7 +1155,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	if (gspca_dev->usb_err < 0)
 		return;
 	if (len > USB_BUF_SZ) {
-		PERR("reg_r: buffer overflow\n");
+		gspca_err(gspca_dev, "reg_r: buffer overflow\n");
 		return;
 	}
 
@@ -1209,7 +1209,7 @@ static void reg_w(struct gspca_dev *gspca_dev,
 		value, buffer[0], buffer[1]);
 
 	if (len > USB_BUF_SZ) {
-		PERR("reg_w: buffer overflow\n");
+		gspca_err(gspca_dev, "reg_w: buffer overflow\n");
 		return;
 	}
 
diff --git a/drivers/media/usb/gspca/spca1528.c b/drivers/media/usb/gspca/spca1528.c
index 327ec901abe1..e53dd3c7066c 100644
--- a/drivers/media/usb/gspca/spca1528.c
+++ b/drivers/media/usb/gspca/spca1528.c
@@ -142,7 +142,7 @@ static void wait_status_0(struct gspca_dev *gspca_dev)
 		w += 15;
 		msleep(w);
 	} while (--i > 0);
-	PERR("wait_status_0 timeout");
+	gspca_err(gspca_dev, "wait_status_0 timeout\n");
 	gspca_dev->usb_err = -ETIME;
 }
 
@@ -160,7 +160,7 @@ static void wait_status_1(struct gspca_dev *gspca_dev)
 			return;
 		}
 	} while (--i > 0);
-	PERR("wait_status_1 timeout");
+	gspca_err(gspca_dev, "wait_status_1 timeout\n");
 	gspca_dev->usb_err = -ETIME;
 }
 
diff --git a/drivers/media/usb/gspca/spca500.c b/drivers/media/usb/gspca/spca500.c
index da2d9027914c..b25960643f7b 100644
--- a/drivers/media/usb/gspca/spca500.c
+++ b/drivers/media/usb/gspca/spca500.c
@@ -485,7 +485,7 @@ static int spca500_full_reset(struct gspca_dev *gspca_dev)
 		return err;
 	err = reg_r_wait(gspca_dev, 0x06, 0, 0);
 	if (err < 0) {
-		PERR("reg_r_wait() failed");
+		gspca_err(gspca_dev, "reg_r_wait() failed\n");
 		return err;
 	}
 	/* all ok */
@@ -501,7 +501,7 @@ static int spca500_full_reset(struct gspca_dev *gspca_dev)
 static int spca500_synch310(struct gspca_dev *gspca_dev)
 {
 	if (usb_set_interface(gspca_dev->dev, gspca_dev->iface, 0) < 0) {
-		PERR("Set packet size: set interface error");
+		gspca_err(gspca_dev, "Set packet size: set interface error\n");
 		goto error;
 	}
 	spca500_ping310(gspca_dev);
@@ -515,7 +515,7 @@ static int spca500_synch310(struct gspca_dev *gspca_dev)
 	if (usb_set_interface(gspca_dev->dev,
 				gspca_dev->iface,
 				gspca_dev->alt) < 0) {
-		PERR("Set packet size: set interface error");
+		gspca_err(gspca_dev, "Set packet size: set interface error\n");
 		goto error;
 	}
 	return 0;
@@ -540,7 +540,7 @@ static void spca500_reinit(struct gspca_dev *gspca_dev)
 	err = spca50x_setup_qtable(gspca_dev, 0x00, 0x8800, 0x8840,
 				 qtable_pocketdv);
 	if (err < 0)
-		PERR("spca50x_setup_qtable failed on init");
+		gspca_err(gspca_dev, "spca50x_setup_qtable failed on init\n");
 
 	/* set qtable index */
 	reg_w(gspca_dev, 0x00, 0x8880, 2);
@@ -636,7 +636,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 					   0x00, 0x8800, 0x8840,
 					   qtable_creative_pccam);
 		if (err < 0)
-			PERR("spca50x_setup_qtable failed");
+			gspca_err(gspca_dev, "spca50x_setup_qtable failed\n");
 		/* Init SDRAM - needed for SDRAM access */
 		reg_w(gspca_dev, 0x00, 0x870a, 0x04);
 
@@ -644,7 +644,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x00, 0x8000, 0x0004);
 		msleep(500);
 		if (reg_r_wait(gspca_dev, 0, 0x8000, 0x44) != 0)
-			PERR("reg_r_wait() failed");
+			gspca_err(gspca_dev, "reg_r_wait() failed\n");
 
 		reg_r(gspca_dev, 0x816b, 1);
 		Data = gspca_dev->usb_buf[0];
@@ -657,13 +657,13 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		/* enable drop packet */
 		err = reg_w(gspca_dev, 0x00, 0x850a, 0x0001);
 		if (err < 0)
-			PERR("failed to enable drop packet");
+			gspca_err(gspca_dev, "failed to enable drop packet\n");
 		reg_w(gspca_dev, 0x00, 0x8880, 3);
 		err = spca50x_setup_qtable(gspca_dev,
 					   0x00, 0x8800, 0x8840,
 					   qtable_creative_pccam);
 		if (err < 0)
-			PERR("spca50x_setup_qtable failed");
+			gspca_err(gspca_dev, "spca50x_setup_qtable failed\n");
 
 		/* Init SDRAM - needed for SDRAM access */
 		reg_w(gspca_dev, 0x00, 0x870a, 0x04);
@@ -672,7 +672,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x00, 0x8000, 0x0004);
 
 		if (reg_r_wait(gspca_dev, 0, 0x8000, 0x44) != 0)
-			PERR("reg_r_wait() failed");
+			gspca_err(gspca_dev, "reg_r_wait() failed\n");
 
 		reg_r(gspca_dev, 0x816b, 1);
 		Data = gspca_dev->usb_buf[0];
@@ -686,18 +686,18 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		/* do a full reset */
 		err = spca500_full_reset(gspca_dev);
 		if (err < 0)
-			PERR("spca500_full_reset failed");
+			gspca_err(gspca_dev, "spca500_full_reset failed\n");
 
 		/* enable drop packet */
 		err = reg_w(gspca_dev, 0x00, 0x850a, 0x0001);
 		if (err < 0)
-			PERR("failed to enable drop packet");
+			gspca_err(gspca_dev, "failed to enable drop packet\n");
 		reg_w(gspca_dev, 0x00, 0x8880, 3);
 		err = spca50x_setup_qtable(gspca_dev,
 					   0x00, 0x8800, 0x8840,
 					   qtable_creative_pccam);
 		if (err < 0)
-			PERR("spca50x_setup_qtable failed");
+			gspca_err(gspca_dev, "spca50x_setup_qtable failed\n");
 
 		spca500_setmode(gspca_dev, xmult, ymult);
 		reg_w(gspca_dev, 0x20, 0x0001, 0x0004);
@@ -706,7 +706,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x00, 0x8000, 0x0004);
 
 		if (reg_r_wait(gspca_dev, 0, 0x8000, 0x44) != 0)
-			PERR("reg_r_wait() failed");
+			gspca_err(gspca_dev, "reg_r_wait() failed\n");
 
 		reg_r(gspca_dev, 0x816b, 1);
 		Data = gspca_dev->usb_buf[0];
@@ -719,7 +719,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		/* do a full reset */
 		err = spca500_full_reset(gspca_dev);
 		if (err < 0)
-			PERR("spca500_full_reset failed");
+			gspca_err(gspca_dev, "spca500_full_reset failed\n");
 		/* enable drop packet */
 		reg_w(gspca_dev, 0x00, 0x850a, 0x0001);
 		reg_w(gspca_dev, 0x00, 0x8880, 0);
@@ -727,7 +727,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 					   0x00, 0x8800, 0x8840,
 					   qtable_kodak_ez200);
 		if (err < 0)
-			PERR("spca50x_setup_qtable failed");
+			gspca_err(gspca_dev, "spca50x_setup_qtable failed\n");
 		spca500_setmode(gspca_dev, xmult, ymult);
 
 		reg_w(gspca_dev, 0x20, 0x0001, 0x0004);
@@ -736,7 +736,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x00, 0x8000, 0x0004);
 
 		if (reg_r_wait(gspca_dev, 0, 0x8000, 0x44) != 0)
-			PERR("reg_r_wait() failed");
+			gspca_err(gspca_dev, "reg_r_wait() failed\n");
 
 		reg_r(gspca_dev, 0x816b, 1);
 		Data = gspca_dev->usb_buf[0];
@@ -762,7 +762,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		err = spca50x_setup_qtable(gspca_dev,
 				   0x00, 0x8800, 0x8840, qtable_pocketdv);
 		if (err < 0)
-			PERR("spca50x_setup_qtable failed");
+			gspca_err(gspca_dev, "spca50x_setup_qtable failed\n");
 		reg_w(gspca_dev, 0x00, 0x8880, 2);
 
 		/* familycam Quicksmart pocketDV stuff */
@@ -792,7 +792,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 					0x00, 0x8800,
 					0x8840, qtable_creative_pccam);
 		if (err < 0)
-			PERR("spca50x_setup_qtable failed");
+			gspca_err(gspca_dev, "spca50x_setup_qtable failed\n");
 		reg_w(gspca_dev, 0x00, 0x8880, 3);
 		reg_w(gspca_dev, 0x00, 0x800a, 0x00);
 		/* Init SDRAM - needed for SDRAM access */
diff --git a/drivers/media/usb/gspca/spca501.c b/drivers/media/usb/gspca/spca501.c
index ae5a80987553..29861588302f 100644
--- a/drivers/media/usb/gspca/spca501.c
+++ b/drivers/media/usb/gspca/spca501.c
@@ -1779,8 +1779,8 @@ static int write_vector(struct gspca_dev *gspca_dev, const __u16 data[][3])
 		ret = reg_write(gspca_dev, data[i][0], data[i][2],
 								data[i][1]);
 		if (ret < 0) {
-			PERR("Reg write failed for 0x%02x,0x%02x,0x%02x",
-				data[i][0], data[i][1], data[i][2]);
+			gspca_err(gspca_dev, "Reg write failed for 0x%02x,0x%02x,0x%02x\n",
+				  data[i][0], data[i][1], data[i][2]);
 			return ret;
 		}
 		i++;
diff --git a/drivers/media/usb/gspca/spca505.c b/drivers/media/usb/gspca/spca505.c
index 1553cc766c04..02b5e2d81c64 100644
--- a/drivers/media/usb/gspca/spca505.c
+++ b/drivers/media/usb/gspca/spca505.c
@@ -650,7 +650,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	ret = reg_read(gspca_dev, 0x06, 0x16);
 
 	if (ret < 0) {
-		PERR("register read failed err: %d", ret);
+		gspca_err(gspca_dev, "register read failed err: %d\n", ret);
 		return ret;
 	}
 	if (ret != 0x0101) {
diff --git a/drivers/media/usb/gspca/spca508.c b/drivers/media/usb/gspca/spca508.c
index 1e0ba6b24e21..aafffaf1d2b5 100644
--- a/drivers/media/usb/gspca/spca508.c
+++ b/drivers/media/usb/gspca/spca508.c
@@ -1309,7 +1309,8 @@ static int ssi_w(struct gspca_dev *gspca_dev,
 		if (gspca_dev->usb_buf[0] == 0)
 			break;
 		if (--retry <= 0) {
-			PERR("ssi_w busy %02x", gspca_dev->usb_buf[0]);
+			gspca_err(gspca_dev, "ssi_w busy %02x\n",
+				  gspca_dev->usb_buf[0]);
 			ret = -1;
 			break;
 		}
diff --git a/drivers/media/usb/gspca/spca561.c b/drivers/media/usb/gspca/spca561.c
index 4ff704cf9ed6..a75bd90bd9e3 100644
--- a/drivers/media/usb/gspca/spca561.c
+++ b/drivers/media/usb/gspca/spca561.c
@@ -728,7 +728,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 
 		/* This should never happen */
 		if (len < 2) {
-			PERR("Short SOF packet, ignoring");
+			gspca_err(gspca_dev, "Short SOF packet, ignoring\n");
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			return;
 		}
diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index f1da34a10ce8..948808305a6a 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -382,7 +382,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	}
 
 	if (ret < 0) {
-		PERR("Start streaming command failed");
+		gspca_err(gspca_dev, "Start streaming command failed\n");
 		return ret;
 	}
 	/* Start the workqueue function to do the streaming */
diff --git a/drivers/media/usb/gspca/sq905c.c b/drivers/media/usb/gspca/sq905c.c
index 8b4e4948a0cb..4fbfcf366f71 100644
--- a/drivers/media/usb/gspca/sq905c.c
+++ b/drivers/media/usb/gspca/sq905c.c
@@ -211,13 +211,13 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	ret = sq905c_command(gspca_dev, SQ905C_GET_ID, 0);
 	if (ret < 0) {
-		PERR("Get version command failed");
+		gspca_err(gspca_dev, "Get version command failed\n");
 		return ret;
 	}
 
 	ret = sq905c_read(gspca_dev, 0xf5, 0, 20);
 	if (ret < 0) {
-		PERR("Reading version command failed");
+		gspca_err(gspca_dev, "Reading version command failed\n");
 		return ret;
 	}
 	/* Note we leave out the usb id and the manufacturing date */
@@ -279,7 +279,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	}
 
 	if (ret < 0) {
-		PERR("Start streaming command failed");
+		gspca_err(gspca_dev, "Start streaming command failed\n");
 		return ret;
 	}
 	/* Start the workqueue function to do the streaming */
diff --git a/drivers/media/usb/gspca/sq930x.c b/drivers/media/usb/gspca/sq930x.c
index aa9a9411b801..af48bd6dbe8c 100644
--- a/drivers/media/usb/gspca/sq930x.c
+++ b/drivers/media/usb/gspca/sq930x.c
@@ -538,7 +538,7 @@ static void ucbus_write(struct gspca_dev *gspca_dev,
 		return;
 
 	if ((batchsize - 1) * 3 > USB_BUF_SZ) {
-		PERR("Bug: usb_buf overflow\n");
+		gspca_err(gspca_dev, "Bug: usb_buf overflow\n");
 		gspca_dev->usb_err = -ENOMEM;
 		return;
 	}
diff --git a/drivers/media/usb/gspca/stv0680.c b/drivers/media/usb/gspca/stv0680.c
index 29a65d05cbb2..4ff6ae18d8dd 100644
--- a/drivers/media/usb/gspca/stv0680.c
+++ b/drivers/media/usb/gspca/stv0680.c
@@ -82,8 +82,8 @@ static int stv_sndctrl(struct gspca_dev *gspca_dev, int set, u8 req, u16 val,
 static int stv0680_handle_error(struct gspca_dev *gspca_dev, int ret)
 {
 	stv_sndctrl(gspca_dev, 0, 0x80, 0, 0x02); /* Get Last Error */
-	PERR("last error: %i,  command = 0x%x",
-	       gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
+	gspca_err(gspca_dev, "last error: %i,  command = 0x%x\n",
+		  gspca_dev->usb_buf[0], gspca_dev->usb_buf[1]);
 	return ret;
 }
 
@@ -94,7 +94,7 @@ static int stv0680_get_video_mode(struct gspca_dev *gspca_dev)
 	gspca_dev->usb_buf[0] = 0x0f;
 
 	if (stv_sndctrl(gspca_dev, 0, 0x87, 0, 0x08) != 0x08) {
-		PERR("Get_Camera_Mode failed");
+		gspca_err(gspca_dev, "Get_Camera_Mode failed\n");
 		return stv0680_handle_error(gspca_dev, -EIO);
 	}
 
@@ -112,13 +112,13 @@ static int stv0680_set_video_mode(struct gspca_dev *gspca_dev, u8 mode)
 	gspca_dev->usb_buf[0] = mode;
 
 	if (stv_sndctrl(gspca_dev, 3, 0x07, 0x0100, 0x08) != 0x08) {
-		PERR("Set_Camera_Mode failed");
+		gspca_err(gspca_dev, "Set_Camera_Mode failed\n");
 		return stv0680_handle_error(gspca_dev, -EIO);
 	}
 
 	/* Verify we got what we've asked for */
 	if (stv0680_get_video_mode(gspca_dev) != mode) {
-		PERR("Error setting camera video mode!");
+		gspca_err(gspca_dev, "Error setting camera video mode!\n");
 		return -EIO;
 	}
 
@@ -142,7 +142,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	/* ping camera to be sure STV0680 is present */
 	if (stv_sndctrl(gspca_dev, 0, 0x88, 0x5678, 0x02) != 0x02 ||
 	    gspca_dev->usb_buf[0] != 0x56 || gspca_dev->usb_buf[1] != 0x78) {
-		PERR("STV(e): camera ping failed!!");
+		gspca_err(gspca_dev, "STV(e): camera ping failed!!\n");
 		return stv0680_handle_error(gspca_dev, -ENODEV);
 	}
 
@@ -152,7 +152,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	if (stv_sndctrl(gspca_dev, 2, 0x06, 0x0200, 0x22) != 0x22 ||
 	    gspca_dev->usb_buf[7] != 0xa0 || gspca_dev->usb_buf[8] != 0x23) {
-		PERR("Could not get descriptor 0200.");
+		gspca_err(gspca_dev, "Could not get descriptor 0200\n");
 		return stv0680_handle_error(gspca_dev, -ENODEV);
 	}
 	if (stv_sndctrl(gspca_dev, 0, 0x8a, 0, 0x02) != 0x02)
@@ -163,7 +163,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 		return stv0680_handle_error(gspca_dev, -ENODEV);
 
 	if (!(gspca_dev->usb_buf[7] & 0x09)) {
-		PERR("Camera supports neither CIF nor QVGA mode");
+		gspca_err(gspca_dev, "Camera supports neither CIF nor QVGA mode\n");
 		return -ENODEV;
 	}
 	if (gspca_dev->usb_buf[7] & 0x01)
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index e72c3e1ab9ff..3db1c24b3d6d 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -285,7 +285,7 @@ static int stv06xx_start(struct gspca_dev *gspca_dev)
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
 	if (!alt) {
-		PERR("Couldn't get altsetting");
+		gspca_err(gspca_dev, "Couldn't get altsetting\n");
 		return -EIO;
 	}
 
@@ -343,7 +343,7 @@ static int stv06xx_isoc_nego(struct gspca_dev *gspca_dev)
 
 	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 1);
 	if (ret < 0)
-		PERR("set alt 1 err %d", ret);
+		gspca_err(gspca_dev, "set alt 1 err %d\n", ret);
 
 	return ret;
 }
@@ -408,7 +408,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 		len -= 4;
 
 		if (len < chunk_len) {
-			PERR("URB packet length is smaller than the specified chunk length");
+			gspca_err(gspca_dev, "URB packet length is smaller than the specified chunk length\n");
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			return;
 		}
@@ -450,7 +450,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 				sd->to_skip = gspca_dev->pixfmt.width * 4;
 
 			if (chunk_len)
-				PERR("Chunk length is non-zero on a SOF");
+				gspca_err(gspca_dev, "Chunk length is non-zero on a SOF\n");
 			break;
 
 		case 0x8002:
@@ -463,7 +463,7 @@ static void stv06xx_pkt_scan(struct gspca_dev *gspca_dev,
 					NULL, 0);
 
 			if (chunk_len)
-				PERR("Chunk length is non-zero on a EOF");
+				gspca_err(gspca_dev, "Chunk length is non-zero on a EOF\n");
 			break;
 
 		case 0x0005:
diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index 8c2785aea3cd..44b07344f0f7 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -248,7 +248,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	int ret;
 
 	if (len > USB_BUF_SZ) {
-		PERR("reg_r: buffer overflow\n");
+		gspca_err(gspca_dev, "reg_r: buffer overflow\n");
 		return;
 	}
 	if (gspca_dev->usb_err < 0)
diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
index b8af4370d27c..a1bb1704d339 100644
--- a/drivers/media/usb/gspca/touptek.c
+++ b/drivers/media/usb/gspca/touptek.c
@@ -195,15 +195,15 @@ static const struct v4l2_pix_format vga_mode[] = {
 static int val_reply(struct gspca_dev *gspca_dev, const char *reply, int rc)
 {
 	if (rc < 0) {
-		PERR("reply has error %d", rc);
+		gspca_err(gspca_dev, "reply has error %d\n", rc);
 		return -EIO;
 	}
 	if (rc != 1) {
-		PERR("Bad reply size %d", rc);
+		gspca_err(gspca_dev, "Bad reply size %d\n", rc);
 		return -EIO;
 	}
 	if (reply[0] != 0x08) {
-		PERR("Bad reply 0x%02x", (int)reply[0]);
+		gspca_err(gspca_dev, "Bad reply 0x%02x\n", (int)reply[0]);
 		return -EIO;
 	}
 	return 0;
@@ -221,14 +221,14 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 		0x0B, 0xC0, value, index, buff, 1, 500);
 	PDEBUG(D_USBO, "rc=%d, ret={0x%02x}", rc, (int)buff[0]);
 	if (rc < 0) {
-		PERR("Failed reg_w(0x0B, 0xC0, 0x%04X, 0x%04X) w/ rc %d\n",
-			value, index, rc);
+		gspca_err(gspca_dev, "Failed reg_w(0x0B, 0xC0, 0x%04X, 0x%04X) w/ rc %d\n",
+			  value, index, rc);
 		gspca_dev->usb_err = rc;
 		return;
 	}
 	if (val_reply(gspca_dev, buff, rc)) {
-		PERR("Bad reply to reg_w(0x0B, 0xC0, 0x%04X, 0x%04X\n",
-			value, index);
+		gspca_err(gspca_dev, "Bad reply to reg_w(0x0B, 0xC0, 0x%04X, 0x%04X\n",
+			  value, index);
 		gspca_dev->usb_err = -EIO;
 	}
 }
@@ -254,7 +254,7 @@ static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 	else if (w == 3264)
 		value = val * 3 / 2;
 	else {
-		PERR("Invalid width %u\n", w);
+		gspca_err(gspca_dev, "Invalid width %u\n", w);
 		gspca_dev->usb_err = -EINVAL;
 		return;
 	}
@@ -372,7 +372,7 @@ static void configure_wh(struct gspca_dev *gspca_dev)
 		reg_w_buf(gspca_dev,
 			       reg_init_res, ARRAY_SIZE(reg_init_res));
 	} else {
-		PERR("bad width %u\n", w);
+		gspca_err(gspca_dev, "bad width %u\n", w);
 		gspca_dev->usb_err = -EINVAL;
 		return;
 	}
@@ -392,7 +392,7 @@ static void configure_wh(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x0B4B, REG_FRAME_LENGTH_LINES_);
 		reg_w(gspca_dev, 0x1F40, REG_LINE_LENGTH_PCK_);
 	} else {
-		PERR("bad width %u\n", w);
+		gspca_err(gspca_dev, "bad width %u\n", w);
 		gspca_dev->usb_err = -EINVAL;
 		return;
 	}
@@ -458,7 +458,7 @@ static int configure(struct gspca_dev *gspca_dev)
 	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
 			     0x16, 0xC0, 0x0000, 0x0000, buff, 2, 500);
 	if (val_reply(gspca_dev, buff, rc)) {
-		PERR("failed key req");
+		gspca_err(gspca_dev, "failed key req\n");
 		return -EIO;
 	}
 
@@ -475,21 +475,24 @@ static int configure(struct gspca_dev *gspca_dev)
 	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
 			     0x01, 0x40, 0x0001, 0x000F, NULL, 0, 500);
 	if (rc < 0) {
-		PERR("failed to replay packet 176 w/ rc %d\n", rc);
+		gspca_err(gspca_dev, "failed to replay packet 176 w/ rc %d\n",
+			  rc);
 		return rc;
 	}
 
 	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
 			     0x01, 0x40, 0x0000, 0x000F, NULL, 0, 500);
 	if (rc < 0) {
-		PERR("failed to replay packet 178 w/ rc %d\n", rc);
+		gspca_err(gspca_dev, "failed to replay packet 178 w/ rc %d\n",
+			  rc);
 		return rc;
 	}
 
 	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
 			     0x01, 0x40, 0x0001, 0x000F, NULL, 0, 500);
 	if (rc < 0) {
-		PERR("failed to replay packet 180 w/ rc %d\n", rc);
+		gspca_err(gspca_dev, "failed to replay packet 180 w/ rc %d\n",
+			  rc);
 		return rc;
 	}
 
@@ -511,7 +514,8 @@ static int configure(struct gspca_dev *gspca_dev)
 	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
 			     0x01, 0x40, 0x0003, 0x000F, NULL, 0, 500);
 	if (rc < 0) {
-		PERR("failed to replay final packet w/ rc %d\n", rc);
+		gspca_err(gspca_dev, "failed to replay final packet w/ rc %d\n",
+			  rc);
 		return rc;
 	}
 
@@ -545,7 +549,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	rc = configure(gspca_dev);
 	if (rc < 0) {
-		PERR("Failed configure");
+		gspca_err(gspca_dev, "Failed configure\n");
 		return rc;
 	}
 	/* First two frames have messed up gains
@@ -641,7 +645,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 			V4L2_CID_RED_BALANCE, 0, 1023, 1, 295);
 
 	if (hdl->error) {
-		PERR("Could not initialize controls\n");
+		gspca_err(gspca_dev, "Could not initialize controls\n");
 		return hdl->error;
 	}
 	return 0;
diff --git a/drivers/media/usb/gspca/w996Xcf.c b/drivers/media/usb/gspca/w996Xcf.c
index 728d2322c433..d149cb7f0019 100644
--- a/drivers/media/usb/gspca/w996Xcf.c
+++ b/drivers/media/usb/gspca/w996Xcf.c
@@ -333,7 +333,7 @@ static int w9968cf_i2c_r(struct sd *sd, u8 reg)
 		ret = value;
 		PDEBUG(D_USBI, "i2c [0x%02X] -> 0x%02X", reg, value);
 	} else
-		PERR("i2c read [0x%02x] failed", reg);
+		gspca_err(gspca_dev, "i2c read [0x%02x] failed\n", reg);
 
 	return ret;
 }
-- 
2.10.0.rc2.1.g053435c
