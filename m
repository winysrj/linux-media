Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60214 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754881AbeD3QWy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 12:22:54 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v7 6/8] media: vsp1: Refactor display list configure
 operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <e033c9432b2e86c764f7b1e44da10ba66ea4e030.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2941184.iUo9Gmn1JQ@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <6f2ebe67-1882-e9fe-89d5-7b2d1137c994@ideasonboard.com>
Date: Mon, 30 Apr 2018 17:22:49 +0100
MIME-Version: 1.0
In-Reply-To: <2941184.iUo9Gmn1JQ@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/04/18 00:38, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Thursday, 8 March 2018 02:05:29 EEST Kieran Bingham wrote:
>> The entities provide a single .configure operation which configures the
>> object into the target display list, based on the vsp1_entity_params
>> selection.
>>
>> This restricts us to a single function prototype for both static
>> configuration (the pre-stream INIT stage) and the dynamic runtime stages
>> for both each frame - and each partition therein.
>>
>> Split the configure function into two parts, '.configure_stream()' and
>> '.configure_frame()', merging both the VSP1_ENTITY_PARAMS_RUNTIME and
>> VSP1_ENTITY_PARAMS_PARTITION stages into a single call through the
>> .configure_frame(). The configuration for individual partitions is
>> handled by passing the partition number to the configure call, and
>> processing any runtime stage actions on the first partition only.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>> v7
>>  - Fix formatting and white space
>>  - s/prepare/configure_stream/
>>  - s/configure/configure_frame/
>>
>>  drivers/media/platform/vsp1/vsp1_bru.c    |  12 +-
>>  drivers/media/platform/vsp1/vsp1_clu.c    |  50 +---
>>  drivers/media/platform/vsp1/vsp1_dl.h     |   1 +-
>>  drivers/media/platform/vsp1/vsp1_drm.c    |  21 +--
>>  drivers/media/platform/vsp1/vsp1_entity.c |  17 +-
>>  drivers/media/platform/vsp1/vsp1_entity.h |  33 +--
>>  drivers/media/platform/vsp1/vsp1_hgo.c    |  12 +-
>>  drivers/media/platform/vsp1/vsp1_hgt.c    |  12 +-
>>  drivers/media/platform/vsp1/vsp1_hsit.c   |  12 +-
>>  drivers/media/platform/vsp1/vsp1_lif.c    |  12 +-
>>  drivers/media/platform/vsp1/vsp1_lut.c    |  32 +-
>>  drivers/media/platform/vsp1/vsp1_rpf.c    | 164 ++++++-------
>>  drivers/media/platform/vsp1/vsp1_sru.c    |  12 +-
>>  drivers/media/platform/vsp1/vsp1_uds.c    |  57 ++--
>>  drivers/media/platform/vsp1/vsp1_video.c  |  24 +--
>>  drivers/media/platform/vsp1/vsp1_wpf.c    | 299 ++++++++++++-----------
>>  16 files changed, 378 insertions(+), 392 deletions(-)
> 
> [snip]
> 
>> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
>> b/drivers/media/platform/vsp1/vsp1_clu.c index b2a39a6ef7e4..b8d8af6d4910
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_clu.c
>> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
>> @@ -213,37 +213,36 @@ static const struct v4l2_subdev_ops clu_ops = {
>>  /*
>> ---------------------------------------------------------------------------
>> -- * VSP1 Entity Operations
>>   */
>> +static void clu_configure_stream(struct vsp1_entity *entity,
>> +				 struct vsp1_pipeline *pipe,
>> +				 struct vsp1_dl_list *dl)
>> +{
>> +	struct vsp1_clu *clu = to_clu(&entity->subdev);
>> +
>> +	/*
>> +	 * The yuv_mode can't be changed during streaming. Cache it internally
>> +	 * for future runtime configuration calls.
>> +	 */
> 
> I'd move this comment right before the vsp1_entity_get_pad_format() call to 
> keep all variable declarations together.

Agreed, Done.

> 
>> +	struct v4l2_mbus_framefmt *format;
>> +
>> +	format = vsp1_entity_get_pad_format(&clu->entity,
>> +					    clu->entity.config,
>> +					    CLU_PAD_SINK);
>> +	clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
>> +}
> 
> [snip]
> 
> 
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h
>> b/drivers/media/platform/vsp1/vsp1_dl.h index 7e820ac6865a..f45083251644
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.h
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
>> @@ -41,7 +41,6 @@ vsp1_dl_body_pool_create(struct vsp1_device *vsp1,
>> unsigned int num_bodies, void vsp1_dl_body_pool_destroy(struct
>> vsp1_dl_body_pool *pool);
>>  struct vsp1_dl_body *vsp1_dl_body_get(struct vsp1_dl_body_pool *pool);
>>  void vsp1_dl_body_put(struct vsp1_dl_body *dlb);
>> -
> 
> This is an unrelated change.
> 

Removed

>>  void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
>>  int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body
>> *dlb);
>>  int vsp1_dl_list_add_chain(struct vsp1_dl_list *head, struct vsp1_dl_list
>>  *dl);
> 
> [snip]
> 
>> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h
>> b/drivers/media/platform/vsp1/vsp1_entity.h index
>> 408602ebeb97..b44ed5414fc3 100644
>> --- a/drivers/media/platform/vsp1/vsp1_entity.h
>> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> 
> [snip]
> 
>> @@ -80,8 +68,10 @@ struct vsp1_route {
>>  /**
>>   * struct vsp1_entity_operations - Entity operations
>>   * @destroy:	Destroy the entity.
>> - * @configure:	Setup the hardware based on the entity state (pipeline,
>> formats,
>> - *		selection rectangles, ...)
>> + * @configure_stream:	Setup the initial hardware parameters for the 
> stream
>> + *			(pipeline, formats)
> 
> Instead of initial I would say "Setup hardware parameters that stay constant 
> for the whole stream (pipeline, formats)", or possible "that don't vary 
> between frames" instead.
> 
>> + * @configure_frame:	Configure the runtime parameters for each partition
>> + *			(rectangles, buffer addresses, ...)
> 
> Maybe "for each frame and each partition thereof" ?
> 
> I think we mentioned, when discussing naming, the option of also having a 
> configure_partition() operation. Do you think that would make sense ? The 
> fact that the partition parameter to the .configure_frame() operation is used 
> for the sole purpose of checking whether to configure frame-related parameters 
> when partition == 0 makes me think that having two separate operations could 
> make sense.

OK, I'll give this a go now ...


Right ... it's looking good. A good clear separation


> 
>>   * @max_width:	Return the max supported width of data that the entity can
>>   *		process in a single operation.
>>   * @partition:	Process the partition construction based on this entity's
> 
> [snip]
> 
