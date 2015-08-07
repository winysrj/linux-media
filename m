Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36212 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbbHGUZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 16:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <1438901893.3109.72.camel@hp.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com> <557AAD910200007800084014@mail.emea.novell.com>
 <1434128306.11808.97.camel@misato.fc.hp.com> <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
 <1438901893.3109.72.camel@hp.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 7 Aug 2015 13:25:23 -0700
Message-ID: <CAB=NE6VnspTPfrn5+ZFSdgKb3uh_4g7LsuZVwe2FET=noijr5Q@mail.gmail.com>
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

On Thu, Aug 6, 2015 at 3:58 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2015-08-06 at 12:53 -0700, Luis R. Rodriguez wrote:
>> On Fri, Jun 12, 2015 at 9:58 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > On Fri, 2015-06-12 at 08:59 +0100, Jan Beulich wrote:
>> > > > > > On 12.06.15 at 01:23, <toshi.kani@hp.com> wrote:
>> > > > There are two usages on MTRRs:
>> > > >  1) MTRR entries set by firmware
>> > > >  2) MTRR entries set by OS drivers
>> > > >
>> > > > We can obsolete 2), but we have no control over 1).  As UEFI
>> > > > firmwares
>> > > > also set this up, this usage will continue to stay.  So, we should
>> > > > not
>> > > > get rid of the MTRR code that looks up the MTRR entries, while we
>> > > > have
>> > > > no need to modify them.
>> > > >
>> > > > Such MTRR entries provide safe guard to /dev/mem, which allows
>> > > > privileged user to access a range that may require UC mapping while
>> > > > the /dev/mem driver blindly maps it with WB.  MTRRs converts WB to
>> > > > UC in
>> > > > such a case.
>> > >
>> > > But it wouldn't be impossible to simply read the MTRRs upon boot,
>> > > store the information, disable MTRRs, and correctly use PAT to
>> > > achieve the same effect (i.e. the "blindly maps" part of course
>> > > would need fixing).
>> >
>> > It could be done, but I do not see much benefit of doing it.  One of the
>> > reasons platform vendors set MTRRs is so that a system won't hit a
>> > machine check when an OS bug leads an access with a wrong cache type.
>> >
>> > A machine check is hard to analyze and can be seen as a hardware issue
>> > by customers.  Emulating MTRRs with PAT won't protect from such a bug.
>>
>> That's seems like a fair and valid concern. This could only happen if
>> the OS would have code that would use MTRR, in the case of Linux we'll
>> soon be able to vet that this cannot happen.
>
> No, there is no OS support necessary to use MTRR.  After firmware sets it
> up, CPUs continue to use it without any OS support.  I think the Linux
> change you are referring is to obsolete legacy interfaces that modify the
> MTRR setup.  I agree that Linux should not modify MTRR.

Its a bit more than that though. Since you agree that the OS can live
without MTRR code I was hoping to then see if we can fold out PAT
Linux code from under the MTRR dependency on Linux and make PAT a
first class citizen, maybe at least for x86-64. Right now you can only
get PAT support on Linux if you have MTRR code, but I'd like to see if
instead we can rip MTRR code out completely under its own Kconfig and
let it start rotting away.

Code-wise the only issue I saw was that PAT code also relies on
mtrr_type_lookup(), see pat_x_mtrr_type(), but other than this I found
no other obvious issues.

Platform firmware and SMIs seems to be the only other possible issue.
More on this below.

>> For those type of OSes...
>> could it be possible to negotiate or hint to the platform through an
>> attribute somehow that the OS has such capability to not use MTRR?
>
> The OS can disable MTRR.  However, this can also cause a problem in
> firmware, which may rely on MTRR.

Can you describe what type of issues we could expect ? I tend to care
more about this for 64-bit systems so if 32-bit platforms would be
more of the ones which could cause an issue would restricting
disabling MTRR only for 64-bit help?

>> Then, only if this bit is set, the platform could then avoid such MTRR
>> settings, and if we have issues you can throw rocks at us.
>
>> And if that's not possible how about a new platform setting that would
>> need to be set at the platform level to enable disabling this junk?
>> Then only folks who know what they are doing would enable it, and if
>> the customer set it, the issue would not be on the platform.
>
>> Could this also be used to prevent SMIs with MTRRs?
>
> ACPI _OSI could be used for firmware to implement some OS-specific features,
> but it may be too late for firmware to make major changes and is generally
> useless unless OS requirements are described in a spec backed by logo
> certification.

I see.. So there are no guarantees that platform firmware would not
expect OS MTRR support.

>  SMIs are also used for platform management, such as fan
> speed control.

And its conceivable that some devices, or the platform itself, may
trigger SMIs to have the platform firmware poke with MTRRs?

> Is there any issue for Linux to use MTRR set by firmware?

Even though we don't have the Kconfig option right now to disable MTRR
cod explicitly I'll note that there are a few other cases that could
flip Linux to note use MTRR:

  a) Some BIOSes could let MTRR get disabled
  b) As of Xen 4.4, the hypervisor disables X86_FEATURE_MTRR which
disables MTRR on Linux

If these environments can exist it'd be good to understand possible
issues that could creep up as a result of the OS not having MTRR
enabled. If this is a reasonable thing for x86-64 I was hoping we
could just let users opt-in to a similar build configuration through
the OS by letting PAT not depend on MTRR.

 Luis
