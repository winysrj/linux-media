Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34616 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858AbbDOXnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 19:43:06 -0400
Received: by lbcga7 with SMTP id ga7so46187847lbc.1
        for <linux-media@vger.kernel.org>; Wed, 15 Apr 2015 16:43:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429137531.1899.28.camel@palomino.walls.org>
References: <20150410171750.GA5622@wotan.suse.de> <CALCETrUG=RiG8S9Gpiqm_0CxvxurxLTNKyuyPoFNX46EAauA+g@mail.gmail.com>
 <CAB=NE6XgNgu7i2OiDxFVJLWiEjbjBY17-dV7L3yi2+yzgMhEbw@mail.gmail.com>
 <1428695379.6646.69.camel@misato.fc.hp.com> <20150410210538.GB5622@wotan.suse.de>
 <1428699490.21794.5.camel@misato.fc.hp.com> <CALCETrUP688aNjckygqO=AXXrNYvLQX6F0=b5fjmsCqqZU78+Q@mail.gmail.com>
 <20150411012938.GC5622@wotan.suse.de> <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
 <20150413174938.GE5622@wotan.suse.de> <1429137531.1899.28.camel@palomino.walls.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Apr 2015 16:42:43 -0700
Message-ID: <CALCETrUFtEMYh8i00ke0f939=17bAQxMDOBZMn_3yk3Nz1AnFA@mail.gmail.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
To: Andy Walls <awalls@md.metrocast.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
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
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 15, 2015 at 3:38 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> Hi All,
>
> On Mon, 2015-04-13 at 19:49 +0200, Luis R. Rodriguez wrote:
> [snip]
>>  I only saw a few drivers using overlapping ioremap*()
>> calls though on my MTRR review and they are all old devices so likely mostly
>> used on non-PAT systems, but there might be other corner cases elsewhere.
>>
>> Lets recap, as I see it we have a few options with all this in mind on our
>> quest to bury MTRR (and later make strong UC default):
>>
>> 1) Let drivers do their own get_vm_area() calls as you note and handle the
>>    cut and splicing of ioremap areas
>>
>> 2) Provide an API to split and splice ioremap ranges
>>
>> 3) Try to avoid these types of situations and let drivers simply try to
>>    work towards a proper clean non-overlapping different ioremap() ranges
>>
>> Let me know if you think of others but please keep in mind the UC- to strong
>> UC converstion we want to do later as well. We have ruled out using
>> set_memor_wc() now.
>>
>> I prefer option 3), its technically possible but only for *new* drivers
>> and we'd need either some hard work to split the ioremap() areas or provide
>> a a set of *transient* APIs as I had originally proposed to phase / hope for
>> final transition. There are 3 drivers to address:
>>
>> [snip]
>
> Just some background for folks:
> The ivtv driver supports cards that perform Standard Definition PAL,
> NTSC, and SECAM TV capture + hardware MPEG-2 encoding and MPEG-2
> decoding + TV output.
>
> Of the supported cards only *one* card type, the PVR-350 based on the
> CX23415 chip, can perform the MPEG-2 or YUV video decoding and output,
> with an OSD overlay.  PVR-350's are legacy PCI cards that have been end
> of life since 2088 or earlier.  Despite that, there are still used units
> available on Amazon and eBay.
>
> The ivtvfb driver module is an *optional* companion driver module that
> provides a framebuffer interface for the user to output an X display, FB
> console, or whatever to a standard definition analog PAL, NTSC, or SECAM
> TV or VCR.  It does this by co-opting the OSD overlay of the video
> decoding output engine and having it take up the whole screen.
>
>
>
>> c) ivtv: the driver does not have the PCI space mapped out separately, and
>> in fact it actually does not do the math for the framebuffer, instead it lets
>> the device's own CPU do that and assume where its at, see
>> ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
>> but not a setter. Its not clear if the firmware would make a split easy.
>
> The CX2341[56]'s firmware + hardware machine are notorious for bugs and
> being hard to work with.  It would be difficult to determine with any
> certainty that the firmware returned predictable OSD framebuffer
> addresses from one user's system to the next.
>
>
>> We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
>
> Yes.
>
> As a driver writer/maintainer, IMO the name ioremap_ucminus() is jargon,
> without a clear meaning from the name, and maybe too x86 PAT specific?
> The pat.txt file under Documentation didn't explain what UC- meant; I
> had to go searching old LKML emails to understand it was a unchached
> region that could be overridden with write combine regions.
>
> To me names along, these lines would be better:
>    ioremap_nocache_weak(), or
>    ioremap_nocache_mutable(), or
>    ioremap_nocache()  (with ioremap_nocache_strong() or something for
> the UC version)
>

IMO the right solution would be to avoid ioremapping the whole bar at
startup.  Instead ioremap pieces once the driver learns what they are.
This wouldn't have any of these problems -- you'd ioremap() register
regions and you'd ioremap_wc() the framebuffer once you find it.  If
there are regions of unknown purpose, just don't map them all.

Would this be feasible?

--Andy
