Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33310 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab0AVSOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 13:14:46 -0500
Received: by fxm20 with SMTP id 20so1601966fxm.21
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 10:14:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001221833.39670.hverkuil@xs4all.nl>
References: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
	 <201001221742.33679.hverkuil@xs4all.nl>
	 <1a297b361001220911g5ae11ebfo36195d75f2e9f0e1@mail.gmail.com>
	 <201001221833.39670.hverkuil@xs4all.nl>
Date: Fri, 22 Jan 2010 22:14:44 +0400
Message-ID: <1a297b361001221014k48ae7da8w80f50616d1d48375@mail.gmail.com>
Subject: Re: About MPEG decoder interface
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>, Michael Qiu <fallwind@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 22, 2010 at 9:33 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Friday 22 January 2010 18:11:48 Manu Abraham wrote:
>> On Fri, Jan 22, 2010 at 8:42 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > On Friday 22 January 2010 04:00:53 Andy Walls wrote:
>> >> On Fri, 2010-01-22 at 10:42 +0800, Michael Qiu wrote:
>> >> > Hi all,
>> >> >
>> >> >   How can I export my MPEG decoder control interface to user space?
>> >> >   Or in other words, which device file(/dev/xxx) should a proper
>> >> > driver for mpeg decoder provide?
>> >>
>> >> The MPEG decoder on a PVR-350 PCI card provides a /dev/video interface
>> >> (normally /dev/video16).
>> >>
>> >> The interface specification to userspace is the V4L2 API:
>> >>
>> >> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html
>> >
>> > Not really. The v4l2 API specifies the MPEG encoder part, but not the decode
>> > part.
>> >
>> > The decoder part is (unfortunately) part of the DVB API.
>> >
>> > Some ioctls are documented here:
>> >
>> > http://www.linuxtv.org/downloads/v4l-dvb-apis/ch11s02.html
>> >
>> > However, that documentation is very out of date and you are better off looking
>> > in the include/linux/dvb/video.h header.
>> >
>> > In particular the new struct video_command and associated ioctls provides
>> > you with more control than the older VIDEO_CMD_ ioctls.
>> >
>> > Note that the V4L2 API will get a new event API soon that should supercede the
>> > event implementation in this video.h. The video.h implementation is pretty
>> > crappy (most of what is in there is crappy: poorly designed without much thought
>> > for extendability).
>> >
>> >> >   And, in linux dvb documents, all the frontend interface looks like
>> >> > /dev/dvb/adapter/xxx, it looks just for PCI based tv card.
>> >> >   If it's not a TV card, but a frontend for a embedded system without
>> >> > PCI, which interface should I use?
>> >
>> > V4L2, but with the ioctls defined in dvb/video.h. See for example the ivtv
>> > driver (ivtv-ioctl.c).
>>
>>
>> For a DVB STB, you don't need to use V4L2 in anyway.. It doesn't make
>> sense either...
>
> Depends on the hardware. If there are no V4L2 features that need to be supported,
> then you are correct. But if the hardware functions more as a video output device
> which can also do MPEG decoding, then the MPEG decoder ioctls should be implemented
> by the V4L2 device.
>
> To be honest, MPEG decoding should have been a V4L2 feature from the beginning. It
> really has nothing to do with DVB as such.


Hard to agree that way. I don't see anything specific to V4L2 that's
in a decoder.
V4L2 originated as nothing more than analog TV capture cards and never
had more than that concept. Adding some new IOCTL's to V4L2 doesn't
mean that all stuff has to be whacked into V4L2.
The DVB API was designed with STB's in mind, in fact it even evolved
from a commercial STB.
I think generally that's what understood by the industry as well ...

http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?tp=&arnumber=964125&isnumber=20813

Till a few years back, vendors announced them as DVB decoders as well ...
http://www.design-reuse.com/news/11090/conexant-dvb-decoders-mass-market-free-air-top-boxes.html




>> The presentation/scaler used with V4L2 is pretty much
>> legacy code.
>
> Huh? Not sure what you mean here.


DirectFB is used for all those scaling and other purposes. DirectFB
has a framebuffer driver, but that which is in userspace, IIRC. This
provides much more control eventually.


>> For STB's generally DirectFB is used to give full
>> control.
>
> There are usually two parts: one is a framebuffer device for the OSD, and one is
> a (possibly V4L2) device node to do the MPEG decoding that support the video.h
> API.


Yup. The hardware that which I have used till date uses
/dev/dvb/adapter/video alone, rather than /dev/video. IIRC VDR
application as well uses it likewise. Most commercial STB's using
Linux go the same path as well. I don't follow what you mean though.
Oh well, let's start moving everything that's in DVB to V4L .... I
just see this as sheer nonsense.

Let's agree to disagree, here.


Regards,
Manu
