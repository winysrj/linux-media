Return-path: <linux-media-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:39951 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753536AbeAFCWx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 21:22:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        peterz@infradead.org, Alan Cox <alan.cox@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Zhang Rui <rui.zhang@intel.com>, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, qla2xxx-upstream@qlogic.com,
        tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, torvalds@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 05 Jan 2018 20:22:02 -0600
In-Reply-To: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
        (Dan Williams's message of "Fri, 05 Jan 2018 17:09:53 -0800")
Message-ID: <87y3lbpvzp.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative execution
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan Williams <dan.j.williams@intel.com> writes:

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

Please expand this.

It is not clear what the static analysis is looking for.  Have a clear
description of what is being fixed is crucial for allowing any of these
changes.

For the details given in the change description what I read is magic
changes because a magic process says this code is vunlerable.

Given the similarities in the code that is being patched to many other
places in the kernel it is not at all clear that this small set of
changes is sufficient for any purpose.

> A consideration worth noting for reviewing these patches is to weigh the
> dramatic cost of being wrong about whether a given report is exploitable
> vs the overhead nospec_{array_ptr,ptr} may introduce. In other words,
> lets make the bar for applying these patches be "can you prove that the
> bounds check bypass is *not* exploitable". Consider that the Spectre
> paper reports one example of a speculation window being ~180 cycles.


> Note that there is also a proposal from Linus, array_access [3], that
> attempts to quash speculative execution past a bounds check without
> introducing an lfence instruction. That may be a future optimization
> possibility that is compatible with this api, but it would appear to
> need guarantees from the compiler that it is not clear the kernel can
> rely on at this point. It is also not clear that it would be a
> significant performance win vs lfence.

It is also not clear that these changes fix anything, or are in any
sense correct for the problem they are trying to fix as the problem
is not clearly described.

In at least one place (mpls) you are patching a fast path.  Compile out
or don't load mpls by all means.  But it is not acceptable to change the
fast path without even considering performance.

So because the description sucks, and the due diligence is not there.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

to the series.


>
> These patches also will also be available via the 'nospec' git branch
> here:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec
>
> [1]: https://googleprojectzero.blogspot.co.uk/2018/01/reading-privileged-memory-with-side.html
> [2]: https://spectreattack.com/spectre.pdf
> [3]: https://marc.info/?l=linux-kernel&m=151510446027625&w=2
>
> ---
>
> Andi Kleen (1):
>       x86, barrier: stop speculation for failed access_ok
>
> Dan Williams (13):
>       x86: implement nospec_barrier()
>       [media] uvcvideo: prevent bounds-check bypass via speculative execution
>       carl9170: prevent bounds-check bypass via speculative execution
>       p54: prevent bounds-check bypass via speculative execution
>       qla2xxx: prevent bounds-check bypass via speculative execution
>       cw1200: prevent bounds-check bypass via speculative execution
>       Thermal/int340x: prevent bounds-check bypass via speculative execution
>       ipv6: prevent bounds-check bypass via speculative execution
>       ipv4: prevent bounds-check bypass via speculative execution
>       vfs, fdtable: prevent bounds-check bypass via speculative execution
>       net: mpls: prevent bounds-check bypass via speculative execution
>       udf: prevent bounds-check bypass via speculative execution
>       userns: prevent bounds-check bypass via speculative execution
>
> Mark Rutland (4):
>       asm-generic/barrier: add generic nospec helpers
>       Documentation: document nospec helpers
>       arm64: implement nospec_ptr()
>       arm: implement nospec_ptr()
>
>  Documentation/speculation.txt                      |  166 ++++++++++++++++++++
>  arch/arm/include/asm/barrier.h                     |   75 +++++++++
>  arch/arm64/include/asm/barrier.h                   |   55 +++++++
>  arch/x86/include/asm/barrier.h                     |    6 +
>  arch/x86/include/asm/uaccess.h                     |   17 ++
>  drivers/media/usb/uvc/uvc_v4l2.c                   |    7 +
>  drivers/net/wireless/ath/carl9170/main.c           |    6 -
>  drivers/net/wireless/intersil/p54/main.c           |    8 +
>  drivers/net/wireless/st/cw1200/sta.c               |   10 +
>  drivers/net/wireless/st/cw1200/wsm.h               |    4 
>  drivers/scsi/qla2xxx/qla_mr.c                      |   15 +-
>  .../thermal/int340x_thermal/int340x_thermal_zone.c |   14 +-
>  fs/udf/misc.c                                      |   39 +++--
>  include/asm-generic/barrier.h                      |   68 ++++++++
>  include/linux/fdtable.h                            |    5 -
>  kernel/user_namespace.c                            |   10 -
>  net/ipv4/raw.c                                     |    9 +
>  net/ipv6/raw.c                                     |    9 +
>  net/mpls/af_mpls.c                                 |   12 +
>  19 files changed, 466 insertions(+), 69 deletions(-)
>  create mode 100644 Documentation/speculation.txt
