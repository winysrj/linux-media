Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44518 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932400AbeB1VDn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 16:03:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 5/8] v4l: vsp1: Refactor display list configure operations
Date: Wed, 28 Feb 2018 23:04:32 +0200
Message-ID: <2221856.6B6Otkzz8D@avalon>
In-Reply-To: <fd7f961c-e1a5-0c07-e6e4-f710f5c86745@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com> <adf83d35-3ccf-d0cc-747e-20b29f8aa629@ideasonboard.com> <fd7f961c-e1a5-0c07-e6e4-f710f5c86745@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 28 February 2018 18:41:31 EET Kieran Bingham wrote:
> Hi Laurent,
> 
> This series has a pending question below:
> 
> On 17/11/17 15:07, Kieran Bingham wrote:
> > Hi Laurent,
> > 
> > Just a query on your bikeshedding here.
> > 
> > Choose your colours wisely :)
> > 
> > On 12/09/17 20:19, Laurent Pinchart wrote:
> >> On Tuesday, 12 September 2017 00:16:50 EEST Kieran Bingham wrote:
> >>> On 17/08/17 19:13, Laurent Pinchart wrote:
> >>>> On Monday 14 Aug 2017 16:13:28 Kieran Bingham wrote:
> >>>>> The entities provide a single .configure operation which configures
> >>>>> the object into the target display list, based on the
> >>>>> vsp1_entity_params selection.
> >>>>> 
> >>>>> This restricts us to a single function prototype for both static
> >>>>> configuration (the pre-stream INIT stage) and the dynamic runtime
> >>>>> stages for both each frame - and each partition therein.
> >>>>> 
> >>>>> Split the configure function into two parts, '.prepare()' and
> >>>>> '.configure()', merging both the VSP1_ENTITY_PARAMS_RUNTIME and
> >>>>> VSP1_ENTITY_PARAMS_PARTITION stages into a single call through the
> >>>>> .configure(). The configuration for individual partitions is handled
> >>>>> by passing the partition number to the configure call, and processing
> >>>>> any runtime stage actions on the first partition only.
> >>>>> 
> >>>>> Signed-off-by: Kieran Bingham
> >>>>> <kieran.bingham+renesas@ideasonboard.com>
> >>>>> ---
> >>>>> 
> >>>>>  drivers/media/platform/vsp1/vsp1_bru.c    |  12 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_clu.c    |  43 +--
> >>>>>  drivers/media/platform/vsp1/vsp1_drm.c    |  11 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_entity.c |  15 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_entity.h |  27 +--
> >>>>>  drivers/media/platform/vsp1/vsp1_hgo.c    |  12 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_hgt.c    |  12 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_hsit.c   |  12 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_lif.c    |  12 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_lut.c    |  24 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_rpf.c    | 162 ++++++-------
> >>>>>  drivers/media/platform/vsp1/vsp1_sru.c    |  12 +-
> >>>>>  drivers/media/platform/vsp1/vsp1_uds.c    |  55 ++--
> >>>>>  drivers/media/platform/vsp1/vsp1_video.c  |  24 +--
> >>>>>  drivers/media/platform/vsp1/vsp1_wpf.c    | 297 +++++++++++----------
> >>>>>  15 files changed, 359 insertions(+), 371 deletions(-)
> >>>> 
> >>>> [snip]
> >>>> 
> >>>>> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
> >>>>> b/drivers/media/platform/vsp1/vsp1_clu.c index
> >>>>> 175717018e11..5f65ce3ad97f
> >>>>> 100644
> >>>>> --- a/drivers/media/platform/vsp1/vsp1_clu.c
> >>>>> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> >>>>> @@ -213,37 +213,37 @@ static const struct v4l2_subdev_ops clu_ops = {
> >>>>>  /* ------------------------------------------------------------------
> >>>>>   * VSP1 Entity Operations
> >>>>>   */
> >>>>> +static void clu_prepare(struct vsp1_entity *entity,
> >>>>> +			struct vsp1_pipeline *pipe,
> >>>>> +			struct vsp1_dl_list *dl)
> >>>>> +{
> >>>>> +	struct vsp1_clu *clu = to_clu(&entity->subdev);
> >>>>> +
> >>>>> +	/*
> >>>>> +	 * The format can't be changed during streaming, only verify it
> >>>>> +	 * at setup time and store the information internally for future
> >>>>> +	 * runtime configuration calls.
> >>>>> +	 */
> >>>> 
> >>>> I know you're just moving the comment around, but let's fix it at the
> >>>> same time. There's no verification here (and no "setup time" either).
> >>>> I'd write it as
> >>>> 
> >>>> 	/*
> >>>> 	 * The format can't be changed during streaming. Cache it internally
> >>>> 	 * for future runtime configuration calls.
> >>>> 	 */
> >>> 
> >>> I think I'm ok with that and I've updated the patch - but I'm not sure
> >>> we are really caching the 'format' here, as much as the yuv_mode ...
> >> 
> >> Yes, it's the YUV mode we're caching, feel free to update the comment.
> > 
> > Done.
> > 
> >>> I'll ponder ...
> >>> 
> >>>>> +	struct v4l2_mbus_framefmt *format;
> >>>>> +
> >>>>> +	format = vsp1_entity_get_pad_format(&clu->entity,
> >>>>> +					    clu->entity.config,
> >>>>> +					    CLU_PAD_SINK);
> >>>>> +	clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
> >>>>> +}
> >>>> 
> >>>> [snip]
> >>>> 
> >>>>> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h
> >>>>> b/drivers/media/platform/vsp1/vsp1_entity.h index
> >>>>> 408602ebeb97..2f33e343ccc6 100644
> >>>>> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> >>>>> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> >>>> 
> >>>> [snip]
> >>>> 
> >>>>> @@ -80,8 +68,10 @@ struct vsp1_route {
> >>>>>  /**
> >>>>>   * struct vsp1_entity_operations - Entity operations
> >>>>>   * @destroy:	Destroy the entity.
> >>>>> - * @configure:	Setup the hardware based on the entity state
> >>>>> (pipeline, formats,
> >>>>> - *		selection rectangles, ...)
> >>>>> + * @prepare:	Setup the initial hardware parameters for the stream
> >>>>> (pipeline,
> >>>>> + *		formats)
> >>>>> + * @configure:	Configure the runtime parameters for each partition
> >>>>> (rectangles,
> >>>>> + *		buffer addresses, ...)
> >>>> 
> >>>> Now moving to the bikeshedding territory, I'm not sure if prepare and
> >>>> configure are the best names for those operations.
> > 
> > Would init() and configure() be more suitable for you ?
> > 
> > Or 'setup()' and 'configure() or perhaps 'runtime()' ?
> > 
> > I'm not convinced on either init() or setup() yet, as they might refer to
> > 'initialising' the object, rather than portraying the configuration of the
> > object into a body...
> 
> Any preference or alternative for the namings on the above topic?

I'd like the names to convey the fact that the functions fill display lists 
(or rather parts thereof) for the purpose of hardware configuration from the 
software configuration of the entity.

> >>>> I'd like to also point out that we could go one step further by caching
> >>>> the partition-related parameters too, in which case we would need a
> >>>> third operation (or possibly passing the partition number to the
> >>>> prepare operation). While I won't mind if you implement this now, the
> >>>> issue could also be addressed later, but I'd like the operations to
> >>>> already support that use case to avoid yet another painful rename
> >>>> patch.
> 
> Or based on the above - would you prefer a different approach to handling
> this?
> 
> I think the reason for the split was to prevent passing a display list when
> not available or required. This could be passed as NULL on operations where
> it is not used.
> 
> And in fact, with this series - it looks like the only use for passing the
> display list now, is to handle the LUT and CLU body swaps.
> 
> Any ideas how we could improve this so that we didn't need to pass a display
> list ?

Sorry, it's been too long, I can't remember. I'm not sure when I'll have time 
to dive into this again.

> >>> Ok, understood - but I think I'll have to defer to a v4 for now ... I'm
> >>> running out of time.
> >>> 
> >>>>>   * @max_width:	Return the max supported width of data that the entity
> >>>>> can
> >>>>>   *		process in a single operation.
> >>>>>   * @partition:	Process the partition construction based on this
> >>>>> entity's
> >>>> 
> >>>> [snip]
> >>>> 
> >>>> The rest of the patch looks good to me.

-- 
Regards,

Laurent Pinchart
