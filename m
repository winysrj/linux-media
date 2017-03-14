Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33184 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdCNBP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 21:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <1489427686.24765.9.camel@linux.intel.com>
References: <20170313105421.GA32342@SEL-JYOUN-D1> <1489427686.24765.9.camel@linux.intel.com>
From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Tue, 14 Mar 2017 10:15:55 +0900
Message-ID: <CAHb8M2BFkzAsZ=sK+ARybtbR1E4w=ApzHo-BxEr0TEoDWK=gqA@mail.gmail.com>
Subject: Re: [PATCH] staging: atomisp: use k{v}zalloc instead of k{v}alloc and memset
To: Alan Cox <alan@linux.intel.com>
Cc: mchehab@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-03-14 2:54 GMT+09:00 Alan Cox <alan@linux.intel.com>:
>
> On Mon, 2017-03-13 at 19:54 +0900, Daeseok Youn wrote:
> > If the atomisp_kernel_zalloc() has "true" as a second parameter, it
> > tries to allocate zeroing memory from kmalloc(vmalloc) and memset.
> > But using kzalloc is rather than kmalloc followed by memset with 0.
> > (vzalloc is for same reason with kzalloc)
>
> This is true but please don't apply this. There are about five other
> layers of indirection for memory allocators that want removing first so
> that the driver just uses the correct kmalloc/kzalloc/kv* functions in
> the right places.
right. kvmalloc/kvzalloc would be used after preparing those
interfaces in staging tree.
I will try to change all the atomisp_kernel_m{z}alloc() callers to
correct functions to allocate memory.

Thanks.
Regards,
Jake.

>
> Alan
>
