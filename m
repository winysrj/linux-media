Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34324 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbIGSV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2015 14:21:29 -0400
Received: by oiev17 with SMTP id v17so47100819oie.1
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2015 11:21:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CDDBFE.3020905@xs4all.nl>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
 <e3c80eb0aebe828d2df72be9971ad720f439bb71.1438891530.git.helen.fornazier@gmail.com>
 <55CDDBFE.3020905@xs4all.nl>
From: Helen Fornazier <helen.fornazier@gmail.com>
Date: Mon, 7 Sep 2015 15:21:09 -0300
Message-ID: <CAPW4XYbpiUZ7=vHdODQypfv2CygJ=nkMMCvkYA8o=8ONs_JMeQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] [media] vimc: sen: Integrate the tpg on the sensor
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, thank you all for your review

On Fri, Aug 14, 2015 at 9:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 08/06/2015 10:26 PM, Helen Fornazier wrote:
>> Initialize the test pattern generator on the sensor
>> Generate a colored bar image instead of a grey one
>
> You don't want to put the tpg in every sensor and have all the blocks in
> between process the video. This is all virtual, so all that is necessary
> is to put the tpg in every DMA engine (video node) but have the subdevs
> modify the tpg setting when you start the pipeline.
>
> So the source would set the width/height to the sensor resolution, and it
> will initialize the crop/compose rectangles. Every other entity in the
> pipeline will continue modifying according to what they do. E.g. a scaler
> will just change the compose rectangle.
>
> When you start streaming the tpg will generate the image based on all those
> settings as if all the entities would actually do the work.
>
> Of course, this assumes the processing the entities do map to what the tpg
> can do, but that's true for vimc.
>
> An additional advantage is that the entities can use a wide range of
> mediabus formats since the tpg can generate basically anything. Implementing
> multiplanar is similarly easy. This would be much harder if you had to write
> the image processing code for the entities since you'd either have to support
> lots of different formats (impractical) or limit yourself to just a few.
>
>>
>> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
>> ---
>>  drivers/media/platform/vimc/Kconfig       |  1 +
>>  drivers/media/platform/vimc/vimc-sensor.c | 44 +++++++++++++++++++++++++++++--
>>  2 files changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
>> index 81279f4..7cf7e84 100644
>> --- a/drivers/media/platform/vimc/Kconfig
>> +++ b/drivers/media/platform/vimc/Kconfig
>> @@ -1,6 +1,7 @@
>>  config VIDEO_VIMC
>>       tristate "Virtual Media Controller Driver (VIMC)"
>>       select VIDEO_V4L2_SUBDEV_API
>> +     select VIDEO_TPG
>>       default n
>>       ---help---
>>         Skeleton driver for Virtual Media Controller
>> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
>> index d613792..a2879ad 100644
>> --- a/drivers/media/platform/vimc/vimc-sensor.c
>> +++ b/drivers/media/platform/vimc/vimc-sensor.c
>> @@ -16,15 +16,19 @@
>>   */
>>
>>  #include <linux/freezer.h>
>> +#include <media/tpg.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/v4l2-mediabus.h>
>>  #include <media/v4l2-subdev.h>
>>
>>  #include "vimc-sensor.h"
>>
>> +#define VIMC_SEN_FRAME_MAX_WIDTH 4096
>> +
>>  struct vimc_sen_device {
>>       struct vimc_ent_device ved;
>>       struct v4l2_subdev sd;
>> +     struct tpg_data tpg;
>>       struct v4l2_device *v4l2_dev;
>>       struct device *dev;
>>       struct task_struct *kthread_sen;
>> @@ -87,6 +91,29 @@ static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
>>       return 0;
>>  }
>>
>> +static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
>> +{
>> +     const struct vimc_pix_map *vpix;
>> +
>> +     vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
>> +     /* This should never be NULL, as we won't allow any format other then
>> +      * the ones in the vimc_pix_map_list table */
>> +     BUG_ON(!vpix);
>> +
>> +     tpg_s_bytesperline(&vsen->tpg, 0,
>> +                        vsen->mbus_format.width * vpix->bpp);
>> +     tpg_s_buf_height(&vsen->tpg, vsen->mbus_format.height);
>> +     tpg_s_fourcc(&vsen->tpg, vpix->pixelformat);
>> +     /* TODO: check why the tpg_s_field need this third argument if
>> +      * it is already receiving the field */
>> +     tpg_s_field(&vsen->tpg, vsen->mbus_format.field,
>> +                 vsen->mbus_format.field == V4L2_FIELD_ALTERNATE);
>
> Actually the second argument argument cannot be FIELD_ALTERNATE. If it
> is field ALTERNATE, then the second argument must be either FIELD_TOP or
> FIELD_BOTTOM: i.e. it tells the generator which field comes first in the
> FIELD_ALTERNATE case.
>
> And in case you are wondering: it's always FIELD_TOP except for 60 Hz SDTV
> formats where it is FIELD_BOTTOM.

I am not really familiar to SDTV, but it seems to me to be a different
structure API. Thus can I put FIELD_TOP directly in the second
argument?

tpg_s_field(&vsen->tpg, V4L2_FIELD_TOP,
        vsen->mbus_format.field == V4L2_FIELD_ALTERNATE);

Or is there a way to check if the format is SDTV? I didn't find it
defined on V4L2_PIX_FMT_

>
>> +     tpg_s_colorspace(&vsen->tpg, vsen->mbus_format.colorspace);
>> +     tpg_s_ycbcr_enc(&vsen->tpg, vsen->mbus_format.ycbcr_enc);
>> +     tpg_s_quantization(&vsen->tpg, vsen->mbus_format.quantization);
>> +     tpg_s_xfer_func(&vsen->tpg, vsen->mbus_format.xfer_func);
>> +}
>> +
>>  static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
>>       .enum_mbus_code         = vimc_sen_enum_mbus_code,
>>       .enum_frame_size        = vimc_sen_enum_frame_size,
>> @@ -112,7 +139,7 @@ static int vimc_thread_sen(void *data)
>>               if (kthread_should_stop())
>>                       break;
>>
>> -             memset(vsen->frame, 100, vsen->frame_size);
>> +             tpg_fill_plane_buffer(&vsen->tpg, V4L2_STD_PAL, 0, vsen->frame);
>>
>>               /* Send the frame to all source pads */
>>               for (i = 0; i < vsen->sd.entity.num_pads; i++)
>> @@ -192,6 +219,7 @@ static void vimc_sen_destroy(struct vimc_ent_device *ved)
>>       struct vimc_sen_device *vsen = container_of(ved,
>>                                               struct vimc_sen_device, ved);
>>
>> +     tpg_free(&vsen->tpg);
>>       media_entity_cleanup(ved->ent);
>>       v4l2_device_unregister_subdev(&vsen->sd);
>>       kfree(vsen);
>> @@ -242,6 +270,16 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
>>       vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
>>       vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
>>
>> +     /* Initialize the test pattern generator */
>> +     tpg_init(&vsen->tpg, vsen->mbus_format.width,
>> +              vsen->mbus_format.height);
>> +     ret = tpg_alloc(&vsen->tpg, VIMC_SEN_FRAME_MAX_WIDTH);
>> +     if (ret)
>> +             goto err_clean_m_ent;
>> +
>> +     /* Configure the tpg */
>> +     vimc_sen_tpg_s_format(vsen);
>> +
>>       /* Fill the vimc_ent_device struct */
>>       vsen->ved.destroy = vimc_sen_destroy;
>>       vsen->ved.ent = &vsen->sd.entity;
>> @@ -261,11 +299,13 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
>>       if (ret) {
>>               dev_err(vsen->dev,
>>                       "subdev register failed (err=%d)\n", ret);
>> -             goto err_clean_m_ent;
>> +             goto err_free_tpg;
>>       }
>>
>>       return &vsen->ved;
>>
>> +err_free_tpg:
>> +     tpg_free(&vsen->tpg);
>>  err_clean_m_ent:
>>       media_entity_cleanup(&vsen->sd.entity);
>>  err_clean_pads:
>>
>
> Regards,
>
>         Hans



-- 
Helen Fornazier
