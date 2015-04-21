Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554AbbDURf5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 13:35:57 -0400
Date: Tue, 21 Apr 2015 19:35:53 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Toshi Kani <toshi.kani@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Roland Dreier <roland@purestorage.com>,
	Juergen Gross <jgross@suse.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Davidlohr Bueso <dbueso@suse.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	mcgrof@do-not-panic.com
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Message-ID: <20150421173553.GM5622@wotan.suse.de>
References: <20150410210538.GB5622@wotan.suse.de>
 <1428699490.21794.5.camel@misato.fc.hp.com>
 <CALCETrUP688aNjckygqO=AXXrNYvLQX6F0=b5fjmsCqqZU78+Q@mail.gmail.com>
 <20150411012938.GC5622@wotan.suse.de>
 <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
 <20150413174938.GE5622@wotan.suse.de>
 <1429137531.1899.28.camel@palomino.walls.org>
 <CALCETrUFtEMYh8i00ke0f939=17bAQxMDOBZMn_3yk3Nz1AnFA@mail.gmail.com>
 <1429142387.1899.57.camel@palomino.walls.org>
 <CALCETrWRjGYqcYPNizrbiVFwFHhrLf=8NTTCLVZh7Q6MgAWj=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWRjGYqcYPNizrbiVFwFHhrLf=8NTTCLVZh7Q6MgAWj=Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 15, 2015 at 05:58:14PM -0700, Andy Lutomirski wrote:
> On Wed, Apr 15, 2015 at 4:59 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Wed, 2015-04-15 at 16:42 -0700, Andy Lutomirski wrote:
> >> On Wed, Apr 15, 2015 at 3:38 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> >
> >> >
> >>
> >> IMO the right solution would be to avoid ioremapping the whole bar at
> >> startup.  Instead ioremap pieces once the driver learns what they are.
> >> This wouldn't have any of these problems -- you'd ioremap() register
> >> regions and you'd ioremap_wc() the framebuffer once you find it.  If
> >> there are regions of unknown purpose, just don't map them all.
> >>
> >> Would this be feasible?
> >
> > Feasible? Maybe.
> >
> > Worth the time and effort for end-of-life, convential PCI hardware so I
> > can have an optimally performing X display on a Standard Def Analog TV
> > screen?   Nope. I don't have that level of nostalgia.
> >
> 
> The point is actually to let us unexport or delete mtrr_add.  We can
> either severely regress performance on ivtv on PAT-capable hardware if
> we naively switch it to arch_phys_wc_add or we can do something else.
> The something else remains to be determined.

Back to square one: I can't come up with anything not too instrusive
or that dotes not requires substantial amount of work as an alternative to
removing MTRR completely right now (with the long term goal of also
making strong UC default) and its because of 2 device drivers:

  * ivtv: firmware API is poo and device is legacy, no one cares
  * ipath: driver needs a clean split and work is considerable,
    maintainers have not been responsive, do they care?

What do we want to do with these drivers? Let us be straight shooters,
if we are serious about having a performance regression on the drivers
for the sake of removing MTRR why not just seriously discuss removal
of these drivers. This way we can remain sane, upkeep a policy to
never even consider overlapping ioremap*() calls, and have a clean
expected strategy we can expect for new drivers.

I'm going to split up my patches now into 4 series:

1) things which are straight forward in converting drivers over
   to arch_phys_wc_add() and ioremap_wc(). These are subsystem
   wide though, so just a heads up, my hope is that each subsystem
   maintainer can take their own series unless someone else is
   comfortable in taking this in for x86

2) a few helpers in the like of ioremap_wc() needed for other drivers.
   These are straight forward but since they depend on x86 / core
   helpers it would be nice for them to go I guess through x86 folks.
   What maintainer is up to take these?

3) MTRR run time changes

4) corner cases - TBD - lets discuss here what we want to do with
   ivtv and ipath. I will however remove fusion's mtrr code use
   as its all commented out.

  Luis
