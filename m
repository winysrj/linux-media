Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 16/39] [media] DocBook: add dvb_ca_en50221.h to documentation
Date: Sat, 22 Aug 2015 14:28:01 -0300
Message-Id: <fe2622a1615d5f5cdeb06bc14d57b2308ba497fc.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are already some tags at dvb_ca_en50221.h, but using a
different format. Convert them, fix a few entries and add
to the device-drivers DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index e3e0f4880770..e0c358760344 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -227,6 +227,7 @@ X!Isound/sound_firmware.c
 !Iinclude/media/v4l2-of.h
 !Iinclude/media/v4l2-subdev.h
 !Iinclude/media/rc-core.h
+!Idrivers/media/dvb-core/dvb_ca_en50221.h
 <!-- FIXME: Removed for now due to document generation inconsistency
 X!Iinclude/media/v4l2-ctrls.h
 X!Iinclude/media/v4l2-dv-timings.h
@@ -240,7 +241,6 @@ X!Idrivers/media/dvb-core/dvb_frontend.h
 X!Idrivers/media/dvb-core/dvbdev.h
 X!Edrivers/media/dvb-core/dvb_net.c
 X!Idrivers/media/dvb-core/dvb_ringbuffer.h
-X!Idrivers/media/dvb-core/dvb_ca_en50221.h
 X!Idrivers/media/dvb-core/dvb_math.h
 -->
 
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 72937756f60c..fb66184dc9b6 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -169,10 +169,10 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * e
 /**
  * Safely find needle in haystack.
  *
- * @param haystack Buffer to look in.
- * @param hlen Number of bytes in haystack.
- * @param needle Buffer to find.
- * @param nlen Number of bytes in needle.
+ * @haystack: Buffer to look in.
+ * @hlen: Number of bytes in haystack.
+ * @needle: Buffer to find.
+ * @nlen: Number of bytes in needle.
  * @return Pointer into haystack needle was found at, or NULL if not found.
  */
 static char *findstr(char * haystack, int hlen, char * needle, int nlen)
@@ -197,7 +197,7 @@ static char *findstr(char * haystack, int hlen, char * needle, int nlen)
 
 
 /**
- * Check CAM status.
+ * dvb_ca_en50221_check_camstatus - Check CAM status.
  */
 static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 {
@@ -240,13 +240,13 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 
 
 /**
- * Wait for flags to become set on the STATUS register on a CAM interface,
- * checking for errors and timeout.
+ * dvb_ca_en50221_wait_if_status - Wait for flags to become set on the STATUS
+ *	 register on a CAM interface, checking for errors and timeout.
  *
- * @param ca CA instance.
- * @param slot Slot on interface.
- * @param waitfor Flags to wait for.
- * @param timeout_ms Timeout in milliseconds.
+ * @ca: CA instance.
+ * @slot: Slot on interface.
+ * @waitfor: Flags to wait for.
+ * @timeout_ms: Timeout in milliseconds.
  *
  * @return 0 on success, nonzero on error.
  */
@@ -290,10 +290,10 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 
 
 /**
- * Initialise the link layer connection to a CAM.
+ * dvb_ca_en50221_link_init - Initialise the link layer connection to a CAM.
  *
- * @param ca CA instance.
- * @param slot Slot id.
+ * @ca: CA instance.
+ * @slot: Slot id.
  *
  * @return 0 on success, nonzero on failure.
  */
@@ -346,14 +346,14 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 }
 
 /**
- * Read a tuple from attribute memory.
+ * dvb_ca_en50221_read_tuple - Read a tuple from attribute memory.
  *
- * @param ca CA instance.
- * @param slot Slot id.
- * @param address Address to read from. Updated.
- * @param tupleType Tuple id byte. Updated.
- * @param tupleLength Tuple length. Updated.
- * @param tuple Dest buffer for tuple (must be 256 bytes). Updated.
+ * @ca: CA instance.
+ * @slot: Slot id.
+ * @address: Address to read from. Updated.
+ * @tupleType: Tuple id byte. Updated.
+ * @tupleLength: Tuple length. Updated.
+ * @tuple: Dest buffer for tuple (must be 256 bytes). Updated.
  *
  * @return 0 on success, nonzero on error.
  */
@@ -399,11 +399,11 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 
 
 /**
- * Parse attribute memory of a CAM module, extracting Config register, and checking
- * it is a DVB CAM module.
+ * dvb_ca_en50221_parse_attributes - Parse attribute memory of a CAM module,
+ *	extracting Config register, and checking it is a DVB CAM module.
  *
- * @param ca CA instance.
- * @param slot Slot id.
+ * @ca: CA instance.
+ * @slot: Slot id.
  *
  * @return 0 on success, <0 on failure.
  */
@@ -546,10 +546,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 /**
- * Set CAM's configoption correctly.
+ * dvb_ca_en50221_set_configoption - Set CAM's configoption correctly.
  *
- * @param ca CA instance.
- * @param slot Slot containing the CAM.
+ * @ca: CA instance.
+ * @slot: Slot containing the CAM.
  */
 static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
 {
@@ -574,15 +574,16 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
 
 
 /**
- * This function talks to an EN50221 CAM control interface. It reads a buffer of
- * data from the CAM. The data can either be stored in a supplied buffer, or
- * automatically be added to the slot's rx_buffer.
+ * dvb_ca_en50221_read_data - This function talks to an EN50221 CAM control
+ *	interface. It reads a buffer of data from the CAM. The data can either
+ *	be stored in a supplied buffer, or automatically be added to the slot's
+ *	rx_buffer.
  *
- * @param ca CA instance.
- * @param slot Slot to read from.
- * @param ebuf If non-NULL, the data will be written to this buffer. If NULL,
+ * @ca: CA instance.
+ * @slot: Slot to read from.
+ * @ebuf: If non-NULL, the data will be written to this buffer. If NULL,
  * the data will be added into the buffering system as a normal fragment.
- * @param ecount Size of ebuf. Ignored if ebuf is NULL.
+ * @ecount: Size of ebuf. Ignored if ebuf is NULL.
  *
  * @return Number of bytes read, or < 0 on error
  */
@@ -698,14 +699,14 @@ exit:
 
 
 /**
- * This function talks to an EN50221 CAM control interface. It writes a buffer of data
- * to a CAM.
+ * dvb_ca_en50221_write_data - This function talks to an EN50221 CAM control
+ *				interface. It writes a buffer of data to a CAM.
  *
- * @param ca CA instance.
- * @param slot Slot to write to.
- * @param ebuf The data in this buffer is treated as a complete link-level packet to
+ * @ca: CA instance.
+ * @slot: Slot to write to.
+ * @ebuf: The data in this buffer is treated as a complete link-level packet to
  * be written.
- * @param count Size of ebuf.
+ * @count: Size of ebuf.
  *
  * @return Number of bytes written, or < 0 on error.
  */
@@ -790,10 +791,10 @@ EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 
 
 /**
- * A CAM has been removed => shut it down.
+ * dvb_ca_en50221_camready_irq - A CAM has been removed => shut it down.
  *
- * @param ca CA instance.
- * @param slot Slot to shut down.
+ * @ca: CA instance.
+ * @slot: Slot to shut down.
  */
 static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 {
@@ -815,11 +816,11 @@ EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
 
 
 /**
- * A CAMCHANGE IRQ has occurred.
+ * dvb_ca_en50221_camready_irq - A CAMCHANGE IRQ has occurred.
  *
- * @param ca CA instance.
- * @param slot Slot concerned.
- * @param change_type One of the DVB_CA_CAMCHANGE_* values.
+ * @ca: CA instance.
+ * @slot: Slot concerned.
+ * @change_type: One of the DVB_CA_CAMCHANGE_* values.
  */
 void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int change_type)
 {
@@ -844,10 +845,10 @@ EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
 
 
 /**
- * A CAMREADY IRQ has occurred.
+ * dvb_ca_en50221_camready_irq - A CAMREADY IRQ has occurred.
  *
- * @param ca CA instance.
- * @param slot Slot concerned.
+ * @ca: CA instance.
+ * @slot: Slot concerned.
  */
 void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 {
@@ -865,8 +866,8 @@ void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 /**
  * An FR or DA IRQ has occurred.
  *
- * @param ca CA instance.
- * @param slot Slot concerned.
+ * @ca: CA instance.
+ * @slot: Slot concerned.
  */
 void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 {
@@ -899,7 +900,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 /**
  * Wake up the DVB CA thread
  *
- * @param ca CA instance.
+ * @ca: CA instance.
  */
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca)
 {
@@ -914,7 +915,7 @@ static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca)
 /**
  * Update the delay used by the thread.
  *
- * @param ca CA instance.
+ * @ca: CA instance.
  */
 static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 {
@@ -1177,10 +1178,10 @@ static int dvb_ca_en50221_thread(void *data)
  * Real ioctl implementation.
  * NOTE: CA_SEND_MSG/CA_GET_MSG ioctls have userspace buffers passed to them.
  *
- * @param inode Inode concerned.
- * @param file File concerned.
- * @param cmd IOCTL command.
- * @param arg Associated argument.
+ * @inode: Inode concerned.
+ * @file: File concerned.
+ * @cmd: IOCTL command.
+ * @arg: Associated argument.
  *
  * @return 0 on success, <0 on error.
  */
@@ -1258,10 +1259,10 @@ out_unlock:
 /**
  * Wrapper for ioctl implementation.
  *
- * @param inode Inode concerned.
- * @param file File concerned.
- * @param cmd IOCTL command.
- * @param arg Associated argument.
+ * @inode: Inode concerned.
+ * @file: File concerned.
+ * @cmd: IOCTL command.
+ * @arg: Associated argument.
  *
  * @return 0 on success, <0 on error.
  */
@@ -1275,10 +1276,10 @@ static long dvb_ca_en50221_io_ioctl(struct file *file,
 /**
  * Implementation of write() syscall.
  *
- * @param file File structure.
- * @param buf Source buffer.
- * @param count Size of source buffer.
- * @param ppos Position in file (ignored).
+ * @file: File structure.
+ * @buf: Source buffer.
+ * @count: Size of source buffer.
+ * @ppos: Position in file (ignored).
  *
  * @return Number of bytes read, or <0 on error.
  */
@@ -1416,10 +1417,10 @@ nextslot:
 /**
  * Implementation of read() syscall.
  *
- * @param file File structure.
- * @param buf Destination buffer.
- * @param count Size of destination buffer.
- * @param ppos Position in file (ignored).
+ * @file: File structure.
+ * @buf: Destination buffer.
+ * @count: Size of destination buffer.
+ * @ppos: Position in file (ignored).
  *
  * @return Number of bytes read, or <0 on error.
  */
@@ -1519,8 +1520,8 @@ exit:
 /**
  * Implementation of file open syscall.
  *
- * @param inode Inode concerned.
- * @param file File concerned.
+ * @inode: Inode concerned.
+ * @file: File concerned.
  *
  * @return 0 on success, <0 on failure.
  */
@@ -1564,8 +1565,8 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 /**
  * Implementation of file close syscall.
  *
- * @param inode Inode concerned.
- * @param file File concerned.
+ * @inode: Inode concerned.
+ * @file: File concerned.
  *
  * @return 0 on success, <0 on failure.
  */
@@ -1592,8 +1593,8 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 /**
  * Implementation of poll() syscall.
  *
- * @param file File concerned.
- * @param wait poll wait table.
+ * @file: File concerned.
+ * @wait: poll wait table.
  *
  * @return Standard poll mask.
  */
@@ -1656,10 +1657,10 @@ static const struct dvb_device dvbdev_ca = {
 /**
  * Initialise a new DVB CA EN50221 interface device.
  *
- * @param dvb_adapter DVB adapter to attach the new CA device to.
- * @param ca The dvb_ca instance.
- * @param flags Flags describing the CA device (DVB_CA_FLAG_*).
- * @param slot_count Number of slots supported.
+ * @dvb_adapter: DVB adapter to attach the new CA device to.
+ * @ca: The dvb_ca instance.
+ * @flags: Flags describing the CA device (DVB_CA_FLAG_*).
+ * @slot_count: Number of slots supported.
  *
  * @return 0 on success, nonzero on failure
  */
@@ -1743,8 +1744,8 @@ EXPORT_SYMBOL(dvb_ca_en50221_release);
 /**
  * Release a DVB CA EN50221 interface device.
  *
- * @param ca_dev The dvb_device_t instance for the CA device.
- * @param ca The associated dvb_ca instance.
+ * @ca_dev: The dvb_device_t instance for the CA device.
+ * @ca: The associated dvb_ca instance.
  */
 void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 {
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.h b/drivers/media/dvb-core/dvb_ca_en50221.h
index 7df2e141187a..aba3b4fbd704 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.h
+++ b/drivers/media/dvb-core/dvb_ca_en50221.h
@@ -83,27 +83,27 @@ struct dvb_ca_en50221 {
 /* Functions for reporting IRQ events */
 
 /**
- * A CAMCHANGE IRQ has occurred.
+ * dvb_ca_en50221_camchange_irq - A CAMCHANGE IRQ has occurred.
  *
- * @param ca CA instance.
- * @param slot Slot concerned.
- * @param change_type One of the DVB_CA_CAMCHANGE_* values
+ * @pubca: CA instance.
+ * @slot: Slot concerned.
+ * @change_type: One of the DVB_CA_CAMCHANGE_* values
  */
 void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221* pubca, int slot, int change_type);
 
 /**
- * A CAMREADY IRQ has occurred.
+ * dvb_ca_en50221_camready_irq - A CAMREADY IRQ has occurred.
  *
- * @param ca CA instance.
- * @param slot Slot concerned.
+ * @pubca: CA instance.
+ * @slot: Slot concerned.
  */
 void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221* pubca, int slot);
 
 /**
- * An FR or a DA IRQ has occurred.
+ * dvb_ca_en50221_frda_irq - An FR or a DA IRQ has occurred.
  *
- * @param ca CA instance.
- * @param slot Slot concerned.
+ * @ca: CA instance.
+ * @slot: Slot concerned.
  */
 void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221* ca, int slot);
 
@@ -113,21 +113,21 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221* ca, int slot);
 /* Initialisation/shutdown functions */
 
 /**
- * Initialise a new DVB CA device.
+ * dvb_ca_en50221_init - Initialise a new DVB CA device.
  *
- * @param dvb_adapter DVB adapter to attach the new CA device to.
- * @param ca The dvb_ca instance.
- * @param flags Flags describing the CA device (DVB_CA_EN50221_FLAG_*).
- * @param slot_count Number of slots supported.
+ * @dvb_adapter: DVB adapter to attach the new CA device to.
+ * @ca: The dvb_ca instance.
+ * @flags: Flags describing the CA device (DVB_CA_EN50221_FLAG_*).
+ * @slot_count: Number of slots supported.
  *
  * @return 0 on success, nonzero on failure
  */
 extern int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter, struct dvb_ca_en50221* ca, int flags, int slot_count);
 
 /**
- * Release a DVB CA device.
+ * dvb_ca_en50221_release - Release a DVB CA device.
  *
- * @param ca The associated dvb_ca instance.
+ * @ca: The associated dvb_ca instance.
  */
 extern void dvb_ca_en50221_release(struct dvb_ca_en50221* ca);
 
-- 
2.4.3

