Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43111 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757242Ab1JEHCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Oct 2011 03:02:22 -0400
Date: Wed, 5 Oct 2011 00:01:59 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Antti Palosaari <crope@iki.fi>, linux-serial@vger.kernel.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	James Courtier-Dutton <james.dutton@gmail.com>,
	HoP <jpetrous@gmail.com>,
	=?iso-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
Subject: Re: serial device name for smart card reader that is integrated to
 Anysee DVB USB device
Message-ID: <20111005070159.GA6896@kroah.com>
References: <4E8B7901.2050700@iki.fi>
 <20111005045917.GB4700@kroah.com>
 <4E8BF21B.4010907@iki.fi>
 <201110050815.17949.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110050815.17949.oneukum@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 05, 2011 at 08:15:17AM +0200, Oliver Neukum wrote:
> Am Mittwoch, 5. Oktober 2011, 07:58:51 schrieb Antti Palosaari:
> > On 10/05/2011 07:59 AM, Greg KH wrote:
> 
> > > Why not just use the usb-serial core and then you get a ttyUSB* device
> > > node "for free"?  It also should provide a lot of the basic tty
> > > infrastructure and ring buffer logic all ready to use.
> > 
> > Since I don't see how I can access same platform data from DVB USB  and 
> > USB-serial driver (usb_set_intfdata). I asked that earlier, see: 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg36027.html
> 
> Yes, and I'll have to give you the same answer as then.
> 
> But, Greg, Antti makes a very valid point here. The generic code assumes that
> it owns intfdata, that is you cannot use it as is for access to anything that lacks
> its own interface. But this is not a fatal flaw. We can alter the generic code to use
> an accessor function the driver can provide and make it default to get/set_intfdata
> 
> What do you think?

I totally forgot about that previous answer, I write too much email :)

Anyway, yes, if we can alter the core to make this work for this type of
device, that is probably much easier than having to write a whole tty
driver just for this one type of device.  I'll gladly take such a patch.

thanks,

greg k-h
