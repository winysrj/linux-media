Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32892 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbFZIpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 04:45:51 -0400
Date: Fri, 26 Jun 2015 10:45:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Hyong-Youb Kim <hkim@cspi.com>,
	Andy Walls <awalls@md.metrocast.net>, benh@kernel.crashing.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>, bp@suse.de,
	andy@silverblocksystems.net, mchehab@osg.samsung.com,
	dledford@redhat.com, fengguang.wu@intel.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and
 replace WARN() with pr_warn()
Message-ID: <20150626084546.GD26303@gmail.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
 <20150625065147.GB5339@gmail.com>
 <20150625173847.GH3005@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150625173847.GH3005@wotan.suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Luis R. Rodriguez <mcgrof@suse.com> wrote:

> On Thu, Jun 25, 2015 at 08:51:47AM +0200, Ingo Molnar wrote:
> > 
> > * Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> > 
> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > 
> > > On built-in kernels this warning will always splat as this is part
> > > of the module init. Fix that by shifting the PAT requirement check
> > > out under the code that does the "quasi-probe" for the device. This
> > > device driver relies on an existing driver to find its own devices,
> > > it looks for that device driver and its own found devices, then
> > > uses driver_for_each_device() to try to see if it can probe each of
> > > those devices as a frambuffer device with ivtvfb_init_card(). We
> > > tuck the PAT requiremenet check then on the ivtvfb_init_card()
> > > call making the check at least require an ivtv device present
> > > before complaining.
> > > 
> > > Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > > ---
> > >  drivers/media/pci/ivtv/ivtvfb.c | 15 +++++++++------
> > >  1 file changed, 9 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> > > index 4cb365d..8b95eef 100644
> > > --- a/drivers/media/pci/ivtv/ivtvfb.c
> > > +++ b/drivers/media/pci/ivtv/ivtvfb.c
> > > @@ -38,6 +38,8 @@
> > >      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> > >   */
> > >  
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +
> > >  #include <linux/module.h>
> > >  #include <linux/kernel.h>
> > >  #include <linux/fb.h>
> > > @@ -1171,6 +1173,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
> > >  {
> > >  	int rc;
> > >  
> > > +#ifdef CONFIG_X86_64
> > > +	if (pat_enabled()) {
> > > +		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
> > > +		return -ENODEV;
> > > +	}
> > > +#endif
> > > +
> > >  	if (itv->osd_info) {
> > >  		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
> > >  		return -EBUSY;
> > 
> > Same argument as for ipath: why not make arch_phys_wc_add() fail on PAT and 
> > return -1, and check it in arch_phys_wc_del()?
> 
> The arch_phys_wc_add() is a no-op for PAT systems but for PAT to work we need 
> not only need to add this in where we replace the MTRR call but we also need to 
> convert ioremap_nocache() calls to ioremap_wc() but only if things were split up 
> already.

We don't need to do that: for such legacy drivers we can fall back to UC just 
fine, and inform the user that by booting with 'nopat' the old behavior will be 
back...

Thanks,

	Ingo
