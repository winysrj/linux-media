Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2J0UmH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:07 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg7k6006301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/68] [media] cx23885: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:28 -0200
Message-Id: <1351370486-29040-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/cx23885/altera-ci.c:266:5: warning: no previous prototype for 'altera_ci_op_cam' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:301:5: warning: no previous prototype for 'altera_ci_read_attribute_mem' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:307:5: warning: no previous prototype for 'altera_ci_write_attribute_mem' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:313:5: warning: no previous prototype for 'altera_ci_read_cam_ctl' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:319:5: warning: no previous prototype for 'altera_ci_write_cam_ctl' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:325:5: warning: no previous prototype for 'altera_ci_slot_reset' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:368:5: warning: no previous prototype for 'altera_ci_slot_shutdown' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:374:5: warning: no previous prototype for 'altera_ci_slot_ts_ctl' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:451:5: warning: no previous prototype for 'altera_poll_ci_slot_status' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:462:6: warning: no previous prototype for 'altera_hw_filt_release' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:584:5: warning: no previous prototype for 'altera_pid_feed_control' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:606:5: warning: no previous prototype for 'altera_ci_start_feed' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:613:5: warning: no previous prototype for 'altera_ci_stop_feed' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:620:5: warning: no previous prototype for 'altera_ci_start_feed_1' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:625:5: warning: no previous prototype for 'altera_ci_stop_feed_1' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:630:5: warning: no previous prototype for 'altera_ci_start_feed_2' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:635:5: warning: no previous prototype for 'altera_ci_stop_feed_2' [-Wmissing-prototypes]
drivers/media/pci/cx23885/altera-ci.c:640:5: warning: no previous prototype for 'altera_hw_filt_init' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:123:5: warning: no previous prototype for 'netup_write_i2c' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:150:5: warning: no previous prototype for 'netup_ci_get_mem' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:169:5: warning: no previous prototype for 'netup_ci_op_cam' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:239:5: warning: no previous prototype for 'netup_ci_read_attribute_mem' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:245:5: warning: no previous prototype for 'netup_ci_write_attribute_mem' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:251:5: warning: no previous prototype for 'netup_ci_read_cam_ctl' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:257:5: warning: no previous prototype for 'netup_ci_write_cam_ctl' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:263:5: warning: no previous prototype for 'netup_ci_slot_reset' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:292:5: warning: no previous prototype for 'netup_ci_slot_shutdown' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:298:5: warning: no previous prototype for 'netup_ci_set_irq' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:319:5: warning: no previous prototype for 'netup_ci_slot_ts_ctl' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:375:5: warning: no previous prototype for 'netup_ci_slot_status' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:402:5: warning: no previous prototype for 'netup_poll_ci_slot_status' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:415:5: warning: no previous prototype for 'netup_ci_init' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:520:6: warning: no previous prototype for 'netup_ci_exit' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cimax2.c:90:5: warning: no previous prototype for 'netup_read_i2c' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-av.c:26:6: warning: no previous prototype for 'cx23885_av_work_handler' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-cards.c:1430:5: warning: no previous prototype for 'netup_jtag_io' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-core.c:306:6: warning: no previous prototype for 'cx23885_irq_add' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-dvb.c:662:5: warning: no previous prototype for 'netup_altera_fpga_rw' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-f300.c:150:5: warning: no previous prototype for 'f300_set_voltage' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-input.c:249:5: warning: no previous prototype for 'cx23885_input_init' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-input.c:353:6: warning: no previous prototype for 'cx23885_input_fini' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-input.c:76:6: warning: no previous prototype for 'cx23885_input_rx_work_handler' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-ioctl.c:134:5: warning: no previous prototype for 'cx23885_g_register' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-ioctl.c:185:5: warning: no previous prototype for 'cx23885_s_register' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-ioctl.c:27:5: warning: no previous prototype for 'cx23885_g_chip_ident' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-ir.c:101:6: warning: no previous prototype for 'cx23885_ir_tx_v4l2_dev_notify' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-ir.c:37:6: warning: no previous prototype for 'cx23885_ir_rx_work_handler' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-ir.c:60:6: warning: no previous prototype for 'cx23885_ir_tx_work_handler' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23885-ir.c:76:6: warning: no previous prototype for 'cx23885_ir_rx_v4l2_dev_notify' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23888-ir.c:1203:5: warning: no previous prototype for 'cx23888_ir_probe' [-Wmissing-prototypes]
drivers/media/pci/cx23885/cx23888-ir.c:1253:5: warning: no previous prototype for 'cx23888_ir_remove' [-Wmissing-prototypes]
drivers/media/pci/cx23885/netup-init.c:109:6: warning: no previous prototype for 'netup_initialize' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx23885/altera-ci.c     | 45 ++++++++++++++++---------------
 drivers/media/pci/cx23885/cimax2.c        | 17 +++++++-----
 drivers/media/pci/cx23885/cx23885-av.c    |  1 +
 drivers/media/pci/cx23885/cx23885-cards.c |  2 +-
 drivers/media/pci/cx23885/cx23885-core.c  |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c   |  2 +-
 drivers/media/pci/cx23885/cx23885-f300.c  |  1 +
 drivers/media/pci/cx23885/cx23885-input.c |  1 +
 drivers/media/pci/cx23885/cx23885-input.h |  2 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c |  2 ++
 drivers/media/pci/cx23885/cx23885-ir.c    |  1 +
 drivers/media/pci/cx23885/cx23888-ir.c    |  1 +
 drivers/media/pci/cx23885/netup-init.c    |  1 +
 13 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
index 495781e..2926f7f 100644
--- a/drivers/media/pci/cx23885/altera-ci.c
+++ b/drivers/media/pci/cx23885/altera-ci.c
@@ -263,7 +263,7 @@ static int netup_fpga_op_rw(struct fpga_internal *inter, int addr,
 }
 
 /* flag - mem/io, read - read/write */
-int altera_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
+static int altera_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
 				u8 flag, u8 read, int addr, u8 val)
 {
 
@@ -298,31 +298,32 @@ int altera_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
 	return mem;
 }
 
-int altera_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
-						int slot, int addr)
+static int altera_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
+					int slot, int addr)
 {
 	return altera_ci_op_cam(en50221, slot, 0, NETUP_CI_FLG_RD, addr, 0);
 }
 
-int altera_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
-						int slot, int addr, u8 data)
+static int altera_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
+					 int slot, int addr, u8 data)
 {
 	return altera_ci_op_cam(en50221, slot, 0, 0, addr, data);
 }
 
-int altera_ci_read_cam_ctl(struct dvb_ca_en50221 *en50221, int slot, u8 addr)
+static int altera_ci_read_cam_ctl(struct dvb_ca_en50221 *en50221,
+				  int slot, u8 addr)
 {
 	return altera_ci_op_cam(en50221, slot, NETUP_CI_FLG_CTL,
 						NETUP_CI_FLG_RD, addr, 0);
 }
 
-int altera_ci_write_cam_ctl(struct dvb_ca_en50221 *en50221, int slot,
-						u8 addr, u8 data)
+static int altera_ci_write_cam_ctl(struct dvb_ca_en50221 *en50221, int slot,
+				   u8 addr, u8 data)
 {
 	return altera_ci_op_cam(en50221, slot, NETUP_CI_FLG_CTL, 0, addr, data);
 }
 
-int altera_ci_slot_reset(struct dvb_ca_en50221 *en50221, int slot)
+static int altera_ci_slot_reset(struct dvb_ca_en50221 *en50221, int slot)
 {
 	struct altera_ci_state *state = en50221->data;
 	struct fpga_internal *inter = state->internal;
@@ -365,13 +366,13 @@ int altera_ci_slot_reset(struct dvb_ca_en50221 *en50221, int slot)
 	return 0;
 }
 
-int altera_ci_slot_shutdown(struct dvb_ca_en50221 *en50221, int slot)
+static int altera_ci_slot_shutdown(struct dvb_ca_en50221 *en50221, int slot)
 {
 	/* not implemented */
 	return 0;
 }
 
-int altera_ci_slot_ts_ctl(struct dvb_ca_en50221 *en50221, int slot)
+static int altera_ci_slot_ts_ctl(struct dvb_ca_en50221 *en50221, int slot)
 {
 	struct altera_ci_state *state = en50221->data;
 	struct fpga_internal *inter = state->internal;
@@ -448,8 +449,8 @@ int altera_ci_irq(void *dev)
 }
 EXPORT_SYMBOL(altera_ci_irq);
 
-int altera_poll_ci_slot_status(struct dvb_ca_en50221 *en50221, int slot,
-								int open)
+static int altera_poll_ci_slot_status(struct dvb_ca_en50221 *en50221,
+				      int slot, int open)
 {
 	struct altera_ci_state *state = en50221->data;
 
@@ -459,7 +460,7 @@ int altera_poll_ci_slot_status(struct dvb_ca_en50221 *en50221, int slot,
 	return state->status;
 }
 
-void altera_hw_filt_release(void *main_dev, int filt_nr)
+static void altera_hw_filt_release(void *main_dev, int filt_nr)
 {
 	struct fpga_inode *temp_int = find_inode(main_dev);
 	struct netup_hw_pid_filter *pid_filt = NULL;
@@ -581,7 +582,7 @@ static void altera_toggle_fullts_streaming(struct netup_hw_pid_filter *pid_filt,
 	mutex_unlock(&inter->fpga_mutex);
 }
 
-int altera_pid_feed_control(void *demux_dev, int filt_nr,
+static int altera_pid_feed_control(void *demux_dev, int filt_nr,
 		struct dvb_demux_feed *feed, int onoff)
 {
 	struct fpga_inode *temp_int = find_dinode(demux_dev);
@@ -603,41 +604,41 @@ int altera_pid_feed_control(void *demux_dev, int filt_nr,
 }
 EXPORT_SYMBOL(altera_pid_feed_control);
 
-int altera_ci_start_feed(struct dvb_demux_feed *feed, int num)
+static int altera_ci_start_feed(struct dvb_demux_feed *feed, int num)
 {
 	altera_pid_feed_control(feed->demux, num, feed, 1);
 
 	return 0;
 }
 
-int altera_ci_stop_feed(struct dvb_demux_feed *feed, int num)
+static int altera_ci_stop_feed(struct dvb_demux_feed *feed, int num)
 {
 	altera_pid_feed_control(feed->demux, num, feed, 0);
 
 	return 0;
 }
 
-int altera_ci_start_feed_1(struct dvb_demux_feed *feed)
+static int altera_ci_start_feed_1(struct dvb_demux_feed *feed)
 {
 	return altera_ci_start_feed(feed, 1);
 }
 
-int altera_ci_stop_feed_1(struct dvb_demux_feed *feed)
+static int altera_ci_stop_feed_1(struct dvb_demux_feed *feed)
 {
 	return altera_ci_stop_feed(feed, 1);
 }
 
-int altera_ci_start_feed_2(struct dvb_demux_feed *feed)
+static int altera_ci_start_feed_2(struct dvb_demux_feed *feed)
 {
 	return altera_ci_start_feed(feed, 2);
 }
 
-int altera_ci_stop_feed_2(struct dvb_demux_feed *feed)
+static int altera_ci_stop_feed_2(struct dvb_demux_feed *feed)
 {
 	return altera_ci_stop_feed(feed, 2);
 }
 
-int altera_hw_filt_init(struct altera_ci_config *config, int hw_filt_nr)
+static int altera_hw_filt_init(struct altera_ci_config *config, int hw_filt_nr)
 {
 	struct netup_hw_pid_filter *pid_filt = NULL;
 	struct fpga_inode *temp_int = find_inode(config->dev);
diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
index 6617774..7344849 100644
--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -24,6 +24,7 @@
  */
 
 #include "cx23885.h"
+#include "cimax2.h"
 #include "dvb_ca_en50221.h"
 /**** Bit definitions for MC417_RWD and MC417_OEN registers  ***
   bits 31-16
@@ -87,7 +88,7 @@ struct netup_ci_state {
 };
 
 
-int netup_read_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
+static int netup_read_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 						u8 *buf, int len)
 {
 	int ret;
@@ -120,7 +121,7 @@ int netup_read_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 	return 0;
 }
 
-int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
+static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 						u8 *buf, int len)
 {
 	int ret;
@@ -147,7 +148,7 @@ int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 	return 0;
 }
 
-int netup_ci_get_mem(struct cx23885_dev *dev)
+static int netup_ci_get_mem(struct cx23885_dev *dev)
 {
 	int mem;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1);
@@ -166,7 +167,7 @@ int netup_ci_get_mem(struct cx23885_dev *dev)
 	return mem & 0xff;
 }
 
-int netup_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
+static int netup_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
 				u8 flag, u8 read, int addr, u8 data)
 {
 	struct netup_ci_state *state = en50221->data;
@@ -248,7 +249,8 @@ int netup_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
 	return netup_ci_op_cam(en50221, slot, 0, 0, addr, data);
 }
 
-int netup_ci_read_cam_ctl(struct dvb_ca_en50221 *en50221, int slot, u8 addr)
+int netup_ci_read_cam_ctl(struct dvb_ca_en50221 *en50221, int slot,
+				 u8 addr)
 {
 	return netup_ci_op_cam(en50221, slot, NETUP_CI_CTL,
 							NETUP_CI_RD, addr, 0);
@@ -295,7 +297,7 @@ int netup_ci_slot_shutdown(struct dvb_ca_en50221 *en50221, int slot)
 	return 0;
 }
 
-int netup_ci_set_irq(struct dvb_ca_en50221 *en50221, u8 irq_mode)
+static int netup_ci_set_irq(struct dvb_ca_en50221 *en50221, u8 irq_mode)
 {
 	struct netup_ci_state *state = en50221->data;
 	int ret;
@@ -399,7 +401,8 @@ int netup_ci_slot_status(struct cx23885_dev *dev, u32 pci_status)
 	return 1;
 }
 
-int netup_poll_ci_slot_status(struct dvb_ca_en50221 *en50221, int slot, int open)
+int netup_poll_ci_slot_status(struct dvb_ca_en50221 *en50221,
+				     int slot, int open)
 {
 	struct netup_ci_state *state = en50221->data;
 
diff --git a/drivers/media/pci/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
index 134ebdd..e958a01 100644
--- a/drivers/media/pci/cx23885/cx23885-av.c
+++ b/drivers/media/pci/cx23885/cx23885-av.c
@@ -22,6 +22,7 @@
  */
 
 #include "cx23885.h"
+#include "cx23885-av.h"
 
 void cx23885_av_work_handler(struct work_struct *work)
 {
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 5acdf95..6277e145 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1427,7 +1427,7 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 	}
 }
 
-int netup_jtag_io(void *device, int tms, int tdi, int read_tdo)
+static int netup_jtag_io(void *device, int tms, int tdi, int read_tdo)
 {
 	int data;
 	int tdo = 0;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 4189d64..065ecd5 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -303,7 +303,7 @@ static struct sram_channel cx23887_sram_channels[] = {
 	},
 };
 
-void cx23885_irq_add(struct cx23885_dev *dev, u32 mask)
+static void cx23885_irq_add(struct cx23885_dev *dev, u32 mask)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&dev->pci_irqmask_lock, flags);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 4379d8a..2f5b902 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -659,7 +659,7 @@ static struct mt2063_config terratec_mt2063_config[] = {
 	},
 };
 
-int netup_altera_fpga_rw(void *device, int flag, int data, int read)
+static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1);
diff --git a/drivers/media/pci/cx23885/cx23885-f300.c b/drivers/media/pci/cx23885/cx23885-f300.c
index 93998f2..5444cc5 100644
--- a/drivers/media/pci/cx23885/cx23885-f300.c
+++ b/drivers/media/pci/cx23885/cx23885-f300.c
@@ -29,6 +29,7 @@
  */
 
 #include "cx23885.h"
+#include "cx23885-f300.h"
 
 #define F300_DATA	GPIO_0
 #define F300_RESET	GPIO_1
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 2004039..4f1055a 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -40,6 +40,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "cx23885.h"
+#include "cx23885-input.h"
 
 #define MODULE_NAME "cx23885"
 
diff --git a/drivers/media/pci/cx23885/cx23885-input.h b/drivers/media/pci/cx23885/cx23885-input.h
index 75ef15d..87dc44e 100644
--- a/drivers/media/pci/cx23885/cx23885-input.h
+++ b/drivers/media/pci/cx23885/cx23885-input.h
@@ -23,7 +23,7 @@
 
 #ifndef _CX23885_INPUT_H_
 #define _CX23885_INPUT_H_
-int cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events);
+void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events);
 
 int cx23885_input_init(struct cx23885_dev *dev);
 void cx23885_input_fini(struct cx23885_dev *dev);
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
index 44812ca..ea9a614 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.c
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.c
@@ -22,6 +22,8 @@
  */
 
 #include "cx23885.h"
+#include "cx23885-ioctl.h"
+
 #include <media/v4l2-chip-ident.h>
 
 int cx23885_g_chip_ident(struct file *file, void *fh,
diff --git a/drivers/media/pci/cx23885/cx23885-ir.c b/drivers/media/pci/cx23885/cx23885-ir.c
index 7125247..bfef193 100644
--- a/drivers/media/pci/cx23885/cx23885-ir.c
+++ b/drivers/media/pci/cx23885/cx23885-ir.c
@@ -24,6 +24,7 @@
 #include <media/v4l2-device.h>
 
 #include "cx23885.h"
+#include "cx23885-ir.h"
 #include "cx23885-input.h"
 
 #define CX23885_IR_RX_FIFO_SERVICE_REQ		0
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index c2bc39c..c4bd1e9 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -29,6 +29,7 @@
 #include <media/rc-core.h>
 
 #include "cx23885.h"
+#include "cx23888-ir.h"
 
 static unsigned int ir_888_debug;
 module_param(ir_888_debug, int, 0644);
diff --git a/drivers/media/pci/cx23885/netup-init.c b/drivers/media/pci/cx23885/netup-init.c
index f4893e6..0044fef 100644
--- a/drivers/media/pci/cx23885/netup-init.c
+++ b/drivers/media/pci/cx23885/netup-init.c
@@ -24,6 +24,7 @@
  */
 
 #include "cx23885.h"
+#include "netup-init.h"
 
 static void i2c_av_write(struct i2c_adapter *i2c, u16 reg, u8 val)
 {
-- 
1.7.11.7

