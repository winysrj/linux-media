Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab2HVNmh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 09:42:37 -0400
Message-ID: <5034E1C2.30205@redhat.com>
Date: Wed, 22 Aug 2012 10:42:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Mike Isely <isely@pobox.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: Core + Radio profile
References: <201208221140.25656.hverkuil@xs4all.nl> <201208221211.47842.hverkuil@xs4all.nl>
In-Reply-To: <201208221211.47842.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-08-2012 07:11, Hans Verkuil escreveu:
> I've added some more core profile requirements.
> 
> Regards,
> 
> 	Hans
> 
> On Wed August 22 2012 11:40:25 Hans Verkuil wrote:
>> Hi all!
>>
>> The v4l2-compliance utility checks whether device drivers follows the V4L2
>> specification. What is missing are 'profiles' detailing what device drivers
>> should and shouldn't implement for particular device classes.
>>
>> This has been discussed several times, but until now no attempt was made to
>> actually write this down.
>>
>> This RFC is my attempt to start this process by describing three profiles:
>> the core profile that all drivers must adhere to, a profile for a radio
>> receiver and a profile for a radio transmitter.
>>
>> Missing in this RFC is a description of how tuner ownership is handled if a
>> tuner is shared between a radio and video driver. This will be discussed
>> during the workshop next week.

DVB x V4L2 tunership discussion is also needed. It also makes sense to 
document it somewhere.

>> I am not certain where these profile descriptions should go. Should we add
>> this to DocBook, or describe it in Documentation/video4linux? Or perhaps
>> somehow add it to v4l2-compliance, since that tool effectively verifies
>> the profile.

The strongest document we have, IMO, is the DocBook API one, as both Kernel
and userspace developers use it. As we want userspace apps to be aware and
benefit of the profiles, this should be there at DocBook.

>> Also note that the core profile description is more strict than the spec.

IMO, that's the right approach: The specs should define the several API
aspects; the profile should mandate what's optional and what's mandatory.

>> For example, G/S_PRIORITY are currently optional,

After putting the profiles there, we should remove "optional" tags elsewhere,
as the profiles section will tell what's mandatory and what is optional, as
different profiles require different mandatory arguments.

>> but I feel that all new drivers should implement this, especially since it
>> is very easy to add provided you use struct v4l2_fh. 

I agree on making G/S_PRIORITY mandatory.

>> Similar with respect to the control requirements which
>> assume you use the control framework.

IMO, we should split the internal API requirements (use the control framework)
from the external API ones, as they're addressed to different audiences, e. g.
external API requirements are needed by all application developers, while
the internal ones are only for Kernel hackers.

The internal API requirements should be together with the internal API descriptions,
so Documentation/video4linux is probably the best place for them.

>> Note that these profiles are primarily meant for driver developers. The V4L2
>> specification is leading for application developers.

This is where we diverge ;) We need profiles primary for application developers,
for them to know what is expected to be there on any media driver of a certain
kind.

Ok, internal driver-developer profiles is also needed, in order for them to
use the right internal API's and internal core functions.

>> While writing down these profiles I noticed one thing that was very much
>> missing for radio devices: there is no capability bit to tell the application
>> whether there is an associated ALSA device or whether the audio goes through
>> a line-in/out. Personally I think that this should be fixed.

Yes, this is one bit that it is missing. Well, this is currently handled this
at xawtv3 "radio" aplication by using the libmedia_dev API there.

It likely makes sense, for a version 2 of the profiles (e. g. after we finish
merging the basic stuff there), to add a chapter at  the profiles section 
recommending the usage of the libraries provided by v4l-utils, with some 
description or code examples.

>>
>> Comments are welcome!
>>
>> Regards,
>>
>> 	Hans
>>
>>
>> Core Profile
>> ============
>>
>> All V4L2 device nodes must support the core profile.
>>
>> VIDIOC_QUERYCAP must be supported and must set the device_caps field.
>> bus_info must be a unique string and must not be empty (pending result of
>> the upcoming workshop).
>>
>> VIDIOC_G/S_PRIORITY must be supported.
>>
>> If you have controls then both the VIDIOC_G/S_CTRL and the VIDIOC_G/S/TRY_EXT_CTRLS
>> ioctls must be supported, together with poll(), VIDIOC_DQEVENT and
>> VIDIOC_(UN)SUBSCRIBE_EVENT to handle control events. 

>> Use the control framework to implement this.

Now looking at the concrete case, I don't see any troubles on adding it to
the V4L2 API, but writing it as:

	"Driver developers must use the control framework to implement this."

>> VIDIOC_LOG_STATUS is optional, but recommended for complex drivers.
>>
>> VIDIOC_DBG_G_CHIP_IDENT, VIDIOC_DBG_G/S_REGISTER are optional and are
>> primarily used to debug drivers.

The above ones require a note for application developers:

	"Applications must not use VIDIOC_LOG_STATUS during its normal behaviour;
	 this is reserved for driver's debug/test.

	 The usage of VIDIOC_DBG_G_CHIP_IDENT and VIDIOC_DBG_G/S_REGISTER is solely 
	 for driver's debug. Applications should never use it."

>> Video, Radio and VBI nodes are for input or output only. 

Hmm... didn't look clear to me. I would change the first phase to something like:

	"Each video, radio or vbi node should be used by just one input or
	output streaming engine."

>> The only exception
>> are video nodes that have the V4L2_CAP_VIDEO_M2M(_MPLANE) capability set.

Again, not clear what it should be expected on a device with the M2M capabilities.

Better to write it like:

	"Video nodes with memory to memory capabilities (V4L2_CAP_VIDEO_M2M and
V4L2_CAP_VIDEO_M2M_MPLANE) must implement both one input streaming engine and
one output streaming engine at the same node."

>> Video nodes only control video, radio nodes only control radio and RDS, vbi
>> nodes only control VBI (raw and/or sliced).

I would use "must" word for everything mandatory at the profiles section (
and "may" for optional ones), like:

	"Video nodes must only control the video functionality.

	 Radio nodes must only control the radio functionality.

	 VBI nodes must only control the Vertical Blank Interface functionality. The
	 same VBI node must be used by raw VBI and sliced VBI api's, when both are
	 supported."

>>
>> Streaming I/O is not supported by radio nodes.

	Hmm... pvrusb2/ivtv? Ok, it makes sense to move it to use the alsa
mpeg API there. If we're enforcing it, we should deprecate the current way
there, and make it use ALSA.

(more comments about it below)

> It should be possible to open device nodes more than once. Just opening a
> node and querying information from the driver should not change the state
> of the driver.

Hmm... locking between DVB and V4L should likely be added here: e. g. is it
allowed to open both DVB and V4L nodes for the same tuner/streaming engine?

Currently, this is not allowed. There are also known issues when applications
change too fast between them (open/close V4L, then open/close dvb or vice-versa).

> The file handle that called VIDIOC_REQBUFS, VIDIOC_CREATE_BUFS, read/write
> or select (for reading or writing) first is the only one that can do I/O.
> Attempts by other file handles to call these ioctls/file operations will
> get an EBUSY error.
>
> This file handle remains the owner of the I/O until the file handle is
> closed, or until VIDIOC_REQBUFS is called with count == 0.

Please change it to use "must". Also, I think that doing s/called/calls/
is better.

It is likely better to say it as:

	The streaming engine ownership must be taken by the first handle that calls
	VIDIOC_REQBUFS, VIDIOC_CREATE_BUFS, read/write or select (for reading or writing).

	Only such file handler must do streaming I/O. Any attempts by other file handlers
	to do I/O must return EBUSY.

	The I/O streaming ownership must be released when the file handler is closed
	or when VIDIOC_REQBUFS is called with count equal to zero.

>>
>> Radio Receiver Profile
>> ======================
>>
>> Radio devices have a tuner and (usually) a demodulator. The audio is either
>> send out to a line-out connector or uses ALSA to stream the audio.

Hmm... are there anything mandatory here, or are you just defining what a radio is?
In the latter, the above text looks ok.

>>
>> It implements VIDIOC_G/S_TUNER, VIDIOC_G/S_FREQUENCY and VIDIOC_ENUM_FREQ_BANDS.

	In addition to the mandatory items at the core profile (I would add an hyperlink here),
	all drivers must implement VIDIOC_G/S_TUNER, VIDIOC_G/S_FREQUENCY and VIDIOC_ENUM_FREQ_BANDS.

>> If hardware seek is supported, then VIDIOC_S_HW_FREQ_SEEK is implemented.

	A radio device may implement VIDIOC_S_HW_FREQ_SEEK, when audio station seek is
	supported by radio.

>> It does *not* implement VIDIOC_ENUM/G/S_INPUT or VIDIOC_ENUM/G/S_AUDIO.

A radio node must *not* implement VIDIOC_ENUM/G/S_INPUT or VIDIOC_ENUM/G/S_AUDIO.

>> If RDS_BLOCK_IO is supported, then read() and poll() are implemented as well.

Radio drivers that support RDS must report RDS_BLOCK_IO. In this case, radio
nodes must implement read()/poll() syscalls.

>> If a mute control exists and the audio is output using a line-out, then the
>> audio must be muted on driver load and unload.
>>
>> On driver load the frequency must be initialized to a valid frequency.

This is not nice, and not always possible: devices with xc3028 tuner (and other
Xceive tuners) have firmwares for radio and for TV. Initializing for radio
makes TV uninitialized, and vice-versa. Also, some devices take up to 30 seconds
to load a firmware (tm6000).

I think you're likely trying to say that the initial frequency should be
a valid value. If so, please prepend it with a "driver developer's note".

>>
>> Note: There are a few drivers that use a radio (pvrusb2) or video (ivtv)
>> node to stream the audio. These are legacy exceptions to the rule.

What an application developer should do with that???

If this should not be supported anymore, then we need instead to either
fix the drivers that aren't compliant with the specs or move them to
staging, in order to let them to be either fixed or dropped, if none
cares enough to fix.

>>
>> FM Transmitter Profile
>> ======================
>>
>> FM transmitter devices have a transmitter and modulator. The audio is
>> transferred using ALSA or a line-in connector.

Hmm... are there anything mandatory here, or are you just defining what a radio is?
In the latter, the above text looks ok.

>>
>> It implements VIDIOC_G/S_MODULATOR, VIDIOC_G/S_FREQUENCY and VIDIOC_ENUM_FREQ_BANDS.
>>
>> It does *not* implement VIDIOC_ENUM/G/S_OUTPUT or VIDIOC_ENUM/G/S_AUDOUT.
>>
>> If RDS_BLOCK_IO is supported, then write() and poll() are implemented
>> as well.
>>
>> On driver load the frequency must be initialized to a valid frequency.

Same notes from the "radio" profile applies here.

--

That's said, I think that the RFC proposal is going on the right direction.
It is very good to see it moving forward!

Thanks!
Mauro
