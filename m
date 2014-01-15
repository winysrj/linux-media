Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2751 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaAOLqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 06:46:04 -0500
Message-ID: <52D6744F.9060502@xs4all.nl>
Date: Wed, 15 Jan 2014 12:43:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jianle Wang <victure86@gmail.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: how can I get compat_ioctl support for v4l2_subdev_fops
References: <CACDDY7429te6a7cUQ0Z=sX6TELjn48FQHiuW=YtBsyOkzrCqZA@mail.gmail.com> <52D63B23.5000505@xs4all.nl> <CACDDY76oeFxv7P_yBQeVosae4sRrMCyveRzUHUXewB2Xn3d-jw@mail.gmail.com> <52D6579F.9080302@xs4all.nl> <CACDDY75x94C=8d8t4mo3eoZeFnreZDiNuCvBgg8qjZ842FNNNw@mail.gmail.com>
In-Reply-To: <CACDDY75x94C=8d8t4mo3eoZeFnreZDiNuCvBgg8qjZ842FNNNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/14 12:36, Jianle Wang wrote:
> Hi Hans:
>     Thanks for your help. It can work at my side.
> 
> BTW: There is a warning during compiling
> drivers/media/v4l2-core/v4l2-subdev.c: In function 'subdev_compat_ioctl32':
> drivers/media/v4l2-core/v4l2-subdev.c:379:2: warning: passing argument
> 3 of 'sd->ops->core->compat_ioctl32' makes pointer from integer
> without a cast [enabled by default]
> drivers/media/v4l2-core/v4l2-subdev.c:379:2: note: expected 'void *'
> but argument is of type 'long unsigned int'

Just replace this:

	return v4l2_subdev_call(sd, core, compat_ioctl32, cmd, arg);

by:

	return v4l2_subdev_call(sd, core, compat_ioctl32, cmd, (void *)arg);

Alternatively, change the type of arg to unsigned long in v4l2-subdev.h.
I'm not sure what is easier.

Regards,

	Hans

> 
> 2014/1/15 Hans Verkuil <hverkuil@xs4all.nl>:
>> On 01/15/14 09:02, Jianle Wang wrote:
>>> Hi Hans:
>>>     Thanks for your patch.
>>> How do we handle the private ioctl defined in struct v4l2_subdev_core.ioctl?
>>> These ioctls are also not supported for compat_ioctl.
>>
>> There is currently no support for that, but try the patch below. That should
>> allow you to add compat_ioctl32 support for your custom ioctls.
>>
>> Regards,
>>
>>         Hans
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index 996c248..60d2550 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -368,6 +368,17 @@ static long subdev_ioctl(struct file *file, unsigned int cmd,
>>         return video_usercopy(file, cmd, arg, subdev_do_ioctl);
>>  }
>>
>> +#ifdef CONFIG_COMPAT
>> +static long subdev_compat_ioctl32(struct file *file, unsigned int cmd,
>> +       unsigned long arg)
>> +{
>> +       struct video_device *vdev = video_devdata(file);
>> +       struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
>> +
>> +       return v4l2_subdev_call(sd, core, compat_ioctl32, cmd, arg);
>> +}
>> +#endif
>> +
>>  static unsigned int subdev_poll(struct file *file, poll_table *wait)
>>  {
>>         struct video_device *vdev = video_devdata(file);
>> @@ -389,6 +400,9 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
>>         .owner = THIS_MODULE,
>>         .open = subdev_open,
>>         .unlocked_ioctl = subdev_ioctl,
>> +#ifdef CONFIG_COMPAT
>> +       .compat_ioctl32 = subdev_compat_ioctl32,
>> +#endif
>>         .release = subdev_close,
>>         .poll = subdev_poll,
>>  };
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index d67210a..3fd91a5 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -162,6 +162,9 @@ struct v4l2_subdev_core_ops {
>>         int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
>>         int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
>>         long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
>> +#ifdef CONFIG_COMPAT
>> +       long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
>> +#endif
>>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>>         int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
>>         int (*s_register)(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg);
>>

