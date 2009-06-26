Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f190.google.com ([209.85.216.190]:56236 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZFZF1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 01:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <4A43FD77.1020709@mlbassoc.com>
References: <4A43FD77.1020709@mlbassoc.com>
Date: Fri, 26 Jun 2009 14:27:15 +0900
Message-ID: <5e9665e10906252227i4f667915rc1b52d6148c1a0e9@mail.gmail.com>
Subject: Re: v4l2_int_device vs v4l2_subdev?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Fri, Jun 26, 2009 at 7:43 AM, Gary Thomas<gary@mlbassoc.com> wrote:
> Still trying to wrap my head around the OMAP/34xx camera support.
> I need to use the TVP5150 sensor/controller, but the existing
> driver uses v4l_subdev.  The "working" examples I've found
> (from Sergio's tree) use sensors like ov3640 with uses v4l2_int_device
>
> Are these two totally separate beasts?
> If I have an infrastructure (I assume) based on v4l2_int_device,
> how do I use a v4l2_subdev device driver?  or need I move one to
> the other?
>

I've been through the same case (now I'm trying to use subdev
framework and writing a new device driver based on that)
As far as I understand, every v4l2 drivers are moving on subdev
framework. But in user space there is nothing changed having access to
device and control them.
As you know, subdev and int-device is all about how to bind
interface(or host?) and device and make them communicated each other.
But using subdev device driver with int-device supporting interface
(or host) device driver? it won't make any communication.
So if you are running out of time with your project, you'd better use
old driver of TVP. Like TVP driver in kernel 2.6.28 I suppose. But if
you have enough time and wanna be challenging, try to convert
in-device based omap3 camera interface driver to subdev supporting
one.
Cheers,

Nate


> ... dizzy from traveling down too many twisty little passages :-(
>
> --
> ------------------------------------------------------------
> Gary Thomas                 |  Consulting for the
> MLB Associates              |    Embedded world
> ------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
