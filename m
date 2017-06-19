Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57031 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdFSRtk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:49:40 -0400
Subject: Re: [PATCH v2] [media] v4l2: add V4L2_CAP_IO_MC
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
 <1497415836-15142-1-git-send-email-helen.koike@collabora.com>
 <2327e555-118e-0882-f2f6-7c0f74985aee@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        jgebben@codeaurora.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <44dda7f2-1bf7-6b4d-d215-35102612ba21@collabora.com>
Date: Mon, 19 Jun 2017 14:49:26 -0300
MIME-Version: 1.0
In-Reply-To: <2327e555-118e-0882-f2f6-7c0f74985aee@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for reviewing this

On 2017-06-19 08:15 AM, Hans Verkuil wrote:
> On 06/14/2017 06:50 AM, Helen Koike wrote:
>> Add V4L2_CAP_IO_MC to be used in struct v4l2_capability to indicate that
>> input and output are controlled by the Media Controller instead of V4L2
>> API.
>> When this flag is set, ioctls for get, set and enum input and outputs
>> are automatically enabled and programmed to call helper function.
>>
>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>
>> ---
>>
>> Changes in v2::
>>     - replace the type by capability
>>     - erase V4L2_INPUT_TYPE_DEFAULT
>>     - also consider output
>>     - plug helpers in the ops automatically so drivers doesn't need
>>     to set it by hand
>>     - update docs
>>     - commit message and title
>> ---
>>   Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +
>>   Documentation/media/videodev2.h.rst.exceptions   |  1 +
>>   drivers/media/v4l2-core/v4l2-dev.c               | 35 +++++++--
>>   drivers/media/v4l2-core/v4l2-ioctl.c             | 91
>> ++++++++++++++++++++++--
>>   include/uapi/linux/videodev2.h                   |  2 +
>>   5 files changed, 120 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst
>> b/Documentation/media/uapi/v4l/vidioc-querycap.rst
>> index 12e0d9a..2bd1223 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
>> @@ -252,6 +252,9 @@ specification the ioctl returns an ``EINVAL``
>> error code.
>>       * - ``V4L2_CAP_TOUCH``
>>         - 0x10000000
>>         - This is a touch device.
>> +    * - ``V4L2_CAP_IO_MC``
>> +      - 0x20000000
>> +      - This device has its inputs and outputs controller by the
>> Media Controller
>
> controller -> controlled

Sorry, I'll remember to use a spell checker next time

>
> But I would rephrase this a bit:
>
>     - The inputs and/or outputs of this device are controlled by the
> Media Controller
>       (see: <add link to Part IV of the media documentation>).
>

Sure, much better.
In this document, almost all the flags start with "The device 
supports..." or "The device has...", I was thinking to do something similar.

>>       * - ``V4L2_CAP_DEVICE_CAPS``
>>         - 0x80000000
>>         - The driver fills the ``device_caps`` field. This capability can
>> diff --git a/Documentation/media/videodev2.h.rst.exceptions
>> b/Documentation/media/videodev2.h.rst.exceptions
>> index a5cb0a8..0b48cd0 100644
>> --- a/Documentation/media/videodev2.h.rst.exceptions
>> +++ b/Documentation/media/videodev2.h.rst.exceptions
>> @@ -159,6 +159,7 @@ replace define V4L2_CAP_ASYNCIO device-capabilities
>>   replace define V4L2_CAP_STREAMING device-capabilities
>>   replace define V4L2_CAP_DEVICE_CAPS device-capabilities
>>   replace define V4L2_CAP_TOUCH device-capabilities
>> +replace define V4L2_CAP_IO_MC device-capabilities
>>     # V4L2 pix flags
>>   replace define V4L2_PIX_FMT_PRIV_MAGIC :c:type:`v4l2_pix_format`
>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c
>> b/drivers/media/v4l2-core/v4l2-dev.c
>> index c647ba6..0f272fe 100644
>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>> @@ -688,22 +688,34 @@ static void determine_valid_ioctls(struct
>> video_device *vdev)
>>           SET_VALID_IOCTL(ops, VIDIOC_G_STD, vidioc_g_std);
>>           if (is_rx) {
>>               SET_VALID_IOCTL(ops, VIDIOC_QUERYSTD, vidioc_querystd);
>> -            SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
>> -            SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
>> -            SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
>>               SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDIO, vidioc_enumaudio);
>>               SET_VALID_IOCTL(ops, VIDIOC_G_AUDIO, vidioc_g_audio);
>>               SET_VALID_IOCTL(ops, VIDIOC_S_AUDIO, vidioc_s_audio);
>>               SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS,
>> vidioc_query_dv_timings);
>>               SET_VALID_IOCTL(ops, VIDIOC_S_EDID, vidioc_s_edid);
>> +            if (vdev->device_caps & V4L2_CAP_IO_MC) {
>> +                set_bit(_IOC_NR(VIDIOC_ENUMINPUT), valid_ioctls);
>> +                set_bit(_IOC_NR(VIDIOC_G_INPUT), valid_ioctls);
>> +                set_bit(_IOC_NR(VIDIOC_S_INPUT), valid_ioctls);
>> +            } else {
>> +                SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT,
>> vidioc_enum_input);
>> +                SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
>> +                SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
>> +            }
>>           }
>>           if (is_tx) {
>> -            SET_VALID_IOCTL(ops, VIDIOC_ENUMOUTPUT, vidioc_enum_output);
>> -            SET_VALID_IOCTL(ops, VIDIOC_G_OUTPUT, vidioc_g_output);
>> -            SET_VALID_IOCTL(ops, VIDIOC_S_OUTPUT, vidioc_s_output);
>>               SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDOUT, vidioc_enumaudout);
>>               SET_VALID_IOCTL(ops, VIDIOC_G_AUDOUT, vidioc_g_audout);
>>               SET_VALID_IOCTL(ops, VIDIOC_S_AUDOUT, vidioc_s_audout);
>> +            if (vdev->device_caps & V4L2_CAP_IO_MC) {
>> +                set_bit(_IOC_NR(VIDIOC_ENUMOUTPUT), valid_ioctls);
>> +                set_bit(_IOC_NR(VIDIOC_G_OUTPUT), valid_ioctls);
>> +                set_bit(_IOC_NR(VIDIOC_S_OUTPUT), valid_ioctls);
>> +            } else {
>> +                SET_VALID_IOCTL(ops, VIDIOC_ENUMOUTPUT,
>> vidioc_enum_output);
>> +                SET_VALID_IOCTL(ops, VIDIOC_G_OUTPUT, vidioc_g_output);
>> +                SET_VALID_IOCTL(ops, VIDIOC_S_OUTPUT, vidioc_s_output);
>> +            }
>>           }
>>           if (ops->vidioc_g_parm || (vdev->vfl_type ==
>> VFL_TYPE_GRABBER &&
>>                       ops->vidioc_g_std))
>> @@ -945,6 +957,17 @@ int __video_register_device(struct video_device
>> *vdev, int type, int nr,
>>       video_device[vdev->minor] = vdev;
>>       mutex_unlock(&videodev_lock);
>>   +#if defined(CONFIG_MEDIA_CONTROLLER)
>> +    if (vdev->ioctl_ops
>> +        && !vdev->ioctl_ops->vidioc_enum_input
>> +        && !vdev->ioctl_ops->vidioc_s_input
>> +        && !vdev->ioctl_ops->vidioc_g_input
>> +        && !vdev->ioctl_ops->vidioc_enum_output
>> +        && !vdev->ioctl_ops->vidioc_s_output
>> +        && !vdev->ioctl_ops->vidioc_g_output)
>> +        vdev->device_caps |= V4L2_CAP_IO_MC;
>
> No, this part should be dropped.
>
> Let the driver set this capability explicitly. This code for example
> would set the IO_MC
> bit as well for radio devices, and that's not what you want.

hmm, right, so we will need to update the drivers one by one in the end.

I think I still don't fully understand the importance of the 
V4L2_CAP_IO_MC flag (sorry to bring this up again, I just want to make 
sure this is right), we don't have a flag to say that an output is an 
HDMI, user space uses the VIDIOC_ENUMOUTPUT ioctl to figure that this is 
an HDMI by its output's name, why this can't be the same for MC 
controlled IOs?

>
> The MC can also be used by regular drivers (there is nothing preventing
> drivers from
> doing that). So just leave this up to the driver.
>
>> +#endif
>> +
>>       if (vdev->ioctl_ops)
>>           determine_valid_ioctls(vdev);
>>   diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
>> b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index e5a2187..9d8c645 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -1019,6 +1019,70 @@ static int v4l_querycap(const struct
>> v4l2_ioctl_ops *ops,
>>       return ret;
>>   }
>>   +static int v4l2_ioctl_enum_input_mc(struct file *file, void *priv,
>> +                    struct v4l2_input *i)
>> +{
>> +    struct video_device *vfd = video_devdata(file);
>> +
>> +    if (i->index > 0)
>> +        return -EINVAL;
>> +
>> +    memset(i, 0, sizeof(*i));
>> +    strlcpy(i->name, vfd->name, sizeof(i->name));
>
>     i->type = V4L2_INPUT_TYPE_CAMERA;
>
>> +
>> +    return 0;
>> +}
>> +
>> +static int v4l2_ioctl_enum_output_mc(struct file *file, void *priv,
>> +                     struct v4l2_output *o)
>> +{
>> +    struct video_device *vfd = video_devdata(file);
>> +
>> +    if (o->index > 0)
>> +        return -EINVAL;
>> +
>> +    memset(o, 0, sizeof(*o));
>> +    strlcpy(o->name, vfd->name, sizeof(o->name));
>
>     o->type = V4L2_OUTPUT_TYPE_ANALOG;
>
>> +
>> +    return 0;
>> +}
>> +
>> +static int v4l2_ioctl_g_input_mc(struct file *file, void *priv,
>> unsigned int *i)
>> +{
>> +    *i = 0;
>> +    return 0;
>> +}
>> +#define v4l2_ioctl_g_output_mc v4l2_ioctl_g_input_mc
>> +
>> +static int v4l2_ioctl_s_input_mc(struct file *file, void *priv,
>> unsigned int i)
>> +{
>> +    return i ? -EINVAL : 0;
>> +}
>> +#define v4l2_ioctl_s_output_mc v4l2_ioctl_s_input_mc
>> +
>> +
>> +static int v4l_g_input(const struct v4l2_ioctl_ops *ops,
>> +               struct file *file, void *fh, void *arg)
>> +{
>> +    struct video_device *vfd = video_devdata(file);
>> +
>> +    if (vfd->device_caps & V4L2_CAP_IO_MC)
>> +        return v4l2_ioctl_g_input_mc(file, fh, arg);
>> +    else
>
> 'else' is not needed.

'else' is not needed but I thought it was easier to read the code this 
way (and I believe the compiler optimizes this), anyway, I'll remove the 
'else' then, no problem.

>
>> +        return ops->vidioc_g_input(file, fh, arg);
>> +}
>> +
>> +static int v4l_g_output(const struct v4l2_ioctl_ops *ops,
>> +               struct file *file, void *fh, void *arg)
>> +{
>> +    struct video_device *vfd = video_devdata(file);
>> +
>> +    if (vfd->device_caps & V4L2_CAP_IO_MC)
>> +        return v4l2_ioctl_g_output_mc(file, fh, arg);
>> +    else
>
> 'else' is not needed. Same for the others below.
>
>> +        return ops->vidioc_g_output(file, fh, arg);
>> +}
>> +
>>   static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
>>                   struct file *file, void *fh, void *arg)
>>   {
>> @@ -1028,13 +1092,22 @@ static int v4l_s_input(const struct
>> v4l2_ioctl_ops *ops,
>>       ret = v4l_enable_media_source(vfd);
>>       if (ret)
>>           return ret;
>> -    return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
>> +
>> +    if (vfd->device_caps & V4L2_CAP_IO_MC)
>> +        return v4l2_ioctl_s_input_mc(file, fh, *(unsigned int *)arg);
>> +    else
>> +        return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
>>   }
>>     static int v4l_s_output(const struct v4l2_ioctl_ops *ops,
>>                   struct file *file, void *fh, void *arg)
>>   {
>> -    return ops->vidioc_s_output(file, fh, *(unsigned int *)arg);
>> +    struct video_device *vfd = video_devdata(file);
>> +
>> +    if (vfd->device_caps & V4L2_CAP_IO_MC)
>> +        return v4l2_ioctl_s_output_mc(file, fh, *(unsigned int *)arg);
>> +    else
>> +        return ops->vidioc_s_output(file, fh, *(unsigned int *)arg);
>>   }
>>     static int v4l_g_priority(const struct v4l2_ioctl_ops *ops,
>> @@ -1077,7 +1150,10 @@ static int v4l_enuminput(const struct
>> v4l2_ioctl_ops *ops,
>>       if (is_valid_ioctl(vfd, VIDIOC_S_STD))
>>           p->capabilities |= V4L2_IN_CAP_STD;
>>   -    return ops->vidioc_enum_input(file, fh, p);
>> +    if (vfd->device_caps & V4L2_CAP_IO_MC)
>> +        return v4l2_ioctl_enum_input_mc(file, fh, p);
>> +    else
>> +        return ops->vidioc_enum_input(file, fh, p);
>>   }
>>     static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
>> @@ -1095,7 +1171,10 @@ static int v4l_enumoutput(const struct
>> v4l2_ioctl_ops *ops,
>>       if (is_valid_ioctl(vfd, VIDIOC_S_STD))
>>           p->capabilities |= V4L2_OUT_CAP_STD;
>>   -    return ops->vidioc_enum_output(file, fh, p);
>> +    if (vfd->device_caps & V4L2_CAP_IO_MC)
>> +        return v4l2_ioctl_enum_output_mc(file, fh, p);
>> +    else
>> +        return ops->vidioc_enum_output(file, fh, p);
>>   }
>>     static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>> @@ -2534,11 +2613,11 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>>       IOCTL_INFO_STD(VIDIOC_S_AUDIO, vidioc_s_audio, v4l_print_audio,
>> INFO_FL_PRIO),
>>       IOCTL_INFO_FNC(VIDIOC_QUERYCTRL, v4l_queryctrl,
>> v4l_print_queryctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
>>       IOCTL_INFO_FNC(VIDIOC_QUERYMENU, v4l_querymenu,
>> v4l_print_querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu,
>> index)),
>> -    IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
>> +    IOCTL_INFO_FNC(VIDIOC_G_INPUT, v4l_g_input, v4l_print_u32, 0),
>>       IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32,
>> INFO_FL_PRIO),
>>       IOCTL_INFO_STD(VIDIOC_G_EDID, vidioc_g_edid, v4l_print_edid, 0),
>>       IOCTL_INFO_STD(VIDIOC_S_EDID, vidioc_s_edid, v4l_print_edid,
>> INFO_FL_PRIO),
>> -    IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
>> +    IOCTL_INFO_FNC(VIDIOC_G_OUTPUT, v4l_g_output, v4l_print_u32, 0),
>>       IOCTL_INFO_FNC(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32,
>> INFO_FL_PRIO),
>>       IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput,
>> v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
>>       IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout,
>> v4l_print_audioout, 0),
>> diff --git a/include/uapi/linux/videodev2.h
>> b/include/uapi/linux/videodev2.h
>> index 2b8feb8..94cb196 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -460,6 +460,8 @@ struct v4l2_capability {
>>     #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch
>> device */
>>   +#define V4L2_CAP_IO_MC            0x20000000  /* Is input/output
>> controlled by the media controler */
>
> controler -> controller
>
>> +
>>   #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device
>> capabilities field */
>>     /*
>>
>
> Regards,
>
>     Hans

Thanks,
Helen
