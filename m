Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63818 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab0CMImI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 03:42:08 -0500
Date: Sat, 13 Mar 2010 00:41:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
Message-ID: <20100313084157.GD22494@core.coreip.homeip.net>
References: <4B99104B.3090307@redhat.com>
 <20100311175214.GB7467@core.coreip.homeip.net>
 <4B99C3D7.7000301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B99C3D7.7000301@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 12, 2010 at 01:32:23AM -0300, Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
> > Hi Mauro,
> > 
> > On Thu, Mar 11, 2010 at 12:46:19PM -0300, Mauro Carvalho Chehab wrote:
> >> In order to allow userspace programs to autoload an IR table, a link is
> >> needed to point to the corresponding input device.
> >>
> >> $ tree /sys/class/irrcv/irrcv0
> >> /sys/class/irrcv/irrcv0
> >> |-- current_protocol
> >> |-- input -> ../../../pci0000:00/0000:00:0b.1/usb1/1-3/input/input22
> >> |-- power
> >> |   `-- wakeup
> >> |-- subsystem -> ../../../../class/irrcv
> >> `-- uevent
> >>
> >> It is now easy to associate an irrcv device with the corresponding
> >> device node, at the input interface.
> >>
> > 
> > I guess the question is why don't you make input device a child of your
> > irrcvX device? Then I believe driver core will link them properly. It
> > will also ensure proper power management hierarchy.
> > 
> > That probably will require you changing from class_dev into device but
> > that's the direction kernel is going to anyway.
> 
> Done, see enclosed. It is now using class_register/device_register. The
> newly created device for irrcv is used as the parent for input_dev->dev.
> 
> The resulting code looked cleaner after the change ;)
>

It is indeed better, however I wonder if current hierarchy expresses the
hardware in best way. You currently have irrcv devices grow in parallel
with input devices whereas I would expect input devices be children of
irrcv devices:


	parent (PCI board, USB) -> irrcvX -> input1
                                          -> input2
					 ...

This way your PM sequence as follows - input core does its thing and
releases all pressed keys, etc, then you can shut off the receiver and
then board driver can shut doen the main piece. Otherwise irrcv0 suspend
may be racing with input suspend and so forth.

Thanks.

-- 
Dmitry
