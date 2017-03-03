Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35499 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbdCCB5A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 20:57:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/3] v4l: vsp1: Register pipe with output WPF
Date: Fri, 03 Mar 2017 03:57:32 +0200
Message-ID: <6507442.4PsfNadeTq@avalon>
In-Reply-To: <c49f9bbdc3061afda54dfeab3b0d05c309a2e0c4.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com> <c49f9bbdc3061afda54dfeab3b0d05c309a2e0c4.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Wednesday 01 Mar 2017 13:12:54 Kieran Bingham wrote:
> The DRM object does not register the pipe with the WPF object. This is
> used internally throughout the driver as a means of accessing the pipe.
> As such this breaks operations which require access to the pipe from WPF
> interrupts.
> 
> Register the pipe inside the WPF object after it has been declared as
> the output.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> b/drivers/media/platform/vsp1/vsp1_drm.c index cd209dccff1b..8e2aa3f8e52f
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -596,6 +596,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>  	pipe->bru = &vsp1->bru->entity;
>  	pipe->lif = &vsp1->lif->entity;
>  	pipe->output = vsp1->wpf[0];
> +	pipe->output->pipe = pipe;

The vsp1_irq_handler() function calls vsp1_pipeline_frame_end() with wpf-
>pipe, which is currently NULL. With this patch the function will get a non-
NULL pipeline and will thus proceed to calling vsp1_dlm_irq_frame_end():

void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
{
	if (pipe == NULL)
		return;

	vsp1_dlm_irq_frame_end(pipe->output->dlm);

	if (pipe->frame_end)
		pipe->frame_end(pipe);

	pipe->sequence++;
}

pipe->frame_end is NULL, pipe->sequence doesn't matter, but we now end up 
calling vsp1_dlm_irq_frame_end(). This is a major change regarding display 
list processing, yet it seems to have no effect at all.

The following commit is to blame for skipping the call to 
vsp1_dlm_irq_frame_end().

commit ff7e97c94d9f7f370fe3ce2a72e85361ca22a605
Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Date:   Tue Jan 19 19:16:36 2016 -0200

    [media] v4l: vsp1: Store pipeline pointer in rwpf

I've added a few debug print statements to vsp1_dlm_irq_frame_end(), and it 
looks like we only hit the if (dlm->queued) test or none of them at all. It 
looks like we've been lucky that nothing broke.

Restoring the previous behaviour should be safe, but it would be worth it 
inspecting the code very carefully to make sure the logic is still correct. 
I'll do it tomorrow if you don't beat me to it.

In any case, how about adding a

Fixes: ff7e97c94d9f ("[media] v4l: vsp1: Store pipeline pointer in rwpf")

line ?

>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart
