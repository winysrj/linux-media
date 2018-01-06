Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36689 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbeAFThE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Jan 2018 14:37:04 -0500
Received: by mail-oi0-f67.google.com with SMTP id j14so5137938oih.3
        for <linux-media@vger.kernel.org>; Sat, 06 Jan 2018 11:37:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 6 Jan 2018 11:37:03 -0800
Message-ID: <CAPcyv4gQbo+Bvf89QVL=mJrRy+id=sj3hiNePS=o_aAZv6hu0w@mail.gmail.com>
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative execution
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
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
        linux-wireless@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Netdev <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 5, 2018 at 5:09 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Quoting Mark's original RFC:
>
> "Recently, Google Project Zero discovered several classes of attack
> against speculative execution. One of these, known as variant-1, allows
> explicit bounds checks to be bypassed under speculation, providing an
> arbitrary read gadget. Further details can be found on the GPZ blog [1]
> and the Documentation patch in this series."
>
> This series incorporates Mark Rutland's latest api and adds the x86
> specific implementation of nospec_barrier. The
> nospec_{array_ptr,ptr,barrier} helpers are then combined with a kernel
> wide analysis performed by Elena Reshetova to address static analysis
> reports where speculative execution on a userspace controlled value
> could bypass a bounds check. The patches address a precondition for the
> attack discussed in the Spectre paper [2].
>
> A consideration worth noting for reviewing these patches is to weigh the
> dramatic cost of being wrong about whether a given report is exploitable
> vs the overhead nospec_{array_ptr,ptr} may introduce. In other words,
> lets make the bar for applying these patches be "can you prove that the
> bounds check bypass is *not* exploitable". Consider that the Spectre
> paper reports one example of a speculation window being ~180 cycles.
>
> Note that there is also a proposal from Linus, array_access [3], that
> attempts to quash speculative execution past a bounds check without
> introducing an lfence instruction. That may be a future optimization
> possibility that is compatible with this api, but it would appear to
> need guarantees from the compiler that it is not clear the kernel can
> rely on at this point. It is also not clear that it would be a
> significant performance win vs lfence.
>
> These patches also will also be available via the 'nospec' git branch
> here:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec

It appears that git.kernel.org has not mirrored out the new branch. In
the meantime here's an alternative location:

    https://github.com/djbw/linux.git nospec

If there are updates to these patches they will appear in nospec-v2,
nospec-v3, etc... branches.
