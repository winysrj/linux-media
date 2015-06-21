Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbbFUUXv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 16:23:51 -0400
Date: Sun, 21 Jun 2015 22:23:48 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Borislav Petkov <bp@suse.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, LKP <lkp@01.org>
Subject: Re: [x86/mm/pat, drivers/media/ivtv]  WARNING: CPU: 0 PID: 1 at
 drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init()
Message-ID: <20150621202348.GP11147@wotan.suse.de>
References: <20150620071756.GA10923@wfg-t540p.sh.intel.com>
 <20150620110844.GA30725@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150620110844.GA30725@pd.tnic>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 20, 2015 at 01:08:44PM +0200, Borislav Petkov wrote:
> On Sat, Jun 20, 2015 at 03:17:56PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > 
> > commit 1bf1735b478008c30acaff18ec6f4a3ff211c28a
> > Author:     Luis R. Rodriguez <mcgrof@suse.com>
> > AuthorDate: Mon Jun 15 10:28:16 2015 +0200
> > Commit:     Ingo Molnar <mingo@kernel.org>
> > CommitDate: Thu Jun 18 11:23:41 2015 +0200
> > 
> >     x86/mm/pat, drivers/media/ivtv: Use arch_phys_wc_add() and require PAT disabled
> 
> ...
> 
> > [   12.956506] ivtv: Start initialization, version 1.4.3
> > [   12.958238] ivtv: End initialization
> > [   12.959438] ------------[ cut here ]------------
> > [   12.974076] WARNING: CPU: 0 PID: 1 at drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init+0x32/0xa3()
> > [   12.978017] ivtvfb needs PAT disabled, boot with nopat kernel parameter
> 
> Warning says it all. You need to boot with "nopat". Apparently, those
> devices are very seldom now and users should boot with "nopat".

Indeed.

> Luis, what is the plan, is this driver supposed to be converted to
> reserve_memtype(..., _PAGE_CACHE_MODE_WC, ...) at some point?

Nope, well the driver requires huge amounts of work to work with PAT,
that work will likely never be done, so hence the warning. Its our
compromise as only 2 drivers will live on Linux like this and they are
both old and rare.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
