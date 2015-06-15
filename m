Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.emea.novell.com ([130.57.118.101]:38939 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbFOGUR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-media@vger.kernel.org:17:3>);
	Mon, 15 Jun 2015 02:20:17 -0400
Message-Id: <557E8ABA02000078000849A8@mail.emea.novell.com>
Date: Mon, 15 Jun 2015 07:20:10 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"Bjorn Helgaas" <bhelgaas@google.com>,
	"Jej B" <James.Bottomley@hansenpartnership.com>,
	"Toshi Kani" <toshi.kani@hp.com>, "X86 ML" <x86@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	<ville.syrjala@linux.intel.com>,
	"Julia Lawall" <julia.lawall@lip6.fr>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
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
 <557AAD910200007800084014@mail.emea.novell.com>
 <CALCETrXWZU2NZRZy7b74z54Tt5aKmTOmgMmf5WYG1OZtEmjw7A@mail.gmail.com>
In-Reply-To: <CALCETrXWZU2NZRZy7b74z54Tt5aKmTOmgMmf5WYG1OZtEmjw7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> On 13.06.15 at 01:15, <luto@amacapital.net> wrote:
> On Jun 12, 2015 12:59 AM, "Jan Beulich" <JBeulich@suse.com> wrote:
>>
>> >>> On 12.06.15 at 01:23, <toshi.kani@hp.com> wrote:
>> > There are two usages on MTRRs:
>> >  1) MTRR entries set by firmware
>> >  2) MTRR entries set by OS drivers
>> >
>> > We can obsolete 2), but we have no control over 1).  As UEFI firmwares
>> > also set this up, this usage will continue to stay.  So, we should not
>> > get rid of the MTRR code that looks up the MTRR entries, while we have
>> > no need to modify them.
>> >
>> > Such MTRR entries provide safe guard to /dev/mem, which allows
>> > privileged user to access a range that may require UC mapping while
>> > the /dev/mem driver blindly maps it with WB.  MTRRs converts WB to UC in
>> > such a case.
>>
>> But it wouldn't be impossible to simply read the MTRRs upon boot,
>> store the information, disable MTRRs, and correctly use PAT to
>> achieve the same effect (i.e. the "blindly maps" part of course
>> would need fixing).
> 
> This may crash and burn badly when we call a UEFI function or an SMI
> happens.  I think we should just leave the MTRRs alone.

I buy the SMI part, but UEFI runtime calls are being done on
page tables we construct and control, so attributes could be kept
correct without relying on MTRRs.

Jan

