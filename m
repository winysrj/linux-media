Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:21699 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbZIAXKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 19:10:23 -0400
Message-ID: <4A9DA9D4.6010506@am.sony.com>
Date: Tue, 1 Sep 2009 16:10:12 -0700
From: Tim Bird <tim.bird@am.sony.com>
MIME-Version: 1.0
To: Jim Paris <jim@jtan.com>
CC: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org, moinejf@free.fr
Subject: Re: [Fwd: How to debug problem with Playstation Eye webcam?]
References: <1251508203.3200.34.camel@palomino.walls.org> <20090829173527.5cb7fb76.ospite@studenti.unina.it> <20090829163211.GA23792@psychosis.jim.sh>
In-Reply-To: <20090829163211.GA23792@psychosis.jim.sh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jim and Antonio,

Thanks very much for the suggestions!  I got it working with
luvcview!  See below for some details.

Jim Paris wrote:
> Antonio Ospite wrote:
>> before doing any further investigation about code in 2.6.29.4, forgive
>> the silly question: is using a more recent kernel/driver an option for
>> you?
>>
>> I've just tried latest code from v4l-dvb and it "just works" with the
>> applications I use. You can get the mercurial repository here
>> http://linuxtv.org/hg/v4l-dvb
>>
>> I know that there was a regression in 2.6.30 (not sure about 2.6.29.4)
>> and a patch has been sent by Jim Paris to fix it, I don't know if it is
>> already in a 2.6.30.x release, tho. The change is this one:
>> http://patchwork.kernel.org/patch/42114/
> 
> I believe 2.6.29.4 should be okay.  However, the Fedora folks might
> have pulled some newer patches which also added the bug.  You might
> try a stock 2.6.29.4 kernel instead of Fedora's, or just apply the
> patch that Antonio refers to (if thta's the problem).

I found that Fedora 11 did indeed have the code that the patch fixes.
That is, it was using a payload length of 2040 instead of 2048.

I downloaded the fedora kernel source and rebuilt the kernel
with the patch applied.

> If your kernel does have the same bug, the symptoms would be as you
> described, with the camera's red LED turning on during an attempted
> capture.  Do you get the red LED?

Yes, I get the red LED.

> You would also probably see the same problem, regardless of kernel
> version, if the camera were connected to a full-speed instead of
> high-speed USB port.
I checked, and the USB port is high speed and the camera connects
at high speed.

usbtree reports:

/: Bus 05.Port 1: Dev 1, Class=root_hub, Drv=uhci_hcd/2p, 12M
/: Bus 04.Port 1: Dev 1, Class=root_hub, Drv=uhci_hcd/2p, 12M
    |_ Port 2: Dev 2, If 0, Prod=Dell USB Mouse, Class=HID, Drv=usbhid, 1.5M
/: Bus 03.Port 1: Dev 1, Class=root_hub, Drv=uhci_hcd/2p, 12M
    |_ Port 2: Dev 2, If 0, Prod=DELL USB Keyboard, Class=HID, Drv=usbhid, 1.5M
/: Bus 02.Port 1: Dev 1, Class=root_hub, Drv=uhci_hcd/2p, 12M
/: Bus 01.Port 1: Dev 1, Class=root_hub, Drv=ehci_hcd/8p, 480M
    |_ Port 8: Dev 10, If 0, Prod=USB Camera-B4.04.27.1, Class=vend., Drv=ov534, 480M
    |_ Port 8: Dev 10, If 1, Prod=, Class=audio, Drv=snd-usb-audio, 480M
    |_ Port 8: Dev 10, If 2, Prod=, Class=audio, Drv=snd-usb-audio, 480M

>> I tested the driver with "mplayer" and "luvcview" during development,
>> and I am now using it with "cheese", I've never run v4l-test.
> 
> Agreed.  luvcview is probably the easiest to test with, and I can
> provide command lines for mplayer, ffmpeg, etc, if necessary.

I had 2 test programs.  One runs OK and one still hangs (probably
a bug on my part since I'm new with v4l.)

Cheese and luvcview work great.

Thanks very much for your help!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

