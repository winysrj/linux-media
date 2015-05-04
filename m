Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23721 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbEDReX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 13:34:23 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH v6 06/11] cec: add HDMI CEC framework
Date: Mon, 04 May 2015 19:32:59 +0200
Message-id: <1430760785-1169-7-git-send-email-k.debski@samsung.com>
In-reply-to: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The added HDMI CEC framework provides a generic kernel interface for
HDMI CEC devices.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
[k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
[k.debski@samsung.com: change kthread handling when setting logical
address]
[k.debski@samsung.com: code cleanup and fixes]
[k.debski@samsung.com: add missing CEC commands to match spec]
[k.debski@samsung.com: add RC framework support]
[k.debski@samsung.com: move and edit documentation]
[k.debski@samsung.com: add vendor id reporting]
[k.debski@samsung.com: add possibility to clear assigned logical
addresses]
[k.debski@samsung.com: documentation fixes, clenaup and expansion]
[k.debski@samsung.com: reorder of API structs and add reserved fields]
[k.debski@samsung.com: fix handling of events and fix 32/64bit timespec
problem]
[k.debski@samsung.com: add cec.h to include/uapi/linux/Kbuild]
[k.debski@samsung.com: add sequence number handling]
[k.debski@samsung.com: add passthrough mode]
[k.debski@samsung.com: fix CEC defines, add missing CEC 2.0 commands]
[k.debski@samsung.com: add DocBook documentation by Hans Verkuil, with
minor additions]
Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 Documentation/cec.txt     |  165 +++++++
 drivers/media/Kconfig     |    6 +
 drivers/media/Makefile    |    2 +
 drivers/media/cec.c       | 1191 +++++++++++++++++++++++++++++++++++++++++++++
 include/media/cec.h       |  142 ++++++
 include/uapi/linux/Kbuild |    1 +
 include/uapi/linux/cec.h  |  332 +++++++++++++
 7 files changed, 1839 insertions(+)
 create mode 100644 Documentation/cec.txt
 create mode 100644 drivers/media/cec.c
 create mode 100644 include/media/cec.h
 create mode 100644 include/uapi/linux/cec.h

diff --git a/Documentation/cec.txt b/Documentation/cec.txt
new file mode 100644
index 0000000..a52017c2
--- /dev/null
+++ b/Documentation/cec.txt
@@ -0,0 +1,165 @@
+CEC Kernel Support
+==================
+
+The CEC framework provides a unified kernel interface for use with HDMI CEC
+hardware. It is designed to handle a multiple variants of hardware. Adding to
+the flexibility of the framework it enables to set which parts of the CEC
+protocol processing is handled by the hardware, by the driver and by the
+userspace application.
+
+
+The CEC Protocol
+----------------
+
+The CEC protocol enables consumer electronic devices to communicate with each
+other through the HDMI connection. The protocol uses logical addresses in the
+communication. The logical address is strictly connected with the functionality
+provided by the device. The TV acting as the communication hub is always
+assigned address 0. The physical address is determined by the physical
+connection between devices.
+
+The protocol enables control of compatible devices with a single remote.
+Synchronous power on/standby, instant playback with changing the content source
+on the TV.
+
+The Kernel Interface
+====================
+
+CEC Adapter
+-----------
+
+#define CEC_LOG_ADDR_INVALID 0xff
+
+/* The maximum number of logical addresses one device can be assigned to.
+ * The CEC 2.0 spec allows for only 2 logical addresses at the moment. The
+ * Analog Devices CEC hardware supports 3. So let's go wild and go for 4. */
+#define CEC_MAX_LOG_ADDRS 4
+
+/* The "Primary Device Type" */
+#define CEC_PRIM_DEVTYPE_TV		0
+#define CEC_PRIM_DEVTYPE_RECORD		1
+#define CEC_PRIM_DEVTYPE_TUNER		3
+#define CEC_PRIM_DEVTYPE_PLAYBACK	4
+#define CEC_PRIM_DEVTYPE_AUDIOSYSTEM	5
+#define CEC_PRIM_DEVTYPE_SWITCH		6
+#define CEC_PRIM_DEVTYPE_VIDEOPROC	7
+
+/* The "All Device Types" flags (CEC 2.0) */
+#define CEC_FL_ALL_DEVTYPE_TV		(1 << 7)
+#define CEC_FL_ALL_DEVTYPE_RECORD	(1 << 6)
+#define CEC_FL_ALL_DEVTYPE_TUNER	(1 << 5)
+#define CEC_FL_ALL_DEVTYPE_PLAYBACK	(1 << 4)
+#define CEC_FL_ALL_DEVTYPE_AUDIOSYSTEM	(1 << 3)
+#define CEC_FL_ALL_DEVTYPE_SWITCH	(1 << 2)
+/* And if you wondering what happened to VIDEOPROC devices: those should
+ * be mapped to a SWITCH. */
+
+/* The logical address types that the CEC device wants to claim */
+#define CEC_LOG_ADDR_TYPE_TV		0
+#define CEC_LOG_ADDR_TYPE_RECORD	1
+#define CEC_LOG_ADDR_TYPE_TUNER		2
+#define CEC_LOG_ADDR_TYPE_PLAYBACK	3
+#define CEC_LOG_ADDR_TYPE_AUDIOSYSTEM	4
+#define CEC_LOG_ADDR_TYPE_SPECIFIC	5
+#define CEC_LOG_ADDR_TYPE_UNREGISTERED	6
+/* Switches should use UNREGISTERED.
+ * Video processors should use SPECIFIC. */
+
+/* The CEC version */
+#define CEC_VERSION_1_4B		5
+#define CEC_VERSION_2_0			6
+
+struct cec_adapter {
+	/* internal fields removed */
+
+	u16 phys_addr;
+	u32 capabilities;
+	u8 version;
+	u8 num_log_addrs;
+	u8 prim_device[CEC_MAX_LOG_ADDRS];
+	u8 log_addr_type[CEC_MAX_LOG_ADDRS];
+	u8 log_addr[CEC_MAX_LOG_ADDRS];
+
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+	int (*adap_transmit)(struct cec_adapter *adap, struct cec_msg *msg);
+	void (*adap_transmit_timed_out)(struct cec_adapter *adap);
+
+	void (*claimed_log_addr)(struct cec_adapter *adap, u8 idx);
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+};
+
+int cec_create_adapter(struct cec_adapter *adap, u32 caps);
+void cec_delete_adapter(struct cec_adapter *adap);
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_data *data, bool block);
+
+/* Called by the adapter */
+void cec_transmit_done(struct cec_adapter *adap, u32 status);
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+
+int cec_receive_msg(struct cec_adapter *adap, struct cec_msg *msg, bool block);
+int cec_claim_log_addrs(struct cec_adapter *adap, struct cec_log_addrs *log_addrs, bool block);
+
+The device type defines are defined by the CEC standard.
+
+The cec_adapter structure represents the adapter. It has a number of
+operations that have to be implemented in the driver: adap_enable() enables
+or disables the physical adapter, adap_log_addr() tells the driver which
+logical address should be configured. This may be called multiple times
+to configure multiple logical addresses. Calling adap_enable(false) or
+adap_log_addr(CEC_LOG_ADDR_INVALID) will clear all configured logical
+addresses.
+
+The adap_transmit op will setup the hardware to send out the given CEC message.
+This will return without waiting for the transmission to finish. The
+adap_transmit_timed_out() function is called when the current transmission timed
+out and the hardware needs to be informed of this (the hardware should go back
+from transmitter to receiver mode).
+
+The adapter driver will also call into the adapter: it should call
+cec_transmit_done() when a cec transfer was finalized and cec_received_msg()
+when a new message was received.
+
+When a message is received the received() op is called.
+
+The driver has to call cec_create_adapter to initialize the structure. If
+the 'caps' argument is non-zero, then it will also create a /dev/cecX
+device node to allow userspace to interact with the CEC device. Userspace
+can request those capabilities with the CEC_G_CAPS ioctl.
+
+In order for a CEC adapter to be configured it needs a physical address.
+This is normally assigned by the driver. It is either 0.0.0.0 for a TV (aka
+video receiver) or it is derived from the EDID that the source received
+from the sink. This is normally set by the driver before enabling the CEC
+adapter, or it is set from userspace in the case of CEC USB dongles (although
+embedded systems might also want to set this manually).
+
+After enabling the CEC adapter it has to be configured.
+
+The userspace has to inform the CEC adapter of which type of device it requests
+the adapter to identify itself. After this information is set by userspace, the
+CEC framework will attempt to to find and claim a logical addresses matching the
+requested device type. If none are found, then it will fall back to logical
+address Unregistered (15). To clear the logical addresses list from the list the
+userspace application should set the num_log_addrs field of struct cec_log_addr
+to 0.
+
+The type of device is set from the userspace with the CEC_S_ADAP_LOG_ADDRS. In
+addition, claiming logical addresses can be initiated from the kernel side by
+calling the cec_claim_log_addrs function.
+
+Before the addresses are claimed it is possible to send and receive messages.
+Sending all messages is possible as it is up to the userspace to the source
+and destination addresses in the message payload. However, only broadcast
+messages can be received until a regular logical address is claimed.
+
+When a CEC message is received the CEC framework will take care of the CEC
+core messages CEC_OP_GET_CEC_VERSION, CEC_OP_GIVE_PHYS_ADDR and CEC_OP_ABORT.
+Then it will call the received() op (if set), and finally it will queue it
+for handling by userspace if create_devnode was true, or send back
+FEATURE_ABORT if create_devnode was false.
+
+Drivers can also use the cec_transmit_msg() call to transmit a message. This
+can either be fire-and-forget (the CEC framework will queue up messages in a
+transmit queue), or a blocking wait until there is either an error or a
+reply to the message.
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3ef0f90..262e9ad 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -15,6 +15,12 @@ if MEDIA_SUPPORT
 
 comment "Multimedia core support"
 
+config CEC
+	tristate "CEC API (EXPERIMENTAL)"
+	select RC_CORE
+	---help---
+	  Enable the CEC API.
+
 #
 # Multimedia support - automatically enable V4L2 and DVB core
 #
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index e608bbc..db66014 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+obj-$(CONFIG_CEC) += cec.o
+
 media-objs	:= media-device.o media-devnode.o media-entity.o
 
 #
diff --git a/drivers/media/cec.c b/drivers/media/cec.c
new file mode 100644
index 0000000..52d936a
--- /dev/null
+++ b/drivers/media/cec.c
@@ -0,0 +1,1191 @@
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kmod.h>
+#include <linux/ktime.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <media/cec.h>
+
+#define CEC_NUM_DEVICES	256
+#define CEC_NAME	"cec"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-1)");
+
+struct cec_transmit_notifier {
+	struct completion c;
+	struct cec_data *data;
+};
+
+#define dprintk(fmt, arg...)						\
+	do {								\
+		if (debug)						\
+			pr_info("cec-%s: " fmt, adap->name, ## arg);	\
+	} while (0)
+
+static dev_t cec_dev_t;
+
+/* Active devices */
+static DEFINE_MUTEX(cec_devnode_lock);
+static DECLARE_BITMAP(cec_devnode_nums, CEC_NUM_DEVICES);
+
+/* dev to cec_devnode */
+#define to_cec_devnode(cd) container_of(cd, struct cec_devnode, dev)
+
+static inline struct cec_devnode *cec_devnode_data(struct file *filp)
+{
+	return filp->private_data;
+}
+
+static int cec_log_addr2idx(const struct cec_adapter *adap, u8 log_addr)
+{
+	int i;
+
+	for (i = 0; i < adap->num_log_addrs; i++)
+		if (adap->log_addr[i] == log_addr)
+			return i;
+	return -1;
+}
+
+static unsigned cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr)
+{
+	int i = cec_log_addr2idx(adap, log_addr);
+
+	return adap->prim_device[i < 0 ? 0 : i];
+}
+
+/* Called when the last user of the cec device exits. */
+static void cec_devnode_release(struct device *cd)
+{
+	struct cec_devnode *cecdev = to_cec_devnode(cd);
+
+	mutex_lock(&cec_devnode_lock);
+
+	/* Delete the cdev on this minor as well */
+	cdev_del(&cecdev->cdev);
+
+	/* Mark device node number as free */
+	clear_bit(cecdev->minor, cec_devnode_nums);
+
+	mutex_unlock(&cec_devnode_lock);
+
+	/* Release cec_devnode and perform other cleanups as needed. */
+	if (cecdev->release)
+		cecdev->release(cecdev);
+}
+
+static struct bus_type cec_bus_type = {
+	.name = CEC_NAME,
+};
+
+static bool cec_sleep(struct cec_adapter *adap, int timeout)
+{
+	bool timed_out = false;
+
+	DECLARE_WAITQUEUE(wait, current);
+
+	add_wait_queue(&adap->kthread_waitq, &wait);
+	if (!kthread_should_stop()) {
+		if (timeout < 0) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+		} else {
+			timed_out = !schedule_timeout_interruptible
+				(msecs_to_jiffies(timeout));
+		}
+	}
+
+	remove_wait_queue(&adap->kthread_waitq, &wait);
+	return timed_out;
+}
+
+/*
+ * Main CEC state machine
+ *
+ * In the IDLE state the CEC adapter is ready to receive or transmit messages.
+ * If it is woken up it will check if a new message is queued, and if so it
+ * will be transmitted and the state will go to TRANSMITTING.
+ *
+ * When the transmit is marked as done the state machine will check if it
+ * should wait for a reply. If not, it will call the notifier and go back
+ * to the IDLE state. Else it will switch to the WAIT state and wait for a
+ * reply. When the reply arrives it will call the notifier and go back
+ * to IDLE state.
+ *
+ * For the transmit and the wait-for-reply states a timeout is used of
+ * 1 second as per the standard.
+ */
+static int cec_thread_func(void *data)
+{
+	struct cec_adapter *adap = data;
+	int timeout = -1;
+
+	for (;;) {
+		bool timed_out = cec_sleep(adap, timeout);
+
+		if (kthread_should_stop())
+			break;
+		timeout = -1;
+		mutex_lock(&adap->lock);
+		dprintk("state %d timedout: %d tx: %d@%d\n", adap->state,
+			timed_out, adap->tx_qcount, adap->tx_qstart);
+		if (adap->state == CEC_ADAP_STATE_TRANSMITTING && timed_out)
+			adap->adap_transmit_timed_out(adap);
+
+		if (adap->state == CEC_ADAP_STATE_WAIT ||
+		    adap->state == CEC_ADAP_STATE_TRANSMITTING) {
+			struct cec_data *data = adap->tx_queue +
+						adap->tx_qstart;
+
+			if (adap->state == CEC_ADAP_STATE_TRANSMITTING &&
+			    data->msg.reply && !timed_out &&
+			    data->msg.status == CEC_TX_STATUS_OK) {
+				adap->state = CEC_ADAP_STATE_WAIT;
+				timeout = 1000;
+			} else {
+				if (timed_out) {
+					data->msg.reply = 0;
+					if (adap->state ==
+					    CEC_ADAP_STATE_TRANSMITTING)
+						data->msg.status =
+						    CEC_TX_STATUS_RETRY_TIMEOUT;
+					else
+						data->msg.status =
+						    CEC_TX_STATUS_REPLY_TIMEOUT;
+				}
+				adap->state = CEC_ADAP_STATE_IDLE;
+				if (data->func) {
+					mutex_unlock(&adap->lock);
+					data->func(adap, data, data->priv);
+					mutex_lock(&adap->lock);
+				}
+				adap->tx_qstart = (adap->tx_qstart + 1) %
+						  CEC_TX_QUEUE_SZ;
+				adap->tx_qcount--;
+				wake_up_interruptible(&adap->waitq);
+			}
+		}
+		if (adap->state == CEC_ADAP_STATE_IDLE && adap->tx_qcount) {
+			adap->state = CEC_ADAP_STATE_TRANSMITTING;
+			timeout = adap->tx_queue[adap->tx_qstart].msg.len == 1 ?
+				  200 : 1000;
+			adap->adap_transmit(adap,
+					  &adap->tx_queue[adap->tx_qstart].msg);
+			mutex_unlock(&adap->lock);
+			continue;
+		}
+		mutex_unlock(&adap->lock);
+	}
+	return 0;
+}
+
+static int cec_transmit_notify(struct cec_adapter *adap, struct cec_data *data,
+		void *priv)
+{
+	struct cec_transmit_notifier *n = priv;
+
+	*(n->data) = *data;
+	complete(&n->c);
+	return 0;
+}
+
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_data *data,
+		     bool block)
+{
+	struct cec_transmit_notifier notifier;
+	struct cec_msg *msg = &data->msg;
+	int res = 0;
+	unsigned idx;
+
+	if (msg->len == 0 || msg->len > 16)
+		return -EINVAL;
+	if (msg->reply && (msg->len == 1 || cec_msg_is_broadcast(msg)))
+		return -EINVAL;
+	if (msg->len > 1 && !cec_msg_is_broadcast(msg) &&
+	    cec_msg_initiator(msg) == cec_msg_destination(msg))
+		return -EINVAL;
+	if (cec_msg_initiator(msg) != 0xf &&
+	    cec_log_addr2idx(adap, cec_msg_initiator(msg)) < 0)
+		return -EINVAL;
+
+	if (msg->len == 1)
+		dprintk("cec_transmit_msg: 0x%02x%s\n",
+				msg->msg[0], !block ? " nb" : "");
+	else if (msg->reply)
+		dprintk("cec_transmit_msg: 0x%02x 0x%02x (wait for 0x%02x)%s\n",
+				msg->msg[0], msg->msg[1],
+				msg->reply, !block ? " nb" : "");
+	else
+		dprintk("cec_transmit_msg: 0x%02x 0x%02x%s\n",
+				msg->msg[0], msg->msg[1],
+				!block ? " nb" : "");
+
+	msg->status = 0;
+	msg->ts = 0;
+	if (msg->reply)
+		msg->timeout = 1000;
+	if (block) {
+		init_completion(&notifier.c);
+		notifier.data = data;
+		data->func = cec_transmit_notify;
+		data->priv = &notifier;
+	} else {
+		data->func = NULL;
+		data->priv = NULL;
+	}
+	mutex_lock(&adap->lock);
+	idx = (adap->tx_qstart + adap->tx_qcount) % CEC_TX_QUEUE_SZ;
+	if (adap->tx_qcount == CEC_TX_QUEUE_SZ) {
+		res = -EBUSY;
+	} else {
+		adap->tx_queue[idx] = *data;
+		adap->tx_qcount++;
+		if (adap->state == CEC_ADAP_STATE_IDLE)
+			wake_up_interruptible(&adap->kthread_waitq);
+	}
+	msg->sequence = adap->sequence++;
+	data->blocking = block;
+	mutex_unlock(&adap->lock);
+	if (res || !block)
+		return res;
+	wait_for_completion_interruptible(&notifier.c);
+	return res;
+}
+EXPORT_SYMBOL_GPL(cec_transmit_msg);
+
+void cec_transmit_done(struct cec_adapter *adap, u32 status)
+{
+	struct cec_msg *msg;
+
+	dprintk("cec_transmit_done\n");
+	mutex_lock(&adap->lock);
+	if (adap->state == CEC_ADAP_STATE_TRANSMITTING) {
+		msg = &adap->tx_queue[adap->tx_qstart].msg;
+		msg->status = status;
+		if (status)
+			msg->reply = 0;
+		msg->ts = ktime_get_ns();
+		wake_up_interruptible(&adap->kthread_waitq);
+	}
+	mutex_unlock(&adap->lock);
+}
+EXPORT_SYMBOL_GPL(cec_transmit_done);
+
+static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	bool is_broadcast = cec_msg_is_broadcast(msg);
+	u8 dest_laddr = cec_msg_destination(msg);
+	u8 devtype = cec_log_addr2dev(adap, dest_laddr);
+	bool is_directed = cec_log_addr2idx(adap, dest_laddr) >= 0;
+	struct cec_data tx_data;
+	int res = 0;
+	unsigned idx;
+
+	if (msg->len <= 1)
+		return 0;
+	if (!is_directed && !is_broadcast && !adap->passthrough)
+		return 0;	/* Not for us */
+
+	tx_data.msg.msg[0] = (msg->msg[0] << 4) | (msg->msg[0] >> 4);
+	tx_data.msg.reply = 0;
+
+	if (adap->received) {
+		res = adap->received(adap, msg);
+		if (res != -ENOMSG)
+			return 0;
+		res = 0;
+	}
+
+	if (adap->passthrough)
+		goto skip_processing;
+
+	switch (msg->msg[1]) {
+	case CEC_OP_GET_CEC_VERSION:
+		if (is_broadcast)
+			return 0;
+		tx_data.msg.len = 3;
+		tx_data.msg.msg[1] = CEC_OP_CEC_VERSION;
+		tx_data.msg.msg[2] = adap->version;
+		return cec_transmit_msg(adap, &tx_data, false);
+
+	case CEC_OP_GIVE_PHYSICAL_ADDR:
+		if (!is_directed)
+			return 0;
+		/* Do nothing for CEC switches using addr 15 */
+		if (devtype == CEC_PRIM_DEVTYPE_SWITCH && dest_laddr == 15)
+			return 0;
+		tx_data.msg.len = 5;
+		tx_data.msg.msg[1] = CEC_OP_REPORT_PHYSICAL_ADDR;
+		tx_data.msg.msg[2] = adap->phys_addr >> 8;
+		tx_data.msg.msg[3] = adap->phys_addr & 0xff;
+		tx_data.msg.msg[4] = devtype;
+		return cec_transmit_msg(adap, &tx_data, false);
+
+	case CEC_OP_ABORT:
+		/* Do nothing for CEC switches */
+		if (devtype == CEC_PRIM_DEVTYPE_SWITCH)
+			return 0;
+		tx_data.msg.len = 4;
+		tx_data.msg.msg[1] = CEC_OP_FEATURE_ABORT;
+		tx_data.msg.msg[2] = msg->msg[1];
+		tx_data.msg.msg[3] = 4;	/* Refused */
+		return cec_transmit_msg(adap, &tx_data, false);
+
+	case CEC_OP_USER_CONTROL_PRESSED:
+		switch (msg->msg[2]) {
+		/* Play function, this message can have variable length
+		 * depending on the specific play function that is used.
+		 */
+		case 0x60:
+			if (msg->len == 3)
+				rc_keydown(adap->rc, RC_TYPE_CEC,
+					   msg->msg[2] << 8 | msg->msg[3], 0);
+			else
+				rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2],
+					   0);
+			break;
+		/* Other function messages that are not handled.
+		 * Currently the RC framework does not allow to supply an
+		 * additional parameter to a keypress. These "keys" contain
+		 * other information such as channel number, an input number
+		 * etc.
+		 * For the time being these messages are not processed by the
+		 * framework and are simply forwarded to the user space.
+		 */
+		case 0x67: case 0x68: case 0x69: case 0x6a:
+			break;
+		default:
+			rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2], 0);
+		}
+		break;
+	case CEC_OP_USER_CONTROL_RELEASED:
+		rc_keyup(adap->rc);
+		return 0;
+	}
+
+skip_processing:
+	if ((adap->capabilities & CEC_CAP_RECEIVE) == 0)
+		return 0;
+	mutex_lock(&adap->lock);
+	idx = (adap->rx_qstart + adap->rx_qcount) % CEC_RX_QUEUE_SZ;
+	if (adap->rx_qcount == CEC_RX_QUEUE_SZ) {
+		res = -EBUSY;
+	} else {
+		adap->rx_queue[idx] = *msg;
+		adap->rx_qcount++;
+		wake_up_interruptible(&adap->waitq);
+	}
+	mutex_unlock(&adap->lock);
+	return res;
+}
+
+int cec_receive_msg(struct cec_adapter *adap, struct cec_msg *msg, bool block)
+{
+	int res;
+
+	do {
+		mutex_lock(&adap->lock);
+		if (adap->rx_qcount) {
+			*msg = adap->rx_queue[adap->rx_qstart];
+			adap->rx_qstart = (adap->rx_qstart + 1) %
+					  CEC_RX_QUEUE_SZ;
+			adap->rx_qcount--;
+			res = 0;
+		} else {
+			res = -EAGAIN;
+		}
+		mutex_unlock(&adap->lock);
+		if (!block || !res)
+			break;
+		if (msg->timeout) {
+			res = wait_event_interruptible_timeout(adap->waitq,
+				adap->rx_qcount,
+				msecs_to_jiffies(msg->timeout));
+			if (res == 0)
+				res = -ETIMEDOUT;
+			else if (res > 0)
+				res = 0;
+		} else {
+			res = wait_event_interruptible(adap->waitq,
+				adap->rx_qcount);
+		}
+	} while (!res);
+	return res;
+}
+EXPORT_SYMBOL_GPL(cec_receive_msg);
+
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	struct cec_data *dst_data = &adap->tx_queue[adap->tx_qstart];
+	bool is_reply = false;
+
+	mutex_lock(&adap->lock);
+	msg->ts = ktime_get_ns();
+	dprintk("cec_received_msg: %02x %02x\n", msg->msg[0], msg->msg[1]);
+	if (!cec_msg_is_broadcast(msg) && msg->len > 1 &&
+	    adap->state == CEC_ADAP_STATE_WAIT) {
+		struct cec_msg *dst = &dst_data->msg;
+
+		if (msg->msg[1] == dst->reply ||
+		    msg->msg[1] == CEC_OP_FEATURE_ABORT) {
+			msg->sequence = dst->sequence;
+			*dst = *msg;
+			is_reply = true;
+			if (msg->msg[1] == CEC_OP_FEATURE_ABORT) {
+				dst->reply = 0;
+				dst->status = CEC_TX_STATUS_FEATURE_ABORT;
+			}
+			wake_up_interruptible(&adap->kthread_waitq);
+		}
+	}
+	mutex_unlock(&adap->lock);
+	if (!is_reply || (is_reply && !dst_data->blocking))
+		adap->recv_notifier(adap, msg);
+	if (is_reply && !dst_data->blocking)
+		cec_post_event(adap, CEC_EVENT_GOT_REPLY, msg->sequence);
+}
+EXPORT_SYMBOL_GPL(cec_received_msg);
+
+void cec_post_event(struct cec_adapter *adap, u32 event, u32 sequence)
+{
+	unsigned idx;
+
+	mutex_lock(&adap->lock);
+	if (adap->ev_qcount == CEC_EV_QUEUE_SZ) {
+		/* Drop oldest event */
+		adap->ev_qstart = (adap->ev_qstart + 1) % CEC_EV_QUEUE_SZ;
+		adap->ev_qcount--;
+	}
+
+	idx = (adap->ev_qstart + adap->ev_qcount) % CEC_EV_QUEUE_SZ;
+
+	adap->ev_queue[idx].event = event;
+	adap->ev_queue[idx].sequence = sequence;
+	adap->ev_queue[idx].ts = ktime_get_ns();
+
+	adap->ev_qcount++;
+	mutex_unlock(&adap->lock);
+}
+EXPORT_SYMBOL_GPL(cec_post_event);
+
+static int cec_report_phys_addr(struct cec_adapter *adap, unsigned logical_addr)
+{
+	struct cec_data data;
+
+	/* Report Physical Address */
+	data.msg.len = 5;
+	data.msg.msg[0] = (logical_addr << 4) | 0x0f;
+	data.msg.msg[1] = CEC_OP_REPORT_PHYSICAL_ADDR;
+	data.msg.msg[2] = adap->phys_addr >> 8;
+	data.msg.msg[3] = adap->phys_addr & 0xff;
+	data.msg.msg[4] = cec_log_addr2dev(adap, logical_addr);
+	data.msg.reply = 0;
+	dprintk("config: la %d pa %x.%x.%x.%x\n",
+			logical_addr, cec_phys_addr_exp(adap->phys_addr));
+	return cec_transmit_msg(adap, &data, true);
+}
+
+int cec_enable(struct cec_adapter *adap, bool enable)
+{
+	int ret;
+
+	mutex_lock(&adap->lock);
+	ret = adap->adap_enable(adap, enable);
+	if (ret) {
+		mutex_unlock(&adap->lock);
+		return ret;
+	}
+	if (!enable) {
+		adap->state = CEC_ADAP_STATE_DISABLED;
+		adap->tx_qcount = 0;
+		adap->rx_qcount = 0;
+		adap->ev_qcount = 0;
+		adap->num_log_addrs = 0;
+	} else {
+		adap->state = CEC_ADAP_STATE_UNCONF;
+	}
+	mutex_unlock(&adap->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cec_enable);
+
+struct cec_log_addrs_int {
+	struct cec_adapter *adap;
+	struct cec_log_addrs log_addrs;
+	struct completion c;
+	bool free_on_exit;
+	int err;
+};
+
+static int cec_config_log_addrs(struct cec_adapter *adap,
+				struct cec_log_addrs *log_addrs)
+{
+	static const u8 tv_log_addrs[] = {
+		0, CEC_LOG_ADDR_INVALID
+	};
+	static const u8 record_log_addrs[] = {
+		1, 2, 9, 12, 13, CEC_LOG_ADDR_INVALID
+	};
+	static const u8 tuner_log_addrs[] = {
+		3, 6, 7, 10, 12, 13, CEC_LOG_ADDR_INVALID
+	};
+	static const u8 playback_log_addrs[] = {
+		4, 8, 11, 12, 13, CEC_LOG_ADDR_INVALID
+	};
+	static const u8 audiosystem_log_addrs[] = {
+		5, 12, 13, CEC_LOG_ADDR_INVALID
+	};
+	static const u8 specific_use_log_addrs[] = {
+		14, 12, 13, CEC_LOG_ADDR_INVALID
+	};
+	static const u8 unregistered_log_addrs[] = {
+		CEC_LOG_ADDR_INVALID
+	};
+	static const u8 *type2addrs[7] = {
+		[CEC_LOG_ADDR_TYPE_TV] = tv_log_addrs,
+		[CEC_LOG_ADDR_TYPE_RECORD] = record_log_addrs,
+		[CEC_LOG_ADDR_TYPE_TUNER] = tuner_log_addrs,
+		[CEC_LOG_ADDR_TYPE_PLAYBACK] = playback_log_addrs,
+		[CEC_LOG_ADDR_TYPE_AUDIOSYSTEM] = audiosystem_log_addrs,
+		[CEC_LOG_ADDR_TYPE_SPECIFIC] = specific_use_log_addrs,
+		[CEC_LOG_ADDR_TYPE_UNREGISTERED] = unregistered_log_addrs,
+	};
+	struct cec_data data;
+	u32 claimed_addrs = 0;
+	int i, j;
+	int err;
+
+	if (adap->phys_addr) {
+		/* The TV functionality can only map to physical address 0.
+		   For any other address, try the Specific functionality
+		   instead as per the spec. */
+		for (i = 0; i < log_addrs->num_log_addrs; i++)
+			if (log_addrs->log_addr_type[i] == CEC_LOG_ADDR_TYPE_TV)
+				log_addrs->log_addr_type[i] =
+						CEC_LOG_ADDR_TYPE_SPECIFIC;
+	}
+
+	memcpy(adap->prim_device, log_addrs->primary_device_type,
+			log_addrs->num_log_addrs);
+	dprintk("physical address: %x.%x.%x.%x, claim %d logical addresses\n",
+			cec_phys_addr_exp(adap->phys_addr),
+			log_addrs->num_log_addrs);
+	adap->num_log_addrs = 0;
+	adap->state = CEC_ADAP_STATE_IDLE;
+
+	/* TODO: remember last used logical addr type to achieve
+	   faster logical address polling by trying that one first.
+	 */
+	for (i = 0; i < log_addrs->num_log_addrs; i++) {
+		const u8 *la_list = type2addrs[log_addrs->log_addr_type[i]];
+
+		if (kthread_should_stop())
+			return -EINTR;
+
+		for (j = 0; la_list[j] != CEC_LOG_ADDR_INVALID; j++) {
+			u8 log_addr = la_list[j];
+
+			if (claimed_addrs & (1 << log_addr))
+				continue;
+
+			/* Send polling message */
+			data.msg.len = 1;
+			data.msg.msg[0] = 0xf0 | log_addr;
+			data.msg.reply = 0;
+			err = cec_transmit_msg(adap, &data, true);
+			if (err)
+				return err;
+			if (data.msg.status == CEC_TX_STATUS_RETRY_TIMEOUT) {
+				/* Message not acknowledged, so this logical
+				   address is free to use. */
+				claimed_addrs |= 1 << log_addr;
+				adap->log_addr[adap->num_log_addrs++] =
+								log_addr;
+				log_addrs->log_addr[i] = log_addr;
+				err = adap->adap_log_addr(adap, log_addr);
+				dprintk("claim addr %d (%d)\n", log_addr,
+							adap->prim_device[i]);
+				if (err)
+					return err;
+				cec_report_phys_addr(adap, log_addr);
+				if (adap->claimed_log_addr)
+					adap->claimed_log_addr(adap, i);
+				break;
+			}
+		}
+	}
+	if (adap->num_log_addrs == 0) {
+		if (log_addrs->num_log_addrs > 1)
+			dprintk("could not claim last %d addresses\n",
+				log_addrs->num_log_addrs - 1);
+		adap->log_addr[adap->num_log_addrs++] = 15;
+		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_UNREGISTERED;
+		log_addrs->log_addr[0] = 15;
+		log_addrs->num_log_addrs = 1;
+		err = adap->adap_log_addr(adap, 15);
+		dprintk("claim addr %d (%d)\n", 15, adap->prim_device[0]);
+		if (err)
+			return err;
+		cec_report_phys_addr(adap, 15);
+		if (adap->claimed_log_addr)
+			adap->claimed_log_addr(adap, 0);
+	}
+	return 0;
+}
+
+static int cec_config_thread_func(void *arg)
+{
+	struct cec_log_addrs_int *cla_int = arg;
+	int err;
+
+	cla_int->err = err = cec_config_log_addrs(cla_int->adap,
+						  &cla_int->log_addrs);
+	cla_int->adap->kthread_config = NULL;
+	if (cla_int->free_on_exit)
+		kfree(cla_int);
+	else
+		complete(&cla_int->c);
+
+	cec_post_event(cla_int->adap, CEC_EVENT_READY, 0);
+	return err;
+}
+
+int cec_claim_log_addrs(struct cec_adapter *adap,
+			struct cec_log_addrs *log_addrs, bool block)
+{
+	struct cec_log_addrs_int *cla_int;
+	int i;
+
+	if (adap->state == CEC_ADAP_STATE_DISABLED)
+		return -EINVAL;
+
+	if (log_addrs->num_log_addrs > CEC_MAX_LOG_ADDRS)
+		return -EINVAL;
+	if (log_addrs->num_log_addrs == 0) {
+		adap->num_log_addrs = 0;
+		adap->state = CEC_ADAP_STATE_IDLE;
+		return 0;
+	}
+	if (log_addrs->cec_version != CEC_VERSION_1_4 &&
+	    log_addrs->cec_version != CEC_VERSION_2_0)
+		return -EINVAL;
+	if (log_addrs->num_log_addrs > 1)
+		for (i = 0; i < log_addrs->num_log_addrs; i++)
+			if (log_addrs->log_addr_type[i] ==
+					CEC_LOG_ADDR_TYPE_UNREGISTERED)
+				return -EINVAL;
+	for (i = 0; i < log_addrs->num_log_addrs; i++) {
+		if (log_addrs->primary_device_type[i] >
+						CEC_PRIM_DEVTYPE_VIDEOPROC)
+			return -EINVAL;
+		if (log_addrs->primary_device_type[i] == 2)
+			return -EINVAL;
+		if (log_addrs->log_addr_type[i] >
+						CEC_LOG_ADDR_TYPE_UNREGISTERED)
+			return -EINVAL;
+	}
+
+	/* For phys addr 0xffff only the Unregistered functionality is
+	   allowed. */
+	if (adap->phys_addr == 0xffff &&
+	    (log_addrs->num_log_addrs > 1 ||
+	     log_addrs->log_addr_type[0] != CEC_LOG_ADDR_TYPE_UNREGISTERED))
+		return -EINVAL;
+
+	cla_int = kzalloc(sizeof(*cla_int), GFP_KERNEL);
+	if (cla_int == NULL)
+		return -ENOMEM;
+	init_completion(&cla_int->c);
+	cla_int->free_on_exit = !block;
+	cla_int->adap = adap;
+	cla_int->log_addrs = *log_addrs;
+	adap->kthread_config = kthread_run(cec_config_thread_func, cla_int,
+							"cec_log_addrs");
+	if (block) {
+		wait_for_completion(&cla_int->c);
+		*log_addrs = cla_int->log_addrs;
+		kfree(cla_int);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cec_claim_log_addrs);
+
+static unsigned int cec_poll(struct file *filp,
+			       struct poll_table_struct *poll)
+{
+	struct cec_devnode *cecdev = cec_devnode_data(filp);
+	struct cec_adapter *adap = to_cec_adapter(cecdev);
+	unsigned res = 0;
+
+	if (!cec_devnode_is_registered(cecdev))
+		return POLLERR | POLLHUP;
+	mutex_lock(&adap->lock);
+	if (adap->tx_qcount < CEC_TX_QUEUE_SZ)
+		res |= POLLOUT | POLLWRNORM;
+	if (adap->rx_qcount)
+		res |= POLLIN | POLLRDNORM;
+	if (adap->ev_qcount)
+		res |= POLLPRI;
+	poll_wait(filp, &adap->waitq, poll);
+	mutex_unlock(&adap->lock);
+	return res;
+}
+
+static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct cec_devnode *cecdev = cec_devnode_data(filp);
+	struct cec_adapter *adap = to_cec_adapter(cecdev);
+	void __user *parg = (void __user *)arg;
+	int err;
+
+	if (!cec_devnode_is_registered(cecdev))
+		return -EIO;
+
+	switch (cmd) {
+	case CEC_G_CAPS: {
+		struct cec_caps caps;
+
+		caps.available_log_addrs = 3;
+		caps.capabilities = adap->capabilities;
+		caps.version = adap->version;
+		caps.vendor_id = adap->vendor_id;
+		if (copy_to_user(parg, &caps, sizeof(caps)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_TRANSMIT: {
+		struct cec_data data;
+
+		if (!(adap->capabilities & CEC_CAP_TRANSMIT))
+			return -ENOTTY;
+		if (copy_from_user(&data.msg, parg, sizeof(data.msg)))
+			return -EFAULT;
+		err = cec_transmit_msg(adap, &data,
+						!(filp->f_flags & O_NONBLOCK));
+		if (err)
+			return err;
+		if (copy_to_user(parg, &data.msg, sizeof(data.msg)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_RECEIVE: {
+		struct cec_data data;
+
+		if (!(adap->capabilities & CEC_CAP_RECEIVE))
+			return -ENOTTY;
+		if (copy_from_user(&data.msg, parg, sizeof(data.msg)))
+			return -EFAULT;
+		err = cec_receive_msg(adap, &data.msg,
+						!(filp->f_flags & O_NONBLOCK));
+		if (err)
+			return err;
+		if (copy_to_user(parg, &data.msg, sizeof(data.msg)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_G_EVENT: {
+		struct cec_event ev;
+
+		mutex_lock(&adap->lock);
+		err = -EAGAIN;
+		if (adap->ev_qcount) {
+			err = 0;
+			ev = adap->ev_queue[adap->ev_qstart];
+			adap->ev_qstart = (adap->ev_qstart + 1) %
+								CEC_EV_QUEUE_SZ;
+			adap->ev_qcount--;
+		}
+		mutex_unlock(&adap->lock);
+		if (err)
+			return err;
+		if (copy_to_user((void __user *)arg, &ev, sizeof(ev)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_G_ADAP_STATE: {
+		u32 state = adap->state != CEC_ADAP_STATE_DISABLED;
+
+		if (copy_to_user(parg, &state, sizeof(state)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_S_ADAP_STATE: {
+		u32 state;
+
+		if (!(adap->capabilities & CEC_CAP_STATE))
+			return -ENOTTY;
+		if (copy_from_user(&state, parg, sizeof(state)))
+			return -EFAULT;
+		if (!state && adap->state == CEC_ADAP_STATE_DISABLED)
+			return 0;
+		if (state && adap->state != CEC_ADAP_STATE_DISABLED)
+			return 0;
+		cec_enable(adap, !!state);
+		break;
+	}
+
+	case CEC_G_ADAP_PHYS_ADDR:
+		if (copy_to_user(parg, &adap->phys_addr,
+						sizeof(adap->phys_addr)))
+			return -EFAULT;
+		break;
+
+	case CEC_S_ADAP_PHYS_ADDR: {
+		u16 phys_addr;
+
+		if (!(adap->capabilities & CEC_CAP_PHYS_ADDR))
+			return -ENOTTY;
+		if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
+			return -EFAULT;
+		adap->phys_addr = phys_addr;
+		break;
+	}
+
+	case CEC_G_ADAP_LOG_ADDRS: {
+		struct cec_log_addrs log_addrs;
+
+		log_addrs.cec_version = adap->version;
+		log_addrs.num_log_addrs = adap->num_log_addrs;
+		memcpy(log_addrs.primary_device_type, adap->prim_device,
+							CEC_MAX_LOG_ADDRS);
+		memcpy(log_addrs.log_addr_type, adap->log_addr_type,
+							CEC_MAX_LOG_ADDRS);
+		memcpy(log_addrs.log_addr, adap->log_addr,
+							CEC_MAX_LOG_ADDRS);
+
+		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_S_ADAP_LOG_ADDRS: {
+		struct cec_log_addrs log_addrs;
+
+		if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
+			return -ENOTTY;
+		if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
+			return -EFAULT;
+		err = cec_claim_log_addrs(adap, &log_addrs,
+					!(filp->f_flags & O_NONBLOCK));
+		if (err)
+			return err;
+
+		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_G_VENDOR_ID:
+		if (copy_to_user(parg, &adap->vendor_id,
+						sizeof(adap->vendor_id)))
+			return -EFAULT;
+		break;
+
+	case CEC_S_VENDOR_ID: {
+		u32 vendor_id;
+
+		if (!(adap->capabilities & CEC_CAP_VENDOR_ID))
+			return -ENOTTY;
+		if (copy_from_user(&vendor_id, parg, sizeof(vendor_id)))
+			return -EFAULT;
+		/* Vendori ID is a 24 bit number, so check if the value is
+		 * within the correct range. */
+		if ((vendor_id & 0xff000000) != 0)
+			return -EINVAL;
+		adap->vendor_id = vendor_id;
+		break;
+	}
+
+	case CEC_G_PASSTHROUGH: {
+		u32 state = adap->passthrough;
+
+		if (copy_to_user(parg, &state, sizeof(state)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_S_PASSTHROUGH: {
+		u32 state;
+
+		if (!(adap->capabilities & CEC_CAP_PASSTHROUGH))
+			return -ENOTTY;
+		if (copy_from_user(&state, parg, sizeof(state)))
+			return -EFAULT;
+		if (state == CEC_PASSTHROUGH_DISABLED)
+			adap->passthrough = state;
+		else if (state == CEC_PASSTHROUGH_ENABLED)
+			adap->passthrough = state;
+		else
+			return -EINVAL;
+		break;
+	}
+
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+/* Override for the open function */
+static int cec_open(struct inode *inode, struct file *filp)
+{
+	struct cec_devnode *cecdev;
+
+	/* Check if the cec device is available. This needs to be done with
+	 * the cec_devnode_lock held to prevent an open/unregister race:
+	 * without the lock, the device could be unregistered and freed between
+	 * the cec_devnode_is_registered() and get_device() calls, leading to
+	 * a crash.
+	 */
+	mutex_lock(&cec_devnode_lock);
+	cecdev = container_of(inode->i_cdev, struct cec_devnode, cdev);
+	/* return ENXIO if the cec device has been removed
+	   already or if it is not registered anymore. */
+	if (!cec_devnode_is_registered(cecdev)) {
+		mutex_unlock(&cec_devnode_lock);
+		return -ENXIO;
+	}
+	/* and increase the device refcount */
+	get_device(&cecdev->dev);
+	mutex_unlock(&cec_devnode_lock);
+
+	filp->private_data = cecdev;
+
+	return 0;
+}
+
+/* Override for the release function */
+static int cec_release(struct inode *inode, struct file *filp)
+{
+	struct cec_devnode *cecdev = cec_devnode_data(filp);
+	int ret = 0;
+
+	/* decrease the refcount unconditionally since the release()
+	   return value is ignored. */
+	put_device(&cecdev->dev);
+	filp->private_data = NULL;
+	return ret;
+}
+
+static const struct file_operations cec_devnode_fops = {
+	.owner = THIS_MODULE,
+	.open = cec_open,
+	.unlocked_ioctl = cec_ioctl,
+	.release = cec_release,
+	.poll = cec_poll,
+	.llseek = no_llseek,
+};
+
+/**
+ * cec_devnode_register - register a cec device node
+ * @cecdev: cec device node structure we want to register
+ *
+ * The registration code assigns minor numbers and registers the new device node
+ * with the kernel. An error is returned if no free minor number can be found,
+ * or if the registration of the device node fails.
+ *
+ * Zero is returned on success.
+ *
+ * Note that if the cec_devnode_register call fails, the release() callback of
+ * the cec_devnode structure is *not* called, so the caller is responsible for
+ * freeing any data.
+ */
+static int __must_check cec_devnode_register(struct cec_devnode *cecdev,
+		struct module *owner)
+{
+	int minor;
+	int ret;
+
+	/* Part 1: Find a free minor number */
+	mutex_lock(&cec_devnode_lock);
+	minor = find_next_zero_bit(cec_devnode_nums, CEC_NUM_DEVICES, 0);
+	if (minor == CEC_NUM_DEVICES) {
+		mutex_unlock(&cec_devnode_lock);
+		pr_err("could not get a free minor\n");
+		return -ENFILE;
+	}
+
+	set_bit(minor, cec_devnode_nums);
+	mutex_unlock(&cec_devnode_lock);
+
+	cecdev->minor = minor;
+
+	/* Part 2: Initialize and register the character device */
+	cdev_init(&cecdev->cdev, &cec_devnode_fops);
+	cecdev->cdev.owner = owner;
+
+	ret = cdev_add(&cecdev->cdev, MKDEV(MAJOR(cec_dev_t), cecdev->minor),
+									1);
+	if (ret < 0) {
+		pr_err("%s: cdev_add failed\n", __func__);
+		goto error;
+	}
+
+	/* Part 3: Register the cec device */
+	cecdev->dev.bus = &cec_bus_type;
+	cecdev->dev.devt = MKDEV(MAJOR(cec_dev_t), cecdev->minor);
+	cecdev->dev.release = cec_devnode_release;
+	if (cecdev->parent)
+		cecdev->dev.parent = cecdev->parent;
+	dev_set_name(&cecdev->dev, "cec%d", cecdev->minor);
+	ret = device_register(&cecdev->dev);
+	if (ret < 0) {
+		pr_err("%s: device_register failed\n", __func__);
+		goto error;
+	}
+
+	/* Part 4: Activate this minor. The char device can now be used. */
+	set_bit(CEC_FLAG_REGISTERED, &cecdev->flags);
+
+	return 0;
+
+error:
+	cdev_del(&cecdev->cdev);
+	clear_bit(cecdev->minor, cec_devnode_nums);
+	return ret;
+}
+
+/**
+ * cec_devnode_unregister - unregister a cec device node
+ * @cecdev: the device node to unregister
+ *
+ * This unregisters the passed device. Future open calls will be met with
+ * errors.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
+static void cec_devnode_unregister(struct cec_devnode *cecdev)
+{
+	/* Check if cecdev was ever registered at all */
+	if (!cec_devnode_is_registered(cecdev))
+		return;
+
+	mutex_lock(&cec_devnode_lock);
+	clear_bit(CEC_FLAG_REGISTERED, &cecdev->flags);
+	mutex_unlock(&cec_devnode_lock);
+	device_unregister(&cecdev->dev);
+}
+
+int cec_create_adapter(struct cec_adapter *adap, const char *name, u32 caps)
+{
+	int res = 0;
+
+	adap->state = CEC_ADAP_STATE_DISABLED;
+	adap->name = name;
+	adap->phys_addr = 0xffff;
+	adap->capabilities = caps;
+	adap->version = CEC_VERSION_1_4;
+	adap->sequence = 0;
+	mutex_init(&adap->lock);
+	adap->kthread = kthread_run(cec_thread_func, adap, name);
+	init_waitqueue_head(&adap->kthread_waitq);
+	init_waitqueue_head(&adap->waitq);
+	if (IS_ERR(adap->kthread)) {
+		pr_err("cec-%s: kernel_thread() failed\n", name);
+		return PTR_ERR(adap->kthread);
+	}
+	if (caps) {
+		res = cec_devnode_register(&adap->devnode, adap->owner);
+		if (res)
+			kthread_stop(adap->kthread);
+	}
+	adap->recv_notifier = cec_receive_notify;
+
+	/* Prepare the RC input device */
+	adap->rc = rc_allocate_device();
+	if (!adap->rc) {
+		pr_err("cec-%s: failed to allocate memory for rc_dev\n", name);
+		cec_devnode_unregister(&adap->devnode);
+		kthread_stop(adap->kthread);
+		return -ENOMEM;
+	}
+
+	snprintf(adap->input_name, sizeof(adap->input_name), "RC for %s", name);
+	snprintf(adap->input_phys, sizeof(adap->input_phys), "%s/input0", name);
+	strncpy(adap->input_drv, name, sizeof(adap->input_drv));
+
+	adap->rc->input_name = adap->input_name;
+	adap->rc->input_phys = adap->input_phys;
+	adap->rc->dev.parent = &adap->devnode.dev;
+	adap->rc->driver_name = adap->input_drv;
+	adap->rc->driver_type = RC_DRIVER_CEC;
+	adap->rc->allowed_protocols = RC_BIT_CEC;
+	adap->rc->priv = adap;
+	adap->rc->map_name = RC_MAP_CEC;
+	adap->rc->timeout = MS_TO_NS(100);
+
+	res = rc_register_device(adap->rc);
+
+	if (res) {
+		pr_err("cec-%s: failed to prepare input device\n", name);
+		cec_devnode_unregister(&adap->devnode);
+		rc_free_device(adap->rc);
+		kthread_stop(adap->kthread);
+	}
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(cec_create_adapter);
+
+void cec_delete_adapter(struct cec_adapter *adap)
+{
+	if (adap->kthread == NULL)
+		return;
+	kthread_stop(adap->kthread);
+	if (adap->kthread_config)
+		kthread_stop(adap->kthread_config);
+	adap->state = CEC_ADAP_STATE_DISABLED;
+	if (cec_devnode_is_registered(&adap->devnode))
+		cec_devnode_unregister(&adap->devnode);
+}
+EXPORT_SYMBOL_GPL(cec_delete_adapter);
+
+/*
+ *	Initialise cec for linux
+ */
+static int __init cec_devnode_init(void)
+{
+	int ret;
+
+	pr_info("Linux cec interface: v0.10\n");
+	ret = alloc_chrdev_region(&cec_dev_t, 0, CEC_NUM_DEVICES,
+				  CEC_NAME);
+	if (ret < 0) {
+		pr_warn("cec: unable to allocate major\n");
+		return ret;
+	}
+
+	ret = bus_register(&cec_bus_type);
+	if (ret < 0) {
+		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
+		pr_warn("cec: bus_register failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void __exit cec_devnode_exit(void)
+{
+	bus_unregister(&cec_bus_type);
+	unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
+}
+
+subsys_initcall(cec_devnode_init);
+module_exit(cec_devnode_exit)
+
+MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
+MODULE_DESCRIPTION("Device node registration for cec drivers");
+MODULE_LICENSE("GPL");
diff --git a/include/media/cec.h b/include/media/cec.h
new file mode 100644
index 0000000..d835e76
--- /dev/null
+++ b/include/media/cec.h
@@ -0,0 +1,142 @@
+#ifndef _CEC_DEVNODE_H
+#define _CEC_DEVNODE_H
+
+#include <linux/poll.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/kthread.h>
+#include <linux/cec.h>
+#include <media/rc-core.h>
+
+#define cec_phys_addr_exp(pa) \
+	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
+
+/*
+ * Flag to mark the cec_devnode struct as registered. Drivers must not touch
+ * this flag directly, it will be set and cleared by cec_devnode_register and
+ * cec_devnode_unregister.
+ */
+#define CEC_FLAG_REGISTERED	0
+
+/**
+ * struct cec_devnode - cec device node
+ * @parent:	parent device
+ * @minor:	device node minor number
+ * @flags:	flags, combination of the CEC_FLAG_* constants
+ *
+ * This structure represents a cec-related device node.
+ *
+ * The @parent is a physical device. It must be set by core or device drivers
+ * before registering the node.
+ */
+struct cec_devnode {
+	/* sysfs */
+	struct device dev;		/* cec device */
+	struct cdev cdev;		/* character device */
+	struct device *parent;		/* device parent */
+
+	/* device info */
+	int minor;
+	unsigned long flags;		/* Use bitops to access flags */
+
+	/* callbacks */
+	void (*release)(struct cec_devnode *cecdev);
+};
+
+static inline int cec_devnode_is_registered(struct cec_devnode *cecdev)
+{
+	return test_bit(CEC_FLAG_REGISTERED, &cecdev->flags);
+}
+
+struct cec_adapter;
+struct cec_data;
+
+typedef int (*cec_notify)(struct cec_adapter *adap, struct cec_data *data,
+			  void *priv);
+typedef int (*cec_recv_notify)(struct cec_adapter *adap, struct cec_msg *msg);
+
+struct cec_data {
+	struct cec_msg msg;
+	cec_notify func;
+	void *priv;
+	bool blocking;
+};
+
+/* Unconfigured state */
+#define CEC_ADAP_STATE_DISABLED		0
+#define CEC_ADAP_STATE_UNCONF		1
+#define CEC_ADAP_STATE_IDLE		2
+#define CEC_ADAP_STATE_TRANSMITTING	3
+#define CEC_ADAP_STATE_WAIT		4
+#define CEC_ADAP_STATE_RECEIVED		5
+
+#define CEC_TX_QUEUE_SZ	(4)
+#define CEC_RX_QUEUE_SZ	(4)
+#define CEC_EV_QUEUE_SZ	(40)
+
+struct cec_adapter {
+	struct module *owner;
+	const char *name;
+	struct cec_devnode devnode;
+	struct mutex lock;
+	struct rc_dev *rc;
+
+	struct cec_data tx_queue[CEC_TX_QUEUE_SZ];
+	u8 tx_qstart, tx_qcount;
+
+	struct cec_msg rx_queue[CEC_RX_QUEUE_SZ];
+	u8 rx_qstart, rx_qcount;
+
+	struct cec_event ev_queue[CEC_EV_QUEUE_SZ];
+	u8 ev_qstart, ev_qcount;
+
+	cec_recv_notify recv_notifier;
+	struct task_struct *kthread_config;
+
+	struct task_struct *kthread;
+	wait_queue_head_t kthread_waitq;
+	wait_queue_head_t waitq;
+
+	u8 state;
+	u32 capabilities;
+	u16 phys_addr;
+	u32 vendor_id;
+	u8 version;
+	u8 num_log_addrs;
+	u8 prim_device[CEC_MAX_LOG_ADDRS];
+	u8 log_addr_type[CEC_MAX_LOG_ADDRS];
+	u8 log_addr[CEC_MAX_LOG_ADDRS];
+	u8 passthrough;
+	u32 sequence;
+
+	char input_name[32];
+	char input_phys[32];
+	char input_drv[32];
+
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+	int (*adap_transmit)(struct cec_adapter *adap, struct cec_msg *msg);
+	void (*adap_transmit_timed_out)(struct cec_adapter *adap);
+
+	void (*claimed_log_addr)(struct cec_adapter *adap, u8 idx);
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+};
+
+#define to_cec_adapter(node) container_of(node, struct cec_adapter, devnode)
+
+int cec_create_adapter(struct cec_adapter *adap, const char *name, u32 caps);
+void cec_delete_adapter(struct cec_adapter *adap);
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_data *data,
+		     bool block);
+int cec_receive_msg(struct cec_adapter *adap, struct cec_msg *msg, bool block);
+void cec_post_event(struct cec_adapter *adap, u32 event, u32 sequence);
+int cec_claim_log_addrs(struct cec_adapter *adap,
+			struct cec_log_addrs *log_addrs, bool block);
+int cec_enable(struct cec_adapter *adap, bool enable);
+
+/* Called by the adapter */
+void cec_transmit_done(struct cec_adapter *adap, u32 status);
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+
+#endif /* _CEC_DEVNODE_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 1a0006a..cea279e 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -81,6 +81,7 @@ header-y += capi.h
 header-y += cciss_defs.h
 header-y += cciss_ioctl.h
 header-y += cdrom.h
+header-y += cec.h
 header-y += cgroupstats.h
 header-y += chio.h
 header-y += cm4000_cs.h
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
new file mode 100644
index 0000000..67b0049
--- /dev/null
+++ b/include/uapi/linux/cec.h
@@ -0,0 +1,332 @@
+#ifndef _CEC_H
+#define _CEC_H
+
+#include <linux/types.h>
+
+struct cec_msg {
+	__u64 ts;
+	__u32 len;
+	__u32 status;
+	__u32 timeout;
+	/* timeout (in ms) is used to timeout CEC_RECEIVE.
+	   Set to 0 if you want to wait forever. */
+	__u8  msg[16];
+	__u8  reply;
+	/* If non-zero, then wait for a reply with this opcode.
+	   If there was an error when sending the msg or FeatureAbort
+	   was returned, then reply is set to 0.
+	   If reply is non-zero upon return, then len/msg are set to
+	   the received message.
+	   If reply is zero upon return and status has the
+	   CEC_TX_STATUS_FEATURE_ABORT bit set, then len/msg are set to the
+	   received feature abort message.
+	   If reply is zero upon return and status has the
+	   CEC_TX_STATUS_REPLY_TIMEOUT
+	   bit set, then no reply was seen at all.
+	   This field is ignored with CEC_RECEIVE.
+	   If reply is non-zero for CEC_TRANSMIT and the message is a broadcast,
+	   then -EINVAL is returned.
+	   if reply is non-zero, then timeout is set to 1000 (the required
+	   maximum response time).
+	 */
+	__u32 sequence;
+	/* The framework assigns a sequence number to messages that are sent.
+	 * This can be used to track replies to previously sent messages.
+	 */
+	__u8 reserved[35];
+};
+
+static inline __u8 cec_msg_initiator(const struct cec_msg *msg)
+{
+	return msg->msg[0] >> 4;
+}
+
+static inline __u8 cec_msg_destination(const struct cec_msg *msg)
+{
+	return msg->msg[0] & 0xf;
+}
+
+static inline bool cec_msg_is_broadcast(const struct cec_msg *msg)
+{
+	return (msg->msg[0] & 0xf) == 0xf;
+}
+
+/* cec status field */
+#define CEC_TX_STATUS_OK            (0)
+#define CEC_TX_STATUS_ARB_LOST      (1 << 0)
+#define CEC_TX_STATUS_RETRY_TIMEOUT (1 << 1)
+#define CEC_TX_STATUS_FEATURE_ABORT (1 << 2)
+#define CEC_TX_STATUS_REPLY_TIMEOUT (1 << 3)
+#define CEC_RX_STATUS_READY         (0)
+
+#define CEC_LOG_ADDR_INVALID 0xff
+
+/* The maximum number of logical addresses one device can be assigned to.
+ * The CEC 2.0 spec allows for only 2 logical addresses at the moment. The
+ * Analog Devices CEC hardware supports 3. So let's go wild and go for 4. */
+#define CEC_MAX_LOG_ADDRS 4
+
+/* The "Primary Device Type" */
+#define CEC_PRIM_DEVTYPE_TV		0
+#define CEC_PRIM_DEVTYPE_RECORD		1
+#define CEC_PRIM_DEVTYPE_TUNER		3
+#define CEC_PRIM_DEVTYPE_PLAYBACK	4
+#define CEC_PRIM_DEVTYPE_AUDIOSYSTEM	5
+#define CEC_PRIM_DEVTYPE_SWITCH		6
+#define CEC_PRIM_DEVTYPE_VIDEOPROC	7
+
+/* The "All Device Types" flags (CEC 2.0) */
+#define CEC_FL_ALL_DEVTYPE_TV		(1 << 7)
+#define CEC_FL_ALL_DEVTYPE_RECORD	(1 << 6)
+#define CEC_FL_ALL_DEVTYPE_TUNER	(1 << 5)
+#define CEC_FL_ALL_DEVTYPE_PLAYBACK	(1 << 4)
+#define CEC_FL_ALL_DEVTYPE_AUDIOSYSTEM	(1 << 3)
+#define CEC_FL_ALL_DEVTYPE_SWITCH	(1 << 2)
+/* And if you wondering what happened to VIDEOPROC devices: those should
+ * be mapped to a SWITCH. */
+
+/* The logical address types that the CEC device wants to claim */
+#define CEC_LOG_ADDR_TYPE_TV		0
+#define CEC_LOG_ADDR_TYPE_RECORD	1
+#define CEC_LOG_ADDR_TYPE_TUNER		2
+#define CEC_LOG_ADDR_TYPE_PLAYBACK	3
+#define CEC_LOG_ADDR_TYPE_AUDIOSYSTEM	4
+#define CEC_LOG_ADDR_TYPE_SPECIFIC	5
+#define CEC_LOG_ADDR_TYPE_UNREGISTERED	6
+/* Switches should use UNREGISTERED.
+ * Video processors should use SPECIFIC. */
+
+/* The CEC version */
+#define CEC_VERSION_1_3A		4
+#define CEC_VERSION_1_4			5
+#define CEC_VERSION_2_0			6
+
+struct cec_event {
+	__u64 ts;
+	__u32 event;
+	__u32 sequence;
+	__u8 reserved[8];
+};
+
+/* The CEC state */
+#define CEC_STATE_DISABLED		0
+#define CEC_STATE_ENABLED		1
+
+/* The passthrough mode state */
+#define CEC_PASSTHROUGH_DISABLED	0
+#define CEC_PASSTHROUGH_ENABLED		1
+
+/* Userspace has to configure the adapter state (enable/disable) */
+#define CEC_CAP_STATE		(1 << 0)
+/* Userspace has to configure the physical address */
+#define CEC_CAP_PHYS_ADDR	(1 << 1)
+/* Userspace has to configure the logical addresses */
+#define CEC_CAP_LOG_ADDRS	(1 << 2)
+/* Userspace can transmit messages */
+#define CEC_CAP_TRANSMIT	(1 << 3)
+/* Userspace can receive messages */
+#define CEC_CAP_RECEIVE		(1 << 4)
+/* Userspace has to configure the vendor id */
+#define CEC_CAP_VENDOR_ID	(1 << 5)
+/* The hardware has the possibility to work in the passthrough */
+#define CEC_CAP_PASSTHROUGH	(1 << 6)
+
+struct cec_caps {
+	__u32 available_log_addrs;
+	__u32 capabilities;
+	__u32 vendor_id;
+	__u8  version;
+	__u8  reserved[35];
+};
+
+struct cec_log_addrs {
+	__u8 cec_version;
+	__u8 num_log_addrs;
+	__u8 primary_device_type[CEC_MAX_LOG_ADDRS];
+	__u8 log_addr_type[CEC_MAX_LOG_ADDRS];
+	__u8 log_addr[CEC_MAX_LOG_ADDRS];
+
+	/* CEC 2.0 */
+	__u8 all_device_types;
+	__u8 features[CEC_MAX_LOG_ADDRS][12];
+
+	__u8 reserved[65];
+};
+
+/* Commands */
+
+/* One Touch Play Feature */
+#define CEC_OP_ACTIVE_SOURCE			0x82
+#define CEC_OP_IMAGE_VIEW_ON			0x04
+#define CEC_OP_TEXT_VIEW_ON			0x0d
+
+/* Routing Control Feature */
+#define CEC_OP_ACTIVE_SOURCE			0x82
+#define CEC_OP_INACTIVE_SOURCE			0x9d
+#define CEC_OP_REQUEST_ACTIVE_SOURCE		0x85
+#define CEC_OP_ROUTING_CHANGE			0x80
+#define CEC_OP_ROUTING_INFORMATION		0x81
+#define CEC_OP_SET_STREAM_PATH			0x86
+
+/* Standby Feature */
+#define CEC_OP_STANDBY				0x36
+
+/* One Touch Record Feature */
+#define CEC_OP_RECORD_OFF			0x0b
+#define CEC_OP_RECORD_ON			0x09
+#define CEC_OP_RECORD_STATUS			0x0a
+#define CEC_OP_RECORD_TV_SCREEN			0x0f
+
+/* Timer Programming Feature */
+#define CEC_OP_CLEAR_ANALOGUE_TIMER		0x33
+#define CEC_OP_CLEAR_DIGITAL_TIMER		0x99
+#define CEC_OP_CLEAR_EXT_TIMER			0xa1
+#define CEC_OP_SET_ANALOGUE_TIMER		0x34
+#define CEC_OP_SET_DIGITAL_TIMER		0x97
+#define CEC_OP_SET_EXT_TIMER			0xa2
+#define CEC_OP_SET_EXT_PROGRAM_TIMER		0x67
+#define CEC_OP_TIMER_CLEARED_STATUS		0x43
+#define CEC_OP_TIMER_STATUS			0x35
+
+/* System Information Feature */
+#define CEC_OP_CEC_VERSION			0x9e
+#define CEC_OP_GET_CEC_VERSION			0x9f
+#define CEC_OP_GIVE_PHYSICAL_ADDR		0x83
+#define CEC_OP_GET_MENU_LANGUAGE		0x91
+#define CEC_OP_REPORT_PHYSICAL_ADDR		0x84
+#define CEC_OP_SET_MENU_LANGUAGE		0x32
+#define CEC_OP_REPORT_FEATURES			0xa6	/* HDMI 2.0 */
+#define CEC_OP_GIVE_FEATURES			0xa5	/* HDMI 2.0 */
+
+/* Deck Control Feature */
+#define CEC_OP_DECK_CONTROL			0x42
+#define CEC_OP_DECK_STATUS			0x1b
+#define CEC_OP_GIVE_DECK_STATUS			0x1a
+#define CEC_OP_PLAY				0x41
+
+/* Tuner Control Feature */
+#define CEC_OP_GIVE_TUNER_DEVICE_STATUS		0x08
+#define CEC_OP_SELECT_ANALOGUE_SERVICE		0x92
+#define CEC_OP_SELECT_DIGITAL_SERVICE		0x93
+#define CEC_OP_TUNER_DEVICE_STATUS		0x07
+#define CEC_OP_TUNER_STEP_DECREMENT		0x06
+#define CEC_OP_TUNER_STEP_INCREMENT		0x05
+
+/* Vendor Specific Commands Feature */
+#define CEC_OP_CEC_VERSION			0x9e
+#define CEC_OP_DEVICE_VENDOR_ID			0x87
+#define CEC_OP_GET_CEC_VERSION			0x9f
+#define CEC_OP_GIVE_DEVICE_VENDOR_ID		0x8c
+#define CEC_OP_VENDOR_COMMAND			0x89
+#define CEC_OP_VENDOR_COMMAND_WITH_ID		0xa0
+#define CEC_OP_VENDOR_REMOTE_BUTTON_DOWN	0x8a
+#define CEC_OP_VENDOR_REMOTE_BUTTON_UP		0x8b
+
+/* OSD Display Feature */
+#define CEC_OP_SET_OSD_STRING			0x64
+
+/* Device OSD Transfer Feature */
+#define CEC_OP_GIVE_OSD_NAME			0x46
+#define CEC_OP_SET_OSD_NAME			0x47
+
+/* Device Menu Control Feature */
+#define CEC_OP_MENU_REQUEST			0x8d
+#define CEC_OP_MENU_STATUS			0x8e
+#define CEC_OP_USER_CONTROL_PRESSED		0x44
+#define CEC_OP_USER_CONTROL_RELEASED		0x45
+
+/* Power Status Feature */
+#define CEC_OP_GIVE_DEVICE_POWER_STATUS		0x8f
+#define CEC_OP_REPORT_POWER_STATUS		0x90
+#define CEC_OP_FEATURE_ABORT			0x00
+#define CEC_OP_ABORT				0xff
+
+/* System Audio Control Feature */
+#define CEC_OP_GIVE_AUDIO_STATUS		0x71
+#define CEC_OP_GIVE_SYSTEM_AUDIO_MODE_STATUS	0x7d
+#define CEC_OP_REPORT_AUDIO_STATUS		0x7a
+#define CEC_OP_SET_SYSTEM_AUDIO_MODE		0x72
+#define CEC_OP_SYSTEM_AUDIO_MODE_REQUEST	0x70
+#define CEC_OP_SYSTEM_AUDIO_MODE_STATUS		0x7e
+
+/* Audio Rate Control Feature */
+#define CEC_OP_SET_AUDIO_RATE			0x9a
+
+/* Audio Return Channel Control Feature */
+#define CEC_OP_INITIATE_ARC			0xc0
+#define CEC_OP_REPORT_ARC_INITIATED		0xc1
+#define CEC_OP_REPORT_ARC_TERMINATED		0xc2
+#define CEC_OP_REQUEST_ARC_INITIATION		0xc3
+#define CEC_OP_REQUEST_ARC_TERMINATION		0xc4
+#define CEC_OP_TERMINATE_ARC			0xc5
+
+/* Dynamic Audio Lipsync Feature, HDMI 2.0 */
+#define CEC_OP_REQUEST_CURRENT_LATENCY		0xa7
+#define CEC_OP_REPORT_CURRENT_LATENCY		0xa8
+
+/* Capability Discovery and Control Feature */
+#define CEC_OP_CDC_MESSAGE			0xf8
+
+/* Events */
+/* Event that occurs when a cable is connected */
+#define CEC_EVENT_CONNECT	1
+/* Event that occurs when all logical addresses were claimed */
+#define CEC_EVENT_READY		2
+/* Event that is sent when the cable is disconnected */
+#define CEC_EVENT_DISCONNECT	3
+/* This event is sent when a reply to a message is received */
+#define CEC_EVENT_GOT_REPLY	4
+
+/* ioctls */
+
+/* issue a CEC command */
+#define CEC_G_CAPS		_IOWR('a', 0, struct cec_caps)
+#define CEC_TRANSMIT		_IOWR('a', 1, struct cec_msg)
+#define CEC_RECEIVE		_IOWR('a', 2, struct cec_msg)
+
+/*
+   Configure the CEC adapter. It sets the device type and which
+   logical types it will try to claim. It will return which
+   logical addresses it could actually claim.
+   An error is returned if the adapter is disabled or if there
+   is no physical address assigned.
+ */
+
+#define CEC_G_ADAP_LOG_ADDRS	_IOR('a', 3, struct cec_log_addrs)
+#define CEC_S_ADAP_LOG_ADDRS	_IOWR('a', 4, struct cec_log_addrs)
+
+/*
+   Enable/disable the adapter. The Set state ioctl may not
+   be available if that is handled internally.
+ */
+#define CEC_G_ADAP_STATE	_IOR('a', 5, __u32)
+#define CEC_S_ADAP_STATE	_IOW('a', 6, __u32)
+
+/*
+   phys_addr is either 0 (if this is the CEC root device)
+   or a valid physical address obtained from the sink's EDID
+   as read by this CEC device (if this is a source device)
+   or a physical address obtained and modified from a sink
+   EDID and used for a sink CEC device.
+   If nothing is connected, then phys_addr is 0xffff.
+   See HDMI 1.4b, section 8.7 (Physical Address).
+
+   The Set ioctl may not be available if that is handled
+   internally.
+ */
+#define CEC_G_ADAP_PHYS_ADDR	_IOR('a', 7, __u16)
+#define CEC_S_ADAP_PHYS_ADDR	_IOW('a', 8, __u16)
+
+#define CEC_G_EVENT		_IOWR('a', 9, struct cec_event)
+/*
+   Read and set the vendor ID of the CEC adapter.
+ */
+#define CEC_G_VENDOR_ID		_IOR('a', 10, __u32)
+#define CEC_S_VENDOR_ID		_IOW('a', 11, __u32)
+/*
+   Enable/disable the passthrough mode
+ */
+#define CEC_G_PASSTHROUGH	_IOR('a', 12, __u32)
+#define CEC_S_PASSTHROUGH	_IOW('a', 13, __u32)
+
+#endif
-- 
1.7.9.5

