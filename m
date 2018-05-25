Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35652 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933214AbeEYNf1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 09:35:27 -0400
Date: Fri, 25 May 2018 15:35:23 +0200
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Sean Young <sean@mess.org>
CC: <linux-media@vger.kernel.org>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/3] media: rc: nuvoton: Keep device enabled during reg
 init
Message-ID: <20180525133523.a42pueu4gvkx6k32@mwiniars-main.ger.corp.intel.com>
References: <20180521143803.25664-1-michal.winiarski@intel.com>
 <20180521143803.25664-3-michal.winiarski@intel.com>
 <20180524113140.s365usmtbnnzn6ft@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180524113140.s365usmtbnnzn6ft@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 24, 2018 at 12:31:40PM +0100, Sean Young wrote:
> On Mon, May 21, 2018 at 04:38:03PM +0200, Michał Winiarski wrote:
> > Doing writes when the device is disabled seems to be a NOOP.
> > Let's enable the device, write the values, and then disable it on init.
> > This changes the behavior for wake device, which is now being disabled
> > after init.
> 
> I don't have the datasheet so I might be misunderstanding this. We want
> the IR wakeup to work fine even after kernel crash/power loss, right?

[snip]

Right, that makes sense. I completely ignored this scenario.
 
> > -	/* enable the CIR WAKE logical device */
> > -	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
> > +	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
> 
> The way I read this is that the CIR, not CIR_WAKE, is being disabled,
> which seems contrary to what the commit message says.
> 

That's a typo. And by accident it makes the wake_device work correctly :)
I think that registers init logic was still broken though, operating under the
assumption that the device is enabled on module load...

I guess we should just remove disable(LOGICAL_DEV_CIR) from wake_regs_init.

Have you already included this in any non-rebasing tree?
Should I send a v2 or fixup on top?

-Michał

> 
> Sean
> 
> >  }
> >  
> >  static void nvt_enable_wake(struct nvt_dev *nvt)
> > -- 
> > 2.17.0
