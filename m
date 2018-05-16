Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59369 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbeEPVEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 17:04:44 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>
Subject: [PATCH v3 1/2] media: rc: introduce BPF_PROG_RAWIR_EVENT
Date: Wed, 16 May 2018 22:04:40 +0100
Message-Id: <92785c791057185fa5691f78cecfa4beae7fc336.1526504511.git.sean@mess.org>
In-Reply-To: <cover.1526504511.git.sean@mess.org>
References: <cover.1526504511.git.sean@mess.org>
In-Reply-To: <cover.1526504511.git.sean@mess.org>
References: <cover.1526504511.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for BPF_PROG_RAWIR_EVENT. This type of BPF program can call
rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
that the last key should be repeated.

The bpf program can be attached to using the bpf(BPF_PROG_ATTACH) syscall;
the target_fd must be the /dev/lircN device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig           |  13 ++
 drivers/media/rc/Makefile          |   1 +
 drivers/media/rc/bpf-rawir-event.c | 363 +++++++++++++++++++++++++++++
 drivers/media/rc/lirc_dev.c        |  24 ++
 drivers/media/rc/rc-core-priv.h    |  24 ++
 drivers/media/rc/rc-ir-raw.c       |  14 +-
 include/linux/bpf_rcdev.h          |  30 +++
 include/linux/bpf_types.h          |   3 +
 include/uapi/linux/bpf.h           |  55 ++++-
 kernel/bpf/syscall.c               |   7 +
 10 files changed, 531 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/rc/bpf-rawir-event.c
 create mode 100644 include/linux/bpf_rcdev.h

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index eb2c3b6eca7f..2172d65b0213 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -25,6 +25,19 @@ config LIRC
 	   passes raw IR to and from userspace, which is needed for
 	   IR transmitting (aka "blasting") and for the lirc daemon.
 
+config BPF_RAWIR_EVENT
+	bool "Support for eBPF programs attached to lirc devices"
+	depends on BPF_SYSCALL
+	depends on RC_CORE=y
+	depends on LIRC
+	help
+	   Allow attaching eBPF programs to a lirc device using the bpf(2)
+	   syscall command BPF_PROG_ATTACH. This is supported for raw IR
+	   receivers.
+
+	   These eBPF programs can be used to decode IR into scancodes, for
+	   IR protocols not supported by the kernel decoders.
+
 menuconfig RC_DECODERS
 	bool "Remote controller decoders"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 2e1c87066f6c..74907823bef8 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -5,6 +5,7 @@ obj-y += keymaps/
 obj-$(CONFIG_RC_CORE) += rc-core.o
 rc-core-y := rc-main.o rc-ir-raw.o
 rc-core-$(CONFIG_LIRC) += lirc_dev.o
+rc-core-$(CONFIG_BPF_RAWIR_EVENT) += bpf-rawir-event.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
diff --git a/drivers/media/rc/bpf-rawir-event.c b/drivers/media/rc/bpf-rawir-event.c
new file mode 100644
index 000000000000..7cb48b8d87b5
--- /dev/null
+++ b/drivers/media/rc/bpf-rawir-event.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0
+// bpf-rawir-event.c - handles bpf
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/bpf_rcdev.h>
+#include "rc-core-priv.h"
+
+/*
+ * BPF interface for raw IR
+ */
+const struct bpf_prog_ops rawir_event_prog_ops = {
+};
+
+BPF_CALL_1(bpf_rc_repeat, struct bpf_rawir_event*, event)
+{
+	struct ir_raw_event_ctrl *ctrl;
+
+	ctrl = container_of(event, struct ir_raw_event_ctrl, bpf_rawir_event);
+
+	rc_repeat(ctrl->dev);
+
+	return 0;
+}
+
+static const struct bpf_func_proto rc_repeat_proto = {
+	.func	   = bpf_rc_repeat,
+	.gpl_only  = true, /* rc_repeat is EXPORT_SYMBOL_GPL */
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+};
+
+BPF_CALL_4(bpf_rc_keydown, struct bpf_rawir_event*, event, u32, protocol,
+	   u32, scancode, u32, toggle)
+{
+	struct ir_raw_event_ctrl *ctrl;
+
+	ctrl = container_of(event, struct ir_raw_event_ctrl, bpf_rawir_event);
+
+	rc_keydown(ctrl->dev, protocol, scancode, toggle != 0);
+
+	return 0;
+}
+
+static const struct bpf_func_proto rc_keydown_proto = {
+	.func	   = bpf_rc_keydown,
+	.gpl_only  = true, /* rc_keydown is EXPORT_SYMBOL_GPL */
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+	.arg4_type = ARG_ANYTHING,
+};
+
+static const struct bpf_func_proto *
+rawir_event_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_rc_repeat:
+		return &rc_repeat_proto;
+	case BPF_FUNC_rc_keydown:
+		return &rc_keydown_proto;
+	case BPF_FUNC_map_lookup_elem:
+		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_update_elem:
+		return &bpf_map_update_elem_proto;
+	case BPF_FUNC_map_delete_elem:
+		return &bpf_map_delete_elem_proto;
+	case BPF_FUNC_ktime_get_ns:
+		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_tail_call:
+		return &bpf_tail_call_proto;
+	case BPF_FUNC_get_prandom_u32:
+		return &bpf_get_prandom_u32_proto;
+	case BPF_FUNC_trace_printk:
+		if (capable(CAP_SYS_ADMIN))
+			return bpf_get_trace_printk_proto();
+		/* fall through */
+	default:
+		return NULL;
+	}
+}
+
+static bool rawir_event_is_valid_access(int off, int size,
+					enum bpf_access_type type,
+					const struct bpf_prog *prog,
+					struct bpf_insn_access_aux *info)
+{
+	/* struct bpf_rawir_event has two u32 fields */
+	if (type == BPF_WRITE)
+		return false;
+
+	if (size != sizeof(__u32))
+		return false;
+
+	if (!(off == offsetof(struct bpf_rawir_event, duration) ||
+	      off == offsetof(struct bpf_rawir_event, type)))
+		return false;
+
+	return true;
+}
+
+const struct bpf_verifier_ops rawir_event_verifier_ops = {
+	.get_func_proto  = rawir_event_func_proto,
+	.is_valid_access = rawir_event_is_valid_access
+};
+
+#define BPF_MAX_PROGS 64
+
+static int rc_dev_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
+{
+	struct ir_raw_event_ctrl *raw;
+	struct bpf_prog_list *pl;
+	int ret, size;
+
+	if (rcdev->driver_type != RC_DRIVER_IR_RAW)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&ir_raw_handler_lock);
+	if (ret)
+		return ret;
+
+	raw = rcdev->raw;
+	if (!raw) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	size = 0;
+	list_for_each_entry(pl, &raw->progs, node) {
+		if (pl->prog == prog) {
+			ret = -EEXIST;
+			goto out;
+		}
+
+		size++;
+	}
+
+	if (size >= BPF_MAX_PROGS) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	pl = kmalloc(sizeof(*pl), GFP_KERNEL);
+	if (!pl) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pl->prog = prog;
+	list_add(&pl->node, &raw->progs);
+out:
+	mutex_unlock(&ir_raw_handler_lock);
+	return ret;
+}
+
+static int rc_dev_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
+{
+	struct ir_raw_event_ctrl *raw;
+	struct bpf_prog_list *pl, *tmp;
+	int ret;
+
+	if (rcdev->driver_type != RC_DRIVER_IR_RAW)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&ir_raw_handler_lock);
+	if (ret)
+		return ret;
+
+	raw = rcdev->raw;
+	if (!raw) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = -ENOENT;
+
+	list_for_each_entry_safe(pl, tmp, &raw->progs, node) {
+		if (pl->prog == prog) {
+			list_del(&pl->node);
+			kfree(pl);
+			bpf_prog_put(prog);
+			ret = 0;
+			goto out;
+		}
+	}
+out:
+	mutex_unlock(&ir_raw_handler_lock);
+	return ret;
+}
+
+void rc_dev_bpf_init(struct rc_dev *rcdev)
+{
+	INIT_LIST_HEAD(&rcdev->raw->progs);
+}
+
+void rc_dev_bpf_run(struct rc_dev *rcdev, struct ir_raw_event ev)
+{
+	struct ir_raw_event_ctrl *raw = rcdev->raw;
+	struct bpf_prog_list *pl;
+
+	if (list_empty(&raw->progs))
+		return;
+
+	if (unlikely(ev.carrier_report)) {
+		raw->bpf_rawir_event.carrier = ev.carrier;
+		raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_CARRIER;
+	} else {
+		raw->bpf_rawir_event.duration = ev.duration;
+
+		if (ev.pulse)
+			raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_PULSE;
+		else if (ev.timeout)
+			raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_TIMEOUT;
+		else if (ev.reset)
+			raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_RESET;
+		else
+			raw->bpf_rawir_event.type = BPF_RAWIR_EVENT_SPACE;
+	}
+
+	list_for_each_entry(pl, &raw->progs, node)
+		BPF_PROG_RUN(pl->prog, &raw->bpf_rawir_event);
+}
+
+void rc_dev_bpf_free(struct rc_dev *rcdev)
+{
+	struct bpf_prog_list *pl, *tmp;
+
+	list_for_each_entry_safe(pl, tmp, &rcdev->raw->progs, node) {
+		list_del(&pl->node);
+		bpf_prog_put(pl->prog);
+		kfree(pl);
+	}
+}
+
+int rc_dev_prog_attach(const union bpf_attr *attr)
+{
+	struct bpf_prog *prog;
+	struct rc_dev *rcdev;
+	int ret;
+
+	if (attr->attach_flags)
+		return -EINVAL;
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd,
+				 BPF_PROG_TYPE_RAWIR_EVENT);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	if (IS_ERR(rcdev)) {
+		bpf_prog_put(prog);
+		return PTR_ERR(rcdev);
+	}
+
+	ret = rc_dev_bpf_attach(rcdev, prog);
+	if (ret)
+		bpf_prog_put(prog);
+
+	put_device(&rcdev->dev);
+
+	return ret;
+}
+
+int rc_dev_prog_detach(const union bpf_attr *attr)
+{
+	struct bpf_prog *prog;
+	struct rc_dev *rcdev;
+	int ret;
+
+	if (attr->attach_flags)
+		return -EINVAL;
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd,
+				 BPF_PROG_TYPE_RAWIR_EVENT);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	if (IS_ERR(rcdev)) {
+		bpf_prog_put(prog);
+		return PTR_ERR(rcdev);
+	}
+
+	ret = rc_dev_bpf_detach(rcdev, prog);
+
+	bpf_prog_put(prog);
+	put_device(&rcdev->dev);
+
+	return ret;
+}
+
+int rc_dev_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
+{
+	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
+	struct ir_raw_event_ctrl *raw;
+	struct bpf_prog_list *pl;
+	struct rc_dev *rcdev;
+	u32 cnt, flags = 0, *ids, i;
+	int ret;
+
+	if (attr->query.query_flags)
+		return -EINVAL;
+
+	rcdev = rc_dev_get_from_fd(attr->query.target_fd);
+	if (IS_ERR(rcdev))
+		return PTR_ERR(rcdev);
+
+	if (rcdev->driver_type != RC_DRIVER_IR_RAW) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = mutex_lock_interruptible(&ir_raw_handler_lock);
+	if (ret)
+		goto out;
+
+	raw = rcdev->raw;
+	if (!raw) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	cnt = 0;
+	list_for_each_entry(pl, &raw->progs, node)
+		cnt++;
+
+	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (attr->query.prog_cnt != 0 && prog_ids && cnt) {
+		if (attr->query.prog_cnt < cnt)
+			cnt = attr->query.prog_cnt;
+
+		ids = kmalloc_array(cnt, sizeof(u32), GFP_KERNEL);
+		if (!ids) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		i = 0;
+		list_for_each_entry(pl, &raw->progs, node) {
+			ids[i++] = pl->prog->aux->id;
+			if (i == cnt)
+				break;
+		}
+
+		ret = copy_to_user(prog_ids, ids, cnt * sizeof(u32));
+	}
+out:
+	mutex_unlock(&ir_raw_handler_lock);
+	put_device(&rcdev->dev);
+
+	return ret;
+}
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 24e9fbb80e81..193540ded626 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
+#include <linux/file.h>
 #include <linux/idr.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
@@ -816,4 +817,27 @@ void __exit lirc_dev_exit(void)
 	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
 
+struct rc_dev *rc_dev_get_from_fd(int fd)
+{
+	struct fd f = fdget(fd);
+	struct lirc_fh *fh;
+	struct rc_dev *dev;
+
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+
+	if (f.file->f_op != &lirc_fops) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+
+	fh = f.file->private_data;
+	dev = fh->rc;
+
+	get_device(&dev->dev);
+	fdput(f);
+
+	return dev;
+}
+
 MODULE_ALIAS("lirc_dev");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index e0e6a17460f6..148db73cfa0c 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -13,6 +13,7 @@
 #define	MAX_IR_EVENT_SIZE	512
 
 #include <linux/slab.h>
+#include <uapi/linux/bpf.h>
 #include <media/rc-core.h>
 
 /**
@@ -57,6 +58,11 @@ struct ir_raw_event_ctrl {
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
 	struct ir_raw_event this_ev;
+
+#ifdef CONFIG_BPF_RAWIR_EVENT
+	struct bpf_rawir_event		bpf_rawir_event;
+	struct list_head		progs;
+#endif
 	struct nec_dec {
 		int state;
 		unsigned count;
@@ -126,6 +132,9 @@ struct ir_raw_event_ctrl {
 	} imon;
 };
 
+/* Mutex for locking raw IR processing and handler change */
+extern struct mutex ir_raw_handler_lock;
+
 /* macros for IR decoders */
 static inline bool geq_margin(unsigned d1, unsigned d2, unsigned margin)
 {
@@ -288,6 +297,7 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
 void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc);
 int ir_lirc_register(struct rc_dev *dev);
 void ir_lirc_unregister(struct rc_dev *dev);
+struct rc_dev *rc_dev_get_from_fd(int fd);
 #else
 static inline int lirc_dev_init(void) { return 0; }
 static inline void lirc_dev_exit(void) {}
@@ -299,4 +309,18 @@ static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
 static inline void ir_lirc_unregister(struct rc_dev *dev) { }
 #endif
 
+/*
+ * bpf interface
+ */
+#ifdef CONFIG_BPF_RAWIR_EVENT
+void rc_dev_bpf_init(struct rc_dev *dev);
+void rc_dev_bpf_free(struct rc_dev *dev);
+void rc_dev_bpf_run(struct rc_dev *dev, struct ir_raw_event ev);
+#else
+static inline void rc_dev_bpf_init(struct rc_dev *dev) { }
+static inline void rc_dev_bpf_free(struct rc_dev *dev) { }
+static inline void rc_dev_bpf_run(struct rc_dev *dev, struct ir_raw_event ev)
+{ }
+#endif
+
 #endif /* _RC_CORE_PRIV */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 374f83105a23..e68cdd4fbf5d 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -14,7 +14,7 @@
 static LIST_HEAD(ir_raw_client_list);
 
 /* Used to handle IR raw handler extensions */
-static DEFINE_MUTEX(ir_raw_handler_lock);
+DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static atomic64_t available_protocols = ATOMIC64_INIT(0);
 
@@ -32,6 +32,7 @@ static int ir_raw_event_thread(void *data)
 				    handler->protocols || !handler->protocols)
 					handler->decode(raw->dev, ev);
 			ir_lirc_raw_event(raw->dev, ev);
+			rc_dev_bpf_run(raw->dev, ev);
 			raw->prev_ev = ev;
 		}
 		mutex_unlock(&ir_raw_handler_lock);
@@ -572,6 +573,7 @@ int ir_raw_event_prepare(struct rc_dev *dev)
 	spin_lock_init(&dev->raw->edge_spinlock);
 	timer_setup(&dev->raw->edge_handle, ir_raw_edge_handle, 0);
 	INIT_KFIFO(dev->raw->kfifo);
+	rc_dev_bpf_init(dev);
 
 	return 0;
 }
@@ -621,9 +623,17 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_unregister)
 			handler->raw_unregister(dev);
-	mutex_unlock(&ir_raw_handler_lock);
+
+	rc_dev_bpf_free(dev);
 
 	ir_raw_event_free(dev);
+
+	/*
+	 * A user can be calling bpf(BPF_PROG_{QUERY|ATTACH|DETACH}), so
+	 * ensure that the raw member is null on unlock; this is how
+	 * "device gone" is checked.
+	 */
+	mutex_unlock(&ir_raw_handler_lock);
 }
 
 /*
diff --git a/include/linux/bpf_rcdev.h b/include/linux/bpf_rcdev.h
new file mode 100644
index 000000000000..17a30f30436a
--- /dev/null
+++ b/include/linux/bpf_rcdev.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_RCDEV_H
+#define _BPF_RCDEV_H
+
+#include <linux/bpf.h>
+#include <uapi/linux/bpf.h>
+
+#ifdef CONFIG_BPF_RAWIR_EVENT
+int rc_dev_prog_attach(const union bpf_attr *attr);
+int rc_dev_prog_detach(const union bpf_attr *attr);
+int rc_dev_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr);
+#else
+static inline int rc_dev_prog_attach(const union bpf_attr *attr)
+{
+	return -EINVAL;
+}
+
+static inline int rc_dev_prog_detach(const union bpf_attr *attr)
+{
+	return -EINVAL;
+}
+
+static inline int rc_dev_prog_query(const union bpf_attr *attr,
+				    union bpf_attr __user *uattr)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* _BPF_RCDEV_H */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index b67f8793de0d..e2b1b12474d4 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -25,6 +25,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
 #endif
+#ifdef CONFIG_BPF_RAWIR_EVENT
+BPF_PROG_TYPE(BPF_PROG_TYPE_RAWIR_EVENT, rawir_event)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d94d333a8225..243e141e8a5b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -141,6 +141,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_RAW_TRACEPOINT,
 	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	BPF_PROG_TYPE_RAWIR_EVENT,
 };
 
 enum bpf_attach_type {
@@ -158,6 +159,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_CONNECT,
 	BPF_CGROUP_INET4_POST_BIND,
 	BPF_CGROUP_INET6_POST_BIND,
+	BPF_RAWIR_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1902,6 +1904,35 @@ union bpf_attr {
  *		egress otherwise). This is the only flag supported for now.
  *	Return
  *		**SK_PASS** on success, or **SK_DROP** on error.
+ *
+ * int bpf_rc_keydown(void *ctx, u32 protocol, u32 scancode, u32 toggle)
+ *	Description
+ *		Report decoded scancode with toggle value. For use in
+ *		BPF_PROG_TYPE_RAWIR_EVENT, to report a successfully
+ *		decoded scancode. This is will generate a keydown event,
+ *		and a keyup event once the scancode is no longer repeated.
+ *
+ *		*ctx* pointer to bpf_rawir_event, *protocol* is decoded
+ *		protocol (see RC_PROTO_* enum).
+ *
+ *		Some protocols include a toggle bit, in case the button
+ *		was released and pressed again between consecutive scancodes,
+ *		copy this bit into *toggle* if it exists, else set to 0.
+ *
+ *     Return
+ *		Always return 0 (for now)
+ *
+ * int bpf_rc_repeat(void *ctx)
+ *	Description
+ *		Repeat the last decoded scancode; some IR protocols like
+ *		NEC have a special IR message for repeat last button,
+ *		in case user is holding a button down; the scancode is
+ *		not repeated.
+ *
+ *		*ctx* pointer to bpf_rawir_event.
+ *
+ *     Return
+ *		Always return 0 (for now)
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -1976,7 +2007,9 @@ union bpf_attr {
 	FN(fib_lookup),			\
 	FN(sock_hash_update),		\
 	FN(msg_redirect_hash),		\
-	FN(sk_redirect_hash),
+	FN(sk_redirect_hash),		\
+	FN(rc_repeat),			\
+	FN(rc_keydown),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -2043,6 +2076,26 @@ enum bpf_hdr_start_off {
 	BPF_HDR_START_NET,
 };
 
+/*
+ * user accessible mirror of in-kernel ir_raw_event
+ */
+#define BPF_RAWIR_EVENT_SPACE		0
+#define BPF_RAWIR_EVENT_PULSE		1
+#define BPF_RAWIR_EVENT_TIMEOUT		2
+#define BPF_RAWIR_EVENT_RESET		3
+#define BPF_RAWIR_EVENT_CARRIER		4
+#define BPF_RAWIR_EVENT_DUTY_CYCLE	5
+
+struct bpf_rawir_event {
+	union {
+		__u32	duration;
+		__u32	carrier;
+		__u32	duty_cycle;
+	};
+
+	__u32	type;
+};
+
 /* user accessible mirror of in-kernel sk_buff.
  * new fields can only be added to the end of this structure
  */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e2aeb5e89f44..75c089f407c8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -11,6 +11,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/bpf_rcdev.h>
 #include <linux/btf.h>
 #include <linux/syscalls.h>
 #include <linux/slab.h>
@@ -1567,6 +1568,8 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
 		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, true);
+	case BPF_RAWIR_EVENT:
+		return rc_dev_prog_attach(attr);
 	default:
 		return -EINVAL;
 	}
@@ -1637,6 +1640,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
 		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, false);
+	case BPF_RAWIR_EVENT:
+		return rc_dev_prog_detach(attr);
 	default:
 		return -EINVAL;
 	}
@@ -1684,6 +1689,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SOCK_OPS:
 	case BPF_CGROUP_DEVICE:
 		break;
+	case BPF_RAWIR_EVENT:
+		return rc_dev_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
-- 
2.17.0
