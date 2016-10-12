Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0043.outbound.protection.outlook.com ([104.47.40.43]:22848
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932441AbcJLJYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 05:24:42 -0400
Subject: Re: [RFC 0/6] Module for tracking/accounting shared memory buffers
To: Ruchi Kandoi <kandoiruchi@google.com>,
        <gregkh@linuxfoundation.org>, <arve@android.com>,
        <riandrews@android.com>, <sumit.semwal@linaro.org>,
        <arnd@arndb.de>, <labbott@redhat.com>, <viro@zeniv.linux.org.uk>,
        <jlayton@poochiereds.net>, <bfields@fieldses.org>,
        <mingo@redhat.com>, <peterz@infradead.org>,
        <akpm@linux-foundation.org>, <keescook@chromium.org>,
        <mhocko@suse.com>, <oleg@redhat.com>, <john.stultz@linaro.org>,
        <mguzik@redhat.com>, <jdanis@google.com>, <adobriyan@gmail.com>,
        <ghackmann@google.com>, <kirill.shutemov@linux.intel.com>,
        <vbabka@suse.cz>, <dave.hansen@linux.intel.com>,
        <dan.j.williams@intel.com>, <hannes@cmpxchg.org>,
        <iamjoonsoo.kim@lge.com>, <luto@kernel.org>, <tj@kernel.org>,
        <vdavydov.dev@gmail.com>, <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>
References: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <a49e7aa1-d9c6-bb52-36b1-0f7538a8f960@amd.com>
Date: Wed, 12 Oct 2016 11:09:47 +0200
MIME-Version: 1.0
In-Reply-To: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 12.10.2016 um 01:50 schrieb Ruchi Kandoi:
> This patchstack adds memtrack hooks into dma-buf and ion.  If there's upstream
> interest in memtrack, it can be extended to other memory allocators as well,
> such as GEM implementations.
We have run into similar problems before. Because of this I already 
proposed a solution for this quite a while ago, but never pushed on 
upstreaming this since it was only done for a special use case.

Instead of keeping track of how much memory a process has bound (which 
is very fragile) my solution  only added some more debugging info on a 
per fd basis (e.g. how much memory is bound to this fd).

This information was then used by the OOM killer (for example) to make a 
better decision on which process to reap.

Shouldn't be to hard to expose this through debugfs or maybe a new fcntl 
to userspace for debugging.

I haven't looked at the code in detail, but messing with the per process 
memory accounting like you did in this proposal is clearly not a good 
idea if you ask me.

Regards,
Christian.
