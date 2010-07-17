Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44876 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab0GQI5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jul 2010 04:57:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Kromer <michael.kromer@topalis.com>
Subject: Re: Chicony Electronics 04f2:b1b4 webcam device unsupported (yet)
Date: Sat, 17 Jul 2010 10:57:26 +0200
Cc: Pete Eberlein <pete@sensoray.com>, linux-media@vger.kernel.org
References: <OF56E589E0.BB18B6B2-ONC1257762.005AE925-C1257762.005AE95B@topalis.com> <1279300489.1989.4.camel@pete-desktop> <4C416B0C.4050608@topalis.com>
In-Reply-To: <4C416B0C.4050608@topalis.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007171057.27325.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Saturday 17 July 2010 10:34:20 Michael Kromer wrote:
> On 07/16/2010 07:14 PM, Pete Eberlein wrote:
> > On Fri, 2010-07-16 at 18:32 +0200, Michael Kromer wrote:
> >> 
> >> I have bought myself a rather new Lenovo Thinkpad X100e, and there is no
> >> support for the webcam device in the current (2.6.34) kernel (yet).
> >> 2.6.35 doesn't seem to have a driver for it either. Is there any
> >> possibility for one of you guys to take a look at it?
> > 
> > The descriptors look like a standard USB Video Class device.  Do you
> > have the uvcvideo module loaded?  Then have a look at your dmesg output
> > to see why it isn't working.
> 
> my problem is:
> 
> [ 2578.903972] uvcvideo: Found UVC 1.00 device Integrated Camera
> (04f2:b1b4) [ 2578.905121] input: Integrated Camera as
> /devices/pci0000:00/0000:00:13.2/usb2/2-2/2-2:1.0/input/input10
> [ 2578.905224] usbcore: registered new interface driver uvcvideo
> [ 2578.905228] USB Video Class driver (v0.1.0)
> 
> It is indeed registred as video device, however, everytime i use some
> program (i tried cheese) to use /dev/video0 I get the following:
> 
> [ 2741.757993] uvcvideo: Failed to query (130) UVC control 5 (unit 3) :
> -32 (exp. 1).

Could you please send me the output of

lsusb -v -d 04f2:b1b4

-- 
Regards,

Laurent Pinchart
