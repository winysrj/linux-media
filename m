Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:59970 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbZENR0Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 13:26:24 -0400
Message-ID: <4A0C544F.1030801@hhs.nl>
Date: Thu, 14 May 2009 19:26:39 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: MK <halfcountplus@intergate.com>
CC: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: working on webcam driver
References: <1242316804.1759.1@lhost.ldomain>
In-Reply-To: <1242316804.1759.1@lhost.ldomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2009 06:00 PM, MK wrote:
> Since I'm cross-posting this (as advised) I should introduce myself by
> saying I am a neophyte C programmer getting into kernel programming by
> trying to write a driver for an unsupported webcam.  So far I've gotten
> the device to register and have enumerated the various interfaces.
>
> On 05/11/2009 02:50:00 PM, Erik Andrén wrote:
>> First of all, this list is deprecated. Send mails to
>> linux-media@vger.kernel.org if you want to reach the kernel community.
>>
>> Secondly, have you researched that there is no existing driver for
>> your camera? A good way to start would perhaps to search for the usb
>> id and linux in google to see if it generates some hits.
>
> I've done this last bit already, and I just checked out gspca.  There
> is a lot of listing for the vendor id, but not the product id, so I
> imagine there is no point in trying any of the drivers (unless I hack
> the source to accept the id string).
>
> However, a rather unhelpful person at the linux driver backport group
> informs me "not all USB video drivers are under
> drivers/media/video/usbvideo/  In fact, the majority of them are not."
> but then tells me I should take off and go find them myself "with a web
> browser" (very nice).
>
> Does anyone know where these drivers are located?

Most non yvc (see below) usb webcams are driven through the gspca usb
webcam driver framework. This is a v4l driver which consists of gspca-core
+ various subdrivers for a lot of bridges, see drivers/media/video/gspca


   The same person also
> claims that the kernel now has support "for all devices that
> follow the USB video class specification, and [sic] that the additional
> 23 device specific drivers in the tree* are just for non-conforming
> devices".

This is correct recently the USB consortium (or whatever they are called)
have created a new spec called UVC, this is one standard protocol for all
webcams to follow. All *newer* webcams use this, but a lot of cams still
in the stores predate UVC (which stands for USB Video Class).

The first thing to find out to get your webcam supported is what kind of
bridge chip it is using, try looking at the windows driver .inf file,
typical bridges are the sonix series (often refenced to as sn9c10x or
sn9c20x), spca5xx series, zc3xx, vc032x, etc. If you see a reference
to anything like this in the windows driver .inf file (or inside dll's)
that would be good to know. Also it would be very helpful to have the usb
id of your camera.

Regards,

Hans
