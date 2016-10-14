Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48681 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbcJNRrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Max Kellermann <max@duempel.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Shuah Khan <shuah@kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Abhilash Jindal <klock.android@gmail.com>,
        Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: [PATCH 11/25] [media] dvb-core: use pr_foo() instead of printk()
Date: Fri, 14 Oct 2016 14:45:49 -0300
Message-Id: <1d5040384c93e1cb37dd41e780e44a88b1e63ce4.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb-core directly calls printk() without using the modern
printk macros, or using the proper printk levels. Change it
to use pr_foo().

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.c         | 24 ++++++----
 drivers/media/dvb-core/dvb_ca_en50221.c | 57 ++++++++++++++---------
 drivers/media/dvb-core/dvb_demux.c      | 46 ++++++++++--------
 drivers/media/dvb-core/dvb_frontend.c   | 12 +++--
 drivers/media/dvb-core/dvb_net.c        | 82 ++++++++++++++++++---------------
 drivers/media/dvb-core/dvbdev.c         | 25 ++++++----
 6 files changed, 146 insertions(+), 100 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 7b67e1dd97fd..1e96a6f1b6f0 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -20,6 +20,8 @@
  *
  */
 
+#define pr_fmt(fmt) "dmxdev: " fmt
+
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
@@ -36,7 +38,11 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
 
-#define dprintk	if (debug) printk
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+			__func__, ##arg);				\
+} while (0)
 
 static int dvb_dmxdev_buffer_write(struct dvb_ringbuffer *buf,
 				   const u8 *src, size_t len)
@@ -50,7 +56,7 @@ static int dvb_dmxdev_buffer_write(struct dvb_ringbuffer *buf,
 
 	free = dvb_ringbuffer_free(buf);
 	if (len > free) {
-		dprintk("dmxdev: buffer overflow\n");
+		dprintk("buffer overflow\n");
 		return -EOVERFLOW;
 	}
 
@@ -126,7 +132,7 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 	struct dmxdev *dmxdev = dvbdev->priv;
 	struct dmx_frontend *front;
 
-	dprintk("function : %s\n", __func__);
+	dprintk("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
@@ -258,7 +264,7 @@ static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
 	void *newmem;
 	void *oldmem;
 
-	dprintk("function : %s\n", __func__);
+	dprintk("%s\n", __func__);
 
 	if (buf->size == size)
 		return 0;
@@ -367,7 +373,7 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 		return 0;
 	}
 	del_timer(&dmxdevfilter->timer);
-	dprintk("dmxdev: section callback %*ph\n", 6, buffer1);
+	dprintk("section callback %*ph\n", 6, buffer1);
 	ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer1,
 				      buffer1_len);
 	if (ret == buffer1_len) {
@@ -655,7 +661,7 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 								   secfeed,
 								   dvb_dmxdev_section_callback);
 			if (ret < 0) {
-				printk("DVB (%s): could not alloc feed\n",
+				pr_err("DVB (%s): could not alloc feed\n",
 				       __func__);
 				return ret;
 			}
@@ -663,7 +669,7 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 			ret = (*secfeed)->set(*secfeed, para->pid, 32768,
 					      (para->flags & DMX_CHECK_CRC) ? 1 : 0);
 			if (ret < 0) {
-				printk("DVB (%s): could not set feed\n",
+				pr_err("DVB (%s): could not set feed\n",
 				       __func__);
 				dvb_dmxdev_feed_restart(filter);
 				return ret;
@@ -844,7 +850,7 @@ static int dvb_dmxdev_filter_set(struct dmxdev *dmxdev,
 				 struct dmxdev_filter *dmxdevfilter,
 				 struct dmx_sct_filter_params *params)
 {
-	dprintk("function : %s, PID=0x%04x, flags=%02x, timeout=%d\n",
+	dprintk("%s: PID=0x%04x, flags=%02x, timeout=%d\n",
 		__func__, params->pid, params->flags, params->timeout);
 
 	dvb_dmxdev_filter_stop(dmxdevfilter);
@@ -1184,7 +1190,7 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 	struct dmxdev *dmxdev = dvbdev->priv;
 	unsigned int mask = 0;
 
-	dprintk("function : %s\n", __func__);
+	dprintk("%s\n", __func__);
 
 	if (dmxdev->exit)
 		return POLLERR;
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index b5b5b195ea7f..262a492e7c08 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -28,6 +28,8 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
+#define pr_fmt(fmt) "dvb_ca_en50221: " fmt
+
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/list.h>
@@ -46,7 +48,10 @@ static int dvb_ca_en50221_debug;
 module_param_named(cam_debug, dvb_ca_en50221_debug, int, 0644);
 MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 
-#define dprintk if (dvb_ca_en50221_debug) printk
+#define dprintk(fmt, arg...) do {					\
+	if (dvb_ca_en50221_debug)					\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt), __func__, ##arg);\
+} while (0)
 
 #define INIT_TIMEOUT_SECS 10
 
@@ -298,7 +303,8 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 
 		/* if we got the flags, it was successful! */
 		if (res & waitfor) {
-			dprintk("%s succeeded timeout:%lu\n", __func__, jiffies - start);
+			dprintk("%s succeeded timeout:%lu\n",
+				__func__, jiffies - start);
 			return 0;
 		}
 
@@ -519,8 +525,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 	/* is it a version we support? */
 	if (strncmp(dvb_str + 8, "1.00", 4)) {
-		printk("dvb_ca adapter %d: Unsupported DVB CAM module version %c%c%c%c\n",
-		       ca->dvbdev->adapter->num, dvb_str[8], dvb_str[9], dvb_str[10], dvb_str[11]);
+		pr_err("dvb_ca adapter %d: Unsupported DVB CAM module version %c%c%c%c\n",
+		       ca->dvbdev->adapter->num, dvb_str[8], dvb_str[9],
+		       dvb_str[10], dvb_str[11]);
 		return -EINVAL;
 	}
 
@@ -557,8 +564,8 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 			break;
 
 		default:	/* Unknown tuple type - just skip this tuple and move to the next one */
-			dprintk("dvb_ca: Skipping unknown tuple type:0x%x length:0x%x\n", tupleType,
-				tupleLength);
+			dprintk("dvb_ca: Skipping unknown tuple type:0x%x length:0x%x\n",
+				tupleType, tupleLength);
 			break;
 		}
 	}
@@ -567,7 +574,8 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 		return -EINVAL;
 
 	dprintk("Valid DVB CAM detected MANID:%x DEVID:%x CONFIGBASE:0x%x CONFIGOPTION:0x%x\n",
-		manfid, devid, ca->slot_info[slot].config_base, ca->slot_info[slot].config_option);
+		manfid, devid, ca->slot_info[slot].config_base,
+		ca->slot_info[slot].config_option);
 
 	// success!
 	return 0;
@@ -661,14 +669,15 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 	/* check it will fit */
 	if (ebuf == NULL) {
 		if (bytes_read > ca->slot_info[slot].link_buf_size) {
-			printk("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
-			       ca->dvbdev->adapter->num, bytes_read, ca->slot_info[slot].link_buf_size);
+			pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
+			       ca->dvbdev->adapter->num, bytes_read,
+			       ca->slot_info[slot].link_buf_size);
 			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 			status = -EIO;
 			goto exit;
 		}
 		if (bytes_read < 2) {
-			printk("dvb_ca adapter %d: CAM sent a buffer that was less than 2 bytes!\n",
+			pr_err("dvb_ca adapter %d: CAM sent a buffer that was less than 2 bytes!\n",
 			       ca->dvbdev->adapter->num);
 			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 			status = -EIO;
@@ -676,7 +685,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 		}
 	} else {
 		if (bytes_read > ecount) {
-			printk("dvb_ca adapter %d: CAM tried to send a buffer larger than the ecount size!\n",
+			pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the ecount size!\n",
 			       ca->dvbdev->adapter->num);
 			status = -EIO;
 			goto exit;
@@ -1062,7 +1071,7 @@ static int dvb_ca_en50221_thread(void *data)
 
 			case DVB_CA_SLOTSTATE_WAITREADY:
 				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
-					printk("dvb_ca adaptor %d: PC card did not respond :(\n",
+					pr_err("dvb_ca adaptor %d: PC card did not respond :(\n",
 					       ca->dvbdev->adapter->num);
 					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
@@ -1084,14 +1093,14 @@ static int dvb_ca_en50221_thread(void *data)
 						}
 					}
 
-					printk("dvb_ca adapter %d: Invalid PC card inserted :(\n",
+					pr_err("dvb_ca adapter %d: Invalid PC card inserted :(\n",
 					       ca->dvbdev->adapter->num);
 					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 				if (dvb_ca_en50221_set_configoption(ca, slot) != 0) {
-					printk("dvb_ca adapter %d: Unable to initialise CAM :(\n",
+					pr_err("dvb_ca adapter %d: Unable to initialise CAM :(\n",
 					       ca->dvbdev->adapter->num);
 					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
@@ -1099,7 +1108,7 @@ static int dvb_ca_en50221_thread(void *data)
 				}
 				if (ca->pub->write_cam_control(ca->pub, slot,
 							       CTRLIF_COMMAND, CMDREG_RS) != 0) {
-					printk("dvb_ca adapter %d: Unable to reset CAM IF\n",
+					pr_err("dvb_ca adapter %d: Unable to reset CAM IF\n",
 					       ca->dvbdev->adapter->num);
 					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
@@ -1114,7 +1123,7 @@ static int dvb_ca_en50221_thread(void *data)
 
 			case DVB_CA_SLOTSTATE_WAITFR:
 				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
-					printk("dvb_ca adapter %d: DVB CAM did not respond :(\n",
+					pr_err("dvb_ca adapter %d: DVB CAM did not respond :(\n",
 					       ca->dvbdev->adapter->num);
 					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
@@ -1141,7 +1150,8 @@ static int dvb_ca_en50221_thread(void *data)
 						}
 					}
 
-					printk("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n", ca->dvbdev->adapter->num);
+					pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
+					       ca->dvbdev->adapter->num);
 					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
@@ -1150,7 +1160,8 @@ static int dvb_ca_en50221_thread(void *data)
 				if (ca->slot_info[slot].rx_buffer.data == NULL) {
 					rxbuf = vmalloc(RX_BUFFER_SIZE);
 					if (rxbuf == NULL) {
-						printk("dvb_ca adapter %d: Unable to allocate CAM rx buffer :(\n", ca->dvbdev->adapter->num);
+						pr_err("dvb_ca adapter %d: Unable to allocate CAM rx buffer :(\n",
+						       ca->dvbdev->adapter->num);
 						ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
 						dvb_ca_en50221_thread_update_delay(ca);
 						break;
@@ -1161,7 +1172,8 @@ static int dvb_ca_en50221_thread(void *data)
 				ca->pub->slot_ts_enable(ca->pub, slot);
 				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_RUNNING;
 				dvb_ca_en50221_thread_update_delay(ca);
-				printk("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n", ca->dvbdev->adapter->num);
+				pr_err("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n",
+				       ca->dvbdev->adapter->num);
 				break;
 
 			case DVB_CA_SLOTSTATE_RUNNING:
@@ -1497,7 +1509,8 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 	pktlen = 2;
 	do {
 		if (idx == -1) {
-			printk("dvb_ca adapter %d: BUG: read packet ended before last_fragment encountered\n", ca->dvbdev->adapter->num);
+			pr_err("dvb_ca adapter %d: BUG: read packet ended before last_fragment encountered\n",
+			       ca->dvbdev->adapter->num);
 			status = -EIO;
 			goto exit;
 		}
@@ -1755,8 +1768,8 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 				 ca->dvbdev->adapter->num, ca->dvbdev->id);
 	if (IS_ERR(ca->thread)) {
 		ret = PTR_ERR(ca->thread);
-		printk("dvb_ca_init: failed to start kernel_thread (%d)\n",
-			ret);
+		pr_err("dvb_ca_init: failed to start kernel_thread (%d)\n",
+		       ret);
 		goto unregister_device;
 	}
 	return 0;
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 280716f1cc46..a0a1f8456c54 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -21,6 +21,8 @@
  *
  */
 
+#define pr_fmt(fmt) "dvb_demux: " fmt
+
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
@@ -55,10 +57,13 @@ module_param(dvb_demux_feed_err_pkts, int, 0644);
 MODULE_PARM_DESC(dvb_demux_feed_err_pkts,
 		 "when set to 0, drop packets with the TEI bit set (1 by default)");
 
-#define dprintk_tscheck(x...) do {                              \
-		if (dvb_demux_tscheck && printk_ratelimit())    \
-			printk(x);                              \
-	} while (0)
+#define dprintk(fmt, arg...) \
+	printk(KERN_DEBUG pr_fmt("%s: " fmt),  __func__, ##arg)
+
+#define dprintk_tscheck(x...) do {			\
+	if (dvb_demux_tscheck && printk_ratelimit())	\
+		dprintk(x);				\
+} while (0)
 
 /******************************************************************************
  * static inlined helper functions
@@ -122,7 +127,7 @@ static inline int dvb_dmx_swfilter_payload(struct dvb_demux_feed *feed,
 	ccok = ((feed->cc + 1) & 0x0f) == cc;
 	feed->cc = cc;
 	if (!ccok)
-		printk("missed packet!\n");
+		dprintk("missed packet!\n");
 	*/
 
 	if (buf[1] & 0x40)	// PUSI ?
@@ -199,12 +204,12 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
 		 * but just first and last.
 		 */
 		if (sec->secbuf[0] != 0xff || sec->secbuf[n - 1] != 0xff) {
-			printk("dvb_demux.c section ts padding loss: %d/%d\n",
+			dprintk("dvb_demux.c section ts padding loss: %d/%d\n",
 			       n, sec->tsfeedp);
-			printk("dvb_demux.c pad data:");
+			dprintk("dvb_demux.c pad data:");
 			for (i = 0; i < n; i++)
-				printk(" %02x", sec->secbuf[i]);
-			printk("\n");
+				pr_cont(" %02x", sec->secbuf[i]);
+			pr_cont("\n");
 		}
 	}
 #endif
@@ -243,7 +248,7 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 
 	if (sec->tsfeedp + len > DMX_MAX_SECFEED_SIZE) {
 #ifdef DVB_DEMUX_SECTION_LOSS_LOG
-		printk("dvb_demux.c section buffer full loss: %d/%d\n",
+		dprintk("dvb_demux.c section buffer full loss: %d/%d\n",
 		       sec->tsfeedp + len - DMX_MAX_SECFEED_SIZE,
 		       DMX_MAX_SECFEED_SIZE);
 #endif
@@ -278,7 +283,7 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 			dvb_dmx_swfilter_section_feed(feed);
 #ifdef DVB_DEMUX_SECTION_LOSS_LOG
 		else
-			printk("dvb_demux.c pusi not seen, discarding section data\n");
+			dprintk("dvb_demux.c pusi not seen, discarding section data\n");
 #endif
 		sec->secbufp += seclen;	/* secbufp and secbuf moving together is */
 		sec->secbuf += seclen;	/* redundant but saves pointer arithmetic */
@@ -313,8 +318,8 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 
 	if (!ccok || dc_i) {
 #ifdef DVB_DEMUX_SECTION_LOSS_LOG
-		printk("dvb_demux.c discontinuity detected %d bytes lost\n",
-		       count);
+		dprintk("dvb_demux.c discontinuity detected %d bytes lost\n",
+			count);
 		/*
 		 * those bytes under sume circumstances will again be reported
 		 * in the following dvb_dmx_swfilter_section_new
@@ -346,7 +351,8 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 		}
 #ifdef DVB_DEMUX_SECTION_LOSS_LOG
 		else if (count > 0)
-			printk("dvb_demux.c PUSI=1 but %d bytes lost\n", count);
+			dprintk("dvb_demux.c PUSI=1 but %d bytes lost\n",
+				count);
 #endif
 	} else {
 		/* PUSI=0 (is not set), no section boundary */
@@ -415,9 +421,9 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 						1024);
 				speed_timedelta = ktime_ms_delta(cur_time,
 							demux->speed_last_time);
-				printk(KERN_INFO "TS speed %llu Kbits/sec \n",
-						div64_u64(speed_bytes,
-							speed_timedelta));
+				dprintk("TS speed %llu Kbits/sec \n",
+					div64_u64(speed_bytes,
+						  speed_timedelta));
 			}
 
 			demux->speed_last_time = cur_time;
@@ -634,7 +640,7 @@ static void dvb_demux_feed_add(struct dvb_demux_feed *feed)
 {
 	spin_lock_irq(&feed->demux->lock);
 	if (dvb_demux_feed_find(feed)) {
-		printk(KERN_ERR "%s: feed already in list (type=%x state=%x pid=%x)\n",
+		pr_err("%s: feed already in list (type=%x state=%x pid=%x)\n",
 		       __func__, feed->type, feed->state, feed->pid);
 		goto out;
 	}
@@ -648,7 +654,7 @@ static void dvb_demux_feed_del(struct dvb_demux_feed *feed)
 {
 	spin_lock_irq(&feed->demux->lock);
 	if (!(dvb_demux_feed_find(feed))) {
-		printk(KERN_ERR "%s: feed not in list (type=%x state=%x pid=%x)\n",
+		pr_err("%s: feed not in list (type=%x state=%x pid=%x)\n",
 		       __func__, feed->type, feed->state, feed->pid);
 		goto out;
 	}
@@ -1267,7 +1273,7 @@ int dvb_dmx_init(struct dvb_demux *dvbdemux)
 
 	dvbdemux->cnt_storage = vmalloc(MAX_PID + 1);
 	if (!dvbdemux->cnt_storage)
-		printk(KERN_WARNING "Couldn't allocate memory for TS/TEI check. Disabling it\n");
+		pr_warn("Couldn't allocate memory for TS/TEI check. Disabling it\n");
 
 	INIT_LIST_HEAD(&dvbdemux->frontend_list);
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 01511e5a5566..98edf46b22d0 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -28,6 +28,8 @@
 /* Enables DVBv3 compatibility bits at the headers */
 #define __DVB_CORE__
 
+#define pr_fmt(fmt) "dvb_frontend: " fmt
+
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -67,6 +69,9 @@ MODULE_PARM_DESC(dvb_powerdown_on_sleep, "0: do not power down, 1: turn LNB volt
 module_param(dvb_mfe_wait_time, int, 0644);
 MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open() for multi-frontend to become available (default:5 seconds)");
 
+#define dprintk(fmt, arg...) \
+	printk(KERN_DEBUG pr_fmt("%s: " fmt), __func__, ##arg)
+
 #define FESTATE_IDLE 1
 #define FESTATE_RETUNE 2
 #define FESTATE_TUNING_FAST 4
@@ -2356,7 +2361,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			int i;
 			u8 last = 1;
 			if (dvb_frontend_debug)
-				printk("%s switch command: 0x%04lx\n", __func__, swcmd);
+				dprintk("%s switch command: 0x%04lx\n",
+					__func__, swcmd);
 			nexttime = ktime_get_boottime();
 			if (dvb_frontend_debug)
 				tv[0] = nexttime;
@@ -2379,10 +2385,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 					dvb_frontend_sleep_until(&nexttime, 8000);
 			}
 			if (dvb_frontend_debug) {
-				printk("%s(%d): switch delay (should be 32k followed by all 8k\n",
+				dprintk("%s(%d): switch delay (should be 32k followed by all 8k)\n",
 					__func__, fe->dvb->num);
 				for (i = 1; i < 10; i++)
-					printk("%d: %d\n", i,
+					pr_info("%d: %d\n", i,
 					(int) ktime_us_delta(tv[i], tv[i-1]));
 			}
 			err = 0;
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 9914f69a4a02..063f63563919 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -54,6 +54,8 @@
  *
  */
 
+#define pr_fmt(fmt) "dvb_net: " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
@@ -344,7 +346,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 
 			/* Check TS error conditions: sync_byte, transport_error_indicator, scrambling_control . */
 			if ((ts[0] != TS_SYNC) || (ts[1] & TS_TEI) || ((ts[3] & TS_SC) != 0)) {
-				printk(KERN_WARNING "%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
+				pr_warn("%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
 				       priv->ts_count, ts[0],
 				       (ts[1] & TS_TEI) >> 7,
 				       (ts[3] & TS_SC) >> 6);
@@ -376,8 +378,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 				priv->tscc = ts[3] & 0x0F;
 				/* There is a pointer field here. */
 				if (ts[4] > ts_remain) {
-					printk(KERN_ERR "%lu: Invalid ULE packet "
-					       "(pointer field %d)\n", priv->ts_count, ts[4]);
+					pr_err("%lu: Invalid ULE packet (pointer field %d)\n",
+					       priv->ts_count, ts[4]);
 					ts += TS_SZ;
 					priv->ts_count++;
 					continue;
@@ -400,8 +402,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 				priv->tscc = (priv->tscc + 1) & 0x0F;
 			else {
 				/* TS discontinuity handling: */
-				printk(KERN_WARNING "%lu: TS discontinuity: got %#x, "
-				       "expected %#x.\n", priv->ts_count, ts[3] & 0x0F, priv->tscc);
+				pr_warn("%lu: TS discontinuity: got %#x, expected %#x.\n",
+					priv->ts_count, ts[3] & 0x0F,
+					priv->tscc);
 				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
 				if (priv->ule_skb) {
 					dev_kfree_skb( priv->ule_skb );
@@ -423,8 +426,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 				if (! priv->need_pusi) {
 					if (!(*from_where < (ts_remain-1)) || *from_where != priv->ule_sndu_remain) {
 						/* Pointer field is invalid.  Drop this TS cell and any started ULE SNDU. */
-						printk(KERN_WARNING "%lu: Invalid pointer "
-						       "field: %u.\n", priv->ts_count, *from_where);
+						pr_warn("%lu: Invalid pointer field: %u.\n",
+							priv->ts_count,
+							*from_where);
 
 						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
 						if (priv->ule_skb) {
@@ -454,9 +458,10 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 					 * current TS cell. */
 					dev->stats.rx_errors++;
 					dev->stats.rx_length_errors++;
-					printk(KERN_WARNING "%lu: Expected %d more SNDU bytes, but "
-					       "got PUSI (pf %d, ts_remain %d).  Flushing incomplete payload.\n",
-					       priv->ts_count, priv->ule_sndu_remain, ts[4], ts_remain);
+					pr_warn("%lu: Expected %d more SNDU bytes, but got PUSI (pf %d, ts_remain %d).  Flushing incomplete payload.\n",
+						priv->ts_count,
+						priv->ule_sndu_remain,
+						ts[4], ts_remain);
 					dev_kfree_skb(priv->ule_skb);
 					/* Prepare for next SNDU. */
 					reset_ule(priv);
@@ -475,8 +480,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 			 * TS.
 			 * Check ts_remain has to be >= 2 here. */
 			if (ts_remain < 2) {
-				printk(KERN_WARNING "Invalid payload packing: only %d "
-				       "bytes left in TS.  Resyncing.\n", ts_remain);
+				pr_warn("Invalid payload packing: only %d bytes left in TS.  Resyncing.\n",
+					ts_remain);
 				priv->ule_sndu_len = 0;
 				priv->need_pusi = 1;
 				ts += TS_SZ;
@@ -494,8 +499,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 					priv->ule_dbit = 0;
 
 				if (priv->ule_sndu_len < 5) {
-					printk(KERN_WARNING "%lu: Invalid ULE SNDU length %u. "
-					       "Resyncing.\n", priv->ts_count, priv->ule_sndu_len);
+					pr_warn("%lu: Invalid ULE SNDU length %u. Resyncing.\n",
+						priv->ts_count,
+						priv->ule_sndu_len);
 					dev->stats.rx_errors++;
 					dev->stats.rx_length_errors++;
 					priv->ule_sndu_len = 0;
@@ -550,8 +556,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 			 * prepare for the largest case: bridged SNDU with MAC address (dbit = 0). */
 			priv->ule_skb = dev_alloc_skb( priv->ule_sndu_len + ETH_HLEN + ETH_ALEN );
 			if (priv->ule_skb == NULL) {
-				printk(KERN_NOTICE "%s: Memory squeeze, dropping packet.\n",
-				       dev->name);
+				pr_notice("%s: Memory squeeze, dropping packet.\n",
+					  dev->name);
 				dev->stats.rx_dropped++;
 				return;
 			}
@@ -595,8 +601,11 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 				       *(tail - 2) << 8 |
 				       *(tail - 1);
 			if (ule_crc != expected_crc) {
-				printk(KERN_WARNING "%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
-				       priv->ts_count, ule_crc, expected_crc, priv->ule_sndu_len, priv->ule_sndu_type, ts_remain, ts_remain > 2 ? *(unsigned short *)from_where : 0);
+				pr_warn("%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
+				       priv->ts_count, ule_crc, expected_crc,
+				       priv->ule_sndu_len, priv->ule_sndu_type,
+				       ts_remain,
+				       ts_remain > 2 ? *(unsigned short *)from_where : 0);
 
 #ifdef ULE_DEBUG
 				hexdump( iov[0].iov_base, iov[0].iov_len );
@@ -687,7 +696,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 					int l = handle_ule_extensions(priv);
 					if (l < 0) {
 						/* Mandatory extension header unknown or TEST SNDU.  Drop it. */
-						// printk( KERN_WARNING "Dropping SNDU, extension headers.\n" );
+						// pr_warn("Dropping SNDU, extension headers.\n" );
 						dev_kfree_skb(priv->ule_skb);
 						goto sndu_done;
 					}
@@ -741,10 +750,10 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 			priv->ule_skb = NULL;
 			priv->ule_sndu_type_1 = 0;
 			priv->ule_sndu_len = 0;
-			// printk(KERN_WARNING "More data in current TS: [%#x %#x %#x %#x]\n",
+			// pr_warn("More data in current TS: [%#x %#x %#x %#x]\n",
 			//	*(from_where + 0), *(from_where + 1),
 			//	*(from_where + 2), *(from_where + 3));
-			// printk(KERN_WARNING "ts @ %p, stopped @ %p:\n", ts, from_where + 0);
+			// pr_warn("ts @ %p, stopped @ %p:\n", ts, from_where + 0);
 			// hexdump(ts, 188);
 		} else {
 			new_ts = 1;
@@ -766,10 +775,10 @@ static int dvb_net_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	struct net_device *dev = feed->priv;
 
 	if (buffer2)
-		printk(KERN_WARNING "buffer2 not NULL: %p.\n", buffer2);
+		pr_warn("buffer2 not NULL: %p.\n", buffer2);
 	if (buffer1_len > 32768)
-		printk(KERN_WARNING "length > 32k: %zu.\n", buffer1_len);
-	/* printk("TS callback: %u bytes, %u TS cells @ %p.\n",
+		pr_warn("length > 32k: %zu.\n", buffer1_len);
+	/* pr_info("TS callback: %u bytes, %u TS cells @ %p.\n",
 		  buffer1_len, buffer1_len / TS_SZ, buffer1); */
 	dvb_net_ule(dev, buffer1, buffer1_len);
 	return 0;
@@ -786,7 +795,7 @@ static void dvb_net_sec(struct net_device *dev,
 
 	/* note: pkt_len includes a 32bit checksum */
 	if (pkt_len < 16) {
-		printk("%s: IP/MPE packet length = %d too small.\n",
+		pr_warn("%s: IP/MPE packet length = %d too small.\n",
 			dev->name, pkt_len);
 		stats->rx_errors++;
 		stats->rx_length_errors++;
@@ -824,7 +833,7 @@ static void dvb_net_sec(struct net_device *dev,
 	 * 12 byte MPE header; 4 byte checksum; + 2 byte alignment, 8 byte LLC/SNAP
 	 */
 	if (!(skb = dev_alloc_skb(pkt_len - 4 - 12 + 14 + 2 - snap))) {
-		//printk(KERN_NOTICE "%s: Memory squeeze, dropping packet.\n", dev->name);
+		//pr_notice("%s: Memory squeeze, dropping packet.\n", dev->name);
 		stats->rx_dropped++;
 		return;
 	}
@@ -903,7 +912,7 @@ static int dvb_net_filter_sec_set(struct net_device *dev,
 	*secfilter=NULL;
 	ret = priv->secfeed->allocate_filter(priv->secfeed, secfilter);
 	if (ret<0) {
-		printk("%s: could not get filter\n", dev->name);
+		pr_err("%s: could not get filter\n", dev->name);
 		return ret;
 	}
 
@@ -944,7 +953,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 	netdev_dbg(dev, "rx_mode %i\n", priv->rx_mode);
 	mutex_lock(&priv->mutex);
 	if (priv->tsfeed || priv->secfeed || priv->secfilter || priv->multi_secfilter[0])
-		printk("%s: BUG %d\n", __func__, __LINE__);
+		pr_err("%s: BUG %d\n", __func__, __LINE__);
 
 	priv->secfeed=NULL;
 	priv->secfilter=NULL;
@@ -955,14 +964,15 @@ static int dvb_net_feed_start(struct net_device *dev)
 		ret=demux->allocate_section_feed(demux, &priv->secfeed,
 					 dvb_net_sec_callback);
 		if (ret<0) {
-			printk("%s: could not allocate section feed\n", dev->name);
+			pr_err("%s: could not allocate section feed\n",
+			       dev->name);
 			goto error;
 		}
 
 		ret = priv->secfeed->set(priv->secfeed, priv->pid, 32768, 1);
 
 		if (ret<0) {
-			printk("%s: could not set section feed\n", dev->name);
+			pr_err("%s: could not set section feed\n", dev->name);
 			priv->demux->release_section_feed(priv->demux, priv->secfeed);
 			priv->secfeed=NULL;
 			goto error;
@@ -1003,7 +1013,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 		netdev_dbg(dev, "alloc tsfeed\n");
 		ret = demux->allocate_ts_feed(demux, &priv->tsfeed, dvb_net_ts_callback);
 		if (ret < 0) {
-			printk("%s: could not allocate ts feed\n", dev->name);
+			pr_err("%s: could not allocate ts feed\n", dev->name);
 			goto error;
 		}
 
@@ -1018,7 +1028,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 					);
 
 		if (ret < 0) {
-			printk("%s: could not set ts feed\n", dev->name);
+			pr_err("%s: could not set ts feed\n", dev->name);
 			priv->demux->release_ts_feed(priv->demux, priv->tsfeed);
 			priv->tsfeed = NULL;
 			goto error;
@@ -1067,7 +1077,7 @@ static int dvb_net_feed_stop(struct net_device *dev)
 			priv->demux->release_section_feed(priv->demux, priv->secfeed);
 			priv->secfeed = NULL;
 		} else
-			printk("%s: no feed to stop\n", dev->name);
+			pr_err("%s: no feed to stop\n", dev->name);
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
 		if (priv->tsfeed) {
 			if (priv->tsfeed->is_filtering) {
@@ -1078,7 +1088,7 @@ static int dvb_net_feed_stop(struct net_device *dev)
 			priv->tsfeed = NULL;
 		}
 		else
-			printk("%s: no ts feed to stop\n", dev->name);
+			pr_err("%s: no ts feed to stop\n", dev->name);
 	} else
 		ret = -EINVAL;
 	mutex_unlock(&priv->mutex);
@@ -1279,7 +1289,7 @@ static int dvb_net_add_if(struct dvb_net *dvbnet, u16 pid, u8 feedtype)
 		free_netdev(net);
 		return result;
 	}
-	printk("dvb_net: created network interface %s\n", net->name);
+	pr_info("created network interface %s\n", net->name);
 
 	return if_num;
 }
@@ -1298,7 +1308,7 @@ static int dvb_net_remove_if(struct dvb_net *dvbnet, unsigned long num)
 	dvb_net_stop(net);
 	flush_work(&priv->set_multicast_list_wq);
 	flush_work(&priv->restart_net_feed_wq);
-	printk("dvb_net: removed network interface %s\n", net->name);
+	pr_info("removed network interface %s\n", net->name);
 	unregister_netdev(net);
 	dvbnet->state[num]=0;
 	dvbnet->device[num] = NULL;
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 75a3f4b57fd4..0694d1d53c67 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -21,6 +21,8 @@
  *
  */
 
+#define pr_fmt(fmt) "dvbdev: " fmt
+
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/string.h>
@@ -43,7 +45,11 @@ static int dvbdev_debug;
 module_param(dvbdev_debug, int, 0644);
 MODULE_PARM_DESC(dvbdev_debug, "Turn on/off device debugging (default:off).");
 
-#define dprintk if (dvbdev_debug) printk
+#define dprintk(fmt, arg...) do {					\
+	if (dvbdev_debug)						\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
+} while (0)
 
 static LIST_HEAD(dvb_adapter_list);
 static DEFINE_MUTEX(dvbdev_register_lock);
@@ -354,7 +360,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 	if (ret)
 		return ret;
 
-	printk(KERN_DEBUG "%s: media entity '%s' registered.\n",
+	pr_info("%s: media entity '%s' registered.\n",
 		__func__, dvbdev->entity->name);
 
 	return 0;
@@ -438,7 +444,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if ((id = dvbdev_get_free_id (adap, type)) < 0){
 		mutex_unlock(&dvbdev_register_lock);
 		*pdvbdev = NULL;
-		printk(KERN_ERR "%s: couldn't find free device id\n", __func__);
+		pr_err("%s: couldn't find free device id\n", __func__);
 		return -ENFILE;
 	}
 
@@ -493,8 +499,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 
 	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
 	if (ret) {
-		printk(KERN_ERR
-		      "%s: dvb_register_media_device failed to create the mediagraph\n",
+		pr_err("%s: dvb_register_media_device failed to create the mediagraph\n",
 		      __func__);
 
 		dvb_media_device_free(dvbdev);
@@ -511,11 +516,11 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			       MKDEV(DVB_MAJOR, minor),
 			       dvbdev, "dvb%d.%s%d", adap->num, dnames[type], id);
 	if (IS_ERR(clsdev)) {
-		printk(KERN_ERR "%s: failed to create device dvb%d.%s%d (%ld)\n",
+		pr_err("%s: failed to create device dvb%d.%s%d (%ld)\n",
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		return PTR_ERR(clsdev);
 	}
-	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
+	dprintk("DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, minor, minor);
 
 	return 0;
@@ -808,7 +813,7 @@ int dvb_register_adapter(struct dvb_adapter *adap, const char *name,
 	memset (adap, 0, sizeof(struct dvb_adapter));
 	INIT_LIST_HEAD (&adap->device_list);
 
-	printk(KERN_INFO "DVB: registering new adapter (%s)\n", name);
+	pr_info("DVB: registering new adapter (%s)\n", name);
 
 	adap->num = num;
 	adap->name = name;
@@ -926,13 +931,13 @@ static int __init init_dvbdev(void)
 	dev_t dev = MKDEV(DVB_MAJOR, 0);
 
 	if ((retval = register_chrdev_region(dev, MAX_DVB_MINORS, "DVB")) != 0) {
-		printk(KERN_ERR "dvb-core: unable to get major %d\n", DVB_MAJOR);
+		pr_err("dvb-core: unable to get major %d\n", DVB_MAJOR);
 		return retval;
 	}
 
 	cdev_init(&dvb_device_cdev, &dvb_device_fops);
 	if ((retval = cdev_add(&dvb_device_cdev, dev, MAX_DVB_MINORS)) != 0) {
-		printk(KERN_ERR "dvb-core: unable register character device\n");
+		pr_err("dvb-core: unable register character device\n");
 		goto error;
 	}
 
-- 
2.7.4


