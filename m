Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42367 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbZF2LdC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 07:33:02 -0400
Subject: Re: [linux-dvb] USBVision device defaults
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com>
References: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 07:33:55 -0400
Message-Id: <1246275235.3917.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-29 at 11:34 +0100, Tim Williams wrote:
> Hello,
> 
> I'm trying use a WinTV USB adaptor which uses the usbvision driver to 
> capture the output of a video camera for streaming across the web, the 
> idea being that there is a reliable local recording, even in the event of 
> a computer crash, while allowing the remote viewers to see the proceedings 
> live without needing to have two separate cameras.
> 
> Unfortunately there is a catch, i'm using flash to do the broadcast 
> and flash (in common with a lot of other software of this type) doesn't 
> have the ability to set the input type and picture format, so you are 
> stuck with the default, which is the rf-tuner. I have managed to make my 
> own bodged driver which disables the rf-input so that I can get a picture 
> via s-video, but it is stubbornly stuck in black and white, which i'm 
> assuming is some kind of colour format problem.
> 
> If I use KDETV to look at the picture then everything comes through in 
> colour, so this would seem to be a problem with the defaults built into 
> the module being incorrect for my circumstances. Rather than carrying on 
> with my bodged driver (this is the first time I have ever attempted to 
> modify a C programme), what would be really great is away to achieve one 
> of the following :
> 
> 1) Set the default input, tv standard and pixel format using module 
> parameters in modprobe.conf

Some modules may do a subset of these things, but generally it is never
necessary.



> 2) Get the driver to 'remember' it's current settings when switching 
> between applications. The windows driver for these devices does this, so 
> all I have to do under windows is start up WinTV, make sure I have a good 
> picture, close it down again and then start up the video broadcast in 
> flash.

According to the V4L2 specification for the close() call, all devices
should remember their settings.

There have been recent discussions on devices that do power management
not saving the RF tuner freq after the final close() (and what to do
about it), but the last input and standard should be preserved.  (Note,
I have not looked at the usbvision driver to look for problems.)

What precise WinTV USB device/verision are you using?


> 3) A way to change the device settings using a 3rd party app even when the 
> main video device is in use and can't be accessed.

All v4l2 devices are multiple-open(); they can always be accessed by
multiple apps.  Changing hardware parameters while a device is streaming
is usually bad and not allowed by the device driver and/or hardware.


> I've tried using v4lctl 
> to set the parameters before starting a capture, but if the flash capture 
> is active, then I (unsurprisingly) get device in use errors.

Most devices will return an -EBUSY for various operations that can't be
performed when a capture is in progress - no surprise.


>  If I use v4lctl 
> before starting flash, then the settings don't stick. The capture box becomes 
> active briefly (there is a red light on the box which indicates this), 
> presumably accepts the setting and is then powered down again, causing 
> the new setting to be immediately forgotten.

The device driver should not forget them.

Try something like:

$ v4l2-ctl --help
$ v4l2-ctl -d /dev/video0 --log-status
$ v4l2-ctl -d /dev/video0 --list-inputs
$ v4l2-ctl -d /dev/video0 --set-input=2
$ v4l2-ctl -d /dev/video0 --log-status

The second "log-status" should show you that your change took effect and
stayed.  If not, the usbvision driver has a problem.

Regards,
Andy

> Any thoughts or help would be much appreciated.
> 
> Tim W
> 

