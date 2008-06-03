Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53JDYBY030549
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 15:13:34 -0400
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53JDKxO018169
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 15:13:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 3 Jun 2008 21:13:15 +0200
References: <48457617.mail5YC1S9Z5F@vesta.asc.rssi.ru>
	<loom.20080603T165006-806@post.gmane.org>
	<3192d3cd0806031200k48d63141hefbb3df5d812e903@mail.gmail.com>
In-Reply-To: <3192d3cd0806031200k48d63141hefbb3df5d812e903@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806032113.15468.hverkuil@xs4all.nl>
Cc: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: v4l API question: any support for HDTV is possible?
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

On Tuesday 03 June 2008 21:00:28 Christian Gmeiner wrote:
> 2008/6/3 Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>:
> > Sergey Kostyuk <kostyuk <at> vesta.asc.rssi.ru> writes:
> >> > Have you not seen this at all? http://dxr3.sf.net
> >>
> >> I know that project. The DXR3 boards dont have HDTV capabilities.
> >
> > The v4l API is a framework for frame grabbers and hardware
> > encoders. There exists no unified API for hardware decoders such as
> > yours. Each hardware decoder driver supplies an API of its own. The
> > DXR3 project is most similar hardware-wise to what you're coding.
> > Other projects in that category include:
>
> I thought v4l2 has support for video output? Have a look at
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single
>/v4l2.html#OUTPUT
>
> Maybe its time to come up with an extension for v4l to support
> decoders?! As far as I can see
> the DVB API hase some output stuff, as there exists FF-DVB cards with
> an mpeg2 decoder
> on it. But I think that there should be an api for decoding which
> gets used by dvb cards, dxr3
> and all other encoder cards.

MPEG decoders ARE supported: ivtv does it for MPEG2, and that includes 
an framebuffer device and Xorg overlay driver.

See the following sections in the V4L2 spec:

- 1.9.5 MPEG Control reference
- 4.3 Video Output Interface
- 4.4 Video Output Overlay Interface

And these sources:

- linux/dvb/video.h for: VIDEO_COMMAND
- ivtv_decoder_ioctls() in ivtv-ioctl.c

So decoder commands are really handled through DVB ioctls, but they work 
pretty well.

There is currently no way to set the HDTV-parameters through the V4L2 
API, so I suggest you make a proposal for this.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
