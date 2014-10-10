Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29261 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaJJPKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 11:10:41 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND8005C9IAG6270@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Oct 2014 16:13:28 +0100 (BST)
Message-id: <5437F6ED.4060800@samsung.com>
Date: Fri, 10 Oct 2014 17:10:37 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/1] Add a libv4l plugin for Exynos4 camera
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
 <1412757980-23570-2-git-send-email-j.anaszewski@samsung.com>
 <54379EB1.7010201@xs4all.nl>
In-reply-to: <54379EB1.7010201@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 10/10/2014 10:54 AM, Hans Verkuil wrote:
> Hi Jacek,
>
> I didn't do an in-depth review, but one thing caught my eye:
>
> On 10/08/2014 10:46 AM, Jacek Anaszewski wrote:
>> The plugin provides support for the media device on Exynos4 SoC.
>> Added is also a media device configuration file parser.
>> The media configuration file is used for conveying information
>> about media device links that need to be established as well
>> as V4L2 user control ioctls redirection to a particular
>> sub-device.
>>
>> The plugin performs single plane <-> multi plane API conversion,
>> video pipeline linking and takes care of automatic data format
>> negotiation for the whole pipeline, after intercepting
>> VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   configure.ac                                       |    1 +
>>   lib/Makefile.am                                    |    5 +-
>>   lib/libv4l-exynos4-camera/Makefile.am              |    7 +
>>   .../libv4l-devconfig-parser.h                      |  145 ++
>>   lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c  | 2486
>> ++++++++++++++++++++
>>   5 files changed, 2642 insertions(+), 2 deletions(-)
>>   create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
>>   create mode 100644 lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
>>   create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
>>
>
> <snip>
>
>> +static int is_control_supported(struct media_device *mdev,
>> +            struct libv4l_media_ctrl_conf *ctrl_cfg)
>> +{
>> +    struct v4l2_query_ext_ctrl queryctrl;
>> +    struct media_entity *entity;
>> +
>> +    entity = get_entity_by_name(mdev, ctrl_cfg->entity_name);
>> +    if (entity == NULL)
>> +        return 0;
>> +
>> +    /* Iterate through control ids */
>> +
>> +    queryctrl.id = V4L2_CID_BASE | V4L2_CTRL_FLAG_NEXT_CTRL;
>> +
>> +    while (!SYS_IOCTL(entity->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl)) {
>> +        if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)
>> +            continue;
>> +
>> +        if (!strcmp((char *) queryctrl.name, ctrl_cfg->control_name)) {
>> +            ctrl_cfg->cid = queryctrl.id &
>> +                    ~V4L2_CTRL_FLAG_NEXT_CTRL;
>> +            ctrl_cfg->entity = entity;
>> +
>> +            return 1;
>> +        }
>> +
>> +        queryctrl.id = queryctrl.id | V4L2_CTRL_FLAG_NEXT_CTRL;
>> +    }
>> +
>> +    queryctrl.id = V4L2_CID_BASE | V4L2_CTRL_FLAG_NEXT_COMPOUND;
>
> Why not combine V4L2_CTRL_FLAG_NEXT_CTRL and V4L2_CTRL_FLAG_NEXT_COMPOUND?
> That way you iterate over both 'normal' and compound controls. But do you
> really want to look at compound controls? First of all, to my knowledge
> the exynos driver doesn't use them and secondly compound controls typically
> do not have simple values that can easily be parsed.

I messed up few things here. I will remove checking for compound
controls

[...]

>> +static int querycap_ioctl(struct exynos4_camera_plugin *plugin,
>> +              struct v4l2_capability *arg)
>> +{
>> +    int ret;
>> +
>> +    ret = SYS_IOCTL(plugin->vid_fd, VIDIOC_QUERYCAP, arg);
>> +
>> +    if (arg->capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
>> +        arg->capabilities |= V4L2_CAP_VIDEO_CAPTURE;
>
> Check device_caps instead of capabilities. That way you can check
> what this specific device supports. I hope that the exynos driver
> sets device_caps. If not, that should be added.
>
> If you want to make this generic you could do:
>
>      __u32 caps = arg->capabilities;
>
>      if (caps & V4L2_CAP_DEVICE_CAPS)
>          caps = arg->device_caps;

Thanks, I'll conform to this.


>> +static int plugin_ioctl(void *dev_ops_priv, int fd, unsigned long int
>> cmd,
>> +                            void *arg)
>> +{
>> +    struct exynos4_camera_plugin *plugin = dev_ops_priv;
>> +
>> +    if (plugin == NULL || arg == NULL)
>> +        return -EINVAL;
>> +
>> +    switch (cmd) {
>> +    case VIDIOC_S_CTRL:
>> +    case VIDIOC_G_CTRL:
>> +        return ctrl_ioctl(plugin, VIDIOC_S_CTRL, arg);
>
> Support for VIDIOC_S/G/TRY_EXT_CTRLS should be added.

I'll cover it.

>> +    case VIDIOC_TRY_FMT:
>> +        return set_fmt_ioctl(plugin, VIDIOC_S_FMT, arg,
>> +                     V4L2_SUBDEV_FORMAT_TRY);
>> +    case VIDIOC_S_FMT:
>> +        return set_fmt_ioctl(plugin, VIDIOC_S_FMT, arg,
>> +                     V4L2_SUBDEV_FORMAT_ACTIVE);
>> +    case VIDIOC_G_FMT:
>> +        return get_fmt_ioctl(plugin, VIDIOC_G_FMT, arg);
>> +    case VIDIOC_ENUM_FMT:
>> +        return enum_fmt_ioctl(plugin, VIDIOC_ENUM_FMT, arg);
>> +    case VIDIOC_QUERYCAP:
>> +        return querycap_ioctl(plugin, arg);
>> +    case VIDIOC_QBUF:
>> +    case VIDIOC_DQBUF:
>> +    case VIDIOC_QUERYBUF:
>> +    case VIDIOC_PREPARE_BUF:
>> +        return buf_ioctl(plugin, cmd, arg);
>> +    case VIDIOC_REQBUFS:
>> +        return SIMPLE_CONVERT_IOCTL(fd, cmd, arg,
>> +                        v4l2_requestbuffers);
>> +    case VIDIOC_STREAMON:
>> +    case VIDIOC_STREAMOFF:
>> +        {
>> +            int *arg_type = (int *) arg;
>> +            int type;
>> +
>> +            type = convert_type(*arg_type);
>> +
>> +            if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
>> +                type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +                V4L2_EXYNOS4_ERR("Invalid buffer type.");
>> +                return -EINVAL;
>> +            }
>> +
>> +            return SYS_IOCTL(fd, cmd, &type);
>> +        }
>> +
>> +    default:
>> +        return SYS_IOCTL(fd, cmd, arg);
>> +    }
>> +}
>> +
>> +PLUGIN_PUBLIC const struct libv4l_dev_ops libv4l2_plugin = {
>> +    .init = &plugin_init,
>> +    .close = &plugin_close,
>> +    .ioctl = &plugin_ioctl,
>> +};
>>
>
> A lot of this looks like it is exynos independent. I would move such
> code to
> a separate source and make it easy to reuse elsewhere.

Yes, I was thinking about it, I'm planning to enclose this code
into SO library.

Best Regards,
Jacek Anaszewski
