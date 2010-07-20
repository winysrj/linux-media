Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:10938 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab0GTMqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 08:46:21 -0400
Date: Tue, 20 Jul 2010 14:46:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Kenney Phillisjr <kphillisjr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 04/17] cx25840: Make cx25840 i2c register read
 transactions  atomic
Message-ID: <20100720144613.49b5ef35@hyperion.delvare>
In-Reply-To: <1279629326.2714.31.camel@morgan.silverblock.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
	<1279588306.28153.6.camel@localhost>
	<20100720084217.4ab937a7@hyperion.delvare>
	<1279629326.2714.31.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Jul 2010 08:35:26 -0400, Andy Walls wrote:
> On Tue, 2010-07-20 at 08:42 +0200, Jean Delvare wrote:
> > Hi Andy,
> > 
> > On Mon, 19 Jul 2010 21:11:46 -0400, Andy Walls wrote:
> > > There was a small window between writing the cx25840 register
> > > address over the i2c bus and reading the register contents back from the
> > > cx25840 device that the i2c adapter lock was released.  This change ensures the
> > > adapter lock is not released until the register read is done.
> > > 
> > > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > 
> > Good catch.
> 
> Thanks.
> 
> > Acked-by: Jean Delvare <khali@linux-fr.org>
> > 
> > Note that cx25840_and_or() still has a (smaller and less dangerous)
> > race window. If several calls to cx25840_and_or() happen in parallel on
> > the same register, some of the changes may be lost. I don't know if
> > this can be a problem in practice though. If it is, then additional
> > locking around cx25840_and_or() would be needed.
> 
> Ah, thank you for pointing that out.
> 
> So, please bear with me while I think out loud:
> 
> 1. There are many explicit cases of read-modify-write on a register in
> the cx25840 module, this is not the only one.
> 
> 2. The bridge driver historically has always serialized access to the
> cx25840 module so races have never previously been an issue.
> 
> 3. I have added a work handler in the cx23885 module that calls the
> cx25840 module's interrupt handler.  Calls by the work handler are
> serialized with respect to themselves, but not with respect to
> serialized calls in #2.
> 
> 4. IIRC, registers written to by the cx25840 interrupt handler are never
> written to by the other cx25840 module functions; and vice-versa.  I
> will have to audit the cx25840 module code to be sure.
> 
> 5. There is always a race on r-m-w on *some* registers in the
> 0x800-0x9ff range with the audio microcontroller that is built into the
> chip.  The only way to provide locking for those is to halt the
> microcontroller.  I've just looked at Patch 12/17 again.  The interrupt
> handler only reads the CX23885_AUD_MC_INT_MASK_REG, which is used by the
> audio micrcontroller.  The interrupt handler does do a r-m-w on the
> CX25840_AUD_INT_STAT_REG, but that register is not used by the
> microcontroller.
> 
> 
> So, I think I'm OK with just not dropping the i2c adapter lock in a
> cx25840 register read transaction until it is complete.
> 
> Thanks for making me think that one through. :)

Looks like you're OK then, but you may want to document this somewhere
for future contributors to these drivers.

-- 
Jean Delvare
