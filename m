Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9H6oxqP018752
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 02:51:00 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9H6ojTs030282
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 02:50:46 -0400
Date: Fri, 17 Oct 2008 08:50:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <aec7e5c30810161947n57851272i4204dcce515a8ec4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810170844420.4600@axis700.grange>
References: <u63nt9mvx.wl%morimoto.kuninori@renesas.com>
	<20081016102701.1bcb2c59.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0810162114030.8422@axis700.grange>
	<200810162258.28993.hverkuil@xs4all.nl>
	<aec7e5c30810161947n57851272i4204dcce515a8ec4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hi Magnus,

On Fri, 17 Oct 2008, Magnus Damm wrote:

> Hans,  any chance of that framework including pixel format helper
> code? I've hacked a bit on using a bitmap to represent pixel formats
> supported by a certain driver. The attached very rough patch maybe
> shows what i'm trying to do.
> 
> Basically, I need a simple way to determine if a camera sensor
> supports a certain pixel format, and if so then i'd like to add a
> bunch of pixel formats supported by the soc_camera host.

Thanks for the code, but, unfortunately, I don't understand what you are 
trying to do there, and why the current soc-camera pixel-format 
enumeration code doesn't suit your needs.

I know there is a problem with it, it has been discussed before on this 
list, look at this thread: http://marc.info/?t=121767492900001&r=1&w=2 but 
that's a bit of a different problem from what you are trying to do in your 
patch, AFAICS. And why are you trying to switch to some multiple arrays 
and bitmaps instead of the curent array / list of structs?

As for the format negotation code we have been discussing in that thread, 
unfortunately, up to now I haven't found time to try and implement it, and 
now my schedule doesn't look better than then:-( I'll see if I can find 
some time during the 2.6.29 development time-frame (i.e., before 2.6.28 is 
released), but, unfortunately, cannot promise anything.

But that is not your problem anyway, or is it?

Thanks
Guennadi

> The SuperH CEU "Capture Engine Unit" has a mode where it accepts
> interleaved YUV pixel formats as input from the camera sensor and
> converts them to one of NV12, NV21 or a less common 4:2:2 format maybe
> known as NV16, NV61. So I need a simple way to check and add pixel
> formats by the soc_camera host driver.
> 
> Also, having a centralized place for pixel format strings, color depth
> and colorspaces associated with each of the pixel formats makes sense
> to me. Any thoughts? Want me to hack something up?
> 
> Cheers,
> 
> / magnus
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
