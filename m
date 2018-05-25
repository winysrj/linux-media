Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37075 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967385AbeEYRvq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 13:51:46 -0400
Date: Fri, 25 May 2018 18:51:44 +0100
From: Sean Young <sean@mess.org>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/3] media: rc: nuvoton: Keep device enabled during reg
 init
Message-ID: <20180525175144.cszceaus7jb37qxc@gofer.mess.org>
References: <20180521143803.25664-1-michal.winiarski@intel.com>
 <20180521143803.25664-3-michal.winiarski@intel.com>
 <20180524113140.s365usmtbnnzn6ft@gofer.mess.org>
 <20180525133523.a42pueu4gvkx6k32@mwiniars-main.ger.corp.intel.com>
 <20180525135941.v3eopzko4joduitx@gofer.mess.org>
 <20180525144202.n6o47kk4e45wphbm@mwiniars-main.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180525144202.n6o47kk4e45wphbm@mwiniars-main.ger.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 04:42:02PM +0200, Michał Winiarski wrote:
> On Fri, May 25, 2018 at 02:59:41PM +0100, Sean Young wrote:
> > On Fri, May 25, 2018 at 03:35:23PM +0200, Michał Winiarski wrote:
> > > On Thu, May 24, 2018 at 12:31:40PM +0100, Sean Young wrote:
> > > > On Mon, May 21, 2018 at 04:38:03PM +0200, Michał Winiarski wrote:
> > > > > Doing writes when the device is disabled seems to be a NOOP.
> > > > > Let's enable the device, write the values, and then disable it on init.
> > > > > This changes the behavior for wake device, which is now being disabled
> > > > > after init.
> > > > 
> > > > I don't have the datasheet so I might be misunderstanding this. We want
> > > > the IR wakeup to work fine even after kernel crash/power loss, right?
> > > 
> > > [snip]
> > > 
> > > Right, that makes sense. I completely ignored this scenario.
> > >  
> > > > > -	/* enable the CIR WAKE logical device */
> > > > > -	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
> > > > > +	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
> > > > 
> > > > The way I read this is that the CIR, not CIR_WAKE, is being disabled,
> > > > which seems contrary to what the commit message says.
> > > > 
> > > 
> > > That's a typo. And by accident it makes the wake_device work correctly :)
> > > I think that registers init logic was still broken though, operating under the
> > > assumption that the device is enabled on module load...
> > > 
> > > I guess we should just remove disable(LOGICAL_DEV_CIR) from wake_regs_init.
> > > 
> > > Have you already included this in any non-rebasing tree?
> > 
> > Nothing has been applied yet.
> > 
> > > Should I send a v2 or fixup on top?
> > 
> > I don't have the hardware to test this, a v2 would be appreciated.
> > 
> > We're late in the release cycle and I'm wondering if this patch would also
> > solve the nuvoton probe problem:
> > 
> > https://patchwork.linuxtv.org/patch/49874/
> 
> It causes us to go back to previous behavior (we're refcounting open/close,
> with your patch initial open on my system is coming from kbd_connect(), so
> userspace close() doesn't propagate to nuvoton-cir).
> 
> It passes my test of "load the module with debug=1, see if I'm getting
> interrupts".
> 
> If there's any scenario in which->close() would be called, it's still going to
> be broken.

Great, thank you very much for testing that. I've created a pull request
for the v2 version.


Sean
