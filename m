Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:37340 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0CNGhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 01:37:10 -0500
Date: Sat, 13 Mar 2010 22:37:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
Message-ID: <20100314063704.GB24684@core.coreip.homeip.net>
References: <4B99104B.3090307@redhat.com>
 <20100311175214.GB7467@core.coreip.homeip.net>
 <4B99C3D7.7000301@redhat.com>
 <20100313084157.GD22494@core.coreip.homeip.net>
 <4B9BFCB6.4080805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9BFCB6.4080805@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 13, 2010 at 05:59:34PM -0300, Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
> > On Fri, Mar 12, 2010 at 01:32:23AM -0300, Mauro Carvalho Chehab wrote:
> >> Dmitry Torokhov wrote:
> >>> Hi Mauro,
> >>>
> >>> On Thu, Mar 11, 2010 at 12:46:19PM -0300, Mauro Carvalho Chehab wrote:
> >>>> In order to allow userspace programs to autoload an IR table, a link is
> >>>> needed to point to the corresponding input device.
> >>>>
> >>>> $ tree /sys/class/irrcv/irrcv0
> >>>> /sys/class/irrcv/irrcv0
> >>>> |-- current_protocol
> >>>> |-- input -> ../../../pci0000:00/0000:00:0b.1/usb1/1-3/input/input22
> >>>> |-- power
> >>>> |   `-- wakeup
> >>>> |-- subsystem -> ../../../../class/irrcv
> >>>> `-- uevent
> >>>>
> >>>> It is now easy to associate an irrcv device with the corresponding
> >>>> device node, at the input interface.
> >>>>
> >>> I guess the question is why don't you make input device a child of your
> >>> irrcvX device? Then I believe driver core will link them properly. It
> >>> will also ensure proper power management hierarchy.
> >>>
> >>> That probably will require you changing from class_dev into device but
> >>> that's the direction kernel is going to anyway.
> >> Done, see enclosed. It is now using class_register/device_register. The
> >> newly created device for irrcv is used as the parent for input_dev->dev.
> >>
> >> The resulting code looked cleaner after the change ;)
> >>
> > 
> > It is indeed better, however I wonder if current hierarchy expresses the
> > hardware in best way. You currently have irrcv devices grow in parallel
> > with input devices whereas I would expect input devices be children of
> > irrcv devices:
> > 
> > 
> > 	parent (PCI board, USB) -> irrcvX -> input1
> >                                           -> input2
> > 					 ...
> > 
> 
> It is representing it right:
> 
> usb1/1-3 -> irrcv -> irrcv0 -> input7 -> event7
> 
> The only extra attribute there is the class name "irrcv", but this seems
> coherent with the other classes on this device (dvb, sound, power, video4linux).
> 

Ah, yes, I saw where you take input device's parent and use it as
irrcv's parent but missed the piece where you substitute original
input device's parent with irrcv. I bit sneaky to my taste but I guess
can be cleaned up later.

-- 
Dmitry
