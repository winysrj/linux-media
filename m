Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:36619 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753255AbcLNM1k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 07:27:40 -0500
Received: by mail-wj0-f194.google.com with SMTP id j10so4337097wjb.3
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2016 04:27:39 -0800 (PST)
Subject: Re: [PATCHv3 RFC 4/4] media: Catch null pipes on pipeline stop
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1481651984-7687-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <20161214072843.GA16630@valkosipuli.retiisi.org.uk>
Cc: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <9594fc25-c657-7326-0987-9a7bc1bc888f@bingham.xyz>
Date: Wed, 14 Dec 2016 12:27:37 +0000
MIME-Version: 1.0
In-Reply-To: <20161214072843.GA16630@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 14/12/16 07:28, Sakari Ailus wrote:
> Hi Kieran,
> 
> On Tue, Dec 13, 2016 at 05:59:44PM +0000, Kieran Bingham wrote:
>> media_entity_pipeline_stop() can be called through error paths with a
>> NULL entity pipe object. In this instance, stopping is a no-op, so
>> simply return without any action
> 
> The approach of returning silently is wrong; the streaming count is indeed a
> count: you have to decrement it the exactly same number of times it's been
> increased. Code that attempts to call __media_entity_pipeline_stop() on an
> entity that's not streaming is simply buggy.

Ok, Thanks for the heads up on where to look, as I suspected we are in
section B) of my comments below :D

> I've got a patch here that adds a warning to graph traversal on streaming
> count being zero. I sent a pull request including that some days ago:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg108980.html>
> <URL:http://www.spinics.net/lists/linux-media/msg108995.html>

Excellent, thanks, I've merged your branch into mine, and I'll
investigate where the error is actually coming from.

--
Ok - so I've merged your patches, (and dropped this patch) but they
don't fire any warning before I hit my null-pointer dereference in
__media_pipeline_stop(), on the WARN_ON(!pipe->streaming_count);

So I think this is a case of calling stop on an invalid entity rather
than an unbalanced start/stop somehow:

[  613.830334] vsp1 fea38000.vsp: failed to reset wpf.0
[  613.838137] PM: resume of devices complete after 124.410 msecs
[  613.847390] PM: Finishing wakeup.
[  613.852247] Restarting tasks ... done.
[  615.864801] ravb e6800000.ethernet eth0: Link is Up - 100Mbps/Full -
flow control rx/tx
[  617.011299] vsp1 fea38000.vsp: failed to reset wpf.0
[  617.017777] vsp1 fea38000.vsp: DRM pipeline stop timeout
[  617.024649] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[  617.034273] pgd = ffffff80098c5000
[  617.039171] [00000000] *pgd=000000073fffe003[  617.043336] ,
*pud=000000073fffe003
, *pmd=0000000000000000[  617.050353]
[  617.053282] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[  617.060309] Modules linked in:
[  617.064793] CPU: 1 PID: 683 Comm: kworker/1:2 Not tainted
4.9.0-00506-g4d2a939ea654 #350
[  617.074320] Hardware name: Renesas Salvator-X board based on r8a7795 (DT)
[  617.082578] Workqueue: events drm_mode_rmfb_work_fn
[  617.088884] task: ffffffc6fabd2b00 task.stack: ffffffc6f9d90000
[  617.096246] PC is at __media_pipeline_stop+0x24/0xe8
[  617.102644] LR is at media_pipeline_stop+0x34/0x48

<regs and stack snipped>

[  617.863386] [<ffffff800853e724>] __media_pipeline_stop+0x24/0xe8
[  617.870417] [<ffffff800853e81c>] media_pipeline_stop+0x34/0x48
[  617.877272] [<ffffff8008568000>] vsp1_du_setup_lif+0x68/0x5a8
[  617.884047] [<ffffff80084de9d4>] rcar_du_vsp_disable+0x2c/0x38
[  617.890898] [<ffffff80084da710>] rcar_du_crtc_stop+0x198/0x1e8
[  617.897749] [<ffffff80084da780>] rcar_du_crtc_disable+0x20/0x38
[  617.904683] [<ffffff80084ac9b0>]
drm_atomic_helper_commit_modeset_disables+0x1b0/0x3d8
[  617.913634] [<ffffff80084db9cc>] rcar_du_atomic_complete+0x34/0xc8
[  617.920828] [<ffffff80084dbd20>] rcar_du_atomic_commit+0x2c0/0x2d0
[  617.928012] [<ffffff80084ceffc>] drm_atomic_commit+0x5c/0x68
[  617.934663] [<ffffff80084ad2e0>] drm_atomic_helper_set_config+0x90/0xd0
[  617.942288] [<ffffff80084c06a0>] drm_mode_set_config_internal+0x70/0x100
[  617.949996] [<ffffff80084c0760>] drm_crtc_force_disable+0x30/0x40
[  617.957084] [<ffffff80084d0b10>] drm_framebuffer_remove+0x100/0x128
[  617.964347] [<ffffff80084d0b80>] drm_mode_rmfb_work_fn+0x48/0x60
[  617.971352] [<ffffff80080e9770>] process_one_work+0x1e0/0x738
[  617.978084] [<ffffff80080e9f24>] worker_thread+0x25c/0x4a0
[  617.984546] [<ffffff80080f11ac>] kthread+0xd4/0xe8
[  617.990305] [<ffffff8008083680>] ret_from_fork+0x10/0x50


So, I'll have to schedule some time to investigate this deeper and find
out where we are calling stop on an invalid entity object.

I agree that this patch should simply be dropped though, it was more to
promote a bit of discussion on the area to help me understand what was
going on, which it has!.

Thankyou Sakari!

--
Regards

Kieran


> I think the check here could simply be removed as the check is done for
> every entity in the pipeline with the above patch.
> 
> If there's still a wish to check for the pipe field which should not be
> written by drivers, it should be done during pipeline traversal so that it
> applies to all entities in the pipeline, not just where traversal starts.
> 
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>
>> I've marked this patch as RFC, although if deemed suitable, by all means
>> integrate it as is.
>>
>> When testing suspend/resume operations on VSP1, I encountered a segfault on the
>> WARN_ON(!pipe->streaming_count) line, where 'pipe == NULL'. The simple
>> protection fix is to return early in this instance, as this patch does however:
>>
>> A) Does this early return path warrant a WARN() statement itself, to identify
>> drivers which are incorrectly calling media_entity_pipeline_stop() with an
>> invalid entity, or would this just be noise ...
>>
>> and therefore..
>>
>> B) I also partly assume this patch could simply get NAK'd with a request to go
>> and dig out the root cause of calling media_entity_pipeline_stop() with an
>> invalid entity. 
>>
>> My brief investigation so far here so far shows that it's almost a second order
>> fault - where the first suspend resume cycle completes but leaves the entity in
>> an invalid state having followed an error path - and then on a second
>> suspend/resume - the stop fails with the affected segfault.
>>
>> If statement A) or B) apply here, please drop this patch from the series, and
>> don't consider it a blocking issue for the other 3 patches.
>>
>> Kieran
>>
>>
>>  drivers/media/media-entity.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index c68239e60487..93c9cbf4bf46 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -508,6 +508,8 @@ void __media_entity_pipeline_stop(struct media_entity *entity)
>>  	struct media_entity_graph *graph = &entity->pipe->graph;
>>  	struct media_pipeline *pipe = entity->pipe;
>>  
>> +	if (!pipe)
>> +		return;
>>  
>>  	WARN_ON(!pipe->streaming_count);
>>  	media_entity_graph_walk_start(graph, entity);
> 

-- 
Regards

Kieran Bingham
