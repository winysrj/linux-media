Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64665 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaAOVgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 16:36:52 -0500
Message-ID: <52D6FFA8.8060008@googlemail.com>
Date: Wed, 15 Jan 2014 22:37:44 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: keith.lawson@libertas-tech.com
CC: linux-media@vger.kernel.org, linux-media-owner@vger.kernel.org
Subject: Re: Support for Empia 2980 video/audio capture chip set
References: <1ed89f5b0a32bf26e17cee890a26b012@www.nowhere.ca> <52D2C929.9080109@googlemail.com> <de907f83197624a31fc6690a43a21929@www.nowhere.ca>
In-Reply-To: <de907f83197624a31fc6690a43a21929@www.nowhere.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.01.2014 01:48, schrieb Keith Lawson:
> On 2014-01-12 11:56, Frank Schäfer wrote:
>
>> On 09.01.2014 02:02, Keith Lawson wrote:
>>
>>> Hello, I sent the following message to the linux-usb mailing list
>>> and they suggested I try here. I'm trying to get a "Dazzle Video
>>> Capture USB V1.0" video capture card working on a Linux device but
>>> it doesn't
>>> look like the chip set is supported yet. I believe this card is the
>>> next version of the Pinnacle VC100 capture card that worked with the
>>> em28xx kernel module. The hardware vendor that sold the card says that
>>> this device has an Empia 2980 chip set in it so I'm inquiring about
>>> support for that chip set. I'm just wondering about the best
>>> approach for getting the new chip supported in the kernel. Is this
>>> something the
>>> em28xx maintainers would naturally address in time or can I assist
>>> in getting this into the kernel? Here's dmesg from the Debian box
>>> I'm working on: [ 3198.920619] usb 3-1: new high-speed USB device
>>> number 5
>>> usingxhci_hcd [ 3198.939394] usb 3-1: New USB device found,
>>> idVendor=1b80,idProduct=e60a [ 3198.939399] usb 3-1: New USB device
>>> strings: Mfr=0, Product=1,SerialNumber=2 [ 3198.939403] usb 3-1:
>>> Product: Dazzle
>>> Video Capture USB Audio Device [ 3198.939405] usb 3-1: SerialNumber:
>>> 0 l440:~$ uname -a Linux l440 3.10-3-amd64 #1 SMP Debian 3.10.11-1
>>> (2013-09-10) x86_64 GNU/Linux If this isn't the appropriate list to ask
>>> this question please point me in the right direction. Thanks, Keith
>>
>>
>> The em28xx is indeed the dedicated driver for this device, but it's hard
>> to say how much work would be necessary to add support for it.
>> We currently don't support any em29xx chip yet, but in theory it is just
>> an extended em28xx device.
>> Whatever that means when it comes to the low level stuff... ;)
>>
>
> What's the best route to get support for this chip added then? Should
> I start working on a patch myself or will this just happen during the
> course of development of the em28xx module? I'm a developer but
> haven't done any kernel hacking so this would likely be a steep
> learning curve for me.

Can you create USB-Traces of the Windows driver and send us the output
of "lsusb -v -d 1b80:e60a" for this device ?
That will give us a hint how much work will be needed.

Regards,
Frank

