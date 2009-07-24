Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6OGAOKE009759
	for <video4linux-list@redhat.com>; Fri, 24 Jul 2009 12:10:25 -0400
Received: from mail-bw0-f216.google.com (mail-bw0-f216.google.com
	[209.85.218.216])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6OGA8Kv013856
	for <video4linux-list@redhat.com>; Fri, 24 Jul 2009 12:10:08 -0400
Received: by bwz12 with SMTP id 12so1493215bwz.3
	for <video4linux-list@redhat.com>; Fri, 24 Jul 2009 09:10:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090724124825.672be2d3@pedra.chehab.org>
References: <20090717174101.GB15611@vanheusden.com>
	<20090723165929.64cf3933@pedra.chehab.org>
	<20090723201823.GS11865@vanheusden.com>
	<36c518800907240758k2a1d8e9btdd841323e4dc2492@mail.gmail.com>
	<20090724150727.GB11865@vanheusden.com>
	<20090724124825.672be2d3@pedra.chehab.org>
Date: Fri, 24 Jul 2009 19:10:07 +0300
Message-ID: <36c518800907240910m93f253cv19efbdf489e0fb1e@mail.gmail.com>
From: vasaka@gmail.com
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: video4linux loopback device
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, Jul 24, 2009 at 6:48 PM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Em Fri, 24 Jul 2009 17:07:29 +0200
> Folkert van Heusden <folkert@vanheusden.com> escreveu:
>
>> > >> > Any chance that the video4linux loopback device will be integrated in
>> > >> > the main video4linux distribution and included in the kernel?
>> > >> > http://www.lavrsen.dk/foswiki/bin/view/Motion/VideoFourLinuxLoopbackDevice
>> > >> > or
>> > >> > http://sourceforge.net/projects/v4l2vd/
>> > >> > or
>> > >> > http://code.google.com/p/v4l2loopback/
>> > >> > This enables userspace postprocessors to feed the altered stream to
>> > >> > applications like amsn and skype for videochats.
>> > >> If the postprocessor application is LGPL, the better is to add it at libv4l.
>> > >
>> > > I don't agree as the postprocessor implements fun-effects: warhol,
>> > > puzzle, circles, wobble, etc.
>> >
>> > and how one can make skype to get pictue from libv4l or alter the
>> > picture which application is getting through libv4l?
>> > again some proxy is needed here.
>>
>> Correct so we definately need some external video loopback device.
>> It gives as a much greater flexibility.
>
> libv4l intercepts V4L2 calls by using LD_PRELOAD. Without it, skype doesn't
> work with most of the cams, since it doesn't support several of the output
> formats common on most cameras. I have lots of different webcam models here. I
> think only one or two are directly supported by skype.
>
> libv4l already have some postprocessor effects (currently limited to image
> enhancements like auto-gain/auto-bright and similar stuff), but I don't see why
> not adding there other effects including the fun ones.
>
> Hans has several plans of improvements for it, including more post-processing
> effects and the ability of duplicating a video to more than one application at
> the same time.
>
> The big problem with a v4l2 loopback is that you're adding something that it is
> not proper to kernel, since it were not designed to be a proxy between two
> userspace applications. This is the space where libraries were designed. Due to
> that, you can affect the machine performance, due to the usage of kernel memory
> barriers.
>
> Also, you'll likely add extra buffering costs of copying control data and
> stream mapping in order to access it  from/to kernel where you could just pass
> a buffer between the effect processors and do a simple function call.
>
>
>
> Cheers,
> Mauro
>

Sounds interesting. will libv4l have ability to provide video from
sources other than v4l2 devices?
One of the things I want to achieve is to provide talking head to
video chatting programs instead of usual video stream.

vasaka

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
