Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZDIReW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 13:34:22 -0400
Date: Thu, 9 Apr 2009 14:34:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobi <listaccount@e-tobi.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Userspace issue with DVB driver includes
Message-ID: <20090409143407.218d68dc@pedra.chehab.org>
In-Reply-To: <49DE2301.5090406@e-tobi.net>
References: <49DDA100.1030205@e-tobi.net>
	<20090409074534.2cf32df0@pedra.chehab.org>
	<49DE2301.5090406@e-tobi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 09 Apr 2009 18:32:01 +0200
Tobi <listaccount@e-tobi.net> wrote:

> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
> 
> > I suspect that this were the upstream change that affected your work, right?
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b852d36b86902abb272b0f2dd7a56dd2d17ea88c
> 
> Yes, at least I thought so.
> 
> > There are two changesets that will likely fix this issue:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=85efde6f4e0de9577256c5f0030088d3fd4347c1
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9adfbfb611307060db54691bc7e6d53fdc12312b
> > 
> > Could you please try to apply they on 2.6.29 and see if those will solve the
> > issue? If so, then we should probably add those on 2.6.29.2. 
> 
> I've applied both patches to 2.6.29.1, but the problem still remains.
> 
> It's hard to figure out, who to blame for this.

If you're compiling with a new kernel, you'll be expected to have installed the
new kernel headers at /usr/include/linux. This is done by using "make
headers_install" at the kernel tree.

Could you please try to do make headers_install and see if the problem
persists? If the problem will still persist, then the better procedure is to open a
bugzilla at bugzilla.kernel.org, and post an email about this at LKML, keeping
LMML c/c, for us to follow the discussions.

Cheers,
Mauro
