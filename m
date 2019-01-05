Return-Path: <SRS0=yUb4=PN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA6CC43387
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 18:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B572232D
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 18:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbfAESmW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:42:22 -0500
Received: from kozue.soulik.info ([108.61.200.231]:40296 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfAESmW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2019 13:42:22 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:a00])
        by kozue.soulik.info (Postfix) with ESMTPA id F3F72101714;
        Sun,  6 Jan 2019 03:32:39 +0900 (JST)
From:   Randy Li <ayaka@soulik.info>
To:     linux-rockchip@lists.infradead.org
Cc:     Randy Li <ayaka@soulik.info>, nicolas.dufresne@collabora.com,
        myy@miouyouyou.fr, paul.kocialkowski@bootlin.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: video: rockchip: video codec for vendor API
Date:   Sun,  6 Jan 2019 02:31:47 +0800
Message-Id: <20190105183150.20266-2-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190105183150.20266-1-ayaka@soulik.info>
References: <20190105183150.20266-1-ayaka@soulik.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 drivers/staging/rockchip-mpp/Kconfig          |  52 +
 drivers/staging/rockchip-mpp/Makefile         |  16 +
 drivers/staging/rockchip-mpp/mpp_debug.h      |  87 ++
 drivers/staging/rockchip-mpp/mpp_dev_common.c | 971 ++++++++++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_common.h | 219 ++++
 drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c | 856 +++++++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_vdpu1.c  | 615 +++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c  | 577 +++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_vepu1.c  | 481 +++++++++
 drivers/staging/rockchip-mpp/mpp_dev_vepu2.c  | 478 +++++++++
 drivers/staging/rockchip-mpp/mpp_iommu_dma.c  | 292 ++++++
 drivers/staging/rockchip-mpp/mpp_iommu_dma.h  |  42 +
 drivers/staging/rockchip-mpp/mpp_service.c    | 197 ++++
 drivers/staging/rockchip-mpp/mpp_service.h    |  38 +
 include/uapi/video/rk_vpu_service.h           | 101 ++
 15 files changed, 5022 insertions(+)
 create mode 100644 drivers/staging/rockchip-mpp/Kconfig
 create mode 100644 drivers/staging/rockchip-mpp/Makefile
 create mode 100644 drivers/staging/rockchip-mpp/mpp_debug.h
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.h
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_vdpu1.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_vepu1.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_vepu2.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_iommu_dma.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_iommu_dma.h
 create mode 100644 drivers/staging/rockchip-mpp/mpp_service.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_service.h
 create mode 100644 include/uapi/video/rk_vpu_service.h

diff --git a/drivers/staging/rockchip-mpp/Kconfig b/drivers/staging/rockchip-mpp/Kconfig
new file mode 100644
index 000000000000..691ddc3bcd14
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/Kconfig
@@ -0,0 +1,52 @@
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
+config ROCKCHIP_MPP_VDPU1_DEVICE
+	tristate "VPU decoder v1 device driver"
+	depends on ROCKCHIP_MPP_DEVICE
+	default n
+	help
+	  rockchip mpp vpu decoder v1.
+
+config ROCKCHIP_MPP_VEPU1_DEVICE
+	tristate "VPU encoder v1 device driver"
+	depends on ROCKCHIP_MPP_DEVICE
+	default n
+	help
+	  rockchip mpp vpu encoder v1.
+
+config ROCKCHIP_MPP_VDPU2_DEVICE
+	tristate "VPU decoder v2 device driver"
+	depends on ROCKCHIP_MPP_DEVICE
+	default n
+	help
+	  rockchip mpp vpu decoder v2.
+
+config ROCKCHIP_MPP_VEPU2_DEVICE
+	tristate "VPU encoder v2 device driver"
+	depends on ROCKCHIP_MPP_DEVICE
+	default n
+	help
+	  rockchip mpp vpu encoder v2.
+endmenu
diff --git a/drivers/staging/rockchip-mpp/Makefile b/drivers/staging/rockchip-mpp/Makefile
new file mode 100644
index 000000000000..06a9c58c92cb
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/Makefile
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+rk-mpp-service-objs := mpp_service.o
+rk-mpp-device-objs := mpp_dev_common.o mpp_iommu_dma.o
+rk-mpp-vdec-objs := mpp_dev_rkvdec.o
+rk-mpp-vdpu1-objs := mpp_dev_vdpu1.o
+rk-mpp-vdpu2-objs := mpp_dev_vdpu2.o
+rk-mpp-vepu1-objs := mpp_dev_vepu1.o
+rk-mpp-vepu2-objs := mpp_dev_vepu2.o
+
+obj-$(CONFIG_ROCKCHIP_MPP_SERVICE) += rk-mpp-service.o
+obj-$(CONFIG_ROCKCHIP_MPP_DEVICE) += rk-mpp-device.o
+obj-$(CONFIG_ROCKCHIP_MPP_VDEC_DEVICE) += rk-mpp-vdec.o
+obj-$(CONFIG_ROCKCHIP_MPP_VDPU1_DEVICE) += rk-mpp-vdpu1.o
+obj-$(CONFIG_ROCKCHIP_MPP_VEPU1_DEVICE) += rk-mpp-vepu1.o
+obj-$(CONFIG_ROCKCHIP_MPP_VDPU2_DEVICE) += rk-mpp-vdpu2.o
+obj-$(CONFIG_ROCKCHIP_MPP_VEPU2_DEVICE) += rk-mpp-vepu2.o
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
index 000000000000..159aa5d244ce
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_common.c
@@ -0,0 +1,971 @@
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
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_irq.h>
+#include <linux/pm_runtime.h>
+#include <linux/poll.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <video/rk_vpu_service.h>
+
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+#include "mpp_iommu_dma.h"
+#include "mpp_service.h"
+
+#define MPP_TIMEOUT_DELAY		(2000)
+
+#define MPP_SESSION_MAX_DONE_TASK	(20)
+
+#ifdef CONFIG_COMPAT
+struct compat_mpp_request {
+	compat_uptr_t req;
+	u32 size;
+};
+#endif
+
+static struct class *mpp_device_class;
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "bit switch for mpp device debug information");
+
+static void *mpp_fd_to_mem_region(struct rockchip_mpp_dev *mpp_dev,
+				  struct mpp_dma_session *dma, int fd)
+{
+	struct mpp_mem_region *mem_region = NULL;
+	dma_addr_t iova;
+
+	if (fd <= 0 || !dma || !mpp_dev)
+		return ERR_PTR(-EINVAL);
+
+	read_lock(&mpp_dev->resource_rwlock);
+	iova = mpp_dma_import_fd(dma, fd);
+	read_unlock(&mpp_dev->resource_rwlock);
+	if (IS_ERR_VALUE(iova)) {
+		mpp_err("can't access dma-buf %d\n", fd);
+		return ERR_PTR(-EINVAL);
+	}
+
+	mem_region = kzalloc(sizeof(*mem_region), GFP_KERNEL);
+	if (!mem_region) {
+		read_lock(&mpp_dev->resource_rwlock);
+		mpp_dma_release_fd(dma, fd);
+		read_unlock(&mpp_dev->resource_rwlock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	mem_region->hdl = (void *)(long)fd;
+	mem_region->iova = iova;
+
+	return mem_region;
+}
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
+	kfifo_in(&session->done_fifo, &task, 1);
+	wake_up(&session->wait);
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
+	mpp_dev = task->session->mpp;
+
+	mpp_debug_time_diff(task);
+
+	if (mpp_dev->ops->finish)
+		mpp_dev->ops->finish(mpp_dev, task);
+
+	atomic_dec(&task->session->task_running);
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
+	struct rockchip_mpp_dev *mpp_dev = session->mpp;
+
+	if (mpp_dev->ops->free_task)
+		mpp_dev->ops->free_task(session, task);
+	return 0;
+}
+
+struct mpp_mem_region *mpp_dev_task_attach_fd(struct mpp_task *task, int fd)
+{
+	struct mpp_mem_region *mem_region = NULL;
+
+	mem_region = mpp_fd_to_mem_region(task->session->mpp,
+					  task->session->dma, fd);
+	if (IS_ERR(mem_region))
+		return mem_region;
+
+	INIT_LIST_HEAD(&mem_region->reg_lnk);
+	list_add_tail(&mem_region->reg_lnk, &task->mem_region_list);
+
+	return mem_region;
+}
+EXPORT_SYMBOL(mpp_dev_task_attach_fd);
+
+int mpp_reg_address_translate(struct rockchip_mpp_dev *mpp,
+			      struct mpp_task *task, int fmt, u32 *reg)
+{
+	struct mpp_trans_info *trans_info = mpp->variant->trans_info;
+	const u8 *tbl = trans_info[fmt].table;
+	int size = trans_info[fmt].count;
+	int i;
+
+	mpp_debug_enter();
+	for (i = 0; i < size; i++) {
+		struct mpp_mem_region *mem_region = NULL;
+		int usr_fd = reg[tbl[i]] & 0x3FF;
+		int offset = reg[tbl[i]] >> 10;
+
+		if (usr_fd == 0)
+			continue;
+
+		mem_region = mpp_dev_task_attach_fd(task, usr_fd);
+		if (IS_ERR(mem_region)) {
+			mpp_debug(DEBUG_IOMMU, "reg[%3d]: %08x failed\n",
+				  tbl[i], reg[tbl[i]]);
+			return PTR_ERR(mem_region);
+		}
+
+		mem_region->reg_idx = tbl[i];
+		mpp_debug(DEBUG_IOMMU, "reg[%3d]: %3d => %pad + offset %10d\n",
+			  tbl[i], usr_fd, &mem_region->iova, offset);
+		reg[tbl[i]] = mem_region->iova + offset;
+	}
+
+	mpp_debug_leave();
+
+	return 0;
+}
+EXPORT_SYMBOL(mpp_reg_address_translate);
+
+void mpp_translate_extra_info(struct mpp_task *task,
+			      struct extra_info_for_iommu *ext_inf,
+			      u32 *reg)
+{
+	mpp_debug_enter();
+	if (ext_inf) {
+		int i;
+
+		if (ext_inf->magic != EXTRA_INFO_MAGIC)
+			return;
+
+		for (i = 0; i < ext_inf->cnt; i++) {
+			mpp_debug(DEBUG_IOMMU, "reg[%d] + offset %d\n",
+				  ext_inf->elem[i].index,
+				  ext_inf->elem[i].offset);
+			reg[ext_inf->elem[i].index] += ext_inf->elem[i].offset;
+		}
+	}
+	mpp_debug_leave();
+}
+EXPORT_SYMBOL(mpp_translate_extra_info);
+
+int mpp_dev_task_init(struct mpp_session *session, struct mpp_task *task)
+{
+	INIT_LIST_HEAD(&task->session_link);
+	INIT_LIST_HEAD(&task->service_link);
+	INIT_LIST_HEAD(&task->mem_region_list);
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
+	mpp_dev = session->mpp;
+	queue_work(mpp_dev->irq_workq, &task->work);
+}
+EXPORT_SYMBOL(mpp_dev_task_finish);
+
+void mpp_dev_task_finalize(struct mpp_session *session, struct mpp_task *task)
+{
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+	struct mpp_mem_region *mem_region = NULL, *n;
+
+	mpp_dev = session->mpp;
+	/* release memory region attach to this registers table. */
+	list_for_each_entry_safe(mem_region, n,
+				 &task->mem_region_list, reg_lnk) {
+		read_lock(&mpp_dev->resource_rwlock);
+		mpp_dma_release_fd(session->dma, (long)mem_region->hdl);
+		read_unlock(&mpp_dev->resource_rwlock);
+		list_del_init(&mem_region->reg_lnk);
+		kfree(mem_region);
+	}
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
+static void mpp_dev_reset(struct rockchip_mpp_dev *mpp_dev)
+{
+	mpp_debug_enter();
+
+	/* FIXME lock resource lock of the other devices in combo */
+	write_lock(&mpp_dev->resource_rwlock);
+	atomic_set(&mpp_dev->reset_request, 0);
+
+	mpp_iommu_detach(mpp_dev->iommu_info);
+	mpp_dev->ops->reset(mpp_dev);
+	mpp_iommu_attach(mpp_dev->iommu_info);
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
+	/*
+	 * In the link table mode, the prepare function of the device
+	 * will check whether I can insert a new task into device.
+	 * If the device supports the task status query(like the HEVC
+	 * encoder), it can report whether the device is busy.
+	 * If the device doesn't support multiple task or task status
+	 * query, leave this job to mpp service.
+	 */
+	if (mpp_dev->ops->prepare)
+		ret = mpp_dev->ops->prepare(mpp_dev, task);
+	if (ret == -EINVAL)
+		mpp_srv_wait_to_run(mpp_dev->srv, task);
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
+			       struct mpp_task *task, u32 __user *dst, u32 size)
+{
+	mpp_debug_enter();
+
+	if (!mpp_dev || !task)
+		return -EINVAL;
+
+	if (mpp_dev->ops->result)
+		mpp_dev->ops->result(mpp_dev, task, dst, size);
+
+	mpp_dev_free_task(task->session, task);
+
+	mpp_debug_leave();
+	return 0;
+}
+
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
+	mpp = session->mpp;
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
+#ifdef CONFIG_COMPAT
+
+#define VPU_IOC_SET_CLIENT_TYPE32          _IOW(VPU_IOC_MAGIC, 1, u32)
+#define VPU_IOC_GET_HW_FUSE_STATUS32       _IOW(VPU_IOC_MAGIC, 2, \
+						compat_ulong_t)
+#define VPU_IOC_SET_REG32                  _IOW(VPU_IOC_MAGIC, 3, \
+						compat_ulong_t)
+#define VPU_IOC_GET_REG32                  _IOW(VPU_IOC_MAGIC, 4, \
+						compat_ulong_t)
+#define VPU_IOC_PROBE_IOMMU_STATUS32       _IOR(VPU_IOC_MAGIC, 5, u32)
+
+static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret = -ENOIOCTLCMD;
+
+	if (file->f_op->unlocked_ioctl)
+		ret = file->f_op->unlocked_ioctl(file, cmd, arg);
+
+	return ret;
+}
+
+long mpp_dev_compat_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	struct vpu_request req;
+	void __user *up = compat_ptr(arg);
+	int compatible_arg = 1;
+	long err = 0;
+
+	mpp_debug_enter();
+	mpp_debug(DEBUG_IOCTL, "cmd %x, VPU_IOC_SET_CLIENT_TYPE32 %x\n", cmd,
+		  (u32)VPU_IOC_SET_CLIENT_TYPE32);
+	/* First, convert the command. */
+	switch (cmd) {
+	case VPU_IOC_SET_CLIENT_TYPE32:
+		cmd = VPU_IOC_SET_CLIENT_TYPE;
+		break;
+	case VPU_IOC_GET_HW_FUSE_STATUS32:
+		cmd = VPU_IOC_GET_HW_FUSE_STATUS;
+		break;
+	case VPU_IOC_SET_REG32:
+		cmd = VPU_IOC_SET_REG;
+		break;
+	case VPU_IOC_GET_REG32:
+		cmd = VPU_IOC_GET_REG;
+		break;
+	case VPU_IOC_PROBE_IOMMU_STATUS32:
+		cmd = VPU_IOC_PROBE_IOMMU_STATUS;
+		break;
+	}
+	switch (cmd) {
+	case VPU_IOC_SET_REG:
+	case VPU_IOC_GET_REG:
+	case VPU_IOC_GET_HW_FUSE_STATUS: {
+		compat_uptr_t req_ptr;
+		struct compat_mpp_request __user *req32 = NULL;
+
+		req32 = (struct compat_mpp_request __user *)up;
+		memset(&req, 0, sizeof(req));
+
+		if (get_user(req_ptr, &req32->req) ||
+		    get_user(req.size, &req32->size)) {
+			mpp_err("error: compat get hw status copy_from_user failed\n");
+			return -EFAULT;
+		}
+		req.req = compat_ptr(req_ptr);
+		compatible_arg = 0;
+	} break;
+	}
+
+	if (compatible_arg) {
+		err = native_ioctl(file, cmd, (unsigned long)up);
+	} else {
+		mm_segment_t old_fs = get_fs();
+
+		set_fs(KERNEL_DS);
+		err = native_ioctl(file, cmd, (unsigned long)&req);
+		set_fs(old_fs);
+	}
+
+	mpp_debug_leave();
+	return err;
+}
+EXPORT_SYMBOL(mpp_dev_compat_ioctl);
+#endif
+
+static int mpp_dev_open(struct inode *inode, struct file *filp)
+{
+	struct rockchip_mpp_dev *mpp = container_of(inode->i_cdev,
+						    struct rockchip_mpp_dev,
+						    mpp_cdev);
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
+	session->mpp = mpp;
+	mutex_init(&session->lock);
+	INIT_LIST_HEAD(&session->pending);
+	init_waitqueue_head(&session->wait);
+	error = kfifo_alloc(&session->done_fifo, MPP_SESSION_MAX_DONE_TASK,
+			    GFP_KERNEL);
+	if (error < 0) {
+		kfree(session);
+		return -ENOMEM;
+	}
+
+	atomic_set(&session->task_running, 0);
+	session->dma = mpp_dma_session_create(mpp->dev);
+	INIT_LIST_HEAD(&session->list_session);
+	filp->private_data = (void *)session;
+
+	mpp_dev_power_on(mpp);
+	mpp_debug_leave();
+
+	return nonseekable_open(inode, filp);
+}
+
+static int mpp_dev_release(struct inode *inode, struct file *filp)
+{
+	struct rockchip_mpp_dev *mpp = container_of(inode->i_cdev,
+						    struct rockchip_mpp_dev,
+						    mpp_cdev);
+	int task_running;
+	struct mpp_session *session = filp->private_data;
+
+	mpp_debug_enter();
+	if (!session)
+		return -EINVAL;
+
+	task_running = atomic_read(&session->task_running);
+	if (task_running) {
+		pr_err("session %d still has %d task running when closing\n",
+		       session->pid, task_running);
+		msleep(50);
+	}
+	wake_up(&session->wait);
+
+	/* remove this filp from the asynchronusly notified filp's */
+	mpp_dev_session_clear(mpp, session);
+
+	read_lock(&session->mpp->resource_rwlock);
+	mpp_dma_destroy_session(session->dma);
+	read_unlock(&session->mpp->resource_rwlock);
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
+static const struct file_operations mpp_dev_default_fops = {
+	.unlocked_ioctl = mpp_dev_ioctl,
+	.open		= mpp_dev_open,
+	.release	= mpp_dev_release,
+	.poll		= mpp_dev_poll,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = mpp_dev_compat_ioctl,
+#endif
+};
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
+/* The device will do more probing work after this */
+int mpp_dev_common_probe(struct rockchip_mpp_dev *mpp_dev,
+			 struct platform_device *pdev,
+			 struct mpp_dev_ops *ops)
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
+	pm_runtime_enable(dev);
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
+	pm_runtime_get_sync(dev);
+	/*
+	 * TODO: here or at the device itself, some device doesn't
+	 * have the iommu, maybe in the device is better.
+	 */
+	mpp_dev->iommu_info = mpp_iommu_probe(dev);
+	if (IS_ERR(mpp_dev->iommu_info)) {
+		dev_err(dev, "failed to attach iommu: %ld\n",
+			PTR_ERR(mpp_dev->iommu_info));
+	}
+
+	pm_runtime_put(dev);
+
+	return 0;
+
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
+			  const char *node_name, const void *fops)
+{
+	struct device *dev = mpp_dev->dev;
+	int ret = 0;
+
+	/* create a device node */
+	ret = alloc_chrdev_region(&mpp_dev->dev_id, 0, 1, node_name);
+	if (ret) {
+		dev_err(dev, "alloc dev_t failed\n");
+		return ret;
+	}
+
+	if (fops)
+		cdev_init(&mpp_dev->mpp_cdev, fops);
+	else
+		cdev_init(&mpp_dev->mpp_cdev, &mpp_dev_default_fops);
+	mpp_dev->mpp_cdev.owner = THIS_MODULE;
+
+	ret = cdev_add(&mpp_dev->mpp_cdev, mpp_dev->dev_id, 1);
+	if (ret) {
+		unregister_chrdev_region(mpp_dev->dev_id, 1);
+		dev_err(dev, "add device node failed\n");
+		return ret;
+	}
+
+	device_create(mpp_device_class, dev, mpp_dev->dev_id, NULL, "%s",
+		      node_name);
+
+	return 0;
+}
+EXPORT_SYMBOL(mpp_dev_register_node);
+
+int mpp_dev_common_remove(struct rockchip_mpp_dev *mpp_dev)
+{
+	destroy_workqueue(mpp_dev->irq_workq);
+
+	device_destroy(mpp_device_class, mpp_dev->dev_id);
+	cdev_del(&mpp_dev->mpp_cdev);
+	unregister_chrdev_region(mpp_dev->dev_id, 1);
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
+		do_gettimeofday(&task->start);
+}
+EXPORT_SYMBOL(mpp_debug_time_record);
+
+void mpp_debug_time_diff(struct mpp_task *task)
+{
+	struct timeval end;
+
+	do_gettimeofday(&end);
+	mpp_debug(DEBUG_TIMING, "time: %ld us\n",
+		  (end.tv_sec  - task->start.tv_sec)  * 1000000 +
+		  (end.tv_usec - task->start.tv_usec));
+}
+EXPORT_SYMBOL(mpp_debug_time_diff);
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
index 000000000000..8a7dc7444dc3
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_common.h
@@ -0,0 +1,219 @@
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
+#include <linux/cdev.h>
+#include <linux/dma-buf.h>
+#include <linux/kfifo.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <linux/reset.h>
+
+#include "mpp_service.h"
+
+#define MPP_IOC_CUSTOM_BASE			0x1000
+
+#define EXTRA_INFO_MAGIC			(0x4C4A46)
+#define JPEG_IOC_EXTRA_SIZE			(48)
+
+struct mpp_trans_info {
+	const int count;
+	const char * const table;
+};
+
+struct extra_info_elem {
+	u32 index;
+	u32 offset;
+};
+
+struct extra_info_for_iommu {
+	u32 magic;
+	u32 cnt;
+	struct extra_info_elem elem[20];
+};
+
+struct mpp_dev_variant {
+	u32 reg_len;
+	struct mpp_trans_info *trans_info;
+	const char *node_name;
+	u32 version_bit;
+};
+
+struct mpp_mem_region {
+	struct list_head srv_lnk;
+	struct list_head reg_lnk;
+	struct list_head session_lnk;
+	/* virtual address for iommu */
+	dma_addr_t iova;
+	unsigned long len;
+	u32 reg_idx;
+	void *hdl;
+};
+
+/* Definition in dma file */
+struct mpp_dma_session;
+/* Definition in mpp service file */
+struct mpp_service;
+
+struct rockchip_mpp_dev {
+	struct device *dev;
+
+	const struct mpp_dev_variant *variant;
+	struct mpp_dev_ops *ops;
+
+	void __iomem *reg_base;
+	int irq;
+	struct workqueue_struct *irq_workq;
+
+	struct mpp_iommu_info *iommu_info;
+	rwlock_t resource_rwlock;
+	atomic_t reset_request;
+
+	struct cdev mpp_cdev;
+	dev_t dev_id;
+
+	/* MPP Service */
+	struct mpp_service_node *srv;
+};
+
+struct mpp_task;
+
+struct mpp_session {
+	/* the session related device private data */
+	struct rockchip_mpp_dev *mpp;
+	/* a linked list of data so we can access them for debugging */
+	struct list_head list_session;
+	struct mpp_dma_session *dma;
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
+	/* The DMA buffer used in this task */
+	struct list_head mem_region_list;
+	struct work_struct work;
+
+	/* record context running start time */
+	struct timeval start;
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
+struct mpp_mem_region *mpp_dev_task_attach_fd(struct mpp_task *task, int fd);
+int mpp_reg_address_translate(struct rockchip_mpp_dev *data,
+			      struct mpp_task *task, int fmt, u32 *reg);
+void mpp_translate_extra_info(struct mpp_task *task,
+			      struct extra_info_for_iommu *ext_inf,
+			      u32 *reg);
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
+/* It can handle the default ioctl */
+long mpp_dev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+long mpp_dev_compat_ioctl(struct file *filp, unsigned int cmd,
+			  unsigned long arg);
+#endif
+
+int mpp_dev_common_probe(struct rockchip_mpp_dev *mpp_dev,
+			 struct platform_device *pdev,
+			 struct mpp_dev_ops *ops);
+int mpp_dev_register_node(struct rockchip_mpp_dev *mpp_dev,
+			  const char *node_name, const void *fops);
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
+			      unsigned long offset, void *buffer,
+			      unsigned long count);
+
+void mpp_dev_write(struct rockchip_mpp_dev *mpp, u32 val, u32 reg);
+
+void mpp_dev_read_seq(struct rockchip_mpp_dev *mpp_dev,
+			     unsigned long offset, void *buffer,
+			     unsigned long count);
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
index 000000000000..a3da27cfc10e
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c
@@ -0,0 +1,856 @@
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
+#include <linux/rockchip/rockchip_sip.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <soc/rockchip/pm_domains.h>
+
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+#include "mpp_iommu_dma.h"
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
+#define MPP_ALIGN_SIZE	0x1000
+
+#define MHZ		(1000 * 1000)
+#define DEF_ACLK	400
+#define DEF_CORE	250
+#define DEF_CABAC	300
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
+	u32 strm_base;
+	u32 irq_status;
+};
+
+/*
+ * file handle translate information
+ */
+static const char trans_tbl_h264d[] = {
+	4, 6, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
+	23, 24, 41, 42, 43, 48, 75
+};
+
+static const char trans_tbl_h265d[] = {
+	4, 6, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
+	23, 24, 42, 43
+};
+
+static const char trans_tbl_vp9d[] = {
+	4, 6, 7, 11, 12, 13, 14, 15, 16
+};
+
+static struct mpp_trans_info trans_rk_hevcdec[] = {
+	[RKVDEC_FMT_H265D] = {
+		.count = sizeof(trans_tbl_h265d),
+		.table = trans_tbl_h265d,
+	},
+};
+
+static struct mpp_trans_info trans_rkvdec[] = {
+	[RKVDEC_FMT_H265D] = {
+		.count = sizeof(trans_tbl_h265d),
+		.table = trans_tbl_h265d,
+	},
+	[RKVDEC_FMT_H264D] = {
+		.count = sizeof(trans_tbl_h264d),
+		.table = trans_tbl_h264d,
+	},
+	[RKVDEC_FMT_VP9D] = {
+		.count = sizeof(trans_tbl_vp9d),
+		.table = trans_tbl_vp9d,
+	},
+};
+
+static const struct mpp_dev_variant rkvdec_v1_data = {
+	.reg_len = 76,
+	.trans_info = trans_rkvdec,
+	.node_name = RKVDEC_NODE_NAME,
+	.version_bit = BIT(0),
+};
+
+static const struct mpp_dev_variant rkvdec_v1p_data = {
+	.reg_len = 76,
+	.trans_info = trans_rkvdec,
+	.node_name = RKVDEC_NODE_NAME,
+	.version_bit = RKVDEC_VER_RK3328_BIT,
+};
+
+
+static const struct mpp_dev_variant rk_hevcdec_data = {
+	.reg_len = 48,
+	.trans_info = trans_rk_hevcdec,
+	.node_name = RK_HEVCDEC_NODE_NAME,
+	.version_bit = BIT(0),
+};
+
+static void *rockchip_rkvdec_get_drv_data(struct platform_device *pdev);
+
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
+	dev = task->mpp_task.session->mpp->dev;
+	if (!dev)
+		return -EINVAL;
+
+	dmabuf = dma_buf_get(fd);
+	if (IS_ERR_OR_NULL(dmabuf)) {
+		dev_err(dev, "invliad pps buffer\n");
+		return -ENOENT;
+	}
+
+	ret = dma_buf_begin_cpu_access(dmabuf, 0, dmabuf->size,
+				       DMA_FROM_DEVICE);
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
+	dma_buf_end_cpu_access(dmabuf, 0, dmabuf->size, DMA_FROM_DEVICE);
+	dma_buf_put(dmabuf);
+
+	return ret;
+}
+
+static void *rockchip_mpp_rkvdec_alloc_task(struct mpp_session *session,
+					    void __user *src, u32 size)
+{
+	struct rkvdec_task *task = NULL;
+	u32 reg_len;
+	u32 fmt = 0;
+	u32 dwsize = size / sizeof(u32);
+	int pps_fd;
+	u32 pps_offset;
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
+	reg_len = dwsize > ROCKCHIP_RKVDEC_REG_NUM ?
+		ROCKCHIP_RKVDEC_REG_NUM : dwsize;
+
+	if (copy_from_user(task->reg, src, reg_len * 4)) {
+		mpp_err("error: copy_from_user failed in reg_init\n");
+		err = -EFAULT;
+		goto fail;
+	}
+
+	fmt = RKVDEC_GET_FORMAT(task->reg[RKVDEC_REG_SYS_CTRL_INDEX]);
+	/*
+	 * special offset scale case
+	 *
+	 * This translation is for fd + offset translation.
+	 * One register has 32bits. We need to transfer both buffer file
+	 * handle and the start address offset so we packet file handle
+	 * and offset together using below format.
+	 *
+	 *  0~9  bit for buffer file handle range 0 ~ 1023
+	 * 10~31 bit for offset range 0 ~ 4M
+	 *
+	 * But on 4K case the offset can be larger the 4M
+	 * So on VP9 4K decoder colmv base we scale the offset by 16
+	 */
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
+
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
+		mpp_debug(DEBUG_PPS_FILL,
+			  "scaling list filling parameter:\n");
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
+
+	err = mpp_reg_address_translate(session->mpp, &task->mpp_task, fmt,
+					task->reg);
+	if (err) {
+		mpp_err("error: translate reg address failed.\n");
+
+		if (unlikely(debug & DEBUG_DUMP_ERR_REG))
+			mpp_debug_dump_reg_mem(task->reg,
+					       ROCKCHIP_RKVDEC_REG_NUM);
+		goto fail;
+	}
+
+	task->strm_base = task->reg[RKVDEC_REG_STREAM_RLC_BASE_INDEX];
+
+	mpp_debug_leave();
+
+	return &task->mpp_task;
+
+fail:
+	mpp_dev_task_finalize(session, &task->mpp_task);
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
+			| RKVDEC_CACHE_PERMIT_READ_ALLOCATE;
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
+	case RKVDEC_STATE_NORMAL: {
+		mpp_dev_read_seq(mpp_dev, RKVDEC_REG_SYS_CTRL,
+				 &task->reg[RKVDEC_REG_SYS_CTRL_INDEX],
+				 mpp_dev->variant->reg_len
+				 - RKVDEC_REG_SYS_CTRL_INDEX);
+		task->reg[RKVDEC_REG_DEC_INT_EN_INDEX] = task->irq_status;
+	} break;
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
+				      u32 __user *dst, u32 size)
+{
+	struct rkvdec_task *task = to_rkvdec_task(mpp_task);
+
+	/* FIXME may overflow the kernel */
+	if (copy_to_user(dst, task->reg, size)) {
+		mpp_err("copy_to_user failed\n");
+		return -EIO;
+	}
+
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
+			| RKVDEC_INT_BUS_ERROR
+			| RKVDEC_INT_COLMV_REF_ERROR
+			| RKVDEC_INT_STRM_ERROR
+			| RKVDEC_INT_TIMEOUT;
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
+	/* TODO: use devm_reset_control_get_share() instead */
+	dec_dev->rst_a = devm_reset_control_get(mpp_dev->dev, "video_a");
+	dec_dev->rst_h = devm_reset_control_get(mpp_dev->dev, "video_h");
+	dec_dev->rst_core = devm_reset_control_get(mpp_dev->dev, "video_core");
+	/* The reset controller below are not shared with VPU */
+	dec_dev->rst_niu_a = devm_reset_control_get(mpp_dev->dev, "niu_a");
+	dec_dev->rst_niu_h = devm_reset_control_get(mpp_dev->dev, "niu_h");
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
+static struct mpp_dev_ops rkvdec_rk3328_ops = {
+	.alloc_task = rockchip_mpp_rkvdec_alloc_task,
+	.prepare = rockchip_mpp_rkvdec_prepare,
+	.run = rockchip_mpp_rkvdec_run,
+	.finish = rockchip_mpp_rkvdec_finish,
+	.result = rockchip_mpp_rkvdec_result,
+	.free_task = rockchip_mpp_rkvdec_free_task,
+	.reset = rockchip_mpp_rkvdec_sip_reset,
+};
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
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name, NULL);
+	if (ret)
+		dev_err(dev, "register char device failed: %d\n", ret);
+
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
+	{ .compatible = "rockchip,video-decoder-v1p", .data = &rkvdec_v1p_data},
+	{ .compatible = "rockchip,video-decoder-v1", .data = &rkvdec_v1_data},
+	{ .compatible = "rockchip,hevc-decoder-v1", .data = &rk_hevcdec_data},
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
+		match = of_match_node(mpp_rkvdec_dt_match,
+				      pdev->dev.of_node);
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
+		.name = RKVDEC_DRIVER_NAME,
+		.of_match_table = of_match_ptr(mpp_rkvdec_dt_match),
+	},
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
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vdpu1.c b/drivers/staging/rockchip-mpp/mpp_dev_vdpu1.c
new file mode 100644
index 000000000000..4371a1a6080b
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vdpu1.c
@@ -0,0 +1,615 @@
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
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+
+#define RKVDPU1_DRIVER_NAME		"mpp_vdpu1"
+#define RKVDPU1_NODE_NAME		"vpu-service"
+
+#define RKAVSD1_NODE_NAME		"avsd"
+
+/* The maximum registers number of all the version */
+#define ROCKCHIP_VDPU1_REG_NUM			108
+
+#define RKVDPU1_REG_DEC_INT_EN			0x004
+#define RKVDPU1_REG_DEC_INT_EN_INDEX		(1)
+/* B slice detected, used in 8190 decoder and later */
+#define		RKVDPU1_INT_PIC_INF		BIT(24)
+#define		RKVDPU1_INT_TIMEOUT		BIT(18)
+#define		RKVDPU1_INT_SLICE		BIT(17)
+#define		RKVDPU1_INT_STRM_ERROR		BIT(16)
+#define		RKVDPU1_INT_ASO_ERROR		BIT(15)
+#define		RKVDPU1_INT_BUF_EMPTY		BIT(14)
+#define		RKVDPU1_INT_BUS_ERROR		BIT(13)
+#define		RKVDPU1_DEC_INT			BIT(12)
+#define		RKVDPU1_DEC_INT_RAW		BIT(8)
+#define		RKVDPU1_DEC_IRQ_DIS		BIT(4)
+#define		RKVDPU1_DEC_START		BIT(0)
+
+#define RKVDPU1_REG_DEC_DEV_CTRL		0x008
+#define RKVDPU1_REG_DEC_DEV_CTRL_INDEX		(2)
+/* NOTE: Don't enable it or decoding AVC would meet problem at rk3288 */
+#define		RKVDPU1_CLOCK_GATE_EN		BIT(10)
+
+#define RKVDPU1_REG_SYS_CTRL			0x00c
+#define RKVDPU1_REG_SYS_CTRL_INDEX		(3)
+#define		RKVDPU1_GET_FORMAT(x)		(((x) >> 28) & 0xf)
+#define		RKVDPU1_FMT_H264D		0
+#define		RKVDPU1_FMT_MPEG4D		1
+#define		RKVDPU1_FMT_H263D		2
+#define		RKVDPU1_FMT_JPEGD		3
+#define		RKVDPU1_FMT_VC1D		4
+#define		RKVDPU1_FMT_MPEG2D		5
+#define		RKVDPU1_FMT_MPEG1D		6
+#define		RKVDPU1_FMT_VP6D		7
+#define		RKVDPU1_FMT_RESERVED		8
+#define		RKVDPU1_FMT_VP7D		9
+#define		RKVDPU1_FMT_VP8D		10
+#define		RKVDPU1_FMT_AVSD		11
+
+#define RKVDPU1_REG_STREAM_RLC_BASE		0x030
+#define RKVDPU1_REG_STREAM_RLC_BASE_INDEX	(12)
+
+#define RKVDPU1_REG_DIR_MV_BASE			0x0a4
+#define RKVDPU1_REG_DIR_MV_BASE_INDEX		(41)
+
+#define to_rkvdpu_task(ctx)		\
+		container_of(ctx, struct rkvdpu_task, mpp_task)
+#define to_rkvdpu_dev(dev)		\
+		container_of(dev, struct rockchip_rkvdpu_dev, mpp_dev)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "bit switch for vdpu1 debug information");
+
+struct vdpu1_dev_data {
+	struct mpp_dev_variant dec_data;
+	bool pp_support;
+};
+
+struct rockchip_rkvdpu_dev {
+	struct rockchip_mpp_dev mpp_dev;
+	struct vdpu1_dev_data *data;
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
+	u32 reg[ROCKCHIP_VDPU1_REG_NUM];
+	u32 idx;
+	struct extra_info_for_iommu ext_inf;
+
+	u32 strm_base;
+	u32 irq_status;
+};
+
+/*
+ * file handle translate information
+ */
+static const char trans_tbl_avsd[] = {
+	12, 13, 14, 15, 16, 17, 40, 41, 45
+};
+
+static const char trans_tbl_default[] = {
+	12, 13, 14, 15, 16, 17, 40, 41
+};
+
+static const char trans_tbl_jpegd[] = {
+	12, 13, 14, 40, 66, 67
+};
+
+static const char trans_tbl_h264d[] = {
+	12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
+	28, 29, 40
+};
+
+static const char trans_tbl_vc1d[] = {
+	12, 13, 14, 15, 16, 17, 27, 41
+};
+
+static const char trans_tbl_vp6d[] = {
+	12, 13, 14, 18, 27, 40
+};
+
+static const char trans_tbl_vp8d[] = {
+	10, 12, 13, 14, 18, 19, 22, 23, 24, 25, 26, 27, 28, 29, 40
+};
+
+static struct mpp_trans_info trans_rk_vdpu1[] = {
+	[RKVDPU1_FMT_H264D] = {
+		.count = sizeof(trans_tbl_h264d),
+		.table = trans_tbl_h264d,
+	},
+	[RKVDPU1_FMT_MPEG4D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU1_FMT_H263D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU1_FMT_JPEGD] = {
+		.count = sizeof(trans_tbl_jpegd),
+		.table = trans_tbl_jpegd,
+	},
+	[RKVDPU1_FMT_VC1D] = {
+		.count = sizeof(trans_tbl_vc1d),
+		.table = trans_tbl_vc1d,
+	},
+	[RKVDPU1_FMT_MPEG2D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU1_FMT_MPEG1D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU1_FMT_VP6D] = {
+		.count = sizeof(trans_tbl_vp6d),
+		.table = trans_tbl_vp6d,
+	},
+	[RKVDPU1_FMT_RESERVED] = {
+		.count = 0,
+		.table = NULL,
+	},
+	[RKVDPU1_FMT_VP7D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU1_FMT_VP8D] = {
+		.count = sizeof(trans_tbl_vp8d),
+		.table = trans_tbl_vp8d,
+	},
+	[RKVDPU1_FMT_AVSD] = {
+		.count = sizeof(trans_tbl_avsd),
+		.table = trans_tbl_avsd,
+	},
+};
+
+static const struct vdpu1_dev_data vdpu_v1_data = {
+	.dec_data = {
+		/* Exclude the register of the Post Processor */
+		.reg_len = 60,
+		.trans_info = trans_rk_vdpu1,
+		.node_name = RKVDPU1_NODE_NAME,
+	},
+	.pp_support = false,
+};
+
+static const struct vdpu1_dev_data vdpu_pp_v1_data = {
+	.dec_data = {
+		/* Exclude the register of the Performance monitor */
+		.reg_len = 101,
+		.trans_info = trans_rk_vdpu1,
+		.node_name = RKVDPU1_NODE_NAME,
+	},
+	.pp_support = true,
+};
+
+static const struct vdpu1_dev_data vdpu_avs_v1_data = {
+	.dec_data = {
+		/* Exclude the register of the Performance monitor */
+		.reg_len = 101,
+		.trans_info = trans_rk_vdpu1,
+		.node_name = RKAVSD1_NODE_NAME,
+	},
+	.pp_support = true,
+};
+
+static void *rockchip_rkvdpu1_get_drv_data(struct platform_device *pdev);
+
+static void *rockchip_mpp_rkvdpu_alloc_task(struct mpp_session *session,
+					    void __user *src, u32 size)
+{
+	struct rkvdpu_task *task = NULL;
+	u32 reg_len;
+	u32 extinf_len;
+	u32 fmt = 0;
+	u32 dwsize = size / sizeof(u32);
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
+	reg_len = dwsize > ROCKCHIP_VDPU1_REG_NUM ?
+		ROCKCHIP_VDPU1_REG_NUM : dwsize;
+	extinf_len = dwsize > reg_len ? (dwsize - reg_len) * 4 : 0;
+
+	if (copy_from_user(task->reg, src, reg_len * 4)) {
+		mpp_err("error: copy_from_user failed in reg_init\n");
+		err = -EFAULT;
+		goto fail;
+	}
+
+	fmt = RKVDPU1_GET_FORMAT(task->reg[RKVDPU1_REG_SYS_CTRL_INDEX]);
+	if (extinf_len > 0) {
+		if (likely(fmt == RKVDPU1_FMT_JPEGD)) {
+			err = copy_from_user(&task->ext_inf,
+					     (u8 *)src + size
+					     - JPEG_IOC_EXTRA_SIZE,
+					     JPEG_IOC_EXTRA_SIZE);
+		} else {
+			u32 ext_cpy = min_t(size_t, extinf_len,
+					    sizeof(task->ext_inf));
+			err = copy_from_user(&task->ext_inf,
+					     (u32 *)src + reg_len, ext_cpy);
+		}
+
+		if (err) {
+			mpp_err("copy_from_user failed when extra info\n");
+			err = -EFAULT;
+			goto fail;
+		}
+	}
+
+	err = mpp_reg_address_translate(session->mpp, &task->mpp_task, fmt,
+					task->reg);
+	if (err) {
+		mpp_err("error: translate reg address failed.\n");
+
+		if (unlikely(debug & DEBUG_DUMP_ERR_REG))
+			mpp_debug_dump_reg_mem(task->reg,
+					       ROCKCHIP_VDPU1_REG_NUM);
+		goto fail;
+	}
+	/*
+	 * special offset scale case
+	 *
+	 * This translation is for fd + offset translation.
+	 * One register has 32bits. We need to transfer both buffer file
+	 * handle and the start address offset so we packet file handle
+	 * and offset together using below format.
+	 *
+	 *  0~9  bit for buffer file handle range 0 ~ 1023
+	 * 10~31 bit for offset range 0 ~ 4M
+	 *
+	 * But on 4K case the offset can be larger the 4M
+	 */
+	if (likely(fmt == RKVDPU1_FMT_H264D)) {
+		struct mpp_mem_region *mem_region = NULL;
+		dma_addr_t iova = 0;
+		u32 offset = task->reg[RKVDPU1_REG_DIR_MV_BASE_INDEX];
+		int fd = task->reg[RKVDPU1_REG_DIR_MV_BASE_INDEX] & 0x3ff;
+
+		offset = offset >> 10 << 4;
+		mem_region = mpp_dev_task_attach_fd(&task->mpp_task, fd);
+		if (IS_ERR(mem_region)) {
+			err = PTR_ERR(mem_region);
+			goto fail;
+		}
+
+		iova = mem_region->iova;
+		mpp_debug(DEBUG_IOMMU, "DMV[%3d]: %3d => %pad + offset %10d\n",
+			  RKVDPU1_REG_DIR_MV_BASE_INDEX, fd, &iova, offset);
+		task->reg[RKVDPU1_REG_DIR_MV_BASE_INDEX] = iova + offset;
+	}
+
+	task->strm_base = task->reg[RKVDPU1_REG_STREAM_RLC_BASE_INDEX];
+
+	mpp_debug(DEBUG_SET_REG, "extra info cnt %u, magic %08x",
+		  task->ext_inf.cnt, task->ext_inf.magic);
+	mpp_translate_extra_info(&task->mpp_task, &task->ext_inf, task->reg);
+
+	mpp_debug_leave();
+
+	return &task->mpp_task;
+
+fail:
+	mpp_dev_task_finalize(session, &task->mpp_task);
+	kfree(task);
+	return ERR_PTR(err);
+}
+
+static int rockchip_mpp_rkvdpu_prepare(struct rockchip_mpp_dev *mpp_dev,
+				       struct mpp_task *task)
+{
+	return -EINVAL;
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
+
+	mpp_dev_write_seq(mpp_dev, RKVDPU1_REG_DEC_DEV_CTRL,
+			  &task->reg[RKVDPU1_REG_DEC_DEV_CTRL_INDEX],
+			  mpp_dev->variant->reg_len
+			  - RKVDPU1_REG_DEC_DEV_CTRL_INDEX);
+	/* Flush the registers */
+	wmb();
+	mpp_dev_write(mpp_dev, RKVDPU1_REG_DEC_INT_EN,
+		      task->reg[RKVDPU1_REG_DEC_INT_EN_INDEX]
+		      | RKVDPU1_DEC_START);
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
+	mpp_dev_read_seq(mpp_dev, RKVDPU1_REG_DEC_DEV_CTRL,
+			 &task->reg[RKVDPU1_REG_DEC_DEV_CTRL_INDEX],
+			 mpp_dev->variant->reg_len
+			 - RKVDPU1_REG_DEC_DEV_CTRL);
+	task->reg[RKVDPU1_REG_DEC_INT_EN_INDEX] = task->irq_status;
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvdpu_result(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task,
+				      u32 __user *dst, u32 size)
+{
+	struct rkvdpu_task *task = to_rkvdpu_task(mpp_task);
+
+	/* FIXME may overflow the kernel */
+	if (copy_to_user(dst, task->reg, size)) {
+		mpp_err("copy_to_user failed\n");
+		return -EIO;
+	}
+
+	return 0;
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
+	irq_status = mpp_dev_read(mpp_dev, RKVDPU1_REG_DEC_INT_EN);
+	if (!(irq_status & RKVDPU1_DEC_INT_RAW))
+		return IRQ_NONE;
+
+	mpp_dev_write(mpp_dev, RKVDPU1_REG_DEC_INT_EN, 0);
+	/* FIXME use a spin lock here */
+	task = (struct rkvdpu_task *)dec_dev->current_task;
+	if (!task) {
+		dev_err(dec_dev->mpp_dev.dev, "no current task\n");
+		return IRQ_HANDLED;
+	}
+
+	mpp_task = &task->mpp_task;
+	mpp_debug_time_diff(mpp_task);
+
+	task->irq_status = irq_status;
+	mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n",
+		  task->irq_status);
+
+	err_mask = RKVDPU1_INT_TIMEOUT
+		| RKVDPU1_INT_STRM_ERROR
+		| RKVDPU1_INT_ASO_ERROR
+		| RKVDPU1_INT_BUF_EMPTY
+		| RKVDPU1_INT_BUS_ERROR;
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
+	/* TODO: use devm_reset_control_get_share() instead */
+	dec_dev->rst_a = devm_reset_control_get(mpp_dev->dev, "video_a");
+	dec_dev->rst_h = devm_reset_control_get(mpp_dev->dev, "video_h");
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
+		/* Don't skip this or iommu won't work after reset */
+		rockchip_pmu_idle_request(mpp_dev->dev, true);
+		safe_reset(dec->rst_a);
+		safe_reset(dec->rst_h);
+		udelay(5);
+		safe_unreset(dec->rst_h);
+		safe_unreset(dec->rst_a);
+		rockchip_pmu_idle_request(mpp_dev->dev, false);
+
+		mpp_dev_write(mpp_dev, RKVDPU1_REG_DEC_INT_EN, 0);
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
+	dec_dev->data = rockchip_rkvdpu1_get_drv_data(pdev);
+	mpp_dev = &dec_dev->mpp_dev;
+	mpp_dev->variant = &dec_dev->data->dec_data;
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
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name, NULL);
+	if (ret)
+		dev_err(dev, "register char device failed: %d\n", ret);
+
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
+static const struct of_device_id mpp_rkvdpu1_dt_match[] = {
+	{ .compatible = "rockchip,vpu-decoder-v1", .data = &vdpu_v1_data},
+	{ .compatible = "rockchip,vpu-decoder-pp-v1", .data = &vdpu_pp_v1_data},
+	{ .compatible = "rockchip,avs-decoder-v1", .data = &vdpu_avs_v1_data},
+	{},
+};
+
+static void *rockchip_rkvdpu1_get_drv_data(struct platform_device *pdev)
+{
+	struct vdpu1_dev_data *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(mpp_rkvdpu1_dt_match,
+				      pdev->dev.of_node);
+		if (match)
+			driver_data = (struct vdpu1_dev_data *)match->data;
+	}
+	return driver_data;
+}
+
+static struct platform_driver rockchip_rkvdpu1_driver = {
+	.probe = rockchip_mpp_rkvdpu_probe,
+	.remove = rockchip_mpp_rkvdpu_remove,
+	.driver = {
+		.name = RKVDPU1_DRIVER_NAME,
+		.of_match_table = of_match_ptr(mpp_rkvdpu1_dt_match),
+	},
+};
+
+static int __init mpp_dev_rkvdpu1_init(void)
+{
+	int ret = platform_driver_register(&rockchip_rkvdpu1_driver);
+
+	if (ret) {
+		mpp_err("Platform device register failed (%d).\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit mpp_dev_rkvdpu1_exit(void)
+{
+	platform_driver_unregister(&rockchip_rkvdpu1_driver);
+}
+
+module_init(mpp_dev_rkvdpu1_init);
+module_exit(mpp_dev_rkvdpu1_exit);
+
+MODULE_DEVICE_TABLE(of, mpp_rkvdpu1_dt_match);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
new file mode 100644
index 000000000000..b131790f72a3
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
@@ -0,0 +1,577 @@
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
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+
+#define RKVDPU2_DRIVER_NAME		"mpp_vdpu2"
+#define RKVDPU2_NODE_NAME		"vpu-service"
+
+/* The maximum registers number of all the version */
+#define ROCKCHIP_VDPU2_REG_NUM		159
+
+/* The first register of the decoder is Reg50(0x000c8) */
+#define RKVDPU2_REG_DEC_CTRL			0x0c8
+#define RKVDPU2_REG_DEC_CTRL_INDEX		(50)
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
+#define RKVDPU2_REG_DIR_MV_BASE                 0x0f8
+#define RKVDPU2_REG_DIR_MV_BASE_INDEX           (62)
+
+#define RKVDPU2_REG_STREAM_RLC_BASE		0x100
+#define RKVDPU2_REG_STREAM_RLC_BASE_INDEX	(64)
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
+	struct extra_info_for_iommu ext_inf;
+
+	u32 strm_base;
+	u32 irq_status;
+};
+
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
+
+static struct mpp_trans_info trans_rk_vdpu2[] = {
+	[RKVDPU2_FMT_H264D] = {
+		.count = sizeof(trans_tbl_h264d),
+		.table = trans_tbl_h264d,
+	},
+	[RKVDPU2_FMT_H263D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU2_FMT_MPEG4D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU2_FMT_JPEGD] = {
+		.count = sizeof(trans_tbl_jpegd),
+		.table = trans_tbl_jpegd,
+	},
+	[RKVDPU2_FMT_VC1D] = {
+		.count = sizeof(trans_tbl_vc1d),
+		.table = trans_tbl_vc1d,
+	},
+	[RKVDPU2_FMT_MPEG2D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU2_FMT_MPEG1D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU2_FMT_VP6D] = {
+		.count = sizeof(trans_tbl_vp6d),
+		.table = trans_tbl_vp6d,
+	},
+	[RKVDPU2_FMT_RESERVED] = {
+		.count = 0,
+		.table = NULL,
+	},
+	[RKVDPU2_FMT_VP7D] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVDPU2_FMT_VP8D] = {
+		.count = sizeof(trans_tbl_vp8d),
+		.table = trans_tbl_vp8d,
+	},
+	[RKVDPU2_FMT_AVSD] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+};
+
+static const struct mpp_dev_variant rkvdpu_v2_data = {
+	/* Exclude the register of the Performance counter */
+	.reg_len = 159,
+	.trans_info = trans_rk_vdpu2,
+	.node_name = RKVDPU2_NODE_NAME,
+};
+
+static void *rockchip_rkvdpu2_get_drv_data(struct platform_device *pdev);
+
+static void *rockchip_mpp_rkvdpu_alloc_task(struct mpp_session *session,
+					    void __user *src, u32 size)
+{
+	struct rkvdpu_task *task = NULL;
+	u32 reg_len;
+	u32 extinf_len;
+	u32 fmt = 0;
+	u32 dwsize = size / sizeof(u32);
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
+	reg_len = dwsize > ROCKCHIP_VDPU2_REG_NUM ?
+		ROCKCHIP_VDPU2_REG_NUM : dwsize;
+	extinf_len = dwsize > reg_len ? (dwsize - reg_len) * 4 : 0;
+
+	if (copy_from_user(task->reg, src, reg_len * 4)) {
+		mpp_err("error: copy_from_user failed in reg_init\n");
+		err = -EFAULT;
+		goto fail;
+	}
+
+	fmt = RKVDPU2_GET_FORMAT(task->reg[RKVDPU2_REG_SYS_CTRL_INDEX]);
+	if (extinf_len > 0) {
+		if (likely(fmt == RKVDPU2_FMT_JPEGD)) {
+			err = copy_from_user(&task->ext_inf,
+					     (u8 *)src + size
+					     - JPEG_IOC_EXTRA_SIZE,
+					     JPEG_IOC_EXTRA_SIZE);
+		} else {
+			u32 ext_cpy = min_t(size_t, extinf_len,
+					    sizeof(task->ext_inf));
+			err = copy_from_user(&task->ext_inf,
+					     (u32 *)src + reg_len, ext_cpy);
+		}
+
+		if (err) {
+			mpp_err("copy_from_user failed when extra info\n");
+			err = -EFAULT;
+			goto fail;
+		}
+	}
+
+	err = mpp_reg_address_translate(session->mpp, &task->mpp_task, fmt,
+					task->reg);
+	if (err) {
+		mpp_err("error: translate reg address failed.\n");
+
+		if (unlikely(debug & DEBUG_DUMP_ERR_REG))
+			mpp_debug_dump_reg_mem(task->reg,
+					       ROCKCHIP_VDPU2_REG_NUM);
+		goto fail;
+	}
+
+	if (likely(fmt == RKVDPU2_FMT_H264D)) {
+		struct mpp_mem_region *mem_region = NULL;
+		dma_addr_t iova = 0;
+		u32 offset = task->reg[RKVDPU2_REG_DIR_MV_BASE_INDEX];
+		int fd = task->reg[RKVDPU2_REG_DIR_MV_BASE_INDEX] & 0x3ff;
+
+		offset = offset >> 10 << 4;
+		mem_region = mpp_dev_task_attach_fd(&task->mpp_task, fd);
+		if (IS_ERR(mem_region)) {
+			err = PTR_ERR(mem_region);
+			goto fail;
+		}
+
+		iova = mem_region->iova;
+		mpp_debug(DEBUG_IOMMU, "DMV[%3d]: %3d => %pad + offset %10d\n",
+			  RKVDPU2_REG_DIR_MV_BASE_INDEX, fd, &iova, offset);
+		task->reg[RKVDPU2_REG_DIR_MV_BASE_INDEX] = iova + offset;
+	}
+
+	task->strm_base = task->reg[RKVDPU2_REG_STREAM_RLC_BASE_INDEX];
+
+	mpp_debug(DEBUG_SET_REG, "extra info cnt %u, magic %08x",
+		  task->ext_inf.cnt, task->ext_inf.magic);
+	mpp_translate_extra_info(&task->mpp_task, &task->ext_inf, task->reg);
+
+	mpp_debug_leave();
+
+	return &task->mpp_task;
+
+fail:
+	if (unlikely(debug & DEBUG_DUMP_ERR_REG))
+		mpp_debug_dump_reg_mem(task->reg, ROCKCHIP_VDPU2_REG_NUM);
+
+	mpp_dev_task_finalize(session, &task->mpp_task);
+	kfree(task);
+	return ERR_PTR(err);
+}
+
+static int rockchip_mpp_rkvdpu_prepare(struct rockchip_mpp_dev *mpp_dev,
+				       struct mpp_task *task)
+{
+	return -EINVAL;
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
+				      u32 __user *dst, u32 size)
+{
+	struct rkvdpu_task *task = to_rkvdpu_task(mpp_task);
+
+	/* FIXME may overflow the kernel */
+	if (copy_to_user(dst, task->reg, size)) {
+		mpp_err("copy_to_user failed\n");
+		return -EIO;
+	}
+
+	return 0;
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
+	mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n",
+		  task->irq_status);
+
+	err_mask = RKVDPU2_INT_TIMEOUT
+		| RKVDPU2_INT_STRM_ERROR
+		| RKVDPU2_INT_ASO_ERROR
+		| RKVDPU2_INT_BUF_EMPTY
+		| RKVDPU2_INT_BUS_ERROR;
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
+	/* TODO: use devm_reset_control_get_share() instead */
+	dec_dev->rst_a = devm_reset_control_get(mpp_dev->dev, "video_a");
+	dec_dev->rst_h = devm_reset_control_get(mpp_dev->dev, "video_h");
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
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name, NULL);
+	if (ret)
+		dev_err(dev, "register char device failed: %d\n", ret);
+
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
+	{ .compatible = "rockchip,vpu-decoder-v2", .data = &rkvdpu_v2_data},
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
+		.name = RKVDPU2_DRIVER_NAME,
+		.of_match_table = of_match_ptr(mpp_rkvdpu2_dt_match),
+	},
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
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vepu1.c b/drivers/staging/rockchip-mpp/mpp_dev_vepu1.c
new file mode 100644
index 000000000000..64619092c792
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vepu1.c
@@ -0,0 +1,481 @@
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
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+
+#define RKVEPU1_DRIVER_NAME		"mpp_vepu1"
+#define RKVEPU1_NODE_NAME		"vepu"
+
+/* The maximum registers number of all the version */
+#define ROCKCHIP_VEPU1_REG_NUM			(164)
+
+#define RKVEPU1_REG_INT				0x004
+#define RKVEPU1_REG_INT_INDEX			(1)
+#define		RKVEPU1_INT_SLICE		BIT(8)
+#define		RKVEPU1_INT_TIMEOUT		BIT(6)
+#define		RKVEPU1_INT_BUF_FULL		BIT(5)
+#define		RKVEPU1_INT_RESET		BIT(4)
+#define		RKVEPU1_INT_BUS_ERROR		BIT(3)
+#define		RKVEPU1_INT_RDY			BIT(2)
+#define		RKVEPU1_IRQ_DIS			BIT(1)
+#define		RKVEPU1_INT_RAW			BIT(0)
+
+#define RKVEPU1_REG_AXI_CTRL			0x008
+#define RKVEPU1_REG_AXI_CTRL_INDEX		(2)
+#define		RKVEPU1_CLOCK_GATE_EN		BIT(4)
+
+#define RKVEPU1_REG_ENC_CTRL			0x038
+#define RKVEPU1_REG_ENC_CTRL_INDEX		(14)
+#define		RKVEPU1_INT_TIMEOUT_EN		BIT(31)
+#define		RKVEPU1_INT_SLICE_EN		BIT(28)
+#define		RKVEPU1_GET_FORMAT(x)		(((x) >> 1) & 0x3)
+#define		RKVEPU1_FMT_RESERVED		(0)
+#define		RKVEPU1_FMT_VP8E		(1)
+#define		RKVEPU1_FMT_JPEGE		(2)
+#define		RKVEPU1_FMT_H264E		(3)
+#define		RKVEPU1_ENC_START		BIT(0)
+
+#define RKVEPU1_REG_INPUT_CTRL			0x03c
+#define RKVEPU1_REG_INPUT_CTRL_INDEX		(15)
+
+#define to_rkvepu_task(ctx)		\
+		container_of(ctx, struct rkvepu_task, mpp_task)
+#define to_rkvepu_dev(dev)		\
+		container_of(dev, struct rockchip_rkvepu_dev, mpp_dev)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "bit switch for vepu1 debug information");
+
+struct rockchip_rkvepu_dev {
+	struct rockchip_mpp_dev mpp_dev;
+
+	struct reset_control *rst_a;
+	struct reset_control *rst_h;
+
+	void *current_task;
+};
+
+struct rkvepu_task {
+	struct mpp_task mpp_task;
+
+	u32 reg[ROCKCHIP_VEPU1_REG_NUM];
+	u32 idx;
+	struct extra_info_for_iommu ext_inf;
+
+	u32 strm_base;
+	u32 irq_status;
+};
+
+/*
+ * file handle translate information
+ */
+static const char trans_tbl_default[] = {
+	5, 6, 7, 8, 9, 10, 11, 12, 13, 51
+};
+
+static const char trans_tbl_vp8e[] = {
+	5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 17, 26, 51, 52, 58, 59
+};
+
+static struct mpp_trans_info trans_rk_vepu1[] = {
+	[RKVEPU1_FMT_RESERVED] = {
+		.count = 0,
+		.table = NULL,
+	},
+	[RKVEPU1_FMT_VP8E] = {
+		.count = sizeof(trans_tbl_vp8e),
+		.table = trans_tbl_vp8e,
+	},
+	[RKVEPU1_FMT_JPEGE] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVEPU1_FMT_H264E] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+};
+
+static const struct mpp_dev_variant rkvepu_v1_data = {
+	.reg_len = ROCKCHIP_VEPU1_REG_NUM,
+	.trans_info = trans_rk_vepu1,
+	.node_name = RKVEPU1_NODE_NAME,
+};
+
+static void *rockchip_rkvepu1_get_drv_data(struct platform_device *pdev);
+
+static void *rockchip_mpp_rkvepu_alloc_task(struct mpp_session *session,
+					    void __user *src, u32 size)
+{
+	struct rkvepu_task *task = NULL;
+	u32 reg_len;
+	u32 extinf_len;
+	u32 fmt = 0;
+	u32 dwsize = size / sizeof(u32);
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
+	reg_len = dwsize > ROCKCHIP_VEPU1_REG_NUM ?
+		ROCKCHIP_VEPU1_REG_NUM : dwsize;
+	extinf_len = dwsize > reg_len ? (dwsize - reg_len) * 4 : 0;
+
+	if (copy_from_user(task->reg, src, reg_len * 4)) {
+		mpp_err("error: copy_from_user failed in reg_init\n");
+		err = -EFAULT;
+		goto fail;
+	}
+
+	fmt = RKVEPU1_GET_FORMAT(task->reg[RKVEPU1_REG_ENC_CTRL_INDEX]);
+	if (extinf_len > 0) {
+		if (likely(fmt == RKVEPU1_FMT_JPEGE)) {
+			err = copy_from_user(&task->ext_inf,
+					     (u8 *)src + size
+					     - JPEG_IOC_EXTRA_SIZE,
+					     JPEG_IOC_EXTRA_SIZE);
+		} else {
+			u32 ext_cpy = min_t(size_t, extinf_len,
+					    sizeof(task->ext_inf));
+			err = copy_from_user(&task->ext_inf,
+					     (u32 *)src + reg_len, ext_cpy);
+		}
+
+		if (err) {
+			mpp_err("copy_from_user failed when extra info\n");
+			err = -EFAULT;
+			goto fail;
+		}
+	}
+
+	err = mpp_reg_address_translate(session->mpp, &task->mpp_task, fmt,
+					task->reg);
+	if (err) {
+		mpp_err("error: translate reg address failed.\n");
+
+		if (unlikely(debug & DEBUG_DUMP_ERR_REG))
+			mpp_debug_dump_reg_mem(task->reg,
+					       ROCKCHIP_VEPU1_REG_NUM);
+		goto fail;
+	}
+
+	mpp_debug(DEBUG_SET_REG, "extra info cnt %u, magic %08x",
+		  task->ext_inf.cnt, task->ext_inf.magic);
+	mpp_translate_extra_info(&task->mpp_task, &task->ext_inf, task->reg);
+
+	mpp_debug_leave();
+
+	return &task->mpp_task;
+
+fail:
+	mpp_dev_task_finalize(session, &task->mpp_task);
+	kfree(task);
+	return ERR_PTR(err);
+}
+
+static int rockchip_mpp_rkvepu_prepare(struct rockchip_mpp_dev *mpp_dev,
+				       struct mpp_task *task)
+{
+	return -EINVAL;
+}
+
+static int rockchip_mpp_rkvepu_run(struct rockchip_mpp_dev *mpp_dev,
+				   struct mpp_task *mpp_task)
+{
+	struct rkvepu_task *task = NULL;
+	struct rockchip_rkvepu_dev *enc_dev = NULL;
+
+	mpp_debug_enter();
+
+	task = to_rkvepu_task(mpp_task);
+	enc_dev = to_rkvepu_dev(mpp_dev);
+
+	/* FIXME: spin lock here */
+	enc_dev->current_task = task;
+
+	mpp_dev_write_seq(mpp_dev, RKVEPU1_REG_AXI_CTRL,
+			  &task->reg[RKVEPU1_REG_AXI_CTRL_INDEX],
+			  RKVEPU1_REG_ENC_CTRL_INDEX
+			  - RKVEPU1_REG_AXI_CTRL_INDEX);
+
+	mpp_dev_write_seq(mpp_dev, RKVEPU1_REG_INPUT_CTRL,
+			  &task->reg[RKVEPU1_REG_INPUT_CTRL_INDEX],
+			  mpp_dev->variant->reg_len
+			  - RKVEPU1_REG_INPUT_CTRL_INDEX);
+	/* Flush the registers */
+	wmb();
+	mpp_dev_write(mpp_dev, RKVEPU1_REG_ENC_CTRL,
+		      task->reg[RKVEPU1_REG_ENC_CTRL_INDEX]
+		      | RKVEPU1_ENC_START);
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_finish(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task)
+{
+	struct rkvepu_task *task = to_rkvepu_task(mpp_task);
+
+	mpp_debug_enter();
+
+	task->reg[RKVEPU1_REG_INT_INDEX] = task->irq_status;
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_result(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task,
+				      u32 __user *dst, u32 size)
+{
+	struct rkvepu_task *task = to_rkvepu_task(mpp_task);
+
+	/* FIXME may overflow the kernel */
+	if (copy_to_user(dst, task->reg, size)) {
+		mpp_err("copy_to_user failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_free_task(struct mpp_session *session,
+					 struct mpp_task *mpp_task)
+{
+	struct rkvepu_task *task = to_rkvepu_task(mpp_task);
+
+	mpp_dev_task_finalize(session, mpp_task);
+	kfree(task);
+
+	return 0;
+}
+
+static irqreturn_t mpp_rkvepu_isr(int irq, void *dev_id)
+{
+	struct rockchip_rkvepu_dev *enc_dev = dev_id;
+	struct rockchip_mpp_dev *mpp_dev = &enc_dev->mpp_dev;
+	struct rkvepu_task *task = NULL;
+	struct mpp_task *mpp_task = NULL;
+	u32 irq_status;
+	u32 err_mask;
+
+	irq_status = mpp_dev_read(mpp_dev, RKVEPU1_REG_INT);
+	if (!(irq_status & RKVEPU1_INT_RAW))
+		return IRQ_NONE;
+
+	mpp_dev_write(mpp_dev, RKVEPU1_REG_INT, 0);
+	/* FIXME use a spin lock here */
+	task = (struct rkvepu_task *)enc_dev->current_task;
+	if (!task) {
+		dev_err(enc_dev->mpp_dev.dev, "no current task\n");
+		return IRQ_HANDLED;
+	}
+
+	mpp_task = &task->mpp_task;
+	mpp_debug_time_diff(mpp_task);
+
+	task->irq_status = irq_status;
+	mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n",
+		  task->irq_status);
+
+	err_mask = RKVEPU1_INT_TIMEOUT
+		| RKVEPU1_INT_BUF_FULL
+		| RKVEPU1_INT_BUS_ERROR;
+
+	if (err_mask & task->irq_status)
+		atomic_set(&mpp_dev->reset_request, 1);
+
+	mpp_dev_task_finish(mpp_task->session, mpp_task);
+
+	mpp_debug_leave();
+	return IRQ_HANDLED;
+
+	return IRQ_NONE;
+}
+
+static int rockchip_mpp_rkvepu_assign_reset(struct rockchip_rkvepu_dev *enc_dev)
+{
+	struct rockchip_mpp_dev *mpp_dev = &enc_dev->mpp_dev;
+
+	/* TODO: use devm_reset_control_get_share() instead */
+	enc_dev->rst_a = devm_reset_control_get(mpp_dev->dev, "video_a");
+	enc_dev->rst_h = devm_reset_control_get(mpp_dev->dev, "video_h");
+
+	if (IS_ERR_OR_NULL(enc_dev->rst_a)) {
+		mpp_err("No aclk reset resource define\n");
+		enc_dev->rst_a = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(enc_dev->rst_h)) {
+		mpp_err("No hclk reset resource define\n");
+		enc_dev->rst_h = NULL;
+	}
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_reset(struct rockchip_mpp_dev *mpp_dev)
+{
+	struct rockchip_rkvepu_dev *enc = to_rkvepu_dev(mpp_dev);
+
+	if (enc->rst_a && enc->rst_h) {
+		mpp_debug(DEBUG_RESET, "reset in\n");
+
+		/* Don't skip this or iommu won't work after reset */
+		rockchip_pmu_idle_request(mpp_dev->dev, true);
+		safe_reset(enc->rst_a);
+		safe_reset(enc->rst_h);
+		udelay(5);
+		safe_unreset(enc->rst_h);
+		safe_unreset(enc->rst_a);
+		rockchip_pmu_idle_request(mpp_dev->dev, false);
+
+		mpp_dev_write(mpp_dev, RKVEPU1_REG_ENC_CTRL, 0);
+		enc->current_task = NULL;
+		mpp_debug(DEBUG_RESET, "reset out\n");
+	}
+
+	return 0;
+}
+
+static struct mpp_dev_ops rkvepu_ops = {
+	.alloc_task = rockchip_mpp_rkvepu_alloc_task,
+	.prepare = rockchip_mpp_rkvepu_prepare,
+	.run = rockchip_mpp_rkvepu_run,
+	.finish = rockchip_mpp_rkvepu_finish,
+	.result = rockchip_mpp_rkvepu_result,
+	.free_task = rockchip_mpp_rkvepu_free_task,
+	.reset = rockchip_mpp_rkvepu_reset,
+};
+
+static int rockchip_mpp_rkvepu_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct rockchip_rkvepu_dev *enc_dev = NULL;
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+	int ret = 0;
+
+	enc_dev = devm_kzalloc(dev, sizeof(struct rockchip_rkvepu_dev),
+			       GFP_KERNEL);
+	if (!enc_dev)
+		return -ENOMEM;
+
+	mpp_dev = &enc_dev->mpp_dev;
+	mpp_dev->variant = rockchip_rkvepu1_get_drv_data(pdev);
+	ret = mpp_dev_common_probe(mpp_dev, pdev, &rkvepu_ops);
+	if (ret)
+		return ret;
+
+	ret = devm_request_threaded_irq(dev, mpp_dev->irq, NULL, mpp_rkvepu_isr,
+					IRQF_SHARED | IRQF_ONESHOT,
+					dev_name(dev), enc_dev);
+	if (ret) {
+		dev_err(dev, "register interrupter runtime failed\n");
+		return ret;
+	}
+
+	rockchip_mpp_rkvepu_assign_reset(enc_dev);
+
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name, NULL);
+	if (ret)
+		dev_err(dev, "register char device failed: %d\n", ret);
+
+	dev_info(dev, "probing finish\n");
+
+	platform_set_drvdata(pdev, enc_dev);
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_remove(struct platform_device *pdev)
+{
+	struct rockchip_rkvepu_dev *enc_dev = platform_get_drvdata(pdev);
+
+	mpp_dev_common_remove(&enc_dev->mpp_dev);
+
+	return 0;
+}
+
+static const struct of_device_id mpp_rkvepu1_dt_match[] = {
+	{ .compatible = "rockchip,vpu-encoder-v1", .data = &rkvepu_v1_data},
+	{},
+};
+
+static void *rockchip_rkvepu1_get_drv_data(struct platform_device *pdev)
+{
+	struct mpp_dev_variant *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(mpp_rkvepu1_dt_match, pdev->dev.of_node);
+		if (match)
+			driver_data = (struct mpp_dev_variant *)match->data;
+	}
+	return driver_data;
+}
+
+static struct platform_driver rockchip_rkvepu1_driver = {
+	.probe = rockchip_mpp_rkvepu_probe,
+	.remove = rockchip_mpp_rkvepu_remove,
+	.driver = {
+		.name = RKVEPU1_DRIVER_NAME,
+		.of_match_table = of_match_ptr(mpp_rkvepu1_dt_match),
+	},
+};
+
+static int __init mpp_dev_rkvepu1_init(void)
+{
+	int ret = platform_driver_register(&rockchip_rkvepu1_driver);
+
+	if (ret) {
+		mpp_err("Platform device register failed (%d).\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit mpp_dev_rkvepu1_exit(void)
+{
+	platform_driver_unregister(&rockchip_rkvepu1_driver);
+}
+
+module_init(mpp_dev_rkvepu1_init);
+module_exit(mpp_dev_rkvepu1_exit);
+
+MODULE_DEVICE_TABLE(of, mpp_rkvepu1_dt_match);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vepu2.c b/drivers/staging/rockchip-mpp/mpp_dev_vepu2.c
new file mode 100644
index 000000000000..48ec401145d5
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vepu2.c
@@ -0,0 +1,478 @@
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
+#include "mpp_debug.h"
+#include "mpp_dev_common.h"
+
+#define RKVEPU2_DRIVER_NAME		"mpp_vepu2"
+#define RKVEPU2_NODE_NAME		"vepu"
+
+/* The maximum registers number of all the version */
+#define ROCKCHIP_VEPU2_REG_NUM			(184)
+
+#define RKVEPU2_REG_ENC_CTRL			0x19c
+#define RKVEPU2_REG_ENC_CTRL_INDEX		(103)
+#define		RKVEPU2_GET_FORMAT(x)		(((x) >> 4) & 0x3)
+#define		RKVEPU2_FMT_RESERVED		(0)
+#define		RKVEPU2_FMT_VP8E		(1)
+#define		RKVEPU2_FMT_JPEGE		(2)
+#define		RKVEPU2_FMT_H264E		(3)
+#define		RKVEPU2_ENC_START		BIT(0)
+
+#define RKVEPU2_REG_MB_CTRL			0x1a0
+#define RKVEPU2_REG_MB_CTRL_INDEX		(104)
+
+#define RKVEPU2_REG_INT				0x1b4
+#define RKVEPU2_REG_INT_INDEX			(109)
+#define		RKVEPU2_MV_SAD_WR_EN		BIT(24)
+#define		RKVEPU2_ROCON_WRITE_DIS		BIT(20)
+#define		RKVEPU1_INT_SLICE_EN		BIT(16)
+#define		RKVEPU2_CLOCK_GATE_EN		BIT(12)
+#define		RKVEPU2_INT_TIMEOUT_EN		BIT(10)
+#define		RKVEPU2_INT_CLEAR		BIT(9)
+#define		RKVEPU2_IRQ_DIS			BIT(8)
+#define		RKVEPU2_INT_TIMEOUT		BIT(6)
+#define		RKVEPU2_INT_BUF_FULL		BIT(5)
+#define		RKVEPU2_INT_BUS_ERROR		BIT(4)
+#define		RKVEPU2_INT_SLICE		BIT(2)
+#define		RKVEPU2_INT_RDY			BIT(1)
+#define		RKVEPU2_INT_RAW			BIT(0)
+
+#define RKVPUE2_REG_DMV_4P_1P(i)		(0x1e0 + ((i) << 4))
+#define RKVPUE2_REG_DMV_4P_1P_INDEX(i)		(120 + (i))
+
+#define to_rkvepu_task(ctx)		\
+		container_of(ctx, struct rkvepu_task, mpp_task)
+#define to_rkvepu_dev(dev)		\
+		container_of(dev, struct rockchip_rkvepu_dev, mpp_dev)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "bit switch for vepu1 debug information");
+
+struct rockchip_rkvepu_dev {
+	struct rockchip_mpp_dev mpp_dev;
+
+	struct reset_control *rst_a;
+	struct reset_control *rst_h;
+
+	void *current_task;
+};
+
+struct rkvepu_task {
+	struct mpp_task mpp_task;
+
+	u32 reg[ROCKCHIP_VEPU2_REG_NUM];
+	u32 idx;
+	struct extra_info_for_iommu ext_inf;
+
+	u32 strm_base;
+	u32 irq_status;
+};
+
+/*
+ * file handle translate information
+ */
+static const char trans_tbl_default[] = {
+	48, 49, 50, 56, 57, 63, 64, 77, 78, 81
+};
+
+static struct mpp_trans_info trans_rk_vepu2[] = {
+	[RKVEPU2_FMT_RESERVED] = {
+		.count = 0,
+		.table = NULL,
+	},
+	[RKVEPU2_FMT_VP8E] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVEPU2_FMT_JPEGE] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+	[RKVEPU2_FMT_H264E] = {
+		.count = sizeof(trans_tbl_default),
+		.table = trans_tbl_default,
+	},
+};
+
+static const struct mpp_dev_variant rkvepu_v2_data = {
+	.reg_len = ROCKCHIP_VEPU2_REG_NUM,
+	.trans_info = trans_rk_vepu2,
+	.node_name = RKVEPU2_NODE_NAME,
+};
+
+static void *rockchip_rkvepu2_get_drv_data(struct platform_device *pdev);
+
+static void *rockchip_mpp_rkvepu_alloc_task(struct mpp_session *session,
+					    void __user *src, u32 size)
+{
+	struct rkvepu_task *task = NULL;
+	u32 reg_len;
+	u32 extinf_len;
+	u32 fmt = 0;
+	u32 dwsize = size / sizeof(u32);
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
+	reg_len = dwsize > ROCKCHIP_VEPU2_REG_NUM ?
+		ROCKCHIP_VEPU2_REG_NUM : dwsize;
+	extinf_len = dwsize > reg_len ? (dwsize - reg_len) * 4 : 0;
+
+	if (copy_from_user(task->reg, src, reg_len * 4)) {
+		mpp_err("error: copy_from_user failed in reg_init\n");
+		err = -EFAULT;
+		goto fail;
+	}
+
+	fmt = RKVEPU2_GET_FORMAT(task->reg[RKVEPU2_REG_ENC_CTRL_INDEX]);
+	if (extinf_len > 0) {
+		if (likely(fmt == RKVEPU2_FMT_JPEGE)) {
+			err = copy_from_user(&task->ext_inf,
+					     (u8 *)src + size
+					     - JPEG_IOC_EXTRA_SIZE,
+					     JPEG_IOC_EXTRA_SIZE);
+		} else {
+			u32 ext_cpy = min_t(size_t, extinf_len,
+					    sizeof(task->ext_inf));
+			err = copy_from_user(&task->ext_inf,
+					     (u32 *)src + reg_len, ext_cpy);
+		}
+
+		if (err) {
+			mpp_err("copy_from_user failed when extra info\n");
+			err = -EFAULT;
+			goto fail;
+		}
+	}
+
+	err = mpp_reg_address_translate(session->mpp, &task->mpp_task, fmt,
+					task->reg);
+	if (err) {
+		mpp_err("error: translate reg address failed.\n");
+
+		if (unlikely(debug & DEBUG_DUMP_ERR_REG))
+			mpp_debug_dump_reg_mem(task->reg,
+					       ROCKCHIP_VEPU2_REG_NUM);
+		goto fail;
+	}
+
+	mpp_debug(DEBUG_SET_REG, "extra info cnt %u, magic %08x",
+		  task->ext_inf.cnt, task->ext_inf.magic);
+	mpp_translate_extra_info(&task->mpp_task, &task->ext_inf, task->reg);
+
+	mpp_debug_leave();
+
+	return &task->mpp_task;
+
+fail:
+	mpp_dev_task_finalize(session, &task->mpp_task);
+	kfree(task);
+	return ERR_PTR(err);
+}
+
+static int rockchip_mpp_rkvepu_prepare(struct rockchip_mpp_dev *mpp_dev,
+				       struct mpp_task *task)
+{
+	return -EINVAL;
+}
+
+static int rockchip_mpp_rkvepu_run(struct rockchip_mpp_dev *mpp_dev,
+				   struct mpp_task *mpp_task)
+{
+	struct rkvepu_task *task = NULL;
+	struct rockchip_rkvepu_dev *enc_dev = NULL;
+
+	mpp_debug_enter();
+
+	task = to_rkvepu_task(mpp_task);
+	enc_dev = to_rkvepu_dev(mpp_dev);
+
+	/* FIXME: spin lock here */
+	enc_dev->current_task = task;
+
+	mpp_dev_write_seq(mpp_dev, 0, &task->reg[0],
+			  RKVEPU2_REG_ENC_CTRL_INDEX);
+
+	mpp_dev_write_seq(mpp_dev, RKVEPU2_REG_MB_CTRL,
+			  &task->reg[RKVEPU2_REG_MB_CTRL_INDEX],
+			  ROCKCHIP_VEPU2_REG_NUM
+			  - RKVEPU2_REG_MB_CTRL_INDEX);
+	/* Flush the registers */
+	wmb();
+	mpp_dev_write(mpp_dev, RKVEPU2_REG_ENC_CTRL,
+		      task->reg[RKVEPU2_REG_ENC_CTRL_INDEX]
+		      | RKVEPU2_ENC_START);
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_finish(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task)
+{
+	struct rkvepu_task *task = to_rkvepu_task(mpp_task);
+
+	mpp_debug_enter();
+
+	task->reg[RKVEPU2_REG_INT_INDEX] = task->irq_status;
+
+	mpp_debug_leave();
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_result(struct rockchip_mpp_dev *mpp_dev,
+				      struct mpp_task *mpp_task,
+				      u32 __user *dst, u32 size)
+{
+	struct rkvepu_task *task = to_rkvepu_task(mpp_task);
+
+	/* FIXME may overflow the kernel */
+	if (copy_to_user(dst, task->reg, size)) {
+		mpp_err("copy_to_user failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_free_task(struct mpp_session *session,
+					 struct mpp_task *mpp_task)
+{
+	struct rkvepu_task *task = to_rkvepu_task(mpp_task);
+
+	mpp_dev_task_finalize(session, mpp_task);
+	kfree(task);
+
+	return 0;
+}
+
+static irqreturn_t mpp_rkvepu_isr(int irq, void *dev_id)
+{
+	struct rockchip_rkvepu_dev *enc_dev = dev_id;
+	struct rockchip_mpp_dev *mpp_dev = &enc_dev->mpp_dev;
+	struct rkvepu_task *task = NULL;
+	struct mpp_task *mpp_task = NULL;
+	u32 irq_status;
+	u32 err_mask;
+
+	irq_status = mpp_dev_read(mpp_dev, RKVEPU2_REG_INT);
+	if (!(irq_status & RKVEPU2_INT_RAW))
+		return IRQ_NONE;
+
+	mpp_dev_write(mpp_dev, RKVEPU2_REG_INT, RKVEPU2_INT_CLEAR
+		      | RKVEPU2_CLOCK_GATE_EN);
+	/* FIXME use a spin lock here */
+	task = (struct rkvepu_task *)enc_dev->current_task;
+	if (!task) {
+		dev_err(enc_dev->mpp_dev.dev, "no current task\n");
+		return IRQ_HANDLED;
+	}
+
+	mpp_task = &task->mpp_task;
+	mpp_debug_time_diff(mpp_task);
+
+	task->irq_status = irq_status;
+	mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n",
+		  task->irq_status);
+
+	err_mask = RKVEPU2_INT_TIMEOUT
+		| RKVEPU2_INT_BUF_FULL
+		| RKVEPU2_INT_BUS_ERROR;
+
+	if (err_mask & task->irq_status)
+		atomic_set(&mpp_dev->reset_request, 1);
+
+	mpp_dev_task_finish(mpp_task->session, mpp_task);
+
+	mpp_debug_leave();
+	return IRQ_HANDLED;
+
+	return IRQ_NONE;
+}
+
+static int rockchip_mpp_rkvepu_assign_reset(struct rockchip_rkvepu_dev *enc_dev)
+{
+	struct rockchip_mpp_dev *mpp_dev = &enc_dev->mpp_dev;
+
+	/* TODO: use devm_reset_control_get_share() instead */
+	enc_dev->rst_a = devm_reset_control_get(mpp_dev->dev, "video_a");
+	enc_dev->rst_h = devm_reset_control_get(mpp_dev->dev, "video_h");
+
+	if (IS_ERR_OR_NULL(enc_dev->rst_a)) {
+		mpp_err("No aclk reset resource define\n");
+		enc_dev->rst_a = NULL;
+	}
+
+	if (IS_ERR_OR_NULL(enc_dev->rst_h)) {
+		mpp_err("No hclk reset resource define\n");
+		enc_dev->rst_h = NULL;
+	}
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_reset(struct rockchip_mpp_dev *mpp_dev)
+{
+	struct rockchip_rkvepu_dev *enc = to_rkvepu_dev(mpp_dev);
+
+	if (enc->rst_a && enc->rst_h) {
+		mpp_debug(DEBUG_RESET, "reset in\n");
+
+		/* Don't skip this or iommu won't work after reset */
+		rockchip_pmu_idle_request(mpp_dev->dev, true);
+		safe_reset(enc->rst_a);
+		safe_reset(enc->rst_h);
+		udelay(5);
+		safe_unreset(enc->rst_h);
+		safe_unreset(enc->rst_a);
+		rockchip_pmu_idle_request(mpp_dev->dev, false);
+
+		mpp_dev_write(mpp_dev, RKVEPU2_REG_INT, RKVEPU2_INT_CLEAR);
+		enc->current_task = NULL;
+		mpp_debug(DEBUG_RESET, "reset out\n");
+	}
+
+	return 0;
+}
+
+static struct mpp_dev_ops rkvepu_ops = {
+	.alloc_task = rockchip_mpp_rkvepu_alloc_task,
+	.prepare = rockchip_mpp_rkvepu_prepare,
+	.run = rockchip_mpp_rkvepu_run,
+	.finish = rockchip_mpp_rkvepu_finish,
+	.result = rockchip_mpp_rkvepu_result,
+	.free_task = rockchip_mpp_rkvepu_free_task,
+	.reset = rockchip_mpp_rkvepu_reset,
+};
+
+static int rockchip_mpp_rkvepu_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct rockchip_rkvepu_dev *enc_dev = NULL;
+	struct rockchip_mpp_dev *mpp_dev = NULL;
+	int ret = 0;
+
+	enc_dev = devm_kzalloc(dev, sizeof(struct rockchip_rkvepu_dev),
+			       GFP_KERNEL);
+	if (!enc_dev)
+		return -ENOMEM;
+
+	mpp_dev = &enc_dev->mpp_dev;
+	mpp_dev->variant = rockchip_rkvepu2_get_drv_data(pdev);
+	ret = mpp_dev_common_probe(mpp_dev, pdev, &rkvepu_ops);
+	if (ret)
+		return ret;
+
+	ret = devm_request_threaded_irq(dev, mpp_dev->irq, NULL, mpp_rkvepu_isr,
+					IRQF_SHARED | IRQF_ONESHOT,
+					dev_name(dev), enc_dev);
+	if (ret) {
+		dev_err(dev, "register interrupter runtime failed\n");
+		return ret;
+	}
+
+	rockchip_mpp_rkvepu_assign_reset(enc_dev);
+
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name, NULL);
+	if (ret)
+		dev_err(dev, "register char device failed: %d\n", ret);
+
+	dev_info(dev, "probing finish\n");
+
+	platform_set_drvdata(pdev, enc_dev);
+
+	return 0;
+}
+
+static int rockchip_mpp_rkvepu_remove(struct platform_device *pdev)
+{
+	struct rockchip_rkvepu_dev *enc_dev = platform_get_drvdata(pdev);
+
+	mpp_dev_common_remove(&enc_dev->mpp_dev);
+
+	return 0;
+}
+
+static const struct of_device_id mpp_rkvepu2_dt_match[] = {
+	{ .compatible = "rockchip,vpu-encoder-v2", .data = &rkvepu_v2_data},
+	{},
+};
+
+static void *rockchip_rkvepu2_get_drv_data(struct platform_device *pdev)
+{
+	struct mpp_dev_variant *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(mpp_rkvepu2_dt_match, pdev->dev.of_node);
+		if (match)
+			driver_data = (struct mpp_dev_variant *)match->data;
+	}
+	return driver_data;
+}
+
+static struct platform_driver rockchip_rkvepu2_driver = {
+	.probe = rockchip_mpp_rkvepu_probe,
+	.remove = rockchip_mpp_rkvepu_remove,
+	.driver = {
+		.name = RKVEPU2_DRIVER_NAME,
+		.of_match_table = of_match_ptr(mpp_rkvepu2_dt_match),
+	},
+};
+
+static int __init mpp_dev_rkvepu2_init(void)
+{
+	int ret = platform_driver_register(&rockchip_rkvepu2_driver);
+
+	if (ret) {
+		mpp_err("Platform device register failed (%d).\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit mpp_dev_rkvepu2_exit(void)
+{
+	platform_driver_unregister(&rockchip_rkvepu2_driver);
+}
+
+module_init(mpp_dev_rkvepu2_init);
+module_exit(mpp_dev_rkvepu2_exit);
+
+MODULE_DEVICE_TABLE(of, mpp_rkvepu2_dt_match);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/rockchip-mpp/mpp_iommu_dma.c b/drivers/staging/rockchip-mpp/mpp_iommu_dma.c
new file mode 100644
index 000000000000..2479b6c91bc9
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_iommu_dma.c
@@ -0,0 +1,292 @@
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
+#include <linux/dma-buf.h>
+#include <linux/dma-iommu.h>
+#include <linux/iommu.h>
+#include <linux/kref.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+
+#include "mpp_iommu_dma.h"
+
+/* pixel buffer, stream buffer and video codec buffer, not used */
+#define BUFFER_LIST_MAX_NUMS		30
+
+struct mpp_dma_buffer {
+	struct list_head list;
+	struct mpp_dma_session *session;
+	/* DMABUF information */
+	struct dma_buf *dma_buf;
+	struct dma_buf_attachment *attach;
+	struct sg_table *sgt;
+	enum dma_data_direction dir;
+
+	dma_addr_t iova;
+	unsigned long size;
+	/* Only be used for identifying the buffer */
+	int fd;
+
+	struct kref ref;
+	struct rcu_head rcu;
+};
+
+struct mpp_dma_session {
+	struct list_head buffer_list;
+	/* the mutex for the above buffer list */
+	struct mutex list_mutex;
+
+	struct device *dev;
+};
+
+static struct mpp_dma_buffer *
+mpp_dma_find_buffer(struct mpp_dma_session *session, int fd)
+{
+	struct mpp_dma_buffer *buffer = NULL;
+
+	list_for_each_entry_rcu(buffer, &session->buffer_list, list) {
+		/*
+		 * As long as the last reference is hold by the buffer pool,
+		 * the same fd won't be assigned to the other application.
+		 */
+		if (buffer->fd == fd)
+			return buffer;
+	}
+
+	return NULL;
+}
+
+/* Release the buffer from the current list */
+static void mpp_dma_buffer_delete_rcu(struct kref *ref)
+{
+	struct mpp_dma_buffer *buffer =
+		container_of(ref, struct mpp_dma_buffer, ref);
+
+	mutex_lock(&buffer->session->list_mutex);
+	list_del_rcu(&buffer->list);
+	mutex_unlock(&buffer->session->list_mutex);
+
+	dma_buf_unmap_attachment(buffer->attach, buffer->sgt, buffer->dir);
+	dma_buf_detach(buffer->dma_buf, buffer->attach);
+	dma_buf_put(buffer->dma_buf);
+	kfree_rcu(buffer, rcu);
+}
+
+int mpp_dma_release_fd(struct mpp_dma_session *session, int fd)
+{
+	struct device *dev = session->dev;
+	struct mpp_dma_buffer *buffer = NULL;
+
+	rcu_read_lock();
+	buffer = mpp_dma_find_buffer(session, fd);
+	rcu_read_unlock();
+	if (IS_ERR_OR_NULL(buffer)) {
+		dev_err(dev, "can not find %d buffer in list to release\n", fd);
+
+		return -EINVAL;
+	}
+
+	kref_put(&buffer->ref, mpp_dma_buffer_delete_rcu);
+
+	return 0;
+}
+
+dma_addr_t mpp_dma_import_fd(struct mpp_dma_session *session, int fd)
+{
+	struct mpp_dma_buffer *buffer = NULL;
+	struct dma_buf_attachment *attach;
+	struct sg_table *sgt;
+	struct dma_buf *dma_buf;
+	int ret = 0;
+
+	if (!session)
+		return -EINVAL;
+
+	dma_buf = dma_buf_get(fd);
+	if (IS_ERR(dma_buf)) {
+		ret = PTR_ERR(dma_buf);
+		return ret;
+	}
+
+	rcu_read_lock();
+	buffer = mpp_dma_find_buffer(session, fd);
+	if (!IS_ERR_OR_NULL(buffer)) {
+		if (buffer->dma_buf == dma_buf) {
+			if (kref_get_unless_zero(&buffer->ref)) {
+				dma_buf_put(dma_buf);
+				rcu_read_unlock();
+				return buffer->iova;
+			}
+		}
+		rcu_read_unlock();
+		dev_dbg(session->dev,
+			"missing the fd %d\n", fd);
+		kref_put(&buffer->ref, mpp_dma_buffer_delete_rcu);
+	} else {
+		rcu_read_unlock();
+	}
+
+	/* A new DMA buffer */
+	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
+	if (!buffer) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	buffer->dma_buf = dma_buf;
+	buffer->fd = fd;
+	/* TODO */
+	buffer->dir = DMA_BIDIRECTIONAL;
+
+	kref_init(&buffer->ref);
+
+	attach = dma_buf_attach(buffer->dma_buf, session->dev);
+	if (IS_ERR(attach)) {
+		ret = PTR_ERR(attach);
+		goto fail_out;
+	}
+
+	sgt = dma_buf_map_attachment(attach, buffer->dir);
+	if (IS_ERR(sgt)) {
+		ret = PTR_ERR(sgt);
+		goto fail_detach;
+	}
+
+	buffer->iova = sg_dma_address(sgt->sgl);
+	buffer->size = sg_dma_len(sgt->sgl);
+
+	buffer->attach = attach;
+	buffer->sgt = sgt;
+
+	/* Increase the reference for used outside the buffer pool */
+	kref_get(&buffer->ref);
+
+	INIT_LIST_HEAD(&buffer->list);
+
+	mutex_lock(&session->list_mutex);
+	buffer->session = session;
+	list_add_tail_rcu(&buffer->list, &session->buffer_list);
+	mutex_unlock(&session->list_mutex);
+
+	return buffer->iova;
+
+fail_detach:
+	dma_buf_detach(buffer->dma_buf, attach);
+fail_out:
+	kfree(buffer);
+err:
+	dma_buf_put(dma_buf);
+	return ret;
+}
+
+void mpp_dma_destroy_session(struct mpp_dma_session *session)
+{
+	struct mpp_dma_buffer *buffer = NULL;
+
+	if (!session)
+		return;
+
+	mutex_lock(&session->list_mutex);
+	list_for_each_entry_rcu(buffer, &session->buffer_list, list) {
+		list_del_rcu(&buffer->list);
+		dma_buf_unmap_attachment(buffer->attach, buffer->sgt,
+					 buffer->dir);
+		dma_buf_detach(buffer->dma_buf, buffer->attach);
+		dma_buf_put(buffer->dma_buf);
+		kfree_rcu(buffer, rcu);
+	}
+	mutex_unlock(&session->list_mutex);
+
+	kfree(session);
+}
+
+struct mpp_dma_session *mpp_dma_session_create(struct device *dev)
+{
+	struct mpp_dma_session *session = NULL;
+
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
+	if (!session)
+		return session;
+
+	INIT_LIST_HEAD(&session->buffer_list);
+	mutex_init(&session->list_mutex);
+
+	session->dev = dev;
+
+	return session;
+}
+
+void mpp_iommu_detach(struct mpp_iommu_info *info)
+{
+	struct iommu_domain *domain = info->domain;
+	struct iommu_group *group = info->group;
+
+	iommu_detach_group(domain, group);
+}
+
+int mpp_iommu_attach(struct mpp_iommu_info *info)
+{
+	struct iommu_domain *domain = info->domain;
+	struct iommu_group *group = info->group;
+	int ret;
+
+	ret = iommu_attach_group(domain, group);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+struct mpp_iommu_info *mpp_iommu_probe(struct device *dev)
+{
+	struct mpp_iommu_info *info = NULL;
+	int ret = 0;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	info->group = iommu_group_get(dev);
+	if (!info->group) {
+		ret = -EINVAL;
+		goto err_free_info;
+	}
+
+	info->domain = iommu_get_domain_for_dev(dev);
+	if (!info->domain) {
+		ret = -EINVAL;
+		goto err_put_group;
+	}
+
+	return info;
+
+err_put_group:
+	iommu_group_put(info->group);
+err_free_info:
+	kfree(info);
+err:
+	return ERR_PTR(ret);
+}
+
+int mpp_iommu_remove(struct mpp_iommu_info *info)
+{
+	iommu_group_put(info->group);
+	kfree(info);
+
+	return 0;
+}
diff --git a/drivers/staging/rockchip-mpp/mpp_iommu_dma.h b/drivers/staging/rockchip-mpp/mpp_iommu_dma.h
new file mode 100644
index 000000000000..5c6866397daa
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/mpp_iommu_dma.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
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
+#ifndef __VCODEC_IOMMU_DMA_H__
+#define __VCODEC_IOMMU_DMA_H__
+
+#include <linux/iommu.h>
+#include <linux/dma-mapping.h>
+
+struct mpp_iommu_info {
+	struct iommu_domain *domain;
+	struct iommu_group *group;
+};
+
+struct mpp_dma_session;
+
+struct mpp_dma_session *mpp_dma_session_create(struct device *dev);
+void mpp_dma_destroy_session(struct mpp_dma_session *session);
+
+dma_addr_t mpp_dma_import_fd(struct mpp_dma_session *session, int fd);
+int mpp_dma_release_fd(struct mpp_dma_session *session, int fd);
+
+struct mpp_iommu_info *mpp_iommu_probe(struct device *dev);
+int mpp_iommu_remove(struct mpp_iommu_info *info);
+
+int mpp_iommu_attach(struct mpp_iommu_info *info);
+void mpp_iommu_detach(struct mpp_iommu_info *info);
+
+#endif
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
diff --git a/include/uapi/video/rk_vpu_service.h b/include/uapi/video/rk_vpu_service.h
new file mode 100644
index 000000000000..b75e03c391c7
--- /dev/null
+++ b/include/uapi/video/rk_vpu_service.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2015 Fuzhou Rockchip Electronics Co., Ltd
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
+#ifndef __UAPI_LINUX_RK_VPU_SERVICE_H__
+#define __UAPI_LINUX_RK_VPU_SERVICE_H__
+
+#include <linux/types.h>
+#include <asm/ioctl.h>
+
+/*
+ * Ioctl definitions
+ */
+
+/* Use 'l' as magic number */
+#define VPU_IOC_MAGIC			'l'
+
+#define VPU_IOC_SET_CLIENT_TYPE		_IOW(VPU_IOC_MAGIC, 1, __u32)
+#define VPU_IOC_GET_HW_FUSE_STATUS	_IOW(VPU_IOC_MAGIC, 2, unsigned long)
+
+#define VPU_IOC_SET_REG			_IOW(VPU_IOC_MAGIC, 3, unsigned long)
+#define VPU_IOC_GET_REG			_IOW(VPU_IOC_MAGIC, 4, unsigned long)
+
+#define VPU_IOC_PROBE_IOMMU_STATUS	_IOR(VPU_IOC_MAGIC, 5, __u32)
+#define VPU_IOC_SET_DRIVER_DATA		_IOW(VPU_IOC_MAGIC, 64, u32)
+
+struct vpu_request {
+	__u32 *req;
+	__u32 size;
+};
+
+/* Hardware decoder configuration description */
+struct vpu_dec_config {
+	/* Maximum video decoding width supported  */
+	__u32 max_dec_pic_width;
+	/* Maximum output width of Post-Processor */
+	__u32 max_pp_out_pic_width;
+	/* HW supports h.264 */
+	__u32 h264_support;
+	/* HW supports JPEG */
+	__u32 jpeg_support;
+	/* HW supports MPEG-4 */
+	__u32 mpeg4_support;
+	/* HW supports custom MPEG-4 features */
+	__u32 custom_mpeg4_support;
+	/* HW supports VC-1 Simple */
+	__u32 vc1_support;
+	/* HW supports MPEG-2 */
+	__u32 mpeg2_support;
+	/* HW supports post-processor */
+	__u32 pp_support;
+	/* HW post-processor functions bitmask */
+	__u32 pp_config;
+	/* HW supports Sorenson Spark */
+	__u32 sorenson_support;
+	/* HW supports reference picture buffering */
+	__u32 ref_buf_support;
+	/* HW supports VP6 */
+	__u32 vp6_support;
+	/* HW supports VP7 */
+	__u32 vp7_support;
+	/* HW supports VP8 */
+	__u32 vp8_support;
+	/* HW supports AVS */
+	__u32 avs_support;
+	/* HW supports JPEG extensions */
+	__u32 jpeg_ext_support;
+	__u32 reserve;
+	/* HW supports H264 MVC extension */
+	__u32 mvc_support;
+};
+
+/* Hardware encoder configuration description */
+struct vpu_enc_config {
+	/* Maximum supported width for video encoding (not JPEG) */
+	__u32 max_encoded_width;
+	/* HW supports H.264 */
+	__u32 h264_enabled;
+	/* HW supports JPEG */
+	__u32 jpeg_enabled;
+	/* HW supports MPEG-4 */
+	__u32 mpeg4_enabled;
+	/* HW supports video stabilization */
+	__u32 vs_enabled;
+	/* HW supports RGB input */
+	__u32 rgb_enabled;
+	__u32 reg_size;
+	__u32 reserv[2];
+};
+
+#endif
-- 
2.20.1

