Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34771 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbFLXPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 19:15:23 -0400
Received: by laew7 with SMTP id w7so28557676lae.1
        for <linux-media@vger.kernel.org>; Fri, 12 Jun 2015 16:15:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557AAD910200007800084014@mail.emea.novell.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com> <557AAD910200007800084014@mail.emea.novell.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Jun 2015 16:15:00 -0700
Message-ID: <CALCETrXWZU2NZRZy7b74z54Tt5aKmTOmgMmf5WYG1OZtEmjw7A@mail.gmail.com>
Subject: Re: [Xen-devel] RIP MTRR - status update for upcoming v4.2
To: Jan Beulich <JBeulich@suse.com>
Cc: Juergen Gross <jgross@suse.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jun 12, 2015 12:59 AM, "Jan Beulich" <JBeulich@suse.com> wrote:
>
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

This may crash and burn badly when we call a UEFI function or an SMI
happens.  I think we should just leave the MTRRs alone.

--Andy
