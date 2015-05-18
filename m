Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbbERGwC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 02:52:02 -0400
Date: Mon, 18 May 2015 08:51:58 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Alex Dowad <alexinbeijing@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clarify expression which uses both multiplication and
 pointer dereference
Message-ID: <20150518065158.GA17391@unicorn.suse.cz>
References: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 17, 2015 at 07:18:42PM +0200, Alex Dowad wrote:
> This fixes a checkpatch style error in vpfe_buffer_queue_setup.
> 
> Signed-off-by: Alex Dowad <alexinbeijing@gmail.com>
> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 06d48d5..04a687c 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1095,7 +1095,7 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
>  	size = video->fmt.fmt.pix.sizeimage;
>  
>  	if (vpfe_dev->video_limit) {
> -		while (size * *nbuffers > vpfe_dev->video_limit)
> +		while (size * (*nbuffers) > vpfe_dev->video_limit)
>  			(*nbuffers)--;
>  	}
>  	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS) {

Style issue aside, is there a reason not to use

		if (size * *nbuffers > vpfe_dev->video_limit)
			*nbuffers = vpfe_dev->video_limit / size;

instead?

                                                          Michal Kubecek

