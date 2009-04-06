Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbZDFNOH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 09:14:07 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding model
Date: Mon, 6 Apr 2009 09:13:32 -0400
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20090404142427.6e81f316@hyperion.delvare> <1238953174.3337.12.camel@morgan.walls.org> <20090405183154.GE10556@aniel>
In-Reply-To: <20090405183154.GE10556@aniel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904060913.32976.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 05 April 2009 14:31:54 Janne Grunau wrote:
> On Sun, Apr 05, 2009 at 01:39:33PM -0400, Andy Walls wrote:
> > On Sun, 2009-04-05 at 16:37 +0200, Janne Grunau wrote:
> > > 
> > > I would guess that it won't work. There is an effort to merge lirc. It's
> > > currently stalled though.
> > 
> > Perhaps you and Jarrod and Christopher have already discussed this,
> > but...
> > 
> > Instead of trying to push all of the LIRC kernel components through in
> > one big patch set, perhaps it would be easier to just get the lirc_dev
> > and any other needed infrastructure components in first.
> > 
> > If one focuses on satisfying the LKML comments to lirc_dev and the
> > Makefile to get that kernel module in the kernel, then, at least for
> > video card hosted IR devices, there is an infrastructure to which to
> > hook new or rewritten i2c IR driver modules.
> 
> I guess lkml would NAK patches adding infrastructure only bits but we
> will probably for the next patchset concentrate on a few lirc drivers.

Yep, my thoughts exactly.

> Christopher doesn't participate in the merge attempt.

Christoph has been giving decent feedback and merging the git tree changes
back into lirc cvs of late, but no, he's not directly participating in
the effort to merge lirc into the kernel.

> > >  A git tree is available at
> > > 
> > > git://git.wilsonet.com/linux-2.6-lirc.git
> > > 
> > > Jared Wilson and I were working on it (mainly last september). Since the
> > > IR on the HD PVR is also driven by the same zilog chip as on other
> > > hauppauge devices I'll take of lirc_zilog. Help converting the i2c
> > > drivers to the new i2c model is welcome. General cleanup of lirc to make
> > > it ready for mainline is of course wellcome too.
> > 
> > I can help with this.  I'm mainly concerned with lirc_dev, lirc_i2c (for
> > Rx only use of the zilog at 0x71), lirc_zilog, and lirc_mceusb2.  That's
> > because, of course, I have devices that use those modules. :)
> 
> I have devices for lirc_zilog (which should probably be merged with
> lirc_i2c) and lirc serial. Jarod has at least mce usb and imon devices.
> That are probably the devices we'll concentrate on the next submission.

Indeed, we should focus on serial, i2c/zilog, mceusb2 and imon. I think
they're by far the most popular and the best maintained, and between
Janne and myself, we can actually test all of them ourselves.

> > lirc_dev and the API header would be my first priority, if you need
> > help.  Did anyone consolidate all the comments from the LKML on Jarrod's
> > patch submission?
> 
> no and I lost track which comments were already handled.

I think we've got just about everything handled, but I should go back over
the stack of comments before we resubmit... I was hoping to have something
ready for 2.6.30, but work keeps getting in the way...

-- 
Jarod Wilson
jarod@redhat.com
