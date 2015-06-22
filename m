Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbbFVBBl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 21:01:41 -0400
Date: Mon, 22 Jun 2015 03:01:38 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Borislav Petkov <bp@suse.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, LKP <lkp@01.org>
Subject: Re: [x86/mm/pat, drivers/media/ivtv]  WARNING: CPU: 0 PID: 1 at
 drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init()
Message-ID: <20150622010138.GQ11147@wotan.suse.de>
References: <20150620071756.GA10923@wfg-t540p.sh.intel.com>
 <20150620110844.GA30725@pd.tnic>
 <20150621202348.GP11147@wotan.suse.de>
 <20150621204120.GA11833@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150621204120.GA11833@pd.tnic>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 21, 2015 at 10:41:20PM +0200, Borislav Petkov wrote:
> On Sun, Jun 21, 2015 at 10:23:48PM +0200, Luis R. Rodriguez wrote:
> > Nope, well the driver requires huge amounts of work to work with PAT,
> > that work will likely never be done, so hence the warning. Its our
> > compromise as only 2 drivers will live on Linux like this and they are
> > both old and rare.
> 
> Hmm, so wasn't the possibility discussed to fail loading 

It will fail load.

> instead and
> issue a single-line pr_warn() when PAT is enabled? 

During review no one opposed the idea of having the warn
as its a load thing, not a compile thing, and a user
that does not get their driver loaded should know why,
otherwise its not clear.

> Those big WARN() splats will only confuse people...

We can certainly replace the WARN() with pr_warn(), I don't see
how its confusing though as its a run time real issue. Either
way whatever you recommend is fine by me.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
