Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab2KMP3g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 10:29:36 -0500
Date: Tue, 13 Nov 2012 13:29:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	michael hartup <michael.hartup@gmail.com>,
	linux-rpi-kernel@lists.infradead.org
Subject: Re: Regarding bulk transfers on stk1160
Message-ID: <20121113132916.5d9fd72f@redhat.com>
In-Reply-To: <20121113145809.GA15029@kroah.com>
References: <CALF0-+XthyGJ-LzovTxLAKmMBif-YkLnNNcQBJvtnqTua+Ktag@mail.gmail.com>
	<20121113145809.GA15029@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 13 Nov 2012 06:58:09 -0800
Greg KH <greg@kroah.com> escreveu:

> On Tue, Nov 13, 2012 at 10:56:48AM -0300, Ezequiel Garcia wrote:
> > Hello,
> > 
> > A user (Michael Hartup in Cc) wants to use stk1160 on low power, low
> > cost devices (like raspberrypi).
> > 
> > At the moment raspberrypi can't stream using isoc urbs due to problems
> > with usb host driver (dwc-otg)
> > preventing it from achieving the required throughput.
> > For instance, on my rpi setup I can stream (using dd) at 16MB/s; but
> > at least 20 MB/s are required.
> > 
> > Having read that bulk transfers may work better with rpi usb driver, I
> > decided to try to implement
> > those at stk1160. However, I later discovered stk1160 doesn't have any
> > bulk endpoint (see lsusb below).
> > (I'm no expert, but I assume lack of bulk endpoint means I can't use
> > bulk urbs, right?).

Typically, a media device either uses isoc or bulk transfer. When the device
has both, one transfer type is generally used by analog and the other one
for digital. So, it is not a driver's choice; it is up to the a hardware's 
manufacturer to decide it.

> Correct, you need to fix the rpi host controller driver in order to make
> this work properly.  Please push back on the developers of that hardware
> so we can get the specs to write a proper driver for it.
> 
> Or better yet, buy a board with a working USB port, like a BeagleBone or
> the like :)
> 
> Sorry, there's really nothing we can do here,

I fully agree with Greg: if the rpi host controller is broken, there's nothing
we can do at media driver. 

Either put pressure at the hardware manufacturer for the fix to happen,
or just return it back to it and use another hardware.

Regards,
Mauro
