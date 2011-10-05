Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43608 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934801Ab1JEWa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 18:30:28 -0400
Received: by ggnv2 with SMTP id v2so1163130ggn.19
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 15:30:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8CD0C6.7000500@infradead.org>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <4E8A9A2F.3080407@infradead.org> <201110040903.59755.hverkuil@xs4all.nl>
 <201110052254.51990.laurent.pinchart@ideasonboard.com> <4E8CD0C6.7000500@infradead.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 6 Oct 2011 00:30:07 +0200
Message-ID: <CAAwP0s0P1eEgWOi=d=bYbmRBs061y_FvYiShXTCocrn-Gkrd+A@mail.gmail.com>
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

On Wed, Oct 5, 2011 at 11:48 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em 05-10-2011 17:54, Laurent Pinchart escreveu:
>>
>> Hi Hans,
>>
>> On Tuesday 04 October 2011 09:03:59 Hans Verkuil wrote:
>>>
>>> On Tuesday, October 04, 2011 07:31:27 Mauro Carvalho Chehab wrote:
>>>>
>>>> Em 03-10-2011 19:37, Javier Martinez Canillas escreveu:
>>>>>
>>>>> On Mon, Oct 3, 2011 at 11:56 PM, Mauro Carvalho Chehab wrote:
>>>>>>
>>>>>> Em 03-10-2011 18:44, Laurent Pinchart escreveu:
>>>>>>>
>>>>>>> On Monday 03 October 2011 21:16:45 Mauro Carvalho Chehab wrote:
>>>>>>>>
>>>>>>>> Em 03-10-2011 08:53, Laurent Pinchart escreveu:
>>>>>>>>>
>>>>>>>>> On Monday 03 October 2011 11:53:44 Javier Martinez Canillas wrote:
>>>>>>>>>
>>>>>>>>> [snip]
>>>>>>>>>
>>>>>>>>>> Laurent, I have a few questions about MCF and the OMAP3ISP driver
>>>>>>>>>> if you are so kind to answer.
>>>>>>>>>>
>>>>>>>>>> 1- User-space programs that are not MCF aware negotiate the format
>>>>>>>>>> with the V4L2 device (i.e: OMAP3 ISP CCDC output), which is a sink
>>>>>>>>>> pad. But the real format is driven by the analog video format in
>>>>>>>>>> the source pad (i.e: tvp5151).
>>>>>>>>>
>>>>>>>>> That's not different from existing systems using digital sensors,
>>>>>>>>> where the format is driven by the sensor.
>>>>>>>>>
>>>>>>>>>> I modified the ISP driver to get the data format from the source
>>>>>>>>>> pad and set the format for each pad on the pipeline accordingly
>>>>>>>>>> but I've read from the documentation [1] that is not correct to
>>>>>>>>>> propagate a data format from source pads to sink pads, that the
>>>>>>>>>> correct thing is to do it from sink to source.
>>>>>>>>>>
>>>>>>>>>> So, in this case an administrator has to externally configure the
>>>>>>>>>> format for each pad and to guarantee a coherent format on the
>>>>>>>>>> whole pipeline?.
>>>>>>>>>
>>>>>>>>> That's correct (except you don't need to be an administrator to do
>>>>>>>>> so
>>>>>>>>>
>>>>>>>>> :-)).
>>>>>>>>
>>>>>>>> NACK.
>>>>>>>
>>>>>>> Double NACK :-D
>>>>>>>
>>>>>>>> When userspace sends a VIDIOC_S_STD ioctl to the sink node, the
>>>>>>>> subdevs that are handling the video/audio standard should be
>>>>>>>> changed, in order to obey the V4L2 ioctl. This is what happens with
>>>>>>>> all other drivers since the beginning of the V4L1 API. There's no
>>>>>>>> reason to change it, and such change would be a regression.
>>>>>>>
>>>>>>> The same could have been told for the format API:
>>>>>>>
>>>>>>> "When userspace sends a VIDIOC_S_FMT ioctl to the sink node, the
>>>>>>> subdevs that are handling the video format should be changed, in
>>>>>>> order to obey the V4L2 ioctl. This is what happens with all other
>>>>>>> drivers since the beginning of the V4L1 API. There's no reason to
>>>>>>> change it, and such change would be a regression."
>>>>>>>
>>>>>>> But we've introduced a pad-level format API. I don't see any reason
>>>>>>> to treat standard differently.
>>>>>>
>>>>>> Neither do I. The pad-level API should not replace the V4L2 API for
>>>>>> standard, for controls and/or for format settings.
>>>
>>> Remember we are talking about the subdev driver here. It makes no sense
>>> to
>>> have both a s_mbus_fmt video op and a set_fmt pad op, which both do the
>>> same thing. Bridge drivers should be adapted to use set_fmt only, so we
>>> can drop s_mbus_fmt.
>>>
>>> BTW, the names 'set_fmt' and 'get_fmt' are very confusing to me. I always
>>> think these refer to v4l2_format. Can we please rename this to
>>> g/s_mbus_fmt?
>>
>> Shouldn't we do it the other way around, renaming the g/s_mbus_fmt video
>> operations to g/s_fmt, now that we only have mbus formats left ? The
>> operation
>> names would be shorter.
>>
>>> And set/get_crop to s/g_crop? This for consistent naming.
>>
>> set/get_crop will be replaced with set/get_selection (or s/g_selection if
>> you
>> like that better :-)).
>>
>>> When it comes to S_STD I don't see the need for a pad version of this. It
>>> is an op that is used to configure subdevs to handle a specific standard.
>>> If you are configuring the pipelines manually, then after calling S_STD
>>> you have to set up the mbus formats yourself.
>>>
>>> Of course, I can generate scenarios where you would need to set the
>>> standard through the subdev node (i.e. two video receivers connected to a
>>> SoC, one receiving PAL, the other receiving NTSC, and both streams
>>> composed into a single new stream that's DMA-ed to memory), but frankly,
>>> those scenarios are very contrived :-)
>>
>> Unless I don't understand this correctly, I think those two paragraphs are
>> not
>> related.
>>
>> Regarding the pad-level standard operations, you're probably right.
>> Subdevs
>> that can handle two or more analog streams at the same time would need
>> that,
>> but we probably won't need to support them any time soon (if ever). So we
>> could keep the subdev-level standard operations, with the implicit (or
>> explicit) rule that they apply to the currently selected input of the
>> subdev
>> (I suppose TV decoders with an input mux are not uncommon).
>
> Switching from one input to the other doesn't switch the TV format (except,
> of course, if autodetection is enabled). The driver should keep the last
> settings
> to the new input for resolution, format, fourcc and image controls.
>
>> Regarding controlling standards directly on subdevs, I think that's the
>> way to
>> go for complex pipelines, but that doesn't require pad-level standard
>> operations.
>>
>>> The preset ioctls would be more realistic since I know that a scenario
>>> like
>>> the one above does exist for e.g. HDMI inputs, where each can receive a
>>> different format.
>>>
>>> In that case the preset ioctls would have to be exposed to the subdev
>>> nodes, allowing you to set it up for each HDMI receiver independently.
>>> But
>>> you still do not need pads to do this since this is a subdev-level
>>> operation, not pad-level.
>>>
>>>>>>>>>> Or does exist a way to do this automatic?. i.e: The output entity
>>>>>>>>>> on the pipeline promotes the capabilities of the source pad so
>>>>>>>>>> applications can select a data format and this format gets
>>>>>>>>>> propagated all over the pipeline from the sink pad to the source?
>>>>>>>>>
>>>>>>>>> It can be automated in userspace (through a libv4l plugin for
>>>>>>>>> instance), but it's really not the kernel's job to do so.
>>>>>>>>
>>>>>>>> It is a kernel job to handle VIDIOC_S_STD, and not a task to be left
>>>>>>>> to any userspace plugin.
>>>>>>>
>>>>>>> And VIDIOC_S_FMT is handled by userspace for the OMAP3 ISP today. Why
>>>>>>> are standards different ?
>>>>>>
>>>>>> All v4l media devices have sub-devices with either tv decoders or
>>>>>> sensors connected into a sink. The sink implements the /dev/video?
>>>>>> node.
>>>>>> When an ioctl is sent to the v4l node, the sensors/decoders are
>>>>>> controlled to implement whatever is requested: video standards,
>>>>>> formats etc.
>>>>>>
>>>>>> Changing it would be a major regression. If OMAP3 is not doing the
>>>>>> right thing, it should be fixed, and not the opposite.
>>>>>
>>>>> That is the approach we took, we hack the isp v4l2 device driver
>>>>> (ispvideo) to bypass the ioctls to the sub-device that as the source
>>>>> pad (tvp5151 in our case, but it could be a sensor as well). So, for
>>>>> example the VIDIOC_S_STD ioctl handler looks like this (I post a
>>>>> simplified version of the code, just to give an idea):
>>>>>
>>>>> static int isp_video_s_std(struct file *file, void *fh, v4l2_std_id
>>>>> *norm) {
>>>>>
>>>>>     struct isp_video *video = video_drvdata(file);
>>>>>     struct v4l2_subdev *sink_subdev;
>>>>>     struct v4l2_subdev *source_subdev;
>>>>>
>>>>>     sink_subdev = isp_video_remote_subdev(video, NULL);
>>>>>     sink_pad =&sink_subdev->entity.pads[0];
>>>>>     source_pad = media_entity_remote_source(sink_pad);
>>>>>     source_subdev = media_entity_to_v4l2_subdev(source_pad->entity);
>>>>>     v4l2_subdev_call(source_subdev, core, s_std, NULL, norm);
>>>>>
>>>>> }
>>>>>
>>>>> So applications interact with the /dev/video? via V4L2 ioctls whose
>>>>> handlers call the sub-dev functions. Is that what you propose?
>>>>
>>>> Something like that. For example:
>>>>
>>>> static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id
>>>> *norm)
>>>> {
>>>>
>>>>        /* Do some sanity test/resolution adjustments, etc */
>>>>
>>>>        v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
>>>>
>>>>        return 0;
>>>>
>>>> }
>>>>
>>>> It should be noticed that:
>>>>
>>>> 1) a full standard auto-detection is only possible at the V4L2 level, as
>>>> a standard is a composition of audio and video carriers. I intend to
>>>> work tomorrow to add audio auto-detection to pvrusb2;
>>>>
>>>> 2) a full s_std should not only adjust the TV demod pad, but also, the
>>>> audio pad and the tuner pad (if the analog input comes from a tuner).
>>>>
>>>>>> The MC/subdev API is there to fill the blanks, e. g. to handle cases
>>>>>> where the same function could be implemented on two different places
>>>>>> of the pipeline, e. g. when both the sensor and the bridge could do
>>>>>> scaling, and userspace wants to explicitly use one, or the other, but
>>>>>> it were never meant to replace the V4L2 functionality.
>>>>>>
>>>>>>>>>> [1]: http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
>>>>>>>>>>
>>>>>>>>>> 2- If the application want a different format that the default
>>>>>>>>>> provided by the tvp5151, (i.e: 720x576 for PAL), where do I have
>>>>>>>>>> to crop the image? I thought this can be made using the CCDC,
>>>>>>>>>> copying less lines to memory or the RESIZER if the application
>>>>>>>>>> wants a bigger image. What is the best approach for this?
>>>>>>>>
>>>>>>>> Not sure if I understood your question, but maybe you're mixing two
>>>>>>>> different concepts here.
>>>>>>>>
>>>>>>>> If the application wants a different image resolution, it will use
>>>>>>>> S_FMT. In this case, what userspace expects is that the driver will
>>>>>>>> scale, if supported, or return -EINVAL otherwise.
>>>>>>>
>>>>>>> With the OMAP3 ISP, which is I believe what Javier was asking about,
>>>>>>> the application will set the format on the OMAP3 ISP resizer input
>>>>>>> and output pads to configure scaling.
>>>>>
>>>>> Yes, that was my question about. But still is not clear to me if
>>>>> configuring the ISP resizer input and output pads with different frame
>>>>> sizes automatically means that I have to do the scale or this has to
>>>>> be configured using a S_FMT ioctl to the /dev/video? node.
>>>>>
>>>>> Basically what I don't know is when I have to modify the pipeline
>>>>> graph inside the ISP driver and when this has to be made from
>>>>> user-space via MCF.
>>>>
>>>> In the specific case of analog inputs, In general, better results are
>>>> obtained if the scaling is done at the analog demod, as it can play with
>>>> the pixel sampling rate, and obtaining a better result than a decimation
>>>> filter. Not all demods accept this through.
>>>>
>>>> Anyway, S_FMT is expected to work at the /dev/video? node. Laurent will
>>>> likely argument against, but, again, allowing to control the scaling on
>>>> a different place is a bonus of the MC/subdev API, but it should never
>>>> replace the S_FMT V4L2 call.
>>>
>>> I agree with Mauro, up to a point. One way or another drivers should
>>> support S_FMT through the video nodes.
>>
>> When there's a one-to-one relationship between the video device (in the
>> hardware sense) and the video node, that's pretty normal. However, when a
>> video device is made of a complex pipeline and several video nodes, the
>> problem becomes much more complex and mapping a "simple" operations such
>> as
>> S_FMT to hardware configuration becomes a policy decision.
>
> One video node should "master" the operation. A V4L2 application will open
> just
> one device to control the stuff (as a general rule, I'd say that it will
> open
> the sink node). A V4L2 ioctl applied into it should be propagated along the
> pipeline for the ioctl to happen. This is what happens with all other
> devices,
> and this is what a V4L2 userspace application expects.
>

What about a hybrid solution? We can set the links from user-space and
kernel-space.

If the application wants to change the current format (S_FMT) the
driver can modify the graph and change the pipeline to include the
resizer or any other entity that can offer the service asked by the
application.

Or in the other hand the user setting the pipeline decides what
capabilities the video device support. If the user doesn't include the
resizer for example then an ioctl call S_FMT to the sink node will
return -ENOIOCTLCMD or -EINVAL.

But then we will need a way to associate V4L2 ioctl actions with media
entities or pads, to know if someone in the pipeline (or someone not
in the pipeline but registered as a sub-device) can provide the
service that the application needs.

>>> But if someone starts programming the pipeline through subdev nodes, then
>>> I
>>> think it is reasonable that trying to call S_FMT would return EBUSY or
>>> something similar.
>>>
>>> It has been suggested that S_FMT can be implemented for such systems as a
>>> libv4l2 plugin, but I would like to see code doing this first as I am not
>>> convinced that that's the best way to do it.
>>
>> Sakari, what's the status of the OMAP3 ISP libv4l plugin ?
>>
>
>



-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
