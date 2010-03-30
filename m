Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0C3NOS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 09:14:18 -0400
Message-ID: <4BB1F920.7060705@redhat.com>
Date: Tue, 30 Mar 2010 10:14:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: "'Hans Verkuil'" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Pawel Osciak <p.osciak@samsung.com>, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC 0/1] v4l: Add support for binary controls
References: <1269856386-29557-1-git-send-email-k.debski@samsung.com> <201003300841.47978.hverkuil@xs4all.nl> <000001cad004$2a770450$7f650cf0$%debski@samsung.com>
In-Reply-To: <000001cad004$2a770450$7f650cf0$%debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kamil Debski wrote:
>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>>
>> Hi Kamil!
> 
> Hi Hans,
> 
>> On Monday 29 March 2010 11:53:05 Kamil Debski wrote:
>>> Hello,
>>>
>>> This patch introduces new type of v4l2 control - the binary control.
>> It
>>> will be useful for exchanging raw binary data between the user space
>> and
>>> the driver/hardware.
>>>
>>> The patch is pretty small – basically it adds a new control type.
>>>
>>> 1.  Reasons to include this new type
>>> - Some devices require data which are not part of the stream, but
>> there
>>> are necessary for the device to work e.g. coefficients for
>> transformation
>>> matrices.
>>> - String control is not suitable as it suggests that the data is a
>> null
>>> terminated string. This might be important when printing debug
>> information -
>>> one might output strings as they are and binary data in hex.
>>>
>>> 2. How does the binary control work
>>> The binary control has been based on the string control. The
>> principle of
>>> use is the same. It uses v4l2_ext_control structure to pass the
>> pointer and
>>> size of the data. It is left for the driver to call the
>> copy_from_user/
>>> copy_to_user function to copy the data.
>>>
>>> 3. About the patch
>>> The patch is pretty small – it basically adds a new control type.
>>>
>>> Best wishes,
>>>
>> I don't think this is a good idea. Controls are not really meant to be
>> used
>> as an ioctl replacement.
>>
>> Controls can be used to control the hardware via a GUI (e.g. qv4l2).
>> Obviously,
>> this will fail for binary controls. Controls can also be used in cases
>> where
>> it is not known up front which controls are needed. This typically
>> happens for
>> bridge drivers that can use numerous combinations of i2c sub-devices.
>> Each
>> subdev can have its own controls.
>>
>> There is a grey area where you want to give the application access to
>> low-level
>> parameters but without showing them to the end-user. This is currently
>> not
>> possible, but it will be once the control framework is finished and
>> once we
>> have the possibility to create device nodes for subdevs.
>>
>> But what you want is to basically pass whole structs as a control.
>> That's
>> something that ioctls where invented for. Especially once we have
>> subdev nodes
>> this shouldn't be a problem.
>>
>> Just the fact that it is easy to implement doesn't mean it should be
>> done :-)
>>
>> Do you have specific use-cases for your proposed binary control?
> 
> Yes, I have. I am working on a driver for a video codec which is using 
> the mem2mem framework. I have to admit it's a pretty difficult 
> hardware to work with. It was one of the reasons for Pawel Osciak 
> to add multiplane support to videobuf.
> 
> Before decoding, the hardware has to parse the header of the video
> stream to get all necessary parameters such as the number of buffers,
> width, height and some internal, codec specific stuff. The video stream
> is then demultiplexed and divided into encoded frames in software and
> the hardware can only process one, separated frame at a time.
> 
> The whole codec setup cannot be achieved by using VIDIOC_S_FMT call, 
> because hardware requires access to the header data. I wanted to use
> this binary control to pass the header to the codec after setting the
> right format with VIDIOC_S_FMT. Then video frames can be easily decoded
> as a standard calls to QBUF/DQBUF pairs.
> 
> It is similar for encoding - the basic parameters are set with
> VIDIOC_S_FMT, then some codec specific/advanced are accessible as
> standard v4l2 controls. Then the encoding engine is initialized and the
> hardware returns an header of the output video stream. The header can
> be acquired by getting the value of the binary control. After that the
> frame to be encoded is provided and hw returns a single frame of
> encoded stream. 
> 
> Using custom ioctls seems appropriate for a hardware specific driver.
> Whereas the proposed binary control for getting and setting the video
> stream header could be generic solution and can be used in many drivers
> for hardware codecs.
> 
> Do You have any better solution for such device?

For sure using custom CTRL's is wrong.

If I understood correctly, you want to send some mpeg transport stream
(or something like) to the hardware and let it decode, right?

For sure the current API spec don't cover such usecase. IMO, whatever decided,
we need to add an example for this non-trivial usage. 

On a first glance, by using what we currently have for V4L2 API, it seems that 
the more correct approach is to format with S_FMT as MPEG, using a "resolution" 
that will allocate a buffer with enough size for sending the stream
to the hardware (this is basically the way other mpeg-capable encoders/decoders
do). Then, send the header via the usual stream interface and retrieve
the stream information via VIDIOC_G_* ioctls. 

Only after having the header processed by the hardware, you'll be able to mmap
memory to receive the decoded streams.

I don't think we should add a custom ioctl for this case, as other hardware may
have similar requirements, but maybe we should, instead, just create a new set of
ioctl's for video processing.

-- 

Cheers,
Mauro
