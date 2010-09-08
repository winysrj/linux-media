Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:36499 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0IHXId (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 19:08:33 -0400
Date: Thu, 9 Sep 2010 01:08:28 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jarod Wilson <jarod@redhat.com>, Jarod Wilson <jarod@wilsonet.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net, mchehab@infradead.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
Message-ID: <20100908230828.GA7121@hardeman.nu>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
 <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
 <AANLkTinr6mN=t=vNnR3pSBxXb0ud=Ymrqn_WyDNkUJTz@mail.gmail.com>
 <1283964646.6372.90.camel@morgan.silverblock.net>
 <20100908172708.GH22323@redhat.com>
 <1283986953.29812.24.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283986953.29812.24.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 07:02:33PM -0400, Andy Walls wrote:
> On Wed, 2010-09-08 at 13:27 -0400, Jarod Wilson wrote:
> > On Wed, Sep 08, 2010 at 12:50:46PM -0400, Andy Walls wrote:
> > > On Wed, 2010-09-08 at 11:26 -0400, Jarod Wilson wrote:
> > > > On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > > > 
> > > > I'm generally good with this entire patch, but the union usage looks a
> > > > bit odd, as the members aren't of the same size, which is generally
> > > > what I've come to expect looking at other code.
> > > 
> > > Having a union with different sized members is perfectly valid C code. 
> > > 
> 
> > Yeah, no, I know that it'll work, just that most of the unions I've
> > actually paid any attention to had members all of the same size. Seemed
> > like sort of an unwritten rule for in-kernel use. But its probably just
> > fine.
> 
> Well if it's an unwritten rule, not everyone is following it. :)
> There are numerous counter-examples in include/linux/*.h .  Here are a
> few easy to see ones:

Not to mention that the use of a union sends an important message to the 
programmer reading the code - i.e. that only one of the union members 
can be used in the same event.


-- 
David Härdeman
