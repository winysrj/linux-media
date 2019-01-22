Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106D2C282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD40021726
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Rk+IQcaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfAVPHE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:07:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43403 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfAVPHD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:07:03 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190122150701euoutp01deb86d2dfd0f94e22c9d768814662431~8NBGFadzG3173231732euoutp01o
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 15:07:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190122150701euoutp01deb86d2dfd0f94e22c9d768814662431~8NBGFadzG3173231732euoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548169621;
        bh=aM8i/vUulid+JbQ2w0vAAJ/GBJVzDtxladv7yCi/YK8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Rk+IQcaKDrxzW7YRK9aK5b1aSX+5WDh0F/EBXOHj/Si43U3eWNvLF9k9LdxVSxmCE
         hTNgy7vgPck44I3omJF6aJKdlyLRfNmGOKm3rQbC1cbWoKSKVdnCvSoJHm308QnOqd
         /uNf1Tb8XBbSRzpxjTGRpf4GtUJQuIr6njAz9tsc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190122150701eucas1p255589c4c5e2fc59de21dd6e164e68df6~8NBFbwK-P0135401354eucas1p2W;
        Tue, 22 Jan 2019 15:07:01 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 41.72.04441.491374C5; Tue, 22
        Jan 2019 15:07:00 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190122150700eucas1p1a635d0d5b318e973e632cca915a3ecaa~8NBEgKHJD2981829818eucas1p1o;
        Tue, 22 Jan 2019 15:07:00 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190122150659eusmtrp17c53f778b0cad846bf7452b87f90e25a~8NBERgwbH0960509605eusmtrp1j;
        Tue, 22 Jan 2019 15:06:59 +0000 (GMT)
X-AuditID: cbfec7f2-5e3ff70000001159-bd-5c4731941f5d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 1E.27.04284.391374C5; Tue, 22
        Jan 2019 15:06:59 +0000 (GMT)
Received: from [106.116.147.30] (unknown [106.116.147.30]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190122150659eusmtip1e9fcea772b62e24454ae4ebae443569e~8NBDnKyPx0290802908eusmtip1C;
        Tue, 22 Jan 2019 15:06:59 +0000 (GMT)
Subject: Re: [PATCH 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range_buggy
To:     Souptick Joarder <jrdr.linux@gmail.com>, akpm@linux-foundation.org,
        willy@infradead.org, mhocko@suse.com, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux@armlinux.org.uk, robin.murphy@arm.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <241810e0-2288-c59b-6c21-6d853d9fe84a@samsung.com>
Date:   Tue, 22 Jan 2019 16:06:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190111151154.GA2819@jordon-HP-15-Notebook-PC>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djPc7pTDN1jDOa8MbSYs34Nm8W1qw3M
        Fmeb3rBbXN41h82iZ8NWVot7a/6zWhyaupfRYtmmP0wW9/scLKa8/clucfDDE1aL3z/msDnw
        eKyZt4bR4/K1i8weO2fdZffYvELLY9OqTjaPTZ8msXucmPGbxePxr5dsHn1bVjF6rN9ylcXj
        8ya5AO4oLpuU1JzMstQifbsErozp856yFKwRrdhzoaaBcbpgFyMnh4SAiUTH+/OsILaQwApG
        iYkbDLoYuYDsL4wSK88cYYNwPjNK/Pqxhr2LkQOsY/NKLoj4ckaJGdPeMEM47xklulsPMIKM
        EhaIlfiycxcLSEJE4AGjxPVn01lAEswCwRILZp1lB7HZBAwlut52sYHYvAJ2Eq1LulhBNrAI
        qEr8nisPYooKxEi0XuaCqBCUODnzCdgUTgFbicenm1ghJspLbH87hxnCFpe49WQ+E8haCYFG
        DolXa14wQ7zpInF68g0WCFtY4tXxLewQtgxQvIcFoqGZUaJ9xix2CKeHUWLrnB1sEFXWEoeP
        XwQ7jllAU2L9Ln2IsKPE7aMXGCGhwidx460gxBF8EpO2TWeGCPNKdLQJQVSrScw6vg5u7cEL
        l5gnMCrNQvLaLCTvzELyziyEvQsYWVYxiqeWFuempxYb5qWW6xUn5haX5qXrJefnbmIEJrrT
        /45/2sH49VLSIUYBDkYlHt6EC64xQqyJZcWVuYcYJTiYlUR4XS+6xQjxpiRWVqUW5ccXleak
        Fh9ilOZgURLnrWZ4EC0kkJ5YkpqdmlqQWgSTZeLglGpgbK3UZG/K43yzU36ZosqPO0VP7CpS
        3Qu8A+wOP72Z/Cdr/5FXh4++rj1nK/qsLuyCt8HN/qM64UvNAyv2Jj0QfeZUu56nIyjvJJtZ
        qPL1f/LvDCL2GTnpVp40//5y5tPJgufOrBI1EYuav79mCtfvB9lPVtRqaCg7qETZfPP47hnX
        oavjvtZDiaU4I9FQi7moOBEAZzUKVXADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t/xu7qTDd1jDC5t0rWYs34Nm8W1qw3M
        Fmeb3rBbXN41h82iZ8NWVot7a/6zWhyaupfRYtmmP0wW9/scLKa8/clucfDDE1aL3z/msDnw
        eKyZt4bR4/K1i8weO2fdZffYvELLY9OqTjaPTZ8msXucmPGbxePxr5dsHn1bVjF6rN9ylcXj
        8ya5AO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsE
        vYzp856yFKwRrdhzoaaBcbpgFyMHh4SAicTmlVxdjFwcQgJLGSXmtRxm7WLkBIrLSJyc1gBl
        C0v8udbFBlH0llHi9t51bCAJYYFYiS87d7GAJEQEHjBKzJq/GSzBLBAscWr3K0aIjgmMEl9W
        n2QESbAJGEp0ve0CK+IVsJNoXdLFCnIGi4CqxO+58iBhUYEYiVlP+tghSgQlTs58wgJicwrY
        Sjw+3cQKMV9d4s+8S8wQtrzE9rdzoGxxiVtP5jNNYBSahaR9FpKWWUhaZiFpWcDIsopRJLW0
        ODc9t9hQrzgxt7g0L10vOT93EyMwurcd+7l5B+OljcGHGAU4GJV4eDnOucYIsSaWFVfmHmKU
        4GBWEuF1vegWI8SbklhZlVqUH19UmpNafIjRFOi3icxSosn5wMSTVxJvaGpobmFpaG5sbmxm
        oSTOe96gMkpIID2xJDU7NbUgtQimj4mDU6qBcaJBhfWPnI3yH/jZ56oukflQUJveZf0hUe+T
        97PmU8asp+JiinNe57NfnftQzPv8xqnbl336sZ1RUNT8apF47NJtZtbxP+YnqDOtiBK8t8Rs
        pw7TO15fHbW1/r/93zJ7qm6KCvN0uyWW7OX4TM95lYDoFDO/NQUPQ1b09XHO1bSUrhVeyM6j
        xFKckWioxVxUnAgA6XIMtAQDAAA=
X-CMS-MailID: 20190122150700eucas1p1a635d0d5b318e973e632cca915a3ecaa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d
References: <CGME20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d@epcas2p4.samsung.com>
        <20190111151154.GA2819@jordon-HP-15-Notebook-PC>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Souptick,

On 2019-01-11 16:11, Souptick Joarder wrote:
> Convert to use vm_insert_range_buggy to map range of kernel memory
> to user vma.
>
> This driver has ignored vm_pgoff. We could later "fix" these drivers
> to behave according to the normal vm_pgoff offsetting simply by
> removing the _buggy suffix on the function name and if that causes
> regressions, it gives us an easy way to revert.

Just a generic note about videobuf2: videobuf2-dma-sg is ignoring vm_pgoff by design. vm_pgoff is used as a 'cookie' to select a buffer to mmap and videobuf2-core already checks that. If userspace provides an offset, which doesn't match any of the registered 'cookies' (reported to userspace via separate v4l2 ioctl), an error is returned.

I'm sorry for the late reply.

> There is an existing bug inside gem_mmap_obj(), where user passed
> length is not checked against buf->num_pages. For any value of
> length > buf->num_pages it will end up overrun buf->pages[i],
> which could lead to a potential bug.
>
> This has been addressed by passing buf->num_pages as input to
> vm_insert_range_buggy() and inside this API error condition is
> checked which will avoid overrun the page boundary.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index 015e737..ef046b4 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -328,28 +328,18 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
>  static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
>  {
>  	struct vb2_dma_sg_buf *buf = buf_priv;
> -	unsigned long uaddr = vma->vm_start;
> -	unsigned long usize = vma->vm_end - vma->vm_start;
> -	int i = 0;
> +	int err;
>  
>  	if (!buf) {
>  		printk(KERN_ERR "No memory to map\n");
>  		return -EINVAL;
>  	}
>  
> -	do {
> -		int ret;
> -
> -		ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
> -		if (ret) {
> -			printk(KERN_ERR "Remapping memory, error: %d\n", ret);
> -			return ret;
> -		}
> -
> -		uaddr += PAGE_SIZE;
> -		usize -= PAGE_SIZE;
> -	} while (usize > 0);
> -
> +	err = vm_insert_range_buggy(vma, buf->pages, buf->num_pages);
> +	if (err) {
> +		printk(KERN_ERR "Remapping memory, error: %d\n", err);
> +		return err;
> +	}
>  
>  	/*
>  	 * Use common vm_area operations to track buffer refcount.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

