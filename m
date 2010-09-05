Return-path: <mchehab@localhost>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:34710 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0IEVGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 17:06:07 -0400
Date: Sun, 5 Sep 2010 23:06:02 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 0/8 V3] Many fixes for in-kernel decoding and for the
 ENE driver
Message-ID: <20100905210602.GA26715@hardeman.nu>
References: <1283642583-13102-1-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283642583-13102-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, Sep 05, 2010 at 02:22:55AM +0300, Maxim Levitsky wrote:
> Hi,
> 
> This is next version of my patchset.
> I addressed the comments from David Härdeman,                   
> And in addition to that did a lot of cleanups in the ENE driver.
> This includes new idle mode support that doesn't need 75 ms sample period.
> Timeouts are now handled in much cleaner way.
> Refactoring, even better register names, stale comments updated, some spelling errors
> were fixed.
> 
> Any comments are welcome!

Out patchsets conflict. Depending on which order Mauro wishes to merge 
them one of us will have to rebase. If mine is merged first, patch 2/8 
in your set should not be necessary.

Also, you seem to have forgotten to include linux-media and/or Mauro in 
the CC list?

-- 
David Härdeman
