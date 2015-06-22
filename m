Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbbFVHGw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 03:06:52 -0400
Date: Mon, 22 Jun 2015 09:06:41 +0200
From: Borislav Petkov <bp@suse.de>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, LKP <lkp@01.org>
Subject: Re: [x86/mm/pat, drivers/media/ivtv]  WARNING: CPU: 0 PID: 1 at
 drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init()
Message-ID: <20150622070641.GA19872@pd.tnic>
References: <20150620071756.GA10923@wfg-t540p.sh.intel.com>
 <20150620110844.GA30725@pd.tnic>
 <20150621202348.GP11147@wotan.suse.de>
 <20150621204120.GA11833@pd.tnic>
 <20150622010138.GQ11147@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150622010138.GQ11147@wotan.suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 22, 2015 at 03:01:38AM +0200, Luis R. Rodriguez wrote:
> We can certainly replace the WARN() with pr_warn(), I don't see
> how its confusing though as its a run time real issue. Either
> way whatever you recommend is fine by me.

Yeah, it confused the 0day robot at least. :-)

But maybe because it cannot really read. But I've experienced cases
where people don't read too, see *a* splat and raise the alarm. So yeah,
I think a simple pr_warn would be much better.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
