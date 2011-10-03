Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34114 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab1JCWhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 18:37:47 -0400
Received: by yxl31 with SMTP id 31so3974153yxl.19
        for <linux-media@vger.kernel.org>; Mon, 03 Oct 2011 15:37:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8A2F76.4020209@infradead.org>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <201110031353.29910.laurent.pinchart@ideasonboard.com> <4E8A0A1D.8060501@infradead.org>
 <201110032344.08963.laurent.pinchart@ideasonboard.com> <4E8A2F76.4020209@infradead.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Tue, 4 Oct 2011 00:37:27 +0200
Message-ID: <CAAwP0s30_FxMu3iegkusk7iQkBaWKmmba7sOk2vK9tcahV3ueg@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Reading the last emails I understand that still isn't a consensus on
the way this has to be made. If it has to be implemented at the video
device node level or at the sub-device level. And if it has to be made
in kernel or user-space.

On Mon, Oct 3, 2011 at 11:56 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em 03-10-2011 18:44, Laurent Pinchart escreveu:
>> Hi Mauro,
>>
>> On Monday 03 October 2011 21:16:45 Mauro Carvalho Chehab wrote:
>>> Em 03-10-2011 08:53, Laurent Pinchart escreveu:
>>>> On Monday 03 October 2011 11:53:44 Javier Martinez Canillas wrote:
>>>>
>>>> [snip]
>>>>
>>>>> Laurent, I have a few questions about MCF and the OMAP3ISP driver if
>>>>> you are so kind to answer.
>>>>>
>>>>> 1- User-space programs that are not MCF aware negotiate the format
>>>>> with the V4L2 device (i.e: OMAP3 ISP CCDC output), which is a sink
>>>>> pad. But the real format is driven by the analog video format in the
>>>>> source pad (i.e: tvp5151).
>>>>
>>>> That's not different from existing systems using digital sensors, where
>>>> the format is driven by the sensor.
>>>>
>>>>> I modified the ISP driver to get the data format from the source pad
>>>>> and set the format for each pad on the pipeline accordingly but I've
>>>>> read from the documentation [1] that is not correct to propagate a
>>>>> data format from source pads to sink pads, that the correct thing is
>>>>> to do it from sink to source.
>>>>>
>>>>> So, in this case an administrator has to externally configure the
>>>>> format for each pad and to guarantee a coherent format on the whole
>>>>> pipeline?.
>>>>
>>>> That's correct (except you don't need to be an administrator to do so
>>>> :-)).
>>>
>>> NACK.
>>
>> Double NACK :-D
>>
>>> When userspace sends a VIDIOC_S_STD ioctl to the sink node, the subdevs
>>> that are handling the video/audio standard should be changed, in order to
>>> obey the V4L2 ioctl. This is what happens with all other drivers since the
>>> beginning of the V4L1 API. There's no reason to change it, and such change
>>> would be a regression.
>>
>> The same could have been told for the format API:
>>
>> "When userspace sends a VIDIOC_S_FMT ioctl to the sink node, the subdevs that
>> are handling the video format should be changed, in order to obey the V4L2
>> ioctl. This is what happens with all other drivers since the beginning of the
>> V4L1 API. There's no reason to change it, and such change would be a
>> regression."
>>
>> But we've introduced a pad-level format API. I don't see any reason to treat
>> standard differently.
>
> Neither do I. The pad-level API should not replace the V4L2 API for standard,
> for controls and/or for format settings.
>
>>>>> Or does exist a way to do this automatic?. i.e: The output entity on the
>>>>> pipeline promotes the capabilities of the source pad so applications can
>>>>> select a data format and this format gets propagated all over the
>>>>> pipeline from the sink pad to the source?
>>>>
>>>> It can be automated in userspace (through a libv4l plugin for instance),
>>>> but it's really not the kernel's job to do so.
>>>
>>> It is a kernel job to handle VIDIOC_S_STD, and not a task to be left to any
>>> userspace plugin.
>>
>> And VIDIOC_S_FMT is handled by userspace for the OMAP3 ISP today. Why are
>> standards different ?
>
> All v4l media devices have sub-devices with either tv decoders or sensors connected
> into a sink. The sink implements the /dev/video? node.
> When an ioctl is sent to the v4l node, the sensors/decoders are controlled
> to implement whatever is requested: video standards, formats etc.
>
> Changing it would be a major regression. If OMAP3 is not doing the right thing,
> it should be fixed, and not the opposite.
>

That is the approach we took, we hack the isp v4l2 device driver
(ispvideo) to bypass the ioctls to the sub-device that as the source
pad (tvp5151 in our case, but it could be a sensor as well). So, for
example the VIDIOC_S_STD ioctl handler looks like this (I post a
simplified version of the code, just to give an idea):

static int isp_video_s_std(struct file *file, void *fh, v4l2_std_id *norm)
{
    struct isp_video *video = video_drvdata(file);
    struct v4l2_subdev *sink_subdev;
    struct v4l2_subdev *source_subdev;

    sink_subdev = isp_video_remote_subdev(video, NULL);
    sink_pad = &sink_subdev->entity.pads[0];
    source_pad = media_entity_remote_source(sink_pad);
    source_subdev = media_entity_to_v4l2_subdev(source_pad->entity);
    v4l2_subdev_call(source_subdev, core, s_std, NULL, norm);
}

So applications interact with the /dev/video? via V4L2 ioctls whose
handlers call the sub-dev functions. Is that what you propose?

> The MC/subdev API is there to fill the blanks, e. g. to handle cases where the
> same function could be implemented on two different places of the pipeline, e. g.
> when both the sensor and the bridge could do scaling, and userspace wants to
> explicitly use one, or the other, but it were never meant to replace the V4L2
> functionality.
>
>>
>>>>> [1]: http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
>>>>>
>>>>> 2- If the application want a different format that the default
>>>>> provided by the tvp5151, (i.e: 720x576 for PAL), where do I have to
>>>>> crop the image? I thought this can be made using the CCDC, copying
>>>>> less lines to memory or the RESIZER if the application wants a bigger
>>>>> image. What is the best approach for this?
>>>
>>> Not sure if I understood your question, but maybe you're mixing two
>>> different concepts here.
>>>
>>> If the application wants a different image resolution, it will use S_FMT.
>>> In this case, what userspace expects is that the driver will scale,
>>> if supported, or return -EINVAL otherwise.
>>
>> With the OMAP3 ISP, which is I believe what Javier was asking about, the
>> application will set the format on the OMAP3 ISP resizer input and output pads
>> to configure scaling.
>

Yes, that was my question about. But still is not clear to me if
configuring the ISP resizer input and output pads with different frame
sizes automatically means that I have to do the scale or this has to
be configured using a S_FMT ioctl to the /dev/video? node.

Basically what I don't know is when I have to modify the pipeline
graph inside the ISP driver and when this has to be made from
user-space via MCF.

> The V4L2 API doesn't tell where a function like scaler will be implemented.
> So, it is fine to implement it at tvp5151 or at the omap3 resizer, when a
> V4L2 call is sent.
>

I don't think I can do the cropping and scaling in the tvp5151 driver
since this is a dumb device, it only spits bytes via its parallel
interface. The actual buffer is inside the ISP.

> Regards,
> Mauro
>

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
