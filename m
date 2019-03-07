Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BC7C4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D32120835
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfCGKKT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:10:19 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:56044 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfCGKKS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 05:10:18 -0500
Received: from randy.li?rock-chips.com (unknown [192.168.167.139])
        by regular1.263xmail.com (Postfix) with ESMTP id 69069237;
        Thu,  7 Mar 2019 18:03:35 +0800 (CST)
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
Received: from randy-pc.lan (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P17008T140071111993088S1551952999924990_;
        Thu, 07 Mar 2019 18:03:34 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <03301cc2a5f5be9d196847f29a3a4543>
X-RL-SENDER: randy.li@rock-chips.com
X-SENDER: randy.li@rock-chips.com
X-LOGIN-NAME: randy.li@rock-chips.com
X-FST-TO: linux-media@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Randy Li <randy.li@rock-chips.com>
To:     linux-media@vger.kernel.org
Cc:     Randy Li <ayaka@soulik.info>, hverkuil@xs4all.nl,
        maxime.ripard@bootlin.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, jernej.skrabec@gmail.com,
        nicolas@ndufresne.ca, paul.kocialkowski@bootlin.com,
        linux-rockchip@lists.infradead.org, thomas.petazzoni@bootlin.com,
        mchehab@kernel.org, ezequiel@collabora.com,
        linux-arm-kernel@lists.infradead.org, posciak@chromium.org,
        groeck@chromium.org, Randy Li <randy.li@rock-chips.com>
Subject: [PATCH v2 2/6] staging: video: rockchip: add v4l2 decoder
Date:   Thu,  7 Mar 2019 18:03:12 +0800
Message-Id: <20190307100316.925-3-randy.li@rock-chips.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190307100316.925-1-randy.li@rock-chips.com>
References: <20190307100316.925-1-randy.li@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Randy Li <ayaka@soulik.info>

It is based on the vendor driver sent to mail list before.

Only MPEG2 video for VDPU2 works. And it need a patch to
fill the QP table.

I have finished the register table of the rkvdec and rk hevc
decoder. But I can't feed its proper input stream, I will
talk the reason below.

The slice header reconstruction is not acceptable,
even I don't care about VP9 now, the reference picture set
for HEVC is very complex.

Signed-off-by: Randy Li <ayaka@soulik.info>
Signed-off-by: Randy Li <randy.li@rock-chips.com>
---
 drivers/staging/rockchip-mpp/Kconfig          |   34 +
 drivers/staging/rockchip-mpp/Makefile         |   10 +
 drivers/staging/rockchip-mpp/mpp_debug.h      |   87 ++
 drivers/staging/rockchip-mpp/mpp_dev_common.c | 1368 +++++++++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_common.h |  212 +++
 drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c |  997 ++++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c  |  616 ++++++++
 drivers/staging/rockchip-mpp/mpp_service.c    |  197 +++
 drivers/staging/rockchip-mpp/mpp_service.h    |   38 +
 drivers/staging/rockchip-mpp/rkvdec/hal.h     |   63 +
 drivers/staging/rockchip-mpp/rkvdec/hevc.c    |  166 ++
 drivers/staging/rockchip-mpp/rkvdec/regs.h    |  608 ++++++++
 drivers/staging/rockchip-mpp/vdpu2/hal.h      |   52 +
 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c    |  270 ++++
 drivers/staging/rockchip-mpp/vdpu2/regs.h     |  699 +++++++++
 15 files changed, 5417 insertions(+)
 create mode 100644 drivers/staging/rockchip-mpp/Kconfig
 create mode 100644 drivers/staging/rockchip-mpp/Makefile
 create mode 100644 drivers/staging/rockchip-mpp/mpp_debug.h
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.h
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_service.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_service.h
 create mode 100644 drivers/staging/rockchip-mpp/rkvdec/hal.h
 create mode 100644 drivers/staging/rockchip-mpp/rkvdec/hevc.c
 create mode 100644 drivers/staging/rockchip-mpp/rkvdec/regs.h
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/hal.h
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/regs.h

diff --git a/drivers/staging/rockchip-mpp/Kconfig b/drivers/staging/rockchip-mpp/Kconfig
new file mode 100644
index 000000000000..75eaa6a2541a
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/Kconfig
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: GPL-2.0
+menu "ROCKCHIP_MPP"
+	depends on ARCH_ROCKCHIP
+
+config ROCKCHIP_MPP_SERVICE
+	tristate "mpp service scheduler"
+	default n
+	help
+	  rockchip mpp service.
+
+config ROCKCHIP_MPP_DEVICE
+	tristate "mpp device framework"
+	depends on ROCKCHIP_MPP_SERVICE
+	select V4L2_MEM2MEM_DEV
+	select VIDEOBUF2_DMA_CONTIG
+	default n
+	help
+	  rockchip mpp device framework.
+
+config ROCKCHIP_MPP_VDEC_DEVICE
+	tristate "video decoder device driver"
+	depends on ROCKCHIP_MPP_DEVICE
+	default n
+	help
+	  rockchip mpp video decoder and hevc decoder.
+
+config ROCKCHIP_MPP_VDPU2_DEVICE
+	tristate "VPU decoder v2 device driver"
+	depends on ROCKCHIP_MPP_DEVICE
+	default n
+	help
+	  rockchip mpp vpu decoder v2.
+
+endmenu
diff --git a/drivers/staging/rockchip-mpp/Makefile b/drivers/staging/rockchip-mpp/Makefile
new file mode 100644
index 000000000000..c35ea3a13461
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+rk-mpp-service-objs := mpp_service.o
+rk-mpp-device-objs := mpp_dev_common.o
+rk-mpp-vdec-objs := mpp_dev_rkvdec.o rkvdec/hevc.o
+rk-mpp-vdpu2-objs := mpp_dev_vdpu2.o vdpu2/mpeg2.o
+
+obj-$(CONFIG_ROCKCHIP_MPP_SERVICE) += rk-mpp-service.o
+obj-$(CONFIG_ROCKCHIP_MPP_DEVICE) += rk-mpp-device.o
+obj-$(CONFIG_ROCKCHIP_MPP_VDEC_DEVICE) += rk-mpp-vdec.o
+obj-$(CONFIG_ROCKCHIP_MPP_VDPU2_DEVICE) += rk-mpp-vdpu2.o
diff --git a/drivers/staging/rockchip-mpp/mpp_debug.h b/drivers/staging/rockchip-mpp/mpp_debug.h
new file mode 100644
index 000000000000..bd6c0e594da3
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_debug.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2016 - 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _ROCKCHIP_MPP_DEBUG_H_
+#define _ROCKCHIP_MPP_DEBUG_H_
+
+#include <linux/types.h>
+
+/*
+ * debug flag usage:
+ * +------+-------------------+
+ * | 8bit |      24bit        |
+ * +------+-------------------+
+ *  0~23 bit is for different information type
+ * 24~31 bit is for information print format
+ */
+
+#define DEBUG_POWER				0x00000001
+#define DEBUG_CLOCK				0x00000002
+#define DEBUG_IRQ_STATUS			0x00000004
+#define DEBUG_IOMMU				0x00000008
+#define DEBUG_IOCTL				0x00000010
+#define DEBUG_FUNCTION				0x00000020
+#define DEBUG_REGISTER				0x00000040
+#define DEBUG_EXTRA_INFO			0x00000080
+#define DEBUG_TIMING				0x00000100
+#define DEBUG_TASK_INFO				0x00000200
+#define DEBUG_DUMP_ERR_REG			0x00000400
+#define DEBUG_LINK_TABLE			0x00000800
+
+#define DEBUG_SET_REG				0x00001000
+#define DEBUG_GET_REG				0x00002000
+#define DEBUG_PPS_FILL				0x00004000
+#define DEBUG_IRQ_CHECK				0x00008000
+#define DEBUG_CACHE_32B				0x00010000
+
+#define DEBUG_RESET				0x00020000
+
+#define PRINT_FUNCTION				0x80000000
+#define PRINT_LINE				0x40000000
+
+#define mpp_debug_func(type, fmt, args...)			\
+	do {							\
+		if (unlikely(debug & type)) {			\
+			pr_info("%s:%d: " fmt,			\
+				 __func__, __LINE__, ##args);	\
+		}						\
+	} while (0)
+#define mpp_debug(type, fmt, args...)				\
+	do {							\
+		if (unlikely(debug & type)) {			\
+			pr_info(fmt, ##args);			\
+		}						\
+	} while (0)
+
+#define mpp_debug_enter()					\
+	do {							\
+		if (unlikely(debug & DEBUG_FUNCTION)) {		\
+			pr_info("%s:%d: enter\n",		\
+				 __func__, __LINE__);		\
+		}						\
+	} while (0)
+
+#define mpp_debug_leave()					\
+	do {							\
+		if (unlikely(debug & DEBUG_FUNCTION)) {		\
+			pr_info("%s:%d: leave\n",		\
+				 __func__, __LINE__);		\
+		}						\
+	} while (0)
+
+#define mpp_err(fmt, args...)					\
+		pr_err("%s:%d: " fmt, __func__, __LINE__, ##args)
+
+#endif
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_common.c b/drivers/staging/rockchip-mpp/mpp_dev_common.c
new file mode 100644
index 000000000000..c43304c3e7b8
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_common.c
@@ -0,0 +1,1368 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2016 - 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *		Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_irq.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+#include "mpp_service.h"
+
+#define MPP_TIMEOUT_DELAY		(2000)
+#include "mpp_dev_common.h"
+
+#define MPP_SESSION_MAX_DONE_TASK	(20)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "bit switch for mpp device debug information");
+
+static struct class *mpp_device_class;
+
+static int rockchip_mpp_result(struct rockchip_mpp_dev *mpp_dev,
+			       struct mpp_task *task);
+
+static const struct media_device_ops mpp_m2m_media_ops = {
+	.req_validate   = vb2_request_validate,
+	.req_queue      = v4l2_m2m_request_queue,
+};
+
+static void mpp_session_push_pending(struct mpp_session *session,
+				     struct mpp_task *task)
+{
+	mutex_lock(&session->lock);
+	list_add_tail(&task->session_link, &session->pending);
+	mutex_unlock(&session->lock);
+}
+
+static void mpp_session_push_done(struct mpp_task *task)
+{
+	struct mpp_session *session = NULL;
+
+	session = task->session;
+
+	mutex_lock(&session->lock);
+	list_del_init(&task->session_link);
+	mutex_unlock(&session->lock);
+
+	//kfifo_in(&session->done_fifo, &task, 1);
+	rockchip_mpp_result(session->mpp_dev, task);
+}
+
+static struct mpp_task *mpp_session_pull_done(struct mpp_session *session)
+{
+	struct mpp_task *task = NULL;
+
+	if (kfifo_out(&session->done_fifo, &task, 1))
+		return task;
+	return NULL;
+}
+
+static void mpp_dev_sched_irq(struct work_struct *work)
+{
+	struct mpp_task *task = container_of(work, struct mpp_task, work);
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+
+	mpp_dev = task->session->mpp_dev;
+
+	mpp_debug_time_diff(task);
+
+	if (mpp_dev->ops->finish)
+		mpp_dev->ops->finish(mpp_dev, task);
+
+	atomic_dec(&task->session->task_running);
+	pm_runtime_mark_last_busy(mpp_dev->dev);
+	pm_runtime_put_autosuspend(mpp_dev->dev);
+	/*
+	 * TODO: unlock the reader locker of the device resource locker
+	 * here
+	 */
+	mpp_srv_done(mpp_dev->srv, task);
+	/* Wake up the GET thread */
+	mpp_session_push_done(task);
+}
+
+static void *mpp_dev_alloc_task(struct rockchip_mpp_dev *mpp_dev,
+				struct mpp_session *session, void __user *src,
+				u32 size)
+{
+	if (mpp_dev->ops->alloc_task)
+		return mpp_dev->ops->alloc_task(session, src, size);
+	return NULL;
+}
+
+static int mpp_dev_free_task(struct mpp_session *session, struct mpp_task *task)
+{
+	struct rockchip_mpp_dev *mpp_dev = session->mpp_dev;
+
+	if (mpp_dev->ops->free_task)
+		mpp_dev->ops->free_task(session, task);
+	return 0;
+}
+
+int mpp_dev_task_init(struct mpp_session *session, struct mpp_task *task)
+{
+	INIT_LIST_HEAD(&task->session_link);
+	INIT_LIST_HEAD(&task->service_link);
+	INIT_WORK(&task->work, mpp_dev_sched_irq);
+
+	task->session = session;
+
+	return 0;
+}
+EXPORT_SYMBOL(mpp_dev_task_init);
+
+void mpp_dev_task_finish(struct mpp_session *session, struct mpp_task *task)
+{
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+
+	mpp_dev = session->mpp_dev;
+	queue_work(mpp_dev->irq_workq, &task->work);
+}
+EXPORT_SYMBOL(mpp_dev_task_finish);
+
+void mpp_dev_task_finalize(struct mpp_session *session, struct mpp_task *task)
+{
+#if 0
+	struct vb2_v4l2_buffer *src, *dst;
+
+	src = v4l2_m2m_src_buf_remove(session->fh.m2m_ctx);
+	dst = v4l2_m2m_dst_buf_remove(session->fh.m2m_ctx);
+	if (WARN_ON(!src))
+		return -EINVAL;
+
+	if (WARN_ON(!dst))
+		return -EINVAL;
+
+	src->sequence = session->sequence_out++;
+	dst->sequence = session->sequence_cap++;
+
+	v4l2_m2m_buf_copy_data(src, dst, true);
+
+	v4l2_m2m_buf_done(src, result);
+	v4l2_m2m_buf_done(dst, result);
+#endif
+}
+EXPORT_SYMBOL(mpp_dev_task_finalize);
+
+static void mpp_dev_session_clear(struct rockchip_mpp_dev *mpp,
+				  struct mpp_session *session)
+{
+	struct mpp_task *task, *n;
+
+	list_for_each_entry_safe(task, n, &session->pending, session_link) {
+		list_del(&task->session_link);
+		mpp_dev_free_task(session, task);
+	}
+	while (kfifo_out(&session->done_fifo, &task, 1))
+		mpp_dev_free_task(session, task);
+}
+
+#if 0
+void *mpp_dev_alloc_session(struct rockchip_mpp_dev *mpp_dev)
+{
+	struct mpp_session *session = NULL;
+	int error = 0;
+
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
+	if (!session)
+		return ERR_PTR(-ENOMEM);
+
+	session->pid = current->pid;
+	session->mpp_dev = mpp_dev;
+	mutex_init(&session->lock);
+	INIT_LIST_HEAD(&session->pending);
+	init_waitqueue_head(&session->wait);
+	error = kfifo_alloc(&session->done_fifo, MPP_SESSION_MAX_DONE_TASK,
+			    GFP_KERNEL);
+	if (error < 0) {
+		kfree(session);
+		return ERR_PTR(error);
+	}
+
+	atomic_set(&session->task_running, 0);
+	INIT_LIST_HEAD(&session->list_session);
+	
+	return session;
+}
+EXPORT_SYMBOL(mpp_dev_alloc_session);
+
+#endif
+
+static void mpp_dev_reset(struct rockchip_mpp_dev *mpp_dev)
+{
+	mpp_debug_enter();
+
+	/* FIXME lock resource lock of the other devices in combo */
+	write_lock(&mpp_dev->resource_rwlock);
+	atomic_set(&mpp_dev->reset_request, 0);
+
+	iommu_detach_device(mpp_dev->domain, mpp_dev->dev);
+	mpp_dev->ops->reset(mpp_dev);
+	iommu_attach_device(mpp_dev->domain, mpp_dev->dev);
+
+	write_unlock(&mpp_dev->resource_rwlock);
+	mpp_debug_leave();
+}
+
+static void mpp_dev_abort(struct rockchip_mpp_dev *mpp_dev)
+{
+	int ret = 0;
+
+	mpp_debug_enter();
+
+	/* destroy the current task after hardware reset */
+	ret = mpp_srv_is_running(mpp_dev->srv);
+
+	mpp_dev_reset(mpp_dev);
+
+	if (ret) {
+		struct mpp_task *task = NULL;
+
+		task = mpp_srv_get_cur_task(mpp_dev->srv);
+		cancel_work_sync(&task->work);
+		list_del(&task->session_link);
+		mpp_srv_abort(mpp_dev->srv, task);
+		mpp_dev_free_task(task->session, task);
+		atomic_dec(&task->session->task_running);
+	} else {
+		mpp_srv_abort(mpp_dev->srv, NULL);
+	}
+
+	mpp_debug_leave();
+}
+
+void mpp_dev_power_on(struct rockchip_mpp_dev *mpp_dev)
+{
+	pm_runtime_get_sync(mpp_dev->dev);
+	pm_stay_awake(mpp_dev->dev);
+}
+
+void mpp_dev_power_off(struct rockchip_mpp_dev *mpp_dev)
+{
+	pm_runtime_put_sync(mpp_dev->dev);
+	pm_relax(mpp_dev->dev);
+}
+
+static void rockchip_mpp_run(struct rockchip_mpp_dev *mpp_dev,
+			     struct mpp_task *task)
+{
+	mpp_debug_enter();
+	/*
+	 * As I got the global lock from the mpp service here,
+	 * I am the very task to be run, the device is ready
+	 * for me. Wait a gap in the other is operating with the IOMMU.
+	 */
+	if (atomic_read(&mpp_dev->reset_request))
+		mpp_dev_reset(mpp_dev);
+
+	mpp_debug_time_record(task);
+
+	mpp_debug(DEBUG_TASK_INFO, "pid %d, start hw %s\n",
+		  task->session->pid, dev_name(mpp_dev->dev));
+
+	if (unlikely(debug & DEBUG_REGISTER))
+		mpp_debug_dump_reg(mpp_dev->reg_base,
+				   mpp_dev->variant->reg_len);
+
+	/*
+	 * TODO: Lock the reader locker of the device resource lock here,
+	 * release at the finish operation
+	 */
+	if (mpp_dev->ops->run)
+		mpp_dev->ops->run(mpp_dev, task);
+
+	mpp_debug_leave();
+}
+
+static void rockchip_mpp_try_run(struct rockchip_mpp_dev *mpp_dev)
+{
+	int ret = 0;
+	struct mpp_task *task;
+
+	mpp_debug_enter();
+
+	task = mpp_srv_get_pending_task(mpp_dev->srv);
+
+	if (mpp_dev->ops->prepare)
+		ret = mpp_dev->ops->prepare(mpp_dev, task);
+
+	mpp_srv_wait_to_run(mpp_dev->srv, task);
+	/*
+	 * FIXME if the hardware supports task query, but we still need to lock
+	 * the running list and lock the mpp service in the current state.
+	 */
+	/* Push a pending task to running queue */
+	rockchip_mpp_run(mpp_dev, task);
+
+	mpp_debug_leave();
+}
+
+static int rockchip_mpp_result(struct rockchip_mpp_dev *mpp_dev,
+			       struct mpp_task *task)
+{
+	struct mpp_session *session = NULL;
+	struct vb2_v4l2_buffer *src, *dst;
+	enum vb2_buffer_state result = VB2_BUF_STATE_DONE;
+
+	mpp_debug_enter();
+
+	if (!mpp_dev || !task)
+		return -EINVAL;
+
+	session = task->session;
+
+	if (mpp_dev->ops->result)
+		result = mpp_dev->ops->result(mpp_dev, task, NULL, 0);
+
+	mpp_dev_free_task(session, task);
+
+	src = v4l2_m2m_src_buf_remove(session->fh.m2m_ctx);
+	dst = v4l2_m2m_dst_buf_remove(session->fh.m2m_ctx);
+	if (WARN_ON(!src))
+		return -EINVAL;
+
+	if (WARN_ON(!dst))
+		return -EINVAL;
+
+	src->sequence = session->sequence_out++;
+	dst->sequence = session->sequence_cap++;
+
+	v4l2_m2m_buf_copy_metadata(src, dst, true);
+
+	v4l2_m2m_buf_done(src, result);
+	v4l2_m2m_buf_done(dst, result);
+
+	v4l2_m2m_job_finish(mpp_dev->m2m_dev, session->fh.m2m_ctx);
+
+	mpp_debug_leave();
+	return 0;
+}
+
+#if 0
+static int rockchip_mpp_wait_result(struct mpp_session *session,
+				    struct rockchip_mpp_dev *mpp,
+				    struct vpu_request req)
+{
+	struct mpp_task *task;
+	int ret;
+
+	ret = wait_event_timeout(session->wait,
+				 !kfifo_is_empty(&session->done_fifo),
+				 msecs_to_jiffies(MPP_TIMEOUT_DELAY));
+	if (ret == 0) {
+		mpp_err("error: pid %d wait %d task done timeout\n",
+			session->pid, atomic_read(&session->task_running));
+		ret = -ETIMEDOUT;
+
+		if (unlikely(debug & DEBUG_REGISTER))
+			mpp_debug_dump_reg(mpp->reg_base,
+					   mpp->variant->reg_len);
+		mpp_dev_abort(mpp);
+
+		return ret;
+	}
+
+	task = mpp_session_pull_done(session);
+	rockchip_mpp_result(mpp, task, req.req, req.size);
+
+	return 0;
+}
+
+long mpp_dev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct mpp_session *session = (struct mpp_session *)filp->private_data;
+	struct rockchip_mpp_dev *mpp = NULL;
+
+	mpp_debug_enter();
+	if (!session)
+		return -EINVAL;
+
+	mpp = session->mpp_dev;
+
+	switch (cmd) {
+	case VPU_IOC_SET_CLIENT_TYPE:
+		break;
+	case VPU_IOC_SET_REG: {
+		struct vpu_request req;
+		struct mpp_task *task;
+
+		mpp_debug(DEBUG_IOCTL, "pid %d set reg\n",
+			  session->pid);
+		if (copy_from_user(&req, (void __user *)arg,
+				   sizeof(struct vpu_request))) {
+			mpp_err("error: set reg copy_from_user failed\n");
+			return -EFAULT;
+		}
+
+		task = mpp_dev_alloc_task(mpp, session, (void __user *)req.req,
+					  req.size);
+		if (IS_ERR_OR_NULL(task))
+			return -EFAULT;
+		mpp_srv_push_pending(mpp->srv, task);
+		mpp_session_push_pending(session, task);
+		atomic_inc(&session->task_running);
+
+		/* TODO: processing the current task */
+		rockchip_mpp_try_run(mpp);
+	} break;
+	case VPU_IOC_GET_REG: {
+		struct vpu_request req;
+
+		mpp_debug(DEBUG_IOCTL, "pid %d get reg\n",
+			  session->pid);
+		if (copy_from_user(&req, (void __user *)arg,
+				   sizeof(struct vpu_request))) {
+			mpp_err("error: get reg copy_from_user failed\n");
+			return -EFAULT;
+		}
+
+		return rockchip_mpp_wait_result(session, mpp, req);
+	} break;
+	case VPU_IOC_PROBE_IOMMU_STATUS: {
+		int iommu_enable = 1;
+
+		mpp_debug(DEBUG_IOCTL, "VPU_IOC_PROBE_IOMMU_STATUS\n");
+
+		if (put_user(iommu_enable, ((u32 __user *)arg))) {
+			mpp_err("error: iommu status copy_to_user failed\n");
+			return -EFAULT;
+		}
+		break;
+	}
+	default: {
+		dev_err(mpp->dev, "unknown mpp ioctl cmd %x\n", cmd);
+		return -ENOIOCTLCMD;
+	} break;
+	}
+
+	mpp_debug_leave();
+	return 0;
+}
+EXPORT_SYMBOL(mpp_dev_ioctl);
+
+static unsigned int mpp_dev_poll(struct file *filp, poll_table *wait)
+{
+	struct mpp_session *session = (struct mpp_session *)filp->private_data;
+	unsigned int mask = 0;
+
+	poll_wait(filp, &session->wait, wait);
+	if (kfifo_len(&session->done_fifo))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static int mpp_dev_open(struct file *filp)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(flip);
+	struct video_device *vdev = video_devdata(filp);
+	struct mpp_session *session = NULL;
+	int error = 0;
+
+	mpp_debug_enter();
+
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
+	if (!session)
+		return -ENOMEM;
+
+	session->pid = current->pid;
+	session->mpp_dev = mpp_dev;
+	mutex_init(&session->lock);
+	INIT_LIST_HEAD(&session->pending);
+	init_waitqueue_head(&session->wait);
+	error = kfifo_alloc(&session->done_fifo, MPP_SESSION_MAX_DONE_TASK,
+			    GFP_KERNEL);
+	if (error < 0)
+		goto fail;
+
+	atomic_set(&session->task_running, 0);
+	INIT_LIST_HEAD(&session->list_session);
+#if 0
+	session->fh.m2m_ctx = v4l2_m2m_ctx_init(mpp_dev->m2m_dev, session,
+						default_queue_init);
+	if (IS_ERR(session->fh.m2m_ctx)) {
+		error = PTR_ERR(session->fb.m2m_ctx);
+		goto fail;
+	}
+	v4l2_fh_init(&session->fh, vdev);
+	filp->private_data = &session->fh;
+	v4l2_fh_add(&session->fh);
+
+	/* TODO: setup default formats */
+
+	/* TODO: install v4l2 ctrl */
+	if (error) {
+		dev_err(mpp_dev->dev, "Failed to set up controls\n");
+		goto err_fh;
+	}
+
+	session->fb.ctrl_handler = mpp_dev->ctrl_handler;
+#endif
+
+	mpp_dev_power_on(mpp);
+	mpp_debug_leave();
+
+	return 0;
+
+err_fh:
+	v4l2_fh_del(&session->fh);
+	v4l2_fh_exit(&session->fh);
+fail:
+	kfree(session);
+	return error; 
+}
+
+static int mpp_dev_release(struct file *filp)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(flip);
+	int task_running;
+
+	mpp_debug_enter();
+	if (!session)
+		return -EINVAL;
+
+	/* TODO: is it necessary for v4l2? */
+	task_running = atomic_read(&session->task_running);
+	if (task_running) {
+		pr_err("session %d still has %d task running when closing\n",
+		       session->pid, task_running);
+		msleep(50);
+	}
+	wake_up(&session->wait);
+
+#if 0
+	v4l2_m2m_ctx_release(session->fh.m2m_ctx);
+	v4l2_fh_del(&seesion->>fh);
+	v4l2_fh_exit(&session->fh);
+	v4l2_ctrl_handler_free(&session->ctrl_handler);
+#endif
+	mpp_dev_session_clear(mpp, session);
+
+#if 0
+	read_lock(&mpp->resource_rwlock);
+	read_unlock(&mpp->resource_rwlock);
+#endif
+	kfifo_free(&session->done_fifo);
+	filp->private_data = NULL;
+
+	mpp_dev_power_off(mpp);
+	kfree(session);
+
+	dev_dbg(mpp->dev, "closed\n");
+	mpp_debug_leave();
+	return 0;
+}
+
+static const struct v4l2_file_operations mpp_v4l2_default_fops = {
+	.owner = THIS_MODULE,
+	.open = mpp_dev_open,
+	.release = mpp_dev_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+};
+#endif
+
+static struct mpp_service_node *mpp_dev_load_srv(struct platform_device *p)
+{
+	struct mpp_service *srv = NULL;
+	struct device_node *np = NULL;
+	struct platform_device *pdev = NULL;
+	struct mpp_service_node *client = NULL;
+
+	np = of_parse_phandle(p->dev.of_node, "rockchip,srv", 0);
+	if (!np || !of_device_is_available(np)) {
+		dev_err(&p->dev,
+			"failed to get the mpp service node\n");
+		return NULL;
+	}
+
+	pdev = of_find_device_by_node(np);
+	if (!pdev) {
+		of_node_put(np);
+		dev_err(&p->dev,
+			"failed to get mpp service from node\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	device_lock(&pdev->dev);
+
+	srv = platform_get_drvdata(pdev);
+	if (srv) {
+		client = mpp_srv_attach(srv, NULL);
+	} else {
+		dev_info(&pdev->dev, "defer probe\n");
+		client = ERR_PTR(-EPROBE_DEFER);
+	}
+	device_unlock(&pdev->dev);
+
+	put_device(&pdev->dev);
+	of_node_put(np);
+
+	return client;
+}
+
+static void mpp_device_run(void *priv)
+{
+	struct mpp_session *session = (struct mpp_session *)priv;
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+	struct mpp_task *task;
+
+	mpp_debug_enter();
+	if (!session)
+		return;
+
+	mpp_dev = session->mpp_dev;
+
+	mpp_debug(DEBUG_IOCTL, "pid %d set reg\n", session->pid);
+	/* power on here */
+	if (pm_runtime_get_if_in_use(mpp_dev->dev) <= 0) {
+		/* TODO: destroy the session and report more error */
+		dev_err(mpp_dev->dev, "can't power on device\n");
+		return;
+	}
+
+	task = mpp_dev_alloc_task(mpp_dev, session, NULL, 0);
+	if (IS_ERR_OR_NULL(task))
+		return;
+
+	mpp_srv_push_pending(mpp_dev->srv, task);
+	mpp_session_push_pending(session, task);
+	atomic_inc(&session->task_running);
+
+	/* TODO: processing the current task */
+	rockchip_mpp_try_run(mpp_dev);
+
+	mpp_debug_leave();
+}
+
+#if 0
+void mpp_job_abort(void *priv)
+{
+	struct mpp_session *session = (struct mpp_session *)priv;
+
+	/* TODO: invoke v4l2_m2m_job_finish */
+	mpp_dev_abort(session->mpp_dev);
+}
+#endif
+
+static const struct v4l2_m2m_ops mpp_m2m_ops = {
+	.device_run = mpp_device_run,
+#if 0
+	.job_abort = mpp_job_abort,
+#endif
+};
+
+/* The device will do more probing work after this */
+int mpp_dev_common_probe(struct rockchip_mpp_dev *mpp_dev,
+			 struct platform_device *pdev, struct mpp_dev_ops *ops)
+{
+	struct device *dev = NULL;
+	struct resource *res = NULL;
+	int err;
+
+	/* Get and register to MPP service */
+	mpp_dev->srv = mpp_dev_load_srv(pdev);
+	if (IS_ERR_OR_NULL(mpp_dev->srv))
+		return PTR_ERR(mpp_dev->srv);
+
+	dev = &pdev->dev;
+	mpp_dev->dev = dev;
+	mpp_dev->ops = ops;
+
+	rwlock_init(&mpp_dev->resource_rwlock);
+
+	device_init_wakeup(mpp_dev->dev, true);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	pm_runtime_idle(dev);
+
+	mpp_dev->irq_workq = alloc_ordered_workqueue("%s_irq_wq",
+						     WQ_MEM_RECLAIM
+						     | WQ_FREEZABLE,
+						     dev_name(mpp_dev->dev));
+	if (!mpp_dev->irq_workq) {
+		dev_err(dev, "failed to create irq workqueue\n");
+		err = -EINVAL;
+		goto failed_irq_workq;
+	}
+
+	mpp_dev->irq = platform_get_irq(pdev, 0);
+	if (mpp_dev->irq < 0) {
+		dev_err(dev, "No interrupt resource found\n");
+		err = -ENODEV;
+		goto failed;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		err = -ENODEV;
+		goto failed;
+	}
+	mpp_dev->reg_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(mpp_dev->reg_base)) {
+		err = PTR_ERR(mpp_dev->reg_base);
+		goto failed;
+	}
+
+	/* V4l2 part */
+	mutex_init(&mpp_dev->dev_lock);
+
+	err = v4l2_device_register(dev, &mpp_dev->v4l2_dev);
+	if (err) {
+		dev_err(dev, "Failed to register v4l2 device\n");
+		goto failed;
+	}
+
+	/* TODO */
+	mpp_dev->m2m_dev = v4l2_m2m_init(&mpp_m2m_ops);
+	if (IS_ERR(mpp_dev->m2m_dev)) {
+		v4l2_err(&mpp_dev->v4l2_dev, "Failed to init mem2mem device\n");
+		err = PTR_ERR(mpp_dev->m2m_dev);
+		goto err_v4l2_unreg;
+	}
+
+	mpp_dev->mdev.dev = dev;
+	strlcpy(mpp_dev->mdev.model, MPP_MODULE_NAME,
+		sizeof(mpp_dev->mdev.model));
+	media_device_init(&mpp_dev->mdev);
+	mpp_dev->mdev.ops = &mpp_m2m_media_ops;
+	mpp_dev->v4l2_dev.mdev = &mpp_dev->mdev;
+
+	mpp_dev->domain = iommu_get_domain_for_dev(dev);
+
+	return 0;
+
+err_v4l2_unreg:
+	v4l2_device_unregister(&mpp_dev->v4l2_dev);
+failed_irq_workq:
+	destroy_workqueue(mpp_dev->irq_workq);
+failed:
+	pm_runtime_disable(dev);
+	return err;
+}
+EXPORT_SYMBOL(mpp_dev_common_probe);
+
+/* Remember to set the platform data after this */
+int mpp_dev_register_node(struct rockchip_mpp_dev *mpp_dev,
+			  const char *node_name, const void *v4l2_fops,
+			  const void *v4l2_ioctl_ops)
+{
+	struct video_device *vfd;
+	int ret = 0;
+
+	/* create a device node */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&mpp_dev->v4l2_dev,
+			 "Failed to allocate video device\n");
+		return -ENOMEM;
+	}
+
+	vfd->fops = v4l2_fops;
+	vfd->release = video_device_release; 
+	vfd->lock = &mpp_dev->dev_lock;
+	vfd->v4l2_dev = &mpp_dev->v4l2_dev;
+	vfd->vfl_dir = VFL_DIR_M2M;
+	vfd->device_caps = V4L2_CAP_STREAMING;
+	vfd->ioctl_ops = v4l2_ioctl_ops;
+
+	strlcpy(vfd->name, node_name, sizeof(vfd->name));
+	video_set_drvdata(vfd, mpp_dev);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&mpp_dev->v4l2_dev,
+			 "Failed to register video device\n");
+		goto err_m2m_rel;
+	}
+	v4l2_info(&mpp_dev->v4l2_dev, "registered as /dev/video%d\n", vfd->num);
+
+	ret = v4l2_m2m_register_media_controller(mpp_dev->m2m_dev, vfd,
+						 mpp_dev->variant->vfd_func);
+	if (ret) {
+		v4l2_err(&mpp_dev->v4l2_dev,
+			 "Failed to init mem2mem media controller\n");
+		goto err_unreg_video;
+	}
+
+	mpp_dev->vfd = vfd;
+
+	ret = media_device_register(&mpp_dev->mdev);
+	if (ret) {
+		v4l2_err(&mpp_dev->v4l2_dev,
+			 "Failed to register mem2mem media device\n");
+		goto err_unreg_video_dev;
+	}
+
+	return 0;
+
+err_unreg_video:
+	video_unregister_device(mpp_dev->vfd);
+err_unreg_video_dev:
+	video_device_release(mpp_dev->vfd);
+err_m2m_rel:
+	v4l2_m2m_release(mpp_dev->m2m_dev);
+	return ret;
+}
+EXPORT_SYMBOL(mpp_dev_register_node);
+
+int mpp_dev_common_remove(struct rockchip_mpp_dev *mpp_dev)
+{
+	destroy_workqueue(mpp_dev->irq_workq);
+
+	media_device_unregister(&mpp_dev->mdev);
+	v4l2_m2m_unregister_media_controller(mpp_dev->m2m_dev);
+	media_device_cleanup(&mpp_dev->mdev);
+
+	video_unregister_device(mpp_dev->vfd);
+	video_device_release(mpp_dev->vfd);
+
+	mpp_srv_detach(mpp_dev->srv);
+
+	mpp_dev_power_off(mpp_dev);
+
+	device_init_wakeup(mpp_dev->dev, false);
+	pm_runtime_disable(mpp_dev->dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(mpp_dev_common_remove);
+
+void mpp_debug_dump_reg(void __iomem *regs, int count)
+{
+	int i;
+
+	pr_info("dumping registers: %p\n", regs);
+
+	for (i = 0; i < count; i++)
+		pr_info("reg[%02d]: %08x\n", i, readl_relaxed(regs + i * 4));
+}
+EXPORT_SYMBOL(mpp_debug_dump_reg);
+
+void mpp_debug_dump_reg_mem(u32 *regs, int count)
+{
+	int i;
+
+	pr_info("Dumping registers: %p\n", regs);
+
+	for (i = 0; i < count; i++)
+		pr_info("reg[%03d]: %08x\n", i, regs[i]);
+}
+EXPORT_SYMBOL(mpp_debug_dump_reg_mem);
+
+void mpp_dev_write_seq(struct rockchip_mpp_dev *mpp_dev, unsigned long offset,
+		       void *buffer, unsigned long count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		u32 *cur = (u32 *)buffer;
+		u32 pos = offset + i * 4;
+		u32 j = i + (u32)(offset / 4);
+
+		cur += i;
+		mpp_debug(DEBUG_SET_REG, "write reg[%03d]: %08x\n", j, *cur);
+		iowrite32(*cur, mpp_dev->reg_base + pos);
+	}
+}
+EXPORT_SYMBOL(mpp_dev_write_seq);
+
+void mpp_dev_write(struct rockchip_mpp_dev *mpp, u32 reg, u32 val)
+{
+	mpp_debug(DEBUG_SET_REG, "write reg[%03d]: %08x\n", reg / 4, val);
+	iowrite32(val, mpp->reg_base + reg);
+}
+EXPORT_SYMBOL(mpp_dev_write);
+
+void mpp_dev_read_seq(struct rockchip_mpp_dev *mpp_dev,
+		      unsigned long offset, void *buffer,
+		      unsigned long count)
+{
+	int i = 0;
+
+	for (i = 0; i < count; i++) {
+		u32 *cur = (u32 *)buffer;
+		u32 pos = offset / 4 + i;
+
+		cur += i;
+		*cur = ioread32(mpp_dev->reg_base + pos * 4);
+		mpp_debug(DEBUG_GET_REG, "get reg[%03d]: %08x\n", pos, *cur);
+	}
+}
+EXPORT_SYMBOL(mpp_dev_read_seq);
+
+u32 mpp_dev_read(struct rockchip_mpp_dev *mpp, u32 reg)
+{
+	u32 val = ioread32(mpp->reg_base + reg);
+
+	mpp_debug(DEBUG_GET_REG, "get reg[%03d] 0x%x: %08x\n", reg / 4,
+		  reg, val);
+	return val;
+}
+EXPORT_SYMBOL(mpp_dev_read);
+
+void mpp_debug_time_record(struct mpp_task *task)
+{
+	if (unlikely(debug & DEBUG_TIMING) && task)
+		getboottime64(&task->start);
+}
+EXPORT_SYMBOL(mpp_debug_time_record);
+
+void mpp_debug_time_diff(struct mpp_task *task)
+{
+	struct timespec64 end;
+
+	getboottime64(&end);
+	mpp_debug(DEBUG_TIMING, "time: %lld ms\n",
+		  (end.tv_sec  - task->start.tv_sec)  * 1000 +
+		  (end.tv_nsec - task->start.tv_nsec) / 1000000);
+}
+EXPORT_SYMBOL(mpp_debug_time_diff);
+
+static int mpp_m2m_querycap(struct file *filp, void *fh,
+			    struct v4l2_capability *cap)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+
+	strscpy(cap->driver, MPP_MODULE_NAME, sizeof(cap->driver));
+	strscpy(cap->card, MPP_MODULE_NAME, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(mpp_dev->dev));
+
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int mpp_g_fmt_mplane(struct file *filp, void *fh, struct v4l2_format *f)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct v4l2_pix_format_mplane *fmt = NULL;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		fmt = &session->fmt_cap;
+	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		fmt = &session->fmt_out;
+
+	*pix_mp = *fmt;
+
+	return 0;
+}
+
+static int mpp_enum_fmt_mplane(struct file *filp, void *priv,
+			       struct v4l2_fmtdesc *f)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	const struct v4l2_pix_format_mplane *formats;
+	unsigned int num_fmts;
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		num_fmts = ARRAY_SIZE(mpp_dev->fmt_out);
+		formats = mpp_dev->fmt_out;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		num_fmts = ARRAY_SIZE(mpp_dev->fmt_cap);
+		formats = mpp_dev->fmt_cap;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (f->index >= num_fmts)
+		return -EINVAL;
+
+	if (formats[f->index].pixelformat == 0)
+		return -EINVAL;
+
+	f->pixelformat = formats[f->index].pixelformat;
+
+	return 0;
+}
+
+static int mpp_try_fmt_mplane(struct file *filp, void *priv,
+			      struct v4l2_format *f)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	const struct v4l2_pix_format_mplane *formats;
+	unsigned int num_fmts;
+	int i;
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		num_fmts = ARRAY_SIZE(mpp_dev->fmt_out);
+		formats = mpp_dev->fmt_out;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		num_fmts = ARRAY_SIZE(mpp_dev->fmt_cap);
+		formats = mpp_dev->fmt_cap;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_fmts; i++) {
+		if (f->fmt.pix_mp.pixelformat == formats[i].pixelformat)
+			return 0;
+	}
+
+	return -EINVAL;
+}
+
+const struct v4l2_ioctl_ops mpp_ioctl_ops_templ = {
+	.vidioc_querycap = mpp_m2m_querycap,
+#if 0
+	.vidioc_try_fmt_vid_cap = mpp_try_fmt_cap,
+	.vidioc_try_fmt_vid_out = mpp_try_fmt_out,
+	.vidioc_s_fmt_vid_out = mpp_s_fmt_out,
+	.vidioc_s_fmt_vid_cap = mpp_s_fmt_cap,
+#endif
+	.vidioc_try_fmt_vid_out_mplane = mpp_try_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane = mpp_try_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane = mpp_g_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane = mpp_g_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane = mpp_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_cap_mplane = mpp_enum_fmt_mplane,
+
+	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
+	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
+
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+
+	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
+};
+EXPORT_SYMBOL(mpp_ioctl_ops_templ);
+
+static int mpp_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
+			   unsigned int *num_planes, unsigned int sizes[],
+			   struct device *alloc_devs[])
+{
+	struct mpp_session *session = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format_mplane *pixfmt;
+	int i;
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		pixfmt = &session->fmt_out;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		pixfmt = &session->fmt_cap;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (*num_planes) {
+		if (*num_planes != pixfmt->num_planes)
+			return -EINVAL;
+		for (i = 0; i < pixfmt->num_planes; ++i)
+			if (sizes[i] < pixfmt->plane_fmt[i].sizeimage)
+				return -EINVAL;
+
+		return 0;
+	}
+
+	*num_planes = pixfmt->num_planes;
+	for (i = 0; i < pixfmt->num_planes; i++)
+		sizes[i] = pixfmt->plane_fmt[i].sizeimage;
+
+	return 0;
+}
+
+/* I am sure what is used for */
+static int mpp_buf_out_validata(struct vb2_buffer *vb)
+{
+	return 0;
+}
+
+static int mpp_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct mpp_session *session = vb2_get_drv_priv(vq);
+
+	if (V4L2_TYPE_IS_OUTPUT(vq->type))
+		session->sequence_out = 0;
+	else
+		session->sequence_cap = 0;
+
+	return 0;
+}
+
+static void mpp_stop_streaming(struct vb2_queue *vq)
+{
+	struct mpp_session *session = vb2_get_drv_priv(vq);
+
+	for (;;) {
+		struct vb2_v4l2_buffer *vbuf;
+
+		if (V4L2_TYPE_IS_OUTPUT(vq->type))
+			vbuf = v4l2_m2m_src_buf_remove(session->fh.m2m_ctx);
+		else
+			vbuf = v4l2_m2m_dst_buf_remove(session->fh.m2m_ctx);
+
+		if (!vbuf)
+			break;
+
+		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
+					   &session->ctrl_handler);
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+	}
+}
+
+static void mpp_buf_queue(struct vb2_buffer *vb) {
+	struct mpp_session *session = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	/* TODO: may alloc registers table here */
+	v4l2_m2m_buf_queue(session->fh.m2m_ctx, vbuf);
+}
+
+static void mpp_buf_request_complete(struct vb2_buffer *vb) {
+	struct mpp_session *session = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &session->ctrl_handler);
+}
+
+static const struct vb2_ops mpp_queue_ops = {
+	.queue_setup = mpp_queue_setup,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	/*
+	 * TODO: may write back feedback to userspace .buf_finish for encoder,
+	 * not the slice header which the job of the userspace
+	 */
+	/* TODO: fill the INPUT buffer with device configure at .buf_prepare */
+	.buf_out_validate = mpp_buf_out_validata,
+	.start_streaming = mpp_start_streaming,
+	.stop_streaming = mpp_stop_streaming,
+	.buf_queue = mpp_buf_queue,
+	.buf_request_complete = mpp_buf_request_complete,
+};
+
+static int rockchip_mpp_queue_init(void *priv, struct vb2_queue *src_vq,
+				   struct vb2_queue *dst_vq)
+{
+	struct mpp_session *session = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->drv_priv = session;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
+			    DMA_ATTR_NO_KERNEL_MAPPING;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->min_buffers_needed = 1;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &session->mpp_dev->dev_lock;
+	src_vq->ops = &mpp_queue_ops;
+	src_vq->dev = session->mpp_dev->v4l2_dev.dev;
+	src_vq->supports_requests = true;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->min_buffers_needed = 1;
+	dst_vq->drv_priv = session;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &session->mpp_dev->dev_lock;
+	dst_vq->ops = &mpp_queue_ops;
+	dst_vq->dev = session->mpp_dev->v4l2_dev.dev;
+
+	ret = vb2_queue_init(dst_vq);
+
+	return ret;
+}
+
+void *rockchip_mpp_alloc_session(struct rockchip_mpp_dev *mpp_dev,
+				 struct video_device *vdev)
+{
+	struct mpp_session *session = NULL;
+	int error = 0;
+
+	mpp_debug_enter();
+
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
+	if (!session)
+		return ERR_PTR(-ENOMEM);
+
+	session->pid = current->pid;
+	session->mpp_dev = mpp_dev;
+	mutex_init(&session->lock);
+	INIT_LIST_HEAD(&session->pending);
+	init_waitqueue_head(&session->wait);
+	error = kfifo_alloc(&session->done_fifo, MPP_SESSION_MAX_DONE_TASK,
+			    GFP_KERNEL);
+	if (error < 0)
+		goto fail;
+
+	atomic_set(&session->task_running, 0);
+	INIT_LIST_HEAD(&session->list_session);
+
+	session->fh.m2m_ctx = v4l2_m2m_ctx_init(mpp_dev->m2m_dev, session,
+						rockchip_mpp_queue_init);
+	if (IS_ERR(session->fh.m2m_ctx)) {
+		error = PTR_ERR(session->fh.m2m_ctx);
+		goto fail;
+	}
+	v4l2_fh_init(&session->fh, vdev);
+	v4l2_fh_add(&session->fh);
+
+	mpp_debug_leave();
+
+	return session;
+
+fail:
+	kfree(session);
+	return ERR_PTR(error);
+}
+EXPORT_SYMBOL(rockchip_mpp_alloc_session);
+
+int rockchip_mpp_dev_release(struct file *filp)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+
+	mpp_debug_enter();
+	if (!session)
+		return -EINVAL;
+
+	/* TODO: is it necessary for v4l2? */
+#if 0
+	int task_running;
+	task_running = atomic_read(&session->task_running);
+	if (task_running) {
+		pr_err("session %d still has %d task running when closing\n",
+		       session->pid, task_running);
+		msleep(50);
+	}
+	wake_up(&session->wait);
+#endif
+
+	v4l2_m2m_ctx_release(session->fh.m2m_ctx);
+	v4l2_fh_del(&session->fh);
+	v4l2_fh_exit(&session->fh);
+	v4l2_ctrl_handler_free(&session->ctrl_handler);
+	mpp_dev_session_clear(mpp_dev, session);
+
+	kfifo_free(&session->done_fifo);
+	filp->private_data = NULL;
+
+	mpp_dev_power_off(mpp_dev);
+	kfree(session);
+
+	dev_dbg(mpp_dev->dev, "closed\n");
+	mpp_debug_leave();
+	return 0;
+}
+EXPORT_SYMBOL(rockchip_mpp_dev_release);
+
+void *rockchip_mpp_get_cur_ctrl(struct mpp_session *session, u32 id)
+{
+	struct v4l2_ctrl *ctrl;
+
+	ctrl = v4l2_ctrl_find(&session->ctrl_handler, id);
+	return ctrl ? ctrl->p_cur.p : NULL;
+}
+EXPORT_SYMBOL(rockchip_mpp_get_cur_ctrl);
+
+int rockchip_mpp_get_ref_idx(struct vb2_queue *queue,
+			     struct vb2_buffer *vb2_buf, u64 timestamp)
+{
+	/* FIXME: TODO: the timestamp is not copied yet before copy_data */
+	if (vb2_buf->timestamp == timestamp)
+		return vb2_buf->index;
+	else
+		return vb2_find_timestamp(queue, timestamp, 0);
+}
+EXPORT_SYMBOL(rockchip_mpp_get_ref_idx);
+
+dma_addr_t rockchip_mpp_find_addr(struct vb2_queue *queue,
+				  struct vb2_buffer *vb2_buf, u64 timestamp)
+{
+	int idx = -1;
+
+	idx = rockchip_mpp_get_ref_idx(queue, vb2_buf, timestamp);
+	if (idx < 0)
+		return 0;
+
+	return vb2_dma_contig_plane_dma_addr(queue->bufs[idx], 0);
+}
+EXPORT_SYMBOL(rockchip_mpp_find_addr);
+
+#if 0
+const struct v4l2_file_operations mpp_v4l2_fops_templ = {
+	.release = mpp_dev_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+};
+#endif
+
+static int __init mpp_device_init(void)
+{
+	mpp_device_class = class_create(THIS_MODULE, "mpp_device");
+	if (PTR_ERR_OR_ZERO(mpp_device_class))
+		return PTR_ERR(mpp_device_class);
+
+	return 0;
+}
+
+static void __exit mpp_device_exit(void)
+{
+	class_destroy(mpp_device_class);
+}
+
+module_init(mpp_device_init);
+module_exit(mpp_device_exit);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_common.h b/drivers/staging/rockchip-mpp/mpp_dev_common.h
new file mode 100644
index 000000000000..36770af53a95
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_common.h
@@ -0,0 +1,212 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2016 - 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _ROCKCHIP_MPP_DEV_COMMON_H_
+#define _ROCKCHIP_MPP_DEV_COMMON_H_
+
+#include <linux/dma-buf.h>
+#include <linux/kfifo.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <linux/reset.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "mpp_service.h"
+
+#define MPP_MODULE_NAME			"rk-mpp"
+
+extern const struct v4l2_ioctl_ops mpp_ioctl_ops_templ;
+
+struct mpp_dev_variant {
+	u32 reg_len;
+	const char *node_name;
+	u32 version_bit;
+	int vfd_func;
+};
+
+/* Definition in mpp service file */
+struct mpp_service;
+
+struct rockchip_mpp_dev {
+	struct device *dev;
+
+	const struct mpp_dev_variant *variant;
+	struct mpp_dev_ops *ops;
+	struct v4l2_pix_format_mplane fmt_out[16];
+	struct v4l2_pix_format_mplane fmt_cap[16];
+
+	void __iomem *reg_base;
+	int irq;
+	struct workqueue_struct *irq_workq;
+	struct iommu_domain *domain;
+
+	rwlock_t resource_rwlock;
+	atomic_t reset_request;
+
+	struct v4l2_device v4l2_dev;
+	struct v4l2_m2m_dev *m2m_dev;
+	struct media_device mdev;
+	struct video_device *vfd;
+	struct mutex dev_lock;
+
+	/* MPP Service */
+	struct mpp_service_node *srv;
+};
+
+struct mpp_task;
+
+struct mpp_session {
+	/* the session related device private data */
+	struct rockchip_mpp_dev *mpp_dev;
+	/* a linked list of data so we can access them for debugging */
+	struct list_head list_session;
+
+	/* session tasks list lock */
+	struct mutex lock;
+	struct list_head pending;
+
+	DECLARE_KFIFO_PTR(done_fifo, struct mpp_task *);
+
+	wait_queue_head_t wait;
+	pid_t pid;
+	atomic_t task_running;
+
+	struct v4l2_fh fh;
+	u32 sequence_cap;
+	u32 sequence_out;
+
+	struct v4l2_pix_format_mplane fmt_out;
+	struct v4l2_pix_format_mplane fmt_cap;
+	
+	struct v4l2_ctrl_handler ctrl_handler;
+	/* TODO: FIXME: slower than helper function ? */
+	struct v4l2_ctrl **ctrls;
+};
+
+/* The context for the a task */
+struct mpp_task {
+	/* context belong to */
+	struct mpp_session *session;
+
+	/* link to service session */
+	struct list_head session_link;
+	/* link to service list */
+	struct list_head service_link;
+	struct work_struct work;
+
+	/* record context running start time */
+	struct timespec64 start;
+};
+
+/*
+ * struct mpp_dev_ops - context specific operations for a device
+ * The task part
+ * @alloc_task
+ * @prepare	Check HW status for determining run next task or not.
+ * @run		Start a single {en,de}coding run. Set registers to hardware.
+ * @finish	Read back processing results and additional data from hardware.
+ * @result	Read status to userspace.
+ * @free_task	Release the resource allocate during init.
+ * The device part
+ * @reset
+ */
+struct mpp_dev_ops {
+	/* size: in bytes, data sent from userspace, length in bytes */
+	void *(*alloc_task)(struct mpp_session *session,
+			    void __user *src, u32 size);
+	int (*prepare)(struct rockchip_mpp_dev *mpp_dev, struct mpp_task *task);
+	int (*run)(struct rockchip_mpp_dev *mpp_dev, struct mpp_task *task);
+	int (*finish)(struct rockchip_mpp_dev *mpp_dev, struct mpp_task *task);
+	int (*result)(struct rockchip_mpp_dev *mpp_dev, struct mpp_task *task,
+		      u32 __user *dst, u32 size);
+	int (*free_task)(struct mpp_session *session,
+			    struct mpp_task *task);
+	/* Hardware only operations */
+	int (*reset)(struct rockchip_mpp_dev *mpp_dev);
+};
+
+struct rockchip_mpp_control {
+	u32 codec;
+	u32 id;
+	u32 elem_size;
+};
+
+void *rockchip_mpp_alloc_session(struct rockchip_mpp_dev *mpp_dev,
+				 struct video_device *vdev);
+int rockchip_mpp_dev_release(struct file *filp);
+
+void *rockchip_mpp_get_cur_ctrl(struct mpp_session *session, u32 id);
+int rockchip_mpp_get_ref_idx(struct vb2_queue *queue,
+			     struct vb2_buffer *vb2_buf, u64 timestamp);
+dma_addr_t rockchip_mpp_find_addr(struct vb2_queue *queue,
+				  struct vb2_buffer *vb2_buf, u64 timestamp);
+
+int mpp_dev_task_init(struct mpp_session *session, struct mpp_task *task);
+void mpp_dev_task_finish(struct mpp_session *session, struct mpp_task *task);
+void mpp_dev_task_finalize(struct mpp_session *session, struct mpp_task *task);
+
+void mpp_dev_power_on(struct rockchip_mpp_dev *mpp);
+void mpp_dev_power_off(struct rockchip_mpp_dev *mpp);
+bool mpp_dev_is_power_on(struct rockchip_mpp_dev *mpp);
+
+void mpp_dump_reg(void __iomem *regs, int count);
+void mpp_dump_reg_mem(u32 *regs, int count);
+
+int mpp_dev_common_probe(struct rockchip_mpp_dev *mpp_dev,
+			 struct platform_device *pdev,
+			 struct mpp_dev_ops *ops);
+int mpp_dev_register_node(struct rockchip_mpp_dev *mpp_dev,
+			  const char *node_name, const void *v4l2_fops,
+			  const void *v4l2_ioctl_ops);
+int mpp_dev_common_remove(struct rockchip_mpp_dev *mpp_dev);
+
+static inline void safe_reset(struct reset_control *rst)
+{
+	if (rst)
+		reset_control_assert(rst);
+}
+
+static inline void safe_unreset(struct reset_control *rst)
+{
+	if (rst)
+		reset_control_deassert(rst);
+}
+
+void mpp_dev_write_seq(struct rockchip_mpp_dev *mpp_dev,
+		       unsigned long offset, void *buffer,
+		       unsigned long count);
+
+void mpp_dev_write(struct rockchip_mpp_dev *mpp, u32 val, u32 reg);
+
+void mpp_dev_read_seq(struct rockchip_mpp_dev *mpp_dev,
+		      unsigned long offset, void *buffer,
+		      unsigned long count);
+
+u32 mpp_dev_read(struct rockchip_mpp_dev *mpp, u32 reg);
+
+void mpp_debug_time_record(struct mpp_task *task);
+void mpp_debug_time_diff(struct mpp_task *task);
+
+void mpp_debug_dump_reg(void __iomem *regs, int count);
+void mpp_debug_dump_reg_mem(u32 *regs, int count);
+
+#endif
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c b/drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c
new file mode 100644
index 000000000000..30a70670e3b7
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c
@@ -0,0 +1,997 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <soc/rockchip/pm_domains.h>
+#include <soc/rockchip/rockchip_sip.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+
+#include <linux/pm_runtime.h>
+
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+#include "rkvdec/hal.h"
+
+#define RKVDEC_DRIVER_NAME		"mpp_rkvdec"
+
+#define RKVDEC_VER_RK3328_BIT		BIT(1)
+#define IOMMU_GET_BUS_ID(x)		(((x) >> 6) & 0x1f)
+#define IOMMU_PAGE_SIZE			SZ_4K
+
+#define RKVDEC_NODE_NAME		"rkvdec"
+#define RK_HEVCDEC_NODE_NAME		"hevc-service"
+
+#define to_rkvdec_task(ctx)		\
+		container_of(ctx, struct rkvdec_task, mpp_task)
+#define to_rkvdec_dev(dev)		\
+		container_of(dev, struct rockchip_rkvdec_dev, mpp_dev)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "bit switch for rkvdec debug information");
+
+enum RKVDEC_STATE {
+	RKVDEC_STATE_NORMAL,
+	RKVDEC_STATE_LT_START,
+	RKVDEC_STATE_LT_RUN,
+};
+
+struct rockchip_rkvdec_dev {
+	struct rockchip_mpp_dev mpp_dev;
+
+	struct reset_control *rst_a;
+	struct reset_control *rst_h;
+	struct reset_control *rst_niu_a;
+	struct reset_control *rst_niu_h;
+	struct reset_control *rst_core;
+	struct reset_control *rst_cabac;
+
+	enum RKVDEC_STATE state;
+
+	unsigned long aux_iova;
+	struct page *aux_page;
+
+	void *current_task;
+};
+
+struct rkvdec_task {
+	struct mpp_task mpp_task;
+
+	u32 reg[ROCKCHIP_RKVDEC_REG_NUM];
+	u32 idx;
+
+	u32 irq_status;
+};
+
+static struct rockchip_mpp_control hevc_controls[] = {
+	{
+	 .codec = V4L2_PIX_FMT_HEVC_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_HEVC_SPS,
+	 .elem_size = sizeof(struct v4l2_ctrl_hevc_sps),
+	},
+	{
+	 .codec = V4L2_PIX_FMT_HEVC_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_HEVC_PPS,
+	 .elem_size = sizeof(struct v4l2_ctrl_hevc_pps),
+	},
+	{
+	 .codec = V4L2_PIX_FMT_HEVC_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS,
+	 .elem_size = sizeof(struct v4l2_ctrl_hevc_slice_params),
+	},
+};
+
+static struct rockchip_mpp_control rkvdec_controls[] = {
+	{
+	 .codec = V4L2_PIX_FMT_HEVC_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_HEVC_SPS,
+	 .elem_size = sizeof(struct v4l2_ctrl_hevc_sps),
+	},
+	{
+	 .codec = V4L2_PIX_FMT_HEVC_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_HEVC_PPS,
+	 .elem_size = sizeof(struct v4l2_ctrl_hevc_pps),
+	},
+	{
+	 .codec = V4L2_PIX_FMT_HEVC_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS,
+	 .elem_size = sizeof(struct v4l2_ctrl_hevc_slice_params),
+	},
+
+};
+
+static const struct v4l2_pix_format_mplane fmt_out_templ[] = {
+	{
+	 .pixelformat = V4L2_PIX_FMT_H264_SLICE,
+	 },
+	{
+	 .pixelformat = V4L2_PIX_FMT_HEVC_SLICE,
+	 },
+};
+
+static const struct v4l2_pix_format_mplane fmt_cap_templ[] = {
+	{
+	 .pixelformat = V4L2_PIX_FMT_NV12M,
+	 },
+	{
+	 .pixelformat = V4L2_PIX_FMT_NV16M,
+	 },
+};
+
+static const struct mpp_dev_variant rkvdec_v1_data = {
+	.reg_len = 76,
+	.node_name = RKVDEC_NODE_NAME,
+	.version_bit = BIT(0),
+};
+
+static const struct mpp_dev_variant rkvdec_v1p_data = {
+	.reg_len = 76,
+	.node_name = RKVDEC_NODE_NAME,
+	.version_bit = RKVDEC_VER_RK3328_BIT,
+};
+
+static const struct mpp_dev_variant rk_hevcdec_data = {
+	.reg_len = 48,
+	.node_name = RK_HEVCDEC_NODE_NAME,
+	.version_bit = BIT(0),
+};
+
+static int rkvdec_open(struct file *filp);
+
+static const struct v4l2_file_operations rkvdec_fops = {
+	.open = rkvdec_open,
+	.release = rockchip_mpp_dev_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+};
+
+static struct v4l2_ioctl_ops rkvdec_ioctl_ops = { 0, };
+
+static void *rockchip_rkvdec_get_drv_data(struct platform_device *pdev);
+
+static int rkvdec_s_fmt_vid_out_mplane(struct file *filp, void *priv,
+				       struct v4l2_format *f)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+	int sizes = 0;
+	int i;
+
+	/* TODO: We can change width and height at streaming on */
+	vq = v4l2_m2m_get_vq(session->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+	if (!pix_mp->num_planes)
+		pix_mp->num_planes = 1;
+
+	for (i = 0; i < pix_mp->num_planes; i++) {
+		sizes += pix_mp->plane_fmt[i].sizeimage;
+	}
+	/* strm_len is 24 bits */
+	if (sizes >= SZ_16M - SZ_1K)
+		return -EINVAL;
+
+	/* FIXME: For those slice header data, put it in a better place */
+	pix_mp->plane_fmt[pix_mp->num_planes - 1].sizeimage += SZ_4M;
+
+	session->fmt_out = *pix_mp;
+
+	/* Copy the pixel format information from OUTPUT to CAPUTRE */
+	session->fmt_cap.pixelformat = V4L2_PIX_FMT_NV12M;
+	session->fmt_cap.width = pix_mp->width;
+	session->fmt_cap.height = pix_mp->height;
+	session->fmt_cap.colorspace = pix_mp->colorspace;
+	session->fmt_cap.ycbcr_enc = pix_mp->ycbcr_enc;
+	session->fmt_cap.xfer_func = pix_mp->xfer_func;
+	session->fmt_cap.quantization = pix_mp->quantization;
+
+	return 0;
+}
+
+static int rkvdec_s_fmt_vid_cap_mplane(struct file *filp, void *priv,
+				       struct v4l2_format *f)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(session->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+	switch (pix_mp->pixelformat) {
+	case V4L2_PIX_FMT_NV12M:
+		/* TODO: adaptive based by cache settings */
+		pix_mp->plane_fmt[0].bytesperline =
+		    ALIGN(pix_mp->width, 256) | 256;
+		pix_mp->plane_fmt[1].bytesperline =
+		    ALIGN(pix_mp->width, 256) | 256;
+#if 0
+		/* TODO: align with 16 for H.264 */
+		pix_mp->plane_fmt[0].sizeimage =
+		    pix_mp->plane_fmt[0].bytesperline * ALIGN(pix_mp->height,
+							      8);
+		/* Additional space for motion vector */
+		pix_mp->plane_fmt[1].sizeimage =
+		    pix_mp->plane_fmt[1].bytesperline * ALIGN(pix_mp->height,
+							      8);
+#else
+		pix_mp->plane_fmt[0].sizeimage =
+		    pix_mp->plane_fmt[0].bytesperline * ALIGN(pix_mp->height,
+							      8);
+		/* Additional space for motion vector */
+		pix_mp->plane_fmt[0].sizeimage *= 2;
+#endif
+		break;
+	case V4L2_PIX_FMT_NV16M:
+		pix_mp->plane_fmt[0].bytesperline =
+		    ALIGN(pix_mp->width, 256) | 256;
+		pix_mp->plane_fmt[1].bytesperline =
+		    ALIGN(pix_mp->width, 256) | 256;
+		pix_mp->plane_fmt[0].sizeimage =
+		    pix_mp->plane_fmt[0].bytesperline * ALIGN(pix_mp->height,
+							      8);
+		/* Additional space for motion vector */
+		pix_mp->plane_fmt[1].sizeimage =
+		    pix_mp->plane_fmt[1].bytesperline * ALIGN(pix_mp->height,
+							      8) * 3 / 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	session->fmt_cap = *pix_mp;
+
+	return 0;
+}
+
+static int rkvdec_setup_ctrls(struct rockchip_mpp_dev *mpp_dev,
+			      struct mpp_session *session)
+{
+	struct v4l2_ctrl_handler *hdl = &session->ctrl_handler;
+	struct v4l2_ctrl *ctrl;
+	unsigned int num_ctrls = ARRAY_SIZE(rkvdec_controls);
+	unsigned int i;
+
+	v4l2_ctrl_handler_init(hdl, num_ctrls);
+	if (hdl->error) {
+		v4l2_err(&mpp_dev->v4l2_dev,
+			 "Failed to initialize control handler\n");
+		return hdl->error;
+	}
+
+	for (i = 0; i < num_ctrls; i++) {
+		struct v4l2_ctrl_config cfg = { };
+
+		cfg.id = rkvdec_controls[i].id;
+		cfg.elem_size = rkvdec_controls[i].elem_size;
+
+		ctrl = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
+		if (hdl->error) {
+			v4l2_err(&mpp_dev->v4l2_dev,
+				 "Failed to create new custom %d control\n",
+				 cfg.id);
+			goto fail;
+		}
+	}
+
+	session->fh.ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
+
+	return 0;
+fail:
+	v4l2_ctrl_handler_free(hdl);
+	return hdl->error;
+}
+
+static int rkvdec_open(struct file *filp)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	struct video_device *vdev = video_devdata(filp);
+	struct mpp_session *session = NULL;
+	/* TODO: install ctrl based on register report */
+	int error = 0;
+
+	mpp_debug_enter();
+
+	session = rockchip_mpp_alloc_session(mpp_dev, vdev);
+	if (IS_ERR_OR_NULL(session))
+		return PTR_ERR(session);
+
+	error = rkvdec_setup_ctrls(mpp_dev, session);
+	if (error) {
+		kfree(session);
+		return error;
+	}
+
+	filp->private_data = &session->fh;
+	pm_runtime_get_sync(mpp_dev->dev);
+
+	mpp_debug_leave();
+	return 0;
+}
+
+#if 0
+/*
+ * NOTE: rkvdec/rkhevc put scaling list address in pps buffer hardware will read
+ * it by pps id in video stream data.
+ *
+ * So we need to translate the address in iommu case. The address data is also
+ * 10bit fd + 22bit offset mode.
+ * Because userspace decoder do not give the pps id in the register file sets
+ * kernel driver need to translate each scaling list address in pps buffer which
+ * means 256 pps for H.264, 64 pps for H.265.
+ *
+ * In order to optimize the performance kernel driver ask userspace decoder to
+ * set all scaling list address in pps buffer to the same one which will be used
+ * on current decoding task. Then kernel driver can only translate the first
+ * address then copy it all pps buffer.
+ */
+static int fill_scaling_list_pps(struct rkvdec_task *task, int fd, int offset,
+				 int count, int pps_info_size,
+				 int sub_addr_offset)
+{
+	struct device *dev = NULL;
+	struct dma_buf *dmabuf = NULL;
+	void *vaddr = NULL;
+	u8 *pps = NULL;
+	u32 base = sub_addr_offset;
+	u32 scaling_fd = 0;
+	u32 scaling_offset;
+	int ret = 0;
+
+	/* FIXME: find a better way, it only be used for debugging purpose */
+	dev = task->mpp_task.session->mpp_dev->dev;
+	if (!dev)
+		return -EINVAL;
+
+	dmabuf = dma_buf_get(fd);
+	if (IS_ERR_OR_NULL(dmabuf)) {
+		dev_err(dev, "invliad pps buffer\n");
+		return -ENOENT;
+	}
+
+	ret = dma_buf_begin_cpu_access(dmabuf, DMA_FROM_DEVICE);
+	if (ret) {
+		dev_err(dev, "can't access the pps buffer\n");
+		goto done;
+	}
+
+	vaddr = dma_buf_vmap(dmabuf);
+	if (!vaddr) {
+		dev_err(dev, "can't access the pps buffer\n");
+		ret = -EIO;
+		goto done;
+	}
+	pps = vaddr + offset;
+
+	memcpy(&scaling_offset, pps + base, sizeof(scaling_offset));
+	scaling_offset = le32_to_cpu(scaling_offset);
+
+	scaling_fd = scaling_offset & 0x3ff;
+	scaling_offset = scaling_offset >> 10;
+
+	if (scaling_fd > 0) {
+		struct mpp_mem_region *mem_region = NULL;
+		dma_addr_t tmp = 0;
+		int i = 0;
+
+		mem_region = mpp_dev_task_attach_fd(&task->mpp_task,
+						    scaling_fd);
+		if (IS_ERR(mem_region)) {
+			ret = PTR_ERR(mem_region);
+			goto done;
+		}
+
+		tmp = mem_region->iova;
+		tmp += scaling_offset;
+		tmp = cpu_to_le32(tmp);
+		mpp_debug(DEBUG_PPS_FILL,
+			  "pps at %p, scaling fd: %3d => %pad + offset %10d\n",
+			  pps, scaling_fd, &mem_region->iova, offset);
+
+		/* Fill the scaling list address in each pps entries */
+		for (i = 0; i < count; i++, base += pps_info_size)
+			memcpy(pps + base, &tmp, sizeof(tmp));
+	}
+
+done:
+	dma_buf_vunmap(dmabuf, vaddr);
+	dma_buf_end_cpu_access(dmabuf, DMA_FROM_DEVICE);
+	dma_buf_put(dmabuf);
+
+	return ret;
+}
+#endif
+
+static void *rockchip_mpp_rkvdec_alloc_task(struct mpp_session *session,
+					    void __user * src, u32 size)
+{
+	struct rkvdec_task *task = NULL;
+	struct vb2_v4l2_buffer *src_buf;
+	u32 fmt = 0;
+	int err = -EFAULT;
+
+	mpp_debug_enter();
+
+	task = kzalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return NULL;
+
+	mpp_dev_task_init(session, &task->mpp_task);
+
+	src_buf = v4l2_m2m_next_src_buf(session->fh.m2m_ctx);
+	v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
+				&session->ctrl_handler);
+
+	fmt = session->fmt_out.pixelformat;
+	switch (fmt) {
+	case V4L2_PIX_FMT_HEVC_SLICE:
+		err = rkvdec_hevc_gen_reg(session, task->reg, src_buf);
+		break;
+	default:
+		goto fail;
+	}
+
+	if (err)
+		goto fail;
+
+	v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
+				   &session->ctrl_handler);
+
+#if 0
+	if (fmt == RKVDEC_FMT_VP9D) {
+		struct mpp_mem_region *mem_region = NULL;
+		dma_addr_t iova = 0;
+		u32 offset = task->reg[RKVDEC_REG_VP9_REFCOLMV_BASE_INDEX];
+		int fd = task->reg[RKVDEC_REG_VP9_REFCOLMV_BASE_INDEX] & 0x3ff;
+
+		offset = offset >> 10 << 4;
+		mem_region = mpp_dev_task_attach_fd(&task->mpp_task, fd);
+		if (IS_ERR(mem_region)) {
+			err = PTR_ERR(mem_region);
+			goto fail;
+		}
+
+		iova = mem_region->iova;
+		task->reg[RKVDEC_REG_VP9_REFCOLMV_BASE_INDEX] = iova + offset;
+	}
+#endif
+
+#if 0
+	pps_fd = task->reg[RKVDEC_REG_PPS_BASE_INDEX] & 0x3ff;
+	pps_offset = task->reg[RKVDEC_REG_PPS_BASE_INDEX] >> 10;
+	if (pps_fd > 0) {
+		int pps_info_offset;
+		int pps_info_count;
+		int pps_info_size;
+		int scaling_list_addr_offset;
+
+		switch (fmt) {
+		case RKVDEC_FMT_H264D:
+			pps_info_offset = pps_offset;
+			pps_info_count = 256;
+			pps_info_size = 32;
+			scaling_list_addr_offset = 23;
+			break;
+		case RKVDEC_FMT_H265D:
+			pps_info_offset = pps_offset;
+			pps_info_count = 64;
+			pps_info_size = 80;
+			scaling_list_addr_offset = 74;
+			break;
+		default:
+			pps_info_offset = 0;
+			pps_info_count = 0;
+			pps_info_size = 0;
+			scaling_list_addr_offset = 0;
+			break;
+		}
+
+		mpp_debug(DEBUG_PPS_FILL, "scaling list filling parameter:\n");
+		mpp_debug(DEBUG_PPS_FILL,
+			  "pps_info_offset %d\n", pps_info_offset);
+		mpp_debug(DEBUG_PPS_FILL,
+			  "pps_info_count  %d\n", pps_info_count);
+		mpp_debug(DEBUG_PPS_FILL,
+			  "pps_info_size   %d\n", pps_info_size);
+		mpp_debug(DEBUG_PPS_FILL,
+			  "scaling_list_addr_offset %d\n",
+			  scaling_list_addr_offset);
+
+		if (pps_info_count) {
+			err = fill_scaling_list_pps(task, pps_fd,
+						    pps_info_offset,
+						    pps_info_count,
+						    pps_info_size,
+						    scaling_list_addr_offset);
+			if (err) {
+				mpp_err("fill pps failed\n");
+				goto fail;
+			}
+		}
+	}
+#endif
+
+	mpp_debug_leave();
+
+	return &task->mpp_task;
+
+fail:
+	kfree(task);
+	return ERR_PTR(err);
+}
+
+static int rockchip_mpp_rkvdec_prepare(struct rockchip_mpp_dev *mpp_dev,
+				       struct mpp_task *task)
+{
+	struct rockchip_rkvdec_dev *dec_dev = to_rkvdec_dev(mpp_dev);
+
+	if (dec_dev->state == RKVDEC_STATE_NORMAL)
+		return -EINVAL;
+	/*
+	 * Don't do soft reset before running or you will meet 0x00408322
+	 * if you will decode a HEVC stream. Different error for the AVC.
+	 */
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdec_run(struct rockchip_mpp_dev *mpp_dev,
+				   struct mpp_task *mpp_task)
+{
+	struct rockchip_rkvdec_dev *dec_dev = NULL;
+	struct rkvdec_task *task = NULL;
+	u32 reg = 0;
+
+	mpp_debug_enter();
+
+	dec_dev = to_rkvdec_dev(mpp_dev);
+	task = to_rkvdec_task(mpp_task);
+
+	switch (dec_dev->state) {
+	case RKVDEC_STATE_NORMAL:
+		/* FIXME: spin lock here */
+		dec_dev->current_task = task;
+
+		reg = RKVDEC_CACHE_PERMIT_CACHEABLE_ACCESS
+		    | RKVDEC_CACHE_PERMIT_READ_ALLOCATE;
+		if (!(debug & DEBUG_CACHE_32B))
+			reg |= RKVDEC_CACHE_LINE_SIZE_64_BYTES;
+
+		mpp_dev_write(mpp_dev, RKVDEC_REG_CACHE_ENABLE(0), reg);
+		mpp_dev_write(mpp_dev, RKVDEC_REG_CACHE_ENABLE(1), reg);
+
+		mpp_dev_write_seq(mpp_dev, RKVDEC_REG_SYS_CTRL,
+				  &task->reg[RKVDEC_REG_SYS_CTRL_INDEX],
+				  mpp_dev->variant->reg_len
+				  - RKVDEC_REG_SYS_CTRL_INDEX);
+
+		/* Flush the register before the start the device */
+		wmb();
+		mpp_dev_write(mpp_dev, RKVDEC_REG_DEC_INT_EN,
+			      task->reg[RKVDEC_REG_DEC_INT_EN_INDEX]
+			      | RKVDEC_DEC_START);
+		break;
+	default:
+		break;
+	}
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdec_finish(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task)
+{
+	struct rockchip_rkvdec_dev *dec_dev = to_rkvdec_dev(mpp_dev);
+	struct rkvdec_task *task = to_rkvdec_task(mpp_task);
+
+	mpp_debug_enter();
+
+	switch (dec_dev->state) {
+	case RKVDEC_STATE_NORMAL:{
+			mpp_dev_read_seq(mpp_dev, RKVDEC_REG_SYS_CTRL,
+					 &task->reg[RKVDEC_REG_SYS_CTRL_INDEX],
+					 mpp_dev->variant->reg_len
+					 - RKVDEC_REG_SYS_CTRL_INDEX);
+			task->reg[RKVDEC_REG_DEC_INT_EN_INDEX] =
+			    task->irq_status;
+		}
+		break;
+	default:
+		break;
+	}
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdec_result(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task,
+				      u32 __user * dst, u32 size)
+{
+	return 0;
+}
+
+static int rockchip_mpp_rkvdec_free_task(struct mpp_session *session,
+					 struct mpp_task *mpp_task)
+{
+	struct rkvdec_task *task = to_rkvdec_task(mpp_task);
+
+	mpp_dev_task_finalize(session, mpp_task);
+	kfree(task);
+
+	return 0;
+}
+
+static irqreturn_t mpp_rkvdec_isr(int irq, void *dev_id)
+{
+	struct rockchip_rkvdec_dev *dec_dev = dev_id;
+	struct rockchip_mpp_dev *mpp_dev = &dec_dev->mpp_dev;
+	struct rkvdec_task *task = NULL;
+	struct mpp_task *mpp_task = NULL;
+	u32 irq_status;
+	u32 err_mask;
+
+	irq_status = mpp_dev_read(mpp_dev, RKVDEC_REG_DEC_INT_EN);
+	if (!(irq_status & RKVDEC_DEC_INT_RAW))
+		return IRQ_NONE;
+
+	mpp_dev_write(mpp_dev, RKVDEC_REG_DEC_INT_EN, RKVDEC_CLOCK_GATE_EN);
+	/* FIXME use a spin lock here */
+	task = (struct rkvdec_task *)dec_dev->current_task;
+	if (!task) {
+		dev_err(dec_dev->mpp_dev.dev, "no current task\n");
+		return IRQ_HANDLED;
+	}
+	mpp_debug_time_diff(&task->mpp_task);
+
+	task->irq_status = irq_status;
+	switch (dec_dev->state) {
+	case RKVDEC_STATE_NORMAL:
+		mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n",
+			  task->irq_status);
+
+		err_mask = RKVDEC_INT_BUF_EMPTY
+		    | RKVDEC_INT_BUS_ERROR
+		    | RKVDEC_INT_COLMV_REF_ERROR
+		    | RKVDEC_INT_STRM_ERROR | RKVDEC_INT_TIMEOUT;
+
+		if (err_mask & task->irq_status)
+			atomic_set(&mpp_dev->reset_request, 1);
+
+		mpp_task = &task->mpp_task;
+		mpp_dev_task_finish(mpp_task->session, mpp_task);
+
+		mpp_debug_leave();
+		return IRQ_HANDLED;
+	default:
+		goto fail;
+	}
+fail:
+	return IRQ_HANDLED;
+}
+
+static int rockchip_mpp_rkvdec_assign_reset(struct rockchip_rkvdec_dev *dec_dev)
+{
+	struct rockchip_mpp_dev *mpp_dev = &dec_dev->mpp_dev;
+
+	dec_dev->rst_a = devm_reset_control_get_shared(mpp_dev->dev, "video_a");
+	dec_dev->rst_h = devm_reset_control_get_shared(mpp_dev->dev, "video_h");
+	/* The reset controller below are not shared with VPU */
+	dec_dev->rst_niu_a = devm_reset_control_get(mpp_dev->dev, "niu_a");
+	dec_dev->rst_niu_h = devm_reset_control_get(mpp_dev->dev, "niu_h");
+	dec_dev->rst_core = devm_reset_control_get(mpp_dev->dev, "video_core");
+	dec_dev->rst_cabac = devm_reset_control_get(mpp_dev->dev,
+						    "video_cabac");
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_a)) {
+		mpp_err("No aclk reset resource define\n");
+		dec_dev->rst_a = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_h)) {
+		mpp_err("No hclk reset resource define\n");
+		dec_dev->rst_h = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_niu_a)) {
+		mpp_err("No axi niu reset resource define\n");
+		dec_dev->rst_niu_a = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_niu_h)) {
+		mpp_err("No ahb niu reset resource define\n");
+		dec_dev->rst_niu_h = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_core)) {
+		mpp_err("No core reset resource define\n");
+		dec_dev->rst_core = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_cabac)) {
+		mpp_err("No cabac reset resource define\n");
+		dec_dev->rst_cabac = NULL;
+	}
+
+	safe_unreset(dec_dev->rst_a);
+	safe_unreset(dec_dev->rst_h);
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdec_reset(struct rockchip_mpp_dev *mpp_dev)
+{
+	struct rockchip_rkvdec_dev *dec = to_rkvdec_dev(mpp_dev);
+
+	if (dec->rst_a && dec->rst_h) {
+		mpp_debug(DEBUG_RESET, "reset in\n");
+		rockchip_pmu_idle_request(mpp_dev->dev, true);
+
+		safe_reset(dec->rst_niu_a);
+		safe_reset(dec->rst_niu_h);
+		safe_reset(dec->rst_a);
+		safe_reset(dec->rst_h);
+		safe_reset(dec->rst_core);
+		safe_reset(dec->rst_cabac);
+		udelay(5);
+		safe_unreset(dec->rst_niu_h);
+		safe_unreset(dec->rst_niu_a);
+		safe_unreset(dec->rst_a);
+		safe_unreset(dec->rst_h);
+		safe_unreset(dec->rst_core);
+		safe_unreset(dec->rst_cabac);
+
+		rockchip_pmu_idle_request(mpp_dev->dev, false);
+
+		mpp_dev_write(mpp_dev, RKVDEC_REG_DEC_INT_EN, 0);
+		dec->current_task = NULL;
+		mpp_debug(DEBUG_RESET, "reset out\n");
+	}
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdec_sip_reset(struct rockchip_mpp_dev *mpp_dev)
+{
+/* The reset flow in arm trustzone firmware */
+#if CONFIG_ROCKCHIP_SIP
+	sip_smc_vpu_reset(0, 0, 0);
+#else
+	return rockchip_mpp_rkvdec_reset(mpp_dev);
+#endif
+	return 0;
+}
+
+#if 0
+static int rkvdec_rk3328_iommu_hdl(struct iommu_domain *iommu,
+				   struct device *iommu_dev, unsigned long iova,
+				   int status, void *arg)
+{
+	struct device *dev = (struct device *)arg;
+	struct platform_device *pdev = NULL;
+	struct rockchip_rkvdec_dev *dec_dev = NULL;
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+
+	int ret = -EIO;
+
+	pdev = container_of(dev, struct platform_device, dev);
+	if (!pdev) {
+		dev_err(dev, "invalid platform_device\n");
+		ret = -ENXIO;
+		goto done;
+	}
+
+	dec_dev = platform_get_drvdata(pdev);
+	if (!dec_dev) {
+		dev_err(dev, "invalid device instance\n");
+		ret = -ENXIO;
+		goto done;
+	}
+	mpp_dev = &dec_dev->mpp_dev;
+
+	if (IOMMU_GET_BUS_ID(status) == 2) {
+		unsigned long page_iova = 0;
+
+		/* avoid another page fault occur after page fault */
+		if (dec_dev->aux_iova != 0)
+			iommu_unmap(mpp_dev->iommu_info->domain,
+				    dec_dev->aux_iova, IOMMU_PAGE_SIZE);
+
+		page_iova = round_down(iova, IOMMU_PAGE_SIZE);
+		ret = iommu_map(mpp_dev->iommu_info->domain, page_iova,
+				page_to_phys(dec_dev->aux_page),
+				IOMMU_PAGE_SIZE, DMA_FROM_DEVICE);
+		if (!ret)
+			dec_dev->aux_iova = page_iova;
+	}
+
+done:
+	return ret;
+}
+#endif
+
+static struct mpp_dev_ops rkvdec_ops = {
+	.alloc_task = rockchip_mpp_rkvdec_alloc_task,
+	.prepare = rockchip_mpp_rkvdec_prepare,
+	.run = rockchip_mpp_rkvdec_run,
+	.finish = rockchip_mpp_rkvdec_finish,
+	.result = rockchip_mpp_rkvdec_result,
+	.free_task = rockchip_mpp_rkvdec_free_task,
+	.reset = rockchip_mpp_rkvdec_reset,
+};
+
+#if 0
+static struct mpp_dev_ops rkvdec_rk3328_ops = {
+	.alloc_task = rockchip_mpp_rkvdec_alloc_task,
+	.prepare = rockchip_mpp_rkvdec_prepare,
+	.run = rockchip_mpp_rkvdec_run,
+	.finish = rockchip_mpp_rkvdec_finish,
+	.result = rockchip_mpp_rkvdec_result,
+	.free_task = rockchip_mpp_rkvdec_free_task,
+	.reset = rockchip_mpp_rkvdec_sip_reset,
+};
+#endif
+
+static int rockchip_mpp_rkvdec_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct rockchip_rkvdec_dev *dec_dev = NULL;
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+	int ret = 0;
+
+	dec_dev = devm_kzalloc(dev, sizeof(struct rockchip_rkvdec_dev),
+			       GFP_KERNEL);
+	if (!dec_dev)
+		return -ENOMEM;
+
+	mpp_dev = &dec_dev->mpp_dev;
+	mpp_dev->variant = rockchip_rkvdec_get_drv_data(pdev);
+
+#if 0
+	if (mpp_dev->variant->version_bit & RKVDEC_VER_RK3328_BIT) {
+		ret = mpp_dev_common_probe(mpp_dev, pdev, &rkvdec_rk3328_ops);
+
+		dec_dev->aux_page = alloc_page(GFP_KERNEL);
+		if (!dec_dev->aux_page) {
+			dev_err(dev,
+				"can't allocate a page for auxiliary usage\n");
+			return ret;
+		}
+		dec_dev->aux_iova = 0;
+
+		iommu_set_fault_handler(mpp_dev->iommu_info->domain,
+					rkvdec_rk3328_iommu_hdl, dev);
+	} else {
+		ret = mpp_dev_common_probe(mpp_dev, pdev, &rkvdec_ops);
+	}
+#else
+	ret = mpp_dev_common_probe(mpp_dev, pdev, &rkvdec_ops);
+#endif
+	if (ret)
+		return ret;
+
+	ret = devm_request_threaded_irq(dev, mpp_dev->irq, NULL, mpp_rkvdec_isr,
+					IRQF_SHARED | IRQF_ONESHOT,
+					dev_name(dev), dec_dev);
+	if (ret) {
+		dev_err(dev, "register interrupter runtime failed\n");
+		return ret;
+	}
+
+	rockchip_mpp_rkvdec_assign_reset(dec_dev);
+	dec_dev->state = RKVDEC_STATE_NORMAL;
+
+	rkvdec_ioctl_ops = mpp_ioctl_ops_templ;
+	rkvdec_ioctl_ops.vidioc_s_fmt_vid_out_mplane =
+		rkvdec_s_fmt_vid_out_mplane;
+	rkvdec_ioctl_ops.vidioc_s_fmt_vid_cap_mplane =
+		rkvdec_s_fmt_vid_cap_mplane;
+
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name,
+				    &rkvdec_fops, &rkvdec_ioctl_ops);
+	if (ret)
+		dev_err(dev, "register char device failed: %d\n", ret);
+
+	memcpy(mpp_dev->fmt_out, fmt_out_templ, sizeof(fmt_out_templ));
+	memcpy(mpp_dev->fmt_cap, fmt_cap_templ, sizeof(fmt_cap_templ));
+	dev_info(dev, "probing finish\n");
+
+	platform_set_drvdata(pdev, dec_dev);
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdec_remove(struct platform_device *pdev)
+{
+	struct rockchip_rkvdec_dev *dec_dev = platform_get_drvdata(pdev);
+
+	mpp_dev_common_remove(&dec_dev->mpp_dev);
+
+	return 0;
+}
+
+static const struct of_device_id mpp_rkvdec_dt_match[] = {
+	{.compatible = "rockchip,video-decoder-v1p",.data = &rkvdec_v1p_data},
+	{.compatible = "rockchip,video-decoder-v1",.data = &rkvdec_v1_data},
+	{.compatible = "rockchip,hevc-decoder-v1",.data = &rk_hevcdec_data},
+	{},
+};
+
+static void *rockchip_rkvdec_get_drv_data(struct platform_device *pdev)
+{
+	struct mpp_dev_variant *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(mpp_rkvdec_dt_match, pdev->dev.of_node);
+		if (match)
+			driver_data = (struct mpp_dev_variant *)match->data;
+	}
+	return driver_data;
+}
+
+static struct platform_driver rockchip_rkvdec_driver = {
+	.probe = rockchip_mpp_rkvdec_probe,
+	.remove = rockchip_mpp_rkvdec_remove,
+	.driver = {
+		   .name = RKVDEC_DRIVER_NAME,
+		   .of_match_table = of_match_ptr(mpp_rkvdec_dt_match),
+		   },
+};
+
+static int __init mpp_dev_rkvdec_init(void)
+{
+	int ret = platform_driver_register(&rockchip_rkvdec_driver);
+
+	if (ret) {
+		mpp_err("Platform device register failed (%d).\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit mpp_dev_rkvdec_exit(void)
+{
+	platform_driver_unregister(&rockchip_rkvdec_driver);
+}
+
+module_init(mpp_dev_rkvdec_init);
+module_exit(mpp_dev_rkvdec_exit);
+
+MODULE_DEVICE_TABLE(of, mpp_rkvdec_dt_match);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
new file mode 100644
index 000000000000..ce98aa15025e
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
@@ -0,0 +1,616 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *		Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <soc/rockchip/pm_domains.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+
+#include <linux/pm_runtime.h>
+
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+#include "vdpu2/hal.h"
+
+#define RKVDPU2_DRIVER_NAME		"mpp_vdpu2"
+#define RKVDPU2_NODE_NAME		"vpu-service"
+
+#define to_rkvdpu_task(ctx)		\
+		container_of(ctx, struct rkvdpu_task, mpp_task)
+#define to_rkvdpu_dev(dev)		\
+		container_of(dev, struct rockchip_rkvdpu_dev, mpp_dev)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "bit switch for vdpu2 debug information");
+
+struct rockchip_rkvdpu_dev {
+	struct rockchip_mpp_dev mpp_dev;
+
+	struct reset_control *rst_a;
+	struct reset_control *rst_h;
+
+	void *current_task;
+};
+
+struct rkvdpu_task {
+	struct mpp_task mpp_task;
+
+	u32 reg[ROCKCHIP_VDPU2_REG_NUM];
+	u32 idx;
+
+	u32 strm_base;
+	u32 irq_status;
+};
+
+static struct rockchip_mpp_control vdpu_controls[] = {
+	{
+	 .codec = V4L2_PIX_FMT_MPEG2_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS,
+	 .elem_size = sizeof(struct v4l2_ctrl_mpeg2_slice_params),
+	 },
+	{
+	 .codec = V4L2_PIX_FMT_MPEG2_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION,
+	 .elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization),
+	 },
+};
+
+static struct v4l2_pix_format_mplane fmt_out_templ[] = {
+	{
+	 .pixelformat = V4L2_PIX_FMT_MPEG2_SLICE,
+	 },
+	{.pixelformat = 0},
+};
+
+static struct v4l2_pix_format_mplane fmt_cap_templ[] = {
+	{
+	 .pixelformat = V4L2_PIX_FMT_NV12M,
+	 },
+	{.pixelformat = 0},
+};
+
+static const struct mpp_dev_variant rkvdpu_v2_data = {
+	/* Exclude the register of the Performance counter */
+	.reg_len = 159,
+	.node_name = RKVDPU2_NODE_NAME,
+	.vfd_func = MEDIA_ENT_F_PROC_VIDEO_DECODER,
+};
+
+static int rkvdpu_open(struct file *filp);
+
+static const struct v4l2_file_operations rkvdpu_fops = {
+	.open = rkvdpu_open,
+	.release = rockchip_mpp_dev_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+};
+
+#if 1
+static struct v4l2_ioctl_ops rkvdpu_ioctl_ops = { 0, };
+#endif
+
+static void *rockchip_rkvdpu2_get_drv_data(struct platform_device *pdev);
+
+
+static int rkvdpu_s_fmt_vid_out_mplane(struct file *filp, void *priv,
+				       struct v4l2_format *f)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+	int sizes = 0;
+	int i;
+
+	/* TODO: We can change width and height at streaming on */
+	vq = v4l2_m2m_get_vq(session->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+#if 0
+	ret = rkvdpu_try_fmt_out(filp, priv, f);
+	if (ret)
+		return ret;
+#endif
+	if (!pix_mp->num_planes)
+		pix_mp->num_planes = 1;
+
+	for (i = 0; i < pix_mp->num_planes; i++) {
+		sizes += pix_mp->plane_fmt[i].sizeimage;
+	}
+	/* strm_len is 24 bits */
+	if (sizes >= SZ_16M)
+		return -EINVAL;
+
+	session->fmt_out = *pix_mp;
+
+	/* Copy the pixel format information from OUTPUT to CAPUTRE */
+	session->fmt_cap.pixelformat = V4L2_PIX_FMT_NV12M;
+	session->fmt_cap.width = pix_mp->width;
+	session->fmt_cap.height = pix_mp->height;
+	session->fmt_cap.colorspace = pix_mp->colorspace;
+	session->fmt_cap.ycbcr_enc = pix_mp->ycbcr_enc;
+	session->fmt_cap.xfer_func = pix_mp->xfer_func;
+	session->fmt_cap.quantization = pix_mp->quantization;
+
+	return 0;
+}
+
+static int rkvdpu_s_fmt_vid_cap_mplane(struct file *filp, void *priv,
+				       struct v4l2_format *f)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(session->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+#if 0
+	ret = rkvdpu_try_fmt_cap(filp, priv, f);
+	if (ret)
+		return ret;
+#endif
+	switch (pix_mp->pixelformat) {
+	case V4L2_PIX_FMT_NV12M:
+		pix_mp->plane_fmt[0].bytesperline = ALIGN(pix_mp->width, 16);
+		pix_mp->plane_fmt[1].bytesperline = ALIGN(pix_mp->width, 16);
+		pix_mp->plane_fmt[0].sizeimage = ALIGN(pix_mp->width, 16) *
+		/*
+		 * FIXME: the plane 1 may map to a lower address than plane 0
+		 * before solve this allocator problem, it can pass the test
+		 */
+		    ALIGN(pix_mp->height, 16) * 2;
+		/* Additional space for motion vector */
+		pix_mp->plane_fmt[1].sizeimage = ALIGN(pix_mp->width, 16) *
+		    ALIGN(pix_mp->height, 16);
+		pix_mp->num_planes = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	session->fmt_cap = *pix_mp;
+
+	return 0;
+}
+
+static int vdpu_setup_ctrls(struct rockchip_mpp_dev *mpp_dev,
+			    struct mpp_session *session)
+{
+	struct v4l2_ctrl_handler *hdl = &session->ctrl_handler;
+	struct v4l2_ctrl *ctrl;
+	unsigned int num_ctrls = ARRAY_SIZE(vdpu_controls);
+	unsigned int i;
+
+	v4l2_ctrl_handler_init(hdl, num_ctrls);
+	if (hdl->error) {
+		v4l2_err(&mpp_dev->v4l2_dev,
+			 "Failed to initialize control handler\n");
+		return hdl->error;
+	}
+
+	for (i = 0; i < num_ctrls; i++) {
+		struct v4l2_ctrl_config cfg = { };
+
+		cfg.id = vdpu_controls[i].id;
+		cfg.elem_size = vdpu_controls[i].elem_size;
+
+		ctrl = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
+		if (hdl->error) {
+			v4l2_err(&mpp_dev->v4l2_dev,
+				 "Failed to create new custom %d control\n",
+				 cfg.id);
+			goto fail;
+		}
+	}
+
+	session->fh.ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
+
+	return 0;
+fail:
+	v4l2_ctrl_handler_free(hdl);
+	return hdl->error;
+}
+
+static int rkvdpu_open(struct file *filp)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	struct video_device *vdev = video_devdata(filp);
+	struct mpp_session *session = NULL;
+	/* TODO: install ctrl based on register report */
+	int error = 0;
+
+	mpp_debug_enter();
+
+	session = rockchip_mpp_alloc_session(mpp_dev, vdev);
+	if (IS_ERR_OR_NULL(session))
+		return PTR_ERR(session);
+
+	error = vdpu_setup_ctrls(mpp_dev, session);
+	if (error) {
+		kfree(session);
+		return error;
+	}
+
+	filp->private_data = &session->fh;
+	pm_runtime_get_sync(mpp_dev->dev);
+
+	mpp_debug_leave();
+	return 0;
+}
+
+static void *rockchip_mpp_rkvdpu_alloc_task(struct mpp_session *session,
+					    void __user * src, u32 size)
+{
+	struct rkvdpu_task *task = NULL;
+	struct vb2_v4l2_buffer *src_buf;
+	u32 fmt = 0;
+	int err = -EFAULT;
+
+	mpp_debug_enter();
+
+	task = kzalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return NULL;
+
+	mpp_dev_task_init(session, &task->mpp_task);
+
+	src_buf = v4l2_m2m_next_src_buf(session->fh.m2m_ctx);
+	v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
+				&session->ctrl_handler);
+
+	fmt = session->fmt_out.pixelformat;
+	switch (fmt) {
+	case V4L2_PIX_FMT_MPEG2_SLICE:
+		err = rkvdpu_mpeg2_gen_reg(session, task->reg, src_buf);
+		break;
+	default:
+		goto fail;
+	}
+
+	if (err)
+		goto fail;
+
+	v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
+				   &session->ctrl_handler);
+
+	mpp_debug_leave();
+
+	return &task->mpp_task;
+
+fail:
+	if (unlikely(debug & DEBUG_DUMP_ERR_REG))
+		mpp_debug_dump_reg_mem(task->reg, ROCKCHIP_VDPU2_REG_NUM);
+
+	kfree(task);
+	return ERR_PTR(err);
+}
+
+static int rockchip_mpp_rkvdpu_prepare(struct rockchip_mpp_dev *mpp_dev,
+				       struct mpp_task *mpp_task)
+{
+	struct rkvdpu_task *task = container_of(mpp_task, struct rkvdpu_task,
+						mpp_task);
+
+	return rkvdpu_mpeg2_prepare_buf(mpp_task->session, task->reg);
+}
+
+static int rockchip_mpp_rkvdpu_run(struct rockchip_mpp_dev *mpp_dev,
+				   struct mpp_task *mpp_task)
+{
+	struct rkvdpu_task *task = NULL;
+	struct rockchip_rkvdpu_dev *dec_dev = NULL;
+
+	mpp_debug_enter();
+
+	task = to_rkvdpu_task(mpp_task);
+	dec_dev = to_rkvdpu_dev(mpp_dev);
+
+	/* FIXME: spin lock here */
+	dec_dev->current_task = task;
+	/* NOTE: Only write the decoder part */
+	mpp_dev_write_seq(mpp_dev, RKVDPU2_REG_DEC_CTRL,
+			  &task->reg[RKVDPU2_REG_DEC_CTRL_INDEX],
+			  RKVDPU2_REG_DEC_DEV_CTRL_INDEX
+			  - RKVDPU2_REG_DEC_CTRL_INDEX);
+
+	mpp_dev_write_seq(mpp_dev, RKVDPU2_REG59,
+			  &task->reg[RKVDPU2_REG59_INDEX],
+			  mpp_dev->variant->reg_len - RKVDPU2_REG59_INDEX);
+	/* Flush the registers */
+	wmb();
+	mpp_dev_write(mpp_dev, RKVDPU2_REG_DEC_DEV_CTRL,
+		      task->reg[RKVDPU2_REG_DEC_DEV_CTRL_INDEX]
+		      | RKVDPU2_DEC_START);
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdpu_finish(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task)
+{
+	struct rkvdpu_task *task = to_rkvdpu_task(mpp_task);
+
+	mpp_debug_enter();
+
+	/* NOTE: Only read the decoder part */
+	mpp_dev_read_seq(mpp_dev, RKVDPU2_REG_DEC_CTRL,
+			 &task->reg[RKVDPU2_REG_DEC_CTRL_INDEX],
+			 mpp_dev->variant->reg_len
+			 - RKVDPU2_REG_DEC_CTRL_INDEX);
+
+	task->reg[RKVDPU2_REG_DEC_INT_EN_INDEX] = task->irq_status;
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdpu_result(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task,
+				      u32 __user * dst, u32 size)
+{
+	struct rkvdpu_task *task = to_rkvdpu_task(mpp_task);
+	u32 err_mask;
+
+	err_mask = RKVDPU2_INT_TIMEOUT
+	    | RKVDPU2_INT_STRM_ERROR
+	    | RKVDPU2_INT_ASO_ERROR
+	    | RKVDPU2_INT_BUF_EMPTY
+	    | RKVDPU2_INT_BUS_ERROR;
+
+	if (err_mask & task->irq_status)
+		return VB2_BUF_STATE_ERROR;
+
+	return VB2_BUF_STATE_DONE;
+}
+
+static int rockchip_mpp_rkvdpu_free_task(struct mpp_session *session,
+					 struct mpp_task *mpp_task)
+{
+	struct rkvdpu_task *task = to_rkvdpu_task(mpp_task);
+
+	mpp_dev_task_finalize(session, mpp_task);
+	kfree(task);
+
+	return 0;
+}
+
+static irqreturn_t mpp_rkvdpu_isr(int irq, void *dev_id)
+{
+	struct rockchip_rkvdpu_dev *dec_dev = dev_id;
+	struct rockchip_mpp_dev *mpp_dev = &dec_dev->mpp_dev;
+	struct rkvdpu_task *task = NULL;
+	struct mpp_task *mpp_task = NULL;
+	u32 irq_status;
+	u32 err_mask;
+
+	irq_status = mpp_dev_read(mpp_dev, RKVDPU2_REG_DEC_INT_EN);
+	if (!(irq_status & RKVDPU2_DEC_INT_RAW))
+		return IRQ_NONE;
+
+	mpp_dev_write(mpp_dev, RKVDPU2_REG_DEC_INT_EN, 0);
+	mpp_dev_write(mpp_dev, RKVDPU2_REG_DEC_DEV_CTRL,
+		      RKVDPU2_DEC_CLOCK_GATE_EN);
+
+	/* FIXME use a spin lock here */
+	task = (struct rkvdpu_task *)dec_dev->current_task;
+	if (!task) {
+		dev_err(dec_dev->mpp_dev.dev, "no current task\n");
+		return IRQ_HANDLED;
+	}
+
+	mpp_task = &task->mpp_task;
+	mpp_debug_time_diff(mpp_task);
+	task->irq_status = irq_status;
+	mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n", task->irq_status);
+
+	err_mask = RKVDPU2_INT_TIMEOUT
+	    | RKVDPU2_INT_STRM_ERROR
+	    | RKVDPU2_INT_ASO_ERROR
+	    | RKVDPU2_INT_BUF_EMPTY
+	    | RKVDPU2_INT_BUS_ERROR;
+
+	if (err_mask & task->irq_status)
+		atomic_set(&mpp_dev->reset_request, 1);
+
+	mpp_dev_task_finish(mpp_task->session, mpp_task);
+
+	mpp_debug_leave();
+	return IRQ_HANDLED;
+}
+
+static int rockchip_mpp_rkvdpu_assign_reset(struct rockchip_rkvdpu_dev *dec_dev)
+{
+	struct rockchip_mpp_dev *mpp_dev = &dec_dev->mpp_dev;
+
+	dec_dev->rst_a = devm_reset_control_get_shared(mpp_dev->dev, "video_a");
+	dec_dev->rst_h = devm_reset_control_get_shared(mpp_dev->dev, "video_h");
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_a)) {
+		mpp_err("No aclk reset resource define\n");
+		dec_dev->rst_a = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(dec_dev->rst_h)) {
+		mpp_err("No hclk reset resource define\n");
+		dec_dev->rst_h = NULL;
+	}
+
+	safe_unreset(dec_dev->rst_h);
+	safe_unreset(dec_dev->rst_a);
+
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdpu_reset(struct rockchip_mpp_dev *mpp_dev)
+{
+	struct rockchip_rkvdpu_dev *dec = to_rkvdpu_dev(mpp_dev);
+
+	if (dec->rst_a && dec->rst_h) {
+		mpp_debug(DEBUG_RESET, "reset in\n");
+
+		safe_reset(dec->rst_a);
+		safe_reset(dec->rst_h);
+		udelay(5);
+		safe_unreset(dec->rst_h);
+		safe_unreset(dec->rst_a);
+
+		mpp_dev_write(mpp_dev, RKVDPU2_REG_DEC_DEV_CTRL, 0);
+		mpp_dev_write(mpp_dev, RKVDPU2_REG_DEC_INT_EN, 0);
+		dec->current_task = NULL;
+		mpp_debug(DEBUG_RESET, "reset out\n");
+	}
+
+	return 0;
+}
+
+static struct mpp_dev_ops rkvdpu_ops = {
+	.alloc_task = rockchip_mpp_rkvdpu_alloc_task,
+	.prepare = rockchip_mpp_rkvdpu_prepare,
+	.run = rockchip_mpp_rkvdpu_run,
+	.finish = rockchip_mpp_rkvdpu_finish,
+	.result = rockchip_mpp_rkvdpu_result,
+	.free_task = rockchip_mpp_rkvdpu_free_task,
+	.reset = rockchip_mpp_rkvdpu_reset,
+};
+
+static int rockchip_mpp_rkvdpu_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct rockchip_rkvdpu_dev *dec_dev = NULL;
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+	int ret = 0;
+
+	dec_dev = devm_kzalloc(dev, sizeof(struct rockchip_rkvdpu_dev),
+			       GFP_KERNEL);
+	if (!dec_dev)
+		return -ENOMEM;
+
+	mpp_dev = &dec_dev->mpp_dev;
+	mpp_dev->variant = rockchip_rkvdpu2_get_drv_data(pdev);
+	ret = mpp_dev_common_probe(mpp_dev, pdev, &rkvdpu_ops);
+	if (ret)
+		return ret;
+
+	ret = devm_request_threaded_irq(dev, mpp_dev->irq, NULL, mpp_rkvdpu_isr,
+					IRQF_SHARED | IRQF_ONESHOT,
+					dev_name(dev), dec_dev);
+	if (ret) {
+		dev_err(dev, "register interrupter runtime failed\n");
+		return ret;
+	}
+
+	rockchip_mpp_rkvdpu_assign_reset(dec_dev);
+
+	rkvdpu_ioctl_ops = mpp_ioctl_ops_templ;
+	rkvdpu_ioctl_ops.vidioc_s_fmt_vid_out_mplane =
+	    rkvdpu_s_fmt_vid_out_mplane;
+	rkvdpu_ioctl_ops.vidioc_s_fmt_vid_cap_mplane =
+	    rkvdpu_s_fmt_vid_cap_mplane;
+
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name,
+				    &rkvdpu_fops, &rkvdpu_ioctl_ops);
+	if (ret)
+		dev_err(dev, "register char device failed: %d\n", ret);
+
+	memcpy(mpp_dev->fmt_out, fmt_out_templ, sizeof(fmt_out_templ));
+	memcpy(mpp_dev->fmt_cap, fmt_cap_templ, sizeof(fmt_cap_templ));
+	dev_info(dev, "probing finish\n");
+
+	platform_set_drvdata(pdev, dec_dev);
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdpu_remove(struct platform_device *pdev)
+{
+	struct rockchip_rkvdpu_dev *dec_dev = platform_get_drvdata(pdev);
+
+	mpp_dev_common_remove(&dec_dev->mpp_dev);
+
+	return 0;
+}
+
+static const struct of_device_id mpp_rkvdpu2_dt_match[] = {
+	{.compatible = "rockchip,vpu-decoder-v2",.data = &rkvdpu_v2_data},
+	{},
+};
+
+static void *rockchip_rkvdpu2_get_drv_data(struct platform_device *pdev)
+{
+	struct mpp_dev_variant *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(mpp_rkvdpu2_dt_match, pdev->dev.of_node);
+		if (match)
+			driver_data = (struct mpp_dev_variant *)match->data;
+	}
+	return driver_data;
+}
+
+static struct platform_driver rockchip_rkvdpu2_driver = {
+	.probe = rockchip_mpp_rkvdpu_probe,
+	.remove = rockchip_mpp_rkvdpu_remove,
+	.driver = {
+		   .name = RKVDPU2_DRIVER_NAME,
+		   .of_match_table = of_match_ptr(mpp_rkvdpu2_dt_match),
+		   },
+};
+
+static int __init mpp_dev_rkvdpu2_init(void)
+{
+	int ret = platform_driver_register(&rockchip_rkvdpu2_driver);
+
+	if (ret) {
+		mpp_err("Platform device register failed (%d).\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit mpp_dev_rkvdpu2_exit(void)
+{
+	platform_driver_unregister(&rockchip_rkvdpu2_driver);
+}
+
+module_init(mpp_dev_rkvdpu2_init);
+module_exit(mpp_dev_rkvdpu2_exit);
+
+MODULE_DEVICE_TABLE(of, mpp_rkvdpu2_dt_match);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/rockchip-mpp/mpp_service.c b/drivers/staging/rockchip-mpp/mpp_service.c
new file mode 100644
index 000000000000..1e45ce141fc4
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_service.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2016 - 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+
+#include "mpp_dev_common.h"
+#include "mpp_service.h"
+
+struct mpp_service {
+	/* service critical time lock */
+	struct completion running;
+	struct mpp_task *cur_task;
+
+	u32 dev_cnt;
+	struct list_head subdev_list;
+};
+
+struct mpp_service_node {
+	/* node structure global lock */
+	struct mutex lock;
+	struct mpp_service *parent;
+	struct list_head pending;
+};
+
+/* service queue schedule */
+void mpp_srv_push_pending(struct mpp_service_node *node, struct mpp_task *task)
+{
+	mutex_lock(&node->lock);
+	list_add_tail(&task->service_link, &node->pending);
+	mutex_unlock(&node->lock);
+}
+EXPORT_SYMBOL(mpp_srv_push_pending);
+
+struct mpp_task *mpp_srv_get_pending_task(struct mpp_service_node *node)
+{
+	struct mpp_task *task = NULL;
+
+	mutex_lock(&node->lock);
+	if (!list_empty(&node->pending)) {
+		task = list_first_entry(&node->pending, struct mpp_task,
+					service_link);
+		list_del_init(&task->service_link);
+	}
+	mutex_unlock(&node->lock);
+
+	return task;
+}
+EXPORT_SYMBOL(mpp_srv_get_pending_task);
+
+int mpp_srv_is_running(struct mpp_service_node *node)
+{
+	struct mpp_service *pservice = node->parent;
+
+	return !try_wait_for_completion(&pservice->running);
+}
+EXPORT_SYMBOL(mpp_srv_is_running);
+
+void mpp_srv_wait_to_run(struct mpp_service_node *node, struct mpp_task *task)
+{
+	struct mpp_service *pservice = node->parent;
+
+	wait_for_completion(&pservice->running);
+	pservice->cur_task = task;
+}
+EXPORT_SYMBOL(mpp_srv_wait_to_run);
+
+struct mpp_task *mpp_srv_get_cur_task(struct mpp_service_node *node)
+{
+	struct mpp_service *pservice = node->parent;
+
+	return pservice->cur_task;
+}
+EXPORT_SYMBOL(mpp_srv_get_cur_task);
+
+void mpp_srv_done(struct mpp_service_node *node, struct mpp_task *task)
+{
+	struct mpp_service *pservice = node->parent;
+
+	pservice->cur_task = NULL;
+	complete(&pservice->running);
+}
+EXPORT_SYMBOL(mpp_srv_done);
+
+int mpp_srv_abort(struct mpp_service_node *node, struct mpp_task *task)
+{
+	struct mpp_service *pservice = node->parent;
+
+	if (task) {
+		if (pservice->cur_task == task)
+			pservice->cur_task = NULL;
+	}
+	complete(&pservice->running);
+
+	return 0;
+}
+EXPORT_SYMBOL(mpp_srv_abort);
+
+void *mpp_srv_attach(struct mpp_service *pservice, void *data)
+{
+	struct mpp_service_node *node = NULL;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return node;
+
+	node->parent = pservice;
+	mutex_init(&node->lock);
+	INIT_LIST_HEAD(&node->pending);
+
+	return node;
+}
+EXPORT_SYMBOL(mpp_srv_attach);
+
+void mpp_srv_detach(struct mpp_service_node *node)
+{
+	kfree(node);
+}
+EXPORT_SYMBOL(mpp_srv_detach);
+
+static void mpp_init_drvdata(struct mpp_service *pservice)
+{
+	init_completion(&pservice->running);
+	complete(&pservice->running);
+}
+
+static int mpp_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mpp_service *pservice = devm_kzalloc(dev, sizeof(*pservice),
+						    GFP_KERNEL);
+	if (!pservice)
+		return -ENOMEM;
+
+	mpp_init_drvdata(pservice);
+
+	platform_set_drvdata(pdev, pservice);
+	dev_info(dev, "init success\n");
+
+	return 0;
+}
+
+static int mpp_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id mpp_service_dt_ids[] = {
+	{ .compatible = "rockchip,mpp-service", },
+	{ },
+};
+
+static struct platform_driver mpp_driver = {
+	.probe = mpp_probe,
+	.remove = mpp_remove,
+	.driver = {
+		.name = "mpp",
+		.of_match_table = of_match_ptr(mpp_service_dt_ids),
+	},
+};
+
+static int __init mpp_service_init(void)
+{
+	int ret = platform_driver_register(&mpp_driver);
+
+	if (ret) {
+		pr_err("Platform device register failed (%d).\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit mpp_service_exit(void)
+{
+}
+
+module_init(mpp_service_init);
+module_exit(mpp_service_exit)
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/rockchip-mpp/mpp_service.h b/drivers/staging/rockchip-mpp/mpp_service.h
new file mode 100644
index 000000000000..a77cff7b02df
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_service.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2016 - 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _ROCKCHIP_MPP_SERVICE_H_
+#define _ROCKCHIP_MPP_SERVICE_H_
+
+struct mpp_service_node;
+struct mpp_service;
+
+struct mpp_task;
+
+void mpp_srv_push_pending(struct mpp_service_node *node, struct mpp_task *task);
+struct mpp_task *mpp_srv_get_pending_task(struct mpp_service_node *node);
+
+void mpp_srv_run(struct mpp_service_node *node, struct mpp_task *task);
+void mpp_srv_done(struct mpp_service_node *node, struct mpp_task *task);
+int mpp_srv_abort(struct mpp_service_node *node, struct mpp_task *task);
+
+void mpp_srv_wait_to_run(struct mpp_service_node *node, struct mpp_task *task);
+struct mpp_task *mpp_srv_get_cur_task(struct mpp_service_node *node);
+
+int mpp_srv_is_running(struct mpp_service_node *node);
+
+void *mpp_srv_attach(struct mpp_service *pservice, void *data);
+void mpp_srv_detach(struct mpp_service_node *node);
+#endif
diff --git a/drivers/staging/rockchip-mpp/rkvdec/hal.h b/drivers/staging/rockchip-mpp/rkvdec/hal.h
new file mode 100644
index 000000000000..0f6b547e4913
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/rkvdec/hal.h
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef RKVDEC_HAL_H
+#define RKVDEC_HAL_H
+
+/* The maximum registers number of all the version */
+#define ROCKCHIP_RKVDEC_REG_NUM			(109)
+
+#define RKVDEC_REG_DEC_INT_EN			0x004
+#define RKVDEC_REG_DEC_INT_EN_INDEX		(1)
+#define		RKVDEC_WR_DDR_ALIGN_EN		BIT(23)
+#define		RKVDEC_FORCE_SOFT_RESET_VALID	BIT(21)
+#define		RKVDEC_SOFTWARE_RESET_EN	BIT(20)
+#define		RKVDEC_INT_COLMV_REF_ERROR	BIT(17)
+#define		RKVDEC_INT_BUF_EMPTY		BIT(16)
+#define		RKVDEC_INT_TIMEOUT		BIT(15)
+#define		RKVDEC_INT_STRM_ERROR		BIT(14)
+#define		RKVDEC_INT_BUS_ERROR		BIT(13)
+#define		RKVDEC_DEC_INT_RAW		BIT(9)
+#define		RKVDEC_DEC_INT			BIT(8)
+#define		RKVDEC_DEC_TIMEOUT_EN		BIT(5)
+#define		RKVDEC_DEC_IRQ_DIS		BIT(4)
+#define		RKVDEC_CLOCK_GATE_EN		BIT(1)
+#define		RKVDEC_DEC_START		BIT(0)
+
+#define RKVDEC_REG_SYS_CTRL			0x008
+#define RKVDEC_REG_SYS_CTRL_INDEX		(2)
+#define		RKVDEC_GET_FORMAT(x)		(((x) >> 20) & 0x3)
+#define		RKVDEC_FMT_H265D		(0)
+#define		RKVDEC_FMT_H264D		(1)
+#define		RKVDEC_FMT_VP9D			(2)
+
+#define RKVDEC_REG_STREAM_RLC_BASE		0x010
+#define RKVDEC_REG_STREAM_RLC_BASE_INDEX	(4)
+
+#define RKVDEC_REG_PPS_BASE			0x0a0
+#define RKVDEC_REG_PPS_BASE_INDEX		(42)
+
+#define RKVDEC_REG_VP9_REFCOLMV_BASE		0x0d0
+#define RKVDEC_REG_VP9_REFCOLMV_BASE_INDEX	(52)
+
+#define RKVDEC_REG_CACHE_ENABLE(i)		(0x41c + ((i) * 0x40))
+#define		RKVDEC_CACHE_PERMIT_CACHEABLE_ACCESS	BIT(0)
+#define		RKVDEC_CACHE_PERMIT_READ_ALLOCATE	BIT(1)
+#define		RKVDEC_CACHE_LINE_SIZE_64_BYTES		BIT(4)
+
+int rkvdec_hevc_gen_reg(struct mpp_session *session, void *regs,
+			struct vb2_v4l2_buffer *src_buf);
+
+#endif
diff --git a/drivers/staging/rockchip-mpp/rkvdec/hevc.c b/drivers/staging/rockchip-mpp/rkvdec/hevc.c
new file mode 100644
index 000000000000..ac3a17176c5b
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/rkvdec/hevc.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/types.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "mpp_dev_common.h"
+#include "hal.h"
+#include "regs.h"
+
+static void init_hw_cfg(struct rkvdec_regs *p_regs)
+{
+	p_regs->sw_interrupt.dec_e = 1;
+	p_regs->sw_interrupt.dec_timeout_e = 1;
+	/* TODO: support HEVC tiles */
+	p_regs->sw_interrupt.wr_ddr_align_en = 1;
+	/* HEVC */
+	p_regs->sw_sysctrl.dec_mode = RKVDEC_FMT_H265D;
+
+	p_regs->sw_ref_valid = 0;
+	/* cabac_error_en */
+	p_regs->sw_strmd_error_en = 0xfdfffffd;
+	/* p_regs->extern_error_en = 0x30000000; */
+	p_regs->extern_error_en.error_en_highbits = 0x3000000;
+}
+
+static void ctb_calc(struct rkvdec_regs *p_regs,
+		     const struct v4l2_ctrl_hevc_sps *sps)
+{
+	u32 min_cb_log2_size_y, ctb_log2_size_y, min_cb_size_y, ctb_size_y;
+	u32 pic_width_in_min_cbs_y, pic_height_in_min_bbs_y;
+	u32 stride_y, stride_uv, virstride_y, virstride_yuv;
+	u32 width, height;
+
+	min_cb_log2_size_y = sps->log2_min_luma_coding_block_size_minus3 + 3;
+	ctb_log2_size_y = min_cb_log2_size_y +
+	    sps->log2_diff_max_min_luma_coding_block_size;
+
+	min_cb_size_y = 1 << min_cb_log2_size_y;
+	/* uiMaxCUWidth */
+	ctb_size_y = 1 << ctb_log2_size_y;
+
+	/* PicWidthInCtbsY (7-15) */
+	pic_width_in_min_cbs_y = sps->pic_width_in_luma_samples / min_cb_size_y;
+	pic_height_in_min_bbs_y = sps->pic_height_in_luma_samples /
+	    min_cb_size_y;
+
+	width = pic_width_in_min_cbs_y << min_cb_log2_size_y;
+	height = pic_height_in_min_bbs_y << min_cb_log2_size_y;
+
+	stride_y = (roundup(width, ctb_size_y) *
+		    ALIGN(sps->bit_depth_luma_minus8, 8)) >> 3;
+	stride_uv = (roundup(height, ctb_size_y) *
+		     ALIGN(sps->bit_depth_chroma_minus8, 8)) >> 3;
+	stride_y = ALIGN(stride_y, 256) | 256;
+	stride_uv = ALIGN(stride_uv, 256) | 256;
+
+	virstride_y = stride_y * ALIGN(height, 8);
+	/* FIXME: may only applied for NV12 ? */
+	virstride_yuv = virstride_y + ((stride_uv * ALIGN(height, 8)) >> 1);
+
+	p_regs->sw_picparameter.y_hor_virstride = stride_y >> 4;
+	p_regs->sw_picparameter.uv_hor_virstride = stride_uv >> 4;
+	p_regs->sw_y_virstride = virstride_y;
+	p_regs->sw_yuv_virstride = virstride_yuv;
+}
+
+static int rkvdec_hevc_gen_ref(struct rkvdec_regs *p_regs,
+			       struct vb2_v4l2_buffer *dst_buf,
+			       const struct v4l2_ctrl_hevc_slice_params *slice_params)
+{
+	struct vb2_queue *cap_q = dst_buf->vb2_buf.vb2_queue;
+	dma_addr_t cur_addr;
+	u16 i = 0;
+
+	cur_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
+	p_regs->sw_decout_base = cur_addr;
+
+	/* FIXME: use a const value */
+	for (i = 0; i < 15; i++)
+		p_regs->sw_refer_base[i].ref_base = cur_addr >> 4;
+
+	for (i = 0; i < slice_params->num_active_dpb_entries; i++) {
+		dma_addr_t ref_addr;
+		/* FIXME: why two pic_order_cnt */
+		p_regs->sw_refer_poc[i] = slice_params->dpb[i].pic_order_cnt[0];
+
+		ref_addr = rockchip_mpp_find_addr(cap_q, &dst_buf->vb2_buf,
+						  slice_params->dpb[i].
+						  timestamp);
+		if (!ref_addr)
+			ref_addr = cur_addr;
+
+		p_regs->sw_refer_base[i].ref_base = ref_addr >> 4;
+		cur_addr = ref_addr;
+
+		p_regs->sw_ref_valid |= (1 << i);
+	}
+
+	/* Enable flag for reference picture */
+	p_regs->sw_refer_base[0].ref_valid_flag =
+	    (p_regs->sw_ref_valid >> 0) & 0xf;
+	p_regs->sw_refer_base[1].ref_valid_flag =
+	    (p_regs->sw_ref_valid >> 4) & 0xf;
+	p_regs->sw_refer_base[2].ref_valid_flag =
+	    (p_regs->sw_ref_valid >> 8) & 0xf;
+	p_regs->sw_refer_base[3].ref_valid_flag =
+	    (p_regs->sw_ref_valid >> 12) & 0x7;
+
+	return 0;
+}
+
+int rkvdec_hevc_gen_reg(struct mpp_session *session, void *regs,
+			struct vb2_v4l2_buffer *src_buf)
+{
+	const struct v4l2_ctrl_hevc_sps *sps;
+	const struct v4l2_ctrl_hevc_pps *pps;
+	const struct v4l2_ctrl_hevc_slice_params *slice_params;
+	struct vb2_v4l2_buffer *dst_buf;
+	struct rkvdec_regs *p_regs = regs;
+	size_t stream_len = 0;
+
+	sps = rockchip_mpp_get_cur_ctrl(session, V4L2_CID_MPEG_VIDEO_HEVC_SPS);
+	pps = rockchip_mpp_get_cur_ctrl(session, V4L2_CID_MPEG_VIDEO_HEVC_PPS);
+	slice_params = rockchip_mpp_get_cur_ctrl(session,
+						 V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS);
+	if (!sps || !pps || !slice_params)
+		return -EINVAL;
+
+	init_hw_cfg(p_regs);
+
+	ctb_calc(p_regs, sps);
+
+	/* FIXME: support more than 1 slice */
+	p_regs->sw_picparameter.slice_num_lowbits = 0;
+	p_regs->sw_strm_rlc_base =
+	    vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	/* The bitstream must be 128bit align ? */
+	p_regs->sw_sysctrl.strm_start_bit = slice_params->data_bit_offset;
+
+	/* hardware wants a zerod memory at the stream end */
+	stream_len = DIV_ROUND_UP(slice_params->bit_size, 16) + 64;
+	p_regs->sw_stream_len = stream_len;
+
+	dst_buf = v4l2_m2m_next_dst_buf(session->fh.m2m_ctx);
+	rkvdec_hevc_gen_ref(p_regs, dst_buf, slice_params);
+
+	return 0;
+}
diff --git a/drivers/staging/rockchip-mpp/rkvdec/regs.h b/drivers/staging/rockchip-mpp/rkvdec/regs.h
new file mode 100644
index 000000000000..c1f8ad4f836f
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/rkvdec/regs.h
@@ -0,0 +1,608 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Randy Li <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef RKVDEC_REGS_H_
+#define RKVDEC_REGS_H_
+
+#if 0
+struct h264_ref {
+	u32 ref_field:1;
+	u32 ref_topfield_used:1;
+	u32 ref_botfield_used:1;
+	u32 ref_colmv_use_flag:1;
+	u32 ref_base:28;
+};
+
+struct hevc_ref {
+	u32 ref_valid_flag:4;
+	u32 ref_base:28;
+};
+#endif
+
+struct vp9_segid_grp {
+	/* this bit is only used by segid0 */
+	u32 abs_delta:1;
+	u32 frame_qp_delta_en:1;
+	u32 frame_qp_delta:9;
+	u32 frame_loopfitler_value_en:1;
+	u32 frame_loopfilter_value:7;
+	u32 referinfo_en:1;
+	u32 referinfo:2;
+	u32 frame_skip_en:1;
+	u32 reserved0:9;
+};
+
+struct rkvdec_regs {
+	struct {
+		u32 minor_ver:8;
+		u32 level:1;
+		u32 dec_support:3;
+		u32 profile:1;
+		u32 reserved0:1;
+		u32 codec_flag:1;
+		u32 reserved1:1;
+		u32 prod_num:16;
+	} sw_id;
+
+	struct {
+		u32 dec_e:1;
+		u32 dec_clkgate_e:1;
+		u32 reserved0:1;
+		u32 timeout_mode:1;
+		u32 dec_irq_dis:1;
+		u32 dec_timeout_e:1;
+		u32 buf_empty_en:1;
+		u32 stmerror_waitdecfifo_empty:1;
+		u32 dec_irq:1;
+		u32 dec_irq_raw:1;
+		u32 reserved1:2;
+		u32 dec_rdy_sta:1;
+		u32 dec_bus_sta:1;
+		u32 dec_error_sta:1;
+		u32 dec_empty_sta:1;
+		u32 colmv_ref_error_sta:1;
+		u32 cabu_end_sta:1;
+		u32 h264orvp9_error_mode:1;
+		u32 softrst_en_p:1;
+		u32 force_softreset_valid:1;
+		u32 softreset_rdy:1;
+		u32 wr_ddr_align_en:1;
+		u32 scl_down_en:1;
+		u32 allow_not_wr_unref_bframe:1;
+		u32 reserved2:6;
+	} sw_interrupt;
+
+	struct {
+		u32 in_endian:1;
+		u32 in_swap32_e:1;
+		u32 in_swap64_e:1;
+		u32 str_endian:1;
+		u32 str_swap32_e:1;
+		u32 str_swap64_e:1;
+		u32 out_endian:1;
+		u32 out_swap32_e:1;
+		u32 out_cbcr_swap:1;
+		u32 reserved0:1;
+		u32 rlc_mode_direct_write:1;
+		u32 rlc_mode:1;
+		u32 strm_start_bit:7;
+		u32 reserved1:1;
+		u32 dec_mode:2;
+		u32 reserved2:2;
+		u32 rps_mode:1;
+		u32 stream_mode:1;
+		u32 stream_lastpacket:1;
+		u32 firstslice_flag:1;
+		u32 frame_orslice:1;
+		u32 buspr_slot_disable:1;
+		u32 colmv_mode:1;
+		u32 ycacherd_prior:1;
+	} sw_sysctrl;
+
+	struct {
+		u32 y_hor_virstride:10;
+		u32 uv_hor_virstride_highbit:1;
+		u32 slice_num_highbit:1;
+		u32 uv_hor_virstride:9;
+		u32 slice_num_lowbits:11;
+	} sw_picparameter;
+
+	u32 sw_strm_rlc_base;
+	u32 sw_stream_len;
+	u32 sw_cabactbl_base;
+	u32 sw_decout_base;
+	u32 sw_y_virstride;
+	u32 sw_yuv_virstride;
+	/* SWREG 10 */
+#if 1
+	union {
+#if 0
+		struct {
+			union {
+				struct h264_ref h264;
+				struct hevc_ref hevc;
+			} sw_refer_base[15];
+			u32 sw_refer_poc[15];
+		};
+#else
+		struct {
+			union {
+				struct {
+					u32 ref_valid_flag:4;
+					u32 ref_base:28;
+				};
+				struct {
+					u32 ref_field:1;
+					u32 ref_topfield_used:1;
+					u32 ref_botfield_used:1;
+					u32 ref_colmv_use_flag:1;
+					u32 padding:28;
+				};
+			} sw_refer_base[15];
+			u32 sw_refer_poc[15];
+		};
+#endif
+
+		struct {
+			struct {
+				u32 vp9_cprheader_offset:16;
+				u32 reserved0:16;
+			};
+			struct {
+				u32 reserved1:4;
+				u32 vp9last_base:28;
+			};
+			struct {
+				u32 reserved2:4;
+				u32 vp9golden_base:28;
+			};
+			struct {
+				u32 reserved3:4;
+				u32 vp9alfter_base:28;
+			};
+			struct {
+				u32 vp9count_update_en:1;
+				u32 reserved4:2;
+				u32 vp9count_base:29;
+			};
+			struct {
+				u32 reserved5:4;
+				u32 vp9segidlast_base:28;
+			};
+			struct {
+				u32 reserved6:4;
+				u32 vp9segidcur_base:28;
+			};
+			struct {
+				u32 framewidth_last:16;
+				u32 frameheight_last:28;
+			};
+			struct {
+				u32 framewidth_golden:16;
+				u32 frameheight_golden:28;
+			};
+			struct {
+				u32 framewidth_alfter:16;
+				u32 frameheight_alfter:28;
+			};
+			/* segid_grp0 to segid_grp4 */
+			/* SWREG 25(grp5) to SWREG 27(grp7) */
+			struct vp9_segid_grp grp[8];
+			/* cprheader_config */
+			struct {
+				u32 tx_mode:3;
+				u32 frame_reference_mode:2;
+				u32 reserved7:27;
+			};
+			/* lref_scale */
+			struct {
+				u32 lref_hor_scale:16;
+				u32 lref_ver_scale:16;
+			};
+			/* gref_scale */
+			struct {
+				u32 gref_hor_scale:16;
+				u32 gref_ver_scale:16;
+			};
+			/* aref_scale */
+			struct {
+				u32 aref_hor_scale:16;
+				u32 aref_ver_scale:16;
+			};
+			/* ref_deltas_lastframe */
+			struct {
+				u32 ref_deltas_lastframe:28;
+				u32 reserved8:4;
+			};
+			/* info_lastframe */
+			struct {
+				u32 mode_deltas_lastframe:14;
+				u32 reserved9:2;
+				u32 segmentation_enable_lastframe:1;
+				u32 last_show_frame:1;
+				u32 last_intra_only:1;
+				u32 last_widthheight_eqcur:1;
+				u32 color_space_lastkeyframe:3;
+				u32 reserved10:9;
+			};
+			/* intercmd_base */
+			struct {
+				u32 reserved11:4;
+				u32 intercmd_base:28;
+			};
+			/* intercmd_num */
+			struct {
+				u32 intercmd_num:24;
+				u32 reserved12:8;
+			};
+			/* lasttile_size */
+			struct {
+				u32 lasttile_size:24;
+				u32 reserved13:8;
+			};
+			/* lastf_hor_virstride */
+			struct {
+				u32 lastfy_hor_virstride:10;
+				u32 reserved14:6;
+				u32 lastfuv_hor_virstride:10;
+				u32 reserved15:6;
+			};
+			/* goldenf_hor_virstride */
+			struct {
+				u32 goldenfy_hor_virstride:10;
+				u32 reserved16:6;
+				u32 goldenuv_hor_virstride:10;
+				u32 reserved17:6;
+			};
+			/* altreff_hor_virstride */
+			struct {
+				u32 altrey_hor_virstride:10;
+				u32 reserved18:6;
+				u32 altreuv_hor_virstride:10;
+				u32 reserved19:6;
+			};
+		} vp9;
+	};
+#else
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 vp9_cprheader_offset:16;
+			u32 reserved0:16;
+		};
+	} sw10;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 reserved0:4;
+			u32 vp9last_base:28;
+		};
+	} sw11;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 reserved0:4;
+			u32 vp9golden_base:28;
+		};
+	} sw12;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 reserved0:4;
+			u32 vp9alfter_base:28;
+		};
+	} sw13;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 vp9count_update_en:1;
+			u32 reserved0:2;
+			u32 vp9count_base:29;
+		};
+	} sw14;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 reserved0:4;
+			u32 vp9segidlast_base:28;
+		};
+	} sw15;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 reserved0:4;
+			u32 vp9segidcur_base:28;
+		};
+	} sw16;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 framewidth_last:16;
+			u32 frameheight_last:28;
+		} vp9;
+	} sw17;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 framewidth_golden:16;
+			u32 frameheight_golden:28;
+		} vp9;
+	} sw18;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+
+		struct {
+			u32 framewidth_alfter:16;
+			u32 frameheight_alfter:28;
+		} vp9;
+	} sw19;
+
+	union {
+		struct h264_ref h264;
+		struct hevc_ref hevc;
+		/* segid_grp0 to segid_grp4 */
+		struct vp9_segid_grp vp9;
+	} sw20_sw24[5];
+
+	/* SWREG 25 */
+	union {
+		u32 sw_refer_poc[15];
+
+		struct {
+			/* SWREG 25(grp5) to SWREG 27(grp7) */
+			struct vp9_segid_grp grp5_grp7[3];
+			/* cprheader_config */
+			struct {
+				u32 tx_mode:3;
+				u32 frame_reference_mode:2;
+				u32 reserved0:27;
+			};
+			/* lref_scale */
+			struct {
+				u32 lref_hor_scale:16;
+				u32 lref_ver_scale:16;
+			};
+			/* gref_scale */
+			struct {
+				u32 gref_hor_scale:16;
+				u32 gref_ver_scale:16;
+			};
+			/* aref_scale */
+			struct {
+				u32 aref_hor_scale:16;
+				u32 aref_ver_scale:16;
+			};
+			/* ref_deltas_lastframe */
+			struct {
+				u32 ref_deltas_lastframe:28;
+				u32 reserved1:4;
+			};
+			/* info_lastframe */
+			struct {
+				u32 mode_deltas_lastframe:14;
+				u32 reserved2:2;
+				u32 segmentation_enable_lastframe:1;
+				u32 last_show_frame:1;
+				u32 last_intra_only:1;
+				u32 last_widthheight_eqcur:1;
+				u32 color_space_lastkeyframe:3;
+				u32 reserved3:9;
+			};
+			/* intercmd_base */
+			struct {
+				u32 reserved4:4;
+				u32 intercmd_base:28;
+			};
+			/* intercmd_num */
+			struct {
+				u32 intercmd_num:24;
+				u32 reserved5:8;
+			};
+			/* lasttile_size */
+			struct {
+				u32 lasttile_size:24;
+				u32 reserved6:8;
+			};
+			/* lastf_hor_virstride */
+			struct {
+				u32 lastfy_hor_virstride:10;
+				u32 reserved7:6;
+				u32 lastfuv_hor_virstride:10;
+				u32 reserved8:6;
+			};
+			/* goldenf_hor_virstride */
+			struct {
+				u32 goldenfy_hor_virstride:10;
+				u32 reserved9:6;
+				u32 goldenuv_hor_virstride:10;
+				u32 reserved10:6;
+			};
+			/* altreff_hor_virstride */
+			struct {
+				u32 altrey_hor_virstride:10;
+				u32 reserved9:6;
+				u32 altreuv_hor_virstride:10;
+				u32 reserved10:6;
+			};
+		} vp9;
+	};
+#endif
+	/* SWREG 40 */
+	u32 sw_cur_poc;
+	u32 sw_rlcwrite_base;
+	u32 sw_pps_base;
+	u32 sw_rps_base;
+	/* in HEVC, it is called cabac_error_en */
+	u32 sw_strmd_error_en;
+	/* SWREG 45, cabac_error_status, vp9_error_info0 */
+	struct {
+		u32 strmd_error_status:28;
+		u32 colmv_error_ref_picidx:4;
+	} sw_strmd_error_status;
+
+	struct cabac_error_ctu {
+		u32 strmd_error_ctu_xoffset:8;
+		u32 strmd_error_ctu_yoffset:8;
+		u32 streamfifo_space2full:7;
+		u32 reserved0:1;
+		u32 vp9_error_ctu0_en:1;
+		u32 reversed1:7;
+	} cabac_error_ctu;
+
+	/* SWREG 47 */
+	struct sao_ctu_position {
+		u32 sw_saowr_xoffset:9;
+		u32 reversed0:7;
+		u32 sw_saowr_yoffset:10;
+		u32 reversed1:6;
+	} sao_ctu_position;
+
+	/* SWREG 48 */
+	union {
+		u32 sw_ref_valid;
+		struct {
+			u32 ref15_base:10;
+			u32 ref15_field:1;
+			u32 ref15_topfield_used:1;
+			u32 ref15_botfield_used:1;
+			u32 ref15_colmv_use_flag:1;
+			u32 reverse0:18;
+		} sw48_h264;
+
+		struct {
+			u32 lastfy_virstride:20;
+			u32 reserved0:12;
+		} sw48_vp9;
+	};
+
+	/* SWREG 49 - 63 */
+#if 0
+	u32 sw_refframe_index[15];
+#else
+	union {
+		u32 sw_refframe_index[15];
+		struct {
+			struct {
+				u32 goldeny_virstride:20;
+				u32 reserved0:12;
+			};
+			struct {
+				u32 altrefy_virstride:20;
+				u32 reserved1:12;
+			};
+			struct {
+				u32 lastref_yuv_virstride:20;
+				u32 reserved2:12;
+			};
+			struct {
+				u32 reserved3:4;
+				u32 refcolmv_base:28;
+			};
+			u32 padding[11];
+		} vp9_vir;
+
+	};
+#endif
+
+	/* SWREG 64 */
+	u32 performance_cycle;
+	u32 axi_ddr_rdata;
+	u32 axi_ddr_wdata;
+	/* SWREG67 */
+	u32 fpgadebug_reset;
+
+	struct {
+		u32 perf_cnt0_sel:6;
+		u32 reserved2:2;
+		u32 perf_cnt1_sel:6;
+		u32 reserved1:2;
+		u32 perf_cnt2_sel:6;
+		u32 reserved0:10;
+	} sw68_perf_sel;
+
+	u32 sw69_perf_cnt0;
+	u32 sw70_perf_cnt1;
+	u32 sw71_perf_cnt2;
+	u32 sw72_h264_refer30_poc;
+	u32 sw73_h264_refer31_poc;
+	u32 sw74_h264_cur_poc1;
+	u32 sw75_errorinfo_base;
+
+#if 0
+	struct {
+		u32 slicedec_num:14;
+		u32 reserved1:1;
+		u32 strmd_detect_error_flag:1;
+		u32 sw_error_packet_num:14;
+		u32 reserved0:2;
+	} sw76_errorinfo_num;
+#else
+	union {
+		struct {
+			u32 slicedec_num:14;
+			u32 reserved1:1;
+			u32 strmd_detect_error_flag:1;
+			u32 sw_error_packet_num:14;
+			u32 reserved0:2;
+		} sw76_errorinfo_num;
+
+		struct {
+			u32 error_ctu1_x:6;
+			u32 reserved0:2;
+			u32 vp9_error_ctu1_y:6;
+			u32 reserved1:1;
+			u32 vp9_error_ctu1_en:1;
+			u32 reserved2:16;
+		} swreg76_vp9_error_ctu1;
+	};
+#endif
+
+	/* SWREG 77 */
+	struct {
+		u32 error_en_highbits:28;
+		u32 strmd_error_en:2;
+		u32 reserved0:2;
+	} extern_error_en;
+};
+
+#endif
diff --git a/drivers/staging/rockchip-mpp/vdpu2/hal.h b/drivers/staging/rockchip-mpp/vdpu2/hal.h
new file mode 100644
index 000000000000..3da4b0e04c17
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/vdpu2/hal.h
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VDPU2_HAL_H_
+#define _VDPU2_HAL_H_
+
+#include <linux/types.h>
+
+/* The maximum registers number of all the version */
+#define ROCKCHIP_VDPU2_REG_NUM		159
+
+/* The first register of the decoder is Reg50(0x000c8) */
+#define RKVDPU2_REG_DEC_CTRL			0x0c8
+#define RKVDPU2_REG_DEC_CTRL_INDEX		(50)
+
+#define RKVDPU2_REG_DEC_INT_EN			0x0dc
+#define RKVDPU2_REG_DEC_INT_EN_INDEX		(55)
+#define		RKVDPU2_INT_TIMEOUT		BIT(13)
+#define		RKVDPU2_INT_STRM_ERROR		BIT(12)
+#define		RKVDPU2_INT_SLICE		BIT(9)
+#define		RKVDPU2_INT_ASO_ERROR		BIT(8)
+#define		RKVDPU2_INT_BUF_EMPTY		BIT(6)
+#define		RKVDPU2_INT_BUS_ERROR		BIT(5)
+#define		RKVDPU2_DEC_INT			BIT(4)
+#define		RKVDPU2_DEC_IRQ_DIS		BIT(1)
+#define		RKVDPU2_DEC_INT_RAW		BIT(0)
+
+#define RKVDPU2_REG_DEC_DEV_CTRL		0x0e4
+#define RKVDPU2_REG_DEC_DEV_CTRL_INDEX		(57)
+#define		RKVDPU2_DEC_CLOCK_GATE_EN	BIT(4)
+#define		RKVDPU2_DEC_START		BIT(0)
+
+#define RKVDPU2_REG59				0x0ec
+#define RKVDPU2_REG59_INDEX			(59)
+
+int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
+			 struct vb2_v4l2_buffer *src_buf);
+int rkvdpu_mpeg2_prepare_buf(struct mpp_session *session, void *regs);
+
+#endif
diff --git a/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
new file mode 100644
index 000000000000..d32958c4cb20
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/types.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "mpp_dev_common.h"
+#include "hal.h"
+#include "regs.h"
+
+#define DEC_LITTLE_ENDIAN	(1)
+
+static const u8 zigzag[64] = {
+	0, 1, 8, 16, 9, 2, 3, 10,
+	17, 24, 32, 25, 18, 11, 4, 5,
+	12, 19, 26, 33, 40, 48, 41, 34,
+	27, 20, 13, 6, 7, 14, 21, 28,
+	35, 42, 49, 56, 57, 50, 43, 36,
+	29, 22, 15, 23, 30, 37, 44, 51,
+	58, 59, 52, 45, 38, 31, 39, 46,
+	53, 60, 61, 54, 47, 55, 62, 63
+};
+
+static const u8 intra_default_q_matrix[64] = {
+	8, 16, 19, 22, 26, 27, 29, 34,
+	16, 16, 22, 24, 27, 29, 34, 37,
+	19, 22, 26, 27, 29, 34, 34, 38,
+	22, 22, 26, 27, 29, 34, 37, 40,
+	22, 26, 27, 29, 32, 35, 40, 48,
+	26, 27, 29, 32, 35, 40, 48, 58,
+	26, 27, 29, 34, 38, 46, 56, 69,
+	27, 29, 35, 38, 46, 56, 69, 83
+};
+
+static void mpeg2_dec_copy_qtable(u8 * qtable, const struct v4l2_ctrl_mpeg2_quantization
+				  *ctrl)
+{
+	int i, n;
+
+	if (!qtable || !ctrl)
+		return;
+
+	if (ctrl->load_intra_quantiser_matrix) {
+		for (i = 0; i < 64; i++)
+			qtable[zigzag[i]] = ctrl->intra_quantiser_matrix[i];
+	} else {
+		for (i = 0; i < 64; i++)
+			qtable[zigzag[i]] = intra_default_q_matrix[i];
+
+	}
+
+	if (ctrl->load_non_intra_quantiser_matrix) {
+		for (i = 0; i < 64; i++)
+			qtable[zigzag[i] + 64] =
+			    ctrl->non_intra_quantiser_matrix[i];
+	} else {
+		for (i = 0; i < 64; i++)
+			qtable[zigzag[i] + 64] = 16;
+	}
+}
+
+static void init_hw_cfg(struct vdpu2_regs *p_regs)
+{
+	p_regs->sw54.dec_strm_wordsp = 1;
+	p_regs->sw54.dec_strendian_e = DEC_LITTLE_ENDIAN;
+	p_regs->sw54.dec_in_wordsp = 1;
+	p_regs->sw54.dec_out_wordsp = 1;
+	p_regs->sw54.dec_in_endian = DEC_LITTLE_ENDIAN;	//change
+	p_regs->sw54.dec_out_endian = DEC_LITTLE_ENDIAN;
+	p_regs->sw57.dec_timeout = 1;
+	p_regs->sw57.dec_timeout_e = 1;
+
+	p_regs->sw57.dec_clk_gate_e = 1;
+
+	p_regs->sw50.tiled_mode_msb = 0;
+	p_regs->sw56.dec_max_burst = 16;
+	p_regs->sw50.dec_scmd_dis = 0;
+	p_regs->sw50.dec_adv_pre_dis = 0;
+	p_regs->sw52.apf_threshold = 8;
+
+	p_regs->sw50.dec_latency = 0;
+	p_regs->sw56.dec_data_disc_e = 0;
+
+	p_regs->sw55.dec_irq = 0;
+	p_regs->sw56.dec_axi_rd_id = 0;
+	p_regs->sw56.dec_axi_wr_id = 0;
+
+	/* default for MPEG-2 */
+	p_regs->sw136.mv_accuracy_fwd = 1;
+	p_regs->sw136.mv_accuracy_bwd = 1;
+}
+
+int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
+			 struct vb2_v4l2_buffer *src_buf)
+{
+	const struct v4l2_ctrl_mpeg2_slice_params *params;
+	const struct v4l2_ctrl_mpeg2_quantization *quantization;
+	const struct v4l2_mpeg2_sequence *sequence;
+	const struct v4l2_mpeg2_picture *picture;
+	struct vdpu2_regs *p_regs = regs;
+
+	params = rockchip_mpp_get_cur_ctrl(session,
+					   V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
+	quantization = rockchip_mpp_get_cur_ctrl(session,
+						 V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
+
+	if (!params)
+		return -EINVAL;
+
+	sequence = &params->sequence;
+	picture = &params->picture;
+
+	init_hw_cfg(p_regs);
+
+	p_regs->sw120.pic_mb_width = DIV_ROUND_UP(sequence->horizontal_size,
+						  16);
+	p_regs->sw120.pic_mb_height_p = DIV_ROUND_UP(sequence->vertical_size,
+						     16);
+
+	/* PICT_FRAME */
+	if (picture->picture_structure == 3) {
+		p_regs->sw57.pic_fieldmode_e = 0;
+	} else {
+		p_regs->sw57.pic_fieldmode_e = 1;
+		/* PICT_TOP_FIEL */
+		if (picture->picture_structure == 1)
+			p_regs->sw57.pic_topfield_e = 1;
+	}
+
+	switch (picture->picture_coding_type) {
+	case V4L2_MPEG2_PICTURE_CODING_TYPE_B:
+		p_regs->sw57.pic_b_e = 1;
+	case V4L2_MPEG2_PICTURE_CODING_TYPE_P:
+		p_regs->sw57.pic_inter_e = 1;
+		break;
+	case V4L2_MPEG2_PICTURE_CODING_TYPE_I:
+	default:
+		p_regs->sw57.pic_inter_e = 0;
+		p_regs->sw57.pic_b_e = 0;
+		break;
+	}
+
+	if (picture->top_field_first)
+		p_regs->sw120.mpeg.topfieldfirst_e = 1;
+
+	p_regs->sw57.fwd_interlace_e = 0;
+	p_regs->sw57.write_mvs_e = 0;
+
+	p_regs->sw120.mpeg.alt_scan_e = picture->alternate_scan;
+	p_regs->sw136.alt_scan_flag_e = picture->alternate_scan;
+
+	p_regs->sw122.qscale_type = picture->q_scale_type;
+	p_regs->sw122.intra_dc_prec = picture->intra_dc_precision;
+	p_regs->sw122.con_mv_e = picture->concealment_motion_vectors;
+	p_regs->sw122.intra_vlc_tab = picture->intra_vlc_format;
+	p_regs->sw122.frame_pred_dct = picture->frame_pred_frame_dct;
+	p_regs->sw51.qp_init = 1;
+
+	/* MPEG-2 decoding mode */
+	p_regs->sw53.dec_mode = RKVDPU2_FMT_MPEG2D;
+
+	p_regs->sw136.fcode_fwd_hor = picture->f_code[0][0];
+	p_regs->sw136.fcode_fwd_ver = picture->f_code[0][1];
+	p_regs->sw136.fcode_bwd_hor = picture->f_code[1][0];
+	p_regs->sw136.fcode_bwd_ver = picture->f_code[1][1];
+
+	p_regs->sw57.pic_interlace_e = 1 - sequence->progressive_sequence;
+#if 0
+	/* MPEG-1 decoding mode */
+	p_regs->sw53.sw_dec_mode = 6;
+	p_regs->sw136.fcode_fwd_hor = picture->f_code[0][1];
+	p_regs->sw136.fcode_fwd_ver = picture->f_code[0][1];
+	p_regs->sw136.fcode_bwd_hor = picture->f_code[1][1];
+	p_regs->sw136.fcode_bwd_ver = picture->f_code[1][1];
+	if (picture->f_code[0][0])
+		p_regs->sw136.mv_accuracy_fwd = 0;
+	if (picture->f_code[1][0])
+		p_regs->sw136.mv_accuracy_bwd = 0;
+#endif
+	p_regs->sw52.startmb_x = 0;
+	p_regs->sw52.startmb_y = 0;
+	p_regs->sw57.dec_out_dis = 0;
+	p_regs->sw50.filtering_dis = 1;
+
+	p_regs->sw64.rlc_vlc_base =
+	    vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	p_regs->sw122.strm_start_bit = params->data_bit_offset;
+	p_regs->sw51.stream_len = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
+
+	return 0;
+}
+
+int rkvdpu_mpeg2_prepare_buf(struct mpp_session *session, void *regs)
+{
+	const struct v4l2_ctrl_mpeg2_slice_params *params;
+	const struct v4l2_mpeg2_sequence *sequence;
+	const struct v4l2_mpeg2_picture *picture;
+	struct vb2_v4l2_buffer *dst_buf;
+	dma_addr_t cur_addr, fwd_addr, bwd_addr;
+	struct vb2_queue *cap_q = &session->fh.m2m_ctx->cap_q_ctx.q;
+	struct vdpu2_regs *p_regs = regs;
+
+	params =
+	    rockchip_mpp_get_cur_ctrl(session,
+				      V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
+	picture = &params->picture;
+	sequence = &params->sequence;
+
+	dst_buf = v4l2_m2m_next_dst_buf(session->fh.m2m_ctx);
+	cur_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
+
+	fwd_addr =
+	    rockchip_mpp_find_addr(cap_q, &dst_buf->vb2_buf,
+				   params->forward_ref_ts);
+	bwd_addr =
+	    rockchip_mpp_find_addr(cap_q, &dst_buf->vb2_buf,
+				   params->backward_ref_ts);
+	if (!bwd_addr)
+		bwd_addr = cur_addr;
+	if (!fwd_addr)
+		fwd_addr = cur_addr;
+
+	/* Starting from the second horizontal line */
+	if (picture->picture_structure == 2)
+		cur_addr += ALIGN(sequence->horizontal_size, 16);
+	p_regs->sw63.dec_out_base = cur_addr;
+
+	if (picture->picture_coding_type == V4L2_MPEG2_PICTURE_CODING_TYPE_B) {
+		p_regs->sw131.refer0_base = fwd_addr >> 2;
+		p_regs->sw148.refer1_base = fwd_addr >> 2;
+		p_regs->sw134.refer2_base = bwd_addr >> 2;
+		p_regs->sw135.refer3_base = bwd_addr >> 2;
+	} else {
+		if (picture->picture_structure == 3 ||
+		    (picture->picture_structure == 1
+		     && picture->top_field_first)
+		    || (picture->picture_structure == 2
+			&& !picture->top_field_first)) {
+			p_regs->sw131.refer0_base = fwd_addr >> 2;
+			p_regs->sw148.refer1_base = fwd_addr >> 2;
+		} else if (picture->picture_structure == 1) {
+			p_regs->sw131.refer0_base = fwd_addr >> 2;
+			p_regs->sw148.refer1_base = cur_addr >> 2;
+		} else if (picture->picture_structure == 2) {
+			p_regs->sw131.refer0_base = cur_addr >> 2;
+			p_regs->sw148.refer1_base = fwd_addr >> 2;
+		}
+		p_regs->sw134.refer2_base = cur_addr >> 2;
+		p_regs->sw135.refer3_base = cur_addr >> 2;
+	}
+
+	return 0;
+}
diff --git a/drivers/staging/rockchip-mpp/vdpu2/regs.h b/drivers/staging/rockchip-mpp/vdpu2/regs.h
new file mode 100644
index 000000000000..8708b26d83c5
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/vdpu2/regs.h
@@ -0,0 +1,699 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *		Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VDPU2_REGS_H_
+#define _VDPU2_REGS_H_
+
+#define RKVDPU2_REG_SYS_CTRL			0x0d4
+#define RKVDPU2_REG_SYS_CTRL_INDEX		(53)
+#define		RKVDPU2_GET_FORMAT(x)		((x) & 0xf)
+#define		RKVDPU2_FMT_H264D		0
+#define		RKVDPU2_FMT_MPEG4D		1
+#define		RKVDPU2_FMT_H263D		2
+#define		RKVDPU2_FMT_JPEGD		3
+#define		RKVDPU2_FMT_VC1D		4
+#define		RKVDPU2_FMT_MPEG2D		5
+#define		RKVDPU2_FMT_MPEG1D		6
+#define		RKVDPU2_FMT_VP6D		7
+#define		RKVDPU2_FMT_RESERVED		8
+#define		RKVDPU2_FMT_VP7D		9
+#define		RKVDPU2_FMT_VP8D		10
+#define		RKVDPU2_FMT_AVSD		11
+
+#define RKVDPU2_REG_DIR_MV_BASE                 0x0f8
+#define RKVDPU2_REG_DIR_MV_BASE_INDEX           (62)
+
+#define RKVDPU2_REG_STREAM_RLC_BASE		0x100
+#define RKVDPU2_REG_STREAM_RLC_BASE_INDEX	(64)
+
+#if 0
+/*
+ * file handle translate information
+ */
+static const char trans_tbl_default[] = {
+	61, 62, 63, 64, 131, 134, 135, 148
+};
+
+static const char trans_tbl_jpegd[] = {
+	21, 22, 61, 63, 64, 131
+};
+
+static const char trans_tbl_h264d[] = {
+	61, 63, 64, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
+	98, 99
+};
+
+static const char trans_tbl_vc1d[] = {
+	62, 63, 64, 131, 134, 135, 145, 148
+};
+
+static const char trans_tbl_vp6d[] = {
+	61, 63, 64, 131, 136, 145
+};
+
+static const char trans_tbl_vp8d[] = {
+	61, 63, 64, 131, 136, 137, 140, 141, 142, 143, 144, 145, 146, 147, 149
+};
+#endif
+
+struct vdpu2_regs {
+	u32 sw00_49[50];
+
+	struct {
+		u32 tiled_mode_msb:1;
+		u32 dec_latency:6;
+		u32 dec_fixed_quant:1;
+		u32 filtering_dis:1;
+		u32 skip_sel:1;
+		u32 dec_scmd_dis:1;
+		u32 dec_adv_pre_dis:1;
+		u32 tiled_mode_lsb:1;
+		u32 refbuf_thrd:12;
+		u32 refbuf_pid:5;
+		u32 reserved0:2;
+	} sw50;
+
+	struct {
+		u32 stream_len:24;
+		u32 stream_len_ext:1;
+		u32 qp_init:6;
+		u32 reserved0:1;
+	} sw51;
+
+	struct {
+		/* ydim_mbst */
+		u32 startmb_y:8;
+		/* xdim_mbst */
+		u32 startmb_x:9;
+		/* adv_pref_thrd */
+		u32 apf_threshold:14;
+		u32 reserved0:1;
+	} sw52;
+
+	struct {
+		u32 dec_mode:4;
+		u32 reserved0:28;
+	} sw53;
+
+	struct {
+		u32 dec_in_endian:1;
+		u32 dec_out_endian:1;
+		u32 dec_in_wordsp:1;
+		u32 dec_out_wordsp:1;
+		u32 dec_strm_wordsp:1;
+		u32 dec_strendian_e:1;
+		u32 reserved0:26;
+	} sw54;
+
+	struct {
+		u32 dec_irq:1;
+		u32 dec_irq_dis:1;
+		u32 reserved0:2;
+		u32 dec_rdy_sts:1;
+		u32 pp_bus_sts:1;
+		u32 buf_emt_sts:1;
+		u32 reserved1:1;
+		u32 aso_det_sts:1;
+		u32 slice_det_sts:1;
+		u32 bslice_det_sts:1;
+		u32 reserved2:1;
+		u32 error_det_sts:1;
+		u32 timeout_det_sts:1;
+		u32 reserved3:18;
+	} sw55;
+
+	struct {
+		u32 dec_axi_rd_id:8;
+		u32 dec_axi_wr_id:8;
+		u32 dec_max_burst:5;
+		u32 bus_pos_sel:1;
+		u32 dec_data_disc_e:1;
+		u32 axi_sel:1;
+		u32 reserved0:8;
+	} sw56;
+
+	struct {
+		u32 dec_e:1;
+		u32 refbuf2_buf_e:1;
+		u32 dec_out_dis:1;
+		u32 reserved2:1;
+		u32 dec_clk_gate_e:1;
+		u32 dec_timeout_e:1;
+		/* rd_cnt_tab_en */
+		u32 picord_count_e:1;
+		u32 seq_mbaff_e:1;
+		u32 reftopfirst_e:1;
+		u32 ref_topfield_e:1;
+		u32 write_mvs_e:1;
+		u32 sorenson_e:1;
+		u32 fwd_interlace_e:1;
+		u32 pic_topfield_e:1;
+		/* sw_pic_type_sel0 */
+		u32 pic_inter_e:1;
+		u32 pic_b_e:1;
+		u32 pic_fieldmode_e:1;
+		u32 pic_interlace_e:1;
+		u32 pjpeg_e:1;
+		u32 divx3_e:1;
+		u32 rlc_mode_e:1;
+		u32 ch_8pix_ileav_e:1;
+		u32 start_code_e:1;
+		u32 reserved1:2;
+		/* sw_init_dc_match0 ? */
+		u32 inter_dblspeed:1;
+		u32 intra_dblspeed:1;
+		u32 intra_dbl3t:1;
+		u32 pref_sigchan:1;
+		u32 cache_en:1;
+		u32 reserved0:1;
+		/* dec_timeout_mode */
+		u32 dec_timeout:1;
+	} sw57;
+
+	struct {
+		u32 soft_rst:1;
+		u32 reserved0:31;
+	} sw58;
+
+	struct {
+		u32 reserved0:2;
+		/* sw_pflt_set0_tap2 */
+		u32 pred_bc_tap_0_2:10;
+		u32 pred_bc_tap_0_1:10;
+		/* pflt_set0_tap0 */
+		u32 pred_bc_tap_0_0:10;
+	} sw59;
+
+	struct {
+		u32 addit_ch_st_adr:32;
+	} sw60;
+
+	struct {
+		u32 qtable_base:32;
+	} sw61;
+
+	struct {
+		u32 dir_mv_base:32;
+	} sw62;
+
+	struct {
+		/* dec_out_st_adr */
+		u32 dec_out_base:32;
+	} sw63;
+
+	struct {
+		u32 rlc_vlc_base:32;
+	} sw64;
+
+	struct {
+		u32 refbuf_y_offset:9;
+		u32 reserve0:3;
+		u32 refbuf_fildpar_mode_e:1;
+		u32 refbuf_idcal_e:1;
+		u32 refbuf_picid:5;
+		u32 refbuf_thr_level:12;
+		u32 refbuf_e:1;
+	} sw65;
+
+	u32 sw66;
+	u32 sw67;
+
+	struct {
+		u32 refbuf_sum_bot:16;
+		u32 refbuf_sum_top:16;
+	} sw68;
+
+	struct {
+		u32 luma_sum_intra:16;
+		u32 refbuf_sum_hit:16;
+	} sw69;
+
+	struct {
+		u32 ycomp_mv_sum:22;
+		u32 reserve0:10;
+	} sw70;
+
+	u32 sw71;
+	u32 sw72;
+	u32 sw73;
+
+	struct {
+		u32 init_reflist_pf4:5;
+		u32 init_reflist_pf5:5;
+		u32 init_reflist_pf6:5;
+		u32 init_reflist_pf7:5;
+		u32 init_reflist_pf8:5;
+		u32 init_reflist_pf9:5;
+		u32 reserved0:2;
+	} sw74;
+
+	struct {
+		u32 init_reflist_pf10:5;
+		u32 init_reflist_pf11:5;
+		u32 init_reflist_pf12:5;
+		u32 init_reflist_pf13:5;
+		u32 init_reflist_pf14:5;
+		u32 init_reflist_pf15:5;
+		u32 reserved0:2;
+	} sw75;
+
+	struct {
+		u32 num_ref_idx0:16;
+		u32 num_ref_idx1:16;
+	} sw76;
+
+	struct {
+		u32 num_ref_idx2:16;
+		u32 num_ref_idx3:16;
+	} sw77;
+
+	struct {
+		u32 num_ref_idx4:16;
+		u32 num_ref_idx5:16;
+	} sw78;
+
+	struct {
+		u32 num_ref_idx6:16;
+		u32 num_ref_idx7:16;
+	} sw79;
+
+	struct {
+		u32 num_ref_idx8:16;
+		u32 num_ref_idx9:16;
+	} sw80;
+
+	struct {
+		u32 num_ref_idx10:16;
+		u32 num_ref_idx11:16;
+	} sw81;
+
+	struct {
+		u32 num_ref_idx12:16;
+		u32 num_ref_idx13:16;
+	} sw82;
+
+	struct {
+		u32 num_ref_idx14:16;
+		u32 num_ref_idx15:16;
+	} sw83;
+
+	/* Used by H.264 */
+	union {
+		u32 ref0_st_addr;
+		struct {
+			u32 ref0_closer_sel:1;
+			u32 ref0_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw84;
+
+	union {
+		u32 ref1_st_addr;
+		struct {
+			u32 ref1_closer_sel:1;
+			u32 ref1_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw85;
+
+	union {
+		u32 ref2_st_addr;
+		struct {
+			u32 ref2_closer_sel:1;
+			u32 ref2_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw86;
+
+	union {
+		u32 ref3_st_addr;
+		struct {
+			u32 ref3_closer_sel:1;
+			u32 ref3_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw87;
+
+	union {
+		u32 ref4_st_addr;
+		struct {
+			u32 ref4_closer_sel:1;
+			u32 ref4_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw88;
+
+	union {
+		u32 ref5_st_addr;
+		struct {
+			u32 ref5_closer_sel:1;
+			u32 ref5_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw89;
+
+	union {
+		u32 ref6_st_addr;
+		struct {
+			u32 ref6_closer_sel:1;
+			u32 ref6_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw90;
+
+	union {
+		u32 ref7_st_addr;
+		struct {
+			u32 ref7_closer_sel:1;
+			u32 ref7_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw91;
+
+	union {
+		u32 ref8_st_addr;
+		struct {
+			u32 ref8_closer_sel:1;
+			u32 ref8_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw92;
+
+	union {
+		u32 ref9_st_addr;
+		struct {
+			u32 ref9_closer_sel:1;
+			u32 ref9_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw93;
+
+	union {
+		u32 ref10_st_addr;
+		struct {
+			u32 ref10_closer_sel:1;
+			u32 ref10_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw94;
+
+	union {
+		u32 ref11_st_addr;
+		struct {
+			u32 ref11_closer_sel:1;
+			u32 ref11_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw95;
+
+	union {
+		u32 ref12_st_addr;
+		struct {
+			u32 ref12_closer_sel:1;
+			u32 ref12_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw96;
+
+	union {
+		u32 ref13_st_addr;
+		struct {
+			u32 ref13_closer_sel:1;
+			u32 ref13_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw97;
+
+	union {
+		u32 ref14_st_addr;
+		struct {
+			u32 ref14_closer_sel:1;
+			u32 ref14_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw98;
+
+	/* Used by H.264 */
+	union {
+		u32 ref15_st_addr;
+		struct {
+			u32 ref15_closer_sel:1;
+			u32 ref15_field_en:1;
+			u32 reserved0:30;
+		};
+	} sw99;
+
+	struct {
+		u32 init_reflist_df0:5;
+		u32 init_reflist_df1:5;
+		u32 init_reflist_df2:5;
+		u32 init_reflist_df3:5;
+		u32 init_reflist_df4:5;
+		u32 init_reflist_df5:5;
+		u32 reserved0:2;
+	} sw100;
+
+	struct {
+		u32 init_reflist_df6:5;
+		u32 init_reflist_df7:5;
+		u32 init_reflist_df8:5;
+		u32 init_reflist_df9:5;
+		u32 init_reflist_df10:5;
+		u32 init_reflist_df11:5;
+		u32 reserved0:2;
+	} sw101;
+
+	struct {
+		u32 init_reflist_df12:5;
+		u32 init_reflist_df13:5;
+		u32 init_reflist_df14:5;
+		u32 init_reflist_df15:5;
+		u32 reserved0:12;
+	} sw102;
+
+	struct {
+		u32 init_reflist_db0:5;
+		u32 init_reflist_db1:5;
+		u32 init_reflist_db2:5;
+		u32 init_reflist_db3:5;
+		u32 init_reflist_db4:5;
+		u32 init_reflist_db5:5;
+		u32 reserved0:2;
+	} sw103;
+
+	struct {
+		u32 init_reflist_db6:5;
+		u32 init_reflist_db7:5;
+		u32 init_reflist_db8:5;
+		u32 init_reflist_db9:5;
+		u32 init_reflist_db10:5;
+		u32 init_reflist_db11:5;
+		u32 reserved0:2;
+	} sw104;
+
+	struct {
+		u32 init_reflist_db12:5;
+		u32 init_reflist_db13:5;
+		u32 init_reflist_db14:5;
+		u32 init_reflist_db15:5;
+		u32 reserved0:12;
+	} sw105;
+
+	struct {
+		u32 init_reflist_pf0:5;
+		u32 init_reflist_pf1:5;
+		u32 init_reflist_pf2:5;
+		u32 init_reflist_pf3:5;
+		u32 reserved0:12;
+	} sw106;
+
+	struct {
+		u32 refpic_term_flag:32;
+	} sw107;
+
+	struct {
+		u32 refpic_valid_flag:32;
+	} sw108;
+
+	struct {
+		u32 strm_start_bit:6;
+		u32 reserved0:26;
+	} sw109;
+
+	struct {
+		u32 pic_mb_w:9;
+		u32 pic_mb_h:8;
+		u32 flt_offset_cb_qp:5;
+		u32 flt_offset_cr_qp:5;
+		u32 reserved0:5;
+	} sw110;
+
+	struct {
+		u32 max_refnum:5;
+		u32 reserved0:11;
+		u32 wp_bslice_sel:2;
+		u32 reserved1:14;
+	} sw111;
+
+	struct {
+		u32 curfrm_num:16;
+		u32 cur_frm_len:5;
+		u32 reserved0:9;
+		u32 rpcp_flag:1;
+		u32 dblk_ctrl_flag:1;
+	} sw112;
+
+	struct {
+		u32 idr_pic_id:16;
+		u32 refpic_mk_len:11;
+		u32 reserved0:5;
+	} sw113;
+
+	struct {
+		u32 poc_field_len:8;
+		u32 reserved0:6;
+		u32 max_refidx0:5;
+		u32 max_refidx1:5;
+		u32 pps_id:5;
+	} sw114;
+
+	struct {
+		u32 fieldpic_flag_exist:1;
+		u32 scl_matrix_en:1;
+		u32 tranf_8x8_flag_en:1;
+		u32 const_intra_en:1;
+		u32 weight_pred_en:1;
+		u32 cabac_en:1;
+		u32 monochr_en:1;
+		u32 dlmv_method_en:1;
+		u32 idr_pic_flag:1;
+		u32 reserved0:23;
+	} sw115;
+
+	/* Not used */
+	u32 sw116_119[4];
+
+	union {
+		struct {
+			u32 pic_refer_flag:1;
+			u32 reserved0:10;
+		} avs;
+
+		struct {
+			u32 pic_mb_w_ext:3;
+			u32 pic_mb_h_ext:3;
+			u32 reserved0:1;
+			u32 mb_height_off:4;
+		} vc1;
+
+		struct {
+			u32 ref_frames:5;
+			u32 reserved0:6;
+		} h264;
+
+		struct {
+			u32 ref_frames:5;
+			u32 topfieldfirst_e:1;
+			u32 alt_scan_e:1;
+			u32 reserved0:4;
+		} mpeg;
+
+		struct {
+			u32 pad:11;
+			u32 pic_mb_height_p:8;
+			/* this register is only used by VC-1 */
+			u32 mb_width_off:4;
+			u32 pic_mb_width:9;
+		};
+	} sw120 __attribute__ ((packed));
+
+	u32 sw121;
+
+	struct {
+		u32 frame_pred_dct:1;
+		u32 intra_vlc_tab:1;
+		u32 intra_dc_prec:1;
+		u32 con_mv_e:1;
+		u32 reserved0:19;
+		u32 qscale_type:1;
+		u32 reserved1:1;
+		u32 strm_start_bit:6;
+	} sw122;
+
+	u32 sw123;
+	u32 sw124;
+	u32 sw125;
+	u32 sw126;
+	u32 sw127;
+	u32 sw128;
+	u32 sw129;
+	u32 sw130;
+
+	struct {
+		u32 refer0_topc_e:1;
+		u32 refer0_field_e:1;
+		u32 refer0_base:30;
+	} sw131;
+
+	u32 sw132;
+	u32 sw133;
+
+	struct {
+		u32 refer2_topc_e:1;
+		u32 refer2_field_e:1;
+		u32 refer2_base:30;
+	} sw134;
+
+	struct {
+		u32 refer3_topc_e:1;
+		u32 refer3_field_e:1;
+		u32 refer3_base:30;
+	} sw135;
+
+	struct {
+		u32 reserved0:1;
+		u32 mv_accuracy_bwd:1;
+		u32 mv_accuracy_fwd:1;
+		u32 fcode_bwd_ver:4;
+		u32 fcode_bwd_hor:4;
+		u32 fcode_fwd_ver:4;
+		u32 fcode_fwd_hor:4;
+		u32 alt_scan_flag_e:1;
+		u32 reserved1:12;
+	} sw136;
+
+	u32 sw137;
+	u32 sw138;
+	u32 sw139;
+	u32 sw140;
+	u32 sw141;
+	u32 sw142;
+	u32 sw143;
+	u32 sw144;
+	u32 sw145;
+	u32 sw146;
+	u32 sw147;
+
+	struct {
+		u32 refer1_topc_e:1;
+		u32 refer1_field_e:1;
+		u32 refer1_base:30;
+	} sw148;
+
+	u32 sw149_sw158[10];
+} __attribute__((packed));
+
+#endif
-- 
2.20.1



