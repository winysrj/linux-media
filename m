Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9H9VuNl023812
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 05:31:57 -0400
Received: from hs-out-0708.google.com (hs-out-0708.google.com [64.233.178.244])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9H9VGDj006926
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 05:31:16 -0400
Received: by hs-out-0708.google.com with SMTP id x43so155923hsb.3
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 02:31:15 -0700 (PDT)
Message-ID: <aec7e5c30810170231w11b83a90ta087efd54edbb71c@mail.gmail.com>
Date: Fri, 17 Oct 2008 18:31:15 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0810171003421.4600@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u63nt9mvx.wl%morimoto.kuninori@renesas.com>
	<20081016102701.1bcb2c59.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0810162114030.8422@axis700.grange>
	<200810162258.28993.hverkuil@xs4all.nl>
	<aec7e5c30810161947n57851272i4204dcce515a8ec4@mail.gmail.com>
	<Pine.LNX.4.64.0810170844420.4600@axis700.grange>
	<aec7e5c30810170055o4496accbnc856c27a3fcc9423@mail.gmail.com>
	<Pine.LNX.4.64.0810171003421.4600@axis700.grange>
Cc: video4linux-list@redhat.com, Michael Schimek <mschimek@gmx.at>
Subject: Re: [PATCH] Add ov772x driver
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

On Fri, Oct 17, 2008 at 5:38 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 17 Oct 2008, Magnus Damm wrote:
>> On Fri, Oct 17, 2008 at 3:50 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > On Fri, 17 Oct 2008, Magnus Damm wrote:
>> >> Hans,  any chance of that framework including pixel format helper
>> >> code? I've hacked a bit on using a bitmap to represent pixel formats
>> >> supported by a certain driver. The attached very rough patch maybe
>> >> shows what i'm trying to do.
>> >>
>> >> Basically, I need a simple way to determine if a camera sensor
>> >> supports a certain pixel format, and if so then i'd like to add a
>> >> bunch of pixel formats supported by the soc_camera host.
>> >
>> > Thanks for the code, but, unfortunately, I don't understand what you are
>> > trying to do there, and why the current soc-camera pixel-format
>> > enumeration code doesn't suit your needs.
>>
>> I need to check for certain pixel formats in my sh_mobile_ceu driver,
>> and if available then i should add a set of NVxx pixel formats and
>> switch the CEU hardware block to a certain operating mode. The patch
>> doesn't contain that part though - only the ground work to manage
>> pixel formats represented as a bitmap.
>>
>> I _can_ do what i want to do with the current list of structs
>> approach, but using lists to represent supported modes seems overly
>> complicated. A bitmap may be a good fit since the number of pixel
>> modes we support through V4L2 is finite. Such a change will most
>> likely simplify the code and on top of that also reduce the memory
>> footprint.
>>
>> I don't know if it fits will with your plans though.
>
> Hm, well, let's try to think about it a bit, if I haven't forgotten yet
> how one does this:-)
>
> We have to be able to describe the kind data that is being transferred
> from the sensor to the host, and the way how it is being transferred.
>
> The "kind of data" is a pixel format, right?

That's how I see it too.

> Now, the "way it is being transferred" includes bus width, byte order, and
> packing information.
>
> For example, the sensor driver can specify, that the sensor supports
> RGB444, is connected in 8 bit parallel mode, is sending data in BE order,
> and is leaving the highest bits 0 (example taken from MT9M111).

The ov772x driver is written so byte 0 of all supported pixel formats
is outputted first.

> Now, how do we represent this? ATM we have a V4L2_PIX_FMT_RGB444 fourcc
> format. Do we introduce one more format V4L2_PIX_FMT_RGB444X for lowest 4
> bits = 0, or do we use the same fourcc code and use an additional
> enumeration to specify its packing?

I'd say a new fourcc. Just to compare with ov772x again, it exports
pixel formats such as RGB565, RGB565X, RGB555 and RGB55X to allow the
soc_camera host / user space select which format that is most
suitable. I think we can support one more YUV format if it would have
a fourcc.

> I would say, it's a different fourcc format, but I'd love to hear what
> others think, Michael?
>
> Packing all this in a single enumeration to then maintain all the formats
> in bitmaps doesn't seem very optimal to me, sorry.

I'm suggesting to simply use one bit per fourcc. No extra enumeration.
I'd like to have one bitmap per driver. Today we're talking about 50
fourccs so the bitmap much smaller than most list / array combinations
i can think of - even with a single fourcc supported.

> Let's decide, what information uniquely describes the data and its
> on-the-wire representation, then we can think about implementing a
> negotiation algorithm in soc-camera.

Sure, good idea.

>> Apart from that, I can probably convince my employer that I should
>> spend a bit of time on this. =)
>
> That'd be good, let's see what the decision regarding the format
> representation and negotiation is, then you can start implementing it, if
> you like:-)

Thanks. I'd like to stay away from endless iteration over arrays though. =)

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
