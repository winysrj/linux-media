Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.emea.novell.com ([130.57.118.101]:39026 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbbFLH7v convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-media@vger.kernel.org:17:3>);
	Fri, 12 Jun 2015 03:59:51 -0400
Message-Id: <557AAD910200007800084014@mail.emea.novell.com>
Date: Fri, 12 Jun 2015 08:59:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Toshi Kani" <toshi.kani@hp.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"Bjorn Helgaas" <bhelgaas@google.com>,
	"Jej B" <James.Bottomley@hansenpartnership.com>,
	"X86 ML" <x86@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	<ville.syrjala@linux.intel.com>,
	"Julia Lawall" <julia.lawall@lip6.fr>,
	<xen-devel@lists.xenproject.org>,
	"Dave Airlie" <airlied@redhat.com>, <syrjala@sci.fi>,
	"Juergen Gross" <JGross@suse.com>,
	"Luis Rodriguez" <Mcgrof@Suse.com>, "Borislav Petkov" <bp@suse.de>,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"linux-fbdev" <linux-fbdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Xen-devel] RIP MTRR - status update for upcoming v4.2
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com>
In-Reply-To: <1434064996.11808.64.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> On 12.06.15 at 01:23, <toshi.kani@hp.com> wrote:
> There are two usages on MTRRs:
>  1) MTRR entries set by firmware
>  2) MTRR entries set by OS drivers
> 
> We can obsolete 2), but we have no control over 1).  As UEFI firmwares
> also set this up, this usage will continue to stay.  So, we should not
> get rid of the MTRR code that looks up the MTRR entries, while we have
> no need to modify them.
> 
> Such MTRR entries provide safe guard to /dev/mem, which allows
> privileged user to access a range that may require UC mapping while
> the /dev/mem driver blindly maps it with WB.  MTRRs converts WB to UC in
> such a case.

But it wouldn't be impossible to simply read the MTRRs upon boot,
store the information, disable MTRRs, and correctly use PAT to
achieve the same effect (i.e. the "blindly maps" part of course
would need fixing).

> UEFI memory table has memory attribute, which describes cache types
> supported in physical memory ranges.  However, this information gets
> lost when it it is converted to e820 table.

I'm afraid you rather don't want to trust that information, as
firmware vendors frequently screw it up.

Jan

