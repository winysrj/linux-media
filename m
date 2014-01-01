Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56095 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaAATl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 14:41:59 -0500
Received: by mail-qc0-f171.google.com with SMTP id c9so12855371qcz.2
        for <linux-media@vger.kernel.org>; Wed, 01 Jan 2014 11:41:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1388586278.1879.21.camel@palomino.walls.org>
References: <CAJghqepkKXth6_jqj5jU-HghAHxBBkaphCpR5MqfuRGXHXA4Sg@mail.gmail.com>
	<CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
	<CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
	<1388254550.2129.83.camel@palomino.walls.org>
	<CAJghqeptMtc2OTUuCY8MUY14kj-d6KPpUAUCxjw8Nod6TNOMaA@mail.gmail.com>
	<1388586278.1879.21.camel@palomino.walls.org>
Date: Wed, 1 Jan 2014 14:41:59 -0500
Message-ID: <CAJghqerAVmCd_xcW9x2y=gKd4uq9-3P0CTmW_UpAjA42WQNNTw@mail.gmail.com>
Subject: Re: Fwd: v4l2: The device does not support the streaming I/O method.
From: Andy <dssnosher@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to stream /dev/video0 to http and encode it in h.264.

On Wed, Jan 1, 2014 at 9:24 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Sun, 2013-12-29 at 15:27 -0500, Andy wrote:
>> Are there any other viable options to stream /dev/video0 then?
>
> I'm not sure what you mean by stream; what are you trying to do?
>
> By default the ivtv driver and the PVR-150 output an MPEG-2 Program
> Stream containing MPEG-2 Video and MPEG-2 Audio Elementary Streams.
>
> Any Linux video application worth it's salt (mplayer, VLC, ffmpeg)
> should be able to handle that MPEG-2 PS with no problem.
>
> It's just a matter of using the correct command line argument to do what
> you want to do.  mplayer only needs the device node name as a command
> line argument to play back the stream.
>
> Regards,
> Andy
>
>
>
>
>> On Sat, Dec 28, 2013 at 1:15 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> > On Fri, 2013-12-27 at 00:37 -0500, Andy wrote:
>> >> I am trying to capture input from /dev/video0 which is Hauppauge Win
>> >> 150 MCE PCI card but I get the following error which has no record on
>> >> google
>> >>
>> >> [video4linux2,v4l2 @ 0xb080d60] The device does not support the
>> >> streaming I/O method.
>> >> /dev/video0: Function not implemented
>> >
>> > The ivtv driver does not support the V4L2 Streaming I/O ioctl()'s for
>> > transferring video data buffers.  It only supports the read()/write()
>> > calls.
>> >
>> > I'm not sure about ffmpeg, but mplayer is happy to read() the mpeg
>> > stream from standard input or the device node:
>> >
>> > # cat /dev/video0 | mplayer
>> > or
>> > # mplayer /dev/video0
>> >
>> > Regards,
>> > Andy
>> >
>> >> Here is the ffmpeg command
>> >> ffmpeg -y -f:v video4linux2 -i /dev/video0 -f:a alsa -ac 1 -i hw:1,0
>> >> -threads 2 -override_ffserver -flags +global_header -vcodec libx264 -s
>> >> 320x240 -preset superfast -r 7.5 -acodec aac -ar 44100
>> >> ipgoeshere:port/dvbstest.ffm
>> >>
>> >> Disregard the DVB syntax, not relevant
>> >>
>> >> Any idea what is causing the error?
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> >
>
>
