Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36915 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbeENVLF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 17:11:05 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH v1 2/4] media: bpf: allow raw IR decoder bpf programs to be used
Date: Mon, 14 May 2018 22:10:59 +0100
Message-Id: <cd3a5e27ef4122fab90daae2af6031982df77282.1526331777.git.sean@mess.org>
In-Reply-To: <cover.1526331777.git.sean@mess.org>
References: <cover.1526331777.git.sean@mess.org>
In-Reply-To: <cover.1526331777.git.sean@mess.org>
References: <cover.1526331777.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This implements attaching, detaching, querying and execution. The target
fd has to be the /dev/lircN device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-bpf-decoder.c | 191 ++++++++++++++++++++++++++++++
 drivers/media/rc/lirc_dev.c       |  30 +++++
 drivers/media/rc/rc-core-priv.h   |  15 +++
 drivers/media/rc/rc-ir-raw.c      |   5 +
 include/uapi/linux/bpf.h          |   1 +
 kernel/bpf/syscall.c              |   7 ++
 6 files changed, 249 insertions(+)

diff --git a/drivers/media/rc/ir-bpf-decoder.c b/drivers/media/rc/ir-bpf-decoder.c
index aaa5e208b1a5..651590a14772 100644
--- a/drivers/media/rc/ir-bpf-decoder.c
+++ b/drivers/media/rc/ir-bpf-decoder.c
@@ -91,3 +91,194 @@ const struct bpf_verifier_ops ir_decoder_verifier_ops = {
 	.get_func_proto  = ir_decoder_func_proto,
 	.is_valid_access = ir_decoder_is_valid_access
 };
+
+#define BPF_MAX_PROGS 64
+
+int rc_dev_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog, u32 flags)
+{
+	struct ir_raw_event_ctrl *raw;
+	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *new_array;
+	int ret;
+
+	if (rcdev->driver_type != RC_DRIVER_IR_RAW)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&rcdev->lock);
+	if (ret)
+		return ret;
+
+	raw = rcdev->raw;
+
+	if (raw->progs && bpf_prog_array_length(raw->progs) >= BPF_MAX_PROGS) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	old_array = raw->progs;
+	ret = bpf_prog_array_copy(old_array, NULL, prog, &new_array);
+	if (ret < 0)
+		goto out;
+
+	rcu_assign_pointer(raw->progs, new_array);
+	bpf_prog_array_free(old_array);
+out:
+	mutex_unlock(&rcdev->lock);
+	return ret;
+}
+
+int rc_dev_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog, u32 flags)
+{
+	struct ir_raw_event_ctrl *raw;
+	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *new_array;
+	int ret;
+
+	if (rcdev->driver_type != RC_DRIVER_IR_RAW)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&rcdev->lock);
+	if (ret)
+		return ret;
+
+	raw = rcdev->raw;
+
+	old_array = raw->progs;
+	ret = bpf_prog_array_copy(old_array, prog, NULL, &new_array);
+	if (ret < 0) {
+		bpf_prog_array_delete_safe(old_array, prog);
+	} else {
+		rcu_assign_pointer(raw->progs, new_array);
+		bpf_prog_array_free(old_array);
+	}
+
+	bpf_prog_put(prog);
+	mutex_unlock(&rcdev->lock);
+	return 0;
+}
+
+void rc_dev_bpf_run(struct rc_dev *rcdev)
+{
+	struct ir_raw_event_ctrl *raw = rcdev->raw;
+
+	if (raw->progs)
+		BPF_PROG_RUN_ARRAY(raw->progs, &raw->prev_ev, BPF_PROG_RUN);
+}
+
+void rc_dev_bpf_put(struct rc_dev *rcdev)
+{
+	struct bpf_prog_array *progs = rcdev->raw->progs;
+	int i, size;
+
+	if (!progs)
+		return;
+
+	size = bpf_prog_array_length(progs);
+	for (i = 0; i < size; i++)
+		bpf_prog_put(progs->progs[i]);
+
+	bpf_prog_array_free(rcdev->raw->progs);
+}
+
+int rc_dev_prog_attach(const union bpf_attr *attr)
+{
+	struct bpf_prog *prog;
+	struct rc_dev *rcdev;
+	int ret;
+
+	if (attr->attach_flags & BPF_F_ALLOW_OVERRIDE)
+		return -EINVAL;
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd,
+				 BPF_PROG_TYPE_RAWIR_DECODER);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	if (IS_ERR(rcdev)) {
+		bpf_prog_put(prog);
+		return PTR_ERR(rcdev);
+	}
+
+	ret = rc_dev_bpf_attach(rcdev, prog, attr->attach_flags);
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
+	if (attr->attach_flags & BPF_F_ALLOW_OVERRIDE)
+		return -EINVAL;
+
+	prog = bpf_prog_get_type(attr->attach_bpf_fd,
+				 BPF_PROG_TYPE_RAWIR_DECODER);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	if (IS_ERR(rcdev)) {
+		bpf_prog_put(prog);
+		return PTR_ERR(rcdev);
+	}
+
+	ret = rc_dev_bpf_detach(rcdev, prog, attr->attach_flags);
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
+	struct bpf_prog_array *progs;
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
+		goto out;
+	}
+
+	ret = mutex_lock_interruptible(&rcdev->lock);
+	if (ret)
+		goto out;
+
+	progs = rcdev->raw->progs;
+	cnt = progs ? bpf_prog_array_length(progs) : 0;
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
+	if (attr->query.prog_cnt != 0 && prog_ids && cnt)
+		ret = bpf_prog_array_copy_to_user(progs, prog_ids, cnt);
+
+out:
+	mutex_unlock(&rcdev->lock);
+	put_device(&rcdev->dev);
+
+	return ret;
+}
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 24e9fbb80e81..65319f2ccc13 100644
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
@@ -28,6 +29,8 @@
 #include "rc-core-priv.h"
 #include <uapi/linux/lirc.h>
 
+#include <linux/bpf-rcdev.h>
+
 #define LIRCBUF_SIZE	256
 
 static dev_t lirc_base_dev;
@@ -816,4 +819,31 @@ void __exit lirc_dev_exit(void)
 	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
 
+struct rc_dev *rc_dev_get_from_fd(int fd)
+{
+	struct rc_dev *dev;
+	struct file *f;
+
+	f = fget_raw(fd);
+	if (!f)
+		return ERR_PTR(-EBADF);
+
+	if (!S_ISCHR(f->f_inode->i_mode) ||
+	    imajor(f->f_inode) != MAJOR(lirc_base_dev)) {
+		fput(f);
+		return ERR_PTR(-EBADF);
+	}
+
+	dev = container_of(f->f_inode->i_cdev, struct rc_dev, lirc_cdev);
+	if (!dev->registered) {
+		fput(f);
+		return ERR_PTR(-ENODEV);
+	}
+
+	get_device(&dev->dev);
+	fput(f);
+
+	return dev;
+}
+
 MODULE_ALIAS("lirc_dev");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index e0e6a17460f6..b6f24f369657 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -57,6 +57,9 @@ struct ir_raw_event_ctrl {
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
 	struct ir_raw_event this_ev;
+#ifdef CONFIG_IR_BPF_DECODER
+	struct bpf_prog_array *progs;
+#endif
 	struct nec_dec {
 		int state;
 		unsigned count;
@@ -288,6 +291,7 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
 void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc);
 int ir_lirc_register(struct rc_dev *dev);
 void ir_lirc_unregister(struct rc_dev *dev);
+struct rc_dev *rc_dev_get_from_fd(int fd);
 #else
 static inline int lirc_dev_init(void) { return 0; }
 static inline void lirc_dev_exit(void) {}
@@ -299,4 +303,15 @@ static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
 static inline void ir_lirc_unregister(struct rc_dev *dev) { }
 #endif
 
+/*
+ * bpf interface
+ */
+#ifdef CONFIG_IR_BPF_DECODER
+void rc_dev_bpf_put(struct rc_dev *dev);
+void rc_dev_bpf_run(struct rc_dev *dev);
+#else
+void rc_dev_bpf_put(struct rc_dev *dev) {}
+void rc_dev_bpf_run(struct rc_dev *dev) {}
+#endif
+
 #endif /* _RC_CORE_PRIV */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 374f83105a23..efddd9c44466 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -8,6 +8,8 @@
 #include <linux/mutex.h>
 #include <linux/kmod.h>
 #include <linux/sched.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
 #include "rc-core-priv.h"
 
 /* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
@@ -33,6 +35,7 @@ static int ir_raw_event_thread(void *data)
 					handler->decode(raw->dev, ev);
 			ir_lirc_raw_event(raw->dev, ev);
 			raw->prev_ev = ev;
+			rc_dev_bpf_run(raw->dev);
 		}
 		mutex_unlock(&ir_raw_handler_lock);
 
@@ -623,6 +626,8 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 			handler->raw_unregister(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
+	rc_dev_bpf_put(dev);
+
 	ir_raw_event_free(dev);
 }
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6ad053e831c0..d9740599adf6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -155,6 +155,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_CONNECT,
 	BPF_CGROUP_INET4_POST_BIND,
 	BPF_CGROUP_INET6_POST_BIND,
+	BPF_RAWIR_DECODER,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 016ef9025827..63ecc1f2e1e3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -27,6 +27,7 @@
 #include <linux/timekeeping.h>
 #include <linux/ctype.h>
 #include <linux/nospec.h>
+#include <linux/bpf-rcdev.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
 			   (map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
@@ -1556,6 +1557,8 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
 		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, true);
+	case BPF_RAWIR_DECODER:
+		return rc_dev_prog_attach(attr);
 	default:
 		return -EINVAL;
 	}
@@ -1626,6 +1629,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
 		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, false);
+	case BPF_RAWIR_DECODER:
+		return rc_dev_prog_detach(attr);
 	default:
 		return -EINVAL;
 	}
@@ -1673,6 +1678,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SOCK_OPS:
 	case BPF_CGROUP_DEVICE:
 		break;
+	case BPF_RAWIR_DECODER:
+		return rc_dev_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
-- 
2.17.0
