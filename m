Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933898Ab1JEGPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 02:15:07 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: serial device name for smart card reader that is integrated to Anysee DVB USB device
Date: Wed, 5 Oct 2011 08:15:17 +0200
Cc: Greg KH <greg@kroah.com>, linux-serial@vger.kernel.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	=?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	"James Courtier-Dutton" <james.dutton@gmail.com>,
	HoP <jpetrous@gmail.com>,
	=?iso-8859-1?q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
References: <4E8B7901.2050700@iki.fi> <20111005045917.GB4700@kroah.com> <4E8BF21B.4010907@iki.fi>
In-Reply-To: <4E8BF21B.4010907@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110050815.17949.oneukum@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, 5. Oktober 2011, 07:58:51 schrieb Antti Palosaari:
> On 10/05/2011 07:59 AM, Greg KH wrote:

> > Why not just use the usb-serial core and then you get a ttyUSB* device
> > node "for free"?  It also should provide a lot of the basic tty
> > infrastructure and ring buffer logic all ready to use.
> 
> Since I don't see how I can access same platform data from DVB USB  and 
> USB-serial driver (usb_set_intfdata). I asked that earlier, see: 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg36027.html

Yes, and I'll have to give you the same answer as then.

But, Greg, Antti makes a very valid point here. The generic code assumes that
it owns intfdata, that is you cannot use it as is for access to anything that lacks
its own interface. But this is not a fatal flaw. We can alter the generic code to use
an accessor function the driver can provide and make it default to get/set_intfdata

What do you think?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
