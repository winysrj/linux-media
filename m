Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41031 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0AVRLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 12:11:50 -0500
Received: by fxm20 with SMTP id 20so1531196fxm.21
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 09:11:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001221742.33679.hverkuil@xs4all.nl>
References: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
	 <1264129253.3094.5.camel@palomino.walls.org>
	 <201001221742.33679.hverkuil@xs4all.nl>
Date: Fri, 22 Jan 2010 21:11:48 +0400
Message-ID: <1a297b361001220911g5ae11ebfo36195d75f2e9f0e1@mail.gmail.com>
Subject: Re: About MPEG decoder interface
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>, Michael Qiu <fallwind@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 22, 2010 at 8:42 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Friday 22 January 2010 04:00:53 Andy Walls wrote:
>> On Fri, 2010-01-22 at 10:42 +0800, Michael Qiu wrote:
>> > Hi all,
>> >
>> >   How can I export my MPEG decoder control interface to user space?
>> >   Or in other words, which device file(/dev/xxx) should a proper
>> > driver for mpeg decoder provide?
>>
>> The MPEG decoder on a PVR-350 PCI card provides a /dev/video interface
>> (normally /dev/video16).
>>
>> The interface specification to userspace is the V4L2 API:
>>
>> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html
>
> Not really. The v4l2 API specifies the MPEG encoder part, but not the decode
> part.
>
> The decoder part is (unfortunately) part of the DVB API.
>
> Some ioctls are documented here:
>
> http://www.linuxtv.org/downloads/v4l-dvb-apis/ch11s02.html
>
> However, that documentation is very out of date and you are better off looking
> in the include/linux/dvb/video.h header.
>
> In particular the new struct video_command and associated ioctls provides
> you with more control than the older VIDEO_CMD_ ioctls.
>
> Note that the V4L2 API will get a new event API soon that should supercede the
> event implementation in this video.h. The video.h implementation is pretty
> crappy (most of what is in there is crappy: poorly designed without much thought
> for extendability).
>
>> >   And, in linux dvb documents, all the frontend interface looks like
>> > /dev/dvb/adapter/xxx, it looks just for PCI based tv card.
>> >   If it's not a TV card, but a frontend for a embedded system without
>> > PCI, which interface should I use?
>
> V4L2, but with the ioctls defined in dvb/video.h. See for example the ivtv
> driver (ivtv-ioctl.c).


For a DVB STB, you don't need to use V4L2 in anyway.. It doesn't make
sense either... The presentation/scaler used with V4L2 is pretty much
legacy code. For STB's generally DirectFB is used to give full
control.

Regards,
Manu
