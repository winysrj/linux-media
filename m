Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay03.digicable.hu ([92.249.128.185]:41475 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1JRUlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 16:41:13 -0400
Message-ID: <4E9DDE13.103@freemail.hu>
Date: Tue, 18 Oct 2011 22:14:11 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Lars Noschinski <lars@public.noschinski.de>
CC: linux-media@vger.kernel.org
Subject: Re: pac7311
References: <20111017060334.GA16001@lars.home.noschinski.de>
In-Reply-To: <20111017060334.GA16001@lars.home.noschinski.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

Lars Noschinski wrote:
> I'm using a webcam (Philipps SPC500NC) which identifies itself as
> 
>     093a:2603 Pixart Imaging, Inc. PAC7312 Camera
> 
> and is sort-of supported by the gspca_pac7311 module. "sort-of" because
> the image alternates quickly between having a red tint or a green tint
> (using the gspac driver from kernel 3.0.0, but this problem is present
> since at least 2.6.31).

The most important source code for your webcam is drivers/media/video/gspca/pac7311.c .
You can see it online at http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/media/video/gspca/pac7311.c .

> If I remove and re-plugin the camera a few times (on average around 3
> times), the colors are stable.

When you plug and remove the webcam and the colors are wrong, do you get any
message in the "dmesg"?

Once the colors are stable and you unplug and replug the webcam, what happens then?
Is there again around 3 times when the webcam is not working properly?

> Then a second issue becomes apparent:
> There is almost no saturation in the image. Toying around with Contrast,
> Gamma, Exposure or Gain does not help. What _does_ help is the Vflip
> switch: If I enable it, the image is flipped vertically (as expected),
> but also the color become a lot better.

Is there any difference when you use the "Mirror" control? What about the
combination of the "Vflip" and "Mirror" controls?

What about the "Auto Gain" setting? Is it enabled or disabled in your case?

> Is there something I can do to debug/fix this problem?

You can try testing the webcam with different resolutions. The webcam
supports 160x120, 320x240 and 640x480 resolutions based on the source code.
You can try the different resolutions for example with "cheese"
( http://projects.gnome.org/cheese/ ) or any of your favorite V4L2 program.

You can load the usbmon kernel module and use Wireshark to log the USB communication
between your computer and the webcam starting with plug-in. You can compare
the communication when the webcam starts to work correctly with the one when
the webcam doesn't work as expected.

Regards,

	Márton Németh
