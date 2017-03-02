Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34009 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754795AbdCBR4A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 12:56:00 -0500
MIME-Version: 1.0
In-Reply-To: <76790664-a7a9-193c-2e30-edaee1308cb0@de.ibm.com>
References: <20170302163834.2273519-1-arnd@arndb.de> <20170302163834.2273519-3-arnd@arndb.de>
 <76790664-a7a9-193c-2e30-edaee1308cb0@de.ibm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 2 Mar 2017 18:55:47 +0100
Message-ID: <CAK8P3a082Bi6Vf5gEFLAJtJvUm=7MtddBzcCOqagQyfJPFTu_g@mail.gmail.com>
Subject: Re: [PATCH 02/26] rewrite READ_ONCE/WRITE_ONCE
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kasan-dev <kasan-dev@googlegroups.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 2, 2017 at 5:51 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 03/02/2017 05:38 PM, Arnd Bergmann wrote:
>>
>> This attempts a rewrite of the two macros, using a simpler implementation
>> for the most common case of having a naturally aligned 1, 2, 4, or (on
>> 64-bit architectures) 8  byte object that can be accessed with a single
>> instruction.  For these, we go back to a volatile pointer dereference
>> that we had with the ACCESS_ONCE macro.
>
> We had changed that back then because gcc 4.6 and 4.7 had a bug that could
> removed the volatile statement on aggregate types like the following one
>
> union ipte_control {
>         unsigned long val;
>         struct {
>                 unsigned long k  : 1;
>                 unsigned long kh : 31;
>                 unsigned long kg : 32;
>         };
> };
>
> See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145
>
> If I see that right, your __ALIGNED_WORD(x)
> macro would say that for above structure  sizeof(x) == sizeof(long)) is true,
> so it would fall back to the old volatile cast and might reintroduce the
> old compiler bug?

Ah, right, that's the missing piece. For some reason I didn't find
the reference in the source or the git log.

> Could you maybe you fence your simple macro for anything older than 4.9? After
> all there was no kasan support anyway on these older gcc version.

Yes, that should work, thanks!

     Arnd
