Return-path: <linux-media-owner@vger.kernel.org>
Received: from ks4004239.ip-142-4-213.net ([142.4.213.193]:50693 "EHLO
	mon.libertas-tech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaANAs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 19:48:58 -0500
To: =?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: Support for Empia 2980 video/audio capture chip set
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 13 Jan 2014 19:48:42 -0500
From: Keith Lawson <keith.lawson@libertas-tech.com>
Cc: linux-media@vger.kernel.org, linux-media-owner@vger.kernel.org
Reply-To: keith.lawson@libertas-tech.com
In-Reply-To: <52D2C929.9080109@googlemail.com>
References: <1ed89f5b0a32bf26e17cee890a26b012@www.nowhere.ca>
 <52D2C929.9080109@googlemail.com>
Message-ID: <de907f83197624a31fc6690a43a21929@www.nowhere.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-01-12 11:56, Frank Schäfer wrote:

> On 09.01.2014 02:02, Keith Lawson wrote:
> 
>> Hello, I sent the following message to the linux-usb mailing list and 
>> they suggested I try here. I'm trying to get a "Dazzle Video Capture 
>> USB V1.0" video capture card working on a Linux device but it doesn't
>> look like the chip set is supported yet. I believe this card is the 
>> next version of the Pinnacle VC100 capture card that worked with the 
>> em28xx kernel module. The hardware vendor that sold the card says that
>> this device has an Empia 2980 chip set in it so I'm inquiring about 
>> support for that chip set. I'm just wondering about the best approach 
>> for getting the new chip supported in the kernel. Is this something 
>> the
>> em28xx maintainers would naturally address in time or can I assist in 
>> getting this into the kernel? Here's dmesg from the Debian box I'm 
>> working on: [ 3198.920619] usb 3-1: new high-speed USB device number 5
>> usingxhci_hcd [ 3198.939394] usb 3-1: New USB device found, 
>> idVendor=1b80,idProduct=e60a [ 3198.939399] usb 3-1: New USB device 
>> strings: Mfr=0, Product=1,SerialNumber=2 [ 3198.939403] usb 3-1: 
>> Product: Dazzle
>> Video Capture USB Audio Device [ 3198.939405] usb 3-1: SerialNumber: 0 
>> l440:~$ uname -a Linux l440 3.10-3-amd64 #1 SMP Debian 3.10.11-1 
>> (2013-09-10) x86_64 GNU/Linux If this isn't the appropriate list to 
>> ask
>> this question please point me in the right direction. Thanks, Keith
> 
> 
> The em28xx is indeed the dedicated driver for this device, but it's 
> hard
> to say how much work would be necessary to add support for it.
> We currently don't support any em29xx chip yet, but in theory it is 
> just
> an extended em28xx device.
> Whatever that means when it comes to the low level stuff... ;)
> 

What's the best route to get support for this chip added then? Should I 
start working on a patch myself or will this just happen during the 
course of development of the em28xx module? I'm a developer but haven't 
done any kernel hacking so this would likely be a steep learning curve 
for me.

> Regards,
> Frank
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html [1]



Links:
------
[1] http://vger.kernel.org/majordomo-info.html
