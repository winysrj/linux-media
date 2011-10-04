Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62273 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1JDHeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2011 03:34:22 -0400
Received: by gyg10 with SMTP id 10so185649gyg.19
        for <linux-media@vger.kernel.org>; Tue, 04 Oct 2011 00:34:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8A9A2F.3080407@infradead.org>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <201110031353.29910.laurent.pinchart@ideasonboard.com> <4E8A0A1D.8060501@infradead.org>
 <201110032344.08963.laurent.pinchart@ideasonboard.com> <4E8A2F76.4020209@infradead.org>
 <CAAwP0s30_FxMu3iegkusk7iQkBaWKmmba7sOk2vK9tcahV3ueg@mail.gmail.com> <4E8A9A2F.3080407@infradead.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Tue, 4 Oct 2011 09:34:02 +0200
Message-ID: <CAAwP0s0sC7n+dwsYngyvd=u1-WqDB_=4ytu7KtPtBQ14rS-jng@mail.gmail.com>
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

On Tue, Oct 4, 2011 at 7:31 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>
> For now, I propose you to just add/improve the auto-detection on the
> existing callbacks. We need to reach a consensus before working at the pad level.
>

Ok, I'll do that using saa7115 driver as a reference as you suggested.

>> On Mon, Oct 3, 2011 at 11:56 PM, Mauro Carvalho Chehab
>> <mchehab@infradead.org> wrote:
>>> Em 03-10-2011 18:44, Laurent Pinchart escreveu:
>>>>>> It can be automated in userspace (through a libv4l plugin for instance),
>>>>>> but it's really not the kernel's job to do so.
>>>>>
>>>>> It is a kernel job to handle VIDIOC_S_STD, and not a task to be left to any
>>>>> userspace plugin.
>>>>
>>>> And VIDIOC_S_FMT is handled by userspace for the OMAP3 ISP today. Why are
>>>> standards different ?
>>>
>>> All v4l media devices have sub-devices with either tv decoders or sensors connected
>>> into a sink. The sink implements the /dev/video? node.
>>> When an ioctl is sent to the v4l node, the sensors/decoders are controlled
>>> to implement whatever is requested: video standards, formats etc.
>>>
>>> Changing it would be a major regression. If OMAP3 is not doing the right thing,
>>> it should be fixed, and not the opposite.
>>>
>>
>> That is the approach we took, we hack the isp v4l2 device driver
>> (ispvideo) to bypass the ioctls to the sub-device that as the source
>> pad (tvp5151 in our case, but it could be a sensor as well). So, for
>> example the VIDIOC_S_STD ioctl handler looks like this (I post a
>> simplified version of the code, just to give an idea):
>>
>> static int isp_video_s_std(struct file *file, void *fh, v4l2_std_id *norm)
>> {
>>     struct isp_video *video = video_drvdata(file);
>>     struct v4l2_subdev *sink_subdev;
>>     struct v4l2_subdev *source_subdev;
>>
>>     sink_subdev = isp_video_remote_subdev(video, NULL);
>>     sink_pad = &sink_subdev->entity.pads[0];
>>     source_pad = media_entity_remote_source(sink_pad);
>>     source_subdev = media_entity_to_v4l2_subdev(source_pad->entity);
>>     v4l2_subdev_call(source_subdev, core, s_std, NULL, norm);
>> }
>>
>> So applications interact with the /dev/video? via V4L2 ioctls whose
>> handlers call the sub-dev functions. Is that what you propose?
>
> Something like that. For example:
>
> static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
> {
>        /* Do some sanity test/resolution adjustments, etc */
>
>        v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
>
>        return 0;
> }
>
> It should be noticed that:
>
> 1) a full standard auto-detection is only possible at the V4L2 level, as a
> standard is a composition of audio and video carriers. I intend to work tomorrow
> to add audio auto-detection to pvrusb2;
>
> 2) a full s_std should not only adjust the TV demod pad, but also, the audio pad
> and the tuner pad (if the analog input comes from a tuner).
>

Ok, got it. Thanks.

>>> The MC/subdev API is there to fill the blanks, e. g. to handle cases where the
>>> same function could be implemented on two different places of the pipeline, e. g.
>>> when both the sensor and the bridge could do scaling, and userspace wants to
>>> explicitly use one, or the other, but it were never meant to replace the V4L2
>>> functionality.
>>>
>>>>
>>>> With the OMAP3 ISP, which is I believe what Javier was asking about, the
>>>> application will set the format on the OMAP3 ISP resizer input and output pads
>>>> to configure scaling.
>>>
>>
>> Yes, that was my question about. But still is not clear to me if
>> configuring the ISP resizer input and output pads with different frame
>> sizes automatically means that I have to do the scale or this has to
>> be configured using a S_FMT ioctl to the /dev/video? node.
>>
>> Basically what I don't know is when I have to modify the pipeline
>> graph inside the ISP driver and when this has to be made from
>> user-space via MCF.
>
> In the specific case of analog inputs, In general, better results are obtained
> if the scaling is done at the analog demod, as it can play with the pixel
> sampling rate, and obtaining a better result than a decimation filter. Not
> all demods accept this through.
>
> Anyway, S_FMT is expected to work at the /dev/video? node. Laurent will likely
> argument against, but, again, allowing to control the scaling on a different
> place is a bonus of the MC/subdev API, but it should never replace the S_FMT
> V4L2 call.
>
>>> The V4L2 API doesn't tell where a function like scaler will be implemented.
>>> So, it is fine to implement it at tvp5151 or at the omap3 resizer, when a
>>> V4L2 call is sent.
>>>
>>
>> I don't think I can do the cropping and scaling in the tvp5151 driver
>> since this is a dumb device, it only spits bytes via its parallel
>> interface. The actual buffer is inside the ISP.
>
> I wrote the tvp5150 driver from scratch a long time ago. Can't remember all
> details anymore. As far as I can remember, I don't think it has scaling. Also,
> its sampler seems to use a fixed pixel clock rate.
>
> It does support crop by adjusting the blank registers. Probably there's a
> limit to the range that cropping can be done, but, in general, it should be enough
> to remove the black lines from the borders (and the teletext/cc info).
>
> I can't think on any advantage of doing cropping at tvp5150. So, you can just
> implement it where you're more comfortable with.
>
> Regards,
> Mauro
>

Once everyone agree on how G/S_FMT, G/S_STD, etc selection has to be
made and in which level (V4L2 device node, sub-dev, pad, etc) I want
to fix everything that has to be fix on the ISP driver, we don't have
the resources nor the will to maintain an ISP driver fork as an
out-of-tree project :)

Also, I volunteer to do any cleanup/modification/migration that
existing V4L2 drivers will require, as I told you before I'm a newbie
both on V4L2 and MCF but I have some free slots that I can dedicate to
this.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
