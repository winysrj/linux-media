Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35149 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbFMGhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jun 2015 02:37:38 -0400
Date: Sat, 13 Jun 2015 08:37:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Beulich <JBeulich@suse.com>, Juergen Gross <jgross@suse.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Dave Airlie <airlied@redhat.com>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	X86 ML <x86@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-media@vger.kernel.org, Luis Rodriguez <Mcgrof@suse.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Toshi Kani <toshi.kani@hp.com>, Borislav Petkov <bp@suse.de>,
	Julia Lawall <julia.lawall@lip6.fr>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	ville.syrjala@linux.intel.com
Subject: Re: [Xen-devel] RIP MTRR - status update for upcoming v4.2
Message-ID: <20150613063731.GB12612@gmail.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com>
 <557AAD910200007800084014@mail.emea.novell.com>
 <CALCETrXWZU2NZRZy7b74z54Tt5aKmTOmgMmf5WYG1OZtEmjw7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXWZU2NZRZy7b74z54Tt5aKmTOmgMmf5WYG1OZtEmjw7A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Andy Lutomirski <luto@amacapital.net> wrote:

> On Jun 12, 2015 12:59 AM, "Jan Beulich" <JBeulich@suse.com> wrote:
> >
> > >>> On 12.06.15 at 01:23, <toshi.kani@hp.com> wrote:
> > > There are two usages on MTRRs:
> > >  1) MTRR entries set by firmware
> > >  2) MTRR entries set by OS drivers
> > >
> > > We can obsolete 2), but we have no control over 1).  As UEFI firmwares
> > > also set this up, this usage will continue to stay.  So, we should not
> > > get rid of the MTRR code that looks up the MTRR entries, while we have
> > > no need to modify them.
> > >
> > > Such MTRR entries provide safe guard to /dev/mem, which allows privileged 
> > > user to access a range that may require UC mapping while the /dev/mem driver 
> > > blindly maps it with WB.  MTRRs converts WB to UC in such a case.
> >
> > But it wouldn't be impossible to simply read the MTRRs upon boot, store the 
> > information, disable MTRRs, and correctly use PAT to achieve the same effect 
> > (i.e. the "blindly maps" part of course would need fixing).
> 
> This may crash and burn badly when we call a UEFI function or an SMI happens.  I 
> think we should just leave the MTRRs alone.

Not to mention suspend/resume, reboot and other goodies where the firmware might 
pop up expecting intact MTRRs.

Btw., doesn't a lack of MTRRs imply UC? So is 'crash and burn' possible in most 
cases? Isn't it just 'executes slower than before'?

Thanks,

	Ingo
