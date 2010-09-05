Return-path: <mchehab@localhost>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59977 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0IEVow (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 17:44:52 -0400
Received: by fxm13 with SMTP id 13so2211994fxm.19
        for <linux-media@vger.kernel.org>; Sun, 05 Sep 2010 14:44:51 -0700 (PDT)
Subject: Re: [PATCH 0/8 V3] Many fixes for in-kernel decoding and for the
 ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org
In-Reply-To: <20100905210602.GA26715@hardeman.nu>
References: <1283642583-13102-1-git-send-email-maximlevitsky@gmail.com>
	 <20100905210602.GA26715@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Sep 2010 00:44:47 +0300
Message-ID: <1283723087.7534.1.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, 2010-09-05 at 23:06 +0200, David Härdeman wrote: 
> On Sun, Sep 05, 2010 at 02:22:55AM +0300, Maxim Levitsky wrote:
> > Hi,
> > 
> > This is next version of my patchset.
> > I addressed the comments from David Härdeman,                   
> > And in addition to that did a lot of cleanups in the ENE driver.
> > This includes new idle mode support that doesn't need 75 ms sample period.
> > Timeouts are now handled in much cleaner way.
> > Refactoring, even better register names, stale comments updated, some spelling errors
> > were fixed.
> > 
> > Any comments are welcome!
> 
> Out patchsets conflict. Depending on which order Mauro wishes to merge 
> them one of us will have to rebase. If mine is merged first, patch 2/8 
> in your set should not be necessary.
Btw, I really welcome your patches.
Indeed we need to resolve this.
I hope to see this patchset in 2.6.36, because without it there are just
too many bugs.

Best regards,
Maxim Levitsky

