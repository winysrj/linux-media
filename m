Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:43898 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaJPVks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 17:40:48 -0400
Received: by mail-yh0-f50.google.com with SMTP id a41so2380221yho.37
        for <linux-media@vger.kernel.org>; Thu, 16 Oct 2014 14:40:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5440362F.5040306@riseup.net>
References: <5440362F.5040306@riseup.net>
Date: Thu, 16 Oct 2014 17:40:47 -0400
Message-ID: <CALzAhNW7szuUJK-as48dTHE6Acx_7Ka195MXKdk-V8AjRjfauA@mail.gmail.com>
Subject: Re: GrabBee-HD
From: Steven Toth <stoth@kernellabs.com>
To: dave.kimble@riseup.net
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, no nobody jumped in the first time around..... my turn I guess... :)

Comments below.

On Thu, Oct 16, 2014 at 5:18 PM, Dave Kimble <dave.kimble@riseup.net> wrote:
> I have just bought an HDMI to USB-2.0 grabber called "GrabBee-HD".
> http://www.greada.com/grabbeex-hd.html
> Motherboard photo: http://www.davekimble.org.au/computers/GrabBee-HD.jpg
> Inside it has chips labelled "Sigma PL330B-CPE3" and "iTE IT6604E".
> Note that it compresses the video with H.264 .

I've worked on drivers for those two chips in the past. I have a large
amount of experience with these parts.

>
> I knew it probably wouldn't have drivers for Linux, but it does have Windows
> drivers on CD,
> so since I run Ubuntu-VirtualBox-WinXP I thought it might well work one way
> or another.

Correct, no Linux drivers.

>
> On Ubuntu 14.04, the USB device is picked up:
> $ lsusb -v -d 0658:1100
>

<snip>

>
> but it is not recognised as a video capture device by VLC.
> /dev/dvb/ , /dev/v4l/ , /dev/video0 do not exist.

Correct. Linux has no support for that device. :(

>
> So I fired up VB-WinXP and installed the Windows drivers and software, and
> restarted.
> Then plugged in the device, which should connect the device to the driver,
> but it didn't.

That's odd. It suggests an (off topic) windows related driver problem,
or a virtual machine issue.

> Starting the Grabbee-HD software gives "No video capture device is
> connected!"
> Then I realised the USB device has to be passed through the VB interface,
> VB-Manager > USB > Add > "no devices available".
>
> So because Ubuntu doesn't properly recognise the device, it can't pass it on
> to VB and XP.

I don't think the virtual machines work that way, at least not in my
experience. I've always been able to do what you want to do on various
platforms. Sorry, I can't really help you debug Windows / Virtual
machine issues.

>
> Is there any chance of getting this going on Ubuntu 14.04 natively?

Unlikely. Sigma are generally GPL unfriendly.

I've done drivers for this chip on OSX before, mostly as a R&D
exercise, so I'm highly familiar with it. The chip is a monster to
write for, kinda nasty to be honest - not very straightforward.

I think you're out of luck.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
