Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbbDMRto (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 13:49:44 -0400
Date: Mon, 13 Apr 2015 19:49:38 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Roland Dreier <roland@purestorage.com>,
	Juergen Gross <jgross@suse.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Davidlohr Bueso <dbueso@suse.de>, dave.hansen@linux.intel.com,
	plagnioj@jcrosoft.com, tglx@linutronix.de,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	x86@kernel.org
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Message-ID: <20150413174938.GE5622@wotan.suse.de>
References: <20150410171750.GA5622@wotan.suse.de>
 <CALCETrUG=RiG8S9Gpiqm_0CxvxurxLTNKyuyPoFNX46EAauA+g@mail.gmail.com>
 <CAB=NE6XgNgu7i2OiDxFVJLWiEjbjBY17-dV7L3yi2+yzgMhEbw@mail.gmail.com>
 <1428695379.6646.69.camel@misato.fc.hp.com>
 <20150410210538.GB5622@wotan.suse.de>
 <1428699490.21794.5.camel@misato.fc.hp.com>
 <CALCETrUP688aNjckygqO=AXXrNYvLQX6F0=b5fjmsCqqZU78+Q@mail.gmail.com>
 <20150411012938.GC5622@wotan.suse.de>
 <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc'ing a few others as we ended up talking about the cruxes of my
unposted v2 series as I confirmed that set_memor_wc() would not work
as an alternative to my originally proposed __arch_phys_wc_add() to
force MTRR as a last resort on a few set of last remaining drivers.
This also discusses overlapping ioremap() calls and what we'd need
for a default shift from UC- to strong UC.

On Fri, Apr 10, 2015 at 11:25:22PM -0700, Andy Lutomirski wrote:
> On Apr 10, 2015 6:29 PM, "Luis R. Rodriguez" <mcgrof@suse.com> wrote:
> >
> > On Fri, Apr 10, 2015 at 02:22:51PM -0700, Andy Lutomirski wrote:
> > > On Fri, Apr 10, 2015 at 1:58 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > > > On Fri, 2015-04-10 at 23:05 +0200, Luis R. Rodriguez wrote:
> > > >> On Fri, Apr 10, 2015 at 01:49:39PM -0600, Toshi Kani wrote:
> > > >> > On Fri, 2015-04-10 at 12:34 -0700, Luis R. Rodriguez wrote:
> > > >> > > On Fri, Apr 10, 2015 at 12:14 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > > >> > > > On Fri, Apr 10, 2015 at 10:17 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > > >> > > >>
> > > >> > > >> Andy, I'm ready to post a v2 series based on review of the first iteration of
> > > >> > > >> the bury-MTRR series however I ran into a snag in vetting for the ioremap_uc()
> > > >> > > >> followed by a set_memory_wc() strategy as a measure to both avoid when possible
> > > >> > > >> overlapping ioremap*() calls and/or to avoid the power of 2 MTRR size
> > > >> > > >> implications on having to use multiple MTRRs.
> > > >> > > >>
> > > >> > > >> I tested the strategy by just making my thinkpad's i915 driver use iremap_uc()
> > > >> > > >> which I add, and then use set_memory_wc(). To start off with I should note
> > > >> > > >> set_memory_*() helpers are x86 specific right now, this is not a problem for
> > > >> > > >> the series but its worth noting as we're replacing MTRR strategies which
> > > >> > > >> are x86 specific, but I am having issues getting set_memory_wc() take effect
> > > >> > > >> on my intel graphics card.
> > > >> > > >>
> > > >> > > >> I've reviewed if this is OK in code and I see no issues other than set_memory_*()
> > > >> > > >> helpers seem to be desirable for RAM, not IO memory, so was wondering if we need
> > > >> > > >> to add other helpers which can address IO memory or if this should work? The diff
> > > >> > > >> for the drivers is below, the actual commit for adding ioremap_uc() folllows
> > > >> > > >> with its commit log. Feedback / review on both is welcome as well as if you
> > > >> > > >> could help me figure out why this test-patch for i915 fails.
> > > >> > > >
> > > >> > > > I think they should work for IO memory, but I'm not really an authority here.
> > > >> > > >
> > > >> > > > Adding some people who have looked at the code recently.
> > > >> > >
> > > >> > > I was avoiding reviewing the cpa code but since this failed I just had
> > > >> > > to review it and I see nothing prevent it from being used on IO memory
> > > >> > > but -- memtype_rb_check_conflict() does prevent an overlap to be set
> > > >> > > on an *existing range* -- and since ioremap_uc() was used earlier the
> > > >> > > first reserve_memtype() with _PAGE_CACHE_MODE_WC by set_memory_wc() I
> > > >> > > believe should fail then. Please correct me if I'm wrong, I don't see
> > > >> > > the "conflicting memory types" print though, so not sure if it was
> > > >> > > because of that.
> > > >> > >
> > > >> > > I only started looking at this though but shouldn't this also mean we
> > > >> > > can't use overlapping ioremap() calls too? I thought that worked,
> > > >> > > because at least some drivers are using that strategy.
> > > >> >
> > > >> > set_memory_*() does not work with I/O memory ranges with the following
> > > >> > reasons:
> > > >> >
> > > >> > 1. __pa(addr) returns a fake address since there is no direct map.
> > > >> > 2. reserve_memtype() tracks regular memory and I/O memory differently.
> > > >> > For regular memory, set_memory_*() can modify WB with a new type since
> > > >> > reserve_memtype() does not track WB.  For I/O memory, reserve_memtype()
> > > >> > detects a conflict when a given type is different from a tracked type.
> > > >>
> > > >> Interesting, but I also just realized I had messed up my test patch too,
> > > >> I checked for (!ret) instead of (ret). This works now.
> > > >>
> > > >> > > diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
> > > >> > > index dccdc8a..dd9501b 100644
> > > >> > > --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> > > >> > > +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> > > >> > > @@ -1958,12 +1958,22 @@ static int ggtt_probe_common(struct drm_device *dev,
> > > >> > >         gtt_phys_addr = pci_resource_start(dev->pdev, 0) +
> > > >> > >                 (pci_resource_len(dev->pdev, 0) / 2);
> > > >> > >
> > > >> > > -       dev_priv->gtt.gsm = ioremap_wc(gtt_phys_addr, gtt_size);
> > > >> > > +       dev_priv->gtt.gsm = ioremap_uc(gtt_phys_addr, gtt_size);
> > > >> > >         if (!dev_priv->gtt.gsm) {
> > > >> > >                 DRM_ERROR("Failed to map the gtt page table\n");
> > > >> > >                 return -ENOMEM;
> > > >> > >         }
> > > >> > >
> > > >> > > +       printk("mcgrof:set_memory_wc() ggtt_probe_common()\n");
> > > >> > > +
> > > >> > > +       ret = set_memory_wc((unsigned long) dev_priv->gtt.gsm, gtt_size >> PAGE_SHIFT);
> > > >> > > +       if (!ret) {
> > > >>
> > > >> Mess up here.
> > > >>
> > > >> > > +               DRM_ERROR("mcgrof: failed set_memory_wc()\n");
> > > >> > > +               iounmap(dev_priv->gtt.gsm);
> > > >> > > +               return ret;
> > > >> > > +       }
> > > >> > > +
> > > >> > > +
> > > >> > >         ret = setup_scratch_page(dev);
> > > >> > >         if (ret) {
> > > >> > >                 DRM_ERROR("Scratch setup failed\n");
> > > >>
> > > >> as I read the code though reserve_memtype() should not allow for a change
> > > >> of an existing type as you note though (and therefore prevent also
> > > >> overlapping ioremap() calls on PAT), but since this is going through now
> > > >> I am not sure at if this is by chance somehow... ?
> > > >
> > > > Unless you fixed issue #1 above, set_memory_wc() passes a bogus address
> > > > to reserve_memtype().  Hence, it won't cause any conflict.
> > >
> > > Presumably fixing #1 would be okay (slow_virt_to_phys or whatever)
> > > since this stuff is already slow.
> >
> > That wouldn't cut it I think. That would still fail as the types
> > don't match. That means we would have to free_memtype() and
> > then alloc a new reserve_memtype(), but I don't think that's
> > enought still. For instance a new ioremap() does:
> >
> > 1) sanity checks on regions of memory
> > 2) get_vm_area_caller() for the range
> > 3) kernel_map_sync_memtype()
> > 4) ioremap_page_range()
> > 5) mmiotrace_ioremap()
> >
> > Correct me if I'm wrong but I think we'd need to do all this as well.
> > If so we'd be cutting and splicing an ioremap() range. This code would
> > seem tricky to get right. Maybe its best to not support this then and
> > simply have to live with having drivers do their own splititn gof
> > ioremap() calls.
> >
> > This *might* implicate some constraints on burrying MTRR though so...
> > please let me know what you think.
> 
> To throw out more ideas, what if the drivers instead did their own
> get_vm_area vmap calls and then mapped the two consecutive regions
> separately at consecutive addresses?

Instead of having an API do it for them? They'd have to implement quite a bit.
Driver writers also tend to not have the best of judgement and *typically* just
copy and paste code, so we'd have to either annotate it well as a work around
for a few drivers (in my series there are 3 that need this in order for us to
bury MTRR) and not share the code or provide an API for these cases.

Note that I belive these findings should also mean, if I understand things
correctly, that when PAT is used overlapping ioremap*() calls may work with
the caveat that the type of cache used will depend on the offset used, one
cannot hope that using either offset will yield the same caching effects.
There might even be other caveats with this but that will depend on the
hardware and not sure what those effects are. The reason is that for the
the cache effects requiring the appropriate offset is reserve_memtype() on IO
memory will use a fake address and this can in turn mean that even though the
same "pa" address was used we could end up with it not really checking
conflicts with the original reserve_memtype(). Some parts of this complexity
were described above. I only saw a few drivers using overlapping ioremap*()
calls though on my MTRR review and they are all old devices so likely mostly
used on non-PAT systems, but there might be other corner cases elsewhere.

Lets recap, as I see it we have a few options with all this in mind on our
quest to bury MTRR (and later make strong UC default):

1) Let drivers do their own get_vm_area() calls as you note and handle the
   cut and splicing of ioremap areas

2) Provide an API to split and splice ioremap ranges

3) Try to avoid these types of situations and let drivers simply try to
   work towards a proper clean non-overlapping different ioremap() ranges

Let me know if you think of others but please keep in mind the UC- to strong
UC converstion we want to do later as well. We have ruled out using
set_memor_wc() now.

I prefer option 3), its technically possible but only for *new* drivers
and we'd need either some hard work to split the ioremap() areas or provide
a a set of *transient* APIs as I had originally proposed to phase / hope for
final transition. There are 3 drivers to address:

a) atyfb: fortunately I believe I have finished the split for the atyfb
driver, ioremap_uc() would be used on only the MMIO region while ioremap_wc()
on the framebuffer (with newly corrected fixed size). This would go in as
an example of what work was required to do a split.

b) ipath:  while a split on ipath is possible the changes are quite
significant. Apart from changing the driver to use different offset bases
in different regions the driver also has a debug userspace filemap for
the entire register map, the code there would need to be modified to
use the right virtual address base depending on the virtual address accessed.
The qib driver already has logic which could be mimic'd for this fortunatley,
but still - this is considerable work. One side hack I was hoping for
was that overlapping ioremap*() calls with different page attribute
types would work even if the 2nd returned __iomem address was not used,
based on my review and Toshi's feedback on reserve_memtype() this would
_not work_, only using the right virtual address would ensure the right
caching technique is used. In fact since this is not really all clear
I would not be surprised if there are other caveats. Sticking to the original
__arch_phys_wc_add() to force MTRR use here might be best but note that
even if this is done an eventual change from ioremap_nocache() to default
from UC- to strong UC would cause a regression on the desired WC area, in
this case on the PIO buffers. We may need an API to keep UC- for drivers that
know that need it -- or we may need to really do tha hard work to try to
convert this driver to split the iorenmap*() areas. If we do not want to do the
work to split this driver's ioremap*() space we could live with having
__arch_phys_wc_add() and another API to force UC- even if later the default is
strong UC.

c) ivtv: the driver does not have the PCI space mapped out separately, and
in fact it actually does not do the math for the framebuffer, instead it lets
the device's own CPU do that and assume where its at, see
ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
but not a setter. Its not clear if the firmware would make a split easy.
We'd need ioremap_ucminus() here too and __arch_phys_wc_add().

>From the beginning it seems only framebuffer devices used MTRR/WC, lately it
seems infiniband drivers also find good use for for it for PIO TX buffers to
blast some sort of data, in the future I would not be surprised if other
devices found use for it. It may be true that the existing drivers that
requires the above type of work are corner cases -- but I wouldn't hold my
breath for that. The ivtv device is a good example of the worst type of
situations and these days. So perhap __arch_phys_wc_add() and a
ioremap_ucminus() might be something more than transient unless hardware folks
get a good memo or already know how to just Do The Right Thing (TM).

 Luis
