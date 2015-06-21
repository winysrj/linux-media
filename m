Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbbFUUlb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 16:41:31 -0400
Date: Sun, 21 Jun 2015 22:41:20 +0200
From: Borislav Petkov <bp@suse.de>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, LKP <lkp@01.org>
Subject: Re: [x86/mm/pat, drivers/media/ivtv]  WARNING: CPU: 0 PID: 1 at
 drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init()
Message-ID: <20150621204120.GA11833@pd.tnic>
References: <20150620071756.GA10923@wfg-t540p.sh.intel.com>
 <20150620110844.GA30725@pd.tnic>
 <20150621202348.GP11147@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150621202348.GP11147@wotan.suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 21, 2015 at 10:23:48PM +0200, Luis R. Rodriguez wrote:
> Nope, well the driver requires huge amounts of work to work with PAT,
> that work will likely never be done, so hence the warning. Its our
> compromise as only 2 drivers will live on Linux like this and they are
> both old and rare.

Hmm, so wasn't the possibility discussed to fail loading instead and
issue a single-line pr_warn() when PAT is enabled? Those big WARN()
splats will only confuse people...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
