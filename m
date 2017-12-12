Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.253]:17090 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752259AbdLLVP3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 16:15:29 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 24E5DED5C
        for <linux-media@vger.kernel.org>; Tue, 12 Dec 2017 14:54:54 -0600 (CST)
Date: Tue, 12 Dec 2017 14:54:53 -0600
Message-ID: <20171212145453.Horde.AIRUKufqtUzYfBoM3NFM_M-@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH] au0828: fix use-after-free at USB probing
References: <CAAeHK+wZXZMxqQn9QbAd3xWt00_bKir4-La2QKtzk8nFb0FQmw@mail.gmail.com>
 <20171110002134.GA32019@embeddedor.com>
 <CAAeHK+zC2-7cP+oJbKPOUs+5Un5+TUkMY2FNs=z+GxLZa4kQug@mail.gmail.com>
 <20171110113552.Horde.eGcnMRStkxzNDhQOqlhnkI5@gator4166.hostgator.com>
 <CAAeHK+y_DA=jf=zThqmO5OE1DJ5u8yJngM=pEUi1_ySLMVpYDg@mail.gmail.com>
 <20171122193159.Horde.FRo8B41DAeyjHhZnK47VCGn@gator4166.hostgator.com>
 <CAAeHK+ws05W5FRuncD42MKEB5tX254baDh1cS7uT4pwq0ddfmQ@mail.gmail.com>
In-Reply-To: <CAAeHK+ws05W5FRuncD42MKEB5tX254baDh1cS7uT4pwq0ddfmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Andrey,

Quoting Andrey Konovalov <andreyknvl@google.com>:

> On Thu, Nov 23, 2017 at 2:31 AM, Gustavo A. R. Silva
> <garsilva@embeddedor.com> wrote:
>> Hi Andrey,
>>
>> I have successfully installed and tested syzkaller with QEMU. Can you please
>> tell me how to reproduce this bug or share with me the full crash report?
>>
>> Also, can you point me out to the PoC file?
>
> Hi Gustavo,
>
> Sorry for the delay.
>

No worries.

> I've now published the USB fuzzing prototype, so here's how you can
> reproduce this:
>
> 1. Get Linux 4.15-rc3 upstream kernel
> (50c4c4e268a2d7a3e58ebb698ac74da0de40ae36).
>
> 2. Apply this patch (it adds a new interface to emulate USB devices):
> https://github.com/google/syzkaller/blob/usb-fuzzer/tools/usb/0002-usb-fuzzer-main-usb-gadget-fuzzer-driver.patch
>
> 3. Build the kernel with the attached .config (you need relatively new
> GCC to make KASAN work).
>
> 4. Run the attached reproducer.
>
> Also attaching the full kernel log.
>

Awesome. :D I'll try this.

Thank you!
--
Gustavo A. R. Silva
