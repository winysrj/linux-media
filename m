Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47286 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbZICLv4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:51:56 -0400
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
From: Andy Walls <awalls@radix.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	linux-media@vger.kernel.org,
	Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <4A9F38EE.7020104@wilsonet.com>
References: <200909011019.35798.jarod@redhat.com>
	 <1251855051.3926.34.camel@palomino.walls.org>
	 <4A9DE5FE.8060409@wilsonet.com>  <4A9F38EE.7020104@wilsonet.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 07:50:07 -0400
Message-Id: <1251978607.22279.36.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-09-02 at 23:33 -0400, Jarod Wilson wrote:
> On 09/01/2009 11:26 PM, Jarod Wilson wrote:
> > On 09/01/2009 09:30 PM, Andy Walls wrote:
> >> On Tue, 2009-09-01 at 10:19 -0400, Jarod Wilson wrote:
> >>> Patch is against http://hg.jannau.net/hdpvr/
> >>>
> >>> 1) Adds support for building hdpvr i2c support when i2c is built as a
> >>> module (based on work by David Engel on the mythtv-users list)
> >>>
> >>> 2) Refines the hdpvr_i2c_write() success check (based on a thread in
> >>> the sagetv forums)
> >>>
> >>> With this patch in place, and the latest lirc_zilog driver in my lirc
> >>> git tree, the IR part in my hdpvr works perfectly, both for reception
> >>> and transmitting.
> >>>
> >>> Signed-off-by: Jarod Wilson<jarod@redhat.com>
> >>
> >> Jarod,
> >>
> >> I recall a problem Brandon Jenkins had from last year, that when I2C was
> >> enabled in hdpvr, his machine with multiple HVR-1600s and an HD-PVR
> >> would produce a kernel oops.
> >>
> >> Have you tested this on a machine with both an HVR-1600 and HD-PVR
> >> installed?
> >
> > Hrm, no, haven't tested it with such a setup, don't have an HVR-1600. I
> > do have an HVR-1250 that I think might suffice for testing though, if
> > I'm thinking clearly.
> 
> Hrm. A brief google search suggests the 1250 IR part isn't enabled. I 
> see a number of i2c devices in i2cdetect -l output, but none that say 
> anything about IR... I could just plug the hdpvr in there and see what 
> happens, I suppose...

You should try that.  It was an issue of legacy I2C driver probing that
caused the hdpvr module to have problems.  The cx18 driver simply
stimulated the i2c subsystem to do legacy probing (via the tuner modules
IIRC)?  See the email I sent you.


> > Ugh. And I just noticed that while everything works swimmingly with a
> > 2.6.30 kernel base, the i2c changes in 2.6.31 actually break it, so
> > there's gonna be at least one more patch coming... I'm an idjit for not
> > testing w/2.6.31 before sending this in, I *knew* there were major i2c
> > changes to account for... (Its actually the hdpvr driver oopsing, before
> > one even tries loading lirc_zilog).
> 
> Getting closer. The hdpvr driver is no longer oopsing, and lirc_zilog 
> binds correctly. Transmit and receive are working too, but there's still 
> an oops on module unload I'm tracking down. Should be able to finish 
> sorting it all out tomorrow and get patches into the mail.


Regards,
Andy

