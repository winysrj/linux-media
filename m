Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50970 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZLCXrd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 18:47:33 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jonsmirl@gmail.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
In-Reply-To: <4B18292C.6070303@redhat.com>
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>
	 <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>
	 <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
	 <4B17AA6A.9060702@redhat.com>  <4B18292C.6070303@redhat.com>
Content-Type: text/plain
Date: Thu, 03 Dec 2009 18:45:26 -0500
Message-Id: <1259883926.3095.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-03 at 19:10 -0200, Mauro Carvalho Chehab wrote:
> Gerd Hoffmann wrote:
> 
> > One final pass over the lirc interface would be good, taking the chance
> > to fixup anything before the ABI is set in stone with the mainline
> > merge.  Things to look at:
 
> >   (3) Someone suggested a 'commit' ioctl which would activate
> >       the parameters set in (multiple) previous ioctls.  Makes sense?
> 
> A better approach is to create an ioctl that can send a group of value/attribute pairs
> at the same time. We used this estrategy for V4L extended controls to do things like
> setting an mpeg encoder (were we need to adjust several parameters at the same time,
> and adding all of them on one struct would be hard, since you can't specify all
> of them sa the same time). The same strategy is also used by DVB API to allow it
> to use any arbitrary protocol. It was conceived to support DVB-S2.

Gerd,

I mentioned it.  The reason that I mentioned it is that partial
configuration, before all the IOCTLs are done, of the IR chips that I
work with *may* cause:

1. Unnecessary, extra I2C bus operations leading to delay on
configuration.  That's no big deal as it would really only matter for a
genuine discrete CX2584x chip with IR implemented using the integrated
IR controller.  I do not know of any TV capture cards wired up like
that.

2. If the Low Pass Filter gets turned off, or set to very short time
interval, bad ambient light conditions could create an "interrupt
storm".  As soon as all the IOCTLs complete, the storm would stop.


We can probably do without the change in lirc_dev ioctl() altogether,
since it only *really* affects one set of chips  that I work with, and
only during configuration.  I could instead implement interrupt storm
detection and interrupt rate limiting for those devices.


BTW IIRC, LIRC likes to resend the ioctl() to set the carrier frequency
over again when it goes to transmit.  That's kind of annoying, but I can
work around that too by caching a copy of the carrier freq LIRC set the
last time.

Regards,
Andy

