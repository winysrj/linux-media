Return-path: <linux-media-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:44751 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbbFLQ6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 12:58:40 -0400
Message-ID: <1434128306.11808.97.camel@misato.fc.hp.com>
Subject: Re: [Xen-devel] RIP MTRR - status update for upcoming v4.2
From: Toshi Kani <toshi.kani@hp.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	X86 ML <x86@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	ville.syrjala@linux.intel.com, Julia Lawall <julia.lawall@lip6.fr>,
	xen-devel@lists.xenproject.org, Dave Airlie <airlied@redhat.com>,
	syrjala@sci.fi, Juergen Gross <JGross@suse.com>,
	Luis Rodriguez <Mcgrof@Suse.com>, Borislav Petkov <bp@suse.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Fri, 12 Jun 2015 10:58:26 -0600
In-Reply-To: <557AAD910200007800084014@mail.emea.novell.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
	 <1434064996.11808.64.camel@misato.fc.hp.com>
	 <557AAD910200007800084014@mail.emea.novell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2015-06-12 at 08:59 +0100, Jan Beulich wrote:
> >>> On 12.06.15 at 01:23, <toshi.kani@hp.com> wrote:
> > There are two usages on MTRRs:
> >  1) MTRR entries set by firmware
> >  2) MTRR entries set by OS drivers
> > 
> > We can obsolete 2), but we have no control over 1).  As UEFI firmwares
> > also set this up, this usage will continue to stay.  So, we should not
> > get rid of the MTRR code that looks up the MTRR entries, while we have
> > no need to modify them.
> > 
> > Such MTRR entries provide safe guard to /dev/mem, which allows
> > privileged user to access a range that may require UC mapping while
> > the /dev/mem driver blindly maps it with WB.  MTRRs converts WB to UC in
> > such a case.
> 
> But it wouldn't be impossible to simply read the MTRRs upon boot,
> store the information, disable MTRRs, and correctly use PAT to
> achieve the same effect (i.e. the "blindly maps" part of course
> would need fixing).

It could be done, but I do not see much benefit of doing it.  One of the
reasons platform vendors set MTRRs is so that a system won't hit a
machine check when an OS bug leads an access with a wrong cache type.  A
machine check is hard to analyze and can be seen as a hardware issue by
customers.  Emulating MTRRs with PAT won't protect from such a bug. 

> > UEFI memory table has memory attribute, which describes cache types
> > supported in physical memory ranges.  However, this information gets
> > lost when it it is converted to e820 table.
> 
> I'm afraid you rather don't want to trust that information, as
> firmware vendors frequently screw it up.

Could be, but we need to use firmware info when necessary...

Thanks,
-Toshi

