Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:54122 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CLOek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 09:34:40 -0500
Date: Sat, 12 Mar 2011 15:34:33 +0100
From: "Issa Gorissen" <flop.m@usa.net>
To: Ralph Metzler <rjkm@metzlerbros.de>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
CC: <linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <777PcLohh6368S03.1299940473@web03.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Ralph Metzler <rjkm@metzlerbros.de>
> Andreas Oberritter writes:
>  > > Unless you want to move the writing to/reading from the CI module into
>  > > ioctls of the ci device you need another node. 
>  > > Even nicer would be having the control messages moved to ioctls and
the
>  > > TS IO in read/write of ci, but this would break the old interface.
>  > 
>  > It's possible to keep compatibility. Just add ioctls to get and set the
>  > interface version. Default to the current version, not supporting TS
>  > I/O. If the version is set to e.g. 1, switch from the current interface
>  > to the new one, using ioctls for control messages.
> 
> A possibility, but also requires rewrites in existing software like
libdvben50221.
> Right now you can e.g. tune with /dev/dvb/adapter0/frontend0, point an
unchanged
> libdvben50221 to /dev/dvb/adapter1/ci0 (separate adapter since it can even
> be on a different card) and pipe all PIDs of cam_pmt of the program
> you are watching through /dev/dvb/adapter1/sec0(cam0) and it is decoded.

This is KISS compliant by the way.

Andreas, please explain what *really* bothers you with this architecture
choice of having a new node, leaving the current API as is.

You might find that adding a new node is lazy, but there are advantages:
- current API isn't broken, namely, ca devices are still used for the control
messages, nothing more;
- for applications using the DVB API, it is also easier to debug while reading
the code, in my opinion, because of the usage of two distinct devices (ca /
cam) instead of one (ca / ioctls);


--
Issa

