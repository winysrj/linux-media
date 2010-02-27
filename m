Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:37584 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968007Ab0B0JDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 04:03:47 -0500
Date: Sat, 27 Feb 2010 10:04:00 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca pac7302: allow controlling LED separately
Message-ID: <20100227100400.05fede81@tele>
In-Reply-To: <4B88CF6C.2070703@redhat.com>
References: <4B84CC9E.4030600@freemail.hu>
	<20100224082238.53c8f6f8@tele>
	<4B886566.8000600@freemail.hu>
	<4B88CF6C.2070703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 27 Feb 2010 08:53:16 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> This is true for a lot of cameras, so if we are going to add a way to
> support control of the LED separate of the streaming state, we
> should do that at the gspca_main level, and let sub drivers which
> support this export a set_led callback function.
> 
> I must say I personally don't see much of a use case for this feature,
> but I believe JF Moine does, so I'll leave further comments and
> review of this to JF. I do believe it is important that if we go this
> way we do so add the gspca_main level.

Hi,

I don't like this mechanism to switch on or off the webcam LEDs. Here
are some arguments (some of them were sent last year to the list):

1) End users.

Many Linux users don't know the kernel internals, nor which of the too
many applications they should use to make their devices work. 

Actually, there are a few X11 programs in common Linux distros which can
handle the webcam parameters: I just know about vlc and v4l2ucp, and
they don't even handle the VIDIOC_G_JPEGCOMP and VIDIOC_S_JPEGCOMP
ioctls which are part of the v4l2 API.

The LED interface uses the /sys file system. Will the webcam programs
offer access to this interface? I don't believe it. So, the users will
have to search how they can switch on or off the LEDs of their webcams,
and then, when found, they should start a X terminal and run a command
to do the job!

On the other hand, a webcam LED control, whether general or private, is
available in the graphical interface as soon as the driver offers it.

2) Memory overhead.

Using the led class adds more kernel code and asks the webcam drivers
to create a new device. Also, the function called for changing the LED
brighness cannot sleep, so the use a workqueue is required.

On contrary, with a webcam control, only one byte (for 8 LEDs) is added
to the webcam structure and the change is immediatly done in the ioctl.

3) Development.

If nobody wants a LED control in the v4l2 interface, I think the code
added to access the led class could be splitted between the different
subsystem. For example, the workqueue handling could be done in the led
class itself...

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
