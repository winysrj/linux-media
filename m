Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:44093 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZENTnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:43:32 -0400
Date: Thu, 14 May 2009 14:57:07 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: MK <halfcountplus@intergate.com>,
	=?ISO-8859-15?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: working on webcam driver
In-Reply-To: <4A0C544F.1030801@hhs.nl>
Message-ID: <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu>
References: <1242316804.1759.1@lhost.ldomain> <4A0C544F.1030801@hhs.nl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-437820711-1242329111=:11396"
Content-ID: <alpine.LNX.2.00.0905141425290.11396@banach.math.auburn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-437820711-1242329111=:11396
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0905141425291.11396@banach.math.auburn.edu>



On Thu, 14 May 2009, Hans de Goede wrote:

> On 05/14/2009 06:00 PM, MK wrote:
>> Since I'm cross-posting this (as advised) I should introduce myself by
>> saying I am a neophyte C programmer getting into kernel programming by
>> trying to write a driver for an unsupported webcam.  So far I've gotten
>> the device to register and have enumerated the various interfaces.
>> 
>> On 05/11/2009 02:50:00 PM, Erik Andrén wrote:
>>> First of all, this list is deprecated. Send mails to
>>> linux-media@vger.kernel.org if you want to reach the kernel community.
>>> 
>>> Secondly, have you researched that there is no existing driver for
>>> your camera? A good way to start would perhaps to search for the usb
>>> id and linux in google to see if it generates some hits.
>> 
>> I've done this last bit already, and I just checked out gspca.  There
>> is a loit of listing for the vendor id, but not the product id, so I
>> imagine there is no point in trying any of the drivers (unless I hack
>> the source to accept the id string).
>> 
>> However, a rather unhelpful person at the linux driver backport group
>> informs me "not all USB video drivers are under
>> drivers/media/video/usbvideo/  In fact, the majority of them are not."
>> but then tells me I should take off and go find them myself "with a web
>> browser" (very nice).
>> 
>> Does anyone know where these drivers are located?
>
> Most non yvc (see below) usb webcams are driven through the gspca usb
> webcam driver framework. This is a v4l driver which consists of gspca-core
> + various subdrivers for a lot of bridges, see drivers/media/video/gspca
>
>
>  The same person also
>> claims that the kernel now has support "for all devices that
>> follow the USB video class specification, and [sic] that the additional
>> 23 device specific drivers in the tree* are just for non-conforming
>> devices".
>
> This is correct recently the USB consortium (or whatever they are called)
> have created a new spec called UVC, this is one standard protocol for all
> webcams to follow. All *newer* webcams use this, but a lot of cams still
> in the stores predate UVC (which stands for USB Video Class).
>
> The first thing to find out to get your webcam supported is what kind of
> bridge chip it is using, try looking at the windows driver .inf file,
> typical bridges are the sonix series (often refenced to as sn9c10x or
> sn9c20x), spca5xx series, zc3xx, vc032x, etc. If you see a reference
> to anything like this in the windows driver .inf file (or inside dll's)
> that would be good to know. Also it would be very helpful to have the usb
> id of your camera.
>
> Regards,
>
> Hans

All of the above is excellent advice, especially in view of the fact that 
you say, "There is a lot of listing for the vendor id, but not the product 
id, so I imagine there is no point in trying any of the drivers (unless I 
hack the source to accept the id string)," apparently with reference to 
the cameras supported by gspca.

>From there, things could go in several directions. First, it might 
possibly be the case that it suffices only to add the camera's Vendor and 
Product ID to an existing driver. Or, it might be a completely different 
one. Or, it might be that everything can be solved but for the fact that 
the camera is using an undocumented and unsolved compression algorithm, 
which is the ultimate obstacle to overcome and also the most difficult. 
Perhaps in addition to the list from Hans, above, an output of lsusb or 
the content of the /proc/bus/usb/devices file (available if your kernel 
supports usbfs, otherwise not) would help.

Finally, since you say that the Vendor ID appears, it could possibly be 
the case that someone is already working on support for your particular 
camera. The matter would be more clear if the Vendor and Product ID 
numbers are known.


Theodore Kilgore
---863829203-437820711-1242329111=:11396--
