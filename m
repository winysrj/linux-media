Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48950 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab1BIX71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 18:59:27 -0500
MIME-Version: 1.0
In-Reply-To: <201102092043.01437.hverkuil@xs4all.nl>
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
	<AANLkTimeYp=aJi40jH2Nwu25C_e1dJYxLXXXu-7zwZEp@mail.gmail.com>
	<AANLkTim1_ba1gj25fGYua=mrya5q0twYO29enEhWxsod@mail.gmail.com>
	<201102092043.01437.hverkuil@xs4all.nl>
Date: Wed, 9 Feb 2011 18:59:25 -0500
Message-ID: <AANLkTin-6S33woAUcKOpCfw9=MFk++L7NcvYKcf2de5B@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/5] HDMI driver for Samsung S5PV310 platform
From: Alex Deucher <alexdeucher@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Matt Turner <mattst88@gmail.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Maling list - DRI developers
	<dri-devel@lists.freedesktop.org>, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 9, 2011 at 2:43 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wednesday, February 09, 2011 20:00:38 Matt Turner wrote:
>> On Wed, Feb 9, 2011 at 7:12 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> > On Tue, Feb 8, 2011 at 5:47 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> >> On Tue, 2011-02-08 at 10:28 -0500, Alex Deucher wrote:
>> >>> On Tue, Feb 8, 2011 at 4:47 AM, Hans Verkuil <hansverk@cisco.com> wrote:
>> >>> > Just two quick notes. I'll try to do a full review this weekend.
>> >>> >
>> >>> > On Tuesday, February 08, 2011 10:30:22 Tomasz Stanislawski wrote:
>> >>> >> ==============
>> >>> >>  Introduction
>> >>> >> ==============
>> >>> >>
>> >>> >> The purpose of this RFC is to discuss the driver for a TV output interface
>> >>> >> available in upcoming Samsung SoC. The HW is able to generate digital and
>> >>> >> analog signals. Current version of the driver supports only digital output.
>> >>> >>
>> >>> >> Internally the driver uses videobuf2 framework, and CMA memory allocator.
>> >>> > Not
>> >>> >> all of them are merged by now, but I decided to post the sources to start
>> >>> >> discussion driver's design.
>> >>
>> >>> >
>> >>> > Cisco (i.e. a few colleagues and myself) are working on this. We hope to post
>> >>> > an RFC by the end of this month. We also have a proposal for CEC support in
>> >>> > the pipeline.
>> >>>
>> >>> Any reason to not use the drm kms APIs for modesetting, display
>> >>> configuration, and hotplug support?  We already have the
>> >>> infrastructure in place for complex display configurations and
>> >>> generating events for hotplug interrupts.  It would seem to make more
>> >>> sense to me to fix any deficiencies in the KMS APIs than to spin a new
>> >>> API.  Things like CEC would be a natural fit since a lot of desktop
>> >>> GPUs support hdmi audio/3d/etc. and are already using kms.
>> >>>
>> >>> Alex
>> >>
>> >> I'll toss one out: lack of API documentation for driver or application
>> >> developers to use.
>> >>
>> >>
>> >> When I last looked at converting ivtvfb to use DRM, KMS, TTM, etc. (to
>> >> possibly get rid of reliance on the ivtv X video driver
>> >> http://dl.ivtvdriver.org/xf86-video-ivtv/ ), I found the documentation
>> >> was really sparse.
>> >>
>> >> DRM had the most documentation under Documentation/DocBook/drm.tmpl, but
>> >> the userland API wasn't fleshed out.  GEM was talked about a bit in
>> >> there as well, IIRC.
>> >>
>> >> TTM documentation was essentially non-existant.
>> >>
>> >> I can't find any KMS documentation either.
>> >>
>> >> I recall having to read much of the drm code, and having to look at the
>> >> radeon driver, just to tease out what the DRM ioctls needed to do.
>> >>
>> >> Am I missing a Documentation source for the APIs?
>>
>> Yes,
>>
>> My summer of code project's purpose was to create something of a
>> tutorial for writing a KMS driver. The code, split out into something
>> like 15 step-by-step patches, and accompanying documentation are
>> available from Google's website.
>>
>> http://code.google.com/p/google-summer-of-code-2010-xorg/downloads/detail?name=Matt_Turner.tar.gz
>
> Nice!
>
> What I still don't understand is if and how this is controlled via userspace.
>
> Is there some documentation of the userspace API somewhere?

At the moment, it's only used by Xorg ddxes and the plymouth
bootsplash.  For details see:
http://cgit.freedesktop.org/plymouth/tree/src/plugins/renderers/drm
http://cgit.freedesktop.org/xorg/driver/xf86-video-ati/tree/src/drmmode_display.c

>
>> My repository (doesn't include the documentation) is available here:
>> http://git.kernel.org/?p=linux/kernel/git/mattst88/glint.git;a=summary
>>
>> There's a 'rebased' branch that contains API changes required for the
>> code to work with 2.6.37~.
>>
>> I hope it's useful to you.
>>
>> I can't image how the lack of documentation of an used and tested API
>> could be a serious reason to write you own.
>
> That never was the main reason. It doesn't help, though.
>
>> That makes absolutely no
>> sense to me, so I hope you'll decide to use KMS.
>
> No, we won't. A GPU driver != a V4L driver. The primary purpose of a V4L2
> display driver is to output discrete frames from memory to some device. This
> may be a HDMI transmitter, a SDTV transmitter, a memory-to-memory codec, an
> FPGA, whatever. In other words, there is not necessarily a monitor on the other
> end. We have for some time now V4L2 APIs to set up video formats. The original
> ioctl was VIDIOC_G/S_STD to select PAL/NTSC/SECAM. The new ones are
> VIDIOC_G/S_DV_PRESETS which set up standard formats (1080p60, 720p60, etc) and
> DV_TIMINGS which can be used for custom bt.656/1120 digital video timings.
>
> Trying to mix KMS into the V4L2 API is just a recipe for disaster. Just think
> about what it would mean for DRM if DRM would use the V4L2 API for setting
> video modes. That would be a disaster as well.

I still think there's room for cooperation here.  There are GPUs out
there that have a capture interface and a full gamut of display output
options in addition to a 3D engine.  Besides conventional desktop
stuff, you could use this sort of setup to capture frames, run them
through shader-based filters/transforms and render then to memory to
be scanned out by display hardware, or dma'ed to another device like
an fpga or codec like you mentioned.  On the other side, the same SoCs
that such that are used for v4l could also be used as a desktop
framebuffer.

FWIW, you may find the drm EDID and mode handling bits useful.  See
drm_modes.c and drm_edid.c.

Alex

>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
>
