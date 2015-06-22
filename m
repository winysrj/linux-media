Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32847 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbbFVGgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 02:36:53 -0400
Date: Mon, 22 Jun 2015 08:36:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	LKP <lkp@01.org>
Subject: Re: [x86/mm/pat, drivers/media/ivtv]  WARNING: CPU: 0 PID: 1 at
 drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init()
Message-ID: <20150622063647.GA24434@gmail.com>
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


* Borislav Petkov <bp@suse.de> wrote:

> On Sun, Jun 21, 2015 at 10:23:48PM +0200, Luis R. Rodriguez wrote:

> > Nope, well the driver requires huge amounts of work to work with PAT, that 
> > work will likely never be done, so hence the warning. Its our compromise as 
> > only 2 drivers will live on Linux like this and they are both old and rare.
> 
> Hmm, so wasn't the possibility discussed to fail loading instead and issue a 
> single-line pr_warn() when PAT is enabled? Those big WARN() splats will only 
> confuse people...

Absolutely - they are a regression.

Thanks,

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
