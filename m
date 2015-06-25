Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbbFYRPx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 13:15:53 -0400
Date: Thu, 25 Jun 2015 19:15:49 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, bp@suse.de,
	andy@silverblocksystems.net, mchehab@osg.samsung.com,
	dledford@redhat.com, fengguang.wu@intel.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/mm/pat, drivers/infiniband/ipath: replace
 WARN() with pr_warn()
Message-ID: <20150625171549.GG3005@wotan.suse.de>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-2-git-send-email-mcgrof@do-not-panic.com>
 <20150625064922.GA5339@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150625064922.GA5339@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2015 at 08:49:22AM +0200, Ingo Molnar wrote:
> 
> * Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> 
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > WARN() may confuse users, fix that. ipath_init_one() is part the
> > device's probe so this would only be triggered if a corresponding
> > device was found.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
> > index 2d7e503..871dbe5 100644
> > --- a/drivers/infiniband/hw/ipath/ipath_driver.c
> > +++ b/drivers/infiniband/hw/ipath/ipath_driver.c
> > @@ -31,6 +31,8 @@
> >   * SOFTWARE.
> >   */
> >  
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> >  #include <linux/sched.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/idr.h>
> > @@ -399,8 +401,8 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  	u32 bar0 = 0, bar1 = 0;
> >  
> >  #ifdef CONFIG_X86_64
> > -	if (WARN(pat_enabled(),
> > -		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
> > +	if (pat_enabled()) {
> > +		pr_warn("ipath needs PAT disabled, boot with nopat kernel parameter\n");
> >  		ret = -ENODEV;
> >  		goto bail;
> >  	}
> 
> So driver init will always fail with this on modern kernels.

Nope, I double checked this, ipath_init_one() is the PCI probe routine,
not the module init call. It should probably be renamed.

> Btw., on a second thought, ipath uses MTRRs to enable WC:
> 
>         ret = ipath_enable_wc(dd);
>         if (ret)
>                 ret = 0;
> 
> Note how it ignores any failures - the driver still works even if WC was not 
> enabled.

Ah, well WC strategy requires a split of the MMIO registers and the desired
WC area, right now they are combined for some type of ipath devices. There
are two things to consider when thinking about whether or not we want to
do the work required to do the split:

1) The state of affairs of the ipath driver
2) The effort required to do the ipath MMIO register / WC split

As for 1): the ipath driver is deprecated, the folks who maintain it
haven't used the driver in testing for 3-4 years now. The ipath driver
powers the old HTX bus card that only work in AMD systems, the replacement
driver is the qib infiniband driver , it powers all PCI-E cards. Doug
was even talking about removing the driver from the kernel [0] [1].

As for 2): I looked into doing the split and what makes it really
hard is that the ipath driver has a character device that is used
for diagnostics which lets userspace poke at the PCI device's
ioremap'd space, for the split case some magic needs to be done to
ensure the driver uses the right offset. So apart from addressing the
split and driver's use the character device mapping calls also would
need to be fixed.

I did the work on the atyfb driver to demo work effort required to
address the split, I did look to doing it for both the ipath and
ivtv driver but for both 1) and 2) indicated it was not worth it.

[0] http://lkml.kernel.org/r/1429728791.121496.10.camel@redhat.com
[1] http://lkml.kernel.org/r/1430159932.44548.20.camel@redhat.com

> So why don't you simply extend ipath_enable_wc() to generate the warning message 
> and return -EINVAL - which still keeps the driver working on modern kernels?

We would need to do the split.

> Just inform the user about 'nopat' if he wants WC for this driver.

If we had the split we could do this.

  Luis
