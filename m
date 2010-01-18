Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:34677 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab0ARWmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 17:42:11 -0500
Date: Mon, 18 Jan 2010 16:42:04 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Andy Walls <awalls@radix.net>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stoth@kernellabs.com, Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@isely.net>
Subject: Re: Do any drivers access the cx25840 module in an atomic context?
In-Reply-To: <1263852965.7750.31.camel@palomino.walls.org>
Message-ID: <alpine.DEB.1.10.1001181631020.19606@cnc.isely.net>
References: <1263791968.5220.87.camel@palomino.walls.org>  <alpine.DEB.1.10.1001181407470.13307@cnc.isely.net> <1263852965.7750.31.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jan 2010, Andy Walls wrote:

> On Mon, 2010-01-18 at 14:18 -0600, Mike Isely wrote:
> > On Mon, 18 Jan 2010, Andy Walls wrote:> 
> > > Any definitive confirmation anyone can give on any of these drivers
> > > would be helpful and would save me some time.
> 
> 
> Mike,
> 
> Great!  Thank you for the answers.

You're welcome.


> 
> If you would indulge one more (compound) question:
> 
> Looking at the I2C master implementation in pvrusb2, it looks like it
> would be OK for me to combine the i2c_master_write() and
> i2c_master_read() in cx25840_read() into a single 2 "msg" i2c_transfer()
> without the pvrusb2 driver having a problem.
> 
> a. Is that correct?

Yes, that is correct.


> b. Is there a limit on the combined payload, such that a the
> cx25840_read4() would not work as a combined i2c_transfer() ?

There is an overall limit on the size of the I2C transfer.  This is due 
to the underlying firmware on pvrusb2-support devices.  Essentially the 
entire outgoing transfer plus a few bytes of overhead has to fit inside 
a single 64 byte URB.  This also limits the atomic read size to roughly 
64 bytes as well (the URB size on the returned data).  You should be 
able to reliably write up to 48 bytes at a time, perhaps even a little 
more.

This issue caused a problem for the cx25840 module a few years back when 
it used to do firmware downloads with large (e.g. 1024 byte or larger) 
single I2C transfers.  Hans told me then it was that large because it 
allowed the ivtv driver to run more efficiently, but we cut it back to 
48 bytes since it triggered problems with I2C adapters (e.g. pvrusb2) 
which could not handle such larger transfers at all.

The pvrusb2 driver's I2C adapter is really just a proxy for the I2C 
implementation in the device at the far end of the USB cable.  So it 
works at a higher level than one might normally expect - it operates at 
the transfer level, no bit-banging.  The communications protocol 
required by the hardware limits the I2C transfers to be either a write 
of some size, or an atomic write followed by a read of various sizes.  
The pvrusb2 implementation looks at the incoming transfers and tries to 
map them as best it can over what the device protocol allows.  
Generally this means that if it is possible it will do the right thing.  
In the specific case you mentioned above, the result should in fact be 
exactly what you need.  (I'm saying that without having looked at that 
area of code for quite a while, but it's what I remember being in my 
head when I did that part..)

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
