Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4634 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835AbaGQXku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:40:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.17 1/4] go7007: update the README, fix checkpatch warnings
Date: Fri, 18 Jul 2014 01:40:20 +0200
Message-Id: <1405640423-1037-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
References: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This prepares the driver for moving out of staging.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/README           |  1 -
 drivers/staging/media/go7007/go7007-driver.c  |  6 +----
 drivers/staging/media/go7007/go7007-fw.c      |  4 ----
 drivers/staging/media/go7007/go7007-i2c.c     |  4 ----
 drivers/staging/media/go7007/go7007-loader.c  |  4 ----
 drivers/staging/media/go7007/go7007-priv.h    |  4 ----
 drivers/staging/media/go7007/go7007-usb.c     |  4 ----
 drivers/staging/media/go7007/go7007-v4l2.c    |  4 ----
 drivers/staging/media/go7007/s2250-board.c    |  9 +++----
 drivers/staging/media/go7007/saa7134-go7007.c | 34 +++++++++++----------------
 drivers/staging/media/go7007/snd-go7007.c     |  4 ----
 11 files changed, 18 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/media/go7007/README b/drivers/staging/media/go7007/README
index 3af0d90..34516ea 100644
--- a/drivers/staging/media/go7007/README
+++ b/drivers/staging/media/go7007/README
@@ -1,5 +1,4 @@
 Todo:
-	- create an API for motion detection
 	- let s2250-board use i2c subdevs as well instead of hardcoding
 	  support for the i2c devices.
 	- when the driver is moved out of staging, support for saa7134-go7007
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index c200601..95cffb7 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #include <linux/module.h>
@@ -225,7 +221,7 @@ static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *con
 		return 0;
 	}
 
-	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", i2c->type);
+	pr_info("go7007: probing for module i2c:%s failed\n", i2c->type);
 	return -EINVAL;
 }
 
diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index f60640b..5f4c9b9 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 /*
diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
index 4cf4c0d..55addfa 100644
--- a/drivers/staging/media/go7007/go7007-i2c.c
+++ b/drivers/staging/media/go7007/go7007-i2c.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/media/go7007/go7007-loader.c b/drivers/staging/media/go7007/go7007-loader.c
index 491d0e6..042f78a 100644
--- a/drivers/staging/media/go7007/go7007-loader.c
+++ b/drivers/staging/media/go7007/go7007-loader.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index a8aefed..2251c3f 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 /*
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 2f62be9..ece27ec 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 4bf143f..ec799b4 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index eaa2b09..bb84668 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #include <linux/module.h>
@@ -573,11 +569,12 @@ static int s2250_probe(struct i2c_client *client,
 	if (mutex_lock_interruptible(&usb->i2c_lock) == 0) {
 		data = kzalloc(16, GFP_KERNEL);
 		if (data != NULL) {
-			int rc;
-			rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
+			int rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
 						       data, 16, 1);
+
 			if (rc > 0) {
 				u8 mask;
+
 				data[0] = 0;
 				mask = 1<<5;
 				data[0] &= ~mask;
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index df5cb1c..b137432 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #include <linux/module.h>
@@ -167,7 +163,7 @@ static int saa7134_go7007_interface_reset(struct go7007 *go)
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 
 	status = saa_readb(SAA7134_GPIO_GPSTATUS2);
-	/*printk(KERN_DEBUG "status is %s\n", status & 0x40 ? "OK" : "not OK"); */
+	/*pr_debug("status is %s\n", status & 0x40 ? "OK" : "not OK"); */
 
 	/* enter command mode...(?) */
 	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_REQ1);
@@ -177,14 +173,13 @@ static int saa7134_go7007_interface_reset(struct go7007 *go)
 		saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 		saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 		status = saa_readb(SAA7134_GPIO_GPSTATUS2);
-		/*printk(KERN_INFO "gpio is %08x\n", saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2)); */
+		/*pr_info("gpio is %08x\n", saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2)); */
 	} while (--count > 0);
 
 	/* Wait for an interrupt to indicate successful hardware reset */
 	if (go7007_read_interrupt(go, &intr_val, &intr_data) < 0 ||
 			(intr_val & ~0x1) != 0x55aa) {
-		printk(KERN_ERR
-			"saa7134-go7007: unable to reset the GO7007\n");
+		pr_err("saa7134-go7007: unable to reset the GO7007\n");
 		return -1;
 	}
 	return 0;
@@ -198,8 +193,7 @@ static int saa7134_go7007_write_interrupt(struct go7007 *go, int addr, int data)
 	u16 status_reg;
 
 #ifdef GO7007_HPI_DEBUG
-	printk(KERN_DEBUG
-		"saa7134-go7007: WriteInterrupt: %04x %04x\n", addr, data);
+	pr_debug("saa7134-go7007: WriteInterrupt: %04x %04x\n", addr, data);
 #endif
 
 	for (i = 0; i < 100; ++i) {
@@ -209,8 +203,7 @@ static int saa7134_go7007_write_interrupt(struct go7007 *go, int addr, int data)
 		msleep(10);
 	}
 	if (i == 100) {
-		printk(KERN_ERR
-			"saa7134-go7007: device is hung, status reg = 0x%04x\n",
+		pr_err("saa7134-go7007: device is hung, status reg = 0x%04x\n",
 			status_reg);
 		return -1;
 	}
@@ -230,7 +223,7 @@ static int saa7134_go7007_read_interrupt(struct go7007 *go)
 	gpio_read(dev, HPI_ADDR_INTR_RET_VALUE, &go->interrupt_value);
 	gpio_read(dev, HPI_ADDR_INTR_RET_DATA, &go->interrupt_data);
 #ifdef GO7007_HPI_DEBUG
-	printk(KERN_DEBUG "saa7134-go7007: ReadInterrupt: %04x %04x\n",
+	pr_debug("saa7134-go7007: ReadInterrupt: %04x %04x\n",
 			go->interrupt_value, go->interrupt_data);
 #endif
 	return 0;
@@ -245,7 +238,7 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
 	if (!vb2_is_streaming(&go->vidq))
 		return;
 	if (0 != (status & 0x000f0000))
-		printk(KERN_DEBUG "saa7134-go7007: irq: lost %ld\n",
+		pr_debug("saa7134-go7007: irq: lost %ld\n",
 				(status >> 16) & 0x0f);
 	if (status & 0x100000) {
 		dma_sync_single_for_cpu(&dev->pci->dev,
@@ -355,8 +348,7 @@ static int saa7134_go7007_send_firmware(struct go7007 *go, u8 *data, int len)
 	int i;
 
 #ifdef GO7007_HPI_DEBUG
-	printk(KERN_DEBUG "saa7134-go7007: DownloadBuffer "
-			"sending %d bytes\n", len);
+	pr_debug("saa7134-go7007: DownloadBuffer sending %d bytes\n", len);
 #endif
 
 	while (len > 0) {
@@ -378,8 +370,8 @@ static int saa7134_go7007_send_firmware(struct go7007 *go, u8 *data, int len)
 				break;
 		}
 		if (i == 100) {
-			printk(KERN_ERR "saa7134-go7007: device is hung, "
-					"status reg = 0x%04x\n", status_reg);
+			pr_err("saa7134-go7007: device is hung, status reg = 0x%04x\n",
+					status_reg);
 			return -1;
 		}
 	}
@@ -416,6 +408,7 @@ static int saa7134_go7007_s_ctrl(struct v4l2_subdev *sd,
 {
 	struct saa7134_go7007 *saa = to_state(sd);
 	struct saa7134_dev *dev = saa->dev;
+
 	return saa7134_s_ctrl_internal(dev, NULL, ctrl);
 }
 
@@ -424,6 +417,7 @@ static int saa7134_go7007_g_ctrl(struct v4l2_subdev *sd,
 {
 	struct saa7134_go7007 *saa = to_state(sd);
 	struct saa7134_dev *dev = saa->dev;
+
 	return saa7134_g_ctrl_internal(dev, NULL, ctrl);
 }
 
@@ -455,7 +449,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	struct saa7134_go7007 *saa;
 	struct v4l2_subdev *sd;
 
-	printk(KERN_DEBUG "saa7134-go7007: probing new SAA713X board\n");
+	pr_debug("saa7134-go7007: probing new SAA713X board\n");
 
 	go = go7007_alloc(&board_voyager, &dev->pci->dev);
 	if (go == NULL)
@@ -500,7 +494,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 
 	/* Register the subdevice interface with the go7007 device */
 	if (v4l2_device_register_subdev(&go->v4l2_dev, sd) < 0)
-		printk(KERN_INFO "saa7134-go7007: register subdev failed\n");
+		pr_info("saa7134-go7007: register subdev failed\n");
 
 	dev->empress_dev = &go->vdev;
 
diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
index 9eb2a20..d22d7d5 100644
--- a/drivers/staging/media/go7007/snd-go7007.c
+++ b/drivers/staging/media/go7007/snd-go7007.c
@@ -9,10 +9,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
-- 
2.0.0

