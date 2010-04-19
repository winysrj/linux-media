Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0DSSci (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Apr 2010 14:32:38 -0400
Date: Mon, 19 Apr 2010 11:21:40 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-media@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH v2] V4L/DVB: budget: Oops: "BUG: unable to
 handle kernel NULL pointer dereference"
Message-ID: <20100419182140.GE32347@kroah.com>
References: <1269428277-6709-1-git-send-email-bjorn@mork.no>
 <201003241325.52864@orion.escape-edv.de>
 <1269436658-20370-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269436658-20370-1-git-send-email-bjorn@mork.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 24, 2010 at 02:17:38PM +0100, Bjørn Mork wrote:
> Never call dvb_frontend_detach if we failed to attach a frontend. This fixes
> the following oops:
> 
> [    8.172997] DVB: registering new adapter (TT-Budget S2-1600 PCI)
> [    8.209018] adapter has MAC addr = 00:d0:5c:cc:a7:29
> [    8.328665] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    8.328753] Intel ICH 0000:00:1f.5: setting latency timer to 64
> [    8.562047] DVB: Unable to find symbol stv090x_attach()
> [    8.562117] BUG: unable to handle kernel NULL pointer dereference at 000000ac
> [    8.562239] IP: [<e08b04a3>] dvb_frontend_detach+0x4/0x67 [dvb_core]
> 
> Ref http://bugs.debian.org/575207
> 
> Also clean up if we are unable to register the tuner and LNB drivers
> 
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Cc: stable@kernel.org
> Reported-by: Fladischer Michael <FladischerMichael@fladi.at>
> ---
> Oliver Endriss <o.endriss@gmx.de> writes:
> 
> > Could you please extend your patch in a way
> > that it will also catch, if
> > - dvb_attach(stv6110x_attach,...)
> > - dvb_attach(isl6423_attach,...)
> > fail?
> 
> OK.  Attempting, although I have no clue whether such failures are really
> fatal or not...
> 
> This is version 2 of this patch, adding cleanup in case we fail to register
> the two submodules used by this card/frontend.  I'm not certain that this 
> additional cleanup is appropriate for stable as any failure to register 
> these will be handled cleanly AFAICS.  But I have no way to test this.
> 
> This patch should apply cleanly to 2.6.32, 2.6.33, 2.6.34-rc2
> 
> This does not apply cleanly to git://linuxtv.org/v4l-dvb.git master.  I will 
> followup with a similar patch for that branch
> 
> Please apply to stable if appropriate.  If not, please apply version 1
> of the patch, which fixes only the oops condition.

Any reason why this patch isn't in Linus's tree yet?

thanks,

greg k-h
