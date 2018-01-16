Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:42025 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeAPTVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 14:21:21 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwUspY8DG3hRxZqQaf_n_0OZxGCd=pELc8ZVuBu+058cA@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com>
 <CA+8MBb+H0FqciBw9nSO9L0fNQtiRvc_1TREitH9z89YxhtyFAQ@mail.gmail.com> <CA+55aFwUspY8DG3hRxZqQaf_n_0OZxGCd=pELc8ZVuBu+058cA@mail.gmail.com>
From: Tony Luck <tony.luck@gmail.com>
Date: Tue, 16 Jan 2018 11:21:19 -0800
Message-ID: <CA+8MBbL-ZJhTT7jTKVffS5r_7Qq6b-Af96YiNLrMs7Ndo45WhA@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] prevent bounds-check bypass via speculative execution
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        kernel-hardening@lists.openwall.com,
        Peter Zijlstra <peterz@infradead.org>,
        Alan Cox <alan.cox@intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ingo Molnar <mingo@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>, Jan Kara <jack@suse.com>,
        Al Viro <viro@zeniv.linux.org.uk>, qla2xxx-upstream@qlogic.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 13, 2018 at 10:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jan 12, 2018 at 4:15 PM, Tony Luck <tony.luck@gmail.com> wrote:
> So your argument depends on "the uarch will actually run the code in
> order if there are no events that block the pipeline".

And might be bogus ... I'm a software person not a u-arch expert. That
sounded good in my head, but the level of parallelism may be greater
than I can imagine.

> Or at least it depends on a certain latency of the killing of any OoO
> execution being low enough that the cache access doesn't even begin.
>
> I realize that that is very much a particular microarchitectural
> detail, but it's actually a *big* deal. Do we have a set of rules for
> what is not a worry, simply because the speculated accesses get killed
> early enough?
>
> Apparently "test a register value against a constant" is good enough,
> assuming that register is also needed for the address of the access.

People who do understand this are working on what can be guaranteed.
For now don't make big plans based on my ramblings.

-Tony
