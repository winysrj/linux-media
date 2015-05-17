Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57925 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbEQTnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 15:43:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex Dowad <alexinbeijing@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clarify expression which uses both multiplication and pointer dereference
Date: Sun, 17 May 2015 22:43:48 +0300
Message-ID: <1845070.nZfaVzKiG7@avalon>
In-Reply-To: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
References: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thank you for the patch.

On Sunday 17 May 2015 19:18:42 Alex Dowad wrote:
> This fixes a checkpatch style error in vpfe_buffer_queue_setup.
> 
> Signed-off-by: Alex Dowad <alexinbeijing@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index 06d48d5..04a687c
> 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1095,7 +1095,7 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq, const
> struct v4l2_format *fmt, size = video->fmt.fmt.pix.sizeimage;
> 
>  	if (vpfe_dev->video_limit) {
> -		while (size * *nbuffers > vpfe_dev->video_limit)
> +		while (size * (*nbuffers) > vpfe_dev->video_limit)
>  			(*nbuffers)--;
>  	}
>  	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS) {

-- 
Regards,

Laurent Pinchart

