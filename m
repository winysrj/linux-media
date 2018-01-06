Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:35691 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeAFGaR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Jan 2018 01:30:17 -0500
Received: by mail-ot0-f182.google.com with SMTP id q5so5636880oth.2
        for <linux-media@vger.kernel.org>; Fri, 05 Jan 2018 22:30:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87y3lbpvzp.fsf@xmission.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87y3lbpvzp.fsf@xmission.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 Jan 2018 22:30:16 -0800
Message-ID: <CAPcyv4hVisGeXbTH985Hb6dkYKA9Sr8wwZHudNF-CtH0=ADFug@mail.gmail.com>
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative execution
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alan Cox <alan.cox@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Zhang Rui <rui.zhang@intel.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, qla2xxx-upstream@qlogic.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 5, 2018 at 6:22 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> Quoting Mark's original RFC:
>>
>> "Recently, Google Project Zero discovered several classes of attack
>> against speculative execution. One of these, known as variant-1, allows
>> explicit bounds checks to be bypassed under speculation, providing an
>> arbitrary read gadget. Further details can be found on the GPZ blog [1]
>> and the Documentation patch in this series."
>>
>> This series incorporates Mark Rutland's latest api and adds the x86
>> specific implementation of nospec_barrier. The
>> nospec_{array_ptr,ptr,barrier} helpers are then combined with a kernel
>> wide analysis performed by Elena Reshetova to address static analysis
>> reports where speculative execution on a userspace controlled value
>> could bypass a bounds check. The patches address a precondition for the
>> attack discussed in the Spectre paper [2].
>
> Please expand this.
>
> It is not clear what the static analysis is looking for.  Have a clear
> description of what is being fixed is crucial for allowing any of these
> changes.
>
> For the details given in the change description what I read is magic
> changes because a magic process says this code is vunlerable.

Yes, that was my first reaction to the patches as well, I try below to
add some more background and guidance, but in the end these are static
analysis reports across a wide swath of sub-systems. It's going to
take some iteration with domain experts to improve the patch
descriptions, and that's the point of this series, to get the better
trained eyes from the actual sub-system owners to take a look at these
reports.

For example, I'm looking for feedback like what Srinivas gave where he
identified that the report is bogus, the branch condition can not be
seeded with bad values in that path. Be like Srinivas.

> Given the similarities in the code that is being patched to many other
> places in the kernel it is not at all clear that this small set of
> changes is sufficient for any purpose.

I find this assertion absurd, when in the past have we as kernel
developers ever been handed a static analysis report and then
questioned why the static analysis did not flag other call sites
before first reviewing the ones it did find?

>> A consideration worth noting for reviewing these patches is to weigh the
>> dramatic cost of being wrong about whether a given report is exploitable
>> vs the overhead nospec_{array_ptr,ptr} may introduce. In other words,
>> lets make the bar for applying these patches be "can you prove that the
>> bounds check bypass is *not* exploitable". Consider that the Spectre
>> paper reports one example of a speculation window being ~180 cycles.
>
>
>> Note that there is also a proposal from Linus, array_access [3], that
>> attempts to quash speculative execution past a bounds check without
>> introducing an lfence instruction. That may be a future optimization
>> possibility that is compatible with this api, but it would appear to
>> need guarantees from the compiler that it is not clear the kernel can
>> rely on at this point. It is also not clear that it would be a
>> significant performance win vs lfence.
>
> It is also not clear that these changes fix anything, or are in any
> sense correct for the problem they are trying to fix as the problem
> is not clearly described.

I'll try my best. I don't have first hand knowledge of how the static
analyzer is doing this job, and I don't think it matters for
evaluating these reports. I'll give you my thoughts on how I would
handle one of these reports if it flagged one of the sub-systems I
maintain.

Start with the example from the Spectre paper:

    if (x < array1_size)
        y = array2[array1[x] * 256];

In all the patches 'x' and 'array1' are called out explicitly. For example:

    net: mpls: prevent bounds-check bypass via speculative execution

    Static analysis reports that 'index' may be a user controlled value that
    is used as a data dependency reading 'rt' from the 'platform_label'
    array...

So the first thing to review is whether the analyzer got it wrong and
'x' is not arbitrarily controllable by userspace to cause speculation
outside of the checked bounds. Be like Srinivas. The next step is to
ask whether the code can be refactored so that 'x' is sanitized
earlier in the call stack, especially if the nospec_array_ptr() lands
in a hot path. The next aspect that I expect most would be tempted to
go check is whether 'array2[array1[x]]' occurs later in the code
stream, but with speculation windows being architecture dependent and
potentially large (~180 cycles in one case says the paper) I submit
that we should err on the side of caution and not guess if that second
dependent read has been emitted somewhere in the instruction stream.

> In at least one place (mpls) you are patching a fast path.  Compile out
> or don't load mpls by all means.  But it is not acceptable to change the
> fast path without even considering performance.

Performance matters greatly, but I need help to identify a workload
that is representative for this fast path to see what, if any, impact
is incurred. Even better is a review that says "nope, 'index' is not
subject to arbitrary userspace control at this point, drop the patch."
