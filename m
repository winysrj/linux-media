Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m14MQjPG030807
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 17:26:45 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m14MQESs004664
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 17:26:15 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: video4linux-list@redhat.com
Date: Mon, 4 Feb 2008 23:26:08 +0100
References: <20080204073357.0cbd20c4@gaivota>
In-Reply-To: <20080204073357.0cbd20c4@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042326.08270.tobias.lorenz@gmx.net>
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	Linux DVB <linux-dvb@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] radio-si470x version 1.0.6
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

Hi Mauro,

> Unfortunately, there were a crash at the server that I use for my inboxes.

Good luck to reassemble your data... I've been gone through this too.

> [PATCH (resend)] - for patches that you're re-sending to me

This patch combines all the finished discussions and its resulting patches from the mailing list.
It's against the current mercurial version from 2008-Feb-04.

The version 1.0.6 is mainly influenced by Oliver Neukum.
He found a lot of small issues, that are fixed with this patch now.
For me the most interesting thing is, that it's now safer to use it on other architectures.

I suggest to also upload the current version of the driver into the linux git repository.
I've seen that version 1.0.4, which has some unwanted "hidden features", is currently in the linus' git repository.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/media/radio/radio-si470x.c;h=8e4bd4769048ccb65dd455e9f763b233db9c3137;hb=HEAD

The history for version 1.0.6 is:
- fixed coverity checker warnings in *_usb_driver_disconnect
- probe()/open() race by correct ordering in probe()
- DMA coherency rules by separate allocation of all buffers
- use of endianness macros
- abuse of spinlock, replaced by mutex
- racy handling of timer in disconnect, replaced by delayed_work
- racy interruptible_sleep_on(), replaced with wait_event_interruptible()
- handle signals in read()

The driver is tested with all Debian/testing radio programs and rdsd. The patch is tested against checkpatch.pl v1.12.

I'm still discussing the USB autosuspend feature with Oliver Neukum. I send a patch, as soon as it is finished and working.

Bye,
  Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- 20080204_mercurial/drivers/media/radio/radio-si470x.c	2008-02-04 23:03:09.000000000 +0100
+++ 1.0.6b_printk/drivers/media/radio/radio-si470x.c	2008-02-04 22:58:55.000000000 +0100
@@ -66,8 +66,21 @@
  *		Version 1.0.5
  *		- number of seek_retries changed to tune_timeout
  *		- fixed problem with incomplete tune operations by own buffers
- *		- optimization of variables
+ *		- optimization of variables and printf types
  *		- improved error logging
+ * 2008-01-31	Tobias Lorenz <tobias.lorenz@gmx.net>
+ *		Oliver Neukum <oliver@neukum.org>
+ *		Version 1.0.6
+ *		- fixed coverity checker warnings in *_usb_driver_disconnect
+ *		- probe()/open() race by correct ordering in probe()
+ *		- DMA coherency rules by separate allocation of all buffers
+ *		- use of endianness macros
+ *		- abuse of spinlock, replaced by mutex
+ *		- racy handling of timer in disconnect,
+ *		  replaced by delayed_work
+ *		- racy interruptible_sleep_on(),
+ *		  replaced with wait_event_interruptible()
+ *		- handle signals in read()
  *
  * ToDo:
  * - add seeking support
@@ -80,10 +93,10 @@
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_NAME "radio-si470x"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 5)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 6)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.5"
+#define DRIVER_VERSION "1.0.6"
 
 
 /* kernel includes */
@@ -97,8 +110,10 @@
 #include <linux/version.h>
 #include "compat.h"
 #include <linux/videodev2.h>
+#include <linux/mutex.h>
 #include <media/v4l2-common.h>
 #include <media/rds.h>
+#include <asm/unaligned.h>
 
 
 /* USB Device ID List */
@@ -410,10 +425,9 @@ struct si470x_device {
 	unsigned short registers[RADIO_REGISTER_NUM];
 
 	/* RDS receive buffer */
-	struct work_struct work;
+	struct delayed_work work;
 	wait_queue_head_t read_queue;
-	struct timer_list timer;
-	spinlock_t lock;		/* buffer locking */
+	struct mutex lock;		/* buffer locking */
 	unsigned char *buffer;		/* size is always multiple of three */
 	unsigned int buf_size;
 	unsigned int rd_index;
@@ -495,7 +509,8 @@ static int si470x_get_register(struct si
 	retval = si470x_get_report(radio, (void *) &buf, sizeof(buf));
 
 	if (retval >= 0)
-		radio->registers[regnr] = (buf[1] << 8) | buf[2];
+		radio->registers[regnr] = be16_to_cpu(get_unaligned(
+			(unsigned short *) &buf[1]));
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -510,8 +525,8 @@ static int si470x_set_register(struct si
 	int retval;
 
 	buf[0] = REGISTER_REPORT(regnr);
-	buf[1] = (radio->registers[regnr] & 0xff00) >> 8;
-	buf[2] = (radio->registers[regnr] & 0x00ff);
+	put_unaligned(cpu_to_be16(radio->registers[regnr]),
+		(unsigned short *) &buf[1]);
 
 	retval = si470x_set_report(radio, (void *) &buf, sizeof(buf));
 
@@ -534,9 +549,9 @@ static int si470x_get_all_registers(stru
 
 	if (retval >= 0)
 		for (regnr = 0; regnr < RADIO_REGISTER_NUM; regnr++)
-			radio->registers[regnr] =
-			(buf[regnr * RADIO_REGISTER_SIZE + 1] << 8) |
-			 buf[regnr * RADIO_REGISTER_SIZE + 2];
+			radio->registers[regnr] = be16_to_cpu(get_unaligned(
+				(unsigned short *)
+				&buf[regnr * RADIO_REGISTER_SIZE + 1]));
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -559,7 +574,7 @@ static int si470x_get_rds_registers(stru
 		(void *) &buf, sizeof(buf), &size, usb_timeout);
 	if (size != sizeof(buf))
 		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_register: "
-		       "return size differs: %d != %ld\n", size, sizeof(buf));
+			"return size differs: %d != %zu\n", size, sizeof(buf));
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
 			"usb_interrupt_msg returned %d\n", retval);
@@ -567,8 +582,8 @@ static int si470x_get_rds_registers(stru
 	if (retval >= 0)
 		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
 			radio->registers[STATUSRSSI + regnr] =
-			(buf[regnr * RADIO_REGISTER_SIZE + 1] << 8) |
-			 buf[regnr * RADIO_REGISTER_SIZE + 2];
+				be16_to_cpu(get_unaligned((unsigned short *)
+				&buf[regnr * RADIO_REGISTER_SIZE + 1]));
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -601,7 +616,7 @@ static int si470x_set_chan(struct si470x
 		(!timed_out));
 	if (timed_out)
 		printk(KERN_WARNING DRIVER_NAME
-			": seek does not finish after %d ms\n", tune_timeout);
+			": seek does not finish after %u ms\n", tune_timeout);
 
 	/* stop tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
@@ -764,6 +779,11 @@ static int si470x_rds_on(struct si470x_d
  */
 static void si470x_rds(struct si470x_device *radio)
 {
+	unsigned char blocknum;
+	unsigned short bler; /* rds block errors */
+	unsigned short rds;
+	unsigned char tmpbuf[3];
+
 	/* get rds blocks */
 	if (si470x_get_rds_registers(radio) < 0)
 		return;
@@ -776,69 +796,58 @@ static void si470x_rds(struct si470x_dev
 		return;
 	}
 
-	/* copy four RDS blocks to internal buffer */
-	if (spin_trylock(&radio->lock)) {
-		unsigned char blocknum;
-		unsigned short bler; /* rds block errors */
-		unsigned short rds;
-		unsigned char tmpbuf[3];
-		unsigned char i;
-
-		/* process each rds block */
-		for (blocknum = 0; blocknum < 4; blocknum++) {
-			switch (blocknum) {
-			default:
-				bler = (radio->registers[STATUSRSSI] &
-						STATUSRSSI_BLERA) >> 9;
-				rds = radio->registers[RDSA];
-				break;
-			case 1:
-				bler = (radio->registers[READCHAN] &
-						READCHAN_BLERB) >> 14;
-				rds = radio->registers[RDSB];
-				break;
-			case 2:
-				bler = (radio->registers[READCHAN] &
-						READCHAN_BLERC) >> 12;
-				rds = radio->registers[RDSC];
-				break;
-			case 3:
-				bler = (radio->registers[READCHAN] &
-						READCHAN_BLERD) >> 10;
-				rds = radio->registers[RDSD];
-				break;
-			};
-
-			/* Fill the V4L2 RDS buffer */
-			tmpbuf[0] = rds & 0x00ff;	/* LSB */
-			tmpbuf[1] = (rds & 0xff00) >> 8;/* MSB */
-			tmpbuf[2] = blocknum;		/* offset name */
-			tmpbuf[2] |= blocknum << 3;	/* received offset */
-			if (bler > max_rds_errors)
-				tmpbuf[2] |= 0x80; /* uncorrectable errors */
-			else if (bler > 0)
-				tmpbuf[2] |= 0x40; /* corrected error(s) */
-
-			/* copy RDS block to internal buffer */
-			for (i = 0; i < 3; i++) {
-				radio->buffer[radio->wr_index] = tmpbuf[i];
-				radio->wr_index++;
-			}
-
-			/* wrap write pointer */
-			if (radio->wr_index >= radio->buf_size)
-				radio->wr_index = 0;
-
-			/* check for overflow */
-			if (radio->wr_index == radio->rd_index) {
-				/* increment and wrap read pointer */
-				radio->rd_index += 3;
-				if (radio->rd_index >= radio->buf_size)
-					radio->rd_index = 0;
-			}
+	/* copy all four RDS blocks to internal buffer */
+	mutex_lock(&radio->lock);
+	for (blocknum = 0; blocknum < 4; blocknum++) {
+		switch (blocknum) {
+		default:
+			bler = (radio->registers[STATUSRSSI] &
+					STATUSRSSI_BLERA) >> 9;
+			rds = radio->registers[RDSA];
+			break;
+		case 1:
+			bler = (radio->registers[READCHAN] &
+					READCHAN_BLERB) >> 14;
+			rds = radio->registers[RDSB];
+			break;
+		case 2:
+			bler = (radio->registers[READCHAN] &
+					READCHAN_BLERC) >> 12;
+			rds = radio->registers[RDSC];
+			break;
+		case 3:
+			bler = (radio->registers[READCHAN] &
+					READCHAN_BLERD) >> 10;
+			rds = radio->registers[RDSD];
+			break;
+		};
+
+		/* Fill the V4L2 RDS buffer */
+		put_unaligned(cpu_to_le16(rds), (unsigned short *) &tmpbuf);
+		tmpbuf[2] = blocknum;		/* offset name */
+		tmpbuf[2] |= blocknum << 3;	/* received offset */
+		if (bler > max_rds_errors)
+			tmpbuf[2] |= 0x80; /* uncorrectable errors */
+		else if (bler > 0)
+			tmpbuf[2] |= 0x40; /* corrected error(s) */
+
+		/* copy RDS block to internal buffer */
+		memcpy(&radio->buffer[radio->wr_index], &tmpbuf, 3);
+		radio->wr_index += 3;
+
+		/* wrap write pointer */
+		if (radio->wr_index >= radio->buf_size)
+			radio->wr_index = 0;
+
+		/* check for overflow */
+		if (radio->wr_index == radio->rd_index) {
+			/* increment and wrap read pointer */
+			radio->rd_index += 3;
+			if (radio->rd_index >= radio->buf_size)
+				radio->rd_index = 0;
 		}
-		spin_unlock(&radio->lock);
 	}
+	mutex_unlock(&radio->lock);
 
 	/* wake up read queue */
 	if (radio->wr_index != radio->rd_index)
@@ -847,29 +856,18 @@ static void si470x_rds(struct si470x_dev
 
 
 /*
- * si470x_timer - rds timer function
- */
-static void si470x_timer(unsigned long data)
-{
-	struct si470x_device *radio = (struct si470x_device *) data;
-
-	schedule_work(&radio->work);
-}
-
-
-/*
  * si470x_work - rds work function
  */
 static void si470x_work(struct work_struct *work)
 {
 	struct si470x_device *radio = container_of(work, struct si470x_device,
-		work);
+		work.work);
 
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		return;
 
 	si470x_rds(radio);
-	mod_timer(&radio->timer, jiffies + msecs_to_jiffies(rds_poll_time));
+	schedule_delayed_work(&radio->work, msecs_to_jiffies(rds_poll_time));
 }
 
 
@@ -886,49 +884,49 @@ static ssize_t si470x_fops_read(struct f
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval = 0;
+	unsigned int block_count = 0;
 
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
 		si470x_rds_on(radio);
-		schedule_work(&radio->work);
+		schedule_delayed_work(&radio->work,
+			msecs_to_jiffies(rds_poll_time));
 	}
 
 	/* block if no new data available */
 	while (radio->wr_index == radio->rd_index) {
 		if (file->f_flags & O_NONBLOCK)
 			return -EWOULDBLOCK;
-		interruptible_sleep_on(&radio->read_queue);
+		if (wait_event_interruptible(radio->read_queue,
+			radio->wr_index != radio->rd_index) < 0)
+			return -EINTR;
 	}
 
 	/* calculate block count from byte count */
 	count /= 3;
 
 	/* copy RDS block out of internal buffer and to user buffer */
-	if (spin_trylock(&radio->lock)) {
-		unsigned int block_count = 0;
-		while (block_count < count) {
-			if (radio->rd_index == radio->wr_index)
-				break;
-
-			/* always transfer rds complete blocks */
-			if (copy_to_user(buf,
-					&radio->buffer[radio->rd_index], 3))
-				/* retval = -EFAULT; */
-				break;
-
-			/* increment and wrap read pointer */
-			radio->rd_index += 3;
-			if (radio->rd_index >= radio->buf_size)
-				radio->rd_index = 0;
+	mutex_lock(&radio->lock);
+	while (block_count < count) {
+		if (radio->rd_index == radio->wr_index)
+			break;
 
-			/* increment counters */
-			block_count++;
-			buf += 3;
-			retval += 3;
-		}
+		/* always transfer rds complete blocks */
+		if (copy_to_user(buf, &radio->buffer[radio->rd_index], 3))
+			/* retval = -EFAULT; */
+			break;
 
-		spin_unlock(&radio->lock);
+		/* increment and wrap read pointer */
+		radio->rd_index += 3;
+		if (radio->rd_index >= radio->buf_size)
+			radio->rd_index = 0;
+
+		/* increment counters */
+		block_count++;
+		buf += 3;
+		retval += 3;
 	}
+	mutex_unlock(&radio->lock);
 
 	return retval;
 }
@@ -945,7 +943,8 @@ static unsigned int si470x_fops_poll(str
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
 		si470x_rds_on(radio);
-		schedule_work(&radio->work);
+		schedule_delayed_work(&radio->work,
+			msecs_to_jiffies(rds_poll_time));
 	}
 
 	poll_wait(file, &radio->read_queue, pts);
@@ -985,8 +984,7 @@ static int si470x_fops_release(struct in
 	radio->users--;
 	if (radio->users == 0) {
 		/* stop rds reception */
-		del_timer_sync(&radio->timer);
-		flush_scheduled_work();
+		cancel_delayed_work_sync(&radio->work);
 
 		/* cancel read processes */
 		wake_up_interruptible(&radio->read_queue);
@@ -1363,73 +1361,82 @@ static int si470x_usb_driver_probe(struc
 		const struct usb_device_id *id)
 {
 	struct si470x_device *radio;
+	int retval = -ENOMEM;
 
-	/* memory and interface allocations */
-	radio = kmalloc(sizeof(struct si470x_device), GFP_KERNEL);
+	/* private data allocation */
+	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
 	if (!radio)
-		return -ENOMEM;
+		goto err_initial;
+
+	/* video device allocation */
 	radio->videodev = video_device_alloc();
-	if (!radio->videodev) {
-		kfree(radio);
-		return -ENOMEM;
-	}
+	if (!radio->videodev)
+		goto err_radio;
+
+	/* initial configuration */
 	memcpy(radio->videodev, &si470x_viddev_template,
 			sizeof(si470x_viddev_template));
 	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
+	mutex_init(&radio->lock);
 	video_set_drvdata(radio->videodev, radio);
-	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
-		printk(KERN_WARNING DRIVER_NAME
-				": Could not register video device\n");
-		video_device_release(radio->videodev);
-		kfree(radio);
-		return -EIO;
-	}
-	usb_set_intfdata(intf, radio);
 
 	/* show some infos about the specific device */
-	if (si470x_get_all_registers(radio) < 0) {
-		video_device_release(radio->videodev);
-		kfree(radio);
-		return -EIO;
-	}
-	printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4x ChipID=0x%4.4x\n",
+	retval = -EIO;
+	if (si470x_get_all_registers(radio) < 0)
+		goto err_all;
+	printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
 			radio->registers[DEVICEID], radio->registers[CHIPID]);
 
 	/* check if firmware is current */
 	if ((radio->registers[CHIPID] & CHIPID_FIRMWARE)
-			< RADIO_SW_VERSION_CURRENT)
+			< RADIO_SW_VERSION_CURRENT) {
+		printk(KERN_WARNING DRIVER_NAME
+			": This driver is known to work with "
+			"firmware version %hu,\n", RADIO_SW_VERSION_CURRENT);
+		printk(KERN_WARNING DRIVER_NAME
+			": but the device has firmware version %hu.\n",
+			radio->registers[CHIPID] & CHIPID_FIRMWARE);
 		printk(KERN_WARNING DRIVER_NAME
-			": This driver is known to work with chip version %d, "
-			"but the device has firmware %d.\n"
-			DRIVER_NAME
-			"If you have some trouble using this driver, please "
-			"report to V4L ML at video4linux-list@redhat.com\n",
-			radio->registers[CHIPID] & CHIPID_FIRMWARE,
-			RADIO_SW_VERSION_CURRENT);
+			": If you have some trouble using this driver,\n");
+		printk(KERN_WARNING DRIVER_NAME
+			": please report to V4L ML at "
+			"video4linux-list@redhat.com\n");
+	}
 
 	/* set initial frequency */
 	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
 
-	/* rds initialization */
+	/* rds buffer allocation */
 	radio->buf_size = rds_buf * 3;
 	radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
-	if (!radio->buffer) {
-		video_device_release(radio->videodev);
-		kfree(radio);
-		return -ENOMEM;
-	}
+	if (!radio->buffer)
+		goto err_all;
+
+	/* rds buffer configuration */
 	radio->wr_index = 0;
 	radio->rd_index = 0;
 	init_waitqueue_head(&radio->read_queue);
 
-	/* prepare polling via eventd */
-	INIT_WORK(&radio->work, si470x_work);
-	init_timer(&radio->timer);
-	radio->timer.function = si470x_timer;
-	radio->timer.data = (unsigned long) radio;
+	/* prepare rds work function */
+	INIT_DELAYED_WORK(&radio->work, si470x_work);
+
+	/* register video device */
+	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
+		printk(KERN_WARNING DRIVER_NAME
+				": Could not register video device\n");
+		goto err_all;
+	}
+	usb_set_intfdata(intf, radio);
 
 	return 0;
+err_all:
+	video_device_release(radio->videodev);
+	kfree(radio->buffer);
+err_radio:
+	kfree(radio);
+err_initial:
+	return retval;
 }
 
 
@@ -1440,14 +1447,11 @@ static void si470x_usb_driver_disconnect
 {
 	struct si470x_device *radio = usb_get_intfdata(intf);
 
+	cancel_delayed_work_sync(&radio->work);
 	usb_set_intfdata(intf, NULL);
-	if (radio) {
-	       del_timer_sync(&radio->timer);
-	       flush_scheduled_work();
-		video_unregister_device(radio->videodev);
-		kfree(radio->buffer);
-		kfree(radio);
-	}
+	video_unregister_device(radio->videodev);
+	kfree(radio->buffer);
+	kfree(radio);
 }
 
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
