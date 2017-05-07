Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754064AbdEGWEc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:32 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 05/11] [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 1
Date: Sun,  7 May 2017 23:23:28 +0200
Message-Id: <1494192214-20082-6-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index cc1d1d1..48b652b 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -193,8 +193,10 @@ static void dvb_ca_private_put(struct dvb_ca_private *ca)
 }
 
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca);
-static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
-static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
+static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
+				    u8 *ebuf, int ecount);
+static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
+				     u8 *ebuf, int ecount);
 
 
 /**
@@ -206,7 +208,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * e
  * @nlen: Number of bytes in needle.
  * @return Pointer into haystack needle was found at, or NULL if not found.
  */
-static char *findstr(char * haystack, int hlen, char * needle, int nlen)
+static char *findstr(char *haystack, int hlen, char *needle, int nlen)
 {
 	int i;
 
@@ -392,7 +394,8 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
  * @return 0 on success, nonzero on error.
  */
 static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
-				     int *address, int *tupleType, int *tupleLength, u8 * tuple)
+				     int *address, int *tupleType,
+				     int *tupleLength, u8 *tuple)
 {
 	int i;
 	int _tupleType;
@@ -626,7 +629,8 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
  *
  * @return Number of bytes read, or < 0 on error
  */
-static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount)
+static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
+				    u8 *ebuf, int ecount)
 {
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int bytes_read;
@@ -763,7 +767,8 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
  *
  * @return Number of bytes written, or < 0 on error.
  */
-static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * buf, int bytes_write)
+static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
+				     u8 *buf, int bytes_write)
 {
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int status;
@@ -1391,7 +1396,8 @@ static long dvb_ca_en50221_io_ioctl(struct file *file,
  * @return Number of bytes read, or <0 on error.
  */
 static ssize_t dvb_ca_en50221_io_write(struct file *file,
-				       const char __user * buf, size_t count, loff_t * ppos)
+				       const char __user *buf, size_t count,
+				       loff_t *ppos)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
@@ -1535,8 +1541,8 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
  *
  * @return Number of bytes read, or <0 on error.
  */
-static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
-				      size_t count, loff_t * ppos)
+static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
@@ -1717,7 +1723,7 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
  *
  * @return Standard poll mask.
  */
-static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table * wait)
+static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
-- 
2.7.4
