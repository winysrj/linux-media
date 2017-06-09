Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:32883 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751584AbdFIRzB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 13:55:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] stkwebcam: Use more common logging styles
Date: Fri,  9 Jun 2017 10:54:57 -0700
Message-Id: <3fca8bd5dce632bc2a24020fff821e3afacd20a1.1497030881.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert STK_<LEVEL> to pr_<level> to use the typical kernel logging.
Add a define for pr_fmt.  No change in logging output.

Miscellanea:

o Remove now unused PREFIX and STK_<LEVEL> macros
o Realign arguments
o Use pr_<level>_ratelimited
o Add a few missing newlines to formats

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/usb/stkwebcam/stk-sensor.c | 32 ++++++++-------
 drivers/media/usb/stkwebcam/stk-webcam.c | 70 ++++++++++++++++----------------
 drivers/media/usb/stkwebcam/stk-webcam.h |  6 ---
 3 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-sensor.c b/drivers/media/usb/stkwebcam/stk-sensor.c
index 985af9933c7e..c1d4505f84ea 100644
--- a/drivers/media/usb/stkwebcam/stk-sensor.c
+++ b/drivers/media/usb/stkwebcam/stk-sensor.c
@@ -41,6 +41,8 @@
 
 /* It seems the i2c bus is controlled with these registers */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "stk-webcam.h"
 
 #define STK_IIC_BASE		(0x0200)
@@ -239,8 +241,8 @@ static int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val)
 	} while (tmpval == 0 && i < MAX_RETRIES);
 	if (tmpval != STK_IIC_STAT_TX_OK) {
 		if (tmpval)
-			STK_ERROR("stk_sensor_outb failed, status=0x%02x\n",
-				tmpval);
+			pr_err("stk_sensor_outb failed, status=0x%02x\n",
+			       tmpval);
 		return 1;
 	} else
 		return 0;
@@ -262,8 +264,8 @@ static int stk_sensor_inb(struct stk_camera *dev, u8 reg, u8 *val)
 	} while (tmpval == 0 && i < MAX_RETRIES);
 	if (tmpval != STK_IIC_STAT_RX_OK) {
 		if (tmpval)
-			STK_ERROR("stk_sensor_inb failed, status=0x%02x\n",
-				tmpval);
+			pr_err("stk_sensor_inb failed, status=0x%02x\n",
+			       tmpval);
 		return 1;
 	}
 
@@ -366,29 +368,29 @@ int stk_sensor_init(struct stk_camera *dev)
 	if (stk_camera_write_reg(dev, STK_IIC_ENABLE, STK_IIC_ENABLE_YES)
 		|| stk_camera_write_reg(dev, STK_IIC_ADDR, SENSOR_ADDRESS)
 		|| stk_sensor_outb(dev, REG_COM7, COM7_RESET)) {
-		STK_ERROR("Sensor resetting failed\n");
+		pr_err("Sensor resetting failed\n");
 		return -ENODEV;
 	}
 	msleep(10);
 	/* Read the manufacturer ID: ov = 0x7FA2 */
 	if (stk_sensor_inb(dev, REG_MIDH, &idh)
 	    || stk_sensor_inb(dev, REG_MIDL, &idl)) {
-		STK_ERROR("Strange error reading sensor ID\n");
+		pr_err("Strange error reading sensor ID\n");
 		return -ENODEV;
 	}
 	if (idh != 0x7f || idl != 0xa2) {
-		STK_ERROR("Huh? you don't have a sensor from ovt\n");
+		pr_err("Huh? you don't have a sensor from ovt\n");
 		return -ENODEV;
 	}
 	if (stk_sensor_inb(dev, REG_PID, &idh)
 	    || stk_sensor_inb(dev, REG_VER, &idl)) {
-		STK_ERROR("Could not read sensor model\n");
+		pr_err("Could not read sensor model\n");
 		return -ENODEV;
 	}
 	stk_sensor_write_regvals(dev, ov_initvals);
 	msleep(10);
-	STK_INFO("OmniVision sensor detected, id %02X%02X at address %x\n",
-		 idh, idl, SENSOR_ADDRESS);
+	pr_info("OmniVision sensor detected, id %02X%02X at address %x\n",
+		idh, idl, SENSOR_ADDRESS);
 	return 0;
 }
 
@@ -520,7 +522,8 @@ int stk_sensor_configure(struct stk_camera *dev)
 	case MODE_SXGA: com7 = COM7_FMT_SXGA;
 		dummylines = 0;
 		break;
-	default: STK_ERROR("Unsupported mode %d\n", dev->vsettings.mode);
+	default:
+		pr_err("Unsupported mode %d\n", dev->vsettings.mode);
 		return -EFAULT;
 	}
 	switch (dev->vsettings.palette) {
@@ -544,7 +547,8 @@ int stk_sensor_configure(struct stk_camera *dev)
 		com7 |= COM7_PBAYER;
 		rv = ov_fmt_bayer;
 		break;
-	default: STK_ERROR("Unsupported colorspace\n");
+	default:
+		pr_err("Unsupported colorspace\n");
 		return -EFAULT;
 	}
 	/*FIXME sometimes the sensor go to a bad state
@@ -564,7 +568,7 @@ int stk_sensor_configure(struct stk_camera *dev)
 	switch (dev->vsettings.mode) {
 	case MODE_VGA:
 		if (stk_sensor_set_hw(dev, 302, 1582, 6, 486))
-			STK_ERROR("stk_sensor_set_hw failed (VGA)\n");
+			pr_err("stk_sensor_set_hw failed (VGA)\n");
 		break;
 	case MODE_SXGA:
 	case MODE_CIF:
@@ -572,7 +576,7 @@ int stk_sensor_configure(struct stk_camera *dev)
 	case MODE_QCIF:
 		/*FIXME These settings seem ignored by the sensor
 		if (stk_sensor_set_hw(dev, 220, 1500, 10, 1034))
-			STK_ERROR("stk_sensor_set_hw failed (SXGA)\n");
+			pr_err("stk_sensor_set_hw failed (SXGA)\n");
 		*/
 		break;
 	}
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 6e7fc36b658f..90d4a08cda31 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -18,6 +18,8 @@
  * GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -175,15 +177,15 @@ static int stk_start_stream(struct stk_camera *dev)
 	if (!is_present(dev))
 		return -ENODEV;
 	if (!is_memallocd(dev) || !is_initialised(dev)) {
-		STK_ERROR("FIXME: Buffers are not allocated\n");
+		pr_err("FIXME: Buffers are not allocated\n");
 		return -EFAULT;
 	}
 	ret = usb_set_interface(dev->udev, 0, 5);
 
 	if (ret < 0)
-		STK_ERROR("usb_set_interface failed !\n");
+		pr_err("usb_set_interface failed !\n");
 	if (stk_sensor_wakeup(dev))
-		STK_ERROR("error awaking the sensor\n");
+		pr_err("error awaking the sensor\n");
 
 	stk_camera_read_reg(dev, 0x0116, &value_116);
 	stk_camera_read_reg(dev, 0x0117, &value_117);
@@ -224,9 +226,9 @@ static int stk_stop_stream(struct stk_camera *dev)
 		unset_streaming(dev);
 
 		if (usb_set_interface(dev->udev, 0, 0))
-			STK_ERROR("usb_set_interface failed !\n");
+			pr_err("usb_set_interface failed !\n");
 		if (stk_sensor_sleep(dev))
-			STK_ERROR("error suspending the sensor\n");
+			pr_err("error suspending the sensor\n");
 	}
 	return 0;
 }
@@ -313,7 +315,7 @@ static void stk_isoc_handler(struct urb *urb)
 	dev = (struct stk_camera *) urb->context;
 
 	if (dev == NULL) {
-		STK_ERROR("isoc_handler called with NULL device !\n");
+		pr_err("isoc_handler called with NULL device !\n");
 		return;
 	}
 
@@ -326,14 +328,13 @@ static void stk_isoc_handler(struct urb *urb)
 	spin_lock_irqsave(&dev->spinlock, flags);
 
 	if (urb->status != -EINPROGRESS && urb->status != 0) {
-		STK_ERROR("isoc_handler: urb->status == %d\n", urb->status);
+		pr_err("isoc_handler: urb->status == %d\n", urb->status);
 		goto resubmit;
 	}
 
 	if (list_empty(&dev->sio_avail)) {
 		/*FIXME Stop streaming after a while */
-		(void) (printk_ratelimit() &&
-		STK_ERROR("isoc_handler without available buffer!\n"));
+		pr_err_ratelimited("isoc_handler without available buffer!\n");
 		goto resubmit;
 	}
 	fb = list_first_entry(&dev->sio_avail,
@@ -343,8 +344,8 @@ static void stk_isoc_handler(struct urb *urb)
 	for (i = 0; i < urb->number_of_packets; i++) {
 		if (urb->iso_frame_desc[i].status != 0) {
 			if (urb->iso_frame_desc[i].status != -EXDEV)
-				STK_ERROR("Frame %d has error %d\n", i,
-					urb->iso_frame_desc[i].status);
+				pr_err("Frame %d has error %d\n",
+				       i, urb->iso_frame_desc[i].status);
 			continue;
 		}
 		framelen = urb->iso_frame_desc[i].actual_length;
@@ -368,9 +369,8 @@ static void stk_isoc_handler(struct urb *urb)
 			/* This marks a new frame */
 			if (fb->v4lbuf.bytesused != 0
 				&& fb->v4lbuf.bytesused != dev->frame_size) {
-				(void) (printk_ratelimit() &&
-				STK_ERROR("frame %d, bytesused=%d, skipping\n",
-					i, fb->v4lbuf.bytesused));
+				pr_err_ratelimited("frame %d, bytesused=%d, skipping\n",
+						   i, fb->v4lbuf.bytesused);
 				fb->v4lbuf.bytesused = 0;
 				fill = fb->buffer;
 			} else if (fb->v4lbuf.bytesused == dev->frame_size) {
@@ -395,8 +395,7 @@ static void stk_isoc_handler(struct urb *urb)
 
 		/* Our buffer is full !!! */
 		if (framelen + fb->v4lbuf.bytesused > dev->frame_size) {
-			(void) (printk_ratelimit() &&
-			STK_ERROR("Frame buffer overflow, lost sync\n"));
+			pr_err_ratelimited("Frame buffer overflow, lost sync\n");
 			/*FIXME Do something here? */
 			continue;
 		}
@@ -414,8 +413,8 @@ static void stk_isoc_handler(struct urb *urb)
 	urb->dev = dev->udev;
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret != 0) {
-		STK_ERROR("Error (%d) re-submitting urb in stk_isoc_handler.\n",
-			ret);
+		pr_err("Error (%d) re-submitting urb in stk_isoc_handler\n",
+		       ret);
 	}
 }
 
@@ -433,32 +432,31 @@ static int stk_prepare_iso(struct stk_camera *dev)
 	udev = dev->udev;
 
 	if (dev->isobufs)
-		STK_ERROR("isobufs already allocated. Bad\n");
+		pr_err("isobufs already allocated. Bad\n");
 	else
 		dev->isobufs = kcalloc(MAX_ISO_BUFS, sizeof(*dev->isobufs),
 				       GFP_KERNEL);
 	if (dev->isobufs == NULL) {
-		STK_ERROR("Unable to allocate iso buffers\n");
+		pr_err("Unable to allocate iso buffers\n");
 		return -ENOMEM;
 	}
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		if (dev->isobufs[i].data == NULL) {
 			kbuf = kzalloc(ISO_BUFFER_SIZE, GFP_KERNEL);
 			if (kbuf == NULL) {
-				STK_ERROR("Failed to allocate iso buffer %d\n",
-					i);
+				pr_err("Failed to allocate iso buffer %d\n", i);
 				goto isobufs_out;
 			}
 			dev->isobufs[i].data = kbuf;
 		} else
-			STK_ERROR("isobuf data already allocated\n");
+			pr_err("isobuf data already allocated\n");
 		if (dev->isobufs[i].urb == NULL) {
 			urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 			if (urb == NULL)
 				goto isobufs_out;
 			dev->isobufs[i].urb = urb;
 		} else {
-			STK_ERROR("Killing URB\n");
+			pr_err("Killing URB\n");
 			usb_kill_urb(dev->isobufs[i].urb);
 			urb = dev->isobufs[i].urb;
 		}
@@ -567,7 +565,7 @@ static int stk_prepare_sio_buffers(struct stk_camera *dev, unsigned n_sbufs)
 {
 	int i;
 	if (dev->sio_bufs != NULL)
-		STK_ERROR("sio_bufs already allocated\n");
+		pr_err("sio_bufs already allocated\n");
 	else {
 		dev->sio_bufs = kzalloc(n_sbufs * sizeof(struct stk_sio_buffer),
 				GFP_KERNEL);
@@ -690,7 +688,7 @@ static ssize_t stk_read(struct file *fp, char __user *buf,
 	spin_lock_irqsave(&dev->spinlock, flags);
 	if (list_empty(&dev->sio_full)) {
 		spin_unlock_irqrestore(&dev->spinlock, flags);
-		STK_ERROR("BUG: No siobufs ready\n");
+		pr_err("BUG: No siobufs ready\n");
 		return 0;
 	}
 	sbuf = list_first_entry(&dev->sio_full, struct stk_sio_buffer, list);
@@ -907,7 +905,7 @@ static int stk_vidioc_g_fmt_vid_cap(struct file *filp,
 			stk_sizes[i].m != dev->vsettings.mode; i++)
 		;
 	if (i == ARRAY_SIZE(stk_sizes)) {
-		STK_ERROR("ERROR: mode invalid\n");
+		pr_err("ERROR: mode invalid\n");
 		return -EINVAL;
 	}
 	pix_format->width = stk_sizes[i].w;
@@ -985,7 +983,7 @@ static int stk_setup_format(struct stk_camera *dev)
 			stk_sizes[i].m != dev->vsettings.mode)
 		i++;
 	if (i == ARRAY_SIZE(stk_sizes)) {
-		STK_ERROR("Something is broken in %s\n", __func__);
+		pr_err("Something is broken in %s\n", __func__);
 		return -EFAULT;
 	}
 	/* This registers controls some timings, not sure of what. */
@@ -1241,7 +1239,7 @@ static void stk_v4l_dev_release(struct video_device *vd)
 	struct stk_camera *dev = vdev_to_camera(vd);
 
 	if (dev->sio_bufs != NULL || dev->isobufs != NULL)
-		STK_ERROR("We are leaking memory\n");
+		pr_err("We are leaking memory\n");
 	usb_put_intf(dev->interface);
 	kfree(dev);
 }
@@ -1264,10 +1262,10 @@ static int stk_register_video_device(struct stk_camera *dev)
 	video_set_drvdata(&dev->vdev, dev);
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
-		STK_ERROR("v4l registration failed\n");
+		pr_err("v4l registration failed\n");
 	else
-		STK_INFO("Syntek USB2.0 Camera is now controlling device %s\n",
-			 video_device_node_name(&dev->vdev));
+		pr_info("Syntek USB2.0 Camera is now controlling device %s\n",
+			video_device_node_name(&dev->vdev));
 	return err;
 }
 
@@ -1288,7 +1286,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 
 	dev = kzalloc(sizeof(struct stk_camera), GFP_KERNEL);
 	if (dev == NULL) {
-		STK_ERROR("Out of memory !\n");
+		pr_err("Out of memory !\n");
 		return -ENOMEM;
 	}
 	err = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
@@ -1352,7 +1350,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 		}
 	}
 	if (!dev->isoc_ep) {
-		STK_ERROR("Could not find isoc-in endpoint");
+		pr_err("Could not find isoc-in endpoint\n");
 		err = -ENODEV;
 		goto error;
 	}
@@ -1387,8 +1385,8 @@ static void stk_camera_disconnect(struct usb_interface *interface)
 
 	wake_up_interruptible(&dev->wait_frame);
 
-	STK_INFO("Syntek USB2.0 Camera release resources device %s\n",
-		 video_device_node_name(&dev->vdev));
+	pr_info("Syntek USB2.0 Camera release resources device %s\n",
+		video_device_node_name(&dev->vdev));
 
 	video_unregister_device(&dev->vdev);
 	v4l2_ctrl_handler_free(&dev->hdl);
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
index 0284120ce246..5cecbdc97573 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.h
+++ b/drivers/media/usb/stkwebcam/stk-webcam.h
@@ -31,12 +31,6 @@
 #define ISO_MAX_FRAME_SIZE	3 * 1024
 #define ISO_BUFFER_SIZE		(ISO_FRAMES_PER_DESC * ISO_MAX_FRAME_SIZE)
 
-
-#define PREFIX				"stkwebcam: "
-#define STK_INFO(str, args...)		printk(KERN_INFO PREFIX str, ##args)
-#define STK_ERROR(str, args...)		printk(KERN_ERR PREFIX str, ##args)
-#define STK_WARNING(str, args...)	printk(KERN_WARNING PREFIX str, ##args)
-
 struct stk_iso_buf {
 	void *data;
 	int length;
-- 
2.10.0.rc2.1.g053435c
