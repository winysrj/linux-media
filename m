Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18762 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaCKL3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 07:29:23 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, posciak@chromium.org,
	arunkk.samsung@gmail.com
References: <1394180752-16348-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1394180752-16348-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH] [media] s5p-mfc: Don't try to resubmit VP8 bitstream
 buffer for decode.
Date: Tue, 11 Mar 2014 12:29:20 +0100
Message-id: <1d2001cf3d1d$25bd90c0$7138b240$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com] On Behalf Of Arun
> Kumar K
> Sent: Friday, March 07, 2014 9:26 AM
> 
> From: Pawel Osciak <posciak@chromium.org>
> 
> Currently, for formats that are not H264, MFC driver will check the
> consumed stream size returned by the firmware and, based on that, will
> try to decide whether the bitstream buffer contained more than one
> frame. If the size of the buffer is larger than the consumed stream, it
> assumes that there are more frames in the buffer and that the buffer
> should be resubmitted for decode. This rarely works though and actually
> introduces problems, because:
> 
> - v7 firmware will always return consumed stream size equal to whatever
> the driver passed to it when running decode (which is the size of the
> whole buffer), which means we will never try to resubmit, because the
> firmware will always tell us that it consumed all the data we passed to
> it;

This does sound like a hardware bug/feature. So in v7 the buffer is never
resubmitted, yes? And this patch makes no difference for v7?

> 
> - v6 firmware will return the number of consumed bytes, but will not
> include the padding ("stuffing") bytes that are allowed after the frame
> in VP8. Since there is no way of figuring out how many of those bytes
> follow the frame without getting the frame size from IVF headers (or
> somewhere else, but not from the stream itself), the driver tries to
> guess that padding size is not larger than 4 bytes, which is not always
> true;

How about v5 of MFC? I need to do some additional testing, as I don't want
to introduce any regressions. I remember that this check was a result of a
fair amount of work and testing with v5.
 
> The only way to make it work is to queue only one frame per buffer from
> userspace and the check in the kernel is useless and wrong for VP8.
> MPEG4 still seems to require it, so keep it only for that format.

Is your goal to give more than one frame in a single buffer and have the 
buffer resubmitted? Or the opposite - you are getting the frame resubmitted
without the need? By the contents of this patch I guess the latter, on the
other hand I do remember that at some point the idea was to be able to queue
more than one frame per buffer. I don't remember exactly who was opting for
the ability to queue more frames in a single buffer...

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index e2aac59..66c1775 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -360,7 +360,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx
> *ctx,
>  								list);
>  		ctx->consumed_stream += s5p_mfc_hw_call(dev->mfc_ops,
>  						get_consumed_stream, dev);
> -		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
> +		if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_DEC &&
>  			ctx->consumed_stream + STUFF_BYTE <
>  			src_buf->b->v4l2_planes[0].bytesused) {
>  			/* Run MFC again on the same buffer */
> --
> 1.7.9.5

