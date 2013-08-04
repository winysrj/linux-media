Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53584 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3HDPD2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Aug 2013 11:03:28 -0400
Message-ID: <51FE6D38.6020208@gmail.com>
Date: Sun, 04 Aug 2013 17:03:20 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v3 10/13] [media] exynos5-fimc-is: Add the hardware interface
 module
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-11-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-11-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 08/02/2013 05:02 PM, Arun Kumar K wrote:
> The hardware interface module finally sends the commands to the
> FIMC-IS firmware and runs the interrupt handler for getting the
> responses.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   .../media/platform/exynos5-is/fimc-is-interface.c  |  861 ++++++++++++++++++++
>   .../media/platform/exynos5-is/fimc-is-interface.h  |  128 +++
>   2 files changed, 989 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.c
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-interface.c b/drivers/media/platform/exynos5-is/fimc-is-interface.c
> new file mode 100644
> index 0000000..12073be
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-interface.c
> @@ -0,0 +1,861 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> +*
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Kil-yeon Lim<kilyeon.im@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<linux/debugfs.h>
> +#include<linux/seq_file.h>
> +#include "fimc-is.h"
> +#include "fimc-is-cmd.h"
> +#include "fimc-is-regs.h"
> +
> +#define init_request_barrier(itf) mutex_init(&itf->request_barrier)
> +#define enter_request_barrier(itf) mutex_lock(&itf->request_barrier)
> +#define exit_request_barrier(itf) mutex_unlock(&itf->request_barrier)
> +
> +static inline void itf_get_cmd(struct fimc_is_interface *itf,
> +	struct fimc_is_msg *msg, unsigned int index)
> +{
> +	struct is_common_reg __iomem *com_regs = itf->com_regs;
> +
> +	memset(msg, 0, sizeof(*msg));
> +
> +	switch (index) {
> +	case INTR_GENERAL:
> +		msg->command = com_regs->ihcmd;
> +		msg->instance = com_regs->ihc_sensorid;

nit: How about doing something like:

		memcpy(msg->param, com_regs->ihc_param,
				4 * sizeof(mgs->iparam[0]);

for such repeated assignments ?

> +		msg->param[0] = com_regs->ihc_param[0];
> +		msg->param[1] = com_regs->ihc_param[1];
> +		msg->param[2] = com_regs->ihc_param[2];
> +		msg->param[3] = com_regs->ihc_param[3];
> +		break;
> +	case INTR_SCC_FDONE:
> +		msg->command = IHC_FRAME_DONE;
> +		msg->instance = com_regs->scc_sensor_id;
> +		msg->param[0] = com_regs->scc_param[0];
> +		msg->param[1] = com_regs->scc_param[1];
> +		msg->param[2] = com_regs->scc_param[2];
> +		break;
> +	case INTR_SCP_FDONE:
> +		msg->command = IHC_FRAME_DONE;
> +		msg->instance = com_regs->scp_sensor_id;
> +		msg->param[0] = com_regs->scp_param[0];
> +		msg->param[1] = com_regs->scp_param[1];
> +		msg->param[2] = com_regs->scp_param[2];
> +		break;
> +	case INTR_META_DONE:
> +		msg->command = IHC_FRAME_DONE;
> +		msg->instance = com_regs->meta_sensor_id;
> +		msg->param[0] = com_regs->meta_param1;
> +		break;
> +	case INTR_SHOT_DONE:
> +		msg->command = IHC_FRAME_DONE;
> +		msg->instance = com_regs->shot_sensor_id;
> +		msg->param[0] = com_regs->shot_param[0];
> +		msg->param[1] = com_regs->shot_param[1];
> +		break;
> +	default:
> +		pr_err("unknown command getting\n");

Would be nice to have at least function name in that log message.

> +		break;
> +	}
> +}
> +
> +static inline unsigned int itf_get_intr(struct fimc_is_interface *itf)
> +{
> +	unsigned int status;
> +	struct is_common_reg __iomem *com_regs = itf->com_regs;
> +
> +	status = readl(itf->regs + INTMSR1) | com_regs->ihcmd_iflag |
> +		com_regs->scc_iflag |
> +		com_regs->scp_iflag |
> +		com_regs->meta_iflag |
> +		com_regs->shot_iflag;
> +
> +	return status;
> +}
> +
> +static void itf_set_state(struct fimc_is_interface *itf,
> +		unsigned long state)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&itf->slock_state, flags);
> +	__set_bit(state,&itf->state);
> +	spin_unlock_irqrestore(&itf->slock_state, flags);
> +}
> +
> +static void itf_clr_state(struct fimc_is_interface *itf,
> +		unsigned long state)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&itf->slock_state, flags);
> +	__clear_bit(state,&itf->state);
> +	spin_unlock_irqrestore(&itf->slock_state, flags);
> +}
> +
> +static int itf_get_state(struct fimc_is_interface *itf,
> +		unsigned long state)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&itf->slock_state, flags);
> +	ret = test_bit(state,&itf->state);

Shouldn't it be __test_bit() ?

> +	spin_unlock_irqrestore(&itf->slock_state, flags);
> +	return ret;
> +}
> +
> +static void itf_init_wakeup(struct fimc_is_interface *itf)
> +{
> +	itf_set_state(itf, IS_IF_STATE_INIT);
> +	wake_up(&itf->irq_queue);
> +}
> +
> +void itf_busy_wakeup(struct fimc_is_interface *itf)
> +{
> +	itf_clr_state(itf, IS_IF_STATE_BUSY);
> +	wake_up(&itf->irq_queue);
> +}
> +
> +static int itf_wait_hw_ready(struct fimc_is_interface *itf)
> +{
> +	int t;
> +	for (t = TRY_RECV_AWARE_COUNT; t>= 0; t--) {
> +		unsigned int cfg = readl(itf->regs + INTMSR0);

> +		unsigned int status = INTMSR0_GET_INTMSD(0, cfg);
> +		if (!status)
> +			return 0;

You could simplify this to:

		if (INTMSR0_GET_INTMSD(0, cfg) == 0)
			return 0;

> +	}
> +	pr_err("INTMSR0's 0 bit is not cleared.\n");
> +	return -EINVAL;
> +}
> +
> +static int itf_wait_idlestate(struct fimc_is_interface *itf)
> +{
> +	int ret;
> +
> +	ret = wait_event_timeout(itf->irq_queue,
> +			!itf_get_state(itf, IS_IF_STATE_BUSY),
> +			FIMC_IS_COMMAND_TIMEOUT);
> +	if (!ret) {
> +		pr_err("timeout");

Sorry, this is a pretty useless log. It has neither function nor device
name appended. Just imagine other subsystems spitting such single "timeout"
messages. You can't even use grep reasonably with such messages.

> +		return -ETIME;
> +	}
> +	return 0;
> +}
> +
> +int fimc_is_itf_wait_init_state(struct fimc_is_interface *itf)
> +{
> +	int ret = 0;

Unneeded initialization.

> +	ret = wait_event_timeout(itf->irq_queue,
> +		itf_get_state(itf, IS_IF_STATE_INIT),
> +		FIMC_IS_STARTUP_TIMEOUT);
> +
> +	if (!ret) {
> +		pr_err("timeout\n");

Again, single word contextless log message.

> +		return -ETIME;
> +	}
> +	return 0;
> +}
> +
> +/* Send Host to IS command interrupt */
> +static void itf_hic_interrupt(struct fimc_is_interface *itf)
> +{
> +	writel(INTGR0_INTGD(0), itf->regs + INTGR0);
> +}
> +
> +static int itf_send_sensor_number(struct fimc_is_interface *itf)
> +{
> +	struct fimc_is_msg msg = {
> +		.command = ISR_DONE,
> +		.param[0] = IHC_GET_SENSOR_NUMBER,
> +		.param[1] = 1

.param = { IHC_GET_SENSOR_NUMBER, 1 },

?

> +	};
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&itf->slock, flags);
> +	itf->com_regs->hicmd = msg.command;
> +	itf->com_regs->hic_sensorid = msg.instance;
> +	itf->com_regs->hic_param[0] = msg.param[0];
> +	itf->com_regs->hic_param[1] = msg.param[1];
> +	itf->com_regs->hic_param[2] = msg.param[2];
> +	itf->com_regs->hic_param[3] = msg.param[3];

	memcpy(itf->com_regs->hic_param, msg.param,
			4 * sizeof(msg.param[0]));

?
> +	itf_hic_interrupt(itf);
> +	spin_unlock_irqrestore(&itf->slock, flags);
> +
> +	return 0;
> +}
> +
> +static int fimc_is_itf_set_cmd(struct fimc_is_interface *itf,
> +	struct fimc_is_msg *msg)
> +{
> +	int ret = 0;
> +	bool block_io;

To simplify the below switch statement you could initialize block_io
here:

	bool block_io = true;

> +	unsigned long flags;
> +
> +	enter_request_barrier(itf);
> +
> +	switch (msg->command) {
> +	case HIC_STREAM_ON:
> +		if (itf->streaming == IS_IF_STREAMING_ON)
> +			goto exit;
> +		else
> +			block_io = true;

And remove all those else\nblock_io = true; statements.

> +		break;
> +	case HIC_STREAM_OFF:
> +		if (itf->streaming == IS_IF_STREAMING_OFF)
> +			goto exit;
> +		else
> +			block_io = true;
> +		break;
> +	case HIC_PROCESS_START:
> +		if (itf->processing == IS_IF_PROCESSING_ON)
> +			goto exit;
> +		else
> +			block_io = true;
> +		break;
> +	case HIC_PROCESS_STOP:
> +		if (itf->processing == IS_IF_PROCESSING_OFF)
> +			goto exit;
> +		else
> +			block_io = true;
> +		break;
> +	case HIC_POWER_DOWN:
> +		if (itf->pdown_ready == IS_IF_POWER_DOWN_READY)
> +			goto exit;
> +		else
> +			block_io = true;
> +		break;
> +	case HIC_OPEN_SENSOR:
> +	case HIC_GET_SET_FILE_ADDR:
> +	case HIC_SET_PARAMETER:
> +	case HIC_PREVIEW_STILL:
> +	case HIC_GET_STATIC_METADATA:
> +	case HIC_SET_A5_MEM_ACCESS:
> +	case HIC_SET_CAM_CONTROL:
> +		block_io = true;
> +		break;
> +	case HIC_SHOT:
> +	case ISR_DONE:
> +		block_io = false;
> +		break;
> +	default:
> +		block_io = true;
> +		break;
> +	}
> +
> +	ret = itf_wait_hw_ready(itf);
> +	if (ret) {
> +		pr_err("waiting for ready is fail");

This message seems grammatically incorrect, perhaps:

	pr_err("%s: itf_wait_hw_ready() failed", __func__);

?
> +		ret = -EBUSY;
> +		goto exit;
> +	}
> +
> +	spin_lock_irqsave(&itf->slock, flags);
> +	itf_set_state(itf, IS_IF_STATE_BUSY);
> +	itf->com_regs->hicmd = msg->command;
> +	itf->com_regs->hic_sensorid = msg->instance;
> +	itf->com_regs->hic_param[0] = msg->param[0];
> +	itf->com_regs->hic_param[1] = msg->param[1];
> +	itf->com_regs->hic_param[2] = msg->param[2];
> +	itf->com_regs->hic_param[3] = msg->param[3];

	memcpy(itf->com_regs->hic_param, msg->param,
				4 * sizeof(msg->param[0]));
?
> +	itf_hic_interrupt(itf);
> +	spin_unlock_irqrestore(&itf->slock, flags);
> +
> +	if (!block_io)
> +		goto exit;
> +
> +	ret = itf_wait_idlestate(itf);
> +	if (ret) {
> +		pr_err("%d command is timeout\n", msg->command);
> +		itf_clr_state(itf, IS_IF_STATE_BUSY);
> +		ret = -ETIME;
> +		goto exit;
> +	}
> +
> +	if (itf->reply.command == ISR_DONE) {
> +		switch (msg->command) {
> +		case HIC_STREAM_ON:
> +			itf->streaming = IS_IF_STREAMING_ON;
> +			break;
> +		case HIC_STREAM_OFF:
> +			itf->streaming = IS_IF_STREAMING_OFF;
> +			break;
> +		case HIC_PROCESS_START:
> +			itf->processing = IS_IF_PROCESSING_ON;
> +			break;
> +		case HIC_PROCESS_STOP:
> +			itf->processing = IS_IF_PROCESSING_OFF;
> +			break;
> +		case HIC_POWER_DOWN:
> +			itf->pdown_ready = IS_IF_POWER_DOWN_READY;
> +			break;
> +		case HIC_OPEN_SENSOR:
> +			if (itf->reply.param[0] == HIC_POWER_DOWN) {
> +				pr_err("firmware power down");

Add function name prefix.

> +				itf->pdown_ready = IS_IF_POWER_DOWN_READY;
> +				ret = -ECANCELED;
> +				goto exit;
> +			} else
> +				itf->pdown_ready = IS_IF_POWER_DOWN_NREADY;
> +			break;
> +		default:
> +			break;
> +		}
> +	} else {
> +		pr_err("ISR_NDONE is occured");

s/is occured/occured.

> +		ret = -EINVAL;
> +	}
> +exit:
> +	exit_request_barrier(itf);
> +
> +	if (ret)
> +		pr_err("Error returned from FW. See debugfs for error log\n");
> +
> +

nit: Superfluous empty line.

> +	return ret;
> +}
> +
> +static int fimc_is_itf_set_cmd_shot(struct fimc_is_interface *itf,
> +		struct fimc_is_msg *msg)
> +{
> +	int ret = 0;

You could remove this variable and just return 0 below. Or perhaps
this function should be returning void.

> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&itf->slock, flags);
> +	itf->com_regs->hicmd = msg->command;
> +	itf->com_regs->hic_sensorid = msg->instance;

> +	itf->com_regs->hic_param[0] = msg->param[0];
> +	itf->com_regs->hic_param[1] = msg->param[1];
> +	itf->com_regs->hic_param[2] = msg->param[2];
> +	itf->com_regs->hic_param[3] = msg->param[3];

	memcpy(itf->com_regs->hic_param, msg->param,
				4 * sizeof(msg->param[0]));
?
> +	itf->com_regs->fcount = msg->param[2];
> +	itf_hic_interrupt(itf);
> +	spin_unlock_irqrestore(&itf->slock, flags);
> +
> +	return ret;
> +}
> +
> +static void itf_handle_general(struct fimc_is_interface *itf,
> +		struct fimc_is_msg *msg)
> +{
> +	bool is_blocking = true;
> +
> +	switch (msg->command) {
> +
> +	case IHC_GET_SENSOR_NUMBER:
> +		pr_debug("IS version : %d.%d\n",
> +			ISDRV_VERSION, msg->param[0]);
> +		/* Respond with sensor number */
> +		itf_send_sensor_number(itf);
> +		itf_init_wakeup(itf);
> +		break;
> +	case ISR_DONE:
> +		switch (msg->param[0]) {
> +		case HIC_OPEN_SENSOR:
> +			pr_debug("open done\n");
> +			break;
> +		case HIC_GET_SET_FILE_ADDR:
> +			pr_debug("saddr(%p) done\n",
> +				(void *)msg->param[1]);
> +			break;
> +		case HIC_LOAD_SET_FILE:
> +			pr_debug("setfile done\n");
> +			break;
> +		case HIC_SET_A5_MEM_ACCESS:
> +			pr_debug("cfgmem done\n");
> +			break;
> +		case HIC_PROCESS_START:
> +			pr_debug("process_on done\n");
> +			break;
> +		case HIC_PROCESS_STOP:
> +			pr_debug("process_off done\n");
> +			break;
> +		case HIC_STREAM_ON:
> +			pr_debug("stream_on done\n");
> +			break;
> +		case HIC_STREAM_OFF:
> +			pr_debug("stream_off done\n");
> +			break;
> +		case HIC_SET_PARAMETER:
> +			pr_debug("s_param done\n");
> +			break;
> +		case HIC_GET_STATIC_METADATA:
> +			pr_debug("g_capability done\n");
> +			break;
> +		case HIC_PREVIEW_STILL:
> +			pr_debug("a_param(%dx%d) done\n",
> +				msg->param[1],
> +				msg->param[2]);

nit: Couldn't that msg->param* be in one line instead ?

> +			break;
> +		case HIC_POWER_DOWN:
> +			pr_debug("powerdown done\n");
> +			break;
> +		/*non-blocking command*/

nit: Add space after /* and before */.

> +		case HIC_SHOT:
> +			is_blocking = false;
> +			pr_err("shot done is not acceptable\n");
> +			break;
> +		case HIC_SET_CAM_CONTROL:
> +			is_blocking = false;
> +			pr_err("camctrl is not acceptable\n");
> +			break;
> +		default:
> +			is_blocking = false;
> +			pr_err("unknown done is invokded\n");
> +			break;
> +		}
> +		break;
> +	case ISR_NDONE:
> +		switch (msg->param[0]) {
> +		case HIC_SHOT:
> +			is_blocking = false;
> +			pr_err("shot NOT done is not acceptable\n");
> +			break;
> +		case HIC_SET_CAM_CONTROL:
> +			is_blocking = false;
> +			pr_debug("camctrl NOT done\n");
> +			break;
> +		case HIC_SET_PARAMETER:
> +			pr_err("s_param NOT done\n");
> +			pr_err("param2 : 0x%08X\n", msg->param[1]);
> +			pr_err("param3 : 0x%08X\n", msg->param[2]);
> +			pr_err("param4 : 0x%08X\n", msg->param[3]);
> +			break;
> +		default:
> +			pr_err("a command(%d) not done", msg->param[0]);
> +			break;
> +		}
> +		break;
> +	case IHC_SET_FACE_MARK:
> +		is_blocking = false;
> +		pr_err("FACE_MARK(%d,%d,%d) is not acceptable\n",
> +			msg->param[0],
> +			msg->param[1],
> +			msg->param[2]);

Ditto.

> +		break;
> +	case IHC_AA_DONE:
> +		is_blocking = false;
> +		pr_err("AA_DONE(%d,%d,%d) is not acceptable\n",
> +			msg->param[0],
> +			msg->param[1],
> +			msg->param[2]);

Ditto.

> +		break;
> +	case IHC_FLASH_READY:
> +		is_blocking = false;
> +		pr_err("IHC_FLASH_READY is not acceptable");
> +		break;
> +	case IHC_NOT_READY:
> +		is_blocking = false;
> +		pr_err("IHC_NOT_READY is occured, need reset");
> +		break;
> +	default:
> +		is_blocking = false;
> +		pr_err("func_general unknown(0x%08X) end\n", msg->command);

This message is a bit weird, maybe:

		pr_err("%s: unknown (#%08X) command\n", __func__, msg->command);

?
> +		break;
> +	}
> +
> +	if (is_blocking) {
> +		memcpy(&itf->reply, msg,
> +			sizeof(struct fimc_is_msg));

Unnecessarily broken into two lines ?

> +		itf_busy_wakeup(itf);
> +	}
> +}
> +
> +static void itf_handle_scaler_done(struct fimc_is_interface *itf,
> +		struct fimc_is_msg *msg)
> +{
> +	struct fimc_is *is = fimc_interface_to_is(itf);
> +	struct fimc_is_pipeline *pipeline =&is->pipeline[msg->instance];
> +	struct fimc_is_buf *buf;
> +	struct fimc_is_scaler *scl;
> +	const struct fimc_is_fmt *fmt;
> +	struct timeval *tv;
> +	struct timespec ts;
> +	unsigned int wh, i;
> +	unsigned int fcount = msg->param[0];
> +	unsigned long *comp_state;
> +
> +	if (msg->param[3] == SCALER_SCC) {
> +		scl =&pipeline->scaler[SCALER_SCC];
> +		comp_state =&pipeline->comp_state[IS_SCC];
> +	} else {
> +		scl =&pipeline->scaler[SCALER_SCP];
> +		comp_state =&pipeline->comp_state[IS_SCP];
> +	}
> +
> +	fmt = scl->fmt;
> +
> +	fimc_is_pipeline_buf_lock(pipeline);
> +	if (!list_empty(&scl->run_queue)) {
> +
> +		wh = scl->width * scl->height;
> +		buf = fimc_is_scaler_run_queue_get(scl);
> +		for (i = 0; i<  fmt->num_planes; i++) {
> +			vb2_set_plane_payload(buf->vb, i,
> +					(wh * fmt->depth[i]) / 8);
> +		}

CodingStyle: Superfluous braces.

> +		/* Set timestamp */
> +		ktime_get_ts(&ts);
> +		tv =&buf->vb->v4l2_buf.timestamp;
> +		tv->tv_sec = ts.tv_sec;
> +		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> +		buf->vb->v4l2_buf.sequence = fcount;
> +
> +		pr_debug("SCP buffer done %d/%d\n",
> +				msg->param[0], msg->param[2]);
> +		vb2_buffer_done(buf->vb, VB2_BUF_STATE_DONE);
> +	}
> +	fimc_is_pipeline_buf_unlock(pipeline);
> +	clear_bit(COMP_RUN, comp_state);
> +	wake_up(&scl->event_q);
> +}
> +
> +static void itf_handle_shot_done(struct fimc_is_interface *itf,
> +		struct fimc_is_msg *msg)
> +{
> +	struct fimc_is *is = fimc_interface_to_is(itf);
> +	struct fimc_is_pipeline *pipeline =&is->pipeline[msg->instance];
> +	unsigned int status = msg->param[1];
> +	struct fimc_is_buf *bayer_buf;
> +	int ret;
> +
> +	if (status != ISR_DONE)
> +		pr_err("Shot done is invalid(0x%08X)\n", status);
> +
> +	/* DQ the bayer input buffer */
> +	fimc_is_pipeline_buf_lock(pipeline);
> +	bayer_buf = fimc_is_isp_run_queue_get(&pipeline->isp);
> +	if (bayer_buf) {
> +		vb2_buffer_done(bayer_buf->vb, VB2_BUF_STATE_DONE);
> +		pr_debug("Bayer buffer done.\n");
> +	}
> +	fimc_is_pipeline_buf_unlock(pipeline);
> +
> +	/* Clear state&  call shot again */
> +	clear_bit(PIPELINE_RUN,&pipeline->state);
> +
> +	ret = fimc_is_pipeline_shot(pipeline);
> +	if (ret)
> +		pr_err("Shot failed\n");
> +}
> +
> +/* Main FIMC-IS interrupt handler */
> +static irqreturn_t itf_irq_handler(int irq, void *data)
> +{
> +	struct fimc_is_interface *itf;
> +	struct fimc_is_msg msg;
> +	unsigned int status, intr;
> +	struct is_common_reg __iomem *com_regs;
> +
> +	itf = (struct fimc_is_interface *)data;

Unnecessary casting from void *. You could well make this assignment
at the declaration time above.

> +	com_regs = itf->com_regs;
> +	status = itf_get_intr(itf);
> +
> +	for (intr = INTR_GENERAL; intr<  INTR_MAX_MAP; intr++) {
> +
> +		if (status&  (1<<  intr)) {

nit: you could also use BIT() macro (from <linux/bitops.h>):

		if (status & BIT(intr))

> +			itf_get_cmd(itf,&msg, intr);
> +
> +			switch (intr) {
> +			case INTR_GENERAL:
> +				itf_handle_general(itf,&msg);
> +				com_regs->ihcmd_iflag = 0;
> +				break;
> +			case INTR_SHOT_DONE:
> +				itf_handle_shot_done(itf,&msg);
> +				com_regs->shot_iflag = 0;
> +				break;
> +			case INTR_SCC_FDONE:
> +				msg.param[3] = SCALER_SCC;
> +				itf_handle_scaler_done(itf,&msg);
> +				com_regs->scc_iflag = 0;
> +				break;
> +			case INTR_SCP_FDONE:
> +				msg.param[3] = SCALER_SCP;
> +				itf_handle_scaler_done(itf,&msg);
> +				com_regs->scp_iflag = 0;
> +				break;
> +			case INTR_META_DONE:
> +				com_regs->meta_iflag = 0;
> +				break;
> +			}
> +			status&= ~(1<<  intr);
> +			writel((1<<  intr), itf->regs + INTCR1);

Ditto, s/(1 << intr)/BIT(intr).

> +		}
> +	}
> +
> +	if (status != 0)
> +		pr_err("status is NOT all clear(0x%08X)", status);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +int fimc_is_itf_open_sensor(struct fimc_is_interface *itf,
> +		unsigned int instance,
> +		unsigned int sensor_id,
> +		unsigned int i2c_channel,
> +		unsigned int sensor_ext)
> +{
> +	struct fimc_is_msg msg = {0,};

nit: a colon is not really needed here and in other functions below.

> +	msg.command = HIC_OPEN_SENSOR;
> +	msg.instance = instance;
> +	msg.param[0] = sensor_id;
> +	msg.param[1] = i2c_channel;
> +	msg.param[2] = sensor_ext;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_get_setfile_addr(struct fimc_is_interface *itf,
> +		unsigned int instance, unsigned int *setfile_addr)
> +{
> +	int ret;

> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_GET_SET_FILE_ADDR;
> +	msg.instance = instance;

This could also written as:

	struct fimc_is_msg msg = {
		.command = HIC_GET_SET_FILE_ADDR,
		.instance = instance,
	};

> +	ret = fimc_is_itf_set_cmd(itf,&msg);
> +	*setfile_addr = itf->reply.param[1];
> +
> +	return ret;
> +}
> +
> +int fimc_is_itf_load_setfile(struct fimc_is_interface *itf,
> +		unsigned int instance)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_LOAD_SET_FILE;
> +	msg.instance = instance;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_stream_on(struct fimc_is_interface *itf,
> +		unsigned int instance)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_STREAM_ON;
> +	msg.instance = instance;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_stream_off(struct fimc_is_interface *itf,
> +		unsigned int instance)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_STREAM_OFF;
> +	msg.instance = instance;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_process_on(struct fimc_is_interface *itf,
> +		unsigned int instance)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_PROCESS_START;
> +	msg.instance = instance;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_process_off(struct fimc_is_interface *itf,
> +		unsigned int instance)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_PROCESS_STOP;
> +	msg.instance = instance;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_set_param(struct fimc_is_interface *itf,
> +		unsigned int instance,
> +		unsigned int indexes,
> +		unsigned int lindex,
> +		unsigned int hindex)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_SET_PARAMETER;
> +	msg.instance = instance;
> +	msg.param[0] = ISS_PREVIEW_STILL;
> +	msg.param[1] = indexes;
> +	msg.param[2] = lindex;
> +	msg.param[3] = hindex;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_preview_still(struct fimc_is_interface *itf,
> +		unsigned int instance)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_PREVIEW_STILL;
> +	msg.instance = instance;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_get_capability(struct fimc_is_interface *itf,
> +	unsigned int instance, unsigned int address)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_GET_STATIC_METADATA;
> +	msg.instance = instance;
> +	msg.param[0] = address;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_cfg_mem(struct fimc_is_interface *itf,
> +		unsigned int instance, unsigned int address,
> +		unsigned int size)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_SET_A5_MEM_ACCESS;
> +	msg.instance = instance;
> +	msg.param[0] = address;
> +	msg.param[1] = size;
> +
> +	return fimc_is_itf_set_cmd(itf,&msg);
> +}
> +
> +int fimc_is_itf_shot_nblk(struct fimc_is_interface *itf,
> +		unsigned int instance, unsigned int bayer,
> +		unsigned int shot, unsigned int fcount, unsigned int rcount)
> +{
> +	struct fimc_is_msg msg = {0,};
> +
> +	msg.command = HIC_SHOT;
> +	msg.instance = instance;
> +	msg.param[0] = bayer;
> +	msg.param[1] = shot;
> +	msg.param[2] = fcount;
> +	msg.param[3] = rcount;

nit: And this:

	struct fimc_is_msg msg = {
		.command = HIC_SHOT,
		.instance = instance,
		.param = { bayer, shot, fcount, rcount },
	};

It's more compact this way and still has a good readability IMHO.

> +	return fimc_is_itf_set_cmd_shot(itf,&msg);
> +}
> +
> +int fimc_is_itf_power_down(struct fimc_is_interface *itf,
> +		unsigned int instance)
> +{
> +	struct fimc_is_msg msg = {0,};
> +	int ret;
> +
> +	msg.command = HIC_POWER_DOWN;
> +	msg.instance = instance;
> +
> +	ret = fimc_is_itf_set_cmd(itf,&msg);
> +	itf_clr_state(itf, IS_IF_STATE_INIT);
> +
> +	return ret;
> +}
> +
> +/* Debugfs for showing FW debug messages */
> +static int fimc_is_log_show(struct seq_file *s, void *data)
> +{
> +	struct fimc_is_interface *itf = s->private;
> +	struct fimc_is *is = fimc_interface_to_is(itf);
> +
> +	const u8 *buf = (u8 *) (is->minfo.fw_vaddr + DEBUG_OFFSET);
> +
> +	if (is->minfo.fw_vaddr == 0) {
> +		pr_err("Firmware memory is not initialized\n");

dev_err() !

> +		return -EIO;
> +	}
> +
> +	seq_printf(s, "%s\n", buf);
> +	return 0;
> +}
> +
> +static int fimc_is_debugfs_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, fimc_is_log_show, inode->i_private);
> +}
> +
> +static const struct file_operations fimc_is_debugfs_fops = {
> +	.open		= fimc_is_debugfs_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static void fimc_is_debugfs_remove(struct fimc_is_interface *itf)
> +{
> +	debugfs_remove(itf->debugfs_entry);
> +	itf->debugfs_entry = NULL;
> +}
> +
> +static int fimc_is_debugfs_create(struct fimc_is_interface *itf)
> +{
> +	struct dentry *dentry;
> +
> +	itf->debugfs_entry = debugfs_create_dir("fimc_is", NULL);
> +
> +	dentry = debugfs_create_file("fw_log", S_IRUGO, itf->debugfs_entry,
> +					itf,&fimc_is_debugfs_fops);
> +	if (!dentry)
> +		fimc_is_debugfs_remove(itf);
> +
> +	return itf->debugfs_entry == NULL ? -EIO : 0;
> +}
> +
> +int fimc_is_interface_init(struct fimc_is_interface *itf,
> +		void __iomem *regs, int irq)
> +{
> +	struct fimc_is *is = fimc_interface_to_is(itf);
> +	struct device *dev =&is->pdev->dev;
> +	int ret;
> +
> +	if (!regs || !irq) {
> +		pr_err("Invalid args\n");

dev_err()

> +		return -EINVAL;
> +	}
> +
> +	itf->regs = regs;
> +	itf->com_regs = (struct is_common_reg *)(regs + ISSR(0));
> +
> +	init_waitqueue_head(&itf->irq_queue);
> +	spin_lock_init(&itf->slock_state);
> +	spin_lock_init(&itf->slock);
> +
> +	/* Register interrupt handler */
> +	ret = devm_request_irq(dev, irq, itf_irq_handler,
> +			       0, dev_name(dev), itf);
> +	if (ret) {
> +		dev_err(dev, "Failed to install irq (%d)\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	/* Initialize context vars */
> +	itf->streaming = IS_IF_STREAMING_INIT;
> +	itf->processing = IS_IF_PROCESSING_INIT;
> +	itf->pdown_ready = IS_IF_POWER_DOWN_READY;
> +	itf->debug_cnt = 0;
> +	init_request_barrier(itf);
> +
> +	/* Debugfs for FW debug log */
> +	fimc_is_debugfs_create(itf);
> +
> +	return 0;
> +}
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-interface.h b/drivers/media/platform/exynos5-is/fimc-is-interface.h
> new file mode 100644
> index 0000000..faf86d8
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-interface.h
> @@ -0,0 +1,128 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *  Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef FIMC_IS_INTERFACE_H_
> +#define FIMC_IS_INTERFACE_H_
> +
> +#include "fimc-is-core.h"
> +
> +#define TRY_RECV_AWARE_COUNT    100
> +
> +#define ISDRV_VERSION		111
> +
> +#define LOWBIT_OF(num)  (num>= 32 ? 0 : (unsigned int)1<<num)
> +#define HIGHBIT_OF(num) (num>= 32 ? (unsigned int)1<<(num-32) : 0)

These macros should not be needed. Please see my comments to patch 09/13.

> +enum interrupt_map {
> +	INTR_GENERAL            = 0,
> +	INTR_ISP_FDONE          = 1,
> +	INTR_SCC_FDONE          = 2,
> +	INTR_DNR_FDONE          = 3,
> +	INTR_SCP_FDONE          = 4,
> +	INTR_ISP_YUV_DONE	= 5,
> +	INTR_META_DONE          = 6,
> +	INTR_SHOT_DONE          = 7,
> +	INTR_MAX_MAP
> +};
> +
> +enum fimc_is_interface_state {
> +	IS_IF_STATE_INIT,
> +	IS_IF_STATE_OPEN,
> +	IS_IF_STATE_START,
> +	IS_IF_STATE_BUSY
> +};
> +
> +enum streaming_state {
> +	IS_IF_STREAMING_INIT,
> +	IS_IF_STREAMING_OFF,
> +	IS_IF_STREAMING_ON
> +};
> +
> +enum processing_state {
> +	IS_IF_PROCESSING_INIT,
> +	IS_IF_PROCESSING_OFF,
> +	IS_IF_PROCESSING_ON
> +};
> +
> +enum pdown_ready_state {
> +	IS_IF_POWER_DOWN_READY,
> +	IS_IF_POWER_DOWN_NREADY
> +};
> +
> +struct fimc_is_msg {
> +	unsigned int	id;
> +	unsigned int	command;
> +	unsigned int	instance;
> +	unsigned int	param[4];

Shouldn't all these fields be of u32 type instead ?

> +};
> +
> +struct fimc_is_interface {
> +

Superfluous empty line.

> +	unsigned long			state;
> +
> +	void __iomem			*regs;
> +	struct is_common_reg __iomem    *com_regs;
> +	spinlock_t			slock;
> +	spinlock_t			slock_state;

Locking needs to be documented. A short comment on how these
spinlocks are used would do.

> +	wait_queue_head_t		irq_queue;
> +
> +	spinlock_t			process_barrier;
> +	struct mutex			request_barrier;

Ditto.

> +	enum streaming_state		streaming;
> +	enum processing_state		processing;
> +	enum pdown_ready_state		pdown_ready;
> +
> +	struct fimc_is_msg		reply;
> +
> +	int				debug_cnt;
> +	struct dentry                   *debugfs_entry;
> +
> +};

--
Thanks,
Sylwester
