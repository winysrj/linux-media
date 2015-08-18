Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:3550 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbbHRIi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:38:59 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 07/15] cec: add HDMI CEC framework
Date: Tue, 18 Aug 2015 10:26:32 +0200
Message-Id: <87a579ddacf90718a166fbb8a777b5d8cd05200b.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
minor additions]
Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                    |   12 +
 drivers/media/Kconfig          |    6 +
 drivers/media/Makefile         |    2 +
 drivers/media/cec.c            | 1903 ++++++++++++++++++++++++++++++++++++++++
 include/media/cec.h            |  178 ++++
 include/uapi/linux/Kbuild      |    2 +
 include/uapi/linux/cec-funcs.h | 1771 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/cec.h       |  781 +++++++++++++++++
 8 files changed, 4655 insertions(+)
 create mode 100644 drivers/media/cec.c
 create mode 100644 include/media/cec.h
 create mode 100644 include/uapi/linux/cec-funcs.h
 create mode 100644 include/uapi/linux/cec.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e0946a0..2904a66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2553,6 +2553,18 @@ F:	drivers/net/ieee802154/cc2520.c
 F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
+CEC DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Supported
+F:	drivers/media/cec.c
+F:	drivers/media/rc/keymaps/rc-cec.c
+F:	include/media/cec.h
+F:	include/uapi/linux/cec.h
+F:	include/uapi/linux/cec-funcs.h
+
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
 L:	linuxppc-dev@lists.ozlabs.org
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3ef3d6c..48e44f5 100644
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
index 0000000..6c485d3
--- /dev/null
+++ b/drivers/media/cec.c
@@ -0,0 +1,1903 @@
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
+MODULE_PARM_DESC(debug, "debug level (0-2)");
+
+#define dprintk(lvl, fmt, arg...)					\
+	do {								\
+		if (lvl <= debug)					\
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
+	struct cec_fh *fh = filp->private_data;
+
+	return &fh->adap->devnode;
+}
+
+static bool cec_pa_are_adjacent(const struct cec_adapter *adap, u16 pa1, u16 pa2)
+{
+	u16 mask = 0xf000;
+	int i;
+
+	if (pa1 == CEC_PHYS_ADDR_INVALID || pa2 == CEC_PHYS_ADDR_INVALID)
+		return false;
+	for (i = 0; i < 3; i++) {
+		if ((pa1 & mask) != (pa2 & mask))
+			break;
+		mask = (mask >> 4) | 0xf000;
+	}
+	if ((pa1 & ~mask) || (pa2 & ~mask))
+		return false;
+	if (!(pa1 & mask) ^ !(pa2 & mask))
+		return true;
+	return false;
+}
+
+static bool cec_la_are_adjacent(const struct cec_adapter *adap, u8 la1, u8 la2)
+{
+	u16 pa1 = adap->phys_addrs[la1];
+	u16 pa2 = adap->phys_addrs[la2];
+
+	return cec_pa_are_adjacent(adap, pa1, pa2);
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
+static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
+{
+	struct cec_msg_entry *entry;
+	struct cec_event *ev = &fh->events[CEC_EVENT_LOST_MSGS - 1];
+
+	mutex_lock(&fh->lock);
+	if (fh->queued_msgs == CEC_MAX_MSG_QUEUE_SZ)
+		goto lost_msgs;
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (entry == NULL)
+		goto lost_msgs;
+
+	entry->msg = *msg;
+	list_add(&entry->list, &fh->msgs);
+	fh->queued_msgs++;
+	mutex_unlock(&fh->lock);
+	wake_up_interruptible(&fh->wait);
+	return;
+
+lost_msgs:
+	if (ev->event == 0) {
+		ev->ts = ktime_get_ns();
+		ev->event = CEC_EVENT_LOST_MSGS;
+	}
+	mutex_unlock(&fh->lock);
+	wake_up_interruptible(&fh->wait);
+}
+
+static void cec_queue_msg_monitor(struct cec_adapter *adap,
+				  const struct cec_msg *msg)
+{
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.fhs_lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list) {
+		if (fh->monitor)
+			cec_queue_msg_fh(fh, msg);
+	}
+	mutex_unlock(&adap->devnode.fhs_lock);
+}
+
+static void cec_post_state_event_fh(struct cec_adapter *adap,
+				    struct cec_fh *fh, u64 ts)
+{
+	struct cec_event *ev = &fh->events[CEC_EVENT_STATE_CHANGE - 1];
+	struct cec_event_state_change *ch = &ev->state_change;
+
+	mutex_lock(&fh->lock);
+	ev->ts = ts;
+	ev->event = CEC_EVENT_STATE_CHANGE;
+	if (!adap->is_enabled)
+		ch->state = CEC_EVENT_STATE_DISABLED;
+	else if (adap->is_configuring)
+		ch->state = CEC_EVENT_STATE_CONFIGURING;
+	else if (adap->is_configured)
+		ch->state = CEC_EVENT_STATE_CONFIGURED;
+	else
+		ch->state = CEC_EVENT_STATE_UNCONFIGURED;
+	mutex_unlock(&fh->lock);
+	wake_up_interruptible(&fh->wait);
+}
+
+static void cec_post_state_event(struct cec_adapter *adap)
+{
+	u64 ts = ktime_get_ns();
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.fhs_lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list)
+		cec_post_state_event_fh(adap, fh, ts);
+	mutex_unlock(&adap->devnode.fhs_lock);
+}
+
+static void cec_data_completed(struct cec_data *data)
+{
+	if (data->blocking) {
+		/*
+		 * Someone is blocking so mark the message as completed
+		 * and call complete.
+		 */
+		data->completed = true;
+		complete(&data->c);
+	} else {
+		/*
+		 * No blocking, so just queue the message if needed and
+		 * free the memory.
+		 */
+		if (data->fh)
+			cec_queue_msg_fh(data->fh, &data->msg);
+		kfree(data);
+	}
+}
+
+/*
+ * Main CEC state machine
+ *
+ * Wait until the thread should be stopped, or we're not transmitting and
+ * a new transmit message is queued up, in which case we start transmitting
+ * that message. When the adapter finished transmitting the message it will
+ * call cec_transmit_done().
+ *
+ * If the adapter is disabled, then remove all queued messages instead.
+ */
+static int cec_thread_func(void *_adap)
+{
+	struct cec_adapter *adap = _adap;
+
+	for (;;) {
+		struct cec_data *data;
+		u32 timeout;
+
+		wait_event_interruptible(adap->kthread_waitq,
+			kthread_should_stop() ||
+			(!adap->transmitting &&
+			 !list_empty(&adap->transmit_queue)));
+
+		if (kthread_should_stop())
+			break;
+		mutex_lock(&adap->lock);
+
+		if (!adap->is_enabled) {
+			while (!list_empty(&adap->transmit_queue)) {
+				data = list_first_entry(&adap->transmit_queue,
+							struct cec_data, list);
+				list_del(&data->list);
+				data->msg.ts = ktime_get_ns();
+				data->msg.status = CEC_TX_STATUS_RETRY_TIMEOUT;
+				data->msg.reply = 0;
+				cec_data_completed(data);
+			}
+			goto unlock;
+		}
+
+		if (list_empty(&adap->transmit_queue))
+			goto unlock;
+
+		data = list_first_entry(&adap->transmit_queue,
+					struct cec_data, list);
+		list_del(&data->list);
+		adap->transmitting = data;
+		timeout = data->msg.len == 1 ? 200 : 1000;
+		adap->adap_transmit(adap, timeout, &data->msg);
+unlock:
+		mutex_unlock(&adap->lock);
+	}
+	return 0;
+}
+
+void cec_transmit_done(struct cec_adapter *adap, u32 status)
+{
+	dprintk(2, "cec_transmit_done\n");
+	mutex_lock(&adap->lock);
+	if (WARN_ON(adap->transmitting == NULL)) {
+		dprintk(0, "cec_transmit_done without an ongoing transmit!\n");
+	} else {
+		struct cec_data *data = adap->transmitting;
+		struct cec_msg *msg = &data->msg;
+
+		msg->ts = ktime_get_ns();
+		msg->status = status;
+		if (status || !adap->is_configured)
+			msg->reply = 0;
+		/* Queue transmitted message for monitoring purposes */
+		cec_queue_msg_monitor(adap, msg);
+		adap->transmitting = NULL;
+		if (msg->reply) {
+			/*
+			 * We want to wait for a reply, so queue the message to
+			 * the wait_queue and schedule a timeout task.
+			 */
+			if (msg->timeout == 0)
+				msg->timeout = 1000;
+			list_add_tail(&data->list, &adap->wait_queue);
+			schedule_delayed_work(&data->work,
+					      msecs_to_jiffies(msg->timeout));
+		} else {
+			cec_data_completed(data);
+		}
+		/*
+		 * Wake up the main thread to see if another message is ready
+		 * for transmitting.
+		 */
+		wake_up_interruptible(&adap->kthread_waitq);
+	}
+	mutex_unlock(&adap->lock);
+}
+EXPORT_SYMBOL_GPL(cec_transmit_done);
+
+/*
+ * Called when waiting for a reply times out.
+ */
+static void cec_wait_timeout(struct work_struct *work)
+{
+	struct cec_data *data = container_of(work, struct cec_data, work.work);
+	struct cec_adapter *adap = data->adap;
+
+	mutex_lock(&adap->lock);
+	if (list_empty(&data->list))
+		goto unlock;
+
+	list_del_init(&data->list);
+	data->msg.ts = ktime_get_ns();
+	data->msg.status = CEC_TX_STATUS_REPLY_TIMEOUT;
+	cec_data_completed(data);
+unlock:
+	mutex_unlock(&adap->lock);
+}
+
+static int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
+			       struct cec_fh *fh, bool block)
+{
+	struct cec_data *data;
+	int res = 0;
+
+	if (msg->len == 0 || msg->len > 16) {
+		dprintk(1, "cec_transmit_msg: invalid length %d\n", msg->len);
+		return -EINVAL;
+	}
+	if (msg->reply && (msg->len == 1 || (cec_msg_is_broadcast(msg)))) {
+		dprintk(1, "cec_transmit_msg: can't reply for poll or broadcast msg\n");
+		return -EINVAL;
+	}
+	if (msg->len > 1 && !cec_msg_is_broadcast(msg) &&
+	    cec_msg_initiator(msg) == cec_msg_destination(msg)) {
+		dprintk(1, "cec_transmit_msg: initiator == destination\n");
+		return -EINVAL;
+	}
+	if (cec_msg_initiator(msg) != 0xf &&
+	    cec_log_addr2idx(adap, cec_msg_initiator(msg)) < 0) {
+		dprintk(1, "cec_transmit_msg: initiator has unknown logical address\n");
+		return -EINVAL;
+	}
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (msg->len == 1)
+		dprintk(2, "cec_transmit_msg: 0x%02x%s\n",
+				msg->msg[0], !block ? " nb" : "");
+	else if (msg->reply)
+		dprintk(2, "cec_transmit_msg: 0x%02x 0x%02x (wait for 0x%02x)%s\n",
+				msg->msg[0], msg->msg[1],
+				msg->reply, !block ? " nb" : "");
+	else
+		dprintk(2, "cec_transmit_msg: 0x%02x 0x%02x%s\n",
+				msg->msg[0], msg->msg[1],
+				!block ? " nb" : "");
+
+	if (msg->len > 1 && msg->msg[1] == CEC_MSG_CDC_MESSAGE) {
+		msg->msg[2] = adap->phys_addr >> 8;
+		msg->msg[3] = adap->phys_addr & 0xff;
+	}
+	data->msg = *msg;
+	data->fh = fh;
+	data->adap = adap;
+	data->blocking = block;
+	init_completion(&data->c);
+	INIT_DELAYED_WORK(&data->work, cec_wait_timeout);
+
+	mutex_lock(&adap->lock);
+	if (adap->is_configured || adap->is_configuring) {
+		data->msg.sequence = adap->sequence++;
+		list_add_tail(&data->list, &adap->transmit_queue);
+		if (adap->transmitting == NULL)
+			wake_up_interruptible(&adap->kthread_waitq);
+	} else {
+		res = -ENONET;
+		kfree(data);
+	}
+	mutex_unlock(&adap->lock);
+	if (res || !block)
+		return res;
+	res = wait_for_completion_interruptible(&data->c);
+	mutex_lock(&adap->lock);
+	if (data->completed) {
+		*msg = data->msg;
+		kfree(data);
+		res = 0;
+	} else {
+		data->blocking = false;
+		data->fh = NULL;
+	}
+	mutex_unlock(&adap->lock);
+	return res;
+}
+
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+		     bool block)
+{
+	return cec_transmit_msg_fh(adap, msg, NULL, block);
+}
+EXPORT_SYMBOL_GPL(cec_transmit_msg);
+
+static int cec_report_features(struct cec_adapter *adap, unsigned la_idx)
+{
+	struct cec_msg msg = { };
+	u8 *features = adap->features[la_idx];
+	bool op_is_dev_features = false;
+	unsigned idx;
+
+	if (adap->cec_version < CEC_OP_CEC_VERSION_2_0)
+		return 0;
+
+	/* Report Features */
+	msg.msg[0] = (adap->log_addr[la_idx] << 4) | 0x0f;
+	msg.len = 4;
+	msg.msg[1] = CEC_MSG_REPORT_FEATURES;
+	msg.msg[2] = adap->cec_version;
+	msg.msg[3] = adap->all_device_types[la_idx];
+
+	/* Write RC Profiles first, then Device Features */
+	for (idx = 0; idx < sizeof(adap->features[0]); idx++) {
+		msg.msg[msg.len++] = features[idx];
+		if ((features[idx] & CEC_OP_FEAT_EXT) == 0) {
+			if (op_is_dev_features)
+				break;
+			op_is_dev_features = true;
+		}
+	}
+	return cec_transmit_msg(adap, &msg, false);
+}
+
+static int cec_report_phys_addr(struct cec_adapter *adap, unsigned la_idx)
+{
+	struct cec_msg msg = { };
+
+	/* Report Physical Address */
+	msg.msg[0] = (adap->log_addr[la_idx] << 4) | 0x0f;
+	cec_msg_report_physical_addr(&msg, adap->phys_addr,
+				     adap->prim_device[la_idx]);
+	dprintk(2, "config: la %d pa %x.%x.%x.%x\n",
+			adap->log_addr[la_idx],
+			cec_phys_addr_exp(adap->phys_addr));
+	return cec_transmit_msg(adap, &msg, false);
+}
+
+static int cec_feature_abort_reason(struct cec_adapter *adap,
+				    struct cec_msg *msg, u8 reason)
+{
+	struct cec_msg tx_msg = { };
+
+	/*
+	 * Don't reply with CEC_MSG_FEATURE_ABORT to a CEC_MSG_FEATURE_ABORT
+	 * message!
+	 */
+	if (msg->msg[1] == CEC_MSG_FEATURE_ABORT)
+		return 0;
+	cec_msg_set_reply_to(&tx_msg, msg);
+	cec_msg_feature_abort(&tx_msg, msg->msg[1], reason);
+	return cec_transmit_msg(adap, &tx_msg, false);
+}
+
+static int cec_feature_abort(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	return cec_feature_abort_reason(adap, msg,
+					CEC_OP_ABORT_UNRECOGNIZED_OP);
+}
+
+static int cec_feature_refused(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	return cec_feature_abort_reason(adap, msg,
+					CEC_OP_ABORT_REFUSED);
+}
+
+/*
+ * Called when a CEC message is received. This function will do any
+ * necessary core processing. The is_reply bool is true if this message
+ * is a reply to an earlier transmit.
+ */
+static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
+			      bool is_reply)
+{
+	bool is_broadcast = cec_msg_is_broadcast(msg);
+	u8 dest_laddr = cec_msg_destination(msg);
+	u8 init_laddr = cec_msg_initiator(msg);
+	u8 devtype = cec_log_addr2dev(adap, dest_laddr);
+	int la_idx = cec_log_addr2idx(adap, dest_laddr);
+	bool is_directed = la_idx >= 0;
+	bool from_unregistered = init_laddr == 0xf;
+	u16 cdc_phys_addr;
+	struct cec_msg tx_cec_msg = { };
+	u8 *tx_msg = tx_cec_msg.msg;
+
+	dprintk(1, "cec_receive_notify: %02x %02x\n", msg->msg[0], msg->msg[1]);
+
+	if (!is_directed && !is_broadcast) {
+		if (adap->passthrough)
+			goto skip_processing;
+		return 0;
+	}
+
+	if (adap->received) {
+		/* Allow drivers to process the message first */
+		if (adap->received(adap, msg) != -ENOMSG)
+			return 0;
+	}
+
+	/*
+	 * ARC, CDC and REPORT_PHYSICAL_ADDR, CEC_MSG_USER_CONTROL_PRESSED and
+	 * CEC_MSG_USER_CONTROL_RELEASED messages always have to be
+	 * handled by the CEC core, even if the passthrough mode is on.
+	 * ARC and CDC messages will never be seen even if passthrough is
+	 * on, but the others are just passed on normally.
+	 */
+	switch (msg->msg[1]) {
+	case CEC_MSG_INITIATE_ARC:
+	case CEC_MSG_TERMINATE_ARC:
+	case CEC_MSG_REQUEST_ARC_INITIATION:
+	case CEC_MSG_REQUEST_ARC_TERMINATION:
+	case CEC_MSG_REPORT_ARC_INITIATED:
+	case CEC_MSG_REPORT_ARC_TERMINATED:
+		/* ARC messages are never passed through if CAP_ARC is set */
+
+		/* Abort/ignore if ARC is not supported */
+		if (!(adap->capabilities & CEC_CAP_ARC)) {
+			/* Just abort if nobody is listening */
+			if (is_directed && !is_reply && !adap->cec_owner)
+				return cec_feature_abort(adap, msg);
+			goto skip_processing;
+		}
+		/* Ignore if addressing is wrong */
+		if (is_broadcast || from_unregistered)
+			return 0;
+		break;
+
+	case CEC_MSG_CDC_MESSAGE:
+		switch (msg->msg[4]) {
+		case CEC_MSG_CDC_HPD_REPORT_STATE:
+		case CEC_MSG_CDC_HPD_SET_STATE:
+			/*
+			 * CDC_HPD messages are never passed through if
+			 * CAP_CDC_HPD is set
+			 */
+
+			/* Ignore if CDC_HPD is not supported */
+			if (!(adap->capabilities & CEC_CAP_CDC_HPD))
+				goto skip_processing;
+			/* or the addressing is wrong */
+			if (!is_broadcast)
+				return 0;
+			break;
+		default:
+			/* Other CDC messages are ignored */
+			goto skip_processing;
+		}
+		break;
+
+	case CEC_MSG_GET_CEC_VERSION:
+	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
+	case CEC_MSG_ABORT:
+	case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
+	case CEC_MSG_GIVE_PHYSICAL_ADDR:
+	case CEC_MSG_GIVE_OSD_NAME:
+	case CEC_MSG_GIVE_FEATURES:
+		/*
+		 * Skip processing these messages if the passthrough mode
+		 * is on.
+		 */
+		if (adap->passthrough)
+			goto skip_processing;
+		/* Ignore if addressing is wrong */
+		if (is_broadcast || from_unregistered)
+			return 0;
+		break;
+
+	case CEC_MSG_USER_CONTROL_PRESSED:
+	case CEC_MSG_USER_CONTROL_RELEASED:
+		/* Wrong addressing mode: don't process */
+		if (is_broadcast || from_unregistered)
+			goto skip_processing;
+		break;
+
+	case CEC_MSG_REPORT_PHYSICAL_ADDR:
+		/*
+		 * This message is always processed, regardless of the
+		 * passthrough setting.
+		 *
+		 * Exception: don't process if wrong addressing mode.
+		 */
+		if (!is_broadcast)
+			goto skip_processing;
+		break;
+
+	default:
+		break;
+	}
+
+	cec_msg_set_reply_to(&tx_cec_msg, msg);
+
+	switch (msg->msg[1]) {
+	/* The following messages are processed but still passed through */
+	case CEC_MSG_REPORT_PHYSICAL_ADDR:
+		adap->phys_addrs[init_laddr] =
+			(msg->msg[2] << 8) | msg->msg[3];
+		dprintk(1, "Reported physical address %04x for logical address %d\n",
+			adap->phys_addrs[init_laddr], init_laddr);
+		break;
+
+	case CEC_MSG_USER_CONTROL_PRESSED:
+		if (!(adap->capabilities & CEC_CAP_RC))
+			break;
+
+		switch (msg->msg[2]) {
+		/* Play function, this message can have variable length
+		 * depending on the specific play function that is used.
+		 */
+		case 0x60:
+			if (msg->len == 2)
+				rc_keydown(adap->rc, RC_TYPE_CEC,
+					   msg->msg[2], 0);
+			else
+				rc_keydown(adap->rc, RC_TYPE_CEC,
+					   msg->msg[2] << 8 | msg->msg[3], 0);
+			break;
+		/* Other function messages that are not handled.
+		 * Currently the RC framework does not allow to supply an
+		 * additional parameter to a keypress. These "keys" contain
+		 * other information such as channel number, an input number
+		 * etc.
+		 * For the time being these messages are not processed by the
+		 * framework and are simply forwarded to the user space.
+		 */
+		case 0x56: case 0x57:
+		case 0x67: case 0x68: case 0x69: case 0x6a:
+			break;
+		default:
+			rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2], 0);
+			break;
+		}
+		break;
+
+	case CEC_MSG_USER_CONTROL_RELEASED:
+		if (!(adap->capabilities & CEC_CAP_RC))
+			break;
+		rc_keyup(adap->rc);
+		break;
+
+	/*
+	 * The remaining messages are only processed if the passthrough mode
+	 * is off.
+	 */
+	case CEC_MSG_GET_CEC_VERSION:
+		cec_msg_cec_version(&tx_cec_msg, adap->cec_version);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_GIVE_PHYSICAL_ADDR:
+		/* Do nothing for CEC switches using addr 15 */
+		if (devtype == CEC_OP_PRIM_DEVTYPE_SWITCH && dest_laddr == 15)
+			return 0;
+		cec_msg_report_physical_addr(&tx_cec_msg, adap->phys_addr, devtype);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
+		if (!(adap->capabilities & CEC_CAP_VENDOR_ID) ||
+		    adap->vendor_id == CEC_VENDOR_ID_NONE)
+			return cec_feature_abort(adap, msg);
+		cec_msg_device_vendor_id(&tx_cec_msg, adap->vendor_id);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_ABORT:
+		/* Do nothing for CEC switches */
+		if (devtype == CEC_OP_PRIM_DEVTYPE_SWITCH)
+			return 0;
+		return cec_feature_refused(adap, msg);
+
+	case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
+		/* Do nothing for CEC switches */
+		if (devtype == CEC_OP_PRIM_DEVTYPE_SWITCH)
+			return 0;
+		cec_msg_report_power_status(&tx_cec_msg, adap->pwr_state);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_GIVE_OSD_NAME: {
+		if (adap->osd_name[0] == 0)
+			return cec_feature_abort(adap, msg);
+		cec_msg_set_osd_name(&tx_cec_msg, adap->osd_name);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+	}
+
+	case CEC_MSG_GIVE_FEATURES:
+		if (adap->cec_version >= CEC_OP_CEC_VERSION_2_0)
+			return cec_report_features(adap, la_idx);
+		return 0;
+
+	case CEC_MSG_REQUEST_ARC_INITIATION:
+		if (!adap->is_source ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		cec_msg_initiate_arc(&tx_cec_msg, false);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_REQUEST_ARC_TERMINATION:
+		if (!adap->is_source ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		cec_msg_terminate_arc(&tx_cec_msg, false);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_INITIATE_ARC:
+		if (!adap->ninputs ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		if (adap->sink_initiate_arc && adap->sink_initiate_arc(adap))
+			return 0;
+		cec_msg_report_arc_initiated(&tx_cec_msg);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_TERMINATE_ARC:
+		if (!adap->ninputs ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		if (adap->sink_terminate_arc && adap->sink_terminate_arc(adap))
+			return 0;
+		cec_msg_report_arc_terminated(&tx_cec_msg);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_REPORT_ARC_INITIATED:
+		if (!adap->is_source ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		if (adap->source_arc_initiated)
+			adap->source_arc_initiated(adap);
+		return 0;
+
+	case CEC_MSG_REPORT_ARC_TERMINATED:
+		if (!adap->is_source ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		if (adap->source_arc_terminated)
+			adap->source_arc_terminated(adap);
+		return 0;
+
+	case CEC_MSG_CDC_MESSAGE: {
+		unsigned shift;
+		unsigned input_port;
+
+		cdc_phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+		if (!cec_pa_are_adjacent(adap, cdc_phys_addr, adap->phys_addr))
+			return 0;
+
+		switch (msg->msg[4]) {
+		case CEC_MSG_CDC_HPD_REPORT_STATE:
+			/*
+			 * Ignore if we're not a sink or the message comes from
+			 * an upstream device.
+			 */
+			if (!adap->ninputs || cdc_phys_addr <= adap->phys_addr)
+				return 0;
+			adap->sink_cdc_hpd(adap, msg->msg[5] >> 4, msg->msg[5] & 0xf);
+			return 0;
+		case CEC_MSG_CDC_HPD_SET_STATE:
+			/* Ignore if we're not a source */
+			if (!adap->is_source)
+				return 0;
+			break;
+		default:
+			return 0;
+		}
+
+		input_port = msg->msg[5] >> 4;
+		for (shift = 0; shift < 16; shift += 4) {
+			if (cdc_phys_addr & (0xf000 >> shift))
+				continue;
+			cdc_phys_addr |= input_port << (12 - shift);
+			break;
+		}
+		if (cdc_phys_addr != adap->phys_addr)
+			return 0;
+
+		tx_cec_msg.len = 6;
+		/* broadcast reply */
+		tx_msg[0] = (adap->log_addr[0] << 4) | 0xf;
+		cec_msg_cdc_hpd_report_state(&tx_cec_msg,
+			     msg->msg[5] & 0xf,
+			     adap->source_cdc_hpd(adap, msg->msg[5] & 0xf));
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+	}
+
+	default:
+		/*
+		 * Unprocessed messages are aborted if userspace isn't doing
+		 * any processing either.
+		 */
+		if (is_directed && !is_reply && !adap->cec_owner)
+			return cec_feature_abort(adap, msg);
+		break;
+	}
+
+skip_processing:
+	if (!is_reply && adap->cec_owner)
+		cec_queue_msg_fh(adap->cec_owner, msg);
+	return 0;
+}
+
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	struct cec_data *data;
+	bool is_reply = false;
+
+	mutex_lock(&adap->lock);
+	msg->ts = ktime_get_ns();
+	msg->status = CEC_RX_STATUS_READY;
+	msg->sequence = msg->reply = msg->timeout = 0;
+	memset(msg->reserved, 0, sizeof(msg->reserved));
+	dprintk(2, "cec_received_msg: %02x %02x\n", msg->msg[0], msg->msg[1]);
+	if (msg->len > 1 && msg->msg[1] != CEC_MSG_CDC_MESSAGE) {
+		u8 cmd = msg->msg[1];
+
+		if (cmd == CEC_MSG_FEATURE_ABORT)
+			cmd = msg->msg[2];
+		list_for_each_entry(data, &adap->wait_queue, list) {
+			struct cec_msg *dst = &data->msg;
+
+			if (cec_msg_initiator(msg) != cec_msg_destination(dst) ||
+			    cmd != dst->reply)
+				continue;
+			msg->sequence = dst->sequence;
+			*dst = *msg;
+			if (msg->msg[1] == CEC_MSG_FEATURE_ABORT) {
+				dst->reply = 0;
+				dst->status = CEC_TX_STATUS_FEATURE_ABORT;
+			}
+			list_del_init(&data->list);
+			if (!cancel_delayed_work(&data->work)) {
+				mutex_unlock(&adap->lock);
+				flush_scheduled_work();
+				mutex_lock(&adap->lock);
+			}
+			if (data->blocking || data->fh)
+				is_reply = true;
+			cec_data_completed(data);
+			break;
+		}
+	}
+	mutex_unlock(&adap->lock);
+	cec_queue_msg_monitor(adap, msg);
+
+	if (msg->len <= 1)
+		return;
+
+	cec_receive_notify(adap, msg, is_reply);
+}
+EXPORT_SYMBOL_GPL(cec_received_msg);
+
+static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
+{
+	int res;
+
+	do {
+		mutex_lock(&fh->lock);
+		if (fh->queued_msgs) {
+			struct cec_msg_entry *entry =
+				list_first_entry(&fh->msgs,
+						 struct cec_msg_entry, list);
+
+			list_del(&entry->list);
+			*msg = entry->msg;
+			kfree(entry);
+			fh->queued_msgs--;
+			res = 0;
+		} else {
+			res = -EAGAIN;
+		}
+		mutex_unlock(&fh->lock);
+		if (!block || !res)
+			break;
+		if (msg->timeout) {
+			res = wait_event_interruptible_timeout(fh->wait,
+				fh->queued_msgs,
+				msecs_to_jiffies(msg->timeout));
+			if (res == 0)
+				res = -ETIMEDOUT;
+			else if (res > 0)
+				res = 0;
+		} else {
+			res = wait_event_interruptible(fh->wait,
+				fh->queued_msgs);
+		}
+	} while (!res);
+	return res;
+}
+
+static void cec_post_inputs_event_fh(struct cec_adapter *adap,
+				     struct cec_fh *fh, u64 ts)
+{
+	struct cec_event *ev = &fh->events[CEC_EVENT_INPUTS_CHANGE - 1];
+	struct cec_event_inputs_change *ch = &ev->inputs_change;
+
+	mutex_lock(&fh->lock);
+	if (ev->event == 0) {
+		ev->ts = ts;
+		ev->event = CEC_EVENT_INPUTS_CHANGE;
+	}
+	ch->changed_inputs |=
+		adap->connected_inputs ^ ch->connected_inputs;
+	ch->connected_inputs = adap->connected_inputs;
+	mutex_unlock(&fh->lock);
+	wake_up_interruptible(&fh->wait);
+}
+
+static void cec_post_inputs_event(struct cec_adapter *adap)
+{
+	u64 ts = ktime_get_ns();
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.fhs_lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list)
+		cec_post_inputs_event_fh(adap, fh, ts);
+	mutex_unlock(&adap->devnode.fhs_lock);
+}
+
+int cec_enable(struct cec_adapter *adap, bool enable)
+{
+	int ret = 0;
+
+	mutex_lock(&adap->lock);
+	if (enable == adap->is_enabled)
+		goto unlock;
+	ret = adap->adap_enable(adap, enable);
+	if (ret)
+		goto unlock;
+	adap->is_configured = false;
+	adap->is_enabled = enable;
+	if (!enable) {
+		adap->num_log_addrs = 0;
+		memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
+		wake_up_interruptible(&adap->kthread_waitq);
+	}
+	cec_post_state_event(adap);
+unlock:
+	mutex_unlock(&adap->lock);
+	return ret;
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
+	struct cec_msg msg = { };
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
+	dprintk(2, "physical address: %x.%x.%x.%x, claim %d logical addresses\n",
+			cec_phys_addr_exp(adap->phys_addr),
+			log_addrs->num_log_addrs);
+	strlcpy(adap->osd_name, log_addrs->osd_name, sizeof(adap->osd_name));
+	adap->num_log_addrs = 0;
+	cec_post_state_event(adap);
+
+	/* TODO: remember last used logical addr type to achieve
+	   faster logical address polling by trying that one first.
+	 */
+	for (i = 0; i < log_addrs->num_log_addrs; i++) {
+		const u8 *la_list = type2addrs[log_addrs->log_addr_type[i]];
+
+		if (kthread_should_stop()) {
+			err = -EINTR;
+			goto unconfigure;
+		}
+
+		for (j = 0; la_list[j] != CEC_LOG_ADDR_INVALID; j++) {
+			u8 log_addr = la_list[j];
+
+			if (claimed_addrs & (1 << log_addr))
+				continue;
+
+			/* Send polling message */
+			msg.len = 1;
+			msg.msg[0] = 0xf0 | log_addr;
+			msg.reply = 0;
+			err = cec_transmit_msg(adap, &msg, true);
+			if (err)
+				goto unconfigure;
+
+			if (msg.status == CEC_TX_STATUS_RETRY_TIMEOUT) {
+				unsigned idx = adap->num_log_addrs++;
+
+				/* Message not acknowledged, so this logical
+				   address is free to use. */
+				claimed_addrs |= 1 << log_addr;
+				adap->log_addr[idx] = log_addr;
+				log_addrs->log_addr[i] = log_addr;
+				adap->log_addr_type[idx] =
+					log_addrs->log_addr_type[i];
+				adap->prim_device[idx] =
+					log_addrs->primary_device_type[i];
+				adap->all_device_types[idx] =
+					log_addrs->all_device_types[i];
+				adap->phys_addrs[log_addr] = adap->phys_addr;
+				memcpy(adap->features[idx], log_addrs->features[i],
+				       sizeof(adap->features[idx]));
+				err = adap->adap_log_addr(adap, log_addr);
+				dprintk(2, "claim addr %d (%d)\n", log_addr,
+							adap->prim_device[idx]);
+				if (err)
+					goto unconfigure;
+
+				/*
+				 * Report Features must come first according
+				 * to CEC 2.0
+				 */
+				cec_report_features(adap, idx);
+				cec_report_phys_addr(adap, idx);
+				break;
+			}
+		}
+	}
+	if (adap->num_log_addrs == 0) {
+		if (log_addrs->num_log_addrs > 1)
+			dprintk(2, "could not claim last %d addresses\n",
+				log_addrs->num_log_addrs - 1);
+		adap->log_addr[0] = 15;
+		adap->log_addr_type[0] = CEC_LOG_ADDR_TYPE_UNREGISTERED;
+		adap->prim_device[0] = CEC_OP_PRIM_DEVTYPE_SWITCH;
+		adap->all_device_types[0] = CEC_OP_ALL_DEVTYPE_SWITCH;
+		err = adap->adap_log_addr(adap, 15);
+		dprintk(2, "claim addr %d (%d)\n", 15, adap->prim_device[0]);
+		if (err)
+			goto unconfigure;
+
+		adap->num_log_addrs = 1;
+		/* TODO: do we need to do this for an unregistered device? */
+		cec_report_phys_addr(adap, 0);
+	}
+	mutex_lock(&adap->lock);
+	adap->is_configured = true;
+	adap->is_configuring = false;
+	cec_post_state_event(adap);
+	mutex_unlock(&adap->lock);
+	return 0;
+
+unconfigure:
+	mutex_lock(&adap->lock);
+	adap->num_log_addrs = 0;
+	adap->is_configuring = false;
+	cec_post_state_event(adap);
+	mutex_unlock(&adap->lock);
+	return err;
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
+	return err;
+}
+
+int cec_claim_log_addrs(struct cec_adapter *adap,
+			struct cec_log_addrs *log_addrs, bool block)
+{
+	struct cec_log_addrs_int *cla_int;
+	int i;
+
+	if (!adap->is_enabled)
+		return -ENONET;
+
+	if (log_addrs->num_log_addrs > CEC_MAX_LOG_ADDRS) {
+		dprintk(1, "num_log_addrs > %d\n", CEC_MAX_LOG_ADDRS);
+		return -EINVAL;
+	}
+	if (log_addrs->num_log_addrs == 0) {
+		int err = adap->adap_log_addr(adap, CEC_LOG_ADDR_INVALID);
+
+		if (err)
+			return err;
+		mutex_lock(&adap->lock);
+		adap->is_configured = false;
+		adap->num_log_addrs = 0;
+		wake_up_interruptible(&adap->kthread_waitq);
+		cec_post_state_event(adap);
+		mutex_unlock(&adap->lock);
+		return 0;
+	}
+	if (log_addrs->cec_version != CEC_OP_CEC_VERSION_1_4 &&
+	    log_addrs->cec_version != CEC_OP_CEC_VERSION_2_0) {
+		dprintk(1, "unsupported CEC version\n");
+		return -EINVAL;
+	}
+	if (log_addrs->num_log_addrs > 1)
+		for (i = 0; i < log_addrs->num_log_addrs; i++)
+			if (log_addrs->log_addr_type[i] ==
+					CEC_LOG_ADDR_TYPE_UNREGISTERED) {
+				dprintk(1, "can't claim unregistered logical address\n");
+				return -EINVAL;
+			}
+	for (i = 0; i < log_addrs->num_log_addrs; i++) {
+		u8 *features = log_addrs->features[i];
+		bool op_is_dev_features = false;
+
+		if (log_addrs->primary_device_type[i] >
+					CEC_OP_PRIM_DEVTYPE_PROCESSOR) {
+			dprintk(1, "unknown primary device type\n");
+			return -EINVAL;
+		}
+		if (log_addrs->primary_device_type[i] == 2) {
+			dprintk(1, "invalid primary device type\n");
+			return -EINVAL;
+		}
+		if (log_addrs->log_addr_type[i] > CEC_LOG_ADDR_TYPE_UNREGISTERED) {
+			dprintk(1, "unknown logical address type\n");
+			return -EINVAL;
+		}
+		if (log_addrs->cec_version < CEC_OP_CEC_VERSION_2_0)
+			continue;
+
+		for (i = 0; i < sizeof(adap->features[0]); i++) {
+			if ((features[i] & 0x80) == 0) {
+				if (op_is_dev_features)
+					break;
+				op_is_dev_features = true;
+			}
+		}
+		if (!op_is_dev_features || i == sizeof(adap->features[0])) {
+			dprintk(1, "malformed features\n");
+			return -EINVAL;
+		}
+	}
+
+	/* For phys addr 0xffff only the Unregistered functionality is
+	   allowed. */
+	if (adap->phys_addr == CEC_PHYS_ADDR_INVALID &&
+	    (log_addrs->num_log_addrs > 1 ||
+	     log_addrs->log_addr_type[0] != CEC_LOG_ADDR_TYPE_UNREGISTERED)) {
+		dprintk(1, "physical addr 0xffff only allows unregistered logical address\n");
+		return -EINVAL;
+	}
+
+	cla_int = kzalloc(sizeof(*cla_int), GFP_KERNEL);
+	if (cla_int == NULL)
+		return -ENOMEM;
+	mutex_lock(&adap->lock);
+	if (adap->is_configuring || adap->is_configured) {
+		mutex_unlock(&adap->lock);
+		kfree(cla_int);
+		return -EBUSY;
+	}
+	adap->is_configuring = true;
+	mutex_unlock(&adap->lock);
+	init_completion(&cla_int->c);
+	cla_int->free_on_exit = !block;
+	cla_int->adap = adap;
+	cla_int->log_addrs = *log_addrs;
+	adap->kthread_config = kthread_run(cec_config_thread_func, cla_int,
+					   "ceccfg-%s", adap->name);
+	if (block) {
+		wait_for_completion(&cla_int->c);
+		*log_addrs = cla_int->log_addrs;
+		kfree(cla_int);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cec_claim_log_addrs);
+
+void cec_log_status(struct cec_adapter *adap)
+{
+	dprintk(0, "enabled: %d\n", adap->is_enabled);
+	dprintk(0, "configured: %d\n", adap->is_configured);
+	dprintk(0, "configuring: %d\n", adap->is_configuring);
+	dprintk(0, "phys_addr: %04x\n", adap->phys_addr);
+	dprintk(0, "number of LAs: %d\n", adap->num_log_addrs);
+	if (adap->cec_owner)
+		dprintk(0, "has owner\n");
+	if (adap->passthrough)
+		dprintk(0, "has passthrough\n");
+	if (mutex_is_locked(&adap->lock))
+		dprintk(0, "is locked\n");
+}
+EXPORT_SYMBOL_GPL(cec_log_status);
+
+void cec_connected_inputs(struct cec_adapter *adap, u16 connected_inputs)
+{
+	if (adap->connected_inputs != connected_inputs) {
+		adap->connected_inputs = connected_inputs;
+		if (cec_devnode_is_registered(&adap->devnode))
+			cec_post_inputs_event(adap);
+	}
+}
+EXPORT_SYMBOL_GPL(cec_connected_inputs);
+
+u8 cec_sink_cdc_hpd(struct cec_adapter *adap, u8 input_port, u8 cdc_hpd_state)
+{
+	struct cec_msg msg = { };
+	int err;
+
+	if (!adap->is_configured)
+		return CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE;
+
+	msg.msg[0] = (adap->log_addr[0] << 4) | 0xf;
+	cec_msg_cdc_hpd_set_state(&msg, input_port, cdc_hpd_state);
+	err = cec_transmit_msg(adap, &msg, false);
+	if (err)
+		return CEC_OP_HPD_ERROR_OTHER;
+	return CEC_OP_HPD_ERROR_NONE;
+}
+EXPORT_SYMBOL_GPL(cec_sink_cdc_hpd);
+
+static unsigned int cec_poll(struct file *filp,
+			       struct poll_table_struct *poll)
+{
+	struct cec_fh *fh = filp->private_data;
+	struct cec_adapter *adap = fh->adap;
+	unsigned res = 0;
+
+	if (!cec_devnode_is_registered(&adap->devnode))
+		return POLLERR | POLLHUP;
+	mutex_lock(&adap->lock);
+	if (adap->is_configured)
+		res |= POLLOUT | POLLWRNORM;
+	if (fh->queued_msgs)
+		res |= POLLIN | POLLRDNORM;
+	if (fh->events)
+		res |= POLLPRI;
+	poll_wait(filp, &fh->wait, poll);
+	mutex_unlock(&adap->lock);
+	return res;
+}
+
+static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct cec_fh *fh = filp->private_data;
+	struct cec_adapter *adap = fh->adap;
+	bool block = !(filp->f_flags & O_NONBLOCK);
+	void __user *parg = (void __user *)arg;
+	int err;
+
+	if (!cec_devnode_is_registered(&adap->devnode))
+		return -EIO;
+
+	switch (cmd) {
+	case CEC_ADAP_G_CAPS: {
+		struct cec_caps caps;
+
+		caps.available_log_addrs = adap->available_log_addrs;
+		caps.capabilities = adap->capabilities;
+		caps.ninputs = adap->ninputs;
+		memset(caps.reserved, 0, sizeof(caps.reserved));
+		if (copy_to_user(parg, &caps, sizeof(caps)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_TRANSMIT: {
+		struct cec_msg msg;
+
+		if (!(adap->capabilities & CEC_CAP_IO))
+			return -ENOTTY;
+		if (copy_from_user(&msg, parg, sizeof(msg)))
+			return -EFAULT;
+		memset(msg.reserved, 0, sizeof(msg.reserved));
+		if (!adap->is_configured)
+			return -ENONET;
+		if (fh->monitor)
+			return -EPERM;
+		if (adap->cec_owner && adap->cec_owner != fh)
+			return -EBUSY;
+		if (block || !msg.reply)
+			fh = NULL;
+
+		err = cec_transmit_msg_fh(adap, &msg, fh, block);
+		if (err)
+			return err;
+		if (copy_to_user(parg, &msg, sizeof(msg)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_RECEIVE: {
+		struct cec_msg msg;
+
+		if (!(adap->capabilities & CEC_CAP_IO))
+			return -ENOTTY;
+		if (copy_from_user(&msg, parg, sizeof(msg)))
+			return -EFAULT;
+		memset(msg.reserved, 0, sizeof(msg.reserved));
+		if (!adap->is_configured)
+			return -ENONET;
+		if (!fh->monitor && adap->cec_owner != fh)
+			return -EPERM;
+
+		err = cec_receive_msg(fh, &msg, block);
+		if (err)
+			return err;
+		if (copy_to_user(parg, &msg, sizeof(msg)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_DQEVENT: {
+		struct cec_event *ev = NULL;
+		u64 ts = ~0ULL;
+		unsigned i;
+
+		mutex_lock(&fh->lock);
+		for (i = 0; i < CEC_NUM_EVENTS; i++) {
+			if (fh->events[i].event &&
+			    fh->events[i].ts <= ts) {
+				ev = &fh->events[i];
+				ts = ev->ts;
+			}
+		}
+		err = -EAGAIN;
+		if (ev) {
+			if (copy_to_user((void __user *)arg, ev, sizeof(*ev))) {
+				err = -EFAULT;
+			} else {
+				if (ev->event == CEC_EVENT_INPUTS_CHANGE)
+					ev->inputs_change.changed_inputs = 0;
+				ev->event = 0;
+				err = 0;
+			}
+		}
+		mutex_unlock(&fh->lock);
+		return err;
+	}
+
+	case CEC_ADAP_G_STATE: {
+		u32 state = adap->is_enabled;
+
+		if (copy_to_user(parg, &state, sizeof(state)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_ADAP_S_STATE: {
+		u32 state;
+
+		if (!(adap->capabilities & CEC_CAP_STATE))
+			return -ENOTTY;
+		if (copy_from_user(&state, parg, sizeof(state)))
+			return -EFAULT;
+		if (state > CEC_ADAP_ENABLED)
+			return -EINVAL;
+		if (adap->is_configuring)
+			return -EBUSY;
+		if (state == adap->is_enabled)
+			return 0;
+		if (adap->cec_owner && adap->cec_owner != fh)
+			return -EBUSY;
+		cec_enable(adap, state);
+		break;
+	}
+
+	case CEC_ADAP_G_PHYS_ADDR: {
+		u16 phys_addr = adap->is_enabled ? adap->phys_addr :
+			CEC_PHYS_ADDR_INVALID;
+
+		if (copy_to_user(parg, &phys_addr, sizeof(adap->phys_addr)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_ADAP_S_PHYS_ADDR: {
+		u16 phys_addr;
+
+		if (!(adap->capabilities & CEC_CAP_PHYS_ADDR))
+			return -ENOTTY;
+		if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
+			return -EFAULT;
+		if (adap->phys_addr == phys_addr)
+			return 0;
+		if (!adap->is_enabled)
+			return -ENONET;
+		if (adap->is_configuring || adap->is_configured)
+			return -EBUSY;
+		if (adap->cec_owner && adap->cec_owner != fh)
+			return -EBUSY;
+		adap->phys_addr = phys_addr;
+		break;
+	}
+
+	case CEC_ADAP_S_LOG_ADDRS: {
+		struct cec_log_addrs log_addrs;
+
+		if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
+			return -ENOTTY;
+		if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
+			return -EFAULT;
+		if (adap->is_configuring)
+			return -EBUSY;
+		if (log_addrs.num_log_addrs && adap->is_configured)
+			return -EBUSY;
+		if (adap->cec_owner && adap->cec_owner != fh)
+			return -EBUSY;
+
+		memset(log_addrs.reserved, 0, sizeof(log_addrs.reserved));
+		err = cec_claim_log_addrs(adap, &log_addrs, block);
+		if (err)
+			return err;
+
+		if (filp->f_flags & O_NONBLOCK) {
+			if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+				return -EFAULT;
+			break;
+		}
+
+		/* fall through */
+	}
+
+	case CEC_ADAP_G_LOG_ADDRS: {
+		struct cec_log_addrs log_addrs = { adap->cec_version };
+		unsigned i;
+
+		mutex_lock(&adap->lock);
+		log_addrs.num_log_addrs = adap->num_log_addrs;
+		strlcpy(log_addrs.osd_name, adap->osd_name,
+			sizeof(log_addrs.osd_name));
+		for (i = 0; i < adap->num_log_addrs; i++) {
+			log_addrs.primary_device_type[i] = adap->prim_device[i];
+			log_addrs.log_addr_type[i] = adap->log_addr_type[i];
+			log_addrs.log_addr[i] = adap->log_addr[i];
+			log_addrs.all_device_types[i] = adap->all_device_types[i];
+			memcpy(log_addrs.features[i], adap->features[i],
+			       sizeof(log_addrs.features[i]));
+		}
+		mutex_unlock(&adap->lock);
+
+		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_ADAP_G_VENDOR_ID:
+		if (copy_to_user(parg, &adap->vendor_id,
+						sizeof(adap->vendor_id)))
+			return -EFAULT;
+		break;
+
+	case CEC_ADAP_S_VENDOR_ID: {
+		u32 vendor_id;
+
+		if (!(adap->capabilities & CEC_CAP_VENDOR_ID))
+			return -ENOTTY;
+		if (copy_from_user(&vendor_id, parg, sizeof(vendor_id)))
+			return -EFAULT;
+		/* Vendor ID is a 24 bit number, so check if the value is
+		 * within the correct range. */
+		if (vendor_id != CEC_VENDOR_ID_NONE &&
+		    (vendor_id & 0xff000000) != 0)
+			return -EINVAL;
+		if (adap->vendor_id == vendor_id)
+			return 0;
+		if (adap->is_configuring || adap->is_configured)
+			return -EBUSY;
+		if (adap->cec_owner && adap->cec_owner != fh)
+			return -EBUSY;
+		adap->vendor_id = vendor_id;
+		break;
+	}
+
+	case CEC_G_PASSTHROUGH: {
+		u32 passthrough = CEC_PASSTHROUGH_DISABLED;
+
+		if (!(adap->capabilities & CEC_CAP_PASSTHROUGH))
+			return -ENOTTY;
+		if (adap->cec_owner == fh)
+			passthrough = adap->passthrough;
+		if (copy_to_user(parg, &passthrough, sizeof(passthrough)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_G_MONITOR: {
+		u32 monitor = fh->monitor;
+
+		if (copy_to_user(parg, &monitor, sizeof(monitor)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_S_MONITOR: {
+		u32 monitor;
+
+		if (copy_from_user(&monitor, parg, sizeof(monitor)))
+			return -EFAULT;
+		if (monitor > CEC_MONITOR_ENABLED)
+			return -EINVAL;
+		if (fh->monitor == monitor)
+			break;
+		if (adap->cec_owner == fh)
+			return -EBUSY;
+		fh->monitor = monitor;
+		break;
+	}
+
+	case CEC_CLAIM: {
+		u32 passthrough;
+
+		if (copy_from_user(&passthrough, parg, sizeof(passthrough)))
+			return -EFAULT;
+		if (passthrough > CEC_PASSTHROUGH_ENABLED)
+			return -EINVAL;
+		if (passthrough &&
+		    !(adap->capabilities & CEC_CAP_PASSTHROUGH))
+			return -EPERM;
+		if (adap->cec_owner && adap->cec_owner != fh)
+			return -EBUSY;
+		if (fh->monitor)
+			return -EBUSY;
+		mutex_lock(&adap->lock);
+		adap->passthrough = passthrough;
+		adap->cec_owner = fh;
+		mutex_unlock(&adap->lock);
+		break;
+	}
+
+	case CEC_RELEASE: {
+		if (adap->cec_owner && adap->cec_owner != fh)
+			return -EBUSY;
+		mutex_lock(&adap->lock);
+		adap->cec_owner = NULL;
+		adap->passthrough = 0;
+		mutex_unlock(&adap->lock);
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
+	struct cec_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+
+	if (fh == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&fh->msgs);
+	mutex_init(&fh->lock);
+	init_waitqueue_head(&fh->wait);
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
+		kfree(fh);
+		return -ENXIO;
+	}
+	/* and increase the device refcount */
+	get_device(&cecdev->dev);
+	mutex_unlock(&cec_devnode_lock);
+
+	fh->adap = to_cec_adapter(cecdev);
+	filp->private_data = fh;
+	mutex_lock(&cecdev->fhs_lock);
+	list_add(&fh->list, &cecdev->fhs);
+	mutex_unlock(&cecdev->fhs_lock);
+	if (fh->adap->ninputs)
+		cec_post_inputs_event_fh(fh->adap, fh, ktime_get_ns());
+	cec_post_state_event_fh(fh->adap, fh, ktime_get_ns());
+
+	return 0;
+}
+
+/* Override for the release function */
+static int cec_release(struct inode *inode, struct file *filp)
+{
+	struct cec_devnode *cecdev = cec_devnode_data(filp);
+	struct cec_adapter *adap = to_cec_adapter(cecdev);
+	struct cec_fh *fh = filp->private_data;
+	int ret = 0;
+
+	if (adap->cec_owner == fh)
+		adap->cec_owner = NULL;
+
+	mutex_lock(&cecdev->fhs_lock);
+	list_del(&fh->list);
+	mutex_unlock(&cecdev->fhs_lock);
+
+	while (!list_empty(&fh->msgs)) {
+		struct cec_msg_entry *entry =
+			list_first_entry(&fh->msgs, struct cec_msg_entry, list);
+
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	kfree(fh);
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
+	/* Initialization */
+	INIT_LIST_HEAD(&cecdev->fhs);
+	mutex_init(&cecdev->fhs_lock);
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
+int cec_create_adapter(struct cec_adapter *adap, const char *name, u32 caps,
+		       u8 ninputs, struct module *owner, struct device *parent)
+{
+	int res = 0;
+
+	adap->owner = owner;
+	if (WARN_ON(!owner))
+		return -ENXIO;
+	adap->devnode.parent = parent;
+	if (WARN_ON(!parent))
+		return -ENXIO;
+	adap->name = name;
+	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
+	adap->capabilities = caps;
+	adap->ninputs = ninputs;
+	adap->is_source = caps & CEC_CAP_IS_SOURCE;
+	if (WARN_ON(!adap->ninputs && !adap->is_source))
+		return -ENXIO;
+	adap->cec_version = CEC_OP_CEC_VERSION_2_0;
+	adap->vendor_id = CEC_VENDOR_ID_NONE;
+	adap->available_log_addrs = 1;
+	adap->sequence = 0;
+	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
+	mutex_init(&adap->lock);
+	INIT_LIST_HEAD(&adap->transmit_queue);
+	INIT_LIST_HEAD(&adap->wait_queue);
+	adap->kthread = kthread_run(cec_thread_func, adap, "cec-%s", name);
+	init_waitqueue_head(&adap->kthread_waitq);
+	if (IS_ERR(adap->kthread)) {
+		pr_err("cec-%s: kernel_thread() failed\n", name);
+		return PTR_ERR(adap->kthread);
+	}
+	if (caps) {
+		res = cec_devnode_register(&adap->devnode, adap->owner);
+		if (res) {
+			kthread_stop(adap->kthread);
+			return res;
+		}
+	}
+
+	if (!(caps & CEC_CAP_RC))
+		return 0;
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
+	strlcpy(adap->input_drv, name, sizeof(adap->input_drv));
+
+	adap->rc->input_name = adap->input_name;
+	adap->rc->input_phys = adap->input_phys;
+	adap->rc->input_id.bustype = BUS_CEC;
+	adap->rc->input_id.vendor = 0;
+	adap->rc->input_id.product = 0;
+	adap->rc->input_id.version = 1;
+	adap->rc->dev.parent = adap->devnode.parent;
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
+	if (adap->is_enabled)
+		cec_enable(adap, false);
+	rc_unregister_device(adap->rc);
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
index 0000000..8f01c5d
--- /dev/null
+++ b/include/media/cec.h
@@ -0,0 +1,178 @@
+#ifndef _CEC_DEVNODE_H
+#define _CEC_DEVNODE_H
+
+#include <linux/poll.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/kthread.h>
+#include <linux/timer.h>
+#include <linux/cec-funcs.h>
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
+	struct mutex fhs_lock;
+	struct list_head fhs;		/* cec_fh list */
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
+struct cec_data {
+	struct list_head list;
+	struct cec_adapter *adap;
+	struct cec_msg msg;
+	struct cec_fh *fh;
+	struct delayed_work work;
+	struct completion c;
+	bool blocking;
+	bool completed;
+};
+
+struct cec_msg_entry {
+	struct list_head	list;
+	struct cec_msg		msg;
+};
+
+#define CEC_NUM_EVENTS		CEC_EVENT_LOST_MSGS
+
+struct cec_fh {
+	struct list_head	list;
+	struct cec_adapter	*adap;
+	bool			monitor;
+
+	/* Events */
+	wait_queue_head_t	wait;
+	struct cec_event	events[CEC_NUM_EVENTS];
+	struct mutex		lock;
+	struct list_head	msgs; /* queued messages */
+	unsigned int		queued_msgs;
+};
+
+/*
+ * The minimum message length you can receive (excepting poll messages) is 2.
+ * With a transfer rate of at most 36 bytes per second this makes 18 messages
+ * per second worst case.
+ *
+ * We queue at most 10 seconds worth of messages.
+ */
+#define CEC_MAX_MSG_QUEUE_SZ		(18 * 10)
+
+struct cec_adapter {
+	struct module *owner;
+	const char *name;
+	struct cec_devnode devnode;
+	struct mutex lock;
+	struct rc_dev *rc;
+
+	struct list_head transmit_queue;
+	struct list_head wait_queue;
+	struct cec_data *transmitting;
+
+	struct task_struct *kthread_config;
+
+	struct task_struct *kthread;
+	wait_queue_head_t kthread_waitq;
+	wait_queue_head_t waitq;
+
+	/* Can be set by the main driver: */
+	u32 capabilities;
+	u8 available_log_addrs;
+	u8 pwr_state;
+	u16 phys_addr;
+	u32 vendor_id;
+	u8 cec_version;
+
+	u8 ninputs;
+	u16 connected_inputs;
+	bool is_source;
+	bool is_enabled;
+	bool is_configuring;
+	bool is_configured;
+	u8 num_log_addrs;
+	struct cec_fh *cec_owner;
+	u8 prim_device[CEC_MAX_LOG_ADDRS];
+	u8 log_addr_type[CEC_MAX_LOG_ADDRS];
+	u8 log_addr[CEC_MAX_LOG_ADDRS];
+	u8 all_device_types[CEC_MAX_LOG_ADDRS];
+	u8 features[CEC_MAX_LOG_ADDRS][12];
+	u16 phys_addrs[15];
+	char osd_name[15];
+	u8 passthrough;
+	u32 sequence;
+
+	char input_name[32];
+	char input_phys[32];
+	char input_drv[32];
+
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+	int (*adap_transmit)(struct cec_adapter *adap, u32 timeout_ms, struct cec_msg *msg);
+
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+
+	/* High-level callbacks */
+	u8 (*source_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state);
+	u8 (*sink_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state, u8 cdc_hpd_error);
+	int (*sink_initiate_arc)(struct cec_adapter *adap);
+	int (*sink_terminate_arc)(struct cec_adapter *adap);
+	int (*source_arc_initiated)(struct cec_adapter *adap);
+	int (*source_arc_terminated)(struct cec_adapter *adap);
+};
+
+#define to_cec_adapter(node) container_of(node, struct cec_adapter, devnode)
+
+int cec_create_adapter(struct cec_adapter *adap, const char *name, u32 caps,
+		       u8 ninputs, struct module *owner, struct device *parent);
+void cec_delete_adapter(struct cec_adapter *adap);
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+		     bool block);
+int cec_claim_log_addrs(struct cec_adapter *adap,
+			struct cec_log_addrs *log_addrs, bool block);
+int cec_enable(struct cec_adapter *adap, bool enable);
+u8 cec_sink_cdc_hpd(struct cec_adapter *adap, u8 input_port, u8 cdc_hpd_state);
+void cec_log_status(struct cec_adapter *adap);
+
+/* Called by the adapter */
+void cec_transmit_done(struct cec_adapter *adap, u32 status);
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+void cec_connected_inputs(struct cec_adapter *adap, u16 connected_inputs);
+
+#endif /* _CEC_DEVNODE_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 1ff9942..fef06f9 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -81,6 +81,8 @@ header-y += capi.h
 header-y += cciss_defs.h
 header-y += cciss_ioctl.h
 header-y += cdrom.h
+header-y += cec.h
+header-y += cec-funcs.h
 header-y += cgroupstats.h
 header-y += chio.h
 header-y += cm4000_cs.h
diff --git a/include/uapi/linux/cec-funcs.h b/include/uapi/linux/cec-funcs.h
new file mode 100644
index 0000000..b27b045
--- /dev/null
+++ b/include/uapi/linux/cec-funcs.h
@@ -0,0 +1,1771 @@
+#ifndef _CEC_FUNCS_H
+#define _CEC_FUNCS_H
+
+#include <linux/cec.h>
+
+/* One Touch Play Feature */
+static inline void cec_msg_active_source(struct cec_msg *msg, __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_ACTIVE_SOURCE;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static inline void cec_ops_active_source(const struct cec_msg *msg,
+					 __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static inline void cec_msg_image_view_on(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_IMAGE_VIEW_ON;
+}
+
+static inline void cec_msg_text_view_on(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TEXT_VIEW_ON;
+}
+
+
+/* Routing Control Feature */
+static inline void cec_msg_inactive_source(struct cec_msg *msg,
+					   __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_INACTIVE_SOURCE;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static inline void cec_ops_inactive_source(const struct cec_msg *msg,
+					   __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static inline void cec_msg_request_active_source(struct cec_msg *msg,
+						 bool reply)
+{
+	msg->len = 2;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_REQUEST_ACTIVE_SOURCE;
+	msg->reply = reply ? CEC_MSG_ACTIVE_SOURCE : 0;
+}
+
+static inline void cec_msg_routing_information(struct cec_msg *msg,
+					       __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_ROUTING_INFORMATION;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static inline void cec_ops_routing_information(const struct cec_msg *msg,
+					       __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static inline void cec_msg_routing_change(struct cec_msg *msg,
+					  bool reply,
+					  __u16 orig_phys_addr,
+					  __u16 new_phys_addr)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_ROUTING_CHANGE;
+	msg->msg[2] = orig_phys_addr >> 8;
+	msg->msg[3] = orig_phys_addr & 0xff;
+	msg->msg[4] = new_phys_addr >> 8;
+	msg->msg[5] = new_phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_ROUTING_INFORMATION : 0;
+}
+
+static inline void cec_ops_routing_change(const struct cec_msg *msg,
+					  __u16 *orig_phys_addr,
+					  __u16 *new_phys_addr)
+{
+	*orig_phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*new_phys_addr = (msg->msg[4] << 8) | msg->msg[5];
+}
+
+static inline void cec_msg_set_stream_path(struct cec_msg *msg, __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_SET_STREAM_PATH;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static inline void cec_ops_set_stream_path(const struct cec_msg *msg,
+					   __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+
+/* Standby Feature */
+static inline void cec_msg_standby(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_STANDBY;
+}
+
+
+/* One Touch Record Feature */
+static inline void cec_msg_record_off(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_RECORD_OFF;
+}
+
+struct cec_op_arib_data {
+	__u16 transport_id;
+	__u16 service_id;
+	__u16 orig_network_id;
+};
+
+struct cec_op_atsc_data {
+	__u16 transport_id;
+	__u16 program_number;
+};
+
+struct cec_op_dvb_data {
+	__u16 transport_id;
+	__u16 service_id;
+	__u16 orig_network_id;
+};
+
+struct cec_op_channel_data {
+	__u8 channel_number_fmt;
+	__u16 major;
+	__u16 minor;
+};
+
+struct cec_op_digital_service_id {
+	__u8 service_id_method;
+	__u8 dig_bcast_system;
+	union {
+		struct cec_op_arib_data arib;
+		struct cec_op_atsc_data atsc;
+		struct cec_op_dvb_data dvb;
+		struct cec_op_channel_data channel;
+	};
+};
+
+struct cec_op_record_src {
+	__u8 type;
+	union {
+		struct cec_op_digital_service_id digital;
+		struct {
+			__u8 ana_bcast_type;
+			__u16 ana_freq;
+			__u8 bcast_system;
+		} analog;
+		struct {
+			__u8 plug;
+		} ext_plug;
+		struct {
+			__u16 phys_addr;
+		} ext_phys_addr;
+	};
+};
+
+static inline void cec_set_digital_service_id(__u8 *msg,
+	      const struct cec_op_digital_service_id *digital)
+{
+	*msg++ = (digital->service_id_method << 7) | digital->dig_bcast_system;
+	if (digital->service_id_method == CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL) {
+		*msg++ = (digital->channel.channel_number_fmt << 2) |
+			 (digital->channel.major >> 8);
+		*msg++ = digital->channel.major && 0xff;
+		*msg++ = digital->channel.minor >> 8;
+		*msg++ = digital->channel.minor & 0xff;
+		*msg++ = 0;
+		*msg++ = 0;
+		return;
+	}
+	switch (digital->dig_bcast_system) {
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T:
+		*msg++ = digital->atsc.transport_id >> 8;
+		*msg++ = digital->atsc.transport_id & 0xff;
+		*msg++ = digital->atsc.program_number >> 8;
+		*msg++ = digital->atsc.program_number & 0xff;
+		*msg++ = 0;
+		*msg++ = 0;
+		break;
+	default:
+		*msg++ = digital->dvb.transport_id >> 8;
+		*msg++ = digital->dvb.transport_id & 0xff;
+		*msg++ = digital->dvb.service_id >> 8;
+		*msg++ = digital->dvb.service_id & 0xff;
+		*msg++ = digital->dvb.orig_network_id >> 8;
+		*msg++ = digital->dvb.orig_network_id & 0xff;
+		break;
+	}
+}
+
+static inline void cec_get_digital_service_id(const __u8 *msg,
+	      struct cec_op_digital_service_id *digital)
+{
+	digital->service_id_method = msg[0] >> 7;
+	digital->dig_bcast_system = msg[0] & 0x7f;
+	if (digital->service_id_method == CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL) {
+		digital->channel.channel_number_fmt = msg[1] >> 2;
+		digital->channel.major = ((msg[1] & 3) << 6) | msg[2];
+		digital->channel.minor = (msg[3] << 8) | msg[4];
+		return;
+	}
+	digital->dvb.transport_id = (msg[1] << 8) | msg[2];
+	digital->dvb.service_id = (msg[3] << 8) | msg[4];
+	digital->dvb.orig_network_id = (msg[5] << 8) | msg[6];
+}
+
+static inline void cec_msg_record_on_own(struct cec_msg *msg)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_OWN;
+}
+
+static inline void cec_msg_record_on_digital(struct cec_msg *msg,
+			     const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 10;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_DIGITAL;
+	cec_set_digital_service_id(msg->msg + 3, digital);
+}
+
+static inline void cec_msg_record_on_analog(struct cec_msg *msg,
+					    __u8 ana_bcast_type,
+					    __u16 ana_freq,
+					    __u8 bcast_system)
+{
+	msg->len = 7;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_ANALOG;
+	msg->msg[3] = ana_bcast_type;
+	msg->msg[4] = ana_freq >> 8;
+	msg->msg[5] = ana_freq & 0xff;
+	msg->msg[6] = bcast_system;
+}
+
+static inline void cec_msg_record_on_plug(struct cec_msg *msg,
+					  __u8 plug)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_EXT_PLUG;
+	msg->msg[3] = plug;
+}
+
+static inline void cec_msg_record_on_phys_addr(struct cec_msg *msg,
+					       __u16 phys_addr)
+{
+	msg->len = 5;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_EXT_PHYS_ADDR;
+	msg->msg[3] = phys_addr >> 8;
+	msg->msg[4] = phys_addr & 0xff;
+}
+
+static inline void cec_msg_record_on(struct cec_msg *msg,
+				     const struct cec_op_record_src *rec_src)
+{
+	switch (rec_src->type) {
+	case CEC_OP_RECORD_SRC_OWN:
+		cec_msg_record_on_own(msg);
+		break;
+	case CEC_OP_RECORD_SRC_DIGITAL:
+		cec_msg_record_on_digital(msg, &rec_src->digital);
+		break;
+	case CEC_OP_RECORD_SRC_ANALOG:
+		cec_msg_record_on_analog(msg,
+					 rec_src->analog.ana_bcast_type,
+					 rec_src->analog.ana_freq,
+					 rec_src->analog.bcast_system);
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PLUG:
+		cec_msg_record_on_plug(msg, rec_src->ext_plug.plug);
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PHYS_ADDR:
+		cec_msg_record_on_phys_addr(msg,
+					    rec_src->ext_phys_addr.phys_addr);
+		break;
+	}
+}
+
+static inline void cec_ops_record_on(const struct cec_msg *msg,
+				     struct cec_op_record_src *rec_src)
+{
+	rec_src->type = msg->msg[2];
+	switch (rec_src->type) {
+	case CEC_OP_RECORD_SRC_OWN:
+		break;
+	case CEC_OP_RECORD_SRC_DIGITAL:
+		cec_get_digital_service_id(msg->msg + 3, &rec_src->digital);
+		break;
+	case CEC_OP_RECORD_SRC_ANALOG:
+		rec_src->analog.ana_bcast_type = msg->msg[3];
+		rec_src->analog.ana_freq =
+			(msg->msg[4] << 8) | msg->msg[5];
+		rec_src->analog.bcast_system = msg->msg[6];
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PLUG:
+		rec_src->ext_plug.plug = msg->msg[3];
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PHYS_ADDR:
+		rec_src->ext_phys_addr.phys_addr =
+			(msg->msg[3] << 8) | msg->msg[4];
+		break;
+	}
+}
+
+static inline void cec_msg_record_status(struct cec_msg *msg, __u8 rec_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_RECORD_STATUS;
+	msg->msg[2] = rec_status;
+}
+
+static inline void cec_ops_record_status(const struct cec_msg *msg,
+					 __u8 *rec_status)
+{
+	*rec_status = msg->msg[2];
+}
+
+static inline void cec_msg_record_tv_screen(struct cec_msg *msg,
+					    bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_RECORD_TV_SCREEN;
+	msg->reply = reply ? CEC_MSG_RECORD_ON : 0;
+}
+
+
+/* Timer Programming Feature */
+static inline void cec_msg_timer_status(struct cec_msg *msg,
+					__u8 timer_overlap_warning,
+					__u8 media_info,
+					__u8 prog_info,
+					__u8 prog_error,
+					__u8 duration_hr,
+					__u8 duration_min)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_TIMER_STATUS;
+	msg->msg[2] = (timer_overlap_warning << 7) |
+		(media_info << 5) |
+		(prog_info ? 0x10 : 0) |
+		(prog_info ? prog_info : prog_error);
+	if (prog_info == CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE ||
+	    prog_info == CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE ||
+	    prog_error == CEC_OP_PROG_ERROR_DUPLICATE) {
+		msg->len += 2;
+		msg->msg[3] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+		msg->msg[4] = ((duration_min / 10) << 4) | (duration_min % 10);
+	}
+}
+
+static inline void cec_ops_timer_status(struct cec_msg *msg,
+					__u8 *timer_overlap_warning,
+					__u8 *media_info,
+					__u8 *prog_info,
+					__u8 *prog_error,
+					__u8 *duration_hr,
+					__u8 *duration_min)
+{
+	*timer_overlap_warning = msg->msg[2] >> 7;
+	*media_info = (msg->msg[2] >> 5) & 3;
+	if (msg->msg[2] & 0x10) {
+		*prog_info = msg->msg[2] & 0xf;
+		*prog_error = 0;
+	} else {
+		*prog_info = 0;
+		*prog_error = msg->msg[2] & 0xf;
+	}
+	if (*prog_info == CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE ||
+	    *prog_info == CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE ||
+	    *prog_error == CEC_OP_PROG_ERROR_DUPLICATE) {
+		*duration_hr = (msg->msg[3] >> 4) * 10 + (msg->msg[3] & 0xf);
+		*duration_min = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	} else {
+		*duration_hr = *duration_min = 0;
+	}
+}
+
+static inline void cec_msg_timer_cleared_status(struct cec_msg *msg,
+						__u8 timer_cleared_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_TIMER_CLEARED_STATUS;
+	msg->msg[2] = timer_cleared_status;
+}
+
+static inline void cec_ops_timer_cleared_status(struct cec_msg *msg,
+						__u8 *timer_cleared_status)
+{
+	*timer_cleared_status = msg->msg[2];
+}
+
+static inline void cec_msg_clear_analogue_timer(struct cec_msg *msg,
+						bool reply,
+						__u8 day,
+						__u8 month,
+						__u8 start_hr,
+						__u8 start_min,
+						__u8 duration_hr,
+						__u8 duration_min,
+						__u8 recording_seq,
+						__u8 ana_bcast_type,
+						__u16 ana_freq,
+						__u8 bcast_system)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_CLEAR_ANALOGUE_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ana_bcast_type;
+	msg->msg[10] = ana_freq >> 8;
+	msg->msg[11] = ana_freq & 0xff;
+	msg->msg[12] = bcast_system;
+	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
+}
+
+static inline void cec_ops_clear_analogue_timer(struct cec_msg *msg,
+						__u8 *day,
+						__u8 *month,
+						__u8 *start_hr,
+						__u8 *start_min,
+						__u8 *duration_hr,
+						__u8 *duration_min,
+						__u8 *recording_seq,
+						__u8 *ana_bcast_type,
+						__u16 *ana_freq,
+						__u8 *bcast_system)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ana_bcast_type = msg->msg[9];
+	*ana_freq = (msg->msg[10] << 8) | msg->msg[11];
+	*bcast_system = msg->msg[12];
+}
+
+static inline void cec_msg_clear_digital_timer(struct cec_msg *msg,
+					       bool reply,
+					       __u8 day,
+					       __u8 month,
+					       __u8 start_hr,
+					       __u8 start_min,
+					       __u8 duration_hr,
+					       __u8 duration_min,
+					       __u8 recording_seq,
+					       const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 16;
+	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
+	msg->msg[1] = CEC_MSG_CLEAR_DIGITAL_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	cec_set_digital_service_id(msg->msg + 9, digital);
+}
+
+static inline void cec_ops_clear_digital_timer(struct cec_msg *msg,
+					       __u8 *day,
+					       __u8 *month,
+					       __u8 *start_hr,
+					       __u8 *start_min,
+					       __u8 *duration_hr,
+					       __u8 *duration_min,
+					       __u8 *recording_seq,
+					       struct cec_op_digital_service_id *digital)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	cec_get_digital_service_id(msg->msg + 9, digital);
+}
+
+static inline void cec_msg_clear_ext_timer(struct cec_msg *msg,
+					   bool reply,
+					   __u8 day,
+					   __u8 month,
+					   __u8 start_hr,
+					   __u8 start_min,
+					   __u8 duration_hr,
+					   __u8 duration_min,
+					   __u8 recording_seq,
+					   __u8 ext_src_spec,
+					   __u8 plug,
+					   __u16 phys_addr)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_CLEAR_EXT_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ext_src_spec;
+	msg->msg[10] = plug;
+	msg->msg[11] = phys_addr >> 8;
+	msg->msg[12] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
+}
+
+static inline void cec_ops_clear_ext_timer(struct cec_msg *msg,
+					   __u8 *day,
+					   __u8 *month,
+					   __u8 *start_hr,
+					   __u8 *start_min,
+					   __u8 *duration_hr,
+					   __u8 *duration_min,
+					   __u8 *recording_seq,
+					   __u8 *ext_src_spec,
+					   __u8 *plug,
+					   __u16 *phys_addr)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ext_src_spec = msg->msg[9];
+	*plug = msg->msg[10];
+	*phys_addr = (msg->msg[11] << 8) | msg->msg[12];
+}
+
+static inline void cec_msg_set_analogue_timer(struct cec_msg *msg,
+					      bool reply,
+					      __u8 day,
+					      __u8 month,
+					      __u8 start_hr,
+					      __u8 start_min,
+					      __u8 duration_hr,
+					      __u8 duration_min,
+					      __u8 recording_seq,
+					      __u8 ana_bcast_type,
+					      __u16 ana_freq,
+					      __u8 bcast_system)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_SET_ANALOGUE_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ana_bcast_type;
+	msg->msg[10] = ana_freq >> 8;
+	msg->msg[11] = ana_freq & 0xff;
+	msg->msg[12] = bcast_system;
+	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
+}
+
+static inline void cec_ops_set_analogue_timer(struct cec_msg *msg,
+					      __u8 *day,
+					      __u8 *month,
+					      __u8 *start_hr,
+					      __u8 *start_min,
+					      __u8 *duration_hr,
+					      __u8 *duration_min,
+					      __u8 *recording_seq,
+					      __u8 *ana_bcast_type,
+					      __u16 *ana_freq,
+					      __u8 *bcast_system)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ana_bcast_type = msg->msg[9];
+	*ana_freq = (msg->msg[10] << 8) | msg->msg[11];
+	*bcast_system = msg->msg[12];
+}
+
+static inline void cec_msg_set_digital_timer(struct cec_msg *msg,
+					     bool reply,
+					     __u8 day,
+					     __u8 month,
+					     __u8 start_hr,
+					     __u8 start_min,
+					     __u8 duration_hr,
+					     __u8 duration_min,
+					     __u8 recording_seq,
+					     const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 16;
+	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
+	msg->msg[1] = CEC_MSG_SET_DIGITAL_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	cec_set_digital_service_id(msg->msg + 9, digital);
+}
+
+static inline void cec_ops_set_digital_timer(struct cec_msg *msg,
+					     __u8 *day,
+					     __u8 *month,
+					     __u8 *start_hr,
+					     __u8 *start_min,
+					     __u8 *duration_hr,
+					     __u8 *duration_min,
+					     __u8 *recording_seq,
+					     struct cec_op_digital_service_id *digital)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	cec_get_digital_service_id(msg->msg + 9, digital);
+}
+
+static inline void cec_msg_set_ext_timer(struct cec_msg *msg,
+					 bool reply,
+					 __u8 day,
+					 __u8 month,
+					 __u8 start_hr,
+					 __u8 start_min,
+					 __u8 duration_hr,
+					 __u8 duration_min,
+					 __u8 recording_seq,
+					 __u8 ext_src_spec,
+					 __u8 plug,
+					 __u16 phys_addr)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_SET_EXT_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ext_src_spec;
+	msg->msg[10] = plug;
+	msg->msg[11] = phys_addr >> 8;
+	msg->msg[12] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
+}
+
+static inline void cec_ops_set_ext_timer(struct cec_msg *msg,
+					 __u8 *day,
+					 __u8 *month,
+					 __u8 *start_hr,
+					 __u8 *start_min,
+					 __u8 *duration_hr,
+					 __u8 *duration_min,
+					 __u8 *recording_seq,
+					 __u8 *ext_src_spec,
+					 __u8 *plug,
+					 __u16 *phys_addr)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ext_src_spec = msg->msg[9];
+	*plug = msg->msg[10];
+	*phys_addr = (msg->msg[11] << 8) | msg->msg[12];
+}
+
+static inline void cec_msg_set_timer_program_title(struct cec_msg *msg,
+						   const char *prog_title)
+{
+	unsigned len = strlen(prog_title);
+
+	if (len > 14)
+		len = 14;
+	msg->len = 2 + len;
+	msg->msg[1] = CEC_MSG_SET_TIMER_PROGRAM_TITLE;
+	memcpy(msg->msg + 2, prog_title, len);
+}
+
+static inline void cec_ops_set_timer_program_title(const struct cec_msg *msg,
+						   char *prog_title)
+{
+	unsigned len = msg->len - 2;
+
+	if (len > 14)
+		len = 14;
+	memcpy(prog_title, msg->msg + 2, len);
+	prog_title[len] = '\0';
+}
+
+/* System Information Feature */
+static inline void cec_msg_cec_version(struct cec_msg *msg, __u8 cec_version)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_CEC_VERSION;
+	msg->msg[2] = cec_version;
+}
+
+static inline void cec_ops_cec_version(const struct cec_msg *msg,
+				       __u8 *cec_version)
+{
+	*cec_version = msg->msg[2];
+}
+
+static inline void cec_msg_get_cec_version(struct cec_msg *msg,
+					   bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GET_CEC_VERSION;
+	msg->reply = reply ? CEC_MSG_CEC_VERSION : 0;
+}
+
+static inline void cec_msg_report_physical_addr(struct cec_msg *msg,
+						__u16 phys_addr, __u8 prim_devtype)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_REPORT_PHYSICAL_ADDR;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->msg[4] = prim_devtype;
+}
+
+static inline void cec_ops_report_physical_addr(const struct cec_msg *msg,
+						__u16 *phys_addr, __u8 *prim_devtype)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*prim_devtype = msg->msg[4];
+}
+
+static inline void cec_msg_give_physical_addr(struct cec_msg *msg,
+					      bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_PHYSICAL_ADDR;
+	msg->reply = reply ? CEC_MSG_REPORT_PHYSICAL_ADDR : 0;
+}
+
+static inline void cec_msg_set_menu_language(struct cec_msg *msg,
+					     const char *language)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_SET_MENU_LANGUAGE;
+	memcpy(msg->msg + 2, language, 3);
+}
+
+static inline void cec_ops_set_menu_language(struct cec_msg *msg,
+					     char *language)
+{
+	memcpy(language, msg->msg + 2, 3);
+}
+
+static inline void cec_msg_get_menu_language(struct cec_msg *msg,
+					     bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GET_MENU_LANGUAGE;
+	msg->reply = reply ? CEC_MSG_SET_MENU_LANGUAGE : 0;
+}
+
+/*
+ * Assumes a single RC Profile byte and a single Device Features byte,
+ * i.e. no extended features are supported by this helper function.
+ */
+static inline void cec_msg_report_features(struct cec_msg *msg,
+					   __u8 cec_version, __u8 all_device_types,
+					   __u8 rc_profile, __u8 dev_features)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_REPORT_FEATURES;
+	msg->msg[2] = cec_version;
+	msg->msg[3] = all_device_types;
+	msg->msg[4] = rc_profile;
+	msg->msg[5] = dev_features;
+}
+
+static inline void cec_ops_report_features(const struct cec_msg *msg,
+					   __u8 *cec_version, __u8 *all_device_types,
+					   const __u8 **rc_profile, const __u8 **dev_features)
+{
+	const __u8 *p = &msg->msg[4];
+
+	*cec_version = msg->msg[2];
+	*all_device_types = msg->msg[3];
+	*rc_profile = p;
+	while (p < &msg->msg[14] && (*p & CEC_OP_FEAT_EXT))
+		p++;
+	if (!(*p & CEC_OP_FEAT_EXT)) {
+		*dev_features = p + 1;
+		while (p < &msg->msg[15] && (*p & CEC_OP_FEAT_EXT))
+			p++;
+	}
+	if (*p & CEC_OP_FEAT_EXT)
+		*rc_profile = *dev_features = NULL;
+}
+
+static inline void cec_msg_give_features(struct cec_msg *msg,
+					 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_FEATURES;
+	msg->reply = reply ? CEC_MSG_REPORT_FEATURES : 0;
+}
+
+/* Deck Control Feature */
+static inline void cec_msg_deck_control(struct cec_msg *msg,
+					__u8 deck_control_mode)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_DECK_CONTROL;
+	msg->msg[2] = deck_control_mode;
+}
+
+static inline void cec_ops_deck_control(struct cec_msg *msg,
+					__u8 *deck_control_mode)
+{
+	*deck_control_mode = msg->msg[2];
+}
+
+static inline void cec_msg_deck_status(struct cec_msg *msg,
+				       __u8 deck_info)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_DECK_STATUS;
+	msg->msg[2] = deck_info;
+}
+
+static inline void cec_ops_deck_status(struct cec_msg *msg,
+				       __u8 *deck_info)
+{
+	*deck_info = msg->msg[2];
+}
+
+static inline void cec_msg_give_deck_status(struct cec_msg *msg,
+					    bool reply,
+					    __u8 status_req)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_GIVE_DECK_STATUS;
+	msg->msg[2] = status_req;
+	msg->reply = reply ? CEC_MSG_DECK_STATUS : 0;
+}
+
+static inline void cec_ops_give_deck_status(struct cec_msg *msg,
+					    __u8 *status_req)
+{
+	*status_req = msg->msg[2];
+}
+
+static inline void cec_msg_play(struct cec_msg *msg,
+				__u8 play_mode)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_PLAY;
+	msg->msg[2] = play_mode;
+}
+
+static inline void cec_ops_play(struct cec_msg *msg,
+				__u8 *play_mode)
+{
+	*play_mode = msg->msg[2];
+}
+
+
+/* Tuner Control Feature */
+struct cec_op_tuner_device_info {
+	__u8 rec_flag;
+	__u8 tuner_display_info;
+	bool is_analog;
+	union {
+		struct cec_op_digital_service_id digital;
+		struct {
+			__u8 ana_bcast_type;
+			__u16 ana_freq;
+			__u8 bcast_system;
+		} analog;
+	};
+};
+
+static inline void cec_msg_tuner_device_status_analog(struct cec_msg *msg,
+						      __u8 rec_flag,
+						      __u8 tuner_display_info,
+						      __u8 ana_bcast_type,
+						      __u16 ana_freq,
+						      __u8 bcast_system)
+{
+	msg->len = 7;
+	msg->msg[1] = CEC_MSG_TUNER_DEVICE_STATUS;
+	msg->msg[2] = (rec_flag << 7) | tuner_display_info;
+	msg->msg[3] = ana_bcast_type;
+	msg->msg[4] = ana_freq >> 8;
+	msg->msg[5] = ana_freq & 0xff;
+	msg->msg[6] = bcast_system;
+}
+
+static inline void cec_msg_tuner_device_status_digital(struct cec_msg *msg,
+		   __u8 rec_flag, __u8 tuner_display_info,
+		   const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 10;
+	msg->msg[1] = CEC_MSG_TUNER_DEVICE_STATUS;
+	msg->msg[2] = (rec_flag << 7) | tuner_display_info;
+	cec_set_digital_service_id(msg->msg + 3, digital);
+}
+
+static inline void cec_msg_tuner_device_status(struct cec_msg *msg,
+			const struct cec_op_tuner_device_info *tuner_dev_info)
+{
+	if (tuner_dev_info->is_analog)
+		cec_msg_tuner_device_status_analog(msg,
+			tuner_dev_info->rec_flag,
+			tuner_dev_info->tuner_display_info,
+			tuner_dev_info->analog.ana_bcast_type,
+			tuner_dev_info->analog.ana_freq,
+			tuner_dev_info->analog.bcast_system);
+	else
+		cec_msg_tuner_device_status_digital(msg,
+			tuner_dev_info->rec_flag,
+			tuner_dev_info->tuner_display_info,
+			&tuner_dev_info->digital);
+}
+
+static inline void cec_ops_tuner_device_status(struct cec_msg *msg,
+					       struct cec_op_tuner_device_info *tuner_dev_info)
+{
+	tuner_dev_info->is_analog = msg->len < 10;
+	tuner_dev_info->rec_flag = msg->msg[2] >> 7;
+	tuner_dev_info->tuner_display_info = msg->msg[2] & 0x7f;
+	if (tuner_dev_info->is_analog) {
+		tuner_dev_info->analog.ana_bcast_type = msg->msg[3];
+		tuner_dev_info->analog.ana_freq = (msg->msg[4] << 8) | msg->msg[5];
+		tuner_dev_info->analog.bcast_system = msg->msg[6];
+		return;
+	}
+	cec_get_digital_service_id(msg->msg + 3, &tuner_dev_info->digital);
+}
+
+static inline void cec_msg_give_tuner_device_status(struct cec_msg *msg,
+						    bool reply,
+						    __u8 status_req)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_GIVE_TUNER_DEVICE_STATUS;
+	msg->msg[2] = status_req;
+	msg->reply = reply ? CEC_MSG_TUNER_DEVICE_STATUS : 0;
+}
+
+static inline void cec_ops_give_tuner_device_status(struct cec_msg *msg,
+						    __u8 *status_req)
+{
+	*status_req = msg->msg[2];
+}
+
+static inline void cec_msg_select_analogue_service(struct cec_msg *msg,
+						   __u8 ana_bcast_type,
+						   __u16 ana_freq,
+						   __u8 bcast_system)
+{
+	msg->len = 6;
+	msg->msg[1] = CEC_MSG_SELECT_ANALOGUE_SERVICE;
+	msg->msg[2] = ana_bcast_type;
+	msg->msg[3] = ana_freq >> 8;
+	msg->msg[4] = ana_freq & 0xff;
+	msg->msg[5] = bcast_system;
+}
+
+static inline void cec_ops_select_analogue_service(struct cec_msg *msg,
+						   __u8 *ana_bcast_type,
+						   __u16 *ana_freq,
+						   __u8 *bcast_system)
+{
+	*ana_bcast_type = msg->msg[2];
+	*ana_freq = (msg->msg[3] << 8) | msg->msg[4];
+	*bcast_system = msg->msg[5];
+}
+
+static inline void cec_msg_select_digital_service(struct cec_msg *msg,
+						  const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 9;
+	msg->msg[1] = CEC_MSG_SELECT_DIGITAL_SERVICE;
+	cec_set_digital_service_id(msg->msg + 2, digital);
+}
+
+static inline void cec_ops_select_digital_service(struct cec_msg *msg,
+						  struct cec_op_digital_service_id *digital)
+{
+	cec_get_digital_service_id(msg->msg + 2, digital);
+}
+
+static inline void cec_msg_tuner_step_decrement(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TUNER_STEP_DECREMENT;
+}
+
+static inline void cec_msg_tuner_step_increment(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TUNER_STEP_INCREMENT;
+}
+
+
+/* Vendor Specific Commands Feature */
+static inline void cec_msg_device_vendor_id(struct cec_msg *msg, __u32 vendor_id)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_DEVICE_VENDOR_ID;
+	msg->msg[2] = vendor_id >> 16;
+	msg->msg[3] = (vendor_id >> 8) & 0xff;
+	msg->msg[4] = vendor_id & 0xff;
+}
+
+static inline void cec_ops_device_vendor_id(const struct cec_msg *msg,
+					    __u32 *vendor_id)
+{
+	*vendor_id = (msg->msg[2] << 16) | (msg->msg[3] << 8) | msg->msg[4];
+}
+
+static inline void cec_msg_give_device_vendor_id(struct cec_msg *msg,
+						 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_DEVICE_VENDOR_ID;
+	msg->reply = reply ? CEC_MSG_DEVICE_VENDOR_ID : 0;
+}
+
+static inline void cec_msg_vendor_remote_button_up(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_VENDOR_REMOTE_BUTTON_UP;
+}
+
+
+/* OSD Display Feature */
+static inline void cec_msg_set_osd_string(struct cec_msg *msg,
+					  __u8 disp_ctl,
+					  const char *osd)
+{
+	unsigned len = strlen(osd);
+
+	if (len > 13)
+		len = 13;
+	msg->len = 3 + len;
+	msg->msg[1] = CEC_MSG_SET_OSD_STRING;
+	msg->msg[2] = disp_ctl;
+	memcpy(msg->msg + 3, osd, len);
+}
+
+static inline void cec_ops_set_osd_string(const struct cec_msg *msg,
+					  __u8 *disp_ctl,
+					  char *osd)
+{
+	unsigned len = msg->len - 3;
+
+	*disp_ctl = msg->msg[2];
+	if (len > 13)
+		len = 13;
+	memcpy(osd, msg->msg + 3, len);
+	osd[len] = '\0';
+}
+
+
+/* Device OSD Transfer Feature */
+static inline void cec_msg_set_osd_name(struct cec_msg *msg, const char *name)
+{
+	unsigned len = strlen(name);
+
+	if (len > 14)
+		len = 14;
+	msg->len = 2 + len;
+	msg->msg[1] = CEC_MSG_SET_OSD_NAME;
+	memcpy(msg->msg + 2, name, len);
+}
+
+static inline void cec_ops_set_osd_name(const struct cec_msg *msg,
+					char *name)
+{
+	unsigned len = msg->len - 2;
+
+	if (len > 14)
+		len = 14;
+	memcpy(name, msg->msg + 2, len);
+	name[len] = '\0';
+}
+
+static inline void cec_msg_give_osd_name(struct cec_msg *msg,
+					 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_OSD_NAME;
+	msg->reply = reply ? CEC_MSG_SET_OSD_NAME : 0;
+}
+
+
+/* Device Menu Control Feature */
+static inline void cec_msg_menu_status(struct cec_msg *msg,
+				       __u8 menu_state)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_MENU_STATUS;
+	msg->msg[2] = menu_state;
+}
+
+static inline void cec_ops_menu_status(struct cec_msg *msg,
+				       __u8 *menu_state)
+{
+	*menu_state = msg->msg[2];
+}
+
+static inline void cec_msg_menu_request(struct cec_msg *msg,
+					bool reply,
+					__u8 menu_req)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_MENU_REQUEST;
+	msg->msg[2] = menu_req;
+	msg->reply = reply ? CEC_MSG_MENU_STATUS : 0;
+}
+
+static inline void cec_ops_menu_request(struct cec_msg *msg,
+					__u8 *menu_req)
+{
+	*menu_req = msg->msg[2];
+}
+
+static inline void cec_msg_user_control_pressed(struct cec_msg *msg,
+						__u8 ui_cmd)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_USER_CONTROL_PRESSED;
+	msg->msg[2] = ui_cmd;
+}
+
+static inline void cec_ops_user_control_pressed(struct cec_msg *msg,
+						__u8 *ui_cmd)
+{
+	*ui_cmd = msg->msg[2];
+}
+
+static inline void cec_msg_user_control_released(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_USER_CONTROL_RELEASED;
+}
+
+/* Remote Control Passthrough Feature */
+
+/* Power Status Feature */
+static inline void cec_msg_report_power_status(struct cec_msg *msg,
+					       __u8 pwr_state)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_REPORT_POWER_STATUS;
+	msg->msg[2] = pwr_state;
+}
+
+static inline void cec_ops_report_power_status(const struct cec_msg *msg,
+					       __u8 *pwr_state)
+{
+	*pwr_state = msg->msg[2];
+}
+
+static inline void cec_msg_give_device_power_status(struct cec_msg *msg,
+						    bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_DEVICE_POWER_STATUS;
+	msg->reply = reply ? CEC_MSG_REPORT_POWER_STATUS : 0;
+}
+
+/* General Protocol Messages */
+static inline void cec_msg_feature_abort(struct cec_msg *msg,
+					 __u8 abort_msg, __u8 reason)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_FEATURE_ABORT;
+	msg->msg[2] = abort_msg;
+	msg->msg[3] = reason;
+}
+
+static inline void cec_ops_feature_abort(const struct cec_msg *msg,
+					 __u8 *abort_msg, __u8 *reason)
+{
+	*abort_msg = msg->msg[2];
+	*reason = msg->msg[3];
+}
+
+/* This changes the current message into an abort message */
+static inline void cec_msg_reply_abort(struct cec_msg *msg, __u8 reason)
+{
+	cec_msg_set_reply_to(msg, msg);
+	msg->len = 4;
+	msg->msg[2] = msg->msg[1];
+	msg->msg[3] = reason;
+	msg->msg[1] = CEC_MSG_FEATURE_ABORT;
+}
+
+static inline void cec_msg_abort(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_ABORT;
+}
+
+
+/* System Audio Control Feature */
+static inline void cec_msg_report_audio_status(struct cec_msg *msg,
+					       __u8 aud_mute_status,
+					       __u8 aud_vol_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_REPORT_AUDIO_STATUS;
+	msg->msg[2] = (aud_mute_status << 7) | (aud_vol_status & 0x7f);
+}
+
+static inline void cec_ops_report_audio_status(const struct cec_msg *msg,
+					       __u8 *aud_mute_status,
+					       __u8 *aud_vol_status)
+{
+	*aud_mute_status = msg->msg[2] >> 7;
+	*aud_vol_status = msg->msg[2] & 0x7f;
+}
+
+static inline void cec_msg_give_audio_status(struct cec_msg *msg,
+					     bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_AUDIO_STATUS;
+	msg->reply = reply ? CEC_MSG_REPORT_AUDIO_STATUS : 0;
+}
+
+static inline void cec_msg_set_system_audio_mode(struct cec_msg *msg,
+						 __u8 sys_aud_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_SET_SYSTEM_AUDIO_MODE;
+	msg->msg[2] = sys_aud_status;
+}
+
+static inline void cec_ops_set_system_audio_mode(const struct cec_msg *msg,
+						 __u8 *sys_aud_status)
+{
+	*sys_aud_status = msg->msg[2];
+}
+
+static inline void cec_msg_system_audio_mode_request(struct cec_msg *msg,
+						     bool reply,
+						     __u16 phys_addr)
+{
+	msg->len = phys_addr == 0xffff ? 2 : 4;
+	msg->msg[1] = CEC_MSG_SYSTEM_AUDIO_MODE_REQUEST;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_SET_SYSTEM_AUDIO_MODE : 0;
+
+}
+
+static inline void cec_ops_system_audio_mode_request(const struct cec_msg *msg,
+						     __u16 *phys_addr)
+{
+	if (msg->len < 4)
+		*phys_addr = 0xffff;
+	else
+		*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static inline void cec_msg_system_audio_mode_status(struct cec_msg *msg,
+						    __u8 sys_aud_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_SYSTEM_AUDIO_MODE_STATUS;
+	msg->msg[2] = sys_aud_status;
+}
+
+static inline void cec_ops_system_audio_mode_status(const struct cec_msg *msg,
+						    __u8 *sys_aud_status)
+{
+	*sys_aud_status = msg->msg[2];
+}
+
+static inline void cec_msg_give_system_audio_mode_status(struct cec_msg *msg,
+							 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS;
+	msg->reply = reply ? CEC_MSG_SYSTEM_AUDIO_MODE_STATUS : 0;
+}
+
+static inline void cec_msg_report_short_audio_descriptor(struct cec_msg *msg,
+							 __u8 num_descriptors,
+							 const __u32 *descriptors)
+{
+	unsigned i;
+
+	msg->len = 2 + num_descriptors * 3;
+	msg->msg[1] = CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR;
+	for (i = 0; i < num_descriptors; i++) {
+		msg->msg[2 + i * 3] = (descriptors[i] >> 16) & 0xff;
+		msg->msg[3 + i * 3] = (descriptors[i] >> 8) & 0xff;
+		msg->msg[4 + i * 3] = descriptors[i] & 0xff;
+	}
+}
+
+static inline void cec_ops_report_short_audio_descriptor(const struct cec_msg *msg,
+							 __u8 *num_descriptors,
+							 __u32 *descriptors)
+{
+	unsigned i;
+
+	*num_descriptors = (msg->len - 2) / 3;
+	for (i = 0; i < *num_descriptors; i++)
+		descriptors[i] = (msg->msg[2 + i * 3] << 16) |
+			(msg->msg[3 + i * 3] << 8) |
+			msg->msg[4 + i * 3];
+}
+
+static inline void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
+							  __u8 audio_format_id,
+							  __u8 audio_format_code)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR;
+	msg->msg[2] = (audio_format_id << 6) | (audio_format_code & 0x3f);
+}
+
+static inline void cec_ops_request_short_audio_descriptor(const struct cec_msg *msg,
+							  __u8 *audio_format_id,
+							  __u8 *audio_format_code)
+{
+	*audio_format_id = msg->msg[2] >> 6;
+	*audio_format_code = msg->msg[2] & 0x3f;
+}
+
+
+/* Audio Rate Control Feature */
+static inline void cec_msg_set_audio_rate(struct cec_msg *msg,
+					  __u8 audio_rate)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_SET_AUDIO_RATE;
+	msg->msg[2] = audio_rate;
+}
+
+static inline void cec_ops_set_audio_rate(const struct cec_msg *msg,
+					  __u8 *audio_rate)
+{
+	*audio_rate = msg->msg[2];
+}
+
+
+/* Audio Return Channel Control Feature */
+static inline void cec_msg_report_arc_initiated(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REPORT_ARC_INITIATED;
+}
+
+static inline void cec_msg_initiate_arc(struct cec_msg *msg,
+					bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_INITIATE_ARC;
+	msg->reply = reply ? CEC_MSG_REPORT_ARC_INITIATED : 0;
+}
+
+static inline void cec_msg_request_arc_initiation(struct cec_msg *msg,
+						  bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REQUEST_ARC_INITIATION;
+	msg->reply = reply ? CEC_MSG_INITIATE_ARC : 0;
+}
+
+static inline void cec_msg_report_arc_terminated(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REPORT_ARC_TERMINATED;
+}
+
+static inline void cec_msg_terminate_arc(struct cec_msg *msg,
+					 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TERMINATE_ARC;
+	msg->reply = reply ? CEC_MSG_REPORT_ARC_TERMINATED : 0;
+}
+
+static inline void cec_msg_request_arc_termination(struct cec_msg *msg,
+						   bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REQUEST_ARC_TERMINATION;
+	msg->reply = reply ? CEC_MSG_TERMINATE_ARC : 0;
+}
+
+
+/* Dynamic Audio Lipsync Feature */
+/* Only for CEC 2.0 and up */
+static inline void cec_msg_report_current_latency(struct cec_msg *msg,
+						  __u16 phys_addr,
+						  __u8 video_latency,
+						  __u8 low_latency_mode,
+						  __u8 audio_out_compensated,
+						  __u8 audio_out_delay)
+{
+	msg->len = 7;
+	msg->msg[1] = CEC_MSG_REPORT_CURRENT_LATENCY;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->msg[4] = video_latency;
+	msg->msg[5] = (low_latency_mode << 2) | audio_out_compensated;
+	msg->msg[6] = audio_out_delay;
+}
+
+static inline void cec_ops_report_current_latency(const struct cec_msg *msg,
+						  __u16 *phys_addr,
+						  __u8 *video_latency,
+						  __u8 *low_latency_mode,
+						  __u8 *audio_out_compensated,
+						  __u8 *audio_out_delay)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*video_latency = msg->msg[4];
+	*low_latency_mode = (msg->msg[5] >> 2) & 1;
+	*audio_out_compensated = msg->msg[5] & 3;
+	*audio_out_delay = msg->msg[6];
+}
+
+static inline void cec_msg_request_current_latency(struct cec_msg *msg,
+						   bool reply,
+						   __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_REQUEST_CURRENT_LATENCY;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_REPORT_CURRENT_LATENCY : 0;
+}
+
+static inline void cec_ops_request_current_latency(const struct cec_msg *msg,
+						   __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+
+/* Capability Discovery and Control Feature */
+static inline void cec_msg_cdc_hec_inquire_state(struct cec_msg *msg,
+						 __u16 phys_addr1,
+						 __u16 phys_addr2)
+{
+	msg->len = 9;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_INQUIRE_STATE;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = phys_addr2 >> 8;
+	msg->msg[8] = phys_addr2 & 0xff;
+}
+
+static inline void cec_ops_cdc_hec_inquire_state(const struct cec_msg *msg,
+						 __u16 *phys_addr,
+						 __u16 *phys_addr1,
+						 __u16 *phys_addr2)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*phys_addr2 = (msg->msg[7] << 8) | msg->msg[8];
+}
+
+static inline void cec_msg_cdc_hec_report_state(struct cec_msg *msg,
+						__u16 target_phys_addr,
+						__u8 hec_func_state,
+						__u8 host_func_state,
+						__u8 enc_func_state,
+						__u8 cdc_errcode,
+						__u8 has_field,
+						__u16 hec_field)
+{
+	msg->len = has_field ? 10 : 8;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_REPORT_STATE;
+	msg->msg[5] = target_phys_addr >> 8;
+	msg->msg[6] = target_phys_addr & 0xff;
+	msg->msg[7] = (hec_func_state << 6) |
+		      (host_func_state << 4) |
+		      (enc_func_state << 2) |
+		      cdc_errcode;
+	if (has_field) {
+		msg->msg[8] = hec_field >> 8;
+		msg->msg[9] = hec_field & 0xff;
+	}
+}
+
+static inline void cec_ops_cdc_hec_report_state(const struct cec_msg *msg,
+						__u16 *phys_addr,
+						__u16 *target_phys_addr,
+						__u8 *hec_func_state,
+						__u8 *host_func_state,
+						__u8 *enc_func_state,
+						__u8 *cdc_errcode,
+						__u8 *has_field,
+						__u16 *hec_field)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*target_phys_addr = (msg->msg[5] << 8) | msg->msg[6];
+	*hec_func_state = msg->msg[7] >> 6;
+	*host_func_state = (msg->msg[7] >> 4) & 3;
+	*enc_func_state = (msg->msg[7] >> 4) & 3;
+	*cdc_errcode = msg->msg[7] & 3;
+	*has_field = msg->len >= 10;
+	*hec_field = *has_field ? ((msg->msg[8] << 8) | msg->msg[9]) : 0;
+}
+
+static inline void cec_msg_cdc_hec_set_state(struct cec_msg *msg,
+					     __u16 phys_addr1,
+					     __u16 phys_addr2,
+					     __u8 hec_set_state,
+					     __u16 phys_addr3,
+					     __u16 phys_addr4,
+					     __u16 phys_addr5)
+{
+	msg->len = 10;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_INQUIRE_STATE;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = phys_addr2 >> 8;
+	msg->msg[8] = phys_addr2 & 0xff;
+	msg->msg[9] = hec_set_state;
+	if (phys_addr3 != CEC_PHYS_ADDR_INVALID) {
+		msg->msg[msg->len++] = phys_addr3 >> 8;
+		msg->msg[msg->len++] = phys_addr3 & 0xff;
+		if (phys_addr4 != CEC_PHYS_ADDR_INVALID) {
+			msg->msg[msg->len++] = phys_addr4 >> 8;
+			msg->msg[msg->len++] = phys_addr4 & 0xff;
+			if (phys_addr5 != CEC_PHYS_ADDR_INVALID) {
+				msg->msg[msg->len++] = phys_addr5 >> 8;
+				msg->msg[msg->len++] = phys_addr5 & 0xff;
+			}
+		}
+	}
+}
+
+static inline void cec_ops_cdc_hec_set_state(const struct cec_msg *msg,
+					     __u16 *phys_addr,
+					     __u16 *phys_addr1,
+					     __u16 *phys_addr2,
+					     __u8 *hec_set_state,
+					     __u16 *phys_addr3,
+					     __u16 *phys_addr4,
+					     __u16 *phys_addr5)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*phys_addr2 = (msg->msg[7] << 8) | msg->msg[8];
+	*hec_set_state = msg->msg[9];
+	*phys_addr3 = *phys_addr4 = *phys_addr5 = CEC_PHYS_ADDR_INVALID;
+	if (msg->len >= 12)
+		*phys_addr3 = (msg->msg[10] << 8) | msg->msg[11];
+	if (msg->len >= 14)
+		*phys_addr4 = (msg->msg[12] << 8) | msg->msg[13];
+	if (msg->len >= 16)
+		*phys_addr5 = (msg->msg[14] << 8) | msg->msg[15];
+}
+
+static inline void cec_msg_cdc_hec_set_state_adjacent(struct cec_msg *msg,
+						      __u16 phys_addr1,
+						      __u8 hec_set_state)
+{
+	msg->len = 8;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_SET_STATE_ADJACENT;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = hec_set_state;
+}
+
+static inline void cec_ops_cdc_hec_set_state_adjacent(const struct cec_msg *msg,
+						      __u16 *phys_addr,
+						      __u16 *phys_addr1,
+						      __u8 *hec_set_state)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*hec_set_state = msg->msg[7];
+}
+
+static inline void cec_msg_cdc_hec_request_deactivation(struct cec_msg *msg,
+							__u16 phys_addr1,
+							__u16 phys_addr2,
+							__u16 phys_addr3)
+{
+	msg->len = 11;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_REQUEST_DEACTIVATION;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = phys_addr2 >> 8;
+	msg->msg[8] = phys_addr2 & 0xff;
+	msg->msg[9] = phys_addr3 >> 8;
+	msg->msg[10] = phys_addr3 & 0xff;
+}
+
+static inline void cec_ops_cdc_hec_request_deactivation(const struct cec_msg *msg,
+							__u16 *phys_addr,
+							__u16 *phys_addr1,
+							__u16 *phys_addr2,
+							__u16 *phys_addr3)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*phys_addr2 = (msg->msg[7] << 8) | msg->msg[8];
+	*phys_addr3 = (msg->msg[9] << 8) | msg->msg[10];
+}
+
+static inline void cec_msg_cdc_hec_notify_alive(struct cec_msg *msg)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_NOTIFY_ALIVE;
+}
+
+static inline void cec_ops_cdc_hec_notify_alive(const struct cec_msg *msg,
+						__u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static inline void cec_msg_cdc_hec_discover(struct cec_msg *msg)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_DISCOVER;
+}
+
+static inline void cec_ops_cdc_hec_discover(const struct cec_msg *msg,
+					    __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static inline void cec_msg_cdc_hpd_set_state(struct cec_msg *msg,
+					     __u8 input_port,
+					     __u8 hpd_state)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HPD_SET_STATE;
+	msg->msg[5] = (input_port << 4) | hpd_state;
+}
+
+static inline void cec_ops_cdc_hpd_set_state(const struct cec_msg *msg,
+					    __u16 *phys_addr,
+					    __u8 *input_port,
+					    __u8 *hpd_state)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*input_port = msg->msg[5] >> 4;
+	*hpd_state = msg->msg[5] & 0xf;
+}
+
+static inline void cec_msg_cdc_hpd_report_state(struct cec_msg *msg,
+						__u8 hpd_state,
+						__u8 hpd_error)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HPD_REPORT_STATE;
+	msg->msg[5] = (hpd_state << 4) | hpd_error;
+}
+
+static inline void cec_ops_cdc_hpd_report_state(const struct cec_msg *msg,
+						__u16 *phys_addr,
+						__u8 *hpd_state,
+						__u8 *hpd_error)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*hpd_state = msg->msg[5] >> 4;
+	*hpd_error = msg->msg[5] & 0xf;
+}
+
+#endif
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
new file mode 100644
index 0000000..3cc4b98
--- /dev/null
+++ b/include/uapi/linux/cec.h
@@ -0,0 +1,781 @@
+#ifndef _CEC_H
+#define _CEC_H
+
+#include <linux/types.h>
+
+struct cec_msg {
+	__u64 ts;
+	__u32 len;
+	__u32 status;
+	/*
+	 * timeout (in ms) is used to timeout CEC_RECEIVE.
+	 * Set to 0 if you want to wait forever.
+	 */
+	__u32 timeout;
+	/*
+	 * The framework assigns a sequence number to messages that are sent.
+	 * This can be used to track replies to previously sent messages.
+	 */
+	__u32 sequence;
+	__u8 msg[16];
+	/*
+	 * If non-zero, then wait for a reply with this opcode.
+	 * If there was an error when sending the msg or FeatureAbort
+	 * was returned, then reply is set to 0.
+	 * If reply is non-zero upon return, then len/msg are set to
+	 * the received message.
+	 * If reply is zero upon return and status has the
+	 * CEC_TX_STATUS_FEATURE_ABORT bit set, then len/msg are set to the
+	 * received feature abort message.
+	 * If reply is zero upon return and status has the
+	 * CEC_TX_STATUS_REPLY_TIMEOUT
+	 * bit set, then no reply was seen at all.
+	 * This field is ignored with CEC_RECEIVE.
+	 * If reply is non-zero for CEC_TRANSMIT and the message is a broadcast,
+	 * then -EINVAL is returned.
+	 * if reply is non-zero, then timeout is set to 1000 (the required
+	 * maximum response time).
+	 */
+	__u8 reply;
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
+static inline void cec_msg_init(struct cec_msg *msg,
+				__u8 initiator, __u8 destination)
+{
+	memset(msg, 0, sizeof(*msg));
+	msg->msg[0] = (initiator << 4) | destination;
+	msg->len = 1;
+}
+
+/*
+ * Set the msg destination to the orig initiator and the msg initiator to the
+ * orig destination. Note that msg and orig may be the same pointer, in which
+ * case the change is done in place.
+ */
+static inline void cec_msg_set_reply_to(struct cec_msg *msg, struct cec_msg *orig)
+{
+	/* The destination becomes the initiator and vice versa */
+	msg->msg[0] = (cec_msg_destination(orig) << 4) | cec_msg_initiator(orig);
+}
+
+/* cec status field */
+#define CEC_TX_STATUS_OK		(0)
+#define CEC_TX_STATUS_ARB_LOST		(1 << 0)
+#define CEC_TX_STATUS_RETRY_TIMEOUT	(1 << 1)
+#define CEC_TX_STATUS_FEATURE_ABORT	(1 << 2)
+#define CEC_TX_STATUS_REPLY_TIMEOUT	(1 << 3)
+#define CEC_RX_STATUS_READY		(0)
+
+#define CEC_LOG_ADDR_INVALID		0xff
+#define CEC_PHYS_ADDR_INVALID		0xffff
+
+/* The maximum number of logical addresses one device can be assigned to.
+ * The CEC 2.0 spec allows for only 2 logical addresses at the moment. The
+ * Analog Devices CEC hardware supports 3. So let's go wild and go for 4. */
+#define CEC_MAX_LOG_ADDRS 4
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
+ * Processors should use SPECIFIC. */
+
+/*
+ * Use this if there is no vendor ID (CEC_G_VENDOR_ID) or if the vendor ID
+ * should be disabled (CEC_S_VENDOR_ID)
+ */
+#define CEC_VENDOR_ID_NONE		0xffffffff
+
+/* The CEC adapter state */
+#define CEC_ADAP_DISABLED		0
+#define CEC_ADAP_ENABLED		1
+
+/* The passthrough mode state */
+#define CEC_PASSTHROUGH_DISABLED	0
+#define CEC_PASSTHROUGH_ENABLED		1
+
+/* The monitor state */
+#define CEC_MONITOR_DISABLED		0
+#define CEC_MONITOR_ENABLED		1
+
+/* Userspace has to configure the adapter state (enable/disable) */
+#define CEC_CAP_STATE		(1 << 0)
+/* Userspace has to configure the physical address */
+#define CEC_CAP_PHYS_ADDR	(1 << 1)
+/* Userspace has to configure the logical addresses */
+#define CEC_CAP_LOG_ADDRS	(1 << 2)
+/* Userspace can transmit and receive messages */
+#define CEC_CAP_IO		(1 << 3)
+/* Userspace has to configure the vendor id */
+#define CEC_CAP_VENDOR_ID	(1 << 4)
+/*
+ * Passthrough all messages instead of processing them.
+ * Note: ARC and CDC messages are always processed.
+ */
+#define CEC_CAP_PASSTHROUGH	(1 << 5)
+/* Supports remote control */
+#define CEC_CAP_RC		(1 << 6)
+/* Supports ARC */
+#define CEC_CAP_ARC		(1 << 7)
+/* Supports CDC HPD */
+#define CEC_CAP_CDC_HPD		(1 << 8)
+/* Is a source */
+#define CEC_CAP_IS_SOURCE	(1 << 9)
+
+struct cec_caps {
+	__u32 available_log_addrs;
+	__u32 capabilities;
+	__u8 ninputs;
+	__u8  reserved[39];
+};
+
+struct cec_log_addrs {
+	__u8 cec_version;
+	__u8 num_log_addrs;
+	__u8 primary_device_type[CEC_MAX_LOG_ADDRS];
+	__u8 log_addr_type[CEC_MAX_LOG_ADDRS];
+	__u8 log_addr[CEC_MAX_LOG_ADDRS];
+	char osd_name[15];
+
+	/* CEC 2.0 */
+	__u8 all_device_types[CEC_MAX_LOG_ADDRS];
+	__u8 features[CEC_MAX_LOG_ADDRS][12];
+
+	__u8 reserved[63];
+};
+
+/* Events */
+
+/* Event that occurs when the adapter state changes */
+#define CEC_EVENT_STATE_CHANGE	1
+/* Event that occurs when inputs are connected/disconnected */
+#define CEC_EVENT_INPUTS_CHANGE	2
+/* This event is sent when messages are lost because the application
+ * didn't empty the message queue in time */
+#define CEC_EVENT_LOST_MSGS	3
+
+#define CEC_EVENT_STATE_DISABLED	0
+#define CEC_EVENT_STATE_UNCONFIGURED	1
+#define CEC_EVENT_STATE_CONFIGURING	2
+#define CEC_EVENT_STATE_CONFIGURED	3
+
+struct cec_event_state_change {
+	/* current CEC adapter state */
+	__u8 state;
+};
+
+struct cec_event_inputs_change {
+	/* bit 0 == input port 0, bit 15 == input port 15 */
+	/* currently connected input ports */
+	__u16 connected_inputs;
+	/* input ports that changed state since last event */
+	__u16 changed_inputs;
+};
+
+struct cec_event {
+	__u64 ts;
+	__u32 event;
+	__u32 reserved[7];
+	union {
+		struct cec_event_state_change state_change;
+		struct cec_event_inputs_change inputs_change;
+		__u32 raw[16];
+	};
+};
+
+/* ioctls */
+
+/* Adapter capabilities */
+#define CEC_ADAP_G_CAPS		_IOWR('a',  0, struct cec_caps)
+
+/*
+   Configure the CEC adapter. It sets the device type and which
+   logical types it will try to claim. It will return which
+   logical addresses it could actually claim.
+   An error is returned if the adapter is disabled or if there
+   is no physical address assigned.
+ */
+
+#define CEC_ADAP_G_LOG_ADDRS	_IOR ('a',  1, struct cec_log_addrs)
+#define CEC_ADAP_S_LOG_ADDRS	_IOWR('a',  2, struct cec_log_addrs)
+
+/*
+   Enable/disable the adapter. The Set state ioctl may not
+   be available if that is handled internally.
+ */
+#define CEC_ADAP_G_STATE	_IOR ('a',  3, __u32)
+#define CEC_ADAP_S_STATE	_IOW ('a',  4, __u32)
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
+#define CEC_ADAP_G_PHYS_ADDR	_IOR ('a',  5, __u16)
+#define CEC_ADAP_S_PHYS_ADDR	_IOW ('a',  6, __u16)
+
+/*
+   Read and set the vendor ID of the CEC adapter.
+ */
+#define CEC_ADAP_G_VENDOR_ID	_IOR ('a',  7, __u32)
+#define CEC_ADAP_S_VENDOR_ID	_IOW ('a',  8, __u32)
+
+/*
+   Read and set the monitor state of the filehandle.
+ */
+#define CEC_G_MONITOR		_IOR ('a',  9, __u32)
+#define CEC_S_MONITOR		_IOW ('a', 10, __u32)
+
+/*
+   Claim message handling and set passthrough mode,
+   release message handling and get passthrough mode for
+   this filehandle.
+ */
+#define CEC_CLAIM		_IOW ('a', 11, __u32)
+#define CEC_RELEASE		_IO  ('a', 12)
+#define CEC_G_PASSTHROUGH	_IOR ('a', 13, __u32)
+
+/* Transmit/receive a CEC command */
+#define CEC_TRANSMIT		_IOWR('a', 14, struct cec_msg)
+#define CEC_RECEIVE		_IOWR('a', 15, struct cec_msg)
+
+/* Dequeue CEC events */
+#define CEC_DQEVENT		_IOWR('a', 16, struct cec_event)
+
+/* Commands */
+
+/* One Touch Play Feature */
+#define CEC_MSG_ACTIVE_SOURCE				0x82
+#define CEC_MSG_IMAGE_VIEW_ON				0x04
+#define CEC_MSG_TEXT_VIEW_ON				0x0d
+
+
+/* Routing Control Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_ACTIVE_SOURCE
+ */
+
+#define CEC_MSG_INACTIVE_SOURCE				0x9d
+#define CEC_MSG_REQUEST_ACTIVE_SOURCE			0x85
+#define CEC_MSG_ROUTING_CHANGE				0x80
+#define CEC_MSG_ROUTING_INFORMATION			0x81
+#define CEC_MSG_SET_STREAM_PATH				0x86
+
+
+/* Standby Feature */
+#define CEC_MSG_STANDBY					0x36
+
+
+/* One Touch Record Feature */
+#define CEC_MSG_RECORD_OFF				0x0b
+#define CEC_MSG_RECORD_ON				0x09
+/* Record Source Type Operand (rec_src_type) */
+#define CEC_OP_RECORD_SRC_OWN				1
+#define CEC_OP_RECORD_SRC_DIGITAL			2
+#define CEC_OP_RECORD_SRC_ANALOG			3
+#define CEC_OP_RECORD_SRC_EXT_PLUG			4
+#define CEC_OP_RECORD_SRC_EXT_PHYS_ADDR			5
+/* Service Identification Method Operand (service_id_method) */
+#define CEC_OP_SERVICE_ID_METHOD_BY_DIG_ID		0
+#define CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL		1
+/* Digital Service Broadcast System Operand (dig_bcast_system) */
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_GEN	0x00
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN	0x01
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_GEN		0x02
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_BS		0x08
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_CS		0x09
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_T		0x0a
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE	0x10
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT	0x11
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T		0x12
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_C		0x18
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S		0x19
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S2		0x1a
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_T		0x1b
+/* Analogue Broadcast Type Operand (ana_bcast_type) */
+#define CEC_OP_ANA_BCAST_TYPE_CABLE			0
+#define CEC_OP_ANA_BCAST_TYPE_SATELLITE			1
+#define CEC_OP_ANA_BCAST_TYPE_TERRESTRIAL		2
+/* Broadcast System Operand (bcast_system) */
+#define CEC_OP_BCAST_SYSTEM_PAL_BG			0x00
+#define CEC_OP_BCAST_SYSTEM_SECAM_LQ			0x01 /* SECAM L' */
+#define CEC_OP_BCAST_SYSTEM_PAL_M			0x02
+#define CEC_OP_BCAST_SYSTEM_NTSC_M			0x03
+#define CEC_OP_BCAST_SYSTEM_PAL_I			0x04
+#define CEC_OP_BCAST_SYSTEM_SECAM_DK			0x05
+#define CEC_OP_BCAST_SYSTEM_SECAM_BG			0x06
+#define CEC_OP_BCAST_SYSTEM_SECAM_L			0x07
+#define CEC_OP_BCAST_SYSTEM_PAL_DK			0x08
+#define CEC_OP_BCAST_SYSTEM_OTHER			0x1f
+/* Channel Number Format Operand (channel_number_fmt) */
+#define CEC_OP_CHANNEL_NUMBER_FMT_1_PART		0x01
+#define CEC_OP_CHANNEL_NUMBER_FMT_2_PART		0x02
+
+#define CEC_MSG_RECORD_STATUS				0x0a
+/* Record Status Operand (rec_status) */
+#define CEC_OP_RECORD_STATUS_CUR_SRC			0x01
+#define CEC_OP_RECORD_STATUS_DIG_SERVICE		0x02
+#define CEC_OP_RECORD_STATUS_ANA_SERVICE		0x03
+#define CEC_OP_RECORD_STATUS_EXT_INPUT			0x04
+#define CEC_OP_RECORD_STATUS_NO_DIG_SERVICE		0x05
+#define CEC_OP_RECORD_STATUS_NO_ANA_SERVICE		0x06
+#define CEC_OP_RECORD_STATUS_NO_SERVICE			0x07
+#define CEC_OP_RECORD_STATUS_INVALID_EXT_PLUG		0x09
+#define CEC_OP_RECORD_STATUS_INVALID_EXT_PHYS_ADDR	0x0a
+#define CEC_OP_RECORD_STATUS_UNSUP_CA			0x0b
+#define CEC_OP_RECORD_STATUS_NO_CA_ENTITLEMENTS		0x0c
+#define CEC_OP_RECORD_STATUS_CANT_COPY_SRC		0x0d
+#define CEC_OP_RECORD_STATUS_NO_MORE_COPIES		0x0e
+#define CEC_OP_RECORD_STATUS_NO_MEDIA			0x10
+#define CEC_OP_RECORD_STATUS_PLAYING			0x11
+#define CEC_OP_RECORD_STATUS_ALREADY_RECORDING		0x12
+#define CEC_OP_RECORD_STATUS_MEDIA_PROT			0x13
+#define CEC_OP_RECORD_STATUS_NO_SIGNAL			0x14
+#define CEC_OP_RECORD_STATUS_MEDIA_PROBLEM		0x15
+#define CEC_OP_RECORD_STATUS_NO_SPACE			0x16
+#define CEC_OP_RECORD_STATUS_PARENTAL_LOCK		0x17
+#define CEC_OP_RECORD_STATUS_TERMINATED_OK		0x1a
+#define CEC_OP_RECORD_STATUS_ALREADY_TERM		0x1b
+#define CEC_OP_RECORD_STATUS_OTHER			0x1f
+
+#define CEC_MSG_RECORD_TV_SCREEN			0x0f
+
+
+/* Timer Programming Feature */
+#define CEC_MSG_CLEAR_ANALOGUE_TIMER			0x33
+/* Recording Sequence Operand (recording_seq) */
+#define CEC_OP_REC_SEQ_SUNDAY				0x01
+#define CEC_OP_REC_SEQ_MONDAY				0x02
+#define CEC_OP_REC_SEQ_TUESDAY				0x04
+#define CEC_OP_REC_SEQ_WEDNESDAY			0x08
+#define CEC_OP_REC_SEQ_THURSDAY				0x10
+#define CEC_OP_REC_SEQ_FRIDAY				0x20
+#define CEC_OP_REC_SEQ_SATERDAY				0x40
+#define CEC_OP_REC_SEQ_ONCE_ONLY			0x00
+
+#define CEC_MSG_CLEAR_DIGITAL_TIMER			0x99
+
+#define CEC_MSG_CLEAR_EXT_TIMER				0xa1
+/* External Source Specifier Operand (ext_src_spec) */
+#define CEC_OP_EXT_SRC_PLUG				0x04
+#define CEC_OP_EXT_SRC_PHYS_ADDR			0x05
+
+#define CEC_MSG_SET_ANALOGUE_TIMER			0x34
+#define CEC_MSG_SET_DIGITAL_TIMER			0x97
+#define CEC_MSG_SET_EXT_TIMER				0xa2
+
+#define CEC_MSG_SET_TIMER_PROGRAM_TITLE			0x67
+#define CEC_MSG_TIMER_CLEARED_STATUS			0x43
+/* Timer Cleared Status Data Operand (timer_cleared_status) */
+#define CEC_OP_TIMER_CLR_STAT_RECORDING			0x00
+#define CEC_OP_TIMER_CLR_STAT_NO_MATCHING		0x01
+#define CEC_OP_TIMER_CLR_STAT_NO_INFO			0x02
+#define CEC_OP_TIMER_CLR_STAT_CLEARED			0x80
+
+#define CEC_MSG_TIMER_STATUS				0x35
+/* Timer Overlap Warning Operand (timer_overlap_warning) */
+#define CEC_OP_TIMER_OVERLAP_WARNING_NO_OVERLAP		0
+#define CEC_OP_TIMER_OVERLAP_WARNING_OVERLAP		1
+/* Media Info Operand (media_info) */
+#define CEC_OP_MEDIA_INFO_UNPROT_MEDIA			0
+#define CEC_OP_MEDIA_INFO_PROT_MEDIA			1
+#define CEC_OP_MEDIA_INFO_NO_MEDIA			2
+/* Programmed Indicator Operand (prog_indicator) */
+#define CEC_OP_PROG_IND_NOT_PROGRAMMED			0
+#define CEC_OP_PROG_IND_PROGRAMMED			1
+/* Programmed Info Operand (prog_info) */
+#define CEC_OP_PROG_INFO_ENOUGH_SPACE			0x08
+#define CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE		0x09
+#define CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE	0x0b
+#define CEC_OP_PROG_INFO_NONE_AVAILABLE			0x0a
+/* Not Programmed Error Info Operand (prog_error) */
+#define CEC_OP_PROG_ERROR_NO_FREE_TIMER			0x01
+#define CEC_OP_PROG_ERROR_DATE_OUT_OF_RANGE		0x02
+#define CEC_OP_PROG_ERROR_REC_SEQ_ERROR			0x03
+#define CEC_OP_PROG_ERROR_INV_EXT_PLUG			0x04
+#define CEC_OP_PROG_ERROR_INV_EXT_PHYS_ADDR		0x05
+#define CEC_OP_PROG_ERROR_CA_UNSUPP			0x06
+#define CEC_OP_PROG_ERROR_INSUF_CA_ENTITLEMENTS		0x07
+#define CEC_OP_PROG_ERROR_RESOLUTION_UNSUPP		0x08
+#define CEC_OP_PROG_ERROR_PARENTAL_LOCK			0x09
+#define CEC_OP_PROG_ERROR_CLOCK_FAILURE			0x0a
+#define CEC_OP_PROG_ERROR_DUPLICATE			0x0e
+
+
+/* System Information Feature */
+#define CEC_MSG_CEC_VERSION				0x9e
+/* CEC Version Operand (cec_version) */
+#define CEC_OP_CEC_VERSION_1_3A				4
+#define CEC_OP_CEC_VERSION_1_4				5
+#define CEC_OP_CEC_VERSION_2_0				6
+
+#define CEC_MSG_GET_CEC_VERSION				0x9f
+#define CEC_MSG_GIVE_PHYSICAL_ADDR			0x83
+#define CEC_MSG_GET_MENU_LANGUAGE			0x91
+#define CEC_MSG_REPORT_PHYSICAL_ADDR			0x84
+/* Primary Device Type Operand (prim_devtype) */
+#define CEC_OP_PRIM_DEVTYPE_TV				0
+#define CEC_OP_PRIM_DEVTYPE_RECORD			1
+#define CEC_OP_PRIM_DEVTYPE_TUNER			3
+#define CEC_OP_PRIM_DEVTYPE_PLAYBACK			4
+#define CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM			5
+#define CEC_OP_PRIM_DEVTYPE_SWITCH			6
+#define CEC_OP_PRIM_DEVTYPE_PROCESSOR			7
+
+#define CEC_MSG_SET_MENU_LANGUAGE			0x32
+#define CEC_MSG_REPORT_FEATURES				0xa6	/* HDMI 2.0 */
+/* All Device Types Operand (all_device_types) */
+#define CEC_OP_ALL_DEVTYPE_TV				0x80
+#define CEC_OP_ALL_DEVTYPE_RECORD			0x40
+#define CEC_OP_ALL_DEVTYPE_TUNER			0x20
+#define CEC_OP_ALL_DEVTYPE_PLAYBACK			0x10
+#define CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM			0x08
+#define CEC_OP_ALL_DEVTYPE_SWITCH			0x04
+/* And if you wondering what happened to PROCESSOR devices: those should
+ * be mapped to a SWITCH. */
+
+/* Valid for RC Profile and Device Feature operands */
+#define CEC_OP_FEAT_EXT					0x80	/* Extension bit */
+/* RC Profile Operand (rc_profile) */
+#define CEC_OP_FEAT_RC_TV_PROFILE_NONE			0x00
+#define CEC_OP_FEAT_RC_TV_PROFILE_1			0x02
+#define CEC_OP_FEAT_RC_TV_PROFILE_2			0x06
+#define CEC_OP_FEAT_RC_TV_PROFILE_3			0x0a
+#define CEC_OP_FEAT_RC_TV_PROFILE_4			0x0e
+#define CEC_OP_FEAT_RC_SRC_HAS_DEV_ROOT_MENU		0x50
+#define CEC_OP_FEAT_RC_SRC_HAS_DEV_SETUP_MENU		0x48
+#define CEC_OP_FEAT_RC_SRC_HAS_CONTENTS_MENU		0x44
+#define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_TOP_MENU		0x42
+#define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_CONTEXT_MENU	0x41
+/* Device Feature Operand (dev_features) */
+#define CEC_OP_FEAT_DEV_HAS_RECORD_TV_SCREEN		0x40
+#define CEC_OP_FEAT_DEV_HAS_SET_OSD_STRING		0x20
+#define CEC_OP_FEAT_DEV_HAS_DECK_CONTROL		0x10
+#define CEC_OP_FEAT_DEV_HAS_SET_AUDIO_RATE		0x08
+#define CEC_OP_FEAT_DEV_SINK_HAS_ARC_TX			0x04
+#define CEC_OP_FEAT_DEV_SOURCE_HAS_ARC_RX		0x02
+
+#define CEC_MSG_GIVE_FEATURES				0xa5	/* HDMI 2.0 */
+
+
+/* Deck Control Feature */
+#define CEC_MSG_DECK_CONTROL				0x42
+/* Deck Control Mode Operand (deck_control_mode) */
+#define CEC_OP_DECK_CTL_MODE_SKIP_FWD			1
+#define CEC_OP_DECK_CTL_MODE_SKIP_REV			2
+#define CEC_OP_DECK_CTL_MODE_STOP			3
+#define CEC_OP_DECK_CTL_MODE_EJECT			4
+
+#define CEC_MSG_DECK_STATUS				0x1b
+/* Deck Info Operand (deck_info) */
+#define CEC_OP_DECK_INFO_PLAY				0x11
+#define CEC_OP_DECK_INFO_RECORD				0x12
+#define CEC_OP_DECK_INFO_PLAY_REV			0x13
+#define CEC_OP_DECK_INFO_STILL				0x14
+#define CEC_OP_DECK_INFO_SLOW				0x15
+#define CEC_OP_DECK_INFO_SLOW_REV			0x16
+#define CEC_OP_DECK_INFO_FAST_FWD			0x17
+#define CEC_OP_DECK_INFO_FAST_REV			0x18
+#define CEC_OP_DECK_INFO_NO_MEDIA			0x19
+#define CEC_OP_DECK_INFO_STOP				0x1a
+#define CEC_OP_DECK_INFO_SKIP_FWD			0x1b
+#define CEC_OP_DECK_INFO_SKIP_REV			0x1c
+#define CEC_OP_DECK_INFO_INDEX_SEARCH_FWD		0x1d
+#define CEC_OP_DECK_INFO_INDEX_SEARCH_REV		0x1e
+#define CEC_OP_DECK_INFO_OTHER				0x1f
+
+#define CEC_MSG_GIVE_DECK_STATUS			0x1a
+/* Status Request Operand (status_req) */
+#define CEC_OP_STATUS_REQ_ON				1
+#define CEC_OP_STATUS_REQ_OFF				2
+#define CEC_OP_STATUS_REQ_ONCE				3
+
+#define CEC_MSG_PLAY					0x41
+/* Play Mode Operand (play_mode) */
+#define CEC_OP_PLAY_MODE_PLAY_FWD			0x24
+#define CEC_OP_PLAY_MODE_PLAY_REV			0x20
+#define CEC_OP_PLAY_MODE_PLAY_STILL			0x25
+#define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MIN		0x05
+#define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MED		0x06
+#define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MAX		0x07
+#define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MIN		0x09
+#define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MED		0x0a
+#define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MAX		0x0b
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MIN		0x15
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MED		0x16
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MAX		0x17
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MIN		0x19
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MED		0x1a
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MAX		0x1b
+
+
+/* Tuner Control Feature */
+#define CEC_MSG_GIVE_TUNER_DEVICE_STATUS		0x08
+#define CEC_MSG_SELECT_ANALOGUE_SERVICE			0x92
+#define CEC_MSG_SELECT_DIGITAL_SERVICE			0x93
+#define CEC_MSG_TUNER_DEVICE_STATUS			0x07
+/* Recording Flag Operand (rec_flag) */
+#define CEC_OP_REC_FLAG_USED				0
+#define CEC_OP_REC_FLAG_NOT_USED			1
+/* Tuner Display Info Operand (tuner_display_info) */
+#define CEC_OP_TUNER_DISPLAY_INFO_DIGITAL		0
+#define CEC_OP_TUNER_DISPLAY_INFO_NONE			1
+#define CEC_OP_TUNER_DISPLAY_INFO_ANALOGUE		2
+
+#define CEC_MSG_TUNER_STEP_DECREMENT			0x06
+#define CEC_MSG_TUNER_STEP_INCREMENT			0x05
+
+
+/* Vendor Specific Commands Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_CEC_VERSION
+ *	CEC_MSG_GET_CEC_VERSION
+ */
+#define CEC_MSG_DEVICE_VENDOR_ID			0x87
+#define CEC_MSG_GIVE_DEVICE_VENDOR_ID			0x8c
+#define CEC_MSG_VENDOR_COMMAND				0x89
+#define CEC_MSG_VENDOR_COMMAND_WITH_ID			0xa0
+#define CEC_MSG_VENDOR_REMOTE_BUTTON_DOWN		0x8a
+#define CEC_MSG_VENDOR_REMOTE_BUTTON_UP			0x8b
+
+
+/* OSD Display Feature */
+#define CEC_MSG_SET_OSD_STRING				0x64
+/* Display Control Operand (disp_ctl) */
+#define CEC_OP_DISP_CTL_DEFAULT				0x00
+#define CEC_OP_DISP_CTL_UNTIL_CLEARED			0x40
+#define CEC_OP_DISP_CTL_CLEAR				0x80
+
+
+/* Device OSD Transfer Feature */
+#define CEC_MSG_GIVE_OSD_NAME				0x46
+#define CEC_MSG_SET_OSD_NAME				0x47
+
+
+/* Device Menu Control Feature */
+#define CEC_MSG_MENU_REQUEST				0x8d
+/* Menu Request Type Operand (menu_req) */
+#define CEC_OP_MENU_REQUEST_ACTIVATE			0x00
+#define CEC_OP_MENU_REQUEST_DEACTIVATE			0x01
+#define CEC_OP_MENU_REQUEST_QUERY			0x02
+
+#define CEC_MSG_MENU_STATUS				0x8e
+/* Menu State Operand (menu_state) */
+#define CEC_OP_MENU_STATE_ACTIVATED			0x00
+#define CEC_OP_MENU_STATE_DEACTIVATED			0x01
+
+#define CEC_MSG_USER_CONTROL_PRESSED			0x44
+/* UI Broadcast Type Operand (ui_bcast_type) */
+#define CEC_OP_UI_BCAST_TYPE_TOGGLE_ALL			0x00
+#define CEC_OP_UI_BCAST_TYPE_TOGGLE_DIG_ANA		0x01
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE			0x10
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE_T			0x20
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE_CABLE		0x30
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE_SAT		0x40
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL			0x50
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_T			0x60
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_CABLE		0x70
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_SAT		0x80
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT		0x90
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT2		0x91
+#define CEC_OP_UI_BCAST_TYPE_IP				0xa0
+/* UI Sound Presentation Control Operand (ui_snd_pres_ctl) */
+#define CEC_OP_UI_SND_PRES_CTL_DUAL_MONO		0x10
+#define CEC_OP_UI_SND_PRES_CTL_KARAOKE			0x20
+#define CEC_OP_UI_SND_PRES_CTL_DOWNMIX			0x80
+#define CEC_OP_UI_SND_PRES_CTL_REVERB			0x90
+#define CEC_OP_UI_SND_PRES_CTL_EQUALIZER		0xa0
+#define CEC_OP_UI_SND_PRES_CTL_BASS_UP			0xb1
+#define CEC_OP_UI_SND_PRES_CTL_BASS_NEUTRAL		0xb2
+#define CEC_OP_UI_SND_PRES_CTL_BASS_DOWN		0xb3
+#define CEC_OP_UI_SND_PRES_CTL_TREBLE_UP		0xc1
+#define CEC_OP_UI_SND_PRES_CTL_TREBLE_NEUTRAL		0xc2
+#define CEC_OP_UI_SND_PRES_CTL_TREBLE_DOWN		0xc3
+
+#define CEC_MSG_USER_CONTROL_RELEASED			0x45
+
+
+/* Remote Control Passthrough Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_USER_CONTROL_PRESSED
+ *	CEC_MSG_USER_CONTROL_RELEASED
+ */
+
+
+/* Power Status Feature */
+#define CEC_MSG_GIVE_DEVICE_POWER_STATUS		0x8f
+#define CEC_MSG_REPORT_POWER_STATUS			0x90
+/* Power Status Operand (pwr_state) */
+#define CEC_OP_POWER_STATUS_ON				0
+#define CEC_OP_POWER_STATUS_STANDBY			1
+#define CEC_OP_POWER_STATUS_TO_ON			2
+#define CEC_OP_POWER_STATUS_TO_STANDBY			3
+
+
+/* General Protocol Messages */
+#define CEC_MSG_FEATURE_ABORT				0x00
+/* Abort Reason Operand (reason) */
+#define CEC_OP_ABORT_UNRECOGNIZED_OP			0
+#define CEC_OP_ABORT_INCORRECT_MODE			1
+#define CEC_OP_ABORT_NO_SOURCE				2
+#define CEC_OP_ABORT_INVALID_OP				3
+#define CEC_OP_ABORT_REFUSED				4
+#define CEC_OP_ABORT_UNDETERMINED			5
+
+#define CEC_MSG_ABORT					0xff
+
+
+/* System Audio Control Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_USER_CONTROL_PRESSED
+ *	CEC_MSG_USER_CONTROL_RELEASED
+ */
+#define CEC_MSG_GIVE_AUDIO_STATUS			0x71
+#define CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS		0x7d
+#define CEC_MSG_REPORT_AUDIO_STATUS			0x7a
+/* Audio Mute Status Operand (aud_mute_status) */
+#define CEC_OP_AUD_MUTE_STATUS_OFF			0
+#define CEC_OP_AUD_MUTE_STATUS_ON			1
+
+#define CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR		0xa3
+#define CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR		0xa4
+#define CEC_MSG_SET_SYSTEM_AUDIO_MODE			0x72
+/* System Audio Status Operand (sys_aud_status) */
+#define CEC_OP_SYS_AUD_STATUS_OFF			0
+#define CEC_OP_SYS_AUD_STATUS_ON			1
+
+#define CEC_MSG_SYSTEM_AUDIO_MODE_REQUEST		0x70
+#define CEC_MSG_SYSTEM_AUDIO_MODE_STATUS		0x7e
+/* Audio Format ID Operand (audio_format_id) */
+#define CEC_OP_AUD_FMT_ID_CEA861			0
+#define CEC_OP_AUD_FMT_ID_CEA861_CXT			1
+
+
+/* Audio Rate Control Feature */
+#define CEC_MSG_SET_AUDIO_RATE				0x9a
+/* Audio Rate Operand (audio_rate) */
+#define CEC_OP_AUD_RATE_OFF				0
+#define CEC_OP_AUD_RATE_WIDE_STD			1
+#define CEC_OP_AUD_RATE_WIDE_FAST			2
+#define CEC_OP_AUD_RATE_WIDE_SLOW			3
+#define CEC_OP_AUD_RATE_NARROW_STD			4
+#define CEC_OP_AUD_RATE_NARROW_FAST			5
+#define CEC_OP_AUD_RATE_NARROW_SLOW			6
+
+
+/* Audio Return Channel Control Feature */
+#define CEC_MSG_INITIATE_ARC				0xc0
+#define CEC_MSG_REPORT_ARC_INITIATED			0xc1
+#define CEC_MSG_REPORT_ARC_TERMINATED			0xc2
+#define CEC_MSG_REQUEST_ARC_INITIATION			0xc3
+#define CEC_MSG_REQUEST_ARC_TERMINATION			0xc4
+#define CEC_MSG_TERMINATE_ARC				0xc5
+
+
+/* Dynamic Audio Lipsync Feature */
+/* Only for CEC 2.0 and up */
+#define CEC_MSG_REQUEST_CURRENT_LATENCY			0xa7
+#define CEC_MSG_REPORT_CURRENT_LATENCY			0xa8
+/* Low Latency Mode Operand (low_latency_mode) */
+#define CEC_OP_LOW_LATENCY_MODE_OFF			0
+#define CEC_OP_LOW_LATENCY_MODE_ON			1
+/* Audio Output Compensated Operand (audio_out_compensated) */
+#define CEC_OP_AUD_OUT_COMPENSATED_NA			0
+#define CEC_OP_AUD_OUT_COMPENSATED_DELAY		1
+#define CEC_OP_AUD_OUT_COMPENSATED_NO_DELAY		2
+#define CEC_OP_AUD_OUT_COMPENSATED_PARTIAL_DELAY	3
+
+
+/* Capability Discovery and Control Feature */
+#define CEC_MSG_CDC_MESSAGE				0xf8
+/* Ethernet-over-HDMI: nobody ever does this... */
+#define CEC_MSG_CDC_HEC_INQUIRE_STATE			0x00
+#define CEC_MSG_CDC_HEC_REPORT_STATE			0x01
+/* HEC Functionality State Operand (hec_func_state) */
+#define CEC_OP_HEC_FUNC_STATE_NOT_SUPPORTED		0
+#define CEC_OP_HEC_FUNC_STATE_INACTIVE			1
+#define CEC_OP_HEC_FUNC_STATE_ACTIVE			2
+#define CEC_OP_HEC_FUNC_STATE_ACTIVATION_FIELD		3
+/* Host Functionality State Operand (host_func_state) */
+#define CEC_OP_HOST_FUNC_STATE_NOT_SUPPORTED		0
+#define CEC_OP_HOST_FUNC_STATE_INACTIVE			1
+#define CEC_OP_HOST_FUNC_STATE_ACTIVE			2
+/* ENC Functionality State Operand (enc_func_state) */
+#define CEC_OP_ENC_FUNC_STATE_EXT_CON_NOT_SUPPORTED	0
+#define CEC_OP_ENC_FUNC_STATE_EXT_CON_INACTIVE		1
+#define CEC_OP_ENC_FUNC_STATE_EXT_CON_ACTIVE		2
+/* CDC Error Code Operand (cdc_errcode) */
+#define CEC_OP_CDC_ERROR_CODE_NONE			0
+#define CEC_OP_CDC_ERROR_CODE_CAP_UNSUPPORTED		1
+#define CEC_OP_CDC_ERROR_CODE_WRONG_STATE		2
+#define CEC_OP_CDC_ERROR_CODE_OTHER			3
+/* HEC Support Operand (hec_support) */
+#define CEC_OP_HEC_SUPPORT_NO				0
+#define CEC_OP_HEC_SUPPORT_YES				1
+/* HEC Activation Operand (hec_activation) */
+#define CEC_OP_HEC_ACTIVATION_ON			0
+#define CEC_OP_HEC_ACTIVATION_OFF			1
+
+#define CEC_MSG_CDC_HEC_SET_STATE_ADJACENT		0x02
+#define CEC_MSG_CDC_HEC_SET_STATE			0x03
+/* HEC Set State Operand (hec_set_state) */
+#define CEC_OP_HEC_SET_STATE_DEACTIVATE			0
+#define CEC_OP_HEC_SET_STATE_ACTIVATE			1
+
+#define CEC_MSG_CDC_HEC_REQUEST_DEACTIVATION		0x04
+#define CEC_MSG_CDC_HEC_NOTIFY_ALIVE			0x05
+#define CEC_MSG_CDC_HEC_DISCOVER			0x06
+/* Hotplug Detect messages */
+#define CEC_MSG_CDC_HPD_SET_STATE			0x10
+/* HPD State Operand (hpd_state) */
+#define CEC_OP_HPD_STATE_CP_EDID_DISABLE		0
+#define CEC_OP_HPD_STATE_CP_EDID_ENABLE			1
+#define CEC_OP_HPD_STATE_CP_EDID_DISABLE_ENABLE		2
+#define CEC_OP_HPD_STATE_EDID_DISABLE			3
+#define CEC_OP_HPD_STATE_EDID_ENABLE			4
+#define CEC_OP_HPD_STATE_EDID_DISABLE_ENABLE		5
+#define CEC_MSG_CDC_HPD_REPORT_STATE			0x11
+/* HPD Error Code Operand (hpd_error) */
+#define CEC_OP_HPD_ERROR_NONE				0
+#define CEC_OP_HPD_ERROR_INITIATOR_NOT_CAPABLE		1
+#define CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE		2
+#define CEC_OP_HPD_ERROR_OTHER				3
+#define CEC_OP_HPD_ERROR_NONE_NO_VIDEO			4
+
+#endif
-- 
2.1.4

