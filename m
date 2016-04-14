Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57024 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbcDNQhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 12:37:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] [media] vsp1: make vsp1_drm_frame_end static
Date: Thu, 14 Apr 2016 19:37:10 +0300
Message-ID: <1587312.XcHqdzI2sK@avalon>
In-Reply-To: <5fb2107346cfc6d8fe62117a2cbf91fc1f92cc84.1460580142.git.mchehab@osg.samsung.com>
References: <5fb2107346cfc6d8fe62117a2cbf91fc1f92cc84.1460580142.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 13 Apr 2016 17:42:24 Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/platform/vsp1/vsp1_drm.c:39:6: warning: no previous prototype
> for 'vsp1_drm_frame_end' [-Wmissing-prototypes] void
> vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
> 
> Fixes: ef9621bcd664 ("[media] v4l: vsp1: Store the display list manager in
> the WPF") Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Given that patch "[media] v4l: vsp1: Use display lists with the userspace API" 
from the same series removes the function, that's most likely overkill, but it 
won't hurt. I would have squashed it into the original commit though, as all 
this brings is a smatch warning fix that could only be noticed during 
bisection without any runtime impact, so a separate patch doesn't help much.

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> b/drivers/media/platform/vsp1/vsp1_drm.c index 22f67360b750..1f08da4b933b
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -36,7 +36,7 @@ void vsp1_drm_display_start(struct vsp1_device *vsp1)
>  	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
>  }
> 
> -void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
> +static void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
>  {
>  	vsp1_dlm_irq_frame_end(pipe->output->dlm);
>  }

-- 
Regards,

Laurent Pinchart

