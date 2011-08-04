Return-path: <linux-media-owner@vger.kernel.org>
Received: from woodbine.london.02.net ([87.194.255.145]:48703 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1HDUlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 16:41:22 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Thu, 4 Aug 2011 21:35:15 +0100
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E398381.4080505@redhat.com> <20110804184020.6edb96d8@tele> <alpine.LNX.2.00.1108041358050.17533@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108041358050.17533@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108042135.15972.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 04 August 2011, Theodore Kilgore wrote:
> As far as I know, /dev/sdx signifies a device which is accessible by 
> something like the USB mass storage protocols, at the very least. So, if 
> that fits the camera, fine. But most of the cameras in question are Class 
> Proprietary. Thus, not in any way standard mass storage devices. Then it 
> is probably better not to call the new device by that name unless that 
> name really fits. Probably, it would be better to have /dev/cam or 
> /dev/stillcam, or something like that.

Correct and that is why this idea doesn't work - /dev/sdx needs to be a block 
device that can have a file system on it. These cameras don't have a 
traditional file system and there is a lot of code in gphoto to support all 
the different types of camera.

There does exist the possibility of a relatively simple fix - If libusb 
include a usb_reattach_kernel_driver_np call to go with the 
usb_detach_kernel_driver_np then once gphoto had finished with the device it 
could restore the kernel driver and webcam mode would work. Unfortunately the 
libusb devs don't want to support it in the 0.1 version of libusb that 
everyone uses and the reattach function needs knowledge of libusb internals to 
work reliably. 

I did come up with a hack that sort of worked but I never worked out how to 
clean it up to be acceptable to go upstream.

http://old.nabble.com/Re-attaching-USB-kernel-drivers-detached-by-libgphoto2-
td22978838.html

http://libusb.6.n5.nabble.com/re-attaching-after-usb-detach-kernel-driver-np-
td6068.html

Adam Baker
