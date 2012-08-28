Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56376 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2H1V7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 17:59:41 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9H00685JS3AQ00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 Aug 2012 23:00:03 +0100 (BST)
Received: from AMDN157 ([106.210.236.152])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M9H00KCBJRCUB30@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 Aug 2012 22:59:39 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1346068683-31610-1-git-send-email-arun.kk@samsung.com>
 <1346068683-31610-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1346068683-31610-2-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v5 1/4] [media] s5p-mfc: Update MFCv5 driver for callback
 based architecture
Date: Tue, 28 Aug 2012 14:59:36 -0700
Message-id: <001a01cd8568$6b78bc20$426a3460$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Please find my comments inline.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 27 August 2012 04:58

[...]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
b/drivers/media/video/s5p-
> mfc/s5p_mfc.c
> index 9bb68e7..ab66680 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -21,15 +21,15 @@

[...]

> @@ -552,22 +546,23 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>  	atomic_set(&dev->watchdog_cnt, 0);
>  	ctx = dev->ctx[dev->curr_ctx];
>  	/* Get the reason of interrupt and the error code */
> -	reason = s5p_mfc_get_int_reason();
> -	err = s5p_mfc_get_int_err();
> +	reason = s5p_mfc_get_int_reason(dev);
> +	err = s5p_mfc_get_int_err(dev);
>  	mfc_debug(1, "Int reason: %d (err: %08x)\n", reason, err);
>  	switch (reason) {
> -	case S5P_FIMV_R2H_CMD_ERR_RET:
> +	case S5P_MFC_R2H_CMD_ERR_RET:
>  		/* An error has occured */
>  		if (ctx->state == MFCINST_RUNNING &&
> -			s5p_mfc_err_dec(err) >= S5P_FIMV_ERR_WARNINGS_START)
> +			s5p_mfc_err_dec(err) >= s5p_mfc_get_warn_start(dev))

It's still a function call. I have meant that it could an argument of the
dev structure that is set in probe. It's much better to use a value directly
than call a function.

>  			s5p_mfc_handle_frame(ctx, reason, err);
>  		else
>  			s5p_mfc_handle_error(ctx, reason, err);
>  		clear_bit(0, &dev->enter_suspend);
>  		break;
> 
> -	case S5P_FIMV_R2H_CMD_SLICE_DONE_RET:
> -	case S5P_FIMV_R2H_CMD_FRAME_DONE_RET:
> +	case S5P_MFC_R2H_CMD_SLICE_DONE_RET:
> +	case S5P_MFC_R2H_CMD_FIELD_DONE_RET:
> +	case S5P_MFC_R2H_CMD_FRAME_DONE_RET:
>  		if (ctx->c_ops->post_frame_start) {
>  			if (ctx->c_ops->post_frame_start(ctx))
>  				mfc_err("post_frame_start() failed\n");

[...]

> +/* This function is used to send a command to the MFC */
> +int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
> +				struct s5p_mfc_cmd_args *args)
> +{
> +	return s5p_mfc_hw_call(s5p_mfc_cmds, cmd_host2risc, dev, cmd, args);
>  }
> 	

Arun, also I think that we misunderstood each other. I suggested that
for example s5p_mfc_cmd_host2risc could be changed to
s5p_mfc_hw_call(s5p_mfc_cmds, cmd_host2risc, dev, cmd, args);

It would be much better to use s5p_mfc_hw_call directly in the code.
The idea was to completely remove function such as the above, the ones
that have nothing more than a call to the ops.

[...]

