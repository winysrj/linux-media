Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37560 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbbDPAEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 20:04:37 -0400
Message-ID: <1429137531.1899.28.camel@palomino.walls.org>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
From: Andy Walls <awalls@md.metrocast.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Toshi Kani <toshi.kani@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org,
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
	Davidlohr Bueso <dbueso@suse.de>, dave.hansen@linux.intel.com,
	plagnioj@jcrosoft.com, tglx@linutronix.de,
	Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	x86@kernel.org
Date: Wed, 15 Apr 2015 18:38:51 -0400
In-Reply-To: <20150413174938.GE5622@wotan.suse.de>
References: <20150410171750.GA5622@wotan.suse.de>
	 <CALCETrUG=RiG8S9Gpiqm_0CxvxurxLTNKyuyPoFNX46EAauA+g@mail.gmail.com>
	 <CAB=NE6XgNgu7i2OiDxFVJLWiEjbjBY17-dV7L3yi2+yzgMhEbw@mail.gmail.com>
	 <1428695379.6646.69.camel@misato.fc.hp.com>
	 <20150410210538.GB5622@wotan.suse.de>
	 <1428699490.21794.5.camel@misato.fc.hp.com>
	 <CALCETrUP688aNjckygqO=AXXrNYvLQX6F0=b5fjmsCqqZU78+Q@mail.gmail.com>
	 <20150411012938.GC5622@wotan.suse.de>
	 <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
	 <20150413174938.GE5622@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On Mon, 2015-04-13 at 19:49 +0200, Luis R. Rodriguez wrote:
[snip]
>  I only saw a few drivers using overlapping ioremap*()
> calls though on my MTRR review and they are all old devices so likely mostly
> used on non-PAT systems, but there might be other corner cases elsewhere.
> 
> Lets recap, as I see it we have a few options with all this in mind on our
> quest to bury MTRR (and later make strong UC default):
> 
> 1) Let drivers do their own get_vm_area() calls as you note and handle the
>    cut and splicing of ioremap areas
> 
> 2) Provide an API to split and splice ioremap ranges
> 
> 3) Try to avoid these types of situations and let drivers simply try to
>    work towards a proper clean non-overlapping different ioremap() ranges
> 
> Let me know if you think of others but please keep in mind the UC- to strong
> UC converstion we want to do later as well. We have ruled out using
> set_memor_wc() now.
> 
> I prefer option 3), its technically possible but only for *new* drivers
> and we'd need either some hard work to split the ioremap() areas or provide
> a a set of *transient* APIs as I had originally proposed to phase / hope for
> final transition. There are 3 drivers to address:
> 
> [snip]

Just some background for folks:
The ivtv driver supports cards that perform Standard Definition PAL,
NTSC, and SECAM TV capture + hardware MPEG-2 encoding and MPEG-2
decoding + TV output.

Of the supported cards only *one* card type, the PVR-350 based on the
CX23415 chip, can perform the MPEG-2 or YUV video decoding and output,
with an OSD overlay.  PVR-350's are legacy PCI cards that have been end
of life since 2088 or earlier.  Despite that, there are still used units
available on Amazon and eBay.

The ivtvfb driver module is an *optional* companion driver module that
provides a framebuffer interface for the user to output an X display, FB
console, or whatever to a standard definition analog PAL, NTSC, or SECAM
TV or VCR.  It does this by co-opting the OSD overlay of the video
decoding output engine and having it take up the whole screen.


 
> c) ivtv: the driver does not have the PCI space mapped out separately, and
> in fact it actually does not do the math for the framebuffer, instead it lets
> the device's own CPU do that and assume where its at, see
> ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
> but not a setter. Its not clear if the firmware would make a split easy.

The CX2341[56]'s firmware + hardware machine are notorious for bugs and
being hard to work with.  It would be difficult to determine with any
certainty that the firmware returned predictable OSD framebuffer
addresses from one user's system to the next.


> We'd need ioremap_ucminus() here too and __arch_phys_wc_add().

Yes.

As a driver writer/maintainer, IMO the name ioremap_ucminus() is jargon,
without a clear meaning from the name, and maybe too x86 PAT specific?
The pat.txt file under Documentation didn't explain what UC- meant; I
had to go searching old LKML emails to understand it was a unchached
region that could be overridden with write combine regions.

To me names along, these lines would be better:
   ioremap_nocache_weak(), or
   ioremap_nocache_mutable(), or
   ioremap_nocache()  (with ioremap_nocache_strong() or something for
the UC version)


> From the beginning it seems only framebuffer devices used MTRR/WC,
[snip]
>  The ivtv device is a good example of the worst type of
> situations and these days. So perhap __arch_phys_wc_add() and a
> ioremap_ucminus() might be something more than transient unless hardware folks
> get a good memo or already know how to just Do The Right Thing (TM).

Just to reiterate a subtle point, use of the ivtvfb is *optional*.  A
user may or may not load it.  When the user does load the ivtvfb driver,
the ivtv driver has already been initialized and may have functions of
the card already in use by userspace.

Hopefully no one is trying to use the OSD as framebuffer and the video
decoder/output engine for video display at the same time.  But the video
decoder/output device nodes may already be open for performing ioctl()
functions so unmapping the decoder IO space out from under them, when
loading the ivtvfb driver module, might not be a good thing. 

Regards,
Andy

