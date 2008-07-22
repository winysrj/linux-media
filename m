Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MIAPNJ021172
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 14:10:25 -0400
Received: from mail11e.verio-web.com (mail11e.verio-web.com [204.202.242.84])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6MIAB0Z008494
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 14:10:12 -0400
Received: from mx104.stngva01.us.mxservers.net (198.173.112.41)
	by mail11e.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-013131211
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 14:10:11 -0400 (EDT)
Date: Tue, 22 Jul 2008 10:43:27 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: mchehab@infradead.org, greg@kroah.com, v4l-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <tkrat.ebe7ab2a1a58be00@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv Sensoray 2255 driver fixes
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

From: Dean Anderson <dean@sensoray.com>

This patch fixes timer issues in driver disconnect.
It also removes the restriction of one user per channel at a time.

Signed-off-by: Dean Anderson <dean@sensoray.com>
---
patch to linux-git (pulled July 21,2008 linux-2.6.26-git9 ?).
Thanks to Oliver Neukum and Mauro Chehab for finding these issues.
Locking of video stream partly based on saa7134 driver.


diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 04eb2c3..581b689 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -184,6 +184,7 @@ struct s2255_dmaqueue {
 #define S2255_FW_LOADED_DSPWAIT	1
 #define S2255_FW_SUCCESS	2
 #define S2255_FW_FAILED		3
+#define S2255_FW_DISCONNECTING  4
 
 struct s2255_fw {
 	int		      fw_loaded;
@@ -263,7 +264,6 @@ struct s2255_buffer {
 
 struct s2255_fh {
 	struct s2255_dev	*dev;
-	unsigned int		resources;
 	const struct s2255_fmt	*fmt;
 	unsigned int		width;
 	unsigned int		height;
@@ -273,14 +273,9 @@ struct s2255_fh {
 	/* mode below is the desired mode.
 	   mode in s2255_dev is the current mode that was last set */
 	struct s2255_mode	mode;
+	int			resources[MAX_CHANNELS];
 };
 
-/*
- * TODO: fixme S2255_MAX_USERS. Do not limit open driver handles.
- * Limit V4L to one stream at a time.
- */
-#define S2255_MAX_USERS         1
-
 #define CUR_USB_FWVER	774	/* current cypress EEPROM firmware version */
 #define S2255_MAJOR_VERSION	1
 #define S2255_MINOR_VERSION	13
@@ -476,10 +471,9 @@ static void s2255_timer(unsigned long user_data)
 	dprintk(100, "s2255 timer\n");
 	if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {
 		printk(KERN_ERR "s2255: can't submit urb\n");
-		if (data->fw) {
-			release_firmware(data->fw);
-			data->fw = NULL;
-		}
+		atomic_set(&data->fw_state, S2255_FW_FAILED);
+		/* wake up anything waiting for the firmware */
+		wake_up(&data->wait_fw);
 		return;
 	}
 }
@@ -509,13 +503,18 @@ static void s2255_fwchunk_complete(struct urb *urb)
 	struct usb_device *udev = urb->dev;
 	int len;
 	dprintk(100, "udev %p urb %p", udev, urb);
-	/* TODO: fixme.  reflect change in status */
 	if (urb->status) {
 		dev_err(&udev->dev, "URB failed with status %d", urb->status);
+		atomic_set(&data->fw_state, S2255_FW_FAILED);
+		/* wake up anything waiting for the firmware */
+		wake_up(&data->wait_fw);
 		return;
 	}
 	if (data->fw_urb == NULL) {
-		dev_err(&udev->dev, "early disconncect\n");
+		dev_err(&udev->dev, "s2255 disconnected\n");
+		atomic_set(&data->fw_state, S2255_FW_FAILED);
+		/* wake up anything waiting for the firmware */
+		wake_up(&data->wait_fw);
 		return;
 	}
 #define CHUNK_SIZE 512
@@ -789,7 +788,8 @@ static int res_get(struct s2255_dev *dev, struct s2255_fh *fh)
 	}
 	/* it's free, grab it */
 	dev->resources[fh->channel] = 1;
-	dprintk(1, "res: get\n");
+	fh->resources[fh->channel] = 1;
+	dprintk(1, "s2255: res: get\n");
 	mutex_unlock(&dev->lock);
 	return 1;
 }
@@ -799,9 +799,18 @@ static int res_locked(struct s2255_dev *dev, struct s2255_fh *fh)
 	return dev->resources[fh->channel];
 }
 
+static int res_check(struct s2255_fh *fh)
+{
+	return fh->resources[fh->channel];
+}
+
+
 static void res_free(struct s2255_dev *dev, struct s2255_fh *fh)
 {
+	mutex_lock(&dev->lock);
 	dev->resources[fh->channel] = 0;
+	fh->resources[fh->channel] = 0;
+	mutex_unlock(&dev->lock);
 	dprintk(1, "res: put\n");
 }
 
@@ -1232,7 +1241,7 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	}
 
 	if (!res_get(dev, fh)) {
-		dev_err(&dev->udev->dev, "res get busy\n");
+		dev_err(&dev->udev->dev, "s2255: stream busy\n");
 		return -EBUSY;
 	}
 
@@ -1288,8 +1297,10 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	}
 	s2255_stop_acquire(dev, fh->channel);
 	res = videobuf_streamoff(&fh->vb_vidq);
+	if (res < 0)
+		return res;
 	res_free(dev, fh);
-	return res;
+	return 0;
 }
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
@@ -1462,12 +1473,7 @@ static int s2255_open(struct inode *inode, struct file *file)
 	mutex_lock(&dev->open_lock);
 
 	dev->users[cur_channel]++;
-	if (dev->users[cur_channel] > S2255_MAX_USERS) {
-		dev->users[cur_channel]--;
-		mutex_unlock(&dev->open_lock);
-		printk(KERN_INFO "s2255drv: too many open handles!\n");
-		return -EBUSY;
-	}
+	dprintk(4, "s2255: open_handles %d\n", dev->users[cur_channel]);
 
 	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_FAILED) {
 		err("2255 firmware load failed. retrying.\n");
@@ -1478,7 +1484,8 @@ static int s2255_open(struct inode *inode, struct file *file)
 				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));
 		if (atomic_read(&dev->fw_data->fw_state)
 		    != S2255_FW_SUCCESS) {
-			printk(KERN_INFO "2255 FW load failed after 2 tries\n");
+			printk(KERN_INFO "2255 FW load failed.\n");
+			dev->users[cur_channel]--;
 			mutex_unlock(&dev->open_lock);
 			return -EFAULT;
 		}
@@ -1494,6 +1501,7 @@ static int s2255_open(struct inode *inode, struct file *file)
 		    != S2255_FW_SUCCESS) {
 			printk(KERN_INFO "2255 firmware not loaded"
 			       "try again\n");
+			dev->users[cur_channel]--;
 			mutex_unlock(&dev->open_lock);
 			return -EBUSY;
 		}
@@ -1502,6 +1510,7 @@ static int s2255_open(struct inode *inode, struct file *file)
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh) {
+		dev->users[cur_channel]--;
 		mutex_unlock(&dev->open_lock);
 		return -ENOMEM;
 	}
@@ -1561,44 +1570,48 @@ static void s2255_destroy(struct kref *kref)
 		printk(KERN_ERR "s2255drv: kref problem\n");
 		return;
 	}
+
+	/*
+	 * Wake up any firmware load waiting (only done in .open,
+	 * which holds the open_lock mutex)
+	 */
+	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
+	wake_up(&dev->fw_data->wait_fw);
+
 	/* prevent s2255_disconnect from racing s2255_open */
 	mutex_lock(&dev->open_lock);
 	s2255_exit_v4l(dev);
-	/* device unregistered so no longer possible to open. open_mutex
-	   can be unlocked */
+	/*
+	 * device unregistered so no longer possible to open. open_mutex
+	 *  can be unlocked and timers deleted afterwards.
+	 */
 	mutex_unlock(&dev->open_lock);
 
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
 
 	/* make sure firmware still not trying to load */
+	del_timer(&dev->timer);  /* only started in .probe and .open */
+
 	if (dev->fw_data->fw_urb) {
 		dprintk(2, "kill fw_urb\n");
 		usb_kill_urb(dev->fw_data->fw_urb);
 		usb_free_urb(dev->fw_data->fw_urb);
 		dev->fw_data->fw_urb = NULL;
 	}
+
 	/*
-	 * TODO: fixme(above, below): potentially leaving timers alive.
-	 *                            do not ignore timeout below if
-	 *                            it occurs.
+	 * delete the dsp_wait timer, which sets the firmware
+	 * state on completion.  This is done before fw_data
+	 * is freed below.
 	 */
 
-	/* make sure we aren't waiting for the DSP */
-	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_LOADED_DSPWAIT) {
-		/* if we are, wait for the wakeup for fw_success or timeout */
-		wait_event_timeout(dev->fw_data->wait_fw,
-				   (atomic_read(&dev->fw_data->fw_state)
-				   == S2255_FW_SUCCESS),
-				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));
-	}
+	del_timer(&dev->fw_data->dsp_wait); /* only started in .open */
 
-	if (dev->fw_data) {
-		if (dev->fw_data->fw)
-			release_firmware(dev->fw_data->fw);
-		kfree(dev->fw_data->pfw_data);
-		kfree(dev->fw_data);
-	}
+	if (dev->fw_data->fw)
+		release_firmware(dev->fw_data->fw);
+	kfree(dev->fw_data->pfw_data);
+	kfree(dev->fw_data);
 
 	usb_put_dev(dev->udev);
 	dprintk(1, "%s", __func__);
@@ -1615,17 +1628,23 @@ static int s2255_close(struct inode *inode, struct file *file)
 
 	mutex_lock(&dev->open_lock);
 
-	if (dev->b_acquire[fh->channel])
-		s2255_stop_acquire(dev, fh->channel);
-	res_free(dev, fh);
+	/* turn off stream */
+	if (res_check(fh)) {
+		if (dev->b_acquire[fh->channel])
+			s2255_stop_acquire(dev, fh->channel);
+		videobuf_streamoff(&fh->vb_vidq);
+		res_free(dev, fh);
+	}
+
 	videobuf_mmap_free(&fh->vb_vidq);
-	kfree(fh);
 	dev->users[fh->channel]--;
+
 	mutex_unlock(&dev->open_lock);
 
 	kref_put(&dev->kref, s2255_destroy);
 	dprintk(1, "s2255: close called (minor=%d, users=%d)\n",
 		minor, dev->users[fh->channel]);
+	kfree(fh);
 	return 0;
 }
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
