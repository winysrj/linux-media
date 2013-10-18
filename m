Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58085 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3JRJLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 05:11:42 -0400
Message-id: <5260FB48.5030306@samsung.com>
Date: Fri, 18 Oct 2013 11:11:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	'Arun Kumar K' <arun.kk@samsung.com>
Cc: posciak@google.com, inki.dae@samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v4 3/4] [media] exynos-scaler: Add m2m functionality for
 the SCALER driver
References: <1380889594-10448-1-git-send-email-shaik.ameer@samsung.com>
 <1380889594-10448-4-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1380889594-10448-4-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/13 14:26, Shaik Ameer Basha wrote:
> This patch adds the Makefile and memory to memory (m2m) interface
> functionality for the SCALER driver.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


> +static void scaler_m2m_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct scaler_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	scaler_dbg(ctx->scaler_dev, "ctx: %p, ctx->state: 0x%x",
> +				     ctx, ctx->state);
> +
> +	if (ctx->m2m_ctx)

You can remove this line.

> +		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> +}


Thanks,
Sylwester
