Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40952 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591Ab2HYAhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 20:37:18 -0400
Subject: Re: RFC: Core + Radio profile
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Fri, 24 Aug 2012 20:37:15 -0400
In-Reply-To: <201208221140.25656.hverkuil@xs4all.nl>
References: <201208221140.25656.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1345855036.2491.86.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-08-22 at 11:40 +0200, Hans Verkuil wrote:
> Hi all!
> 
> The v4l2-compliance utility checks whether device drivers follows the V4L2
> specification. What is missing are 'profiles' detailing what device drivers
> should and shouldn't implement for particular device classes.
>
>This has been discussed several times, but until now no attempt was made to
> actually write this down.
 
Hi Hans,

Excellent!

Profiles of what to implement from a large, complex, option-filled
standard are a great way to increase interoperability.  In our case the
"standard" is the V4L2 specification.  The interoperability we need to
increase is between user-space applications (MythTV, tvtime, VLC,
mplayer, gstreamer, cheese, Ekiga, ZoneMinder, Kaffeine, ....) and the
kernel device drivers.

I know of two viewpoints from which profiles are documented:

1. how an as-built system complies with and implement options from a
stanadrd, and

2. how future systems and systems in development should implement a
standard and its options

For linux-media purposes, profiling from viewpoint #1 is a bit of a
waste: the v4l2-compliance tool essentially auto generates the profiles
plus at least some of the existing user applications are already aware
of driver quirks.

I think documenting the profiles from the 2nd viewpoint is what we want.
(Which is what you are proposing.)

Such profiles should state unequviocally:

1. the optional features from the standard/spec that are required to be
implemented

2. any optional features from the standard/spec that are required *not*
to be implemented

3. the mandatory features from the standard/spec that are expected to be
implemented

4. any mandatory portions of the specification that are specifically not
to be used (Probably only needed for profiles trying to ensure the
broadest interoperability).

Hopefully, specifying the above in profiles removes all the guess-work
about what is to be implemented, so that application <-> kernel driver
combinations will be broadly interoperable.



> This RFC is my attempt to start this process by describing three profiles:
> the core profile that all drivers must adhere to, a profile for a radio
> receiver and a profile for a radio transmitter.

I was thinking that profiles based on applications types might be more
useful, but then I saw that applications were basically already handling
different device types differently.  So prfoiles for hardware device
types seems the reasonable choice.

MythTV seems to care about 4 classes of device
http://www.mythtv.org/wiki/Video_capture_card

	Analog Framebuffer
	Analog Hardware Encoder
	Digital Capture
	Digital Tuner

VLC seems to be similar to MythTV in terms of classes:
http://www.videolan.org/doc/streaming-howto/en/images/global-diagram.jpg

I suppose there would also be profiles to support device classes for:

	webcams
	webcams that provide video in a container format (AVI, MJPEG, whatever)
	integrated cameras (I'm thinking smart-phones, but I'm out of my depth here)


I assume you are designing the Core profile to be a minimum subset
profile upon which all other profiles build.


> Missing in this RFC is a description of how tuner ownership is handled if a
> tuner is shared between a radio and video driver. This will be discussed
> during the workshop next week.

IMO, that is a specification issue, and not an issue to be solved in a
profile.  I have a narrow view the profiles are intended to fix
interoperability problems, and they are not to levy new, unprecedented
requirements on behaviour.


> I am not certain where these profile descriptions should go. Should we add
> this to DocBook, or describe it in Documentation/video4linux? Or perhaps
> somehow add it to v4l2-compliance, since that tool effectively verifies
> the profile.

Don't bury the authoritative profile in a tool, profiles should be
documents easily accessed by implementors.

Interoperability is promoted via clearly documentation requirments for
implementors.  Interoperability is assessed with tools.


> Also note that the core profile description is more strict than the spec. For
> example, G/S_PRIORITY are currently optional, but I feel that all new drivers
> should implement this, especially since it is very easy to add provided you
> use struct v4l2_fh. Similar with respect to the control requirements which
> assume you use the control framework.
> 
> Note that these profiles are primarily meant for driver developers. The V4L2
> specification is leading for application developers.

I would contend profiles are for both groups of developers.

The V4L2 spec tells everyone the realm of possibilities.

Profiles tell people here's how to ensure your driver or application has
the greatest chance of working properly with many different applications
or kernel drivers.


> While writing down these profiles I noticed one thing that was very much
> missing for radio devices: there is no capability bit to tell the application
> whether there is an associated ALSA device or whether the audio goes through
> a line-in/out. Personally I think that this should be fixed.

You didn't say it, but I assume that is a problem you think needs to be
solved in the V4L2 spec.

> Comments are welcome!
> 
> Regards,
> 
> 	Hans
> 
> 
> Core Profile
> ============
> 
> All V4L2 device nodes must support the core profile.
> 
> VIDIOC_QUERYCAP must be supported and must set the device_caps field.
> bus_info must be a unique string and must not be empty (pending result of
> the upcoming workshop).

The "bus_info" string is too open ended.  Nail it down.

The profile needs to tell implementers how to ensure their string is
unique and any other constraints on said string.  Likewise application
developers need to know what to expect from the string.



> VIDIOC_G/S_PRIORITY must be supported.

OK.


> If you have controls then both the VIDIOC_G/S_CTRL and the VIDIOC_G/S/TRY_EXT_CTRLS
> ioctls must be supported, together with poll(), VIDIOC_DQEVENT and
> VIDIOC_(UN)SUBSCRIBE_EVENT to handle control events. Use the control framework
> to implement this.

OK.

> VIDIOC_LOG_STATUS is optional, but recommended for complex drivers.

Not OK.  I would avoid making anything in a profile optional.

Given that the output of LOG_STATUS does not enhance interoperability,
as its output is not readily readable by the calling application, I
recommend dropping mention of LOG_STATUS from the core profile.


> VIDIOC_DBG_G_CHIP_IDENT, VIDIOC_DBG_G/S_REGISTER are optional and are
> primarily used to debug drivers.

Drop mention of these from the Core profile as well.  These can be, and
usually are, compiled out of stock distro kernel with a kernel build
configuration option.

Normal end user applications cannot rely on the being there, so they do
not enhance interoperability.

If you wish to add a Debug profile that builds upon the Core profile,
them these ioctl()s and _LOG_STATUS would fit nicely in that.


> Video, Radio and VBI nodes are for input or output only. The only exception
> are video nodes that have the V4L2_CAP_VIDEO_M2M(_MPLANE) capability set.

Slight wording change:

"Video, Radio and VBI nodes are for data input only or output only; not
both from the same node.  The only exception ..."

Although I thought the V4L2 specification would have been clear on that.


> 
> Video nodes only control video, radio nodes only control radio and RDS, vbi
> nodes only control VBI (raw and/or sliced).

If that is the case, then does the profile need to say something about
multiple open of radio nodes?  (I'm thinking of the legacy /dev/video24
nodes here, which are really interoperabily losers in terms of existing
FM radio apps anyway.)

> Streaming I/O is not supported by radio nodes.


That's all I have for now.  I have to go.  I will comment on other posts
as I have time.

Regards,
Andy W.


> Radio Receiver Profile
> ======================
> 
> Radio devices have a tuner and (usually) a demodulator. The audio is either
> send out to a line-out connector or uses ALSA to stream the audio.
> 
> It implements VIDIOC_G/S_TUNER, VIDIOC_G/S_FREQUENCY and VIDIOC_ENUM_FREQ_BANDS.
> 
> If hardware seek is supported, then VIDIOC_S_HW_FREQ_SEEK is implemented.
> 
> It does *not* implement VIDIOC_ENUM/G/S_INPUT or VIDIOC_ENUM/G/S_AUDIO.
> 
> If RDS_BLOCK_IO is supported, then read() and poll() are implemented as well.
> 
> If a mute control exists and the audio is output using a line-out, then the
> audio must be muted on driver load and unload.
> 
> On driver load the frequency must be initialized to a valid frequency.
> 
> Note: There are a few drivers that use a radio (pvrusb2) or video (ivtv)
> node to stream the audio. These are legacy exceptions to the rule.
> 
> FM Transmitter Profile
> ======================
> 
> FM transmitter devices have a transmitter and modulator. The audio is
> transferred using ALSA or a line-in connector.
> 
> It implements VIDIOC_G/S_MODULATOR, VIDIOC_G/S_FREQUENCY and VIDIOC_ENUM_FREQ_BANDS.
> 
> It does *not* implement VIDIOC_ENUM/G/S_OUTPUT or VIDIOC_ENUM/G/S_AUDOUT.
> 
> If RDS_BLOCK_IO is supported, then write() and poll() are implemented
> as well.
> 
> On driver load the frequency must be initialized to a valid frequency.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


