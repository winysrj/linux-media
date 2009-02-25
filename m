Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:43885 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZBYGHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 01:07:47 -0500
Date: Wed, 25 Feb 2009 00:19:35 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Adam Baker <linux@baker-net.org.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
In-Reply-To: <49A4B4FC.9030209@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0902242341070.15857@banach.math.auburn.edu>
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <20090223080715.0c97774e@pedra.chehab.org> <200902232237.32362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu>
 <alpine.LRH.2.00.0902241723090.6831@pedra.chehab.org> <alpine.LNX.2.00.0902241449020.15189@banach.math.auburn.edu> <alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org> <49A4B4FC.9030209@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 25 Feb 2009, Thomas Kaiser wrote:

>>> Also an overview is often very helpful. Also trying to visualize what 
>>> might be needed in the future is helpful. All of this can be extremely 
>>> helpful. But not everyone can see or imagine every possible thing. For 
>>> example, it seems that some of the best minds in the business are stunned 
>>> when confronted with the fact that some manufacturer of cheap electronics 
>>> in Taiwan has produced a lot of mass-market cameras with the sensors 
>>> turned upside down, along with some other cameras having the same USB ID 
>>> with different sensors, which act a bit differently. Clearly, if such a 
>>> thing happened once it can happen again. So how to deal with such a
>>> problem?
>
> Actually, this happens and is happening!
>
> Just step back a get an other view.

I had plenty of other views. SQ905, SQ905C, MR97310, SN9C2028, and one or 
two more. And, oh yes, the GT8290 chip on which Grandtech went broke, 
which was intended for mass storage still cameras but had a 32-bit CBW 
instead of a 31-bit CBW (off by one error and nobody caught it).

>
> These consumer products are manly produced for the Windoz audience.


Very true. Usually, it even says on the package that it will not work on 
Mac. But since Linux is unmentionable they did not say anything about it. 
So we make it work anyway.

>
> After introduction of Win XP the consumer where told that USB device will run 
> out of the box in Win XP,

Not all devices. Perhaps what they really meant is now you don't need to 
install two drivers if you have two Mass Storage Transparent Scsi Bulk 
Transport flash drives. To that extent, it seems that they were truthful. 
There are lots of proprietary devices out there for which AFAICT the 
drivers are still not included in Windows. Some of these are unfinished 
projects of mine, too, such as the JL2005C cameras. The big bugbear with 
those is the compression algorithm. It is a horror.

> which is sometimes true, but .....
>
> But on all (Windowz) Webcams (are Linux Webcams available?) I buy, I find a 
> sticker which tells me to first insert the driver CD before connecting the 
> cam to the PC. When you do, like instructed, your cam works like you 
> expected!

Of course. Hardware will not work without a driver.

>
> Evan the USB ID is the same like the other webcam from the other vendor, you 
> are (more or less) forced to install the driver from this particular vendor, 
> you get a new driver!

Not true. Windows, even back in the days of Windows 98, searched for the 
Vendor:Product number to look for the driver. There were several places to 
search for the number. For example, the INF files. And I have a box full 
of SQ905 cameras for which I will personally guarantee that every one of 
them will work on Windows 98 with the Windows driver from the CD that came 
with any other one. Now, if the picture is always facing in the right 
direction, that is another question, naturally.

Doesn't matter if the sensor is mounted upside down, 
> the "new" driver takes care about this. So, it looks like the cam in the 
> Windowz World just works because you were forced to install the driver from 
> the CD.

And while we are on that topic, I could definitely assert that not always 
did the "manufacturer" get this right, either. I, recall, developed the 
original SQ905 stillcam driver for Linux. I got letters from users and 
sample photos, too, where the photos came out of the camera and lettering 
on a sign visible in the photo was bass ackwards. They were cheap cameras, 
and the people who sold some of them were just a little bit sloppy. Their 
virtue, as cheap cameras go, was comparatively good optics in some of 
them. I have seen lots of cameras about the same price, which had much 
more features and much worse pictures.

>
> So I guess the Windoz diver just knows more then the USB ID.

No, not really. See above.

>
> In the Linux World most of the drive are re-engineered, we don't know how to 
> detect how the sensor is mounted, do we?


Well, yes, we do. And that is what this discussion was about. How to use 
that knowledge constructively while writing a kernel driver.

>
> Actually, what I try to say, is that only the cam can know how the sensor is 
> mounted. Thus, the kernel module has to provide this information to user 
> space (by query the hardware).

Well, that is more like it. Yes, one does have to ask the camera. But the 
camera will tell its answer truthfully. And this is before any streaming 
and image processing has started, too. What a deal.

>
> The "pivot" is an other thing.

Very true. And worth paying attention to. But it is not the same issue.

>
> Thomas
>

Theodore Kilgore
