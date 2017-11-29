Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63053 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754344AbdK2Kqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jasmin Jessich <jasmin@anw.at>,
        Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 01/12] media: dvb_ca_en50221: fix lots of documentation warnings
Date: Wed, 29 Nov 2017 05:46:22 -0500
Message-Id: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building the driver with gcc 7.2.1 and:
	make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' M=drivers/media

now produces a lot of warnings:
	drivers/media/dvb-core/dvb_ca_en50221.c:233: warning: No description found for parameter 'ca'
	drivers/media/dvb-core/dvb_ca_en50221.c:233: warning: No description found for parameter 'slot'
	drivers/media/dvb-core/dvb_ca_en50221.c:284: warning: No description found for parameter 'timeout_hz'
	drivers/media/dvb-core/dvb_ca_en50221.c:284: warning: Excess function parameter 'timeout_ms' description in 'dvb_ca_en50221_wait_if_status'
	drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: No description found for parameter 'tuple_type'
	drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: No description found for parameter 'tuple_length'
	drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: Excess function parameter 'tupleType' description in 'dvb_ca_en50221_read_tuple'
	drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: Excess function parameter 'tupleLength' description in 'dvb_ca_en50221_read_tuple'
	drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: No description found for parameter 'buf'
	drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: No description found for parameter 'bytes_write'
	drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: Excess function parameter 'ebuf' description in 'dvb_ca_en50221_write_data'
	drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: Excess function parameter 'count' description in 'dvb_ca_en50221_write_data'
	drivers/media/dvb-core/dvb_ca_en50221.c:942: warning: No description found for parameter 'pubca'
	drivers/media/dvb-core/dvb_ca_en50221.c:942: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_camchange_irq'
	drivers/media/dvb-core/dvb_ca_en50221.c:970: warning: No description found for parameter 'pubca'
	drivers/media/dvb-core/dvb_ca_en50221.c:970: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_camready_irq'
	drivers/media/dvb-core/dvb_ca_en50221.c:990: warning: No description found for parameter 'pubca'
	drivers/media/dvb-core/dvb_ca_en50221.c:990: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_frda_irq'
	drivers/media/dvb-core/dvb_ca_en50221.c:1304: warning: No description found for parameter 'data'
	drivers/media/dvb-core/dvb_ca_en50221.c:1348: warning: No description found for parameter 'parg'
	drivers/media/dvb-core/dvb_ca_en50221.c:1348: warning: Excess function parameter 'inode' description in 'dvb_ca_en50221_io_do_ioctl'
	drivers/media/dvb-core/dvb_ca_en50221.c:1348: warning: Excess function parameter 'arg' description in 'dvb_ca_en50221_io_do_ioctl'
	drivers/media/dvb-core/dvb_ca_en50221.c:1432: warning: Excess function parameter 'inode' description in 'dvb_ca_en50221_io_ioctl'
	drivers/media/dvb-core/dvb_ca_en50221.c:1544: warning: No description found for parameter 'ca'
	drivers/media/dvb-core/dvb_ca_en50221.c:1544: warning: No description found for parameter 'result'
	drivers/media/dvb-core/dvb_ca_en50221.c:1544: warning: No description found for parameter '_slot'
	drivers/media/dvb-core/dvb_ca_en50221.c:1849: warning: No description found for parameter 'pubca'
	drivers/media/dvb-core/dvb_ca_en50221.c:1849: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_init'
	drivers/media/dvb-core/dvb_ca_en50221.c:1936: warning: No description found for parameter 'pubca'
	drivers/media/dvb-core/dvb_ca_en50221.c:1936: warning: Excess function parameter 'ca_dev' description in 'dvb_ca_en50221_release'
	drivers/media/dvb-core/dvb_ca_en50221.c:1936: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_release'

Trivially fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 68 ++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 95b3723282f4..d48b61eb01f4 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -206,7 +206,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
  * @hlen: Number of bytes in haystack.
  * @needle: Buffer to find.
  * @nlen: Number of bytes in needle.
- * @return Pointer into haystack needle was found at, or NULL if not found.
+ * return: Pointer into haystack needle was found at, or NULL if not found.
  */
 static char *findstr(char *haystack, int hlen, char *needle, int nlen)
 {
@@ -226,7 +226,7 @@ static char *findstr(char *haystack, int hlen, char *needle, int nlen)
 /* ************************************************************************** */
 /* EN50221 physical interface functions */
 
-/**
+/*
  * dvb_ca_en50221_check_camstatus - Check CAM status.
  */
 static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
@@ -275,9 +275,9 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
  * @ca: CA instance.
  * @slot: Slot on interface.
  * @waitfor: Flags to wait for.
- * @timeout_ms: Timeout in milliseconds.
+ * @timeout_hz: Timeout in milliseconds.
  *
- * @return 0 on success, nonzero on error.
+ * return: 0 on success, nonzero on error.
  */
 static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 					 u8 waitfor, int timeout_hz)
@@ -325,7 +325,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
  * @ca: CA instance.
  * @slot: Slot id.
  *
- * @return 0 on success, nonzero on failure.
+ * return: 0 on success, nonzero on failure.
  */
 static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 {
@@ -397,11 +397,11 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
  * @ca: CA instance.
  * @slot: Slot id.
  * @address: Address to read from. Updated.
- * @tupleType: Tuple id byte. Updated.
- * @tupleLength: Tuple length. Updated.
+ * @tuple_type: Tuple id byte. Updated.
+ * @tuple_length: Tuple length. Updated.
  * @tuple: Dest buffer for tuple (must be 256 bytes). Updated.
  *
- * @return 0 on success, nonzero on error.
+ * return: 0 on success, nonzero on error.
  */
 static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 				     int *address, int *tuple_type,
@@ -455,7 +455,7 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
  * @ca: CA instance.
  * @slot: Slot id.
  *
- * @return 0 on success, <0 on failure.
+ * return: 0 on success, <0 on failure.
  */
 static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 {
@@ -632,10 +632,11 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
  * @ca: CA instance.
  * @slot: Slot to read from.
  * @ebuf: If non-NULL, the data will be written to this buffer. If NULL,
- * the data will be added into the buffering system as a normal fragment.
+ *	  the data will be added into the buffering system as a normal
+ *	  fragment.
  * @ecount: Size of ebuf. Ignored if ebuf is NULL.
  *
- * @return Number of bytes read, or < 0 on error
+ * return: Number of bytes read, or < 0 on error
  */
 static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 				    u8 *ebuf, int ecount)
@@ -784,11 +785,11 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
  *
  * @ca: CA instance.
  * @slot: Slot to write to.
- * @ebuf: The data in this buffer is treated as a complete link-level packet to
- * be written.
- * @count: Size of ebuf.
+ * @buf: The data in this buffer is treated as a complete link-level packet to
+ * 	 be written.
+ * @bytes_write: Size of ebuf.
  *
- * @return Number of bytes written, or < 0 on error.
+ * return: Number of bytes written, or < 0 on error.
  */
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 				     u8 *buf, int bytes_write)
@@ -933,7 +934,7 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 /**
  * dvb_ca_en50221_camchange_irq - A CAMCHANGE IRQ has occurred.
  *
- * @ca: CA instance.
+ * @pubca: CA instance.
  * @slot: Slot concerned.
  * @change_type: One of the DVB_CA_CAMCHANGE_* values.
  */
@@ -963,7 +964,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 /**
  * dvb_ca_en50221_camready_irq - A CAMREADY IRQ has occurred.
  *
- * @ca: CA instance.
+ * @pubca: CA instance.
  * @slot: Slot concerned.
  */
 void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
@@ -983,7 +984,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
 /**
  * dvb_ca_en50221_frda_irq - An FR or DA IRQ has occurred.
  *
- * @ca: CA instance.
+ * @pubca: CA instance.
  * @slot: Slot concerned.
  */
 void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
@@ -1091,7 +1092,7 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
  *
  * @ca: CA instance.
  * @slot: Slot to process.
- * @return: 0 .. no change
+ * return:: 0 .. no change
  *          1 .. CAM state changed
  */
 
@@ -1296,7 +1297,7 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 	mutex_unlock(&sl->slot_lock);
 }
 
-/**
+/*
  * Kernel thread which monitors CA slots for CAM changes, and performs data
  * transfers.
  */
@@ -1336,12 +1337,11 @@ static int dvb_ca_en50221_thread(void *data)
  * Real ioctl implementation.
  * NOTE: CA_SEND_MSG/CA_GET_MSG ioctls have userspace buffers passed to them.
  *
- * @inode: Inode concerned.
  * @file: File concerned.
  * @cmd: IOCTL command.
- * @arg: Associated argument.
+ * @parg: Associated argument.
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 				      unsigned int cmd, void *parg)
@@ -1420,12 +1420,11 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 /**
  * Wrapper for ioctl implementation.
  *
- * @inode: Inode concerned.
  * @file: File concerned.
  * @cmd: IOCTL command.
  * @arg: Associated argument.
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 static long dvb_ca_en50221_io_ioctl(struct file *file,
 				    unsigned int cmd, unsigned long arg)
@@ -1441,7 +1440,7 @@ static long dvb_ca_en50221_io_ioctl(struct file *file,
  * @count: Size of source buffer.
  * @ppos: Position in file (ignored).
  *
- * @return Number of bytes read, or <0 on error.
+ * return: Number of bytes read, or <0 on error.
  */
 static ssize_t dvb_ca_en50221_io_write(struct file *file,
 				       const char __user *buf, size_t count,
@@ -1536,7 +1535,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 	return status;
 }
 
-/**
+/*
  * Condition for waking up in dvb_ca_en50221_io_read_condition
  */
 static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
@@ -1593,7 +1592,7 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
  * @count: Size of destination buffer.
  * @ppos: Position in file (ignored).
  *
- * @return Number of bytes read, or <0 on error.
+ * return: Number of bytes read, or <0 on error.
  */
 static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 				      size_t count, loff_t *ppos)
@@ -1702,7 +1701,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
  * @inode: Inode concerned.
  * @file: File concerned.
  *
- * @return 0 on success, <0 on failure.
+ * return: 0 on success, <0 on failure.
  */
 static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 {
@@ -1752,7 +1751,7 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
  * @inode: Inode concerned.
  * @file: File concerned.
  *
- * @return 0 on success, <0 on failure.
+ * return: 0 on success, <0 on failure.
  */
 static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 {
@@ -1781,7 +1780,7 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
  * @file: File concerned.
  * @wait: poll wait table.
  *
- * @return Standard poll mask.
+ * return: Standard poll mask.
  */
 static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 {
@@ -1838,11 +1837,11 @@ static const struct dvb_device dvbdev_ca = {
  * Initialise a new DVB CA EN50221 interface device.
  *
  * @dvb_adapter: DVB adapter to attach the new CA device to.
- * @ca: The dvb_ca instance.
+ * @pubca: The dvb_ca instance.
  * @flags: Flags describing the CA device (DVB_CA_FLAG_*).
  * @slot_count: Number of slots supported.
  *
- * @return 0 on success, nonzero on failure
+ * return: 0 on success, nonzero on failure
  */
 int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 			struct dvb_ca_en50221 *pubca, int flags, int slot_count)
@@ -1929,8 +1928,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_init);
 /**
  * Release a DVB CA EN50221 interface device.
  *
- * @ca_dev: The dvb_device_t instance for the CA device.
- * @ca: The associated dvb_ca instance.
+ * @pubca: The associated dvb_ca instance.
  */
 void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 {
-- 
2.14.3
