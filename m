Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51366 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbeEQULY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 16:11:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v7 8/8] media: vsp1: Move video configuration to a cached dlb
Date: Thu, 17 May 2018 23:11:45 +0300
Message-ID: <25447546.Mi0DG4ekuh@avalon>
In-Reply-To: <00b80250-27dc-4cde-fbce-9fd6e1646864@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com> <2574394.aYb3RYBsUT@avalon> <00b80250-27dc-4cde-fbce-9fd6e1646864@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thursday, 17 May 2018 20:06:46 EEST Kieran Bingham wrote:
> On 17/05/18 15:35, Laurent Pinchart wrote:
> > On Monday, 30 April 2018 20:48:03 EEST Kieran Bingham wrote:
> >> On 07/04/18 01:23, Laurent Pinchart wrote:
> >>> On Thursday, 8 March 2018 02:05:31 EEST Kieran Bingham wrote:
> >>>> We are now able to configure a pipeline directly into a local display
> >>>> list body. Take advantage of this fact, and create a cacheable body to
> >>>> store the configuration of the pipeline in the video object.
> >>>> 
> >>>> vsp1_video_pipeline_run() is now the last user of the pipe->dl object.
> >>>> Convert this function to use the cached video->config body and obtain a
> >>>> local display list reference.
> >>>> 
> >>>> Attach the video->config body to the display list when needed before
> >>>> committing to hardware.
> >>>> 
> >>>> The pipe object is marked as un-configured when resuming from a
> >>>> suspend. This ensures that when the hardware is reset - our cached
> >>>> configuration will be re-attached to the next committed DL.
> >>>> 
> >>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >>>> ---
> >>>> 
> >>>> v3:
> >>>>  - 's/fragment/body/', 's/fragments/bodies/'
> >>>>  - video dlb cache allocation increased from 2 to 3 dlbs
> >>>> 
> >>>> Our video DL usage now looks like the below output:
> >>>> 
> >>>> dl->body0 contains our disposable runtime configuration. Max 41.
> >>>> dl_child->body0 is our partition specific configuration. Max 12.
> >>>> dl->bodies shows our constant configuration and LUTs.
> >>>> 
> >>>>   These two are LUT/CLU:
> >>>>      * dl->bodies[x]->num_entries 256 / max 256
> >>>>      * dl->bodies[x]->num_entries 4914 / max 4914
> >>>> 
> >>>> Which shows that our 'constant' configuration cache is currently
> >>>> utilised to a maximum of 64 entries.
> >>>> 
> >>>> trace-cmd report | \
> >>>> 
> >>>>     grep max | sed 's/.*vsp1_dl_list_commit://g' | sort | uniq;
> >>>>   
> >>>>   dl->body0->num_entries 13 / max 128
> >>>>   dl->body0->num_entries 14 / max 128
> >>>>   dl->body0->num_entries 16 / max 128
> >>>>   dl->body0->num_entries 20 / max 128
> >>>>   dl->body0->num_entries 27 / max 128
> >>>>   dl->body0->num_entries 34 / max 128
> >>>>   dl->body0->num_entries 41 / max 128
> >>>>   dl_child->body0->num_entries 10 / max 128
> >>>>   dl_child->body0->num_entries 12 / max 128
> >>>>   dl->bodies[x]->num_entries 15 / max 128
> >>>>   dl->bodies[x]->num_entries 16 / max 128
> >>>>   dl->bodies[x]->num_entries 17 / max 128
> >>>>   dl->bodies[x]->num_entries 18 / max 128
> >>>>   dl->bodies[x]->num_entries 20 / max 128
> >>>>   dl->bodies[x]->num_entries 21 / max 128
> >>>>   dl->bodies[x]->num_entries 256 / max 256
> >>>>   dl->bodies[x]->num_entries 31 / max 128
> >>>>   dl->bodies[x]->num_entries 32 / max 128
> >>>>   dl->bodies[x]->num_entries 39 / max 128
> >>>>   dl->bodies[x]->num_entries 40 / max 128
> >>>>   dl->bodies[x]->num_entries 47 / max 128
> >>>>   dl->bodies[x]->num_entries 48 / max 128
> >>>>   dl->bodies[x]->num_entries 4914 / max 4914
> >>>>   dl->bodies[x]->num_entries 55 / max 128
> >>>>   dl->bodies[x]->num_entries 56 / max 128
> >>>>   dl->bodies[x]->num_entries 63 / max 128
> >>>>   dl->bodies[x]->num_entries 64 / max 128
> >>> 
> >>> This might be useful to capture in the main part of the commit message.
> >>> 
> >>>> v4:
> >>>>  - Adjust pipe configured flag to be reset on resume rather than
> >>>>  suspend
> >>>>  - rename dl_child, dl_next
> >>>>  
> >>>>  drivers/media/platform/vsp1/vsp1_pipe.c  |  7 +++-
> >>>>  drivers/media/platform/vsp1/vsp1_pipe.h  |  4 +-
> >>>>  drivers/media/platform/vsp1/vsp1_video.c | 67 ++++++++++++++---------
> >>>>  drivers/media/platform/vsp1/vsp1_video.h |  2 +-
> >>>>  4 files changed, 54 insertions(+), 26 deletions(-)
> >>>> 
> >>>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
> >>>> b/drivers/media/platform/vsp1/vsp1_pipe.c index
> >>>> 5012643583b6..fa445b1a2e38
> >>>> 100644
> >>>> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> >>>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> >>>> @@ -249,6 +249,7 @@ void vsp1_pipeline_run(struct vsp1_pipeline *pipe)
> >>>>  		vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index),
> >>>>  			   VI6_CMD_STRCMD);
> >>>>  		pipe->state = VSP1_PIPELINE_RUNNING;
> >>>> +		pipe->configured = true;
> >>>>  	}
> >>>>  	
> >>>>  	pipe->buffers_ready = 0;
> >>>> @@ -470,6 +471,12 @@ void vsp1_pipelines_resume(struct vsp1_device
> >>>> *vsp1)
> >>>>  			continue;
> >>>>  		
> >>>>  		spin_lock_irqsave(&pipe->irqlock, flags);
> >>>> +		/*
> >>>> +		 * The hardware may have been reset during a suspend and will
> >>>> +		 * need a full reconfiguration
> >>>> +		 */
> >>> 
> >>> s/reconfiguration/reconfiguration./
> >>> 
> >>>> +		pipe->configured = false;
> >>>> +
> >>> 
> >>> Where does that full reconfiguration occur, given that the
> >>> vsp1_pipeline_run() right below sets pipe->configured to true without
> >>> performing reconfiguration ?
> > 
> > Q
> > 
> >> It's magic isn't it :D
> >> 
> >> If the pipe->configured flag gets set to false, the next execution of
> >> vsp1_pipeline_run() attaches the video->pipe_config (the cached
> >> configuration, containing the route_setup() and the configure_stream()
> >> entries) to the display list before configuring for the next frame.
> > 
> > Unless I'm mistaken, it's vsp1_video_pipeline_run() that does so, not
> > vsp1_pipeline_run().
> 
> Aha - ok - I think I see the issue.
> 
> 1) Yes - you are correct - vsp1_video_pipeline_run() adds the full cached
> configuration to the display list, to ensure that the routes are
> re-configured after a resume.
> 
> >> This means that the hardware gets a full configuration written to it
> >> after a suspend/resume action.
> >> 
> >> Perhaps the comment should say "The video object will write out it's
> >> cached pipe configuration on the next display list commit"
> >> 
> >>>>  		if (vsp1_pipeline_ready(pipe))
> 
> 2) ... Although the next line is a call to vsp1_pipeline_run(), upon a
> resume for a video pipeline - I believe vsp1_pipeline_ready() is false, (we
> will have gone through STOPPING, STOPPED) thus it won't run until the
> *next* iteration.

I don't think that's correct. vsp1_pipeline_ready() returns true if there is 
at least one buffer queued for every RPF and WPF in the pipeline. This can be 
the case at resume time, as suspending the VSP doesn't affect buffer queues.

> DU pipelines will not be affected by the usage pipe->configured flag...
> 
> >>>>  			vsp1_pipeline_run(pipe);
> 
> However - now I see it - yes this feels a bit ugly in that regards, and now
> feels like it's only worked by chance rather than design! :-(
> 
> Hrm ... in fact as there will be no active DL committed for the pipeline -
> is it ever possible for the above vsp1_pipeline_run() to start the pipeline
> ? So it's not chance at least :D

If power to the VSP is cut during suspend then I don't see how 
vsp1_pipelines_resume() could work. Seems like something is seriously 
broken... Should we move vsp1_pipelines_resume() to vsp1_video.c, rename it to 
vsp1_video_pipelines_resume(), and use vsp1_video_pipeline_run() instead of 
vsp1_pipeline_run() ? That would keep all the logic in vsp1_video.c and allow 
for the configured flag to be stored in struct vsp1_video along with 
stream_config.

> Perhaps instead of adding the configured flag, I could add the cached dlb
> configuration if the pipe->state is STOPPED ...

As explained in my review of v10, I think you'll then end up reconfiguring 
everything for every frame. The VSP should remain functional, but with a bit 
of a performance degradation.

>  ... I feel like I've already tried to go down the route of using the
> pipe->state though ...
> 
> 
> Ok - a quick attempt, and I've removed the pipe->configured flag - and
> changed the attach as follows:
> 
> 	/* Attach our pipe configuration to fully initialise the hardware */
> 	if (!pipe->state == VSP1_PIPELINE_STOPPED)
> 		vsp1_dl_list_add_body(dl, video->pipe_config);
> 
> This is 'cleaner' I think as it doesn't add an extra flag - but relies upon
> the exact same circumstance that the pipe->state is not set to running at
> resume time (which I believe to be OK).
> 
> It also passes the relevant tests on vsp-tests:

Seems like we need a suspend/resume test that cuts power from the VSP.

> root@Ubuntu-ARM64:~/vsp-tests# ./vsp-unit-test-0000.sh
> Test Conditions:
>   Platform          Renesas Salvator-X 2nd version board based on r8a7795
> ES2.0+ Kernel release    4.17.0-rc4-arm64-renesas-00397-g3d2f6f2901b0
>   convert           /usr/bin/convert
>   compare           /usr/bin/compare
>   killall           /usr/bin/killall
>   raw2rgbpnm        /usr/bin/raw2rgbpnm
>   stress            /usr/bin/stress
>   yavta             /usr/bin/yavta
> 
> root@Ubuntu-ARM64:~/vsp-tests# ./vsp-unit-test-0019.sh
> Testing non-active pipeline suspend/resume in suspend:freezer: passed
> Testing non-active pipeline suspend/resume in suspend:devices: passed
> Testing non-active pipeline suspend/resume in suspend:platform: passed
> Testing non-active pipeline suspend/resume in suspend:processors: passed
> Testing non-active pipeline suspend/resume in suspend:core: passed
> 
> root@Ubuntu-ARM64:~/vsp-tests# ./vsp-unit-test-0020.sh
> Testing Testing active pipeline suspend/resume in suspend:freezer: pass
> Testing Testing active pipeline suspend/resume in suspend:devices: pass
> Testing Testing active pipeline suspend/resume in suspend:platform: pass
> Testing Testing active pipeline suspend/resume in suspend:processors: pass
> Testing Testing active pipeline suspend/resume in suspend:core: pass
> 
> >>>>  		spin_unlock_irqrestore(&pipe->irqlock, flags);

[snip]

-- 
Regards,

Laurent Pinchart
