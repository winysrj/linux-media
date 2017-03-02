Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753031AbdCBQvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Mar 2017 11:51:22 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v22Gi992006514
        for <linux-media@vger.kernel.org>; Thu, 2 Mar 2017 11:51:21 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28xpbu386k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 11:51:20 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 2 Mar 2017 11:51:20 -0500
Subject: Re: [PATCH 02/26] rewrite READ_ONCE/WRITE_ONCE
To: Arnd Bergmann <arnd@arndb.de>, kasan-dev@googlegroups.com
References: <20170302163834.2273519-1-arnd@arndb.de>
 <20170302163834.2273519-3-arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Thu, 2 Mar 2017 17:51:14 +0100
MIME-Version: 1.0
In-Reply-To: <20170302163834.2273519-3-arnd@arndb.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <76790664-a7a9-193c-2e30-edaee1308cb0@de.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/2017 05:38 PM, Arnd Bergmann wrote:
> When CONFIG_KASAN is enabled, the READ_ONCE/WRITE_ONCE macros cause
> rather large kernel stacks, e.g.:
> 
> mm/vmscan.c: In function 'shrink_page_list':
> mm/vmscan.c:1333:1: error: the frame size of 3456 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> block/cfq-iosched.c: In function 'cfqg_stats_add_aux':
> block/cfq-iosched.c:750:1: error: the frame size of 4048 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> fs/btrfs/disk-io.c: In function 'open_ctree':
> fs/btrfs/disk-io.c:3314:1: error: the frame size of 3136 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> fs/btrfs/relocation.c: In function 'build_backref_tree':
> fs/btrfs/relocation.c:1193:1: error: the frame size of 4336 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> fs/fscache/stats.c: In function 'fscache_stats_show':
> fs/fscache/stats.c:287:1: error: the frame size of 6512 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> fs/jbd2/commit.c: In function 'jbd2_journal_commit_transaction':
> fs/jbd2/commit.c:1139:1: error: the frame size of 3760 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> 
> This attempts a rewrite of the two macros, using a simpler implementation
> for the most common case of having a naturally aligned 1, 2, 4, or (on
> 64-bit architectures) 8  byte object that can be accessed with a single
> instruction.  For these, we go back to a volatile pointer dereference
> that we had with the ACCESS_ONCE macro.

We had changed that back then because gcc 4.6 and 4.7 had a bug that could
removed the volatile statement on aggregate types like the following one

union ipte_control {
        unsigned long val;
        struct {
                unsigned long k  : 1;
                unsigned long kh : 31;
                unsigned long kg : 32;
        };
};

See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145

If I see that right, your __ALIGNED_WORD(x)
macro would say that for above structure  sizeof(x) == sizeof(long)) is true,
so it would fall back to the old volatile cast and might reintroduce the 
old compiler bug?

Could you maybe you fence your simple macro for anything older than 4.9? After
all there was no kasan support anyway on these older gcc version.

Christian
