Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp9.trip.net ([216.139.64.9]:60778 "EHLO smtp9.trip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZENQYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 12:24:17 -0400
Date: Thu, 14 May 2009 12:00:04 -0400
From: MK <halfcountplus@intergate.com>
Subject: Re: working on webcam driver
To: Erik =?iso-8859-1?q?Andr=E9n?= <erik.andren@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <62e5edd40905111150p4e2dce52wba2b19d15c1e407a@mail.gmail.com>
Message-Id: <1242316804.1759.1@lhost.ldomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since I'm cross-posting this (as advised) I should introduce myself by 
saying I am a neophyte C programmer getting into kernel programming by 
trying to write a driver for an unsupported webcam.  So far I've gotten 
the device to register and have enumerated the various interfaces.

On 05/11/2009 02:50:00 PM, Erik Andrén wrote:
>First of all, this list is deprecated. Send mails to
>linux-media@vger.kernel.org if you want to reach the kernel community.
>
> Secondly, have you researched that there is no existing driver for
> your camera? A good way to start would perhaps to search for the usb
> id and linux in google to see if it generates some hits.

I've done this last bit already, and I just checked out gspca.  There 
is a lot of listing for the vendor id, but not the product id, so I 
imagine there is no point in trying any of the drivers (unless I hack 
the source to accept the id string).

However, a rather unhelpful person at the linux driver backport group 
informs me "not all USB video drivers are under
drivers/media/video/usbvideo/  In fact, the majority of them are not." 
but then tells me I should take off and go find them myself "with a web 
browser" (very nice).  

Does anyone know where these drivers are located?  The same person also 
claims that the kernel now has support "for all devices that 
follow the USB video class specification, and [sic] that the additional 
23 device specific drivers in the tree* are just for non-conforming 
devices".  This kind of flies in the face of everything else I have 
read about linux and usb webcams.  I also notice that it is impossible 
to select anything other than the v4l layer with "xconfig", ie. the 
individual drivers cannot be selected.

Is it normal to include module sources in the tree without making it 
possible to configure them into a regular build?

Sincerely, Mark Eriksen

*I can only find the six under drivers/media, and nothing in 
documentation/ is of assistance


