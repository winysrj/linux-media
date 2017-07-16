Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46240 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 16/16] [media] dvb-core/dvb_ca_en50221.c: Fixed multiple blank lines
Date: Sun, 16 Jul 2017 02:43:17 +0200
Message-Id: <1500165797-16987-17-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

- Running "checkpatch.pl -strict -f ..." complained
  * Please don't use multiple blank lines

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 40 ---------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index fa5f5ef..95b3723 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -86,7 +86,6 @@ MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 #define DVB_CA_SLOTSTATE_WAITFR         6
 #define DVB_CA_SLOTSTATE_LINKINIT       7
 
-
 /* Information on a CA slot */
 struct dvb_ca_slot {
 	/* current state of the CAM */
@@ -200,7 +199,6 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 				     u8 *ebuf, int ecount);
 
-
 /**
  * Safely find needle in haystack.
  *
@@ -225,12 +223,9 @@ static char *findstr(char *haystack, int hlen, char *needle, int nlen)
 	return NULL;
 }
 
-
-
 /* ************************************************************************** */
 /* EN50221 physical interface functions */
 
-
 /**
  * dvb_ca_en50221_check_camstatus - Check CAM status.
  */
@@ -273,7 +268,6 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	return cam_changed;
 }
 
-
 /**
  * dvb_ca_en50221_wait_if_status - Wait for flags to become set on the STATUS
  *	 register on a CAM interface, checking for errors and timeout.
@@ -325,7 +319,6 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 	return -ETIMEDOUT;
 }
 
-
 /**
  * dvb_ca_en50221_link_init - Initialise the link layer connection to a CAM.
  *
@@ -455,7 +448,6 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 	return 0;
 }
 
-
 /**
  * dvb_ca_en50221_parse_attributes - Parse attribute memory of a CAM module,
  *	extracting Config register, and checking it is a DVB CAM module.
@@ -481,7 +473,6 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	u16 manfid = 0;
 	u16 devid = 0;
 
-
 	/* CISTPL_DEVICE_0A */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
@@ -490,8 +481,6 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	if (tuple_type != 0x1D)
 		return -EINVAL;
 
-
-
 	/* CISTPL_DEVICE_0C */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
@@ -500,8 +489,6 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	if (tuple_type != 0x1C)
 		return -EINVAL;
 
-
-
 	/* CISTPL_VERS_1 */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
@@ -510,8 +497,6 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	if (tuple_type != 0x15)
 		return -EINVAL;
 
-
-
 	/* CISTPL_MANFID */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
@@ -524,8 +509,6 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	manfid = (tuple[1] << 8) | tuple[0];
 	devid = (tuple[3] << 8) | tuple[2];
 
-
-
 	/* CISTPL_CONFIG */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
@@ -613,7 +596,6 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	return 0;
 }
 
-
 /**
  * dvb_ca_en50221_set_configoption - Set CAM's configoption correctly.
  *
@@ -641,7 +623,6 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
 	return 0;
 }
 
-
 /**
  * dvb_ca_en50221_read_data - This function talks to an EN50221 CAM control
  *	interface. It reads a buffer of data from the CAM. The data can either
@@ -797,7 +778,6 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 	return status;
 }
 
-
 /**
  * dvb_ca_en50221_write_data - This function talks to an EN50221 CAM control
  *				interface. It writes a buffer of data to a CAM.
@@ -819,7 +799,6 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 
 	dprintk("%s\n", __func__);
 
-
 	/* sanity check */
 	if (bytes_write > sl->link_buf_size)
 		return -EINVAL;
@@ -923,12 +902,9 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	return status;
 }
 
-
-
 /* ************************************************************************** */
 /* EN50221 higher level functions */
 
-
 /**
  * dvb_ca_en50221_slot_shutdown - A CAM has been removed => shut it down.
  *
@@ -954,7 +930,6 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 	return 0;
 }
 
-
 /**
  * dvb_ca_en50221_camchange_irq - A CAMCHANGE IRQ has occurred.
  *
@@ -985,7 +960,6 @@ void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot,
 }
 EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 
-
 /**
  * dvb_ca_en50221_camready_irq - A CAMREADY IRQ has occurred.
  *
@@ -1006,7 +980,6 @@ void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 }
 EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
 
-
 /**
  * dvb_ca_en50221_frda_irq - An FR or DA IRQ has occurred.
  *
@@ -1038,7 +1011,6 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 }
 EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
 
-
 /* ************************************************************************** */
 /* EN50221 thread functions */
 
@@ -1357,8 +1329,6 @@ static int dvb_ca_en50221_thread(void *data)
 	return 0;
 }
 
-
-
 /* ************************************************************************** */
 /* EN50221 IO interface functions */
 
@@ -1447,7 +1417,6 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 	return err;
 }
 
-
 /**
  * Wrapper for ioctl implementation.
  *
@@ -1464,7 +1433,6 @@ static long dvb_ca_en50221_io_ioctl(struct file *file,
 	return dvb_usercopy(file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
 }
 
-
 /**
  * Implementation of write() syscall.
  *
@@ -1568,7 +1536,6 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 	return status;
 }
 
-
 /**
  * Condition for waking up in dvb_ca_en50221_io_read_condition
  */
@@ -1618,7 +1585,6 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 	return found;
 }
 
-
 /**
  * Implementation of read() syscall.
  *
@@ -1730,7 +1696,6 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 	return status;
 }
 
-
 /**
  * Implementation of file open syscall.
  *
@@ -1781,7 +1746,6 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-
 /**
  * Implementation of file close syscall.
  *
@@ -1811,7 +1775,6 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 	return err;
 }
 
-
 /**
  * Implementation of poll() syscall.
  *
@@ -1846,7 +1809,6 @@ static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-
 static const struct file_operations dvb_ca_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_ca_en50221_io_read,
@@ -1872,7 +1834,6 @@ static const struct dvb_device dvbdev_ca = {
 /* ************************************************************************** */
 /* Initialisation/shutdown functions */
 
-
 /**
  * Initialise a new DVB CA EN50221 interface device.
  *
@@ -1965,7 +1926,6 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 }
 EXPORT_SYMBOL(dvb_ca_en50221_init);
 
-
 /**
  * Release a DVB CA EN50221 interface device.
  *
-- 
2.7.4
