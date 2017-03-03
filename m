Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751796AbdCCPRb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 10:17:31 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v238Ni3J065774
        for <linux-media@vger.kernel.org>; Fri, 3 Mar 2017 03:26:57 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28xs8f32nk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 03 Mar 2017 03:26:57 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 3 Mar 2017 03:26:57 -0500
Subject: Re: [PATCH 02/26] rewrite READ_ONCE/WRITE_ONCE
To: Arnd Bergmann <arnd@arndb.de>
References: <20170302163834.2273519-1-arnd@arndb.de>
 <20170302163834.2273519-3-arnd@arndb.de>
 <76790664-a7a9-193c-2e30-edaee1308cb0@de.ibm.com>
 <CAK8P3a082Bi6Vf5gEFLAJtJvUm=7MtddBzcCOqagQyfJPFTu_g@mail.gmail.com>
 <2adc6ff4-5dc5-8f1d-cce1-47f3124a528f@de.ibm.com>
 <CAK8P3a2mepCjPfM9Ychk7CHFHi0UW8RBzK4skJKMSOjw3gKoYg@mail.gmail.com>
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
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Fri, 3 Mar 2017 09:26:50 +0100
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2mepCjPfM9Ychk7CHFHi0UW8RBzK4skJKMSOjw3gKoYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <f86cf852-3960-0dcf-5917-509080ca7bf5@de.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/2017 10:45 PM, Arnd Bergmann wrote:
> On Thu, Mar 2, 2017 at 8:00 PM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>> On 03/02/2017 06:55 PM, Arnd Bergmann wrote:
>>> On Thu, Mar 2, 2017 at 5:51 PM, Christian Borntraeger
>>> <borntraeger@de.ibm.com> wrote:
>>>> On 03/02/2017 05:38 PM, Arnd Bergmann wrote:
>>>>>
>>>>> This attempts a rewrite of the two macros, using a simpler implementation
>>>>> for the most common case of having a naturally aligned 1, 2, 4, or (on
>>>>> 64-bit architectures) 8  byte object that can be accessed with a single
>>>>> instruction.  For these, we go back to a volatile pointer dereference
>>>>> that we had with the ACCESS_ONCE macro.
>>>>
>>>> We had changed that back then because gcc 4.6 and 4.7 had a bug that could
>>>> removed the volatile statement on aggregate types like the following one
>>>>
>>>> union ipte_control {
>>>>         unsigned long val;
>>>>         struct {
>>>>                 unsigned long k  : 1;
>>>>                 unsigned long kh : 31;
>>>>                 unsigned long kg : 32;
>>>>         };
>>>> };
>>>>
>>>> See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145
>>>>
>>>> If I see that right, your __ALIGNED_WORD(x)
>>>> macro would say that for above structure  sizeof(x) == sizeof(long)) is true,
>>>> so it would fall back to the old volatile cast and might reintroduce the
>>>> old compiler bug?
>>
>> Oh dear, I should double check my sentences in emails before sending...anyway
>> the full story is referenced in
>>
>> commit 60815cf2e05057db5b78e398d9734c493560b11e
>>     Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux
>> which has a pointer to
>> http://marc.info/?i=54611D86.4040306%40de.ibm.com
>> which contains the full story.
> 
> Ok, got it. So I guess the behavior of forcing aligned accesses on aligned
> data is accidental, and allowing non-power-of-two arguments is also not
> the main purpose.


Right. The main purpose is to read/write _ONCE_. You can assume a somewhat
atomic access for sizes <= word size. And there are certainly places that
rely on that. But the *ONCE thing is mostly used for things where we used
barrier() 10 years ago.


 Maybe we could just bail out on new compilers if we get
> either of those? That might catch code that accidentally does something
> that is inherently non-atomic or that causes a trap when the intention was
> to have a simple atomic access.

I think Linus stated that its ok to assume that the compiler is smart enough 
to uses a single instruction to access aligned and properly sized scalar types
for *ONCE.

Back then when I changed ACCESS_ONCE there were many places that did use it
for non-atomic, > word size accesses. For example on some architectures a pmd_t
is a typedef to an array, for which there is no way to read that atomically.
So the focus must be on the "ONCE" part.

If some code uses a properly aligned, word sized object we can also assume 
atomic access. If the access is not properly sized/aligned we do not get
atomicity, but we do get the "ONCE".
But adding a check for alignment/size would break the compilation of some
code.
