Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:49151 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab2HLScX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 14:32:23 -0400
Date: Sun, 12 Aug 2012 19:32:21 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net
Subject: Re: [PATCH] [media] iguanair: various fixes
Message-ID: <20120812183221.GA26171@pequod.mess.org>
References: <1343731061-9901-1-git-send-email-sean@mess.org>
 <5026FA51.9080600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5026FA51.9080600@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 11, 2012 at 09:35:29PM -0300, Mauro Carvalho Chehab wrote:
> Em 31-07-2012 07:37, Sean Young escreveu:
> > This fixes:
> >  - rx_overflow while holding down any down button on a nec remote
> >  - suspend/resume
> >  - stop receiver on rmmod
> >  - advertise rx_resolution and timeout properly
> >  - code simplify
> >  - ignore unsupported firmware versions
> 
> Please don't mix several different things on the same patch; it makes
> harder for review and, if any of these changes break, a git revert would
> change a lot of unrelated things. It also makes hard for bug disect.

That makes a lot of sense. I'll rework the patch.

> Tip: "git citool" helps a lot to break messy patches into smaller, concise
> ones.

Thank you very much, I'll try that.


Sean
