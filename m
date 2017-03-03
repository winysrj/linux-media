Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36363 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdCCKwT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 05:52:19 -0500
MIME-Version: 1.0
In-Reply-To: <f86cf852-3960-0dcf-5917-509080ca7bf5@de.ibm.com>
References: <20170302163834.2273519-1-arnd@arndb.de> <20170302163834.2273519-3-arnd@arndb.de>
 <76790664-a7a9-193c-2e30-edaee1308cb0@de.ibm.com> <CAK8P3a082Bi6Vf5gEFLAJtJvUm=7MtddBzcCOqagQyfJPFTu_g@mail.gmail.com>
 <2adc6ff4-5dc5-8f1d-cce1-47f3124a528f@de.ibm.com> <CAK8P3a2mepCjPfM9Ychk7CHFHi0UW8RBzK4skJKMSOjw3gKoYg@mail.gmail.com>
 <f86cf852-3960-0dcf-5917-509080ca7bf5@de.ibm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 3 Mar 2017 10:54:07 +0100
Message-ID: <CAK8P3a0M6KAiLj9HM8UYykL-CtZNEsDcD0L1kZ1usPCx4=vq+g@mail.gmail.com>
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

On Fri, Mar 3, 2017 at 9:26 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 03/02/2017 10:45 PM, Arnd Bergmann wrote:
>> Ok, got it. So I guess the behavior of forcing aligned accesses on aligned
>> data is accidental, and allowing non-power-of-two arguments is also not
>> the main purpose.
>
>
> Right. The main purpose is to read/write _ONCE_. You can assume a somewhat
> atomic access for sizes <= word size. And there are certainly places that
> rely on that. But the *ONCE thing is mostly used for things where we used
> barrier() 10 years ago.

Ok

>
>  Maybe we could just bail out on new compilers if we get
>> either of those? That might catch code that accidentally does something
>> that is inherently non-atomic or that causes a trap when the intention was
>> to have a simple atomic access.
>
> I think Linus stated that its ok to assume that the compiler is smart enough
> to uses a single instruction to access aligned and properly sized scalar types
> for *ONCE.
>
> Back then when I changed ACCESS_ONCE there were many places that did use it
> for non-atomic, > word size accesses. For example on some architectures a pmd_t
> is a typedef to an array, for which there is no way to read that atomically.
> So the focus must be on the "ONCE" part.
>
> If some code uses a properly aligned, word sized object we can also assume
> atomic access. If the access is not properly sized/aligned we do not get
> atomicity, but we do get the "ONCE".
> But adding a check for alignment/size would break the compilation of some
> code.

So what should be the expected behavior for objects that have a smaller
alignment? E.g. this structure

struct fourbytes {
   char bytes[4];
} __packed;

when passed into the current READ_ONCE() will be accessed with
a 32-bit load, while reading it with

struct fourbytes local = *(volatile struct fourbytes *)voidpointer;

on architectures like ARMv5 or lower will turn into four single-byte
reads to avoid an alignment trap when the pointer is actually
unaligned.

I can see arguments for and against either behavior, but what should
I do when modifying it for newer compilers? The possible options
that I see are

- keep assuming that the pointer will be aligned at runtime
  and doesn't trap
- use the regular gcc behavior and do byte-accesses on those
  architectures that otherwise might trap
- add a runtime alignment check to do atomic accesses whenever
  possible, but never trap
- fail the build

     Arnd
