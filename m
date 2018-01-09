Return-path: <linux-media-owner@vger.kernel.org>
Received: from twin.jikos.cz ([91.219.245.39]:37373 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964997AbeAIUDg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 15:03:36 -0500
Date: Tue, 9 Jan 2018 20:34:37 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative
 execution
In-Reply-To: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-ID: <alpine.LRH.2.00.1801092017330.27010@gjva.wvxbf.pm>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Jan 2018, Dan Williams wrote:

[ ... snip ... ]
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

So considering the recent publication of [1], how come we all of a sudden 
don't need the barriers in ___bpf_prog_run(), namely for LD_IMM_DW and 
LDX_MEM_##SIZEOP, and something comparable for eBPF JIT?

Is this going to be handled in eBPF in some other way?

Without that in place, and considering Jann Horn's paper, it would seem 
like PTI doesn't really lock it down fully, right?

[1] https://bugs.chromium.org/p/project-zero/issues/attachmentText?aid=287305

-- 
Jiri Kosina
SUSE Labs
