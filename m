Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58471 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936645AbdIZUOB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:01 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/20] media: lirc_zilog: fix variable types and other ugliness
Date: Tue, 26 Sep 2017 21:13:44 +0100
Message-Id: <89a45738f47751f597742c45578ea18f8584d765.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleans up code and makes checkpatch happy.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_zilog.c | 160 +++++++++++---------------------
 1 file changed, 55 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 757b3fc247ac..d3225bd1b3a6 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -32,32 +32,15 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
+#include <asm/unaligned.h>
 #include <linux/module.h>
-#include <linux/kmod.h>
-#include <linux/kernel.h>
-#include <linux/sched/signal.h>
-#include <linux/fs.h>
-#include <linux/poll.h>
-#include <linux/string.h>
-#include <linux/timer.h>
 #include <linux/delay.h>
-#include <linux/completion.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/firmware.h>
 #include <linux/vmalloc.h>
 
-#include <linux/mutex.h>
-#include <linux/kthread.h>
-
 #include <media/lirc_dev.h>
 #include <media/lirc.h>
 
@@ -70,7 +53,7 @@ struct IR_tx {
 	struct i2c_client *c;
 
 	/* TX additional actions needed */
-	int need_boot;
+	bool need_boot;
 	bool post_tx_ready_poll;
 	struct lirc_dev *l;
 };
@@ -81,45 +64,39 @@ struct IR_tx {
 /* Hauppauge IR transmitter data */
 struct tx_data_struct {
 	/* Boot block */
-	unsigned char *boot_data;
+	u8 *boot_data;
 
 	/* Start of binary data block */
-	unsigned char *datap;
+	u8 *datap;
 
 	/* End of binary data block */
-	unsigned char *endp;
+	u8 *endp;
 
 	/* Number of installed codesets */
-	unsigned int num_code_sets;
+	u32 num_code_sets;
 
 	/* Pointers to codesets */
-	unsigned char **code_sets;
+	u8 **code_sets;
 
 	/* Global fixed data template */
 	int fixed[TX_BLOCK_SIZE];
 };
 
 static struct tx_data_struct *tx_data;
-static struct mutex tx_data_lock;
-
-/* module parameters */
-static bool debug;	/* debug output */
+static DEFINE_MUTEX(tx_data_lock);
 
 /* safe read of a uint32 (always network byte order) */
-static int read_uint32(unsigned char **data,
-		       unsigned char *endp, unsigned int *val)
+static int read_u32(u8 **data, u8 *endp, u32 *val)
 {
 	if (*data + 4 > endp)
 		return 0;
-	*val = ((*data)[0] << 24) | ((*data)[1] << 16) |
-	       ((*data)[2] << 8) | (*data)[3];
+	*val = get_unaligned_be32(data);
 	*data += 4;
 	return 1;
 }
 
 /* safe read of a uint8 */
-static int read_uint8(unsigned char **data,
-		      unsigned char *endp, unsigned char *val)
+static int read_u8(u8 **data, u8 *endp, u8 *val)
 {
 	if (*data + 1 > endp)
 		return 0;
@@ -128,8 +105,8 @@ static int read_uint8(unsigned char **data,
 }
 
 /* safe skipping of N bytes */
-static int skip(unsigned char **data,
-		unsigned char *endp, unsigned int distance)
+static int skip(u8 **data,
+		u8 *endp, unsigned int distance)
 {
 	if (*data + distance > endp)
 		return 0;
@@ -138,11 +115,11 @@ static int skip(unsigned char **data,
 }
 
 /* decompress key data into the given buffer */
-static int get_key_data(unsigned char *buf,
+static int get_key_data(u8 *buf,
 			unsigned int codeset, unsigned int key)
 {
-	unsigned char *data, *endp, *diffs, *key_block;
-	unsigned char keys, ndiffs, id;
+	u8 *data, *endp, *diffs, *key_block;
+	u8 keys, ndiffs, id;
 	unsigned int base, lim, pos, i;
 
 	/* Binary search for the codeset */
@@ -150,7 +127,7 @@ static int get_key_data(unsigned char *buf,
 		pos = base + (lim >> 1);
 		data = tx_data->code_sets[pos];
 
-		if (!read_uint32(&data, tx_data->endp, &i))
+		if (!read_u32(&data, tx_data->endp, &i))
 			goto corrupt;
 
 		if (i == codeset) {
@@ -169,8 +146,8 @@ static int get_key_data(unsigned char *buf,
 		tx_data->code_sets[pos + 1] : tx_data->endp;
 
 	/* Read the block header */
-	if (!read_uint8(&data, endp, &keys) ||
-	    !read_uint8(&data, endp, &ndiffs) ||
+	if (!read_u8(&data, endp, &keys) ||
+	    !read_u8(&data, endp, &ndiffs) ||
 	    ndiffs > TX_BLOCK_SIZE || keys == 0)
 		goto corrupt;
 
@@ -180,16 +157,16 @@ static int get_key_data(unsigned char *buf,
 		goto corrupt;
 
 	/* Read the id of the first key */
-	if (!read_uint8(&data, endp, &id))
+	if (!read_u8(&data, endp, &id))
 		goto corrupt;
 
 	/* Unpack the first key's data */
 	for (i = 0; i < TX_BLOCK_SIZE; ++i) {
 		if (tx_data->fixed[i] == -1) {
-			if (!read_uint8(&data, endp, &buf[i]))
+			if (!read_u8(&data, endp, &buf[i]))
 				goto corrupt;
 		} else {
-			buf[i] = (unsigned char)tx_data->fixed[i];
+			buf[i] = tx_data->fixed[i];
 		}
 	}
 
@@ -207,7 +184,7 @@ static int get_key_data(unsigned char *buf,
 	/* Binary search for the key */
 	for (base = 0, lim = keys - 1; lim; lim >>= 1) {
 		/* Seek to block */
-		unsigned char *key_data;
+		u8 *key_data;
 
 		pos = base + (lim >> 1);
 		key_data = key_block + (ndiffs + 1) * pos;
@@ -218,9 +195,9 @@ static int get_key_data(unsigned char *buf,
 
 			/* found, so unpack the diffs */
 			for (i = 0; i < ndiffs; ++i) {
-				unsigned char val;
+				u8 val;
 
-				if (!read_uint8(&key_data, endp, &val) ||
+				if (!read_u8(&key_data, endp, &val) ||
 				    diffs[i] >= TX_BLOCK_SIZE)
 					goto corrupt;
 				buf[diffs[i]] = val;
@@ -241,17 +218,17 @@ static int get_key_data(unsigned char *buf,
 }
 
 /* send a block of data to the IR TX device */
-static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
+static int send_data_block(struct IR_tx *tx, u8 *data_block)
 {
 	int i, j, ret;
-	unsigned char buf[5];
+	u8 buf[5];
 
 	for (i = 0; i < TX_BLOCK_SIZE;) {
 		int tosend = TX_BLOCK_SIZE - i;
 
 		if (tosend > 4)
 			tosend = 4;
-		buf[0] = (unsigned char)(i + 1);
+		buf[0] = i + 1;
 		for (j = 0; j < tosend; ++j)
 			buf[1 + j] = data_block[i + j];
 		dev_dbg(&tx->l->dev, "%*ph", 5, buf);
@@ -270,7 +247,7 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
 static int send_boot_data(struct IR_tx *tx)
 {
 	int ret, i;
-	unsigned char buf[4];
+	u8 buf[4];
 
 	/* send the boot block */
 	ret = send_data_block(tx, tx_data->boot_data);
@@ -295,7 +272,7 @@ static int send_boot_data(struct IR_tx *tx)
 		ret = i2c_master_send(tx->c, buf, 1);
 		if (ret == 1)
 			break;
-		udelay(100);
+		usleep_range(100, 110);
 	}
 
 	if (ret != 1) {
@@ -348,7 +325,7 @@ static int fw_load(struct IR_tx *tx)
 {
 	int ret;
 	unsigned int i;
-	unsigned char *data, version, num_global_fixed;
+	u8 *data, version, num_global_fixed;
 	const struct firmware *fw_entry;
 
 	/* Already loaded? */
@@ -392,7 +369,7 @@ static int fw_load(struct IR_tx *tx)
 
 	/* Check version */
 	data = tx_data->datap;
-	if (!read_uint8(&data, tx_data->endp, &version))
+	if (!read_u8(&data, tx_data->endp, &version))
 		goto corrupt;
 	if (version != 1) {
 		dev_err(&tx->l->dev,
@@ -408,8 +385,8 @@ static int fw_load(struct IR_tx *tx)
 	if (!skip(&data, tx_data->endp, TX_BLOCK_SIZE))
 		goto corrupt;
 
-	if (!read_uint32(&data, tx_data->endp,
-			 &tx_data->num_code_sets))
+	if (!read_u32(&data, tx_data->endp,
+		      &tx_data->num_code_sets))
 		goto corrupt;
 
 	dev_dbg(&tx->l->dev, "%u IR blaster codesets loaded\n",
@@ -427,14 +404,14 @@ static int fw_load(struct IR_tx *tx)
 		tx_data->fixed[i] = -1;
 
 	/* Read global fixed data template */
-	if (!read_uint8(&data, tx_data->endp, &num_global_fixed) ||
+	if (!read_u8(&data, tx_data->endp, &num_global_fixed) ||
 	    num_global_fixed > TX_BLOCK_SIZE)
 		goto corrupt;
 	for (i = 0; i < num_global_fixed; ++i) {
-		unsigned char pos, val;
+		u8 pos, val;
 
-		if (!read_uint8(&data, tx_data->endp, &pos) ||
-		    !read_uint8(&data, tx_data->endp, &val) ||
+		if (!read_u8(&data, tx_data->endp, &pos) ||
+		    !read_u8(&data, tx_data->endp, &val) ||
 		    pos >= TX_BLOCK_SIZE)
 			goto corrupt;
 		tx_data->fixed[pos] = (int)val;
@@ -442,17 +419,17 @@ static int fw_load(struct IR_tx *tx)
 
 	/* Filch out the position of each code set */
 	for (i = 0; i < tx_data->num_code_sets; ++i) {
-		unsigned int id;
-		unsigned char keys;
-		unsigned char ndiffs;
+		u32 id;
+		u8 keys;
+		u8 ndiffs;
 
 		/* Save the codeset position */
 		tx_data->code_sets[i] = data;
 
 		/* Read header */
-		if (!read_uint32(&data, tx_data->endp, &id) ||
-		    !read_uint8(&data, tx_data->endp, &keys) ||
-		    !read_uint8(&data, tx_data->endp, &ndiffs) ||
+		if (!read_u32(&data, tx_data->endp, &id) ||
+		    !read_u8(&data, tx_data->endp, &keys) ||
+		    !read_u8(&data, tx_data->endp, &ndiffs) ||
 		    ndiffs > TX_BLOCK_SIZE || keys == 0)
 			goto corrupt;
 
@@ -489,8 +466,8 @@ static int fw_load(struct IR_tx *tx)
 /* send a keypress to the IR TX device */
 static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 {
-	unsigned char data_block[TX_BLOCK_SIZE];
-	unsigned char buf[2];
+	u8 data_block[TX_BLOCK_SIZE];
+	u8 buf[2];
 	int i, ret;
 
 	/* Get data for the codeset/key */
@@ -524,7 +501,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 		ret = i2c_master_send(tx->c, buf, 1);
 		if (ret == 1)
 			break;
-		udelay(100);
+		usleep_range(100, 110);
 	}
 
 	if (ret != 1) {
@@ -638,7 +615,7 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 		}
 
 		/* Send boot data first if required */
-		if (tx->need_boot == 1) {
+		if (tx->need_boot) {
 			/* Make sure we have the 'firmware' loaded, first */
 			ret = fw_load(tx);
 			if (ret != 0) {
@@ -650,13 +627,13 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 			/* Prep the chip for transmitting codes */
 			ret = send_boot_data(tx);
 			if (ret == 0)
-				tx->need_boot = 0;
+				tx->need_boot = false;
 		}
 
 		/* Send the code */
 		if (ret == 0) {
 			ret = send_code(tx, (unsigned int)command >> 16,
-					    (unsigned int)command & 0xFFFF);
+					(unsigned int)command & 0xFFFF);
 			if (ret == -EPROTO) {
 				mutex_unlock(&tx->client_lock);
 				return ret;
@@ -680,7 +657,7 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 			}
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout((100 * HZ + 999) / 1000);
-			tx->need_boot = 1;
+			tx->need_boot = true;
 			++failures;
 		} else {
 			i += sizeof(int);
@@ -693,7 +670,6 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 	return n;
 }
 
-
 static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct IR_tx *tx = lirc_get_pdata(filep);
@@ -773,7 +749,7 @@ static const struct i2c_device_id ir_transceiver_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ir_transceiver_id);
 
-static struct i2c_driver driver = {
+static struct i2c_driver zilog_driver = {
 	.driver = {
 		.name	= "Zilog/Hauppauge i2c IR",
 	},
@@ -806,17 +782,13 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * The IR receiver    is at i2c address 0x71.
 	 * The IR transmitter is at i2c address 0x70.
 	 */
-
-	pr_info("probing IR Tx on %s (i2c-%d)\n", adap->name, adap->nr);
-
-	/* Set up a struct IR_tx instance */
 	tx = devm_kzalloc(&client->dev, sizeof(*tx), GFP_KERNEL);
 	if (!tx)
 		return -ENOMEM;
 
 	mutex_init(&tx->client_lock);
 	tx->c = client;
-	tx->need_boot = 1;
+	tx->need_boot = true;
 	tx->post_tx_ready_poll = !(id->driver_data & ID_FLAG_HDPVR);
 
 	/* set lirc_dev stuff */
@@ -855,40 +827,21 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* A tx ref goes to the i2c_client */
 	i2c_set_clientdata(client, tx);
 
-	dev_info(&tx->l->dev,
-		 "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
-		 adap->name, adap->nr, tx->l->minor);
-
-	dev_info(&tx->l->dev,
-		 "probe of IR Tx on %s (i2c-%d) done\n", adap->name, adap->nr);
 	return 0;
 }
 
 static int __init zilog_init(void)
 {
-	int ret;
-
-	pr_notice("Zilog/Hauppauge IR driver initializing\n");
-
-	mutex_init(&tx_data_lock);
-
 	request_module("firmware_class");
 
-	ret = i2c_add_driver(&driver);
-	if (ret)
-		pr_err("initialization failed\n");
-	else
-		pr_notice("initialization complete\n");
-
-	return ret;
+	return i2c_add_driver(&zilog_driver);
 }
 
 static void __exit zilog_exit(void)
 {
-	i2c_del_driver(&driver);
+	i2c_del_driver(&zilog_driver);
 	/* if loaded */
 	fw_unload();
-	pr_notice("Zilog/Hauppauge IR driver unloaded\n");
 }
 
 module_init(zilog_init);
@@ -899,6 +852,3 @@ MODULE_AUTHOR("Gerd Knorr, Michal Kochanowicz, Christoph Bartelmus, Ulrich Muell
 MODULE_LICENSE("GPL");
 /* for compat with old name, which isn't all that accurate anymore */
 MODULE_ALIAS("lirc_pvr150");
-
-module_param(debug, bool, 0644);
-MODULE_PARM_DESC(debug, "Enable debugging messages");
-- 
2.13.5
