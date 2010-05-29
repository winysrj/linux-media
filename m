Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62268 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0E2QxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 12:53:07 -0400
Received: by fxm10 with SMTP id 10so1423571fxm.19
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 09:53:04 -0700 (PDT)
From: Timofey Trofimov <tumoxep@gmail.com>
To: gregh@suse.de, mchehab@redhat.com, d.belimov@gmail.com
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Timofey Trofimov <tumoxep@gmail.com>
Subject: [PATCH 6/6] Staging: tm6000: Fix coding style issues Fixed coding style issues founded by checkpatch.pl in files: tm6000-alsa.c, tm6000-cards, tm6000-core.c, tm6000-dvb.c, tm6000-i2c.c, tm6000-stds.c, tm6000-usb-isoc.h, tm6000.h Signed-off-by: Timofey Trofimov <tumoxep@gmail.com>
Date: Sat, 29 May 2010 20:52:46 +0400
Message-Id: <1275151966-8868-1-git-send-email-tumoxep@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/staging/tm6000/tm6000-alsa.c     |    2 +-
 drivers/staging/tm6000/tm6000-cards.c    |    2 +-
 drivers/staging/tm6000/tm6000-core.c     |  148 ++++++++++++++---------------
 drivers/staging/tm6000/tm6000-dvb.c      |   92 +++++++++----------
 drivers/staging/tm6000/tm6000-i2c.c      |   25 +++---
 drivers/staging/tm6000/tm6000-stds.c     |    6 +-
 drivers/staging/tm6000/tm6000-usb-isoc.h |    2 +-
 drivers/staging/tm6000/tm6000.h          |   50 +++++-----
 8 files changed, 156 insertions(+), 171 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index bc89f9d..b80c438 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -63,7 +63,7 @@ struct snd_tm6000_card {
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;       /* ID for this card */
-static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
+static int enable[SNDRV_CARDS] = {1,[1 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable tm6000x soundcard. default enabled.");
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 6143e20..16984de 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -732,7 +732,7 @@ static void get_max_endpoint(struct usb_device *udev,
 	unsigned int size = tmp & 0x7ff;
 
 	if (udev->speed == USB_SPEED_HIGH)
-		size = size * hb_mult (tmp);
+		size = size * hb_mult(tmp);
 
 	if (size > tm_ep->maxsize) {
 		tm_ep->endp = curr_e;
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index bfbc53b..0e26f81 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -31,66 +31,64 @@
 
 #define USB_TIMEOUT	5*HZ /* ms */
 
-int tm6000_read_write_usb (struct tm6000_core *dev, u8 req_type, u8 req,
-			   u16 value, u16 index, u8 *buf, u16 len)
+int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
+			  u16 value, u16 index, u8 *buf, u16 len)
 {
 	int          ret, i;
 	unsigned int pipe;
-	static int   ini=0, last=0, n=0;
-	u8	     *data=NULL;
+	static int   ini = 0, last = 0, n = 0;
+	u8	     *data = NULL;
 
 	if (len)
 		data = kzalloc(len, GFP_KERNEL);
 
 
 	if (req_type & USB_DIR_IN)
-		pipe=usb_rcvctrlpipe(dev->udev, 0);
+		pipe = usb_rcvctrlpipe(dev->udev, 0);
 	else {
-		pipe=usb_sndctrlpipe(dev->udev, 0);
+		pipe = usb_sndctrlpipe(dev->udev, 0);
 		memcpy(data, buf, len);
 	}
 
 	if (tm6000_debug & V4L2_DEBUG_I2C) {
 		if (!ini)
-			last=ini=jiffies;
+			last = ini = jiffies;
 
 		printk("%06i (dev %p, pipe %08x): ", n, dev->udev, pipe);
 
-		printk( "%s: %06u ms %06u ms %02x %02x %02x %02x %02x %02x %02x %02x ",
-			(req_type & USB_DIR_IN)?" IN":"OUT",
+		printk("%s: %06u ms %06u ms %02x %02x %02x %02x %02x %02x %02x %02x ",
+			(req_type & USB_DIR_IN) ? " IN" : "OUT",
 			jiffies_to_msecs(jiffies-last),
 			jiffies_to_msecs(jiffies-ini),
-			req_type, req,value&0xff,value>>8, index&0xff, index>>8,
-			len&0xff, len>>8);
-		last=jiffies;
+			req_type, req, value&0xff, value>>8, index&0xff,
+			index>>8, len&0xff, len>>8);
+		last = jiffies;
 		n++;
 
-		if ( !(req_type & USB_DIR_IN) ) {
+		if (!(req_type & USB_DIR_IN)) {
 			printk(">>> ");
-			for (i=0;i<len;i++) {
-				printk(" %02x",buf[i]);
-			}
+			for (i = 0; i < len; i++)
+				printk(" %02x", buf[i]);
 		printk("\n");
 		}
 	}
 
-	ret = usb_control_msg(dev->udev, pipe, req, req_type, value, index, data,
-			      len, USB_TIMEOUT);
+	ret = usb_control_msg(dev->udev, pipe, req, req_type, value, index,
+			      data, len, USB_TIMEOUT);
 
 	if (req_type &  USB_DIR_IN)
 		memcpy(buf, data, len);
 
 	if (tm6000_debug & V4L2_DEBUG_I2C) {
-		if (ret<0) {
+		if (ret < 0) {
 			if (req_type &  USB_DIR_IN)
-				printk("<<< (len=%d)\n",len);
+				printk("<<< (len=%d)\n", len);
 
 			printk("%s: Error #%d\n", __FUNCTION__, ret);
 		} else if (req_type &  USB_DIR_IN) {
 			printk("<<< ");
-			for (i=0;i<len;i++) {
-				printk(" %02x",buf[i]);
-			}
+			for (i = 0; i < len; i++)
+				printk(" %02x", buf[i]);
 			printk("\n");
 		}
 	}
@@ -102,52 +100,52 @@ int tm6000_read_write_usb (struct tm6000_core *dev, u8 req_type, u8 req,
 	return ret;
 }
 
-int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index)
+int tm6000_set_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
 	return
-		tm6000_read_write_usb (dev, USB_DIR_OUT | USB_TYPE_VENDOR,
-				       req, value, index, NULL, 0);
+		tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
+				      req, value, index, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(tm6000_set_reg);
 
-int tm6000_get_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index)
+int tm6000_get_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
 	int rc;
 	u8 buf[1];
 
-	rc=tm6000_read_write_usb (dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
-				       value, index, buf, 1);
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
+					value, index, buf, 1);
 
-	if (rc<0)
+	if (rc < 0)
 		return rc;
 
 	return *buf;
 }
 EXPORT_SYMBOL_GPL(tm6000_get_reg);
 
-int tm6000_get_reg16 (struct tm6000_core *dev, u8 req, u16 value, u16 index)
+int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
 	int rc;
 	u8 buf[2];
 
-	rc=tm6000_read_write_usb (dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
-				       value, index, buf, 2);
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
+					value, index, buf, 2);
 
-	if (rc<0)
+	if (rc < 0)
 		return rc;
 
 	return buf[1]|buf[0]<<8;
 }
 
-int tm6000_get_reg32 (struct tm6000_core *dev, u8 req, u16 value, u16 index)
+int tm6000_get_reg32(struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
 	int rc;
 	u8 buf[4];
 
-	rc=tm6000_read_write_usb (dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
-				       value, index, buf, 4);
+	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
+					value, index, buf, 4);
 
-	if (rc<0)
+	if (rc < 0)
 		return rc;
 
 	return buf[3] | buf[2] << 8 | buf[1] << 16 | buf[0] << 24;
@@ -171,7 +169,7 @@ void tm6000_set_fourcc_format(struct tm6000_core *dev)
 	}
 }
 
-int tm6000_init_analog_mode (struct tm6000_core *dev)
+int tm6000_init_analog_mode(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
 		int val;
@@ -277,10 +275,9 @@ int tm6000_init_analog_mode (struct tm6000_core *dev)
 		/* Enables soft reset */
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
 
-		if (dev->scaler) {
+		if (dev->scaler)
 			tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x20);
-		} else {
-			/* Enable Hfilter and disable TS Drop err */
+		else	/* Enable Hfilter and disable TS Drop err */
 			tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x80);
 		}
 
@@ -315,18 +312,18 @@ int tm6000_init_analog_mode (struct tm6000_core *dev)
 	/*FIXME: Hack!!! */
 	struct v4l2_frequency f;
 	mutex_lock(&dev->lock);
-	f.frequency=dev->freq;
+	f.frequency = dev->freq;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 	mutex_unlock(&dev->lock);
 
 	msleep(100);
-	tm6000_set_standard (dev, &dev->norm);
-	tm6000_set_audio_bitrate (dev,48000);
+	tm6000_set_standard(dev, &dev->norm);
+	tm6000_set_audio_bitrate(dev, 48000);
 
 	return 0;
 }
 
-int tm6000_init_digital_mode (struct tm6000_core *dev)
+int tm6000_init_digital_mode(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
 		int val;
@@ -343,10 +340,8 @@ int tm6000_init_digital_mode (struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xfc);
 		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0xff);
 		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe);
-		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
-		printk (KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
-
-
+		tm6000_read_write_usb(dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
+		printk(KERN_INFO"buf %#x %#x\n", buf[0], buf[1]);
 	} else  {
 		tm6000_set_reg(dev, TM6010_REQ07_RFF_SOFT_RESET, 0x08);
 		tm6000_set_reg(dev, TM6010_REQ07_RFF_SOFT_RESET, 0x00);
@@ -354,7 +349,7 @@ int tm6000_init_digital_mode (struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_PULSE_CNT0, 0x08);
 		tm6000_set_reg(dev, TM6010_REQ07_RE2_OUT_SEL2, 0x0c);
 		tm6000_set_reg(dev, TM6010_REQ07_RE8_TYPESEL_MOS_I2S, 0xff);
-		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
+		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
 		tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x40);
 		tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
 		tm6000_set_reg(dev, TM6010_REQ07_RC3_HSTART1, 0x09);
@@ -365,14 +360,14 @@ int tm6000_init_digital_mode (struct tm6000_core *dev)
 
 		tm6000_set_reg(dev, TM6010_REQ07_RE2_OUT_SEL2, 0x0c);
 		tm6000_set_reg(dev, TM6010_REQ07_RE8_TYPESEL_MOS_I2S, 0xff);
-		tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
+		tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
 		msleep(50);
 
-		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
 		msleep(50);
-		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x01);
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x01);
 		msleep(50);
-		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
 		msleep(100);
 	}
 	return 0;
@@ -536,9 +531,9 @@ struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ07_RD8_IR_WAKEUP_SEL,  0xff },
 };
 
-int tm6000_init (struct tm6000_core *dev)
+int tm6000_init(struct tm6000_core *dev)
 {
-	int board, rc=0, i, size;
+	int board, rc = 0, i, size;
 	struct reg_init *tab;
 
 	if (dev->dev_type == TM6010) {
@@ -550,12 +545,12 @@ int tm6000_init (struct tm6000_core *dev)
 	}
 
 	/* Load board's initialization table */
-	for (i=0; i< size; i++) {
-		rc= tm6000_set_reg (dev, tab[i].req, tab[i].reg, tab[i].val);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i while setting req %d, "
-					 "reg %d to value %d\n", rc,
-					 tab[i].req,tab[i].reg, tab[i].val);
+	for (i = 0; i < size; i++) {
+		rc = tm6000_set_reg(dev, tab[i].req, tab[i].reg, tab[i].val);
+		if (rc < 0) {
+			printk(KERN_ERR "Error %i while setting req %d, "
+					"reg %d to value %d\n", rc,
+					tab[i].req, tab[i].reg, tab[i].val);
 			return rc;
 		}
 	}
@@ -563,12 +558,11 @@ int tm6000_init (struct tm6000_core *dev)
 	msleep(5); /* Just to be conservative */
 
 	/* Check board version - maybe 10Moons specific */
-	board=tm6000_get_reg32 (dev, REQ_40_GET_VERSION, 0, 0);
-	if (board >=0) {
-		printk (KERN_INFO "Board version = 0x%08x\n",board);
-	} else {
-		printk (KERN_ERR "Error %i while retrieving board version\n",board);
-	}
+	board = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
+	if (board >= 0)
+		printk(KERN_INFO "Board version = 0x%08x\n", board);
+	else
+		printk(KERN_ERR "Error %i while retrieving board version\n", board);
 
 	rc = tm6000_cards_setup(dev);
 
@@ -579,23 +573,23 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 {
 	int val;
 
-	val=tm6000_get_reg (dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
-printk("Original value=%d\n",val);
-	if (val<0)
+	val = tm6000_get_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
+	printk("Original value=%d\n", val);
+	if (val < 0)
 		return val;
 
 	val &= 0x0f;		/* Preserve the audio input control bits */
 	switch (bitrate) {
 	case 44100:
-		val|=0xd0;
-		dev->audio_bitrate=bitrate;
+		val |= 0xd0;
+		dev->audio_bitrate = bitrate;
 		break;
 	case 48000:
-		val|=0x60;
-		dev->audio_bitrate=bitrate;
+		val |= 0x60;
+		dev->audio_bitrate = bitrate;
 		break;
 	}
-	val=tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0xeb, val);
+	val = tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, val);
 
 	return val;
 }
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index eafc89c..382fd73 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -29,12 +29,12 @@
 
 #include "tuner-xc2028.h"
 
-static void inline print_err_status (struct tm6000_core *dev,
-				     int packet, int status)
+static inline void print_err_status(struct tm6000_core *dev,
+				    int packet, int status)
 {
 	char *errmsg = "Unknown";
 
-	switch(status) {
+	switch (status) {
 	case -ENOENT:
 		errmsg = "unlinked synchronuously";
 		break;
@@ -60,7 +60,7 @@ static void inline print_err_status (struct tm6000_core *dev,
 		errmsg = "Device does not respond";
 		break;
 	}
-	if (packet<0) {
+	if (packet < 0) {
 		dprintk(dev, 1, "URB status %d [%s].\n",
 			status, errmsg);
 	} else {
@@ -72,19 +72,17 @@ static void inline print_err_status (struct tm6000_core *dev,
 static void tm6000_urb_received(struct urb *urb)
 {
 	int ret;
-	struct tm6000_core* dev = urb->context;
+	struct tm6000_core *dev = urb->context;
 
-	if(urb->status != 0) {
-		print_err_status (dev,0,urb->status);
-	}
-	else if(urb->actual_length>0){
+	if (urb->status != 0)
+		print_err_status(dev, 0, urb->status);
+	else if (urb->actual_length > 0)
 		dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
 						   urb->actual_length);
-	}
 
-	if(dev->dvb->streams > 0) {
+	if (dev->dvb->streams > 0) {
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
-		if(ret < 0) {
+		if (ret < 0) {
 			printk(KERN_ERR "tm6000:  error %s\n", __FUNCTION__);
 			kfree(urb->transfer_buffer);
 			usb_free_urb(urb);
@@ -98,12 +96,12 @@ int tm6000_start_stream(struct tm6000_core *dev)
 	unsigned int pipe, size;
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	printk(KERN_INFO "tm6000: got start stream request %s\n",__FUNCTION__);
+	printk(KERN_INFO "tm6000: got start stream request %s\n", __FUNCTION__);
 
 	tm6000_init_digital_mode(dev);
 
 	dvb->bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if(dvb->bulk_urb == NULL) {
+	if (dvb->bulk_urb == NULL) {
 		printk(KERN_ERR "tm6000: couldn't allocate urb\n");
 		return -ENOMEM;
 	}
@@ -115,7 +113,7 @@ int tm6000_start_stream(struct tm6000_core *dev)
 	size = size * 15; /* 512 x 8 or 12 or 15 */
 
 	dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
-	if(dvb->bulk_urb->transfer_buffer == NULL) {
+	if (dvb->bulk_urb->transfer_buffer == NULL) {
 		usb_free_urb(dvb->bulk_urb);
 		printk(KERN_ERR "tm6000: couldn't allocate transfer buffer!\n");
 		return -ENOMEM;
@@ -127,20 +125,20 @@ int tm6000_start_stream(struct tm6000_core *dev)
 						 tm6000_urb_received, dev);
 
 	ret = usb_clear_halt(dev->udev, pipe);
-	if(ret < 0) {
-		printk(KERN_ERR "tm6000: error %i in %s during pipe reset\n",ret,__FUNCTION__);
+	if (ret < 0) {
+		printk(KERN_ERR "tm6000: error %i in %s during pipe reset\n",
+							ret, __FUNCTION__);
 		return ret;
-	}
-	else {
+	} else
 		printk(KERN_ERR "tm6000: pipe resetted\n");
-	}
 
 /*	mutex_lock(&tm6000_driver.open_close_mutex); */
 	ret = usb_submit_urb(dvb->bulk_urb, GFP_KERNEL);
 
 /*	mutex_unlock(&tm6000_driver.open_close_mutex); */
 	if (ret) {
-		printk(KERN_ERR "tm6000: submit of urb failed (error=%i)\n",ret);
+		printk(KERN_ERR "tm6000: submit of urb failed (error=%i)\n",
+									ret);
 
 		kfree(dvb->bulk_urb->transfer_buffer);
 		usb_free_urb(dvb->bulk_urb);
@@ -154,10 +152,10 @@ void tm6000_stop_stream(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	if(dvb->bulk_urb) {
-		printk (KERN_INFO "urb killing\n");
+	if (dvb->bulk_urb) {
+		printk(KERN_INFO "urb killing\n");
 		usb_kill_urb(dvb->bulk_urb);
-		printk (KERN_INFO "urb buffer free\n");
+		printk(KERN_INFO "urb buffer free\n");
 		kfree(dvb->bulk_urb->transfer_buffer);
 		usb_free_urb(dvb->bulk_urb);
 		dvb->bulk_urb = NULL;
@@ -169,35 +167,34 @@ int tm6000_start_feed(struct dvb_demux_feed *feed)
 	struct dvb_demux *demux = feed->demux;
 	struct tm6000_core *dev = demux->priv;
 	struct tm6000_dvb *dvb = dev->dvb;
-	printk(KERN_INFO "tm6000: got start feed request %s\n",__FUNCTION__);
+	printk(KERN_INFO "tm6000: got start feed request %s\n", __FUNCTION__);
 
 	mutex_lock(&dvb->mutex);
-	if(dvb->streams == 0) {
+	if (dvb->streams == 0) {
 		dvb->streams = 1;
 /*		mutex_init(&tm6000_dev->streming_mutex); */
 		tm6000_start_stream(dev);
-	}
-	else {
+	} else {
 		++(dvb->streams);
-	}
 	mutex_unlock(&dvb->mutex);
 
 	return 0;
 }
 
-int tm6000_stop_feed(struct dvb_demux_feed *feed) {
+int tm6000_stop_feed(struct dvb_demux_feed *feed)
+{
 	struct dvb_demux *demux = feed->demux;
 	struct tm6000_core *dev = demux->priv;
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	printk(KERN_INFO "tm6000: got stop feed request %s\n",__FUNCTION__);
+	printk(KERN_INFO "tm6000: got stop feed request %s\n", __FUNCTION__);
 
 	mutex_lock(&dvb->mutex);
 
-	printk (KERN_INFO "stream %#x\n", dvb->streams);
+	printk(KERN_INFO "stream %#x\n", dvb->streams);
 	--(dvb->streams);
-	if(dvb->streams == 0) {
-		printk (KERN_INFO "stop stream\n");
+	if (dvb->streams == 0) {
+		printk(KERN_INFO "stop stream\n");
 		tm6000_stop_stream(dev);
 /*		mutex_destroy(&tm6000_dev->streaming_mutex); */
 	}
@@ -211,9 +208,9 @@ int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	if(dev->caps.has_zl10353) {
-		struct zl10353_config config =
-				    {.demod_address = dev->demod_addr,
+	if (dev->caps.has_zl10353) {
+		struct zl10353_config config = {
+				     demod_address = dev->demod_addr,
 				     .no_tuner = 1,
 				     .parallel_ts = 1,
 				     .if2 = 45700,
@@ -222,8 +219,7 @@ int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 
 		dvb->frontend = dvb_attach(zl10353_attach, &config,
 							   &dev->i2c_adap);
-	}
-	else {
+	} else {
 		printk(KERN_ERR "tm6000: no frontend defined for the device!\n");
 		return -1;
 	}
@@ -244,13 +240,13 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 
 	/* attach the frontend */
 	ret = tm6000_dvb_attach_frontend(dev);
-	if(ret < 0) {
+	if (ret < 0) {
 		printk(KERN_ERR "tm6000: couldn't attach the frontend!\n");
 		goto err;
 	}
 
 	ret = dvb_register_adapter(&dvb->adapter, "Trident TVMaster 6000 DVB-T",
-							  THIS_MODULE, &dev->udev->dev, adapter_nr);
+					THIS_MODULE, &dev->udev->dev, adapter_nr);
 	dvb->adapter.priv = dev;
 
 	if (dvb->frontend) {
@@ -275,9 +271,8 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 		}
 		printk(KERN_INFO "tm6000: XC2028/3028 asked to be "
 				 "attached to frontend!\n");
-	} else {
+	} else
 		printk(KERN_ERR "tm6000: no frontend found\n");
-	}
 
 	dvb->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING
 							    | DMX_MEMORY_BASED_FILTERING;
@@ -288,7 +283,7 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 	dvb->demux.stop_feed = tm6000_stop_feed;
 	dvb->demux.write_to_decoder = NULL;
 	ret = dvb_dmx_init(&dvb->demux);
-	if(ret < 0) {
+	if (ret < 0) {
 		printk("tm6000: dvb_dmx_init failed (errno = %d)\n", ret);
 		goto frontend_err;
 	}
@@ -298,7 +293,7 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 	dvb->dmxdev.capabilities = 0;
 
 	ret =  dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
-	if(ret < 0) {
+	if (ret < 0) {
 		printk("tm6000: dvb_dmxdev_init failed (errno = %d)\n", ret);
 		goto dvb_dmx_err;
 	}
@@ -308,7 +303,7 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 dvb_dmx_err:
 	dvb_dmx_release(&dvb->demux);
 frontend_err:
-	if(dvb->frontend) {
+	if (dvb->frontend) {
 		dvb_frontend_detach(dvb->frontend);
 		dvb_unregister_frontend(dvb->frontend);
 	}
@@ -322,7 +317,7 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	if(dvb->bulk_urb != NULL) {
+	if (dvb->bulk_urb != NULL) {
 		struct urb *bulk_urb = dvb->bulk_urb;
 
 		kfree(bulk_urb->transfer_buffer);
@@ -332,7 +327,7 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
 	}
 
 /*	mutex_lock(&tm6000_driver.open_close_mutex); */
-	if(dvb->frontend) {
+	if (dvb->frontend) {
 		dvb_frontend_detach(dvb->frontend);
 		dvb_unregister_frontend(dvb->frontend);
 	}
@@ -342,5 +337,4 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
 	dvb_unregister_adapter(&dvb->adapter);
 	mutex_destroy(&dvb->mutex);
 /*	mutex_unlock(&tm6000_driver.open_close_mutex); */
-
 }
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 94ff489..79bc67f 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -40,7 +40,7 @@ static unsigned int i2c_debug = 0;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
-#define i2c_dprintk(lvl,fmt, args...) if (i2c_debug>=lvl) do{ \
+#define i2c_dprintk(lvl, fmt, args...) if (i2c_debug >= lvl) do { \
 			printk(KERN_DEBUG "%s at %s: " fmt, \
 			dev->name, __FUNCTION__ , ##args); } while (0)
 
@@ -171,7 +171,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 		return 0;
 	for (i = 0; i < num; i++) {
 		addr = (msgs[i].addr << 1) & 0xff;
-		i2c_dprintk(2,"%s %s addr=0x%x len=%d:",
+		i2c_dprintk(2, "%s %s addr=0x%x len=%d:",
 			 (msgs[i].flags & I2C_M_RD) ? "read" : "write",
 			 i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
 		if (msgs[i].flags & I2C_M_RD) {
@@ -235,7 +235,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 	return num;
 err:
-	i2c_dprintk(2," ERROR: %i\n", rc);
+	i2c_dprintk(2, " ERROR: %i\n", rc);
 	return rc;
 }
 
@@ -266,11 +266,10 @@ static int tm6000_i2c_eeprom(struct tm6000_core *dev,
 		if (0 == (i % 16))
 			printk(KERN_INFO "%s: i2c eeprom %02x:", dev->name, i);
 		printk(" %02x", eedata[i]);
-		if ((eedata[i] >= ' ') && (eedata[i] <= 'z')) {
+		if ((eedata[i] >= ' ') && (eedata[i] <= 'z'))
 			bytes[i%16] = eedata[i];
-		} else {
-			bytes[i%16]='.';
-		}
+		else
+			bytes[i%16] = '.';
 
 		i++;
 
@@ -305,15 +304,15 @@ static u32 functionality(struct i2c_adapter *adap)
 }
 
 #define mass_write(addr, reg, data...)					\
-	{ const static u8 _val[] = data;				\
-	rc=tm6000_read_write_usb(dev,USB_DIR_OUT | USB_TYPE_VENDOR,	\
-	REQ_16_SET_GET_I2C_WR1_RDN,(reg<<8)+addr, 0x00, (u8 *) _val,	\
+	{ static const u8 _val[] = data;				\
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,	\
+	REQ_16_SET_GET_I2C_WR1_RDN, (reg<<8)+addr, 0x00, (u8 *) _val,	\
 	ARRAY_SIZE(_val));						\
-	if (rc<0) {							\
-		printk(KERN_ERR "Error on line %d: %d\n",__LINE__,rc);	\
+	if (rc < 0) {							\
+		printk(KERN_ERR "Error on line %d: %d\n", __LINE__, rc);	\
 		return rc;						\
 	}								\
-	msleep (10);							\
+	msleep(10);							\
 	}
 
 static struct i2c_algorithm tm6000_algo = {
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index b3564f6..7a43782 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -763,11 +763,11 @@ static struct tm6000_std_settings svideo_stds[] = {
 void tm6000_get_std_res(struct tm6000_core *dev)
 {
 	/* Currently, those are the only supported resoltions */
-	if (dev->norm & V4L2_STD_525_60) {
+	if (dev->norm & V4L2_STD_525_60)
 		dev->height = 480;
-	} else {
+	else
 		dev->height = 576;
-	}
+	
 	dev->width = 720;
 }
 
diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
index 5a5049a..e6602bd 100644
--- a/drivers/staging/tm6000/tm6000-usb-isoc.h
+++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
@@ -46,7 +46,7 @@ struct usb_isoc_ctl {
 	int				tmp_buf_len;
 
 		/* Stores already requested buffers */
-	struct tm6000_buffer    	*buf;
+	struct tm6000_buffer		*buf;
 
 		/* Stores the number of received fields */
 	int				nfields;
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 6812d68..d625960 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -20,8 +20,8 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-// Use the tm6000-hack, instead of the proper initialization code
-//#define HACK 1
+/* Use the tm6000-hack, instead of the proper initialization code i*/
+/* #define HACK 1 */
 
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
@@ -98,7 +98,7 @@ enum tm6000_io_method {
 };
 
 enum tm6000_mode {
-	TM6000_MODE_UNKNOWN=0,
+	TM6000_MODE_UNKNOWN = 0,
 	TM6000_MODE_ANALOG,
 	TM6000_MODE_DIGITAL,
 };
@@ -128,7 +128,7 @@ struct tm6000_dvb {
 	struct dvb_frontend	*frontend;
 	struct dmxdev		dmxdev;
 	unsigned int		streams;
-	struct urb 		*bulk_urb;
+	struct urb		*bulk_urb;
 	struct mutex		mutex;
 };
 
@@ -147,7 +147,7 @@ struct tm6000_core {
 	enum tm6000_devtype		dev_type;	/* type of device */
 
 	v4l2_std_id                     norm;           /* Current norm */
-	int				width,height;	/* Selected resolution */
+	int				width, height;	/* Selected resolution */
 
 	enum tm6000_core_state		state;
 
@@ -208,7 +208,7 @@ struct tm6000_fh {
 
 	/* video capture */
 	struct tm6000_fmt            *fmt;
-	unsigned int                 width,height;
+	unsigned int                 width, height;
 	struct videobuf_queue        vb_vidq;
 
 	enum v4l2_buf_type           type;
@@ -220,23 +220,23 @@ struct tm6000_fh {
 
 /* In tm6000-cards.c */
 
-int tm6000_tuner_callback (void *ptr, int component, int command, int arg);
-int tm6000_xc5000_callback (void *ptr, int component, int command, int arg);
+int tm6000_tuner_callback(void *ptr, int component, int command, int arg);
+int tm6000_xc5000_callback(void *ptr, int component, int command, int arg);
 int tm6000_cards_setup(struct tm6000_core *dev);
 
 /* In tm6000-core.c */
 
-int tm6000_read_write_usb (struct tm6000_core *dev, u8 reqtype, u8 req,
+int tm6000_read_write_usb(struct tm6000_core *dev, u8 reqtype, u8 req,
 			   u16 value, u16 index, u8 *buf, u16 len);
-int tm6000_get_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
+int tm6000_get_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg32(struct tm6000_core *dev, u8 req, u16 value, u16 index);
-int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
-int tm6000_init (struct tm6000_core *dev);
+int tm6000_set_reg(struct tm6000_core *dev, u8 req, u16 value, u16 index);
+int tm6000_init(struct tm6000_core *dev);
 
-int tm6000_init_analog_mode (struct tm6000_core *dev);
-int tm6000_init_digital_mode (struct tm6000_core *dev);
-int tm6000_set_audio_bitrate (struct tm6000_core *dev, int bitrate);
+int tm6000_init_analog_mode(struct tm6000_core *dev);
+int tm6000_init_digital_mode(struct tm6000_core *dev);
+int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate);
 
 int tm6000_dvb_register(struct tm6000_core *dev);
 void tm6000_dvb_unregister(struct tm6000_core *dev);
@@ -248,7 +248,7 @@ void tm6000_set_fourcc_format(struct tm6000_core *dev);
 
 /* In tm6000-stds.c */
 void tm6000_get_std_res(struct tm6000_core *dev);
-int tm6000_set_standard (struct tm6000_core *dev, v4l2_std_id *norm);
+int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id *norm);
 
 /* In tm6000-i2c.c */
 int tm6000_i2c_register(struct tm6000_core *dev);
@@ -262,14 +262,14 @@ int tm6000_vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type i);
 int tm6000_vidioc_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type i);
-int tm6000_vidioc_reqbufs (struct file *file, void *priv,
-			   struct v4l2_requestbuffers *rb);
-int tm6000_vidioc_querybuf (struct file *file, void *priv,
-			    struct v4l2_buffer *b);
-int tm6000_vidioc_qbuf (struct file *file, void *priv, struct v4l2_buffer *b);
-int tm6000_vidioc_dqbuf (struct file *file, void *priv, struct v4l2_buffer *b);
+int tm6000_vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *rb);
+int tm6000_vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *b);
+int tm6000_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *b);
+int tm6000_vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b);
 ssize_t tm6000_v4l2_read(struct file *filp, char __user * buf, size_t count,
-			 loff_t * f_pos);
+			 loff_t *f_pos);
 unsigned int tm6000_v4l2_poll(struct file *file,
 			      struct poll_table_struct *wait);
 int tm6000_queue_init(struct tm6000_core *dev);
@@ -284,7 +284,7 @@ extern int tm6000_debug;
 
 #define dprintk(dev, level, fmt, arg...) do {\
 	if (tm6000_debug & level) \
-		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies, 		\
+		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies, \
 			 dev->name, __FUNCTION__ , ##arg); } while (0)
 
 #define V4L2_DEBUG_REG		0x0004
@@ -297,5 +297,3 @@ extern int tm6000_debug;
 #define tm6000_err(fmt, arg...) do {\
 	printk(KERN_ERR "tm6000 %s :"fmt, \
 		__FUNCTION__ , ##arg); } while (0)
-
-
-- 
1.7.0.4

