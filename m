Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49179 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZDERlx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 13:41:53 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Janne Grunau <j@jannau.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20090405143748.GC10556@aniel>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl>  <20090405143748.GC10556@aniel>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 13:39:33 -0400
Message-Id: <1238953174.3337.12.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Janne,

On Sun, 2009-04-05 at 16:37 +0200, Janne Grunau wrote:
> On Sun, Apr 05, 2009 at 07:46:47AM +0200, Hans Verkuil wrote:
> >
> > Let's keep it simple: add a 'load_ir_kbd_i2c' module option for those 
> > drivers that did not autoload this module. The driver author can refine 
> > things later (I'll definitely will do that for ivtv).
> > 
> > It will be interesting if someone can find out whether lirc will work at all 
> > once autoprobing is removed from i2c. If it isn't, then perhaps that will 
> > wake them up to the realization that they really need to move to the 
> > kernel.
> 
> I would guess that it won't work. There is an effort to merge lirc. It's
> currently stalled though.

Perhaps you and Jarrod and Christopher have already discussed this,
but...

Instead of trying to push all of the LIRC kernel components through in
one big patch set, perhaps it would be easier to just get the lirc_dev
and any other needed infrastructure components in first.

If one focuses on satisfying the LKML comments to lirc_dev and the
Makefile to get that kernel module in the kernel, then, at least for
video card hosted IR devices, there is an infrastructure to which to
hook new or rewritten i2c IR driver modules.

 
>  A git tree is available at
> 
> git://git.wilsonet.com/linux-2.6-lirc.git
> 
> Jared Wilson and I were working on it (mainly last september). Since the
> IR on the HD PVR is also driven by the same zilog chip as on other
> hauppauge devices I'll take of lirc_zilog. Help converting the i2c
> drivers to the new i2c model is welcome. General cleanup of lirc to make
> it ready for mainline is of course wellcome too.


I can help with this.  I'm mainly concerned with lirc_dev, lirc_i2c (for
Rx only use of the zilog at 0x71), lirc_zilog, and lirc_mceusb2.  That's
because, of course, I have devices that use those modules. :)

lirc_dev and the API header would be my first priority, if you need
help.  Did anyone consolidate all the comments from the LKML on Jarrod's
patch submission?

Regards,
Andy

> Janne


