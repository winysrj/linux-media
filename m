Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44242 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965312AbeAMAPO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 19:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com>
From: Tony Luck <tony.luck@gmail.com>
Date: Fri, 12 Jan 2018 16:15:12 -0800
Message-ID: <CA+8MBb+H0FqciBw9nSO9L0fNQtiRvc_1TREitH9z89YxhtyFAQ@mail.gmail.com>
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

On Thu, Jan 11, 2018 at 5:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Should the array access in entry_SYSCALL_64_fastpath be made to use
> the masking approach?

That one has a bounds check for an inline constant.

     cmpq    $__NR_syscall_max, %rax

so should be safe.

The classic Spectre variant #1 code sequence is:

int array_size;

       if (x < array_size) {
               something with array[x]
       }

which runs into problems because the array_size variable may not
be in cache, and while the CPU core is waiting for the value it
speculates inside the "if" body.

The syscall entry is more like:

#define ARRAY_SIZE 10

     if (x < ARRAY_SIZE) {
          something with array[x]
     }

Here there isn't any reason for speculation. The core has the
value of 'x' in a register and the upper bound encoded into the
"cmp" instruction.  Both are right there, no waiting, no speculation.

-Tony
