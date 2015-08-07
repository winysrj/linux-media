Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35164 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946334AbbHGX01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 19:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <1438988915.3109.175.camel@hp.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com> <557AAD910200007800084014@mail.emea.novell.com>
 <1434128306.11808.97.camel@misato.fc.hp.com> <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
 <1438901893.3109.72.camel@hp.com> <CAB=NE6VnspTPfrn5+ZFSdgKb3uh_4g7LsuZVwe2FET=noijr5Q@mail.gmail.com>
 <1438984574.3109.151.camel@hp.com> <CAB=NE6V+dAq1u52c3tDhBOYWU1BNMBVL3KzDdM=C-zTkLEx4xA@mail.gmail.com>
 <1438988915.3109.175.camel@hp.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 7 Aug 2015 16:26:07 -0700
Message-ID: <CAB=NE6VmpBchJQ=Bfi1qbc+_aSMzcBe1xCqVvJpgbDw8gdrwwQ@mail.gmail.com>
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

On Fri, Aug 7, 2015 at 4:08 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Fri, 2015-08-07 at 15:23 -0700, Luis R. Rodriguez wrote:
>> On Fri, Aug 7, 2015 at 2:56 PM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > On Fri, 2015-08-07 at 13:25 -0700, Luis R. Rodriguez wrote:
>> > > On Thu, Aug 6, 2015 at 3:58 PM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > > > On Thu, 2015-08-06 at 12:53 -0700, Luis R. Rodriguez wrote:
>> > > > > On Fri, Jun 12, 2015 at 9:58 AM, Toshi Kani <toshi.kani@hp.com>
>> > > > > wrote:
>  :
>> > > >
>> > > > No, there is no OS support necessary to use MTRR.  After firmware
>> > > > sets it up, CPUs continue to use it without any OS support.  I think
>> > > > the Linux change you are referring is to obsolete legacy interfaces
>> > > > that modify the MTRR setup.  I agree that Linux should not modify
>> > > > MTRR.
>> > >
>> > > Its a bit more than that though. Since you agree that the OS can live
>> > > without MTRR code I was hoping to then see if we can fold out PAT
>> > > Linux code from under the MTRR dependency on Linux and make PAT a
>> > > first class citizen, maybe at least for x86-64. Right now you can only
>> > > get PAT support on Linux if you have MTRR code, but I'd like to see if
>> > > instead we can rip MTRR code out completely under its own Kconfig and
>> > > let it start rotting away.
>> > >
>> > > Code-wise the only issue I saw was that PAT code also relies on
>> > > mtrr_type_lookup(), see pat_x_mtrr_type(), but other than this I found
>> > > no other obvious issues.
>> >
>> > We can rip of the MTTR code that modifies the MTRR setup, but not
>> > mtrr_type_lookup().  This function provides necessary checks per
>> > documented
>> > in commit 7f0431e3dc89 as follows.
>> >
>> >     1) reserve_memtype() tracks an effective memory type in case
>> >        a request type is WB (ex. /dev/mem blindly uses WB). Missing
>> >        to track with its effective type causes a subsequent request
>> >        to map the same range with the effective type to fail.
>> >
>> >     2) pud_set_huge() and pmd_set_huge() check if a requested range
>> >        has any overlap with MTRRs. Missing to detect an overlap may
>> >        cause a performance penalty or undefined behavior.
>> >
>> > mtrr_type_lookup() is still admittedly awkward, but I do not think we
>> > have an immediate issue in PAT code calling it.  I do not think it makes
>> > PAT code a second class citizen.
>>
>> OK since we know that if MTRR set up code ends up disabled and would
>> return MTRR_TYPE_INVALID what if we just static inline this for the
>> no-MTRR Kconfig build option immediately, and only then have the full
>> blown implementation for the case where MTRR Kconfig option is
>> enabled?
>
> Yes, the MTRR code could be disabled by Kconfig with such inline stubs

OK thanks.

> as
> long as the kernel is built specifically for a particular platform with MTRR
> disabled, such as Xen guest kernel.

Sure.

> However, since MTRR is a CPU feature enabled on most of the systems, I am
> not sure if it makes sense to be configurable with Kconfig, though.

To me this is about making PAT a first class citizen in code though
and validating through Kconfig the option then to opt-out of MTRR from
OS code. Perhaps we can recommend to enable it but having the options
to split out PAT from MTRR is what I was aiming for.

>> > > Platform firmware and SMIs seems to be the only other possible issue.
>> > > More on this below.
>> > >
>> > > > > For those type of OSes...
>> > > > > could it be possible to negotiate or hint to the platform through
>> > > > > an attribute somehow that the OS has such capability to not use
>> > > > > MTRR?
>> > > >
>> > > > The OS can disable MTRR.  However, this can also cause a problem in
>> > > > firmware, which may rely on MTRR.
>> > >
>> > > Can you describe what type of issues we could expect ? I tend to care
>> > > more about this for 64-bit systems so if 32-bit platforms would be
>> > > more of the ones which could cause an issue would restricting
>> > > disabling MTRR only for 64-bit help?
>> >
>> > The SMI handler runs in real-mode and relies on MTRR being effective to
>> > provide right cache types.  It does not matter if it is 64-bit or not.
>>
>> I see... since I have no visibility to what goes under the hood, can
>> you provide one example use case where an SMI handler would require
>> getting a cache type through MTRR ? I realize this can vary, vendor by
>> vendor, but any example would do just to satisfy my curiosity.
>
> For fan control, it would need UC access to its registers.

OK thanks! To follow up with the example, since the platform firmware
would have set up the MTRRs anyway, the SMI should still work, even if
the OS didn't do anything, right?

>> > > > > Then, only if this bit is set, the platform could then avoid such
>> > > > > MTRR settings, and if we have issues you can throw rocks at us.
>> > > >
>> > > > > And if that's not possible how about a new platform setting that
>> > > > > would need to be set at the platform level to enable disabling
>> > > > > this junk?
>> > > > > Then only folks who know what they are doing would enable it, and
>> > > > > if the customer set it, the issue would not be on the platform.
>> > > >
>> > > > > Could this also be used to prevent SMIs with MTRRs?
>> > > >
>> > > > ACPI _OSI could be used for firmware to implement some OS-specific
>> > > > features, but it may be too late for firmware to make major changes
>> > > > and
>> > > > is generally useless unless OS requirements are described in a spec
>> > > > backed by logo certification.
>> > >
>> > > I see.. So there are no guarantees that platform firmware would not
>> > > expect OS MTRR support.
>> > >
>> > > >  SMIs are also used for platform management, such as fan
>> > > > speed control.
>> > >
>> > > And its conceivable that some devices, or the platform itself, may
>> > > trigger SMIs to have the platform firmware poke with MTRRs?
>> >
>> > SMIs are outside of OS control.  SMI handler relies on MTRR being set.
>> >  SMI must be quick, so the handler should not be required to initialize
>> > MTRR or page tables.
>>
>> Right makes sense.
>>
>> > > > Is there any issue for Linux to use MTRR set by firmware?
>> > >
>> > > Even though we don't have the Kconfig option right now to disable MTRR
>> > > cod explicitly I'll note that there are a few other cases that could
>> > > flip Linux to note use MTRR:
>> > >
>> > >   a) Some BIOSes could let MTRR get disabled
>> > >   b) As of Xen 4.4, the hypervisor disables X86_FEATURE_MTRR which
>> > > disables MTRR on Linux
>> > >
>> > > If these environments can exist it'd be good to understand possible
>> > > issues that could creep up as a result of the OS not having MTRR
>> > > enabled. If this is a reasonable thing for x86-64 I was hoping we
>> > > could just let users opt-in to a similar build configuration through
>> > > the OS by letting PAT not depend on MTRR.
>> >
>> > Case a) and b) do not cause any issue.  They simply lead
>> > mtrr_type_lookup() to return immediately with MTRR_TYPE_INVALID (i.e.
>> > MTRR disable), and the callers handle this value properly.  These cases
>> > are only problematic when the OS tries to modify MTRR.
>>
>> OK if the OS returns MTRR_TYPE_INVALID, for folks who do not want MTRR
>> code on their kernel, we should be OK?
>
> Technically OK.  Not sure if we want such a Kconfig option, though.

Its more of me wanting to get PAT out from under MTRR. Does that make sense?

 Luis
