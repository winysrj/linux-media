Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:38671 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdCMPkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 11:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAHb8M2BOcuW8ToYTT3EUm-GieOMz6+xUhmzwW+3hbygti11k0A@mail.gmail.com>
References: <20170313105421.GA32342@SEL-JYOUN-D1> <20170313115129.GC4136@mwanda>
 <CAHb8M2BOcuW8ToYTT3EUm-GieOMz6+xUhmzwW+3hbygti11k0A@mail.gmail.com>
From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Tue, 14 Mar 2017 00:40:01 +0900
Message-ID: <CAHb8M2CwfTN-dx4ojUJCvF_jr0E1bo4KLWpZE74y45WkV_6C+A@mail.gmail.com>
Subject: Re: [PATCH] staging: atomisp: use k{v}zalloc instead of k{v}alloc and memset
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mchehab@kernel.org, devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alan@linux.intel.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-03-13 23:07 GMT+09:00 DaeSeok Youn <daeseok.youn@gmail.com>:
> 2017-03-13 20:51 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
>> On Mon, Mar 13, 2017 at 07:54:21PM +0900, Daeseok Youn wrote:
>>> If the atomisp_kernel_zalloc() has "true" as a second parameter, it
>>> tries to allocate zeroing memory from kmalloc(vmalloc) and memset.
>>> But using kzalloc is rather than kmalloc followed by memset with 0.
>>> (vzalloc is for same reason with kzalloc)
>>>
>>> And also atomisp_kernel_malloc() can be used with
>>> atomisp_kernel_zalloc(<size>, false);
>>>
>>
>> We should just change all the callers to kvmalloc() and kvzmalloc().
> ok. I will try to change all the callers to kvmalloc() and kvzalloc().

The kvmalloc() and kvzalloc() are not ready to use in staging-testing
branch on staging tree.
If the kvmalloc and kvzalloc are available to use, I will replace
atomisp_kernel_malloc() and atomisp_kernel_zalloc() with kvmalloc()
and kvzalloc().

Thanks.
Regards,
Daeseok Youn.


>
> Thanks.
> Regards,
> Daeseok Youn
>>
>> regards,
>> dan carpenter
>>
