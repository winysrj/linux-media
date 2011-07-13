Return-path: <mchehab@localhost>
Received: from iolanthe.rowland.org ([192.131.102.54]:34047 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755164Ab1GMP7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 11:59:54 -0400
Date: Wed, 13 Jul 2011 11:59:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ming Lei <tom.leiming@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia
 camera
In-Reply-To: <CACVXFVPJvuzKZetupzBf+GhwZKV10EHjpNUwTz98sweH3xkd4w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107131154390.2156-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, 13 Jul 2011, Ming Lei wrote:

> Hi,
> 
> On Wed, Jul 13, 2011 at 11:20 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > Why should system suspend be different from runtime suspend?  Have you
> 
> This is also my puzzle, :-)
> 
> > compared usbmon traces for the two types of suspend?
> 
> Almost same.

Come on.  "Almost same" means they are different.  That difference is
clearly the important thing you need to track down.

>  If I add USB_QUIRK_RESET_RESUME quirk for the device,
> the stream data will not be received from the device in runtime pm case,
> same with that in system suspend.

uvcvideo should be able to reinitialize the device so that it works
correctly following a reset.  If the device doesn't work then uvcvideo
has a bug in its reset_resume handler.

> Maybe buggy BIOS makes root hub send reset signal to the device during
> system suspend time, not sure...

That's entirely possible.

Alan Stern

