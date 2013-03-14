Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62973 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3CNABh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Mar 2013 20:01:37 -0400
Message-ID: <5141135C.8010100@gmail.com>
Date: Thu, 14 Mar 2013 01:01:32 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [RFC 01/12] media: s5p-fimc: modify existing mdev to use common
 pipeline
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com> <1362570838-4737-2-git-send-email-shaik.ameer@samsung.com> <513D027A.10004@gmail.com> <CAOD6ATo3vSCBN1u7wWBP22xDqVR1qEpae6ksg9Tj_ie=hoKOJw@mail.gmail.com>
In-Reply-To: <CAOD6ATo3vSCBN1u7wWBP22xDqVR1qEpae6ksg9Tj_ie=hoKOJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 03/11/2013 07:41 AM, Shaik Ameer Basha wrote:
> Hi Sylwester,
>
> Thanks for the review.
> Actually I know this is the important patch in this series and I
> wanted us to have
> enough time to discuss on this patch. That's why I posted this patch
> series in hurry.

Sure, I'm glad it was posted early.

> I will remove this patch from the exynos5-mdev series and will send this as a
> separate patch from next time.

OK.

> please find my review comments inline..
>
>
> On Mon, Mar 11, 2013 at 3:30 AM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com>  wrote:
>> On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
>>>
>>> This patch modifies the current fimc_pipeline to exynos_pipeline,
>>
>> I think we could leave it as fimc_pipeline, exynos_pipeline seems
>> too generic to me.
>
> no issues, if we are going to strict to this common pipeline implementation
> definitely we can retain fimc_pipeline or we can use some other name which
> is not too generic.
...
>>>    static int fimc_capture_hw_init(struct fimc_dev *fimc)
>>>    {
>>>          struct fimc_ctx *ctx = fimc->vid_cap.ctx;
>>> -       struct fimc_pipeline *p =&fimc->pipeline;
>>> +       struct exynos_pipeline *p =&fimc->pipeline;
>>>
>>>          struct fimc_sensor_info *sensor;
>>>          unsigned long flags;
>>> +       struct v4l2_subdev *sd;
>>>          int ret = 0;
>>>
>>> -       if (p->subdevs[IDX_SENSOR] == NULL || ctx == NULL)
>>> +       sd = exynos_pipeline_get_subdev(fimc->pipeline_ops,
>>> +                                       get_subdev_sensor, p);
>>
>>
>> Hmm, it feels it is going wrong path this way. I would keep changes
>> to the s5p-fimc driver as small as possible. And the modules that
>> are shared across the exynos4 and exynos5 driver should use generic
>> media graph walking routines where possible.
>
> The only problem here is, the fimc_subdev_index enum is specific to
> fimc-mdevice.
> and why should we expose one particular media-device driver specific
> enums to other drivers.

OK, I missed the point this enum is in a public header that would be
reused by other media drivers.

> My Idea was to remove all media device specific structures, macros
> from fimc, fimc-lite, mipi-csis and fimc-is drivers.

Of course we cannot remove them all, as video node drivers need be
able to control the pipeline. And I'm not very enthusiastic about
creating more dependencies between exynos4 and exynos5 drivers.
But I guess a common video pipeline object definition cannot be
avoided as FIMC-LITE is reused by exynos4 and exynos5 subsystems.

>>> +       if (sd == NULL || ctx == NULL)
>>>                  return -ENXIO;
>>>          if (ctx->s_frame.fmt == NULL)
>>>                  return -EINVAL;
>>>
>>> -       sensor = v4l2_get_subdev_hostdata(p->subdevs[IDX_SENSOR]);
>>> +       sensor = v4l2_get_subdev_hostdata(sd);
>>>
>>>          spin_lock_irqsave(&fimc->slock, flags);
>>>          fimc_prepare_dma_offset(ctx,&ctx->d_frame);
>>
>> ...
>>>
>>> @@ -486,9 +491,12 @@ static struct vb2_ops fimc_capture_qops = {
>>>    int fimc_capture_ctrls_create(struct fimc_dev *fimc)
>>>    {
>>>          struct fimc_vid_cap *vid_cap =&fimc->vid_cap;
>>>
>>> -       struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
>>> +       struct v4l2_subdev *sensor;
>>>          int ret;
>>>
>>> +       sensor = exynos_pipeline_get_subdev(fimc->pipeline_ops,
>>> +
>>> get_subdev_sensor,&fimc->pipeline);
>>>
>>> +
>>>          if (WARN_ON(vid_cap->ctx == NULL))
>>>                  return -ENXIO;
>>>          if (vid_cap->ctx->ctrls.ready)
>>> @@ -513,7 +521,7 @@ static int fimc_capture_open(struct file *file)
>>>
>>>          dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
>>>
>>> -       fimc_md_graph_lock(fimc);
>>> +       exynos_pipeline_graph_lock(fimc->pipeline_ops,&fimc->pipeline);
>>
>>
>> Hmm, this look pretty scary to me. But I suspect this change is not
>> needed at all. The graph lock is _not_ the pipeline lock. It protects
>> all media entities registered to the media device, and links between
>> them. Not only entities linked into specific video processing pipeline
>> at a moment.
>
> Sorry, here the function name doesn't suits its implementation.
> Actually  exynos_pipeline_graph_lock() does what exactly
> fimc_md_graph_lock() does.
> I thought of having one common function across all the drivers to use
> graph lock/unlock functionality.

I'm not convinced we need something like this at the exynos drivers
level. We could add something to the v4l2 core, e.g. functions taking
struct media_entity as an argument. No need for adding extra levels
of indirection.

>>> -/* Called with the media graph mutex held */
>>> -static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
>>> -{
>>> -       struct media_pad *pad =&me->pads[0];
>>>
>>> -       struct v4l2_subdev *sd;
>>> -
>>> -       while (pad->flags&   MEDIA_PAD_FL_SINK) {
>>>
>>> -               /* source pad */
>>> -               pad = media_entity_remote_source(pad);
>>> -               if (pad == NULL ||
>>> -                   media_entity_type(pad->entity) !=
>>> MEDIA_ENT_T_V4L2_SUBDEV)
>>> -                       break;
>>> -
>>> -               sd = media_entity_to_v4l2_subdev(pad->entity);
>>> -
>>> -               if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR)
>>> -                       return sd;
>>> -               /* sink pad */
>>> -               pad =&sd->entity.pads[0];
>>>
>>> -       }
>>> -       return NULL;
>>> -}
>>
>>
>> What's wrong with this function ? Why doesn't it work for you ?
>> I think we should drop direct usage of fimc->pipeline->subdevs[IDX_SENSOR]
>> instead. The sensor group IDs should probably be moved to some common
>> header file.
>>
>
> In case of exynos4, fimc-lite only used with fimc-is. That means it only
> uses the FIMC IS SENSOR. but in case of exynos5, fimc-lite can use both

Not really, FIMC-LITE does work without FIMC-IS. I tested it with external
sensors with an embedded ISP. So it is pretty much same as FIMC in terms
of video capture from external sensors.

The function above is only used when FIMC-LITE is used as a subdev, and
the FIMC video node driver creates and owns the fimc_pipeline object.

Accessing the pipeline->subdevs[] array from within FIMC-LITE would have
been racy.

> GRP_ID_SENSOR and GRP_ID_FIMC_IS_SENSOR. Even this group ID's are
> specific to individual media device drivers.

That's true. When a subdev is registered to v4l2_device its driver usually
assigns grp_id as it sees fit.

> Here the idea is driver need not know about which sensor is connected to the
> pipeline, it can be IS sensor or normal sensor. It can use the common pipeline
> api's to get the sensor sub-dev.
>
> Or as you suggested, we can move all this GRP_ID's to some common location
> and change the checking in this function to
>          -  if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR)
>          + if ((sd->grp_id == GRP_ID_FIMC_IS_SENSOR) || (sd->grp_id ==
> GRP_ID_SENSOR))
>
> My only idea was to reuse the fimc pipeline structure (struct
> fimc_pipeline) across
> different media device drivers. Having a hard-coded max array index
> which is specific to
> one media device driver will not help it to be reused by multiple guys.
>
> I may be missing some details here. Can you please suggest a better
> way to remove this dependency.

OK, let's try with the get_subdev pipeline operation for now.

>>> diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
>>> b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
>>> index fc93fad..938cc56 100644
>>> --- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
>>> +++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
>>> @@ -36,6 +36,8 @@
>>>    #include "fimc-mdevice.h"
>>>    #include "mipi-csis.h"
>>>
>>> +static struct fimc_md *g_fimc_mdev;
>>
>>
>> Hm, this is pretty ugly. Can you explain why it is needed ?
>
> I was expecting this.
> Actually i want to associate this fimc_mdev with this exynos_pipeline.
> But as the pipeline init happens from the driver context (fimc,
> fimc-lite), I should
> have a way to access struct fimc_md in pipeline init function. That's
> why I stored a
> global reference of struct fimc_md here.
> I think, I need to find a better way to achieve same functionality if needed. :)

The struct fimc_pipeline was meant as a collection of subdevs only.
Why do you need a back reference to struct fimc_md ? To be able to
control one pipeline from within the other ?

Single entities should be aware of the whole pipeline and the media
device driver internals as little as possible.

...
>>> +       struct v4l2_subdev *(*get_subdev_sensor)(struct exynos_pipeline *p);
>>> +       struct v4l2_subdev *(*get_subdev_csis)(struct exynos_pipeline *p);
>>
>> No, we should instead use generic media graph walking routines in the
>> shared drivers (FIMC-LITE, MIPI-CSIS). FIMC driver could be making
>> certain assumptions about it's related media device driver. These
>> drivers are contained in a single module anyway.
>
> Cant we expose some macros for subdevs in a common header and implement a
> get_subdev function in common pipeline to achieve this.
>
> enum in /include/media/s5p_fimc.h file. Something like
>
> EXYNOS_SD_SENSOR,
> EXYNOS_SD_MIPI_CSIS,
> ...
> ... etc.
>
> pipeline_ops->get_subdev(pipeline, EXYNOS_SD_SENSOR);
>
> actually, the implementation of get_subdev uses the media device specific
> structures which stored the subdev pointers internally by using  generic media
> graph walking routines itself. so there should not be any issues with using the
> common pipeline api's also.

This option might cause less issues WRT locking. Let's try this and see how
it looks. I suppose we could use GRP_IDs as the subdev identifiers, after
adding EXYNOS_SD_* prefix or something similar.

> [Or]
>
> as you already suggested, we can have some common group id's exposed
> in a common header file, and use the generic media graph walking
> routines in each driver to achieve this functionality.

Regards,
Sylwester
