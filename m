Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9H7tnaw012823
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 03:55:49 -0400
Received: from hs-out-0708.google.com (hs-out-0708.google.com [64.233.178.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9H7tPpm026274
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 03:55:30 -0400
Received: by hs-out-0708.google.com with SMTP id x43so144518hsb.3
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 00:55:25 -0700 (PDT)
Message-ID: <aec7e5c30810170055o4496accbnc856c27a3fcc9423@mail.gmail.com>
Date: Fri, 17 Oct 2008 16:55:24 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0810170844420.4600@axis700.grange>
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
Cc: video4linux-list@redhat.com
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

Hi Guennadi,

Thanks for your feedback!

On Fri, Oct 17, 2008 at 3:50 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 17 Oct 2008, Magnus Damm wrote:
>> Hans,  any chance of that framework including pixel format helper
>> code? I've hacked a bit on using a bitmap to represent pixel formats
>> supported by a certain driver. The attached very rough patch maybe
>> shows what i'm trying to do.
>>
>> Basically, I need a simple way to determine if a camera sensor
>> supports a certain pixel format, and if so then i'd like to add a
>> bunch of pixel formats supported by the soc_camera host.
>
> Thanks for the code, but, unfortunately, I don't understand what you are
> trying to do there, and why the current soc-camera pixel-format
> enumeration code doesn't suit your needs.

I need to check for certain pixel formats in my sh_mobile_ceu driver,
and if available then i should add a set of NVxx pixel formats and
switch the CEU hardware block to a certain operating mode. The patch
doesn't contain that part though - only the ground work to manage
pixel formats represented as a bitmap.

I _can_ do what i want to do with the current list of structs
approach, but using lists to represent supported modes seems overly
complicated. A bitmap may be a good fit since the number of pixel
modes we support through V4L2 is finite. Such a change will most
likely simplify the code and on top of that also reduce the memory
footprint.

I don't know if it fits will with your plans though.

> I know there is a problem with it, it has been discussed before on this
> list, look at this thread: http://marc.info/?t=121767492900001&r=1&w=2 but
> that's a bit of a different problem from what you are trying to do in your
> patch, AFAICS. And why are you trying to switch to some multiple arrays
> and bitmaps instead of the curent array / list of structs?

Sorry about the rough code. =) The arrays should contain centralized
knowledge about the different formats.  And I'm just using a single
bitmap to represent the supported modes that both the sensor and the
host support. Doing set_bit()/clear_bit() on a bitmap to enable and
disable formats is much easier compared to searching and modifying
lists. It's also O(1), but I don't think scalability matters here. =)

> As for the format negotation code we have been discussing in that thread,
> unfortunately, up to now I haven't found time to try and implement it, and
> now my schedule doesn't look better than then:-( I'll see if I can find
> some time during the 2.6.29 development time-frame (i.e., before 2.6.28 is
> released), but, unfortunately, cannot promise anything.

That's ok. I understand you're busy. =)

> But that is not your problem anyway, or is it?

No? I need to add NVxx support to the CEU driver, and to add that
cleanly it would be great with a simple way to represent the pixel
formats that are supported. I think the lists of structs are overly
complicated, and if Hans is rewriting things maybe the bitmap strategy
fits well, I'm not sure.

Apart from that, I can probably convince my employer that I should
spend a bit of time on this. =)

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
