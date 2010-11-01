Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45223 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0KAV4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Nov 2010 17:56:41 -0400
Date: Mon, 1 Nov 2010 22:56:35 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101101215635.GA4808@hardeman.nu>
References: <20101029031131.GE17238@redhat.com>
 <20101029031530.GH17238@redhat.com>
 <4CCAD01A.3090106@redhat.com>
 <20101029151141.GA21604@redhat.com>
 <20101029191711.GA12136@hardeman.nu>
 <20101029192733.GE21604@redhat.com>
 <20101029195918.GA12501@hardeman.nu>
 <20101029200937.GG21604@redhat.com>
 <20101030233617.GA13155@hardeman.nu>
 <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, Oct 30, 2010 at 10:32:14PM -0400, Jarod Wilson wrote:
> On Sat, Oct 30, 2010 at 7:36 PM, David H�rdeman <david@hardeman.nu> wrote:
> > In that case, one solution would be:
> >
> > * using the full 32 bit scancode
> > * add a module parameter to squash the ID byte to zero
> > * default the module parameter to true
> > * create a keymap suitable for ID = 0x00
> >
> > Users who really want to distinguish remotes can then change the module
> > parameter and generate a keymap for their particular ID. Most others
> > will be blissfully unaware of this feature.
> 
> I was thinking something similar but slightly different. I think ID =
> 0x00 is a valid ID byte, so I was thinking static int pair_id = -1; to
> start out. This would be a stand-alone apple-only decoder, so we'd
> look for the apple identifier bytes, bail if not found. We'd also look
> at the ID byte, and if pair_id is 0-255, we'd bail if the ID byte
> didn't match it. The scancode we'd actually use to match the key table
> would be just the one command byte. It seems to make sense in my head,
> at least.

But you'd lose the ability to support two different remotes with 
different ID's (if you want different mappings in the keymap).

-- 
David H�rdeman
