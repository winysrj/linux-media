Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab0IHWmp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 18:42:45 -0400
Date: Wed, 8 Sep 2010 18:42:27 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8 V5] Many fixes for in-kernel decoding and for the ENE
 driver
Message-ID: <20100908224227.GL22323@redhat.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
 <4C8805FA.3060102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8805FA.3060102@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 06:54:02PM -0300, Mauro Carvalho Chehab wrote:
> Em 06-09-2010 18:26, Maxim Levitsky escreveu:
> > Hi,
> > 
> > Here is full overview of my patches:
> > 
> > Patch #1 fixes races in ir thread.
> > It fixes the case when ktherad_stop waits forever for the thread.
> > This happens on module unload and therefore it never finishes.
> > Sorry for introducing this bug.
> > 
> > Patch #2, fixes a crash on my module load.
> > It happens because ir core initializes the input device a bit early,
> > therefore it could be accessed while still not set up.
> > 
> > Patch #3 fixes a small typo in lirc code that makes it impossible to use tx duty cycle setting.
> > 
> > Patch #4 fixes a problem seen on my system that results in stuck down forever key.
> > 
> > Patch #5 adds few keys to MCE keymap that were found on laptop of an user I tested this driver with
> > 
> > Patch #6, is a combined update ti my driver. It contains lot of refactoring thanks to docs I have now,
> > and lot of fixes, and supports latest version of firmware (and I have 4 users asking for that)
> > It is quite huge, but it would be a tedios job to break it up. This can't introduce regressions
> > because the ene_ir was never released. In addition to that it was tested by me and another two users.
> > 
> > Patch #7 the really only patch that touches drivers I don't have does touch the ir-core.
> > It is quite small, and it adds a proper solution to dilema about what to do with huge space between keypresses.
> > Now this space is just truncated by the driver with timeout flag.
> > The lirc codec then ensures that right sample is send to the lircd.
> > Please review and test it.
> > 
> > Patch #8 is very simple. It just builds on top of patch #7 and adds carrier reports to ene driver.
> 
> For now, I've applied patches 3, 4 and 5, as it is nice to have Jarod's review also.

I've finally got them all applied atop current media_tree staging/v2.6.37,
though none of the streamzap bits in patch 7 are applicable any longer.
Will try to get through looking and commenting (and testing) of the rest
of them tonight.


-- 
Jarod Wilson
jarod@redhat.com

