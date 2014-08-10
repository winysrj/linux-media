Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 11/18] [media] au0828: use pr_foo macros
Date: Sat,  9 Aug 2014 21:47:17 -0300
Message-Id: <1407631644-11990-12-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using printk(KERN_foo, use pr_foo() macros.

No functional changes.

Note: we should do the same for dprintk(), but that would
require to remove the dprintk levels. So, for now, let's
not touch on it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-cards.c | 13 ++++-----
 drivers/media/usb/au0828/au0828-core.c  | 33 +++++++++++-----------
 drivers/media/usb/au0828/au0828-dvb.c   | 50 +++++++++++++++------------------
 drivers/media/usb/au0828/au0828-i2c.c   | 15 +++++-----
 drivers/media/usb/au0828/au0828-input.c |  4 +--
 drivers/media/usb/au0828/au0828-vbi.c   |  4 +--
 drivers/media/usb/au0828/au0828-video.c | 23 +++++++--------
 drivers/media/usb/au0828/au0828.h       |  5 ++--
 8 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index b6c9d1f466bd..d229c6dbddb9 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -143,8 +143,7 @@ int au0828_tuner_callback(void *priv, int component, int command, int arg)
 			mdelay(10);
 			return 0;
 		} else {
-			printk(KERN_ERR
-				"%s(): Unknown command.\n", __func__);
+			pr_err("%s(): Unknown command.\n", __func__);
 			return -EINVAL;
 		}
 		break;
@@ -178,12 +177,12 @@ static void hauppauge_eeprom(struct au0828_dev *dev, u8 *eeprom_data)
 	case 72500: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */
 		break;
 	default:
-		printk(KERN_WARNING "%s: warning: "
-		       "unknown hauppauge model #%d\n", __func__, tv.model);
+		pr_warn("%s: warning: unknown hauppauge model #%d\n",
+			__func__, tv.model);
 		break;
 	}
 
-	printk(KERN_INFO "%s: hauppauge eeprom: model=%d\n",
+	pr_info("%s: hauppauge eeprom: model=%d\n",
 	       __func__, tv.model);
 }
 
@@ -229,7 +228,7 @@ void au0828_card_analog_fe_setup(struct au0828_dev *dev)
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 				"au8522", 0x8e >> 1, NULL);
 		if (sd == NULL)
-			printk(KERN_ERR "analog subdev registration failed\n");
+			pr_err("analog subdev registration failed\n");
 	}
 
 	/* Setup tuners */
@@ -238,7 +237,7 @@ void au0828_card_analog_fe_setup(struct au0828_dev *dev)
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 				"tuner", dev->board.tuner_addr, NULL);
 		if (sd == NULL)
-			printk(KERN_ERR "tuner subdev registration fail\n");
+			pr_err("tuner subdev registration fail\n");
 
 		tun_setup.mode_mask      = mode_mask;
 		tun_setup.type           = dev->board.tuner_type;
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 5f13888d73a0..452d14249348 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -19,14 +19,14 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "au0828.h"
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
 
-#include "au0828.h"
-
 /*
  * 1 = General debug messages
  * 2 = USB handling
@@ -90,7 +90,7 @@ static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 		status = min(status, 0);
 
 		if (status < 0) {
-			printk(KERN_ERR "%s() Failed sending control message, error %d.\n",
+			pr_err("%s() Failed sending control message, error %d.\n",
 				__func__, status);
 		}
 
@@ -115,7 +115,7 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 		status = min(status, 0);
 
 		if (status < 0) {
-			printk(KERN_ERR "%s() Failed receiving control message, error %d.\n",
+			pr_err("%s() Failed receiving control message, error %d.\n",
 				__func__, status);
 		}
 
@@ -197,15 +197,14 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	 * not enough even for most Digital TV streams.
 	 */
 	if (usbdev->speed != USB_SPEED_HIGH && disable_usb_speed_check == 0) {
-		printk(KERN_ERR "au0828: Device initialization failed.\n");
-		printk(KERN_ERR "au0828: Device must be connected to a "
-		       "high-speed USB 2.0 port.\n");
+		pr_err("au0828: Device initialization failed.\n");
+		pr_err("au0828: Device must be connected to a high-speed USB 2.0 port.\n");
 		return -ENODEV;
 	}
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		printk(KERN_ERR "%s() Unable to allocate memory\n", __func__);
+		pr_err("%s() Unable to allocate memory\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -273,7 +272,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	 */
 	usb_set_intfdata(interface, dev);
 
-	printk(KERN_INFO "Registered device AU0828 [%s]\n",
+	pr_info("Registered device AU0828 [%s]\n",
 		dev->board.name == NULL ? "Unset" : dev->board.name);
 
 	mutex_unlock(&dev->lock);
@@ -320,7 +319,7 @@ static int au0828_resume(struct usb_interface *interface)
 }
 
 static struct usb_driver au0828_usb_driver = {
-	.name		= DRIVER_NAME,
+	.name		= KBUILD_MODNAME,
 	.probe		= au0828_usb_probe,
 	.disconnect	= au0828_usb_disconnect,
 	.id_table	= au0828_usb_id_table,
@@ -334,27 +333,27 @@ static int __init au0828_init(void)
 	int ret;
 
 	if (au0828_debug & 1)
-		printk(KERN_INFO "%s() Debugging is enabled\n", __func__);
+		pr_info("%s() Debugging is enabled\n", __func__);
 
 	if (au0828_debug & 2)
-		printk(KERN_INFO "%s() USB Debugging is enabled\n", __func__);
+		pr_info("%s() USB Debugging is enabled\n", __func__);
 
 	if (au0828_debug & 4)
-		printk(KERN_INFO "%s() I2C Debugging is enabled\n", __func__);
+		pr_info("%s() I2C Debugging is enabled\n", __func__);
 
 	if (au0828_debug & 8)
-		printk(KERN_INFO "%s() Bridge Debugging is enabled\n",
+		pr_info("%s() Bridge Debugging is enabled\n",
 		       __func__);
 
 	if (au0828_debug & 16)
-		printk(KERN_INFO "%s() IR Debugging is enabled\n",
+		pr_info("%s() IR Debugging is enabled\n",
 		       __func__);
 
-	printk(KERN_INFO "au0828 driver loaded\n");
+	pr_info("au0828 driver loaded\n");
 
 	ret = usb_register(&au0828_usb_driver);
 	if (ret)
-		printk(KERN_ERR "usb_register failed, error = %d\n", ret);
+		pr_err("usb_register failed, error = %d\n", ret);
 
 	return ret;
 }
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 7b6e71065aa4..99cf83bca033 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -19,6 +19,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "au0828.h"
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -26,7 +28,6 @@
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
-#include "au0828.h"
 #include "au8522.h"
 #include "xc5000.h"
 #include "mxl5007t.h"
@@ -126,7 +127,7 @@ static void urb_completion(struct urb *purb)
 	}
 
 	if (ptype != PIPE_BULK) {
-		printk(KERN_ERR "%s: Unsupported URB type %d\n",
+		pr_err("%s: Unsupported URB type %d\n",
 		       __func__, ptype);
 		return;
 	}
@@ -201,8 +202,7 @@ static int start_urb_transfer(struct au0828_dev *dev)
 		if (!purb->transfer_buffer) {
 			usb_free_urb(purb);
 			dev->urbs[i] = NULL;
-			printk(KERN_ERR
-			       "%s: failed big buffer allocation, err = %d\n",
+			pr_err("%s: failed big buffer allocation, err = %d\n",
 			       __func__, ret);
 			goto err;
 		}
@@ -223,8 +223,8 @@ static int start_urb_transfer(struct au0828_dev *dev)
 		ret = usb_submit_urb(dev->urbs[i], GFP_ATOMIC);
 		if (ret != 0) {
 			stop_urb_transfer(dev);
-			printk(KERN_ERR "%s: failed urb submission, "
-			       "err = %d\n", __func__, ret);
+			pr_err("%s: failed urb submission, err = %d\n",
+			       __func__, ret);
 			return ret;
 		}
 	}
@@ -392,9 +392,8 @@ static int dvb_register(struct au0828_dev *dev)
 			if (!dev->dig_transfer_buffer[i]) {
 				result = -ENOMEM;
 
-				printk(KERN_ERR
-				       "%s: failed buffer allocation (errno = %d)\n",
-				       DRIVER_NAME, result);
+				pr_err("failed buffer allocation (errno = %d)\n",
+				       result);
 				goto fail_adapter;
 			}
 		}
@@ -403,11 +402,12 @@ static int dvb_register(struct au0828_dev *dev)
 	INIT_WORK(&dev->restart_streaming, au0828_restart_dvb_streaming);
 
 	/* register adapter */
-	result = dvb_register_adapter(&dvb->adapter, DRIVER_NAME, THIS_MODULE,
+	result = dvb_register_adapter(&dvb->adapter,
+				      KBUILD_MODNAME, THIS_MODULE,
 				      &dev->usbdev->dev, adapter_nr);
 	if (result < 0) {
-		printk(KERN_ERR "%s: dvb_register_adapter failed "
-		       "(errno = %d)\n", DRIVER_NAME, result);
+		pr_err("dvb_register_adapter failed (errno = %d)\n",
+		       result);
 		goto fail_adapter;
 	}
 	dvb->adapter.priv = dev;
@@ -415,8 +415,8 @@ static int dvb_register(struct au0828_dev *dev)
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->frontend);
 	if (result < 0) {
-		printk(KERN_ERR "%s: dvb_register_frontend failed "
-		       "(errno = %d)\n", DRIVER_NAME, result);
+		pr_err("dvb_register_frontend failed (errno = %d)\n",
+		       result);
 		goto fail_frontend;
 	}
 
@@ -435,8 +435,7 @@ static int dvb_register(struct au0828_dev *dev)
 	dvb->demux.stop_feed  = au0828_dvb_stop_feed;
 	result = dvb_dmx_init(&dvb->demux);
 	if (result < 0) {
-		printk(KERN_ERR "%s: dvb_dmx_init failed (errno = %d)\n",
-		       DRIVER_NAME, result);
+		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
 		goto fail_dmx;
 	}
 
@@ -445,31 +444,29 @@ static int dvb_register(struct au0828_dev *dev)
 	dvb->dmxdev.capabilities = 0;
 	result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
 	if (result < 0) {
-		printk(KERN_ERR "%s: dvb_dmxdev_init failed (errno = %d)\n",
-		       DRIVER_NAME, result);
+		pr_err("dvb_dmxdev_init failed (errno = %d)\n", result);
 		goto fail_dmxdev;
 	}
 
 	dvb->fe_hw.source = DMX_FRONTEND_0;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		printk(KERN_ERR "%s: add_frontend failed "
-		       "(DMX_FRONTEND_0, errno = %d)\n", DRIVER_NAME, result);
+		pr_err("add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
+		       result);
 		goto fail_fe_hw;
 	}
 
 	dvb->fe_mem.source = DMX_MEMORY_FE;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	if (result < 0) {
-		printk(KERN_ERR "%s: add_frontend failed "
-		       "(DMX_MEMORY_FE, errno = %d)\n", DRIVER_NAME, result);
+		pr_err("add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
+		       result);
 		goto fail_fe_mem;
 	}
 
 	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		printk(KERN_ERR "%s: connect_frontend failed (errno = %d)\n",
-		       DRIVER_NAME, result);
+		pr_err("connect_frontend failed (errno = %d)\n", result);
 		goto fail_fe_conn;
 	}
 
@@ -595,12 +592,11 @@ int au0828_dvb_register(struct au0828_dev *dev)
 		}
 		break;
 	default:
-		printk(KERN_WARNING "The frontend of your DVB/ATSC card "
-		       "isn't supported yet\n");
+		pr_warn("The frontend of your DVB/ATSC card isn't supported yet\n");
 		break;
 	}
 	if (NULL == dvb->frontend) {
-		printk(KERN_ERR "%s() Frontend initialization failed\n",
+		pr_err("%s() Frontend initialization failed\n",
 		       __func__);
 		return -1;
 	}
diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
index daaeaf1b089c..ae7ac6669769 100644
--- a/drivers/media/usb/au0828/au0828-i2c.c
+++ b/drivers/media/usb/au0828/au0828-i2c.c
@@ -19,13 +19,14 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "au0828.h"
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 
-#include "au0828.h"
 #include "media/tuner.h"
 #include <media/v4l2-common.h>
 
@@ -340,7 +341,7 @@ static struct i2c_algorithm au0828_i2c_algo_template = {
 /* ----------------------------------------------------------------------- */
 
 static struct i2c_adapter au0828_i2c_adap_template = {
-	.name              = DRIVER_NAME,
+	.name              = KBUILD_MODNAME,
 	.owner             = THIS_MODULE,
 	.algo              = &au0828_i2c_algo_template,
 };
@@ -365,7 +366,7 @@ static void do_i2c_scan(char *name, struct i2c_client *c)
 		rc = i2c_master_recv(c, &buf, 0);
 		if (rc < 0)
 			continue;
-		printk(KERN_INFO "%s: i2c scan: found device @ 0x%x  [%s]\n",
+		pr_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
 		       name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 }
@@ -381,7 +382,7 @@ int au0828_i2c_register(struct au0828_dev *dev)
 
 	dev->i2c_adap.dev.parent = &dev->usbdev->dev;
 
-	strlcpy(dev->i2c_adap.name, DRIVER_NAME,
+	strlcpy(dev->i2c_adap.name, KBUILD_MODNAME,
 		sizeof(dev->i2c_adap.name));
 
 	dev->i2c_adap.algo = &dev->i2c_algo;
@@ -396,11 +397,11 @@ int au0828_i2c_register(struct au0828_dev *dev)
 	dev->i2c_client.adapter = &dev->i2c_adap;
 
 	if (0 == dev->i2c_rc) {
-		printk(KERN_INFO "%s: i2c bus registered\n", DRIVER_NAME);
+		pr_info("i2c bus registered\n");
 		if (i2c_scan)
-			do_i2c_scan(DRIVER_NAME, &dev->i2c_client);
+			do_i2c_scan(KBUILD_MODNAME, &dev->i2c_client);
 	} else
-		printk(KERN_INFO "%s: i2c bus register FAILED\n", DRIVER_NAME);
+		pr_info("i2c bus register FAILED\n");
 
 	return dev->i2c_rc;
 }
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 5efb83977f39..6db1ce8e09e1 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -17,6 +17,8 @@
   GNU General Public License for more details.
  */
 
+#include "au0828.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -29,8 +31,6 @@ static int disable_ir;
 module_param(disable_ir,        int, 0444);
 MODULE_PARM_DESC(disable_ir, "disable infrared remote support");
 
-#include "au0828.h"
-
 struct au0828_rc {
 	struct au0828_dev *dev;
 	struct rc_dev *rc;
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 63f593070ee8..932d24f42b24 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -21,13 +21,13 @@
    02110-1301, USA.
  */
 
+#include "au0828.h"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 
-#include "au0828.h"
-
 static unsigned int vbibufs = 5;
 module_param(vbibufs, int, 0644);
 MODULE_PARM_DESC(vbibufs, "number of vbi buffers, range 2-32");
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 574a08c7013d..193b2e364266 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -28,6 +28,8 @@
  *
  */
 
+#include "au0828.h"
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -36,7 +38,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
 #include <media/tuner.h>
-#include "au0828.h"
 #include "au0828-reg.h"
 
 static DEFINE_MUTEX(au0828_sysfs_lock);
@@ -52,7 +53,7 @@ MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
 #define au0828_isocdbg(fmt, arg...) \
 do {\
 	if (isoc_debug) { \
-		printk(KERN_INFO "au0828 %s :"fmt, \
+		pr_info("au0828 %s :"fmt, \
 		       __func__ , ##arg);	   \
 	} \
   } while (0)
@@ -105,12 +106,12 @@ static inline void print_err_status(struct au0828_dev *dev,
 static int check_dev(struct au0828_dev *dev)
 {
 	if (dev->dev_state & DEV_DISCONNECTED) {
-		printk(KERN_INFO "v4l2 ioctl: device not present\n");
+		pr_info("v4l2 ioctl: device not present\n");
 		return -ENODEV;
 	}
 
 	if (dev->dev_state & DEV_MISCONFIGURED) {
-		printk(KERN_INFO "v4l2 ioctl: device is misconfigured; "
+		pr_info("v4l2 ioctl: device is misconfigured; "
 		       "close and open it again\n");
 		return -EIO;
 	}
@@ -719,7 +720,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
 		rc = videobuf_iolock(vq, &buf->vb, NULL);
 		if (rc < 0) {
-			printk(KERN_INFO "videobuf_iolock failed\n");
+			pr_info("videobuf_iolock failed\n");
 			goto fail;
 		}
 	}
@@ -732,7 +733,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 				      AU0828_MAX_ISO_BUFS, dev->max_pkt_size,
 				      au0828_isoc_copy);
 		if (rc < 0) {
-			printk(KERN_INFO "au0828_init_isoc failed\n");
+			pr_info("au0828_init_isoc failed\n");
 			goto fail;
 		}
 	}
@@ -803,7 +804,7 @@ static int au0828_analog_stream_enable(struct au0828_dev *d)
 		/* set au0828 interface0 to AS5 here again */
 		ret = usb_set_interface(d->usbdev, 0, 5);
 		if (ret < 0) {
-			printk(KERN_INFO "Au0828 can't set alt setting to 5!\n");
+			pr_info("Au0828 can't set alt setting to 5!\n");
 			return -EBUSY;
 		}
 	}
@@ -1092,7 +1093,7 @@ static int au0828_v4l2_close(struct file *filp)
 		   USB bandwidth */
 		ret = usb_set_interface(dev->usbdev, 0, 0);
 		if (ret < 0)
-			printk(KERN_INFO "Au0828 can't set alternate to 0!\n");
+			pr_info("Au0828 can't set alternate to 0!\n");
 	}
 	mutex_unlock(&dev->lock);
 
@@ -1346,7 +1347,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		return rc;
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		printk(KERN_INFO "%s queue busy\n", __func__);
+		pr_info("%s queue busy\n", __func__);
 		rc = -EBUSY;
 		goto out;
 	}
@@ -1999,7 +2000,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	retval = usb_set_interface(dev->usbdev,
 			interface->cur_altsetting->desc.bInterfaceNumber, 5);
 	if (retval != 0) {
-		printk(KERN_INFO "Failure setting usb interface0 to as5\n");
+		pr_info("Failure setting usb interface0 to as5\n");
 		return retval;
 	}
 
@@ -2023,7 +2024,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 		}
 	}
 	if (!(dev->isoc_in_endpointaddr)) {
-		printk(KERN_INFO "Could not locate isoc endpoint\n");
+		pr_info("Could not locate isoc endpoint\n");
 		kfree(dev);
 		return -ENODEV;
 	}
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 0d8cfe5cd264..d187129b96b7 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -19,6 +19,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
@@ -42,7 +44,6 @@
 #include "au0828-reg.h"
 #include "au0828-cards.h"
 
-#define DRIVER_NAME "au0828"
 #define URB_COUNT   16
 #define URB_BUFSIZE (0xe522)
 
@@ -331,7 +332,7 @@ extern struct videobuf_queue_ops au0828_vbi_qops;
 
 #define dprintk(level, fmt, arg...)\
 	do { if (au0828_debug & level)\
-		printk(KERN_DEBUG DRIVER_NAME "/0: " fmt, ## arg);\
+		printk(KERN_DEBUG pr_fmt(fmt), ## arg);\
 	} while (0)
 
 /* au0828-input.c */
-- 
1.9.3

