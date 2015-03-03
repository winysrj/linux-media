Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8530 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbbCCPwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 10:52:07 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKN00GK489M2S30@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Mar 2015 15:56:10 +0000 (GMT)
Message-id: <54F5D897.9020103@samsung.com>
Date: Tue, 03 Mar 2015 16:51:51 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] s5p-jpeg: Fix possible NULL pointer dereference in s_fmt
References: <1417180218-4421-1-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1417180218-4421-1-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 28/11/14 14:10, Jacek Anaszewski wrote:
> Some formats are not supported in encoding or decoding
> mode for given type of buffer (e.g. V4L2_PIX_FMT_JPEG
> is supported on output buffer only while in decoding
> mode). Make S_FMT failing if not suitable format
> is found.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index d7571cd..dfab848 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1345,6 +1345,14 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
>  			FMT_TYPE_OUTPUT : FMT_TYPE_CAPTURE;
>  
>  	q_data->fmt = s5p_jpeg_find_format(ct, pix->pixelformat, f_type);
> +
> +	if (!q_data->fmt) {
> +		v4l2_err(&ct->jpeg->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +

How about forcing one of valid formats instead ? VIDIOC_S_FMT is not
supposed to return an error just because a not supported fourcc
was passed from user space.

--
Thanks,
Sylwester
