Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60587 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZGaIiS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 04:38:18 -0400
Date: Fri, 31 Jul 2009 10:38:08 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: amol verule <amol.debian@gmail.com>
Cc: Denis Loginov <dinvlad@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: driver for 041e:4055 Creative Technology, Ltd Live! Cam Video
 IM
Message-ID: <20090731103808.46480a31@tele>
In-Reply-To: <77ca8eab0907302124n50bb8122p128f6f6934b2faf5@mail.gmail.com>
References: <200907261604.30661.dinvlad@gmail.com>
	<77ca8eab0907302124n50bb8122p128f6f6934b2faf5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 31 Jul 2009 09:54:19 +0530
amol verule <amol.debian@gmail.com> wrote:

> thanks denis,
>                        after following these steps it worked me to
> detect device but not to read or get picture from device. it is
> giving error as usb 5-5: new high speed USB device using ehci_hcd and
> address 3 usb 5-5: configuration #1 chosen from 1 choice
> Linux video capture interface: v2.00
> gspca: main v2.7.0 registered
> gspca: probing 041e:4055
> zc3xx: Sensor Tas5130 (VF0250)
> gspca: probe ok
> usbcore: registered new interface driver zc3xx
> zc3xx: registered
> usb 5-5: USB disconnect, address 3
> gspca: usb_submit_urb alt 2 err -19
> gspca: disconnect complete
> gspca: open failed err -19
> gspca: open failed err -19
>                                what this error means ..i think
> problem in device driver it is not able to open device..how to
> resolve this error???
>  
> On Sun, Jul 26, 2009 at 6:34 PM, Denis Loginov <dinvlad@gmail.com>
> wrote:
> 
> > Actually, according to http://linux-uvc.berlios.de/ , you can just
> > try 'USB
> > Video Class' Driver, i.e. Device Drivers -> Multimedia Devices ->
> > Video Capture Adapters -> V4L USB Devices -> (M) USB Video Class
> > (UVC) & (y) UVC input events device support
> > (CONFIG_USB_VIDEO_CLASS=m & USB_VIDEO_CLASS_INPUT_EVDEV=y).

Hello Amol and Denis,

This webcam is not handled by gspca (it is VF0230, and not VF0250).

I already got a usbsnoop and I may say that it if not UVC compliant too.

With the usbsnoop and the register names in the V0230Dev.inf of the
ms-win driver, it should be easy to create a new driver, but:

- it seems it asks for a firmware which may be copyrighted,

- the images are compressed and the encoding is not known...

BTW, the linux video stuff is now discussed in the linux-media mailing
list (see Cc:).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
