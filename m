Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:34431 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1JTTYz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 15:24:55 -0400
Date: Thu, 20 Oct 2011 21:18:37 +0200
From: Lars Noschinski <lars@public.noschinski.de>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-media@vger.kernel.org
Subject: Re: pac7311
Message-ID: <20111020191837.GA14773@lars.home.noschinski.de>
References: <20111017060334.GA16001@lars.home.noschinski.de>
 <4E9DDE13.103@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E9DDE13.103@freemail.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* N�meth M�rton <nm127@freemail.hu> [11-10-18 22:14]:
> Hi Lars,
> 
> Lars Noschinski wrote:
> > I'm using a webcam (Philipps SPC500NC) which identifies itself as
> > 
> >     093a:2603 Pixart Imaging, Inc. PAC7312 Camera
> > 
> > and is sort-of supported by the gspca_pac7311 module. "sort-of" because
> > the image alternates quickly between having a red tint or a green tint
> > (using the gspac driver from kernel 3.0.0, but this problem is present
> > since at least 2.6.31).
> 
> The most important source code for your webcam is drivers/media/video/gspca/pac7311.c .
> You can see it online at http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/media/video/gspca/pac7311.c .
> 
> > If I remove and re-plugin the camera a few times (on average around 3
> > times), the colors are stable.
> 
> When you plug and remove the webcam and the colors are wrong, do you get any
> message in the "dmesg"?

I get the same messages; sometimes the order of the messages output by
uhci_hcd ehci_hcd differs, but this seems to be unrelated to working/not
working.

> Once the colors are stable and you unplug and replug the webcam, what happens then?
> Is there again around 3 times when the webcam is not working properly?

I now did a longer series of unplug&replug: Over the time, status
"stable colors" seemed to get more probable. After a while, it only
falls back to alternating colors, when I unplug it for a longer time
(say 10 seconds). Might be a hardware problem?

> > Then a second issue becomes apparent:
> > There is almost no saturation in the image. Toying around with Contrast,
> > Gamma, Exposure or Gain does not help. What _does_ help is the Vflip
> > switch: If I enable it, the image is flipped vertically (as expected),
> > but also the color become a lot better.
> 
> Is there any difference when you use the "Mirror" control? What about the
> combination of the "Vflip" and "Mirror" controls?

"Vflip" and ("Vflip" and "Mirror") change color; "Mirror" alone does
not.

> What about the "Auto Gain" setting? Is it enabled or disabled in your case?

Auto Gain is enabled; but colors also change if it is disabled
> 
> > Is there something I can do to debug/fix this problem?
> 
> You can try testing the webcam with different resolutions. The webcam
> supports 160x120, 320x240 and 640x480 resolutions based on the source code.
> You can try the different resolutions for example with "cheese"
> ( http://projects.gnome.org/cheese/ ) or any of your favorite V4L2 program.

This does not seem to make a difference; except that 160x120 is listed,
but does not seem to be available. guvcview tells me:

Checking video mode 640x480@32bpp : OK 
setting new resolution (320 x 240)
checking format: 859981650
Checking video mode 320x240@32bpp : OK 
setting new resolution (160 x 120)
checking format: 859981650
Checking video mode 160x120@32bpp : OK 
ioctl (-1067952623) retried 4 times - giving up: Die Ressource ist zur Zeit nicht verf�gbar)
VIDIOC_DQBUF - Unable to dequeue buffer : Die Ressource ist zur Zeit nicht verf�gbar
Error grabbing image 
(the last message is then repeated, till i change the resolution)

[Also, since I switched to 160x120, cheese crashes with a segfault,
without giving me the possibility to switch back and I cannot find the
config file.]

> You can load the usbmon kernel module and use Wireshark to log the USB communication
> between your computer and the webcam starting with plug-in. You can compare
> the communication when the webcam starts to work correctly with the one when
> the webcam doesn't work as expected.

I'll try to do this later this week.

Greetings,
  Lars Noschinski
