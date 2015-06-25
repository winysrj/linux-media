Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbbFYRiw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 13:38:52 -0400
Date: Thu, 25 Jun 2015 19:38:47 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ingo Molnar <mingo@kernel.org>, Hyong-Youb Kim <hkim@cspi.com>,
	Andy Walls <awalls@md.metrocast.net>, benh@kernel.crashing.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, bp@suse.de,
	andy@silverblocksystems.net, mchehab@osg.samsung.com,
	dledford@redhat.com, fengguang.wu@intel.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and
 replace WARN() with pr_warn()
Message-ID: <20150625173847.GH3005@wotan.suse.de>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
 <20150625065147.GB5339@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150625065147.GB5339@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2015 at 08:51:47AM +0200, Ingo Molnar wrote:
> 
> * Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> 
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > On built-in kernels this warning will always splat as this is part
> > of the module init. Fix that by shifting the PAT requirement check
> > out under the code that does the "quasi-probe" for the device. This
> > device driver relies on an existing driver to find its own devices,
> > it looks for that device driver and its own found devices, then
> > uses driver_for_each_device() to try to see if it can probe each of
> > those devices as a frambuffer device with ivtvfb_init_card(). We
> > tuck the PAT requiremenet check then on the ivtvfb_init_card()
> > call making the check at least require an ivtv device present
> > before complaining.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  drivers/media/pci/ivtv/ivtvfb.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> > index 4cb365d..8b95eef 100644
> > --- a/drivers/media/pci/ivtv/ivtvfb.c
> > +++ b/drivers/media/pci/ivtv/ivtvfb.c
> > @@ -38,6 +38,8 @@
> >      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> >   */
> >  
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> >  #include <linux/fb.h>
> > @@ -1171,6 +1173,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
> >  {
> >  	int rc;
> >  
> > +#ifdef CONFIG_X86_64
> > +	if (pat_enabled()) {
> > +		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
> > +		return -ENODEV;
> > +	}
> > +#endif
> > +
> >  	if (itv->osd_info) {
> >  		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
> >  		return -EBUSY;
> 
> Same argument as for ipath: why not make arch_phys_wc_add() fail on PAT and return 
> -1, and check it in arch_phys_wc_del()?

The arch_phys_wc_add() is a no-op for PAT systems but for PAT to work we need
not only need to add this in where we replace the MTRR call but we also need
to convert ioremap_nocache() calls to ioremap_wc() but only if things were
split up already.

We racked our heads [0] [1] trying to figure out how to do the split for ivtv. The
issues with ivtv were that the firmware decides where the WC area is and does
not provide APIs to expose it. Then alternatives are to for example just use WC
on the entire full range and use work arounds write(); wmb(); read(); for MMIO
registers. That idea came from the use case of the Myricom Ethernet device
driver which uses WC as a compromise to address a performance regression if
it didn't use WC on an entire range, it uses the work around for the MMIO
registers. I considered very *briefly* adding a generic API that would let
device driver use this but dropped the idea as it seems this was not a common
issue and this was rather a work around.

I should note that Benjamin recenlty noted that power pc (and he says possibly
more) writel() and co contains an implicit mb(). That addresses some of it may
maybe not all requirements.

[0] http://lkml.kernel.org/r/1429146457.1899.99.camel@palomino.walls.org
[1] https://marc.info/?t=142894741100005&r=1&w=2

> That way we don't do anything drastic, the remaining few drivers still keep 
> working (albeit suboptimally - can be worked around with the 'nopat' boot option) 
> - yet we've reduced the use of MTRRs drastically.

It seems the 3 drivers that needed hackery are ancient, not common and likely
adding a general fix more work than the gains provided through it. We'd need
to address not only the use of the arch_phys calls but also to split their MMIO
registers / WC desire area. This later part was the harder part of all this.
Fortunately the "norm" is that modern devices have a full PCI bar designated
for each now. Furthermore in the future we should hope for buses that do the
negotiation of this for us and we can just map things out for them in the
kernel. benh seems to note ppc does some hackery for this but I wouldn't bet
on it being viable without issues on x86 just unless a thorough review / big
wagers are made.

  Luis
