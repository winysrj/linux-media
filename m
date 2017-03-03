Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36371 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdCCJMV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 04:12:21 -0500
Received: by mail-wm0-f65.google.com with SMTP id v190so2077757wme.3
        for <linux-media@vger.kernel.org>; Fri, 03 Mar 2017 01:12:20 -0800 (PST)
Subject: Re: [RFC PATCH 1/3] v4l: vsp1: Register pipe with output WPF
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
 <c49f9bbdc3061afda54dfeab3b0d05c309a2e0c4.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6507442.4PsfNadeTq@avalon>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <01298cec-ea75-d9ab-235b-8625334576f5@bingham.xyz>
Date: Fri, 3 Mar 2017 08:40:54 +0000
MIME-Version: 1.0
In-Reply-To: <6507442.4PsfNadeTq@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review,

On 03/03/17 01:57, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Wednesday 01 Mar 2017 13:12:54 Kieran Bingham wrote:
>> The DRM object does not register the pipe with the WPF object. This is
>> used internally throughout the driver as a means of accessing the pipe.
>> As such this breaks operations which require access to the pipe from WPF
>> interrupts.
>>
>> Register the pipe inside the WPF object after it has been declared as
>> the output.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/platform/vsp1/vsp1_drm.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
>> b/drivers/media/platform/vsp1/vsp1_drm.c index cd209dccff1b..8e2aa3f8e52f
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
>> @@ -596,6 +596,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>>  	pipe->bru = &vsp1->bru->entity;
>>  	pipe->lif = &vsp1->lif->entity;
>>  	pipe->output = vsp1->wpf[0];
>> +	pipe->output->pipe = pipe;
> 
> The vsp1_irq_handler() function calls vsp1_pipeline_frame_end() with wpf-
>> pipe, which is currently NULL. With this patch the function will get a non-
> NULL pipeline and will thus proceed to calling vsp1_dlm_irq_frame_end():
> 
> void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
> {
> 	if (pipe == NULL)
> 		return;
> 
> 	vsp1_dlm_irq_frame_end(pipe->output->dlm);
> 
> 	if (pipe->frame_end)
> 		pipe->frame_end(pipe);
> 
> 	pipe->sequence++;
> }
> 
> pipe->frame_end is NULL, pipe->sequence doesn't matter, but we now end up 
> calling vsp1_dlm_irq_frame_end(). This is a major change regarding display 
> list processing, yet it seems to have no effect at all.

I was a bit surprised at this bit. I had expected vsp1_dlm_irq_frame_end() to be
more critical, but ultimately - it's only job is to handle a race condition on
DL commits which we (presumably) don't hit. At least we don't hit in our testing
more than $(DL_QTY) times, or I believe the display would have hung.

In fact we would have panic'd on a NULL dereference with pipe->dl:
	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);

where I don't see any checks on pipe->dl != NULL in the current code paths.

> The following commit is to blame for skipping the call to 
> vsp1_dlm_irq_frame_end().
> 
> commit ff7e97c94d9f7f370fe3ce2a72e85361ca22a605
> Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Date:   Tue Jan 19 19:16:36 2016 -0200
> 
>     [media] v4l: vsp1: Store pipeline pointer in rwpf
> 
> I've added a few debug print statements to vsp1_dlm_irq_frame_end(), and it 
> looks like we only hit the if (dlm->queued) test or none of them at all. It 
> looks like we've been lucky that nothing broke.
> 
> Restoring the previous behaviour should be safe, but it would be worth it 
> inspecting the code very carefully to make sure the logic is still correct. 
> I'll do it tomorrow if you don't beat me to it.

As far as I can tell it still seems correct. If we had ever hit this race, I
believe we would have leaked the DL, (which is quite a limited resource to us),
which if anything just raises the importance of this fix.

> 
> In any case, how about adding a
> 
> Fixes: ff7e97c94d9f ("[media] v4l: vsp1: Store pipeline pointer in rwpf")

Absolutely.

This seems worthy of a stable backport...? (though not critical)

The breakage was introduced in 4.6...

Should I add a CC: stable@kernel.org #4.6+

> line ?
> 
>>  	return 0;
>>  }
> 

-- 
Regards

Kieran Bingham
