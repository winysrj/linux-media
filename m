Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbbD0Qnd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 12:43:33 -0400
Date: Mon, 27 Apr 2015 18:43:26 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-media@vger.kernel.org, luto@amacapital.net, mst@redhat.com,
	linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Juergen Gross <jgross@suse.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Stefan Bader <stefan.bader@canonical.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
	Borislav Petkov <bp@suse.de>, Davidlohr Bueso <dbueso@suse.de>,
	konrad.wilk@oracle.com, ville.syrjala@linux.intel.com,
	david.vrabel@citrix.com, jbeulich@suse.com, toshi.kani@hp.com,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
	ivtv-devel@ivtvdriver.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] [media] ivtv: use arch_phys_wc_add() and require PAT
 disabled
Message-ID: <20150427164325.GR5622@wotan.suse.de>
References: <1429731182-6974-1-git-send-email-mcgrof@do-not-panic.com>
 <1429960325.2109.13.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1429960325.2109.13.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 25, 2015 at 07:12:05AM -0400, Andy Walls wrote:
> Hi Luis,
> 
> Sorry for the late reply.
> 
> Thank you for the patch! See my comments below:
> 
> On Wed, 2015-04-22 at 12:33 -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > We are burrying direct access to MTRR code support on
> > x86 in order to take advantage of PAT. In the future we
> > also want to make the default behaviour of ioremap_nocache()
> > to use strong UC, use of mtrr_add() on those systems
> > would make write-combining void.
> > 
> > In order to help both enable us to later make strong
> > UC default and in order to phase out direct MTRR access
> > code port the driver over to arch_phys_wc_add() and
> > annotate that the device driver requires systems to
> > boot with PAT disabled, with the nopat kernel parameter.
> > 
> > This is a worthy comprmise given that the hardware is
> > really rare these days,
> 
> I'm OK with the compromise solution.  It makes sense.

OK great!

> > diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> > index 9ff1230..552408b 100644
> > --- a/drivers/media/pci/ivtv/ivtvfb.c
> > +++ b/drivers/media/pci/ivtv/ivtvfb.c
> > @@ -1120,6 +1121,7 @@ static int ivtvfb_init_io(struct ivtv *itv)
> >  	oi->video_buffer_size = 1704960;
> >  
> >  	oi->video_pbase = itv->base_addr + IVTV_DECODER_OFFSET + oi->video_rbase;
> > +	/* XXX: split this for PAT */
> 
> Please remove this comment. 

Done.

> > @@ -1190,6 +1172,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
> >  {
> >  	int rc;
> >  
> > +#ifdef CONFIG_X86_64
> > +	if (WARN(pat_enabled,
> 
> This check might be better placed in ivtvfb_init().  This check is going
> to have the same result for every PVR-350 card in the system that is
> found by ivtvfb.

OK moved!

> > +		 "ivtv needs PAT disabled, boot with nopat kernel parameter\n")) {
> 
> This needs to read "ivtvfb needs [...]" to avoid user confusion with the
> main ivtv driver module.

OK!

> This change is the only one I really care about.  Then I can give my
> Ack.

OK!

  Luis
