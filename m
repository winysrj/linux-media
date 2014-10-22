Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:37372 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaJVKPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:15:52 -0400
Message-ID: <544783D4.8010502@cisco.com>
Date: Wed, 22 Oct 2014 12:15:48 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 5/5] [media] vivid: enable VIDIOC_EXPBUF
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de> <1413972221-13669-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1413972221-13669-6-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/22/2014 12:03 PM, Philipp Zabel wrote:
> Instances created with allocators == 1 use videobuf2-dma-contig, and are
> able to export DMA buffers via VIDIOC_EXPBUF.

Can you test what happens if you use EXPBUF when vmalloc is used? I hope it
will just fail, but I am not sure.

Regards,

	Hans

>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/media/platform/vivid/vivid-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 4c4fc3d..695286b 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -596,7 +596,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
>   	.vidioc_querybuf		= vb2_ioctl_querybuf,
>   	.vidioc_qbuf			= vb2_ioctl_qbuf,
>   	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> -/* Not yet	.vidioc_expbuf		= vb2_ioctl_expbuf,*/
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
>   	.vidioc_streamon		= vb2_ioctl_streamon,
>   	.vidioc_streamoff		= vb2_ioctl_streamoff,
>
>

