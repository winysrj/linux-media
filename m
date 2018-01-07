Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:45681 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754485AbeAGThf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 Jan 2018 14:37:35 -0500
Received: by mail-oi0-f45.google.com with SMTP id x20so6146998oix.12
        for <linux-media@vger.kernel.org>; Sun, 07 Jan 2018 11:37:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180107090918.GA29329@kroah.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151520103240.32271.14706852449205864676.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180106090907.GG4380@kroah.com> <20180106094026.GA11525@kroah.com>
 <CAPcyv4je-agqvmNSJf7v-1VBOrfhOvcs_qASNPJiBzgTt70dPA@mail.gmail.com> <20180107090918.GA29329@kroah.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 7 Jan 2018 11:37:33 -0800
Message-ID: <CAPcyv4gzbB-xESmmmpQ9+rt0swA+5y5pEOVNOYvroYQaP1kCfQ@mail.gmail.com>
Subject: Re: [PATCH 07/18] [media] uvcvideo: prevent bounds-check bypass via
 speculative execution
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Elena Reshetova <elena.reshetova@intel.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dsj@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 7, 2018 at 1:09 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
[..]
> Sorry for the confusion, no, I don't mean the "taint tracking", I mean
> the generic pattern of "speculative out of bounds access" that we are
> fixing here.
>
> Yes, as you mentioned before, there are tons of false-positives in the
> tree, as to find the real problems you have to show that userspace
> controls the access index.  But if we have a generic pattern that can
> rewrite that type of logic into one where it does not matter at all
> (i.e. like the ebpf proposed changes), then it would not be an issue if
> they are false or not, we just rewrite them all to be safe.
>
> We need to find some way not only to fix these issues now (like you are
> doing with this series), but to prevent them from every coming back into
> the codebase again.  It's that second part that we need to keep in the
> back of our minds here, while doing the first portion of this work.

I understand the goal, but I'm not sure any of our current annotation
mechanisms are suitable. We have:

    __attribute__((noderef, address_space(x)))

...for the '__user' annotation and other pointers that must not be
de-referenced without a specific accessor. We also have:

    __attribute__((bitwise))

...for values that should not be consumed directly without a specific
conversion like endian swapping.

The problem is that we need to see if a value derived from a userspace
controlled input is used to trigger a chain of dependent reads. As far
as I can see the annotation would need to be guided by taint analysis
to be useful, at which point we can just "annotate" the problem spot
with nospec_array_ptr(). Otherwise it seems the scope of a
"__nospec_array_index" annotation would have a low signal to noise
ratio.

Stopping speculation past a uacess_begin() boundary appears to handle
a wide swath of potential problems, and the rest likely needs taint
analysis, at least for now.

All that to say, yes, we need better tooling and infrastructure going forward.
