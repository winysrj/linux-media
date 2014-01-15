Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:37602 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaAOICW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 03:02:22 -0500
Received: by mail-lb0-f169.google.com with SMTP id q8so516610lbi.0
        for <linux-media@vger.kernel.org>; Wed, 15 Jan 2014 00:02:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52D63B23.5000505@xs4all.nl>
References: <CACDDY7429te6a7cUQ0Z=sX6TELjn48FQHiuW=YtBsyOkzrCqZA@mail.gmail.com>
	<52D63B23.5000505@xs4all.nl>
Date: Wed, 15 Jan 2014 16:02:20 +0800
Message-ID: <CACDDY76oeFxv7P_yBQeVosae4sRrMCyveRzUHUXewB2Xn3d-jw@mail.gmail.com>
Subject: Re: how can I get compat_ioctl support for v4l2_subdev_fops
From: Jianle Wang <victure86@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans:
    Thanks for your patch.
How do we handle the private ioctl defined in struct v4l2_subdev_core.ioctl?
These ioctls are also not supported for compat_ioctl.

2014/1/15 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Jianle,
>
> On 01/15/2014 07:28 AM, Jianle Wang wrote:
>> Hi all, :
>> I use the media-ctl from http://git.ideasonboard.org/media-ctl.git
>> It is compiled into a 32 bit application. Run on a 64 bit CPU. The
>> version of kernel is 3.10.
>>
>> When call ioctl(, VIDIOC_SUBDEV_S_SELECTION,), meet the below warning:
>> [   97.186338] c0 707 (drv_test) compat_ioctl32: unknown ioctl 'V',
>> dir=3, #62 (0xc040563e)
>> [   97.203252] c0 707 (drv_test) WARNING: no compat_ioctl for v4l-subdev1
>>
>> VIDIOC_SUBDEV_S_SELECTION is not supported for compat_iocl. And I list
>> others subdev�s ioctl, which are also not included
>>
>> in v4l2_compat_iocl32().
>> How can I get these compat_ioctl?
>> Have they been added in v4l2_compat_iocl32() or We have added a
>> compat_ioctl32 in v4l2_subdev_fops?
>
> It's a bug, I'm afraid. A lot of the SUBDEV ioctls are missing in v4l2_compat_ioctl32.
> Try the patch below, that should fix it.
>
> Regards,
>
>         Hans
>
>>
>> VIDIOC_SUBDEV_G_FMT
>> VIDIOC_SUBDEV_S_FMT
>> VIDIOC_SUBDEV_G_CROP
>> VIDIOC_SUBDEV_S_CROP
>> VIDIOC_SUBDEV_ENUM_MBUS_CODE
>> VIDIOC_SUBDEV_ENUM_FRAME_SIZE
>> VIDIOC_SUBDEV_G_FRAME_INTERVAL
>> VIDIOC_SUBDEV_S_FRAME_INTERVAL
>> VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
>> VIDIOC_SUBDEV_G_SELECTION
>> VIDIOC_SUBDEV_S_SELECTION
>> default
>> v4l2_subdev_call(sd, core, ioctl, cmd, arg);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 8f7a6a4..15d3586 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -1007,6 +1007,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>                 return ret;
>
>         switch (cmd) {
> +       /* V4L2 ioctls */
>         case VIDIOC_QUERYCAP:
>         case VIDIOC_RESERVED:
>         case VIDIOC_ENUM_FMT:
> @@ -1087,8 +1088,21 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>         case VIDIOC_QUERY_DV_TIMINGS:
>         case VIDIOC_DV_TIMINGS_CAP:
>         case VIDIOC_ENUM_FREQ_BANDS:
> +
> +       /* V4L2 subdev ioctls */
>         case VIDIOC_SUBDEV_G_EDID32:
>         case VIDIOC_SUBDEV_S_EDID32:
> +       case VIDIOC_SUBDEV_G_FMT:
> +       case VIDIOC_SUBDEV_S_FMT:
> +       case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
> +       case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
> +       case VIDIOC_SUBDEV_ENUM_MBUS_CODE:
> +       case VIDIOC_SUBDEV_ENUM_FRAME_SIZE:
> +       case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL:
> +       case VIDIOC_SUBDEV_G_CROP:
> +       case VIDIOC_SUBDEV_S_CROP:
> +       case VIDIOC_SUBDEV_G_SELECTION:
> +       case VIDIOC_SUBDEV_S_SELECTION:
>                 ret = do_video_ioctl(file, cmd, arg);
>                 break;
>
>
