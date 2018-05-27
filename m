Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39125 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755158AbeE0LYP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 May 2018 07:24:15 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH v5 2/3] media: rc: introduce BPF_PROG_LIRC_MODE2
Date: Sun, 27 May 2018 12:24:09 +0100
Message-Id: <9f2c54d4956f962f44fcda739a824397ddea132c.1527419762.git.sean@mess.org>
In-Reply-To: <cover.1527419762.git.sean@mess.org>
References: <cover.1527419762.git.sean@mess.org>
In-Reply-To: <cover.1527419762.git.sean@mess.org>
References: <cover.1527419762.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for BPF_PROG_LIRC_MODE2. This type of BPF program can call
rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
that the last key should be repeated.

The bpf program can be attached to using the bpf(BPF_PROG_ATTACH) syscall;
the target_fd must be the /dev/lircN device.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig        |  13 ++
 drivers/media/rc/Makefile       |   1 +
 drivers/media/rc/bpf-lirc.c     | 313 ++++++++++++++++++++++++++++++++
 drivers/media/rc/lirc_dev.c     |  30 +++
 drivers/media/rc/rc-core-priv.h |  21 +++
 drivers/media/rc/rc-ir-raw.c    |  12 +-
 include/linux/bpf_lirc.h        |  29 +++
 include/linux/bpf_types.h       |   3 +
 include/uapi/linux/bpf.h        |  53 +++++-
 kernel/bpf/syscall.c            |   7 +
 10 files changed, 479 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/rc/bpf-lirc.c
 create mode 100644 include/linux/bpf_lirc.h

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index eb2c3b6eca7f..d5b35a6ba899 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -25,6 +25,19 @@ config LIRC
 	   passes raw IR to and from userspace, which is needed for
 	   IR transmitting (aka "blasting") and for the lirc daemon.
 
+config BPF_LIRC_MODE2
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
index 2e1c87066f6c..e0340d043fe8 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -5,6 +5,7 @@ obj-y += keymaps/
 obj-$(CONFIG_RC_CORE) += rc-core.o
 rc-core-y := rc-main.o rc-ir-raw.o
 rc-core-$(CONFIG_LIRC) += lirc_dev.o
+rc-core-$(CONFIG_BPF_LIRC_MODE2) += bpf-lirc.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
new file mode 100644
index 000000000000..40826bba06b6
--- /dev/null
+++ b/drivers/media/rc/bpf-lirc.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0
+// bpf-lirc.c - handles bpf
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/bpf_lirc.h>
+#include "rc-core-priv.h"
+
+/*
+ * BPF interface for raw IR
+ */
+const struct bpf_prog_ops lirc_mode2_prog_ops = {
+};
+
+BPF_CALL_1(bpf_rc_repeat, u32*, sample)
+{
+	struct ir_raw_event_ctrl *ctrl;
+
+	ctrl = container_of(sample, struct ir_raw_event_ctrl, bpf_sample);
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
+/*
+ * Currently rc-core does not support 64-bit scancodes, but there are many
+ * known protocols with more than 32 bits. So, define the interface as u64
+ * as a future-proof.
+ */
+BPF_CALL_4(bpf_rc_keydown, u32*, sample, u32, protocol, u64, scancode,
+	   u32, toggle)
+{
+	struct ir_raw_event_ctrl *ctrl;
+
+	ctrl = container_of(sample, struct ir_raw_event_ctrl, bpf_sample);
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
+lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
+static bool lirc_mode2_is_valid_access(int off, int size,
+				       enum bpf_access_type type,
+				       const struct bpf_prog *prog,
+				       struct bpf_insn_access_aux *info)
+{
+	/* We have one field of u32 */
+	return type == BPF_READ && off == 0 && size == sizeof(u32);
+}
+
+const struct bpf_verifier_ops lirc_mode2_verifier_ops = {
+	.get_func_proto  = lirc_mode2_func_proto,
+	.is_valid_access = lirc_mode2_is_valid_access
+};
+
+#define BPF_MAX_PROGS 64
+
+static int lirc_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
+{
+	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *new_array;
+	struct ir_raw_event_ctrl *raw;
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
+		goto unlock;
+	}
+
+	if (raw->progs && bpf_prog_array_length(raw->progs) >= BPF_MAX_PROGS) {
+		ret = -E2BIG;
+		goto unlock;
+	}
+
+	old_array = raw->progs;
+	ret = bpf_prog_array_copy(old_array, NULL, prog, &new_array);
+	if (ret < 0)
+		goto unlock;
+
+	rcu_assign_pointer(raw->progs, new_array);
+	bpf_prog_array_free(old_array);
+
+unlock:
+	mutex_unlock(&ir_raw_handler_lock);
+	return ret;
+}
+
+static int lirc_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
+{
+	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *new_array;
+	struct ir_raw_event_ctrl *raw;
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
+		goto unlock;
+	}
+
+	old_array = raw->progs;
+	ret = bpf_prog_array_copy(old_array, prog, NULL, &new_array);
+	/*
+	 * Do not use bpf_prog_array_delete_safe() as we would end up
+	 * with a dummy entry in the array, and the we would free the
+	 * dummy in lirc_bpf_free()
+	 */
+	if (ret)
+		goto unlock;
+
+	rcu_assign_pointer(raw->progs, new_array);
+	bpf_prog_array_free(old_array);
+unlock:
+	mutex_unlock(&ir_raw_handler_lock);
+	return ret;
+}
+
+void lirc_bpf_run(struct rc_dev *rcdev, u32 sample)
+{
+	struct ir_raw_event_ctrl *raw = rcdev->raw;
+
+	raw->bpf_sample = sample;
+
+	if (raw->progs)
+		BPF_PROG_RUN_ARRAY(raw->progs, &raw->bpf_sample, BPF_PROG_RUN);
+}
+
+/*
+ * This should be called once the rc thread has been stopped, so there can be
+ * no concurrent bpf execution.
+ */
+void lirc_bpf_free(struct rc_dev *rcdev)
+{
+	struct bpf_prog **progs;
+
+	if (!rcdev->raw->progs)
+		return;
+
+	progs = rcu_dereference(rcdev->raw->progs)->progs;
+	while (*progs)
+		bpf_prog_put(*progs++);
+
+	bpf_prog_array_free(rcdev->raw->progs);
+}
+
+int lirc_prog_attach(const union bpf_attr *attr)
+{
+	struct bpf_prog *prog;
+	struct rc_dev *rcdev;
+	int ret;
+
+	if (attr->attach_flags)
+		return -EINVAL;
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd,
+				 BPF_PROG_TYPE_LIRC_MODE2);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	if (IS_ERR(rcdev)) {
+		bpf_prog_put(prog);
+		return PTR_ERR(rcdev);
+	}
+
+	ret = lirc_bpf_attach(rcdev, prog);
+	if (ret)
+		bpf_prog_put(prog);
+
+	put_device(&rcdev->dev);
+
+	return ret;
+}
+
+int lirc_prog_detach(const union bpf_attr *attr)
+{
+	struct bpf_prog *prog;
+	struct rc_dev *rcdev;
+	int ret;
+
+	if (attr->attach_flags)
+		return -EINVAL;
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd,
+				 BPF_PROG_TYPE_LIRC_MODE2);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	if (IS_ERR(rcdev)) {
+		bpf_prog_put(prog);
+		return PTR_ERR(rcdev);
+	}
+
+	ret = lirc_bpf_detach(rcdev, prog);
+
+	bpf_prog_put(prog);
+	put_device(&rcdev->dev);
+
+	return ret;
+}
+
+int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
+{
+	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
+	struct bpf_prog_array __rcu *progs;
+	struct rc_dev *rcdev;
+	u32 cnt, flags = 0;
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
+		goto put;
+	}
+
+	ret = mutex_lock_interruptible(&ir_raw_handler_lock);
+	if (ret)
+		goto put;
+
+	progs = rcdev->raw->progs;
+	cnt = progs ? bpf_prog_array_length(progs) : 0;
+
+	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt))) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags))) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+
+	if (attr->query.prog_cnt != 0 && prog_ids && cnt)
+		ret = bpf_prog_array_copy_to_user(progs, prog_ids, cnt);
+
+unlock:
+	mutex_unlock(&ir_raw_handler_lock);
+put:
+	put_device(&rcdev->dev);
+
+	return ret;
+}
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 24e9fbb80e81..da7013a12a58 100644
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
@@ -104,6 +105,12 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
+	/*
+	 * bpf does not care about the gap generated above; that exists
+	 * for backwards compatibility
+	 */
+	lirc_bpf_run(dev, sample);
+
 	spin_lock_irqsave(&dev->lirc_fh_lock, flags);
 	list_for_each_entry(fh, &dev->lirc_fh, list) {
 		if (LIRC_IS_TIMEOUT(sample) && !fh->send_timeout_reports)
@@ -816,4 +823,27 @@ void __exit lirc_dev_exit(void)
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
index e0e6a17460f6..eb004757038b 100644
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
+#ifdef CONFIG_BPF_LIRC_MODE2
+	u32				bpf_sample;
+	struct bpf_prog_array __rcu	*progs;
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
@@ -299,4 +309,15 @@ static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
 static inline void ir_lirc_unregister(struct rc_dev *dev) { }
 #endif
 
+/*
+ * bpf interface
+ */
+#ifdef CONFIG_BPF_LIRC_MODE2
+void lirc_bpf_free(struct rc_dev *dev);
+void lirc_bpf_run(struct rc_dev *dev, u32 sample);
+#else
+static inline void lirc_bpf_free(struct rc_dev *dev) { }
+static inline void lirc_bpf_run(struct rc_dev *dev, u32 sample) { }
+#endif
+
 #endif /* _RC_CORE_PRIV */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 374f83105a23..7675b7ee5bc7 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -14,7 +14,7 @@
 static LIST_HEAD(ir_raw_client_list);
 
 /* Used to handle IR raw handler extensions */
-static DEFINE_MUTEX(ir_raw_handler_lock);
+DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static atomic64_t available_protocols = ATOMIC64_INIT(0);
 
@@ -621,9 +621,17 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 	list_for_each_entry(handler, &ir_raw_handler_list, list)
 		if (handler->raw_unregister)
 			handler->raw_unregister(dev);
-	mutex_unlock(&ir_raw_handler_lock);
+
+	lirc_bpf_free(dev);
 
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
diff --git a/include/linux/bpf_lirc.h b/include/linux/bpf_lirc.h
new file mode 100644
index 000000000000..5f8a4283092d
--- /dev/null
+++ b/include/linux/bpf_lirc.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_LIRC_H
+#define _BPF_LIRC_H
+
+#include <uapi/linux/bpf.h>
+
+#ifdef CONFIG_BPF_LIRC_MODE2
+int lirc_prog_attach(const union bpf_attr *attr);
+int lirc_prog_detach(const union bpf_attr *attr);
+int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr);
+#else
+static inline int lirc_prog_attach(const union bpf_attr *attr)
+{
+	return -EINVAL;
+}
+
+static inline int lirc_prog_detach(const union bpf_attr *attr)
+{
+	return -EINVAL;
+}
+
+static inline int lirc_prog_query(const union bpf_attr *attr,
+				  union bpf_attr __user *uattr)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* _BPF_LIRC_H */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index b161e506dcfc..c5700c2d5549 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -26,6 +26,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
 #endif
+#ifdef CONFIG_BPF_LIRC_MODE2
+BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 9b8c6e310e9a..4636c596096d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -143,6 +143,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_RAW_TRACEPOINT,
 	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
 	BPF_PROG_TYPE_LWT_SEG6LOCAL,
+	BPF_PROG_TYPE_LIRC_MODE2,
 };
 
 enum bpf_attach_type {
@@ -160,6 +161,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_CONNECT,
 	BPF_CGROUP_INET4_POST_BIND,
 	BPF_CGROUP_INET6_POST_BIND,
+	BPF_LIRC_MODE2,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -2004,6 +2006,53 @@ union bpf_attr {
  * 		direct packet access.
  *	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded key press with *scancode*,
+ *		*toggle* value in the given *protocol*. The scancode will be
+ *		translated to a keycode using the rc keymap, and reported as
+ *		an input key down event. After a period a key up event is
+ *		generated. This period can be extended by calling either
+ *		**bpf_rc_keydown** () again with the same values, or calling
+ *		**bpf_rc_repeat** ().
+ *
+ *		Some protocols include a toggle bit, in case the button	was
+ *		released and pressed again between consecutive scancodes.
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
+ *
+ *		The *protocol* is the decoded protocol number (see
+ *		**enum rc_proto** for some predefined values).
+ *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
+ *
+ *	Return
+ *		0
+ *
+ * int bpf_rc_repeat(void *ctx)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded repeat key message. This delays
+ *		the generation of a key up event for previously generated
+ *		key down event.
+ *
+ *		Some IR protocols like NEC have a special IR message for
+ *		repeating last button, for when a button is held down.
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
+ *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
+ *
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2082,7 +2131,9 @@ union bpf_attr {
 	FN(lwt_push_encap),		\
 	FN(lwt_seg6_store_bytes),	\
 	FN(lwt_seg6_adjust_srh),	\
-	FN(lwt_seg6_action),
+	FN(lwt_seg6_action),		\
+	FN(rc_repeat),			\
+	FN(rc_keydown),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 388d4feda348..3c104113d040 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -11,6 +11,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/bpf_lirc.h>
 #include <linux/btf.h>
 #include <linux/syscalls.h>
 #include <linux/slab.h>
@@ -1578,6 +1579,8 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
 		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, true);
+	case BPF_LIRC_MODE2:
+		return lirc_prog_attach(attr);
 	default:
 		return -EINVAL;
 	}
@@ -1648,6 +1651,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
 		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, false);
+	case BPF_LIRC_MODE2:
+		return lirc_prog_detach(attr);
 	default:
 		return -EINVAL;
 	}
@@ -1695,6 +1700,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SOCK_OPS:
 	case BPF_CGROUP_DEVICE:
 		break;
+	case BPF_LIRC_MODE2:
+		return lirc_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
-- 
2.17.0
