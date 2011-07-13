Return-path: <mchehab@localhost>
Received: from iolanthe.rowland.org ([192.131.102.54]:55282 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755435Ab1GMPUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 11:20:19 -0400
Date: Wed, 13 Jul 2011 11:20:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ming Lei <tom.leiming@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia
 camera
In-Reply-To: <CACVXFVOGiJswRQ+5kJd7HW3Zyow9hrC6+HR=fB5o6o=iH-ca3A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107131118550.2156-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, 13 Jul 2011, Ming Lei wrote:

> Hi,
> 
> On Tue, Jul 12, 2011 at 11:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 12 Jul 2011, Ming Lei wrote:
> >
> >> Hi Laurent,
> >>
> >> After resume from sleep,  all the ISO packets from camera are like below:
> >>
> >> ffff880122d9f400 3527230728 S Zi:1:004:1 -115:1:2568 32 -18:0:1600
> >> -18:1600:1600 -18:3200:1600 -18:4800:1600 -18:6400:1600 51200 <
> >> ffff880122d9d400 3527234708 C Zi:1:004:1 0:1:2600:0 32 0:0:12
> >> 0:1600:12 0:3200:12 0:4800:12 0:6400:12 51200 = 0c8c0000 0000fa7e
> >> 012f1b05 00000000 00000000 00000000 00000000 00000000
> >>
> >> All are headed with 0c8c0000, see attached usbmon captures.
> >
> > Maybe this device needs a USB_QUIRK_RESET_RESUME entry in quirks.c.
> 
> I will try it, but seems unbind&bind driver don't produce extra usb reset signal
> to the device.
> 
> Also, the problem didn't happen in runtime pm case, just happen in
> wakeup from system suspend case. uvcvideo has enabled auto suspend
> already at default.

Why should system suspend be different from runtime suspend?  Have you
compared usbmon traces for the two types of suspend?

Alan Stern

