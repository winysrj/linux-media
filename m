Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59291 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab3CHOnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:43:05 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 10/12] exynos-fimc-is: Adds the hardware interface module
Date: Fri, 08 Mar 2013 09:59:23 -0500
Message-id: <1362754765-2651-11-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware interface module finally sends the commands to the
FIMC-IS firmware and runs the interrupt handler for getting the
responses.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 .../media/platform/exynos5-is/fimc-is-interface.c  | 1003 ++++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-interface.h  |  130 +++
 2 files changed, 1133 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-interface.c b/drivers/media/platform/exynos5-is/fimc-is-interface.c
new file mode 100644
index 0000000..2537220
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-interface.c
@@ -0,0 +1,1003 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+*
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "fimc-is.h"
+#include "fimc-is-cmd.h"
+#include "fimc-is-regs.h"
+
+#define init_request_barrier(itf) mutex_init(&itf->request_barrier)
+#define enter_request_barrier(itf) mutex_lock(&itf->request_barrier)
+#define exit_request_barrier(itf) mutex_unlock(&itf->request_barrier)
+
+static inline void itf_get_cmd(struct fimc_is_interface *itf,
+	struct fimc_is_msg *msg, unsigned int index)
+{
+	struct is_common_reg __iomem *com_regs = itf->com_regs;
+
+	switch (index) {
+	case INTR_GENERAL:
+		msg->id = 0;
+		msg->command = com_regs->ihcmd;
+		msg->instance = com_regs->ihc_sensorid;
+		msg->parameter1 = com_regs->ihc_param1;
+		msg->parameter2 = com_regs->ihc_param2;
+		msg->parameter3 = com_regs->ihc_param3;
+		msg->parameter4 = com_regs->ihc_param4;
+		break;
+	case INTR_SCC_FDONE:
+		msg->id = 0;
+		msg->command = IHC_FRAME_DONE;
+		msg->instance = com_regs->scc_sensor_id;
+		msg->parameter1 = com_regs->scc_param1;
+		msg->parameter2 = com_regs->scc_param2;
+		msg->parameter3 = com_regs->scc_param3;
+		msg->parameter4 = 0;
+		break;
+	case INTR_SCP_FDONE:
+		msg->id = 0;
+		msg->command = IHC_FRAME_DONE;
+		msg->instance = com_regs->scp_sensor_id;
+		msg->parameter1 = com_regs->scp_param1;
+		msg->parameter2 = com_regs->scp_param2;
+		msg->parameter3 = com_regs->scp_param3;
+		msg->parameter4 = 0;
+		break;
+	case INTR_META_DONE:
+		msg->id = 0;
+		msg->command = IHC_FRAME_DONE;
+		msg->instance = com_regs->meta_sensor_id;
+		msg->parameter1 = com_regs->meta_param1;
+		msg->parameter2 = 0;
+		msg->parameter3 = 0;
+		msg->parameter4 = 0;
+		break;
+	case INTR_SHOT_DONE:
+		msg->id = 0;
+		msg->command = IHC_FRAME_DONE;
+		msg->instance = com_regs->shot_sensor_id;
+		msg->parameter1 = com_regs->shot_param1;
+		msg->parameter2 = com_regs->shot_param2;
+		msg->parameter3 = 0;
+		msg->parameter4 = 0;
+		break;
+	default:
+		msg->id = 0;
+		msg->command = 0;
+		msg->instance = 0;
+		msg->parameter1 = 0;
+		msg->parameter2 = 0;
+		msg->parameter3 = 0;
+		msg->parameter4 = 0;
+		is_err("unknown command getting\n");
+		break;
+	}
+}
+
+static inline unsigned int itf_get_intr(struct fimc_is_interface *itf)
+{
+	unsigned int status;
+	struct is_common_reg __iomem *com_regs = itf->com_regs;
+
+	status = readl(itf->regs + INTMSR1) | com_regs->ihcmd_iflag |
+		com_regs->scc_iflag |
+		com_regs->scp_iflag |
+		com_regs->meta_iflag |
+		com_regs->shot_iflag;
+
+	return status;
+}
+
+static void itf_set_state(struct fimc_is_interface *itf,
+		unsigned long state)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&itf->slock_state, flags);
+	set_bit(state, &itf->state);
+	spin_unlock_irqrestore(&itf->slock_state, flags);
+}
+
+static void itf_clr_state(struct fimc_is_interface *itf,
+		unsigned long state)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&itf->slock_state, flags);
+	clear_bit(state, &itf->state);
+	spin_unlock_irqrestore(&itf->slock_state, flags);
+}
+
+static int itf_get_state(struct fimc_is_interface *itf,
+		unsigned long state)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&itf->slock_state, flags);
+	ret = test_bit(state, &itf->state);
+	spin_unlock_irqrestore(&itf->slock_state, flags);
+	return ret;
+}
+
+static void itf_init_wakeup(struct fimc_is_interface *itf)
+{
+	itf_set_state(itf, IS_IF_STATE_INIT);
+	wake_up(&itf->irq_queue);
+}
+
+void itf_busy_wakeup(struct fimc_is_interface *itf)
+{
+	itf_clr_state(itf, IS_IF_STATE_BUSY);
+	wake_up(&itf->irq_queue);
+}
+
+static int itf_wait_hw_ready(struct fimc_is_interface *itf)
+{
+	int ret = 0;
+	unsigned int try_count = TRY_RECV_AWARE_COUNT;
+	unsigned int cfg = readl(itf->regs + INTMSR0);
+	unsigned int status = INTMSR0_GET_INTMSD0(cfg);
+
+	while (status) {
+		cfg = readl(itf->regs + INTMSR0);
+		status = INTMSR0_GET_INTMSD0(cfg);
+
+		if (try_count-- == 0) {
+			try_count = TRY_RECV_AWARE_COUNT;
+			is_err("INTMSR0's 0 bit is not cleared.\n");
+			ret = -EINVAL;
+			break;
+		}
+	}
+	return ret;
+}
+
+static int itf_wait_idlestate(struct fimc_is_interface *itf)
+{
+	int ret = 0;
+
+	ret = wait_event_timeout(itf->irq_queue,
+			!itf_get_state(itf, IS_IF_STATE_BUSY),
+			FIMC_IS_COMMAND_TIMEOUT);
+	if (!ret) {
+		is_err("timeout");
+		return -ETIME;
+	}
+	return 0;
+}
+
+int fimc_is_itf_wait_init_state(struct fimc_is_interface *itf)
+{
+	int ret = 0;
+
+	ret = wait_event_timeout(itf->irq_queue,
+		itf_get_state(itf, IS_IF_STATE_INIT),
+		FIMC_IS_STARTUP_TIMEOUT);
+
+	if (!ret) {
+		is_err("timeout\n");
+		return -ETIME;
+	}
+	return 0;
+}
+
+static inline void itf_clr_intr(struct fimc_is_interface *itf,
+		unsigned int index)
+{
+	struct is_common_reg __iomem *com_regs = itf->com_regs;
+
+	switch (index) {
+	case INTR_GENERAL:
+		writel((1<<INTR_GENERAL), itf->regs + INTCR1);
+		com_regs->ihcmd_iflag = 0;
+		break;
+	case INTR_SCC_FDONE:
+		writel((1<<INTR_SCC_FDONE), itf->regs + INTCR1);
+		com_regs->scc_iflag = 0;
+		break;
+	case INTR_SCP_FDONE:
+		writel((1<<INTR_SCP_FDONE), itf->regs + INTCR1);
+		com_regs->scp_iflag = 0;
+		break;
+	case INTR_META_DONE:
+		writel((1<<INTR_META_DONE), itf->regs + INTCR1);
+		com_regs->meta_iflag = 0;
+		break;
+	case INTR_SHOT_DONE:
+		writel((1<<INTR_SHOT_DONE), itf->regs + INTCR1);
+		com_regs->shot_iflag = 0;
+		break;
+	default:
+		is_err("Unknown command clear\n");
+		break;
+	}
+}
+
+/* Send Host to IS command interrupt */
+static void itf_hic_interrupt(struct fimc_is_interface *itf)
+{
+	writel(INTGR0_INTGD0, itf->regs + INTGR0);
+}
+
+int fimc_is_itf_hw_dump(struct fimc_is_interface *itf)
+{
+	struct fimc_is *is = fimc_interface_to_is(itf);
+	int debug_cnt;
+	char *debug;
+	char letter;
+	int count = 0, i;
+
+	debug = (char *)(is->minfo.fw_vaddr + DEBUG_OFFSET);
+	debug_cnt = *((int *)(is->minfo.fw_vaddr + DEBUGCTL_OFFSET))
+			- DEBUG_OFFSET;
+
+	if (itf->debug_cnt > debug_cnt)
+		count = (DEBUG_CNT - itf->debug_cnt) + debug_cnt;
+	else
+		count = debug_cnt - itf->debug_cnt;
+
+	if (count) {
+		pr_info("start(%d %d)\n", debug_cnt, count);
+		for (i = itf->debug_cnt; count > 0; count--) {
+			letter = debug[i];
+			if (letter)
+				pr_cont("%c", letter);
+			i++;
+			if (i > DEBUG_CNT)
+				i = 0;
+		}
+		itf->debug_cnt = debug_cnt;
+		pr_info("end\n");
+	}
+	return count;
+}
+
+static int itf_send_sensor_number(struct fimc_is_interface *itf)
+{
+	struct fimc_is_msg msg;
+	unsigned long flags;
+
+	msg.id = 0;
+	msg.command = ISR_DONE;
+	msg.instance = 0;
+	msg.parameter1 = IHC_GET_SENSOR_NUMBER;
+
+	msg.parameter2 = 1;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	spin_lock_irqsave(&itf->slock, flags);
+	itf->com_regs->hicmd = msg.command;
+	itf->com_regs->hic_sensorid = msg.instance;
+	itf->com_regs->hic_param1 = msg.parameter1;
+	itf->com_regs->hic_param2 = msg.parameter2;
+	itf->com_regs->hic_param3 = msg.parameter3;
+	itf->com_regs->hic_param4 = msg.parameter4;
+	itf_hic_interrupt(itf);
+	spin_unlock_irqrestore(&itf->slock, flags);
+
+	return 0;
+}
+
+static int fimc_is_itf_set_cmd(struct fimc_is_interface *itf,
+	struct fimc_is_msg *msg)
+{
+	int ret = 0;
+	bool block_io, send_cmd;
+	unsigned long flags;
+
+	enter_request_barrier(itf);
+
+	switch (msg->command) {
+	case HIC_STREAM_ON:
+		if (itf->streaming == IS_IF_STREAMING_ON) {
+			send_cmd = false;
+		} else {
+			send_cmd = true;
+			block_io = true;
+		}
+		break;
+	case HIC_STREAM_OFF:
+		if (itf->streaming == IS_IF_STREAMING_OFF) {
+			send_cmd = false;
+		} else {
+			send_cmd = true;
+			block_io = true;
+		}
+		break;
+	case HIC_PROCESS_START:
+		if (itf->processing == IS_IF_PROCESSING_ON) {
+			send_cmd = false;
+		} else {
+			send_cmd = true;
+			block_io = true;
+		}
+		break;
+	case HIC_PROCESS_STOP:
+		if (itf->processing == IS_IF_PROCESSING_OFF) {
+			send_cmd = false;
+		} else {
+			send_cmd = true;
+			block_io = true;
+		}
+		break;
+	case HIC_POWER_DOWN:
+		if (itf->pdown_ready == IS_IF_POWER_DOWN_READY) {
+			send_cmd = false;
+		} else {
+			send_cmd = true;
+			block_io = true;
+		}
+		break;
+	case HIC_OPEN_SENSOR:
+	case HIC_GET_SET_FILE_ADDR:
+	case HIC_SET_PARAMETER:
+	case HIC_PREVIEW_STILL:
+	case HIC_GET_STATIC_METADATA:
+	case HIC_SET_A5_MEM_ACCESS:
+	case HIC_SET_CAM_CONTROL:
+		send_cmd = true;
+		block_io = true;
+		break;
+	case HIC_SHOT:
+	case ISR_DONE:
+		send_cmd = true;
+		block_io = false;
+		break;
+	default:
+		send_cmd = true;
+		block_io = true;
+		break;
+	}
+
+	if (!send_cmd) {
+		is_dbg(3, "skipped\n");
+		goto exit;
+	}
+
+	ret = itf_wait_hw_ready(itf);
+	if (ret) {
+		is_err("waiting for ready is fail");
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	spin_lock_irqsave(&itf->slock, flags);
+	itf_set_state(itf, IS_IF_STATE_BUSY);
+	itf->com_regs->hicmd = msg->command;
+	itf->com_regs->hic_sensorid = msg->instance;
+	itf->com_regs->hic_param1 = msg->parameter1;
+	itf->com_regs->hic_param2 = msg->parameter2;
+	itf->com_regs->hic_param3 = msg->parameter3;
+	itf->com_regs->hic_param4 = msg->parameter4;
+	itf_hic_interrupt(itf);
+	spin_unlock_irqrestore(&itf->slock, flags);
+
+	if (!block_io)
+		goto exit;
+
+	ret = itf_wait_idlestate(itf);
+	if (ret) {
+		is_err("%d command is timeout\n", msg->command);
+		itf_clr_state(itf, IS_IF_STATE_BUSY);
+		ret = -ETIME;
+		goto exit;
+	}
+
+	if (itf->reply.command == ISR_DONE) {
+		switch (msg->command) {
+		case HIC_STREAM_ON:
+			itf->streaming = IS_IF_STREAMING_ON;
+			break;
+		case HIC_STREAM_OFF:
+			itf->streaming = IS_IF_STREAMING_OFF;
+			break;
+		case HIC_PROCESS_START:
+			itf->processing = IS_IF_PROCESSING_ON;
+			break;
+		case HIC_PROCESS_STOP:
+			itf->processing = IS_IF_PROCESSING_OFF;
+			break;
+		case HIC_POWER_DOWN:
+			itf->pdown_ready = IS_IF_POWER_DOWN_READY;
+			break;
+		case HIC_OPEN_SENSOR:
+			if (itf->reply.parameter1 == HIC_POWER_DOWN) {
+				is_err("firmware power down");
+				itf->pdown_ready = IS_IF_POWER_DOWN_READY;
+				ret = -ECANCELED;
+				goto exit;
+			} else
+				itf->pdown_ready = IS_IF_POWER_DOWN_NREADY;
+			break;
+		default:
+			break;
+		}
+	} else {
+		is_err("ISR_NDONE is occured");
+		ret = -EINVAL;
+	}
+
+exit:
+	exit_request_barrier(itf);
+
+	if (ret)
+		fimc_is_itf_hw_dump(itf);
+
+	return ret;
+}
+
+static int fimc_is_itf_set_cmd_shot(struct fimc_is_interface *itf,
+		struct fimc_is_msg *msg)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&itf->slock, flags);
+	itf->com_regs->hicmd = msg->command;
+	itf->com_regs->hic_sensorid = msg->instance;
+	itf->com_regs->hic_param1 = msg->parameter1;
+	itf->com_regs->hic_param2 = msg->parameter2;
+	itf->com_regs->hic_param3 = msg->parameter3;
+	itf->com_regs->hic_param4 = msg->parameter4;
+	itf->com_regs->fcount = msg->parameter3;
+	itf_hic_interrupt(itf);
+	spin_unlock_irqrestore(&itf->slock, flags);
+
+	return ret;
+}
+
+static void itf_handle_general(struct fimc_is_interface *itf,
+		struct fimc_is_msg *msg)
+{
+	switch (msg->command) {
+
+	case IHC_GET_SENSOR_NUMBER:
+		is_dbg(3, "IS version : %d.%d\n",
+			ISDRV_VERSION, msg->parameter1);
+		/* Respond with sensor number */
+		itf_send_sensor_number(itf);
+		itf_init_wakeup(itf);
+		break;
+	case ISR_DONE:
+		switch (msg->parameter1) {
+		case HIC_OPEN_SENSOR:
+			is_dbg(3, "open done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_GET_SET_FILE_ADDR:
+			is_dbg(3, "saddr(%p) done\n",
+				(void *)msg->parameter2);
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_LOAD_SET_FILE:
+			is_dbg(3, "setfile done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_SET_A5_MEM_ACCESS:
+			is_dbg(3, "cfgmem done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_PROCESS_START:
+			is_dbg(3, "process_on done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_PROCESS_STOP:
+			is_dbg(3, "process_off done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_STREAM_ON:
+			is_dbg(3, "stream_on done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_STREAM_OFF:
+			is_dbg(3, "stream_off done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_SET_PARAMETER:
+			is_dbg(3, "s_param done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_GET_STATIC_METADATA:
+			is_dbg(3, "g_capability done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_PREVIEW_STILL:
+			is_dbg(3, "a_param(%dx%d) done\n",
+				msg->parameter2,
+				msg->parameter3);
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		case HIC_POWER_DOWN:
+			is_dbg(3, "powerdown done\n");
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		/*non-blocking command*/
+		case HIC_SHOT:
+			is_err("shot done is not acceptable\n");
+			break;
+		case HIC_SET_CAM_CONTROL:
+			is_err("camctrl is not acceptable\n");
+			break;
+		default:
+			is_err("unknown done is invokded\n");
+			break;
+		}
+		break;
+	case ISR_NDONE:
+		switch (msg->parameter1) {
+		case HIC_SHOT:
+			is_err("shot NOT done is not acceptable\n");
+			break;
+		case HIC_SET_CAM_CONTROL:
+			is_dbg(3, "camctrl NOT done\n");
+			break;
+		case HIC_SET_PARAMETER:
+			is_err("s_param NOT done\n");
+			is_err("param2 : 0x%08X\n", msg->parameter2);
+			is_err("param3 : 0x%08X\n", msg->parameter3);
+			is_err("param4 : 0x%08X\n", msg->parameter4);
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		default:
+			is_err("a command(%d) not done", msg->parameter1);
+			memcpy(&itf->reply, msg,
+				sizeof(struct fimc_is_msg));
+			itf_busy_wakeup(itf);
+			break;
+		}
+		break;
+	case IHC_SET_FACE_MARK:
+		is_err("FACE_MARK(%d,%d,%d) is not acceptable\n",
+			msg->parameter1,
+			msg->parameter2,
+			msg->parameter3);
+		break;
+	case IHC_AA_DONE:
+		is_err("AA_DONE(%d,%d,%d) is not acceptable\n",
+			msg->parameter1,
+			msg->parameter2,
+			msg->parameter3);
+		break;
+	case IHC_FLASH_READY:
+		is_err("IHC_FLASH_READY is not acceptable");
+		break;
+	case IHC_NOT_READY:
+		is_err("IHC_NOT_READY is occured, need reset");
+		break;
+	default:
+		is_err("func_general unknown(0x%08X) end\n", msg->command);
+		break;
+	}
+}
+
+static void itf_handle_scaler_done(struct fimc_is_interface *itf,
+		struct fimc_is_msg *msg)
+{
+	struct fimc_is *is = fimc_interface_to_is(itf);
+	struct fimc_is_pipeline *pipeline = &is->pipeline;
+	struct fimc_is_buf *buf;
+	struct fimc_is_scaler *scl;
+	struct fimc_is_fmt *fmt;
+	struct timeval *tv;
+	struct timespec ts;
+	unsigned int wh, i;
+	unsigned int fcount = msg->parameter1;
+	unsigned long *comp_state;
+
+	if (msg->parameter4 == SCALER_SCC) {
+		scl = &pipeline->scaler[SCALER_SCC];
+		comp_state = &pipeline->comp_state[IS_SCC];
+	} else {
+		scl = &pipeline->scaler[SCALER_SCP];
+		comp_state = &pipeline->comp_state[IS_SCP];
+	}
+
+	fmt = scl->fmt;
+
+	fimc_is_pipeline_buf_lock(pipeline);
+	if (!list_empty(&scl->run_queue)) {
+
+		wh = scl->width * scl->height;
+		buf = fimc_is_scaler_run_queue_get(scl);
+		for (i = 0; i < fmt->num_planes; i++) {
+			vb2_set_plane_payload(buf->vb, i,
+					(wh * fmt->depth[i]) / 8);
+		}
+
+		/* Set timestamp */
+		ktime_get_ts(&ts);
+		tv = &buf->vb->v4l2_buf.timestamp;
+		tv->tv_sec = ts.tv_sec;
+		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+		buf->vb->v4l2_buf.sequence = fcount;
+
+		is_dbg(5, "SCP buffer done %d/%d\n",
+				msg->parameter1, msg->parameter3);
+		vb2_buffer_done(buf->vb, VB2_BUF_STATE_DONE);
+	}
+	fimc_is_pipeline_buf_unlock(pipeline);
+	clear_bit(COMP_RUN, comp_state);
+	wake_up(&scl->event_q);
+}
+
+static void itf_handle_shot_done(struct fimc_is_interface *itf,
+		struct fimc_is_msg *msg)
+{
+	struct fimc_is *is = fimc_interface_to_is(itf);
+	struct fimc_is_pipeline *pipeline = &is->pipeline;
+	unsigned int status = msg->parameter2;
+	struct fimc_is_buf *bayer_buf;
+	int ret;
+
+	if (status != ISR_DONE)
+		is_err("Shot done is invalid(0x%08X)\n", status);
+
+	/* DQ the bayer input buffer */
+	fimc_is_pipeline_buf_lock(pipeline);
+	bayer_buf = fimc_is_isp_run_queue_get(&pipeline->isp);
+	if (bayer_buf) {
+		vb2_buffer_done(bayer_buf->vb, VB2_BUF_STATE_DONE);
+		is_dbg(5, "Bayer buffer done.\n");
+	}
+	fimc_is_pipeline_buf_unlock(pipeline);
+
+	/* Clear state & call shot again */
+	clear_bit(PIPELINE_RUN, &pipeline->state);
+
+	ret = fimc_is_pipeline_shot(pipeline);
+	if (ret)
+		is_err("Shot failed\n");
+}
+
+/* Main FIMC-IS interrupt handler */
+static irqreturn_t itf_irq_handler(int irq, void *data)
+{
+	struct fimc_is_interface *itf;
+	struct fimc_is_msg msg;
+	unsigned int status;
+
+	itf = (struct fimc_is_interface *)data;
+	status = itf_get_intr(itf);
+
+	if (status & (1<<INTR_SHOT_DONE)) {
+		itf_get_cmd(itf, &msg, INTR_SHOT_DONE);
+
+		itf_handle_shot_done(itf, &msg);
+
+		status &= ~(1<<INTR_SHOT_DONE);
+		itf_clr_intr(itf, INTR_SHOT_DONE);
+	}
+
+	if (status & (1<<INTR_GENERAL)) {
+		itf_get_cmd(itf, &msg, INTR_GENERAL);
+
+		itf_handle_general(itf, &msg);
+
+		status &= ~(1<<INTR_GENERAL);
+		itf_clr_intr(itf, INTR_GENERAL);
+	}
+
+	if (status & (1<<INTR_SCC_FDONE)) {
+		itf_get_cmd(itf, &msg, INTR_SCC_FDONE);
+
+		msg.parameter4 = SCALER_SCC;
+		itf_handle_scaler_done(itf, &msg);
+
+		status &= ~(1<<INTR_SCC_FDONE);
+		itf_clr_intr(itf, INTR_SCC_FDONE);
+	}
+
+	if (status & (1<<INTR_SCP_FDONE)) {
+		itf_get_cmd(itf, &msg, INTR_SCP_FDONE);
+
+		msg.parameter4 = SCALER_SCP;
+		itf_handle_scaler_done(itf, &msg);
+
+		status &= ~(1<<INTR_SCP_FDONE);
+		itf_clr_intr(itf, INTR_SCP_FDONE);
+	}
+
+	if (status & (1<<INTR_META_DONE)) {
+		status &= ~(1<<INTR_META_DONE);
+		itf_clr_intr(itf, INTR_META_DONE);
+	}
+
+	if (status != 0)
+		is_err("status is NOT all clear(0x%08X)", status);
+
+	return IRQ_HANDLED;
+}
+
+int fimc_is_itf_open_sensor(struct fimc_is_interface *itf,
+		unsigned int instance,
+		unsigned int sensor_id,
+		unsigned int i2c_channel,
+		unsigned int sensor_ext)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_OPEN_SENSOR;
+	msg.instance = instance;
+	msg.parameter1 = sensor_id;
+	msg.parameter2 = i2c_channel;
+	msg.parameter3 = sensor_ext;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_get_setfile_addr(struct fimc_is_interface *itf,
+		unsigned int instance, unsigned int *setfile_addr)
+{
+	int ret;
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_GET_SET_FILE_ADDR;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	ret = fimc_is_itf_set_cmd(itf, &msg);
+	*setfile_addr = itf->reply.parameter2;
+
+	return ret;
+}
+
+int fimc_is_itf_load_setfile(struct fimc_is_interface *itf,
+		unsigned int instance)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_LOAD_SET_FILE;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_stream_on(struct fimc_is_interface *itf,
+		unsigned int instance)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_STREAM_ON;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_stream_off(struct fimc_is_interface *itf,
+		unsigned int instance)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_STREAM_OFF;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_process_on(struct fimc_is_interface *itf,
+		unsigned int instance)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_PROCESS_START;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_process_off(struct fimc_is_interface *itf,
+		unsigned int instance)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_PROCESS_STOP;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_set_param(struct fimc_is_interface *itf,
+		unsigned int instance,
+		unsigned int indexes,
+		unsigned int lindex,
+		unsigned int hindex)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_SET_PARAMETER;
+	msg.instance = instance;
+	msg.parameter1 = ISS_PREVIEW_STILL;
+	msg.parameter2 = indexes;
+	msg.parameter3 = lindex;
+	msg.parameter4 = hindex;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_preview_still(struct fimc_is_interface *itf,
+		unsigned int instance)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_PREVIEW_STILL;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_get_capability(struct fimc_is_interface *itf,
+	unsigned int instance, unsigned int address)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_GET_STATIC_METADATA;
+	msg.instance = instance;
+	msg.parameter1 = address;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_cfg_mem(struct fimc_is_interface *itf,
+		unsigned int instance, unsigned int address,
+		unsigned int size)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_SET_A5_MEM_ACCESS;
+	msg.instance = instance;
+	msg.parameter1 = address;
+	msg.parameter2 = size;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	return fimc_is_itf_set_cmd(itf, &msg);
+}
+
+int fimc_is_itf_shot_nblk(struct fimc_is_interface *itf,
+		unsigned int instance, unsigned int bayer,
+		unsigned int shot, unsigned int fcount, unsigned int rcount)
+{
+	struct fimc_is_msg msg;
+
+	msg.id = 0;
+	msg.command = HIC_SHOT;
+	msg.instance = instance;
+	msg.parameter1 = bayer;
+	msg.parameter2 = shot;
+	msg.parameter3 = fcount;
+	msg.parameter4 = rcount;
+
+	return fimc_is_itf_set_cmd_shot(itf, &msg);
+}
+
+int fimc_is_itf_power_down(struct fimc_is_interface *itf,
+		unsigned int instance)
+{
+	struct fimc_is_msg msg;
+	int ret;
+
+	msg.id = 0;
+	msg.command = HIC_POWER_DOWN;
+	msg.instance = instance;
+	msg.parameter1 = 0;
+	msg.parameter2 = 0;
+	msg.parameter3 = 0;
+	msg.parameter4 = 0;
+
+	ret = fimc_is_itf_set_cmd(itf, &msg);
+	itf_clr_state(itf, IS_IF_STATE_INIT);
+
+	return ret;
+}
+
+int fimc_is_interface_init(struct fimc_is_interface *itf,
+		void __iomem *regs, int irq)
+{
+	struct fimc_is *is = fimc_interface_to_is(itf);
+	struct device *dev = &is->pdev->dev;
+	int ret;
+
+	if (!regs || !irq) {
+		is_err("Invalid args\n");
+		return -EINVAL;
+	}
+
+	itf->regs = regs;
+	itf->com_regs = (struct is_common_reg *)(regs + ISSR0);
+
+	init_waitqueue_head(&itf->irq_queue);
+	spin_lock_init(&itf->slock_state);
+	spin_lock_init(&itf->slock);
+
+	/* Register interrupt handler */
+	ret = devm_request_irq(dev, irq, itf_irq_handler,
+			       0, dev_name(dev), itf);
+	if (ret) {
+		dev_err(dev, "Failed to install irq (%d)\n", ret);
+		return -EINVAL;
+	}
+
+	/* Initialize context vars */
+	itf->streaming = IS_IF_STREAMING_INIT;
+	itf->processing = IS_IF_PROCESSING_INIT;
+	itf->pdown_ready = IS_IF_POWER_DOWN_READY;
+	itf->debug_cnt = 0;
+	init_request_barrier(itf);
+
+	return 0;
+}
diff --git a/drivers/media/platform/exynos5-is/fimc-is-interface.h b/drivers/media/platform/exynos5-is/fimc-is-interface.h
new file mode 100644
index 0000000..54f3aec
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-interface.h
@@ -0,0 +1,130 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *  Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_INTERFACE_H_
+#define FIMC_IS_INTERFACE_H_
+
+#include "fimc-is-core.h"
+
+#define TRY_RECV_AWARE_COUNT    100
+
+#define ISDRV_VERSION		111
+
+#define LOWBIT_OF(num)  (num >= 32 ? 0 : (unsigned int)1<<num)
+#define HIGHBIT_OF(num) (num >= 32 ? (unsigned int)1<<(num-32) : 0)
+
+enum interrupt_map {
+	INTR_GENERAL            = 0,
+	INTR_ISP_FDONE          = 1,
+	INTR_SCC_FDONE          = 2,
+	INTR_DNR_FDONE          = 3,
+	INTR_SCP_FDONE          = 4,
+	/* 5 is ISP YUV DONE */
+	INTR_META_DONE          = 6,
+	INTR_SHOT_DONE          = 7,
+	INTR_MAX_MAP
+};
+
+enum fimc_is_interface_state {
+	IS_IF_STATE_INIT,
+	IS_IF_STATE_OPEN,
+	IS_IF_STATE_START,
+	IS_IF_STATE_BUSY
+};
+
+enum streaming_state {
+	IS_IF_STREAMING_INIT,
+	IS_IF_STREAMING_OFF,
+	IS_IF_STREAMING_ON
+};
+
+enum processing_state {
+	IS_IF_PROCESSING_INIT,
+	IS_IF_PROCESSING_OFF,
+	IS_IF_PROCESSING_ON
+};
+
+enum pdown_ready_state {
+	IS_IF_POWER_DOWN_READY,
+	IS_IF_POWER_DOWN_NREADY
+};
+
+struct fimc_is_msg {
+	unsigned int	id;
+	unsigned int	command;
+	unsigned int	instance;
+	unsigned int	parameter1;
+	unsigned int	parameter2;
+	unsigned int	parameter3;
+	unsigned int	parameter4;
+};
+
+struct fimc_is_interface {
+
+	unsigned long			state;
+
+	void __iomem			*regs;
+	struct is_common_reg __iomem    *com_regs;
+	spinlock_t			slock;
+	spinlock_t			slock_state;
+	wait_queue_head_t		irq_queue;
+
+	spinlock_t			process_barrier;
+	struct mutex			request_barrier;
+
+	enum streaming_state		streaming;
+	enum processing_state		processing;
+	enum pdown_ready_state		pdown_ready;
+
+	struct fimc_is_msg		reply;
+
+	int				debug_cnt;
+
+};
+
+int fimc_is_interface_init(struct fimc_is_interface *itf,
+		void __iomem *regs, int irq);
+int fimc_is_itf_wait_init_state(struct fimc_is_interface *itf);
+int fimc_is_itf_hw_dump(struct fimc_is_interface *itf);
+int fimc_is_itf_open_sensor(struct fimc_is_interface *itf,
+		unsigned int instance,
+		unsigned int sensor_id,
+		unsigned int i2c_channel,
+		unsigned int sensor_ext);
+int fimc_is_itf_get_setfile_addr(struct fimc_is_interface *this,
+		unsigned int instance, unsigned int *setfile_addr);
+int fimc_is_itf_load_setfile(struct fimc_is_interface *itf,
+		unsigned int instance);
+int fimc_is_itf_stream_on(struct fimc_is_interface *itf,
+		unsigned int instance);
+int fimc_is_itf_stream_off(struct fimc_is_interface *itf,
+		unsigned int instance);
+int fimc_is_itf_process_on(struct fimc_is_interface *itf,
+		unsigned int instance);
+int fimc_is_itf_process_off(struct fimc_is_interface *itf,
+		unsigned int instance);
+int fimc_is_itf_set_param(struct fimc_is_interface *this,
+		unsigned int instance,
+		unsigned int indexes,
+		unsigned int lindex,
+		unsigned int hindex);
+int fimc_is_itf_preview_still(struct fimc_is_interface *itf,
+		unsigned int instance);
+int fimc_is_itf_get_capability(struct fimc_is_interface *itf,
+	unsigned int instance, unsigned int address);
+int fimc_is_itf_cfg_mem(struct fimc_is_interface *itf,
+		unsigned int instance, unsigned int address,
+		unsigned int size);
+int fimc_is_itf_shot_nblk(struct fimc_is_interface *itf,
+		unsigned int instance, unsigned int bayer,
+		unsigned int shot, unsigned int fcount, unsigned int rcount);
+int fimc_is_itf_power_down(struct fimc_is_interface *itf,
+		unsigned int instance);
+#endif
-- 
1.7.9.5

