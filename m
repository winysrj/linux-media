Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53440 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3FRJ4v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 05:56:51 -0400
Message-ID: <1371549397.4275.3.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 8/8] [media] coda: add CODA7541 decoding support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?ISO-8859-1?Q?Ga=EBtan?= Carlier <gcembed@gmail.com>
Date: Tue, 18 Jun 2013 11:56:37 +0200
In-Reply-To: <1371481159-27412-9-git-send-email-p.zabel@pengutronix.de>
References: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
	 <1371481159-27412-9-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 17.06.2013, 16:59 +0200 schrieb Philipp Zabel:
> This patch enables decoding of h.264 and mpeg4 streams on CODA7541.
> Queued output buffers are immediately copied into the bitstream
> ringbuffer. A device_run can be scheduled whenever there is either
> enough compressed bitstream data, or the CODA is in stream end mode.
> 
> Each successful device_run, data is read from the bitstream ringbuffer
> and a frame is decoded into a free internal framebuffer. Depending on
> reordering, a possibly previously decoded frame is marked as display
> frame, and at the same time the display frame from the previous run
> is copied out into a capture buffer by the rotator hardware.
> 
> The dequeued capture buffers are counted to send the EOS signal to
> userspace with the last frame. When userspace sends the decoder stop
> command or enqueues an empty output buffer, the stream end flag is
> set to allow decoding the remaining frames in the bitstream
> ringbuffer.
> 
> The enum_fmt/try_fmt functions return fixed capture buffer sizes
> while the output queue is streaming, to allow better autonegotiation
> in userspace.
> 
> A per-context buffer mutex is used to lock the picture run against
> buffer dequeueing: if a job gets queued, then streamoff dequeues
> the last buffer, and then device_run is called, bail out. For that
> the interrupt handler has to be threaded.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 785 ++++++++++++++++++++++++++++++++++++++----
>  drivers/media/platform/coda.h |  84 +++++
>  2 files changed, 811 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index e8b3708..16f1726 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
[...]
> @@ -938,6 +1185,8 @@ static void coda_device_run(void *m2m_priv)
>  	/* 1 second timeout in case CODA locks up */
>  	schedule_delayed_work(&dev->timeout, HZ);
>  
> +	if (ctx->inst_type == CODA_INST_DECODER)
> +		coda_kfifo_sync_to_device_full(ctx);
>  	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
>  }
>  
> @@ -963,6 +1212,15 @@ static int coda_job_ready(void *m2m_priv)
>  		return 0;
>  	}
>  
> +	if (ctx->prescan_failed ||
> +	    ((coda_get_bitstream_payload(ctx) < 512) &&
> +	     !(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "%d: not ready: not enough bitstream data.\n",

This of course is only valid for decoder contexts:

--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1618,7 +1618,8 @@ static int coda_job_ready(void *m2m_priv)
        }
 
        if (ctx->prescan_failed ||
-           ((coda_get_bitstream_payload(ctx) < 512) &&
+           ((ctx->inst_type == CODA_INST_DECODER) &&
+            (coda_get_bitstream_payload(ctx) < 512) &&
             !(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
                v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
                         "%d: not ready: not enough bitstream data.\n",

> +			 ctx->idx);
> +		return 0;
> +	}
> +
>  	if (ctx->aborting) {
>  		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>  			 "not ready: aborting\n");
[...]

regards
Philipp

