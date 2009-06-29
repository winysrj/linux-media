Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51323 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbZF2Tr6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 15:47:58 -0400
Date: Mon, 29 Jun 2009 21:47:47 +0200
From: Thierry MERLE <thierry.merle@free.fr>
To: linux-media@vger.kernel.org
Cc: tmw@autotrain.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USBVision device defaults
Message-ID: <20090629214747.2fba7b4a@lugdush.houroukhai.org>
In-Reply-To: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com>
References: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Mon, 29 Jun 2009 11:34:50 +0100 (BST)
Tim Williams <tmw@autotrain.org> wrote:

> 
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
> 2) Get the driver to 'remember' it's current settings when switching 
> between applications. The windows driver for these devices does this, so 
> all I have to do under windows is start up WinTV, make sure I have a good 
> picture, close it down again and then start up the video broadcast in 
> flash.
> 3) A way to change the device settings using a 3rd party app even when the 
> main video device is in use and can't be accessed. I've tried using v4lctl 
> to set the parameters before starting a capture, but if the flash capture 
> is active, then I (unsurprisingly) get device in use errors. If I use v4lctl 
> before starting flash, then the settings don't stick. The capture box becomes 
> active briefly (there is a red light on the box which indicates this), 
> presumably accepts the setting and is then powered down again, causing 
> the new setting to be immediately forgotten.
> 
> Any thoughts or help would be much appreciated.
> 
I remember a guy that did the trick with the vloopback device.
Searching a bit on the Internet, it seems that flashcam 
http://www.swift-tools.net/Flashcam/ can be convenient for your needs.
HTH
Regards,
Thierry
