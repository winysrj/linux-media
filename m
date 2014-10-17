Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:57028 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaJQH3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 03:29:33 -0400
Message-ID: <5440C555.2040308@riseup.net>
Date: Fri, 17 Oct 2014 17:29:25 +1000
From: Dave Kimble <dave.kimble@riseup.net>
Reply-To: dave.kimble@riseup.net
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: Re: GrabBee-HD
References: <5440362F.5040306@riseup.net> <CALzAhNW7szuUJK-as48dTHE6Acx_7Ka195MXKdk-V8AjRjfauA@mail.gmail.com>
In-Reply-To: <CALzAhNW7szuUJK-as48dTHE6Acx_7Ka195MXKdk-V8AjRjfauA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your reply.
Your feeling that VB-WinXP would be the problem sent me back to that.
So I found that VB picking up USB 2.0 devices requires the Extension 
Pack installed with ehci controller enabled , and that cured that 
problem, and the device now finds it's XP driver.

The grabber software loads OK and asks for the signal information. Since 
the software goes with this particular device, I am surprised at this - 
it should know it already, shouldn't it?

Although the software's input is the device's output, it also seems to 
depend on the device's input, i.e. the HDMI stream.This stream comes via 
satellite dish and decoder box, and is picking up Freeview channels in 
Australia.

Almost all of the options produce the error: "Sigma Designs USB Device 
device does not active or error !" [sic]
The best combination of options produces a good picture, but it moves 
very slowly and after a few seconds freezes.
XP cannot then terminate the process, and neither can VB > Close.
So I have to VB > Reset
Then Ubuntu loses the device from lsusb and it needs too be unplugged 
and plugged in again, and VB-WinXP started again.

Any assistance would be welcome - as you can probably tell, I really 
don't know what I'm doing.

Dave

On 17/10/14 07:40, Steven Toth wrote:
> Ok, no nobody jumped in the first time around..... my turn I guess... :)
>
> Comments below.
>
> On Thu, Oct 16, 2014 at 5:18 PM, Dave Kimble<dave.kimble@riseup.net>  wrote:
>> I have just bought an HDMI to USB-2.0 grabber called "GrabBee-HD".
>> http://www.greada.com/grabbeex-hd.html
>> Motherboard photo:http://www.davekimble.org.au/computers/GrabBee-HD.jpg
>> Inside it has chips labelled "Sigma PL330B-CPE3" and "iTE IT6604E".
>> Note that it compresses the video with H.264 .
> I've worked on drivers for those two chips in the past. I have a large
> amount of experience with these parts.
>
>> I knew it probably wouldn't have drivers for Linux, but it does have Windows
>> drivers on CD,
>> so since I run Ubuntu-VirtualBox-WinXP I thought it might well work one way
>> or another.
> Correct, no Linux drivers.
>
>> On Ubuntu 14.04, the USB device is picked up:
>> $ lsusb -v -d 0658:1100
>>
> <snip>
>
>> but it is not recognised as a video capture device by VLC.
>> /dev/dvb/ , /dev/v4l/ , /dev/video0 do not exist.
> Correct. Linux has no support for that device. :(
>
>> So I fired up VB-WinXP and installed the Windows drivers and software, and
>> restarted.
>> Then plugged in the device, which should connect the device to the driver,
>> but it didn't.
> That's odd. It suggests an (off topic) windows related driver problem,
> or a virtual machine issue.
>
>> Starting the Grabbee-HD software gives "No video capture device is
>> connected!"
>> Then I realised the USB device has to be passed through the VB interface,
>> VB-Manager > USB > Add > "no devices available".
>>
>> So because Ubuntu doesn't properly recognise the device, it can't pass it on
>> to VB and XP.
> I don't think the virtual machines work that way, at least not in my
> experience. I've always been able to do what you want to do on various
> platforms. Sorry, I can't really help you debug Windows / Virtual
> machine issues.
>
>> Is there any chance of getting this going on Ubuntu 14.04 natively?
> Unlikely. Sigma are generally GPL unfriendly.
>
> I've done drivers for this chip on OSX before, mostly as a R&D
> exercise, so I'm highly familiar with it. The chip is a monster to
> write for, kinda nasty to be honest - not very straightforward.
>
> I think you're out of luck.
>
> - Steve
>

