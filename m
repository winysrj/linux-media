Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36623 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbbHFTxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 15:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <1434128306.11808.97.camel@misato.fc.hp.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com> <557AAD910200007800084014@mail.emea.novell.com>
 <1434128306.11808.97.camel@misato.fc.hp.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Aug 2015 12:53:03 -0700
Message-ID: <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
Subject: Re: [Xen-devel] RIP MTRR - status update for upcoming v4.2
To: Toshi Kani <toshi.kani@hp.com>
Cc: Jan Beulich <JBeulich@suse.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	X86 ML <x86@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	xen-devel@lists.xenproject.org, Dave Airlie <airlied@redhat.com>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	Juergen Gross <JGross@suse.com>, Borislav Petkov <bp@suse.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 12, 2015 at 9:58 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Fri, 2015-06-12 at 08:59 +0100, Jan Beulich wrote:
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
> It could be done, but I do not see much benefit of doing it.  One of the
> reasons platform vendors set MTRRs is so that a system won't hit a
> machine check when an OS bug leads an access with a wrong cache type.
>
> A machine check is hard to analyze and can be seen as a hardware issue by
> customers.  Emulating MTRRs with PAT won't protect from such a bug.

That's seems like a fair and valid concern. This could only happen if
the OS would have code that would use MTRR, in the case of Linux we'll
soon be able to vet that this cannot happen. For those type of OSes...
could it be possible to negotiate or hint to the platform through an
attribute somehow that the OS has such capability to not use MTRR?
Then, only if this bit is set, the platform could then avoid such MTRR
settings, and if we have issues you can throw rocks at us.

Could this also be used to prevent SMIs with MTRRs?

 Luis
