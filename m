Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:36446 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbbDPTT2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 15:19:28 -0400
Received: by lagv1 with SMTP id v1so64330857lag.3
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 12:19:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429146083.1899.94.camel@palomino.walls.org>
References: <20150410171750.GA5622@wotan.suse.de> <CALCETrUG=RiG8S9Gpiqm_0CxvxurxLTNKyuyPoFNX46EAauA+g@mail.gmail.com>
 <CAB=NE6XgNgu7i2OiDxFVJLWiEjbjBY17-dV7L3yi2+yzgMhEbw@mail.gmail.com>
 <1428695379.6646.69.camel@misato.fc.hp.com> <20150410210538.GB5622@wotan.suse.de>
 <1428699490.21794.5.camel@misato.fc.hp.com> <CALCETrUP688aNjckygqO=AXXrNYvLQX6F0=b5fjmsCqqZU78+Q@mail.gmail.com>
 <20150411012938.GC5622@wotan.suse.de> <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
 <20150413174938.GE5622@wotan.suse.de> <1429137531.1899.28.camel@palomino.walls.org>
 <CALCETrUFtEMYh8i00ke0f939=17bAQxMDOBZMn_3yk3Nz1AnFA@mail.gmail.com>
 <1429142387.1899.57.camel@palomino.walls.org> <CALCETrWRjGYqcYPNizrbiVFwFHhrLf=8NTTCLVZh7Q6MgAWj=Q@mail.gmail.com>
 <1429146083.1899.94.camel@palomino.walls.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Apr 2015 12:19:05 -0700
Message-ID: <CALCETrX9xWtaw=1abNK1WSNgkAfR3b1gVpTeTC2Rn93SAJv4_w@mail.gmail.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Roland Dreier <roland@purestorage.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	Borislav Petkov <bp@suse.de>,
	Sean Hefty <sean.hefty@intel.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Toshi Kani <toshi.kani@hp.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Davidlohr Bueso <dbueso@suse.de>, linux-media@vger.kernel.org,
	Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 15, 2015 6:54 PM, "Andy Walls" <awalls@md.metrocast.net> wrote:
>
> On Wed, 2015-04-15 at 17:58 -0700, Andy Lutomirski wrote:
> > On Wed, Apr 15, 2015 at 4:59 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > > On Wed, 2015-04-15 at 16:42 -0700, Andy Lutomirski wrote:
> > >> On Wed, Apr 15, 2015 at 3:38 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > >
> > >> >
> > >>
> > >> IMO the right solution would be to avoid ioremapping the whole bar at
> > >> startup.  Instead ioremap pieces once the driver learns what they are.
> > >> This wouldn't have any of these problems -- you'd ioremap() register
> > >> regions and you'd ioremap_wc() the framebuffer once you find it.  If
> > >> there are regions of unknown purpose, just don't map them all.
> > >>
> > >> Would this be feasible?
> > >
> > > Feasible? Maybe.
> > >
> > > Worth the time and effort for end-of-life, convential PCI hardware so I
> > > can have an optimally performing X display on a Standard Def Analog TV
> > > screen?   Nope. I don't have that level of nostalgia.
> > >
> >
> > The point is actually to let us unexport or delete mtrr_add.
>
> Understood.
>
>
> >   We can
> > either severely regress performance on ivtv on PAT-capable hardware if
> > we naively switch it to arch_phys_wc_add or we can do something else.
> > The something else remains to be determined.
>
> Maybe ioremap the decoder register area as UC, and ioremap the rest of
> the decoder region to WC. (Does that suck up too many PAT resources?

PAT resources are unlimited.

> Then add PCI reads following any sort of singleton PCI writes in the WC
> region.  I assume PCI rules about write postings before reads still
> apply when WC is set.
>

I think we need sfence, too, but that's easy.  We also lose the write
sizes.  That is, adjacent writes get combined.  Maybe that's okay.

> > >
> > > We sort of know where some things are in the MMIO space due to
> > > experimentation and past efforts examining the firmware binary.
> > >
> > > Documentation/video4linux/cx2341x/fw-*.txt documents some things.  The
> > > driver code actually codifies a little bit more knowledge.
> > >
> > > The driver code for doing transfers between host and card is complex and
> > > fragile with some streams that use DMA, other streams that use PIO,
> > > digging VBI data straight out of card memory, and scatter-gather being
> > > broken on newer firmwares.  Playing around with ioremapping will be hard
> > > to get right and likely cause something in the code to break for the
> > > primary use case of the ivtv supported cards.
> >
> > Ick.
>
> Yeah.
>
> > If the only thing that really wants WC is the esoteric framebuffer
> > thing,
>
> That appears to be it.
>
> >  could we just switch to arch_phys_wc_add and assume that no one
> > will care about the regression on new CPUs with ivtv cards?
>
> That's on the table in my mind.  Not sure if it is the friendliest thing
> to do to users.  Quite honestly though, modern graphics cards have much
> better ouput resolution and performance.  Anyone with a modern system
> really should be using one.  (i.e. MythTV gave up on support for PVR-350
> output for video playback years ago in May 2010.)
>
>
> BTW, my 2005 system with multiple conventional PCI slots in it shows a
> 'pat' flag in /proc/cpuinfo.  (AMD Athlon(tm) 64 X2 Dual Core Processor
> 4200+)  I didn't know it was considered "new". :)

Tons of CPUs have that ability, but we often turn it off due to errata
on older CPUs.

--Andy

>
> Regards,
> Andy
>
>
