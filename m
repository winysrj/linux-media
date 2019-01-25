Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3A0C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 12:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADB2F218F0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 12:28:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iTQuWVW8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfAYM17 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:27:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42558 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfAYM16 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 07:27:58 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190125122756euoutp01ffc55563b12067d37288bb20f41ef52d~9FyDExYbm1207812078euoutp01G
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2019 12:27:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190125122756euoutp01ffc55563b12067d37288bb20f41ef52d~9FyDExYbm1207812078euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548419276;
        bh=1lPVJOJ/AfWt5Dr2dBgMtuYlLQMGEYvhjUdex851l+8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=iTQuWVW8P6sCYgF80V9EDv9Qmzgxj8rAbKC9RQ9fojpcXwwULLMlRBw3yvtUiaz26
         5p3UZm74NXlYGWaItm56kEqKCERbfoHjrBfAo6W4k4RBozSBHdbAtVXq2a/berrTMj
         7wSSUvdTGupymlIsow1Qf6RYXa9lj4nYaym+pNqw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190125122755eucas1p19a117b5e5210018d02974b5820735792~9FyCWccPO2265222652eucas1p1C;
        Fri, 25 Jan 2019 12:27:55 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 11.CC.04294.BC00B4C5; Fri, 25
        Jan 2019 12:27:55 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190125122754eucas1p22f1e8a1622f036635033984a578bc78f~9FyBaj7vb2908929089eucas1p2e;
        Fri, 25 Jan 2019 12:27:54 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190125122754eusmtrp142170f398fc09ead01ade6738ea16475~9FyBMAofb3212032120eusmtrp1H;
        Fri, 25 Jan 2019 12:27:54 +0000 (GMT)
X-AuditID: cbfec7f4-835ff700000010c6-a6-5c4b00cb3e76
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 1C.FB.04128.AC00B4C5; Fri, 25
        Jan 2019 12:27:54 +0000 (GMT)
Received: from [106.116.147.30] (unknown [106.116.147.30]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190125122753eusmtip16e5f2a4120fff53d3e36dc16f39e31b5~9FyAk-Eun0963109631eusmtip1H;
        Fri, 25 Jan 2019 12:27:53 +0000 (GMT)
Subject: Re: [PATCH 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range_buggy
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, pawel@osciak.com,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <febb9775-20da-69d5-4f0e-cd87253eb8f9@samsung.com>
Date:   Fri, 25 Jan 2019 13:27:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAFqt6zbYHq-pS=rGx+3ncJ7rO-LvL5=iOou21oguKjrc=3qouA@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01SWUwTURTldabToVAcC6ZXRU2aaKIGBePHKKZi4jJuqNEvxEjVSVFoIS2I
        S4IFomhFoiARhwouQREaC7VFwQ2KUAlCWKQqRtwqEbVaLTFWcSuDyt8555177znJIzHpM+Ek
        cqcmjdVqlMlyQozXtvg6ItoCVsdH3nCOo41mE0E7e/UY3Z79XkT31BsJOq/aJqT7Tb+EtL3o
        FqIvWoYF9LP8GPqk2yeiGz0uIf39q5GICWZMpSbE9Di7MKaOeypirlbMYiyVRwjG8rlAxNwr
        /o4zr74NEky+tRIxZmsvzngtU9cHxYkX7WCTd+5mtXMVCeLEDpdZkNowZU9pzgE9soIBBZJA
        zYd2WxVuQGJSSlUgaLXZCZ4MIahpvi/giReB5wQn/Dty1Ptu1HUJgfV8PuLJRwTZr44hvyuU
        2gJDdfW4H4dRs+FM0zfMjzHKI4Csm3I/JqgoMLgNhB9LKAW8cDWMYJyaDv16t8iASHICFQ8H
        e8S8ZTy0nnaNrAykNkCxtxfxK6dBjq1kdL0M+lxlI6mB+iGCvoESnE+9FDpr2kYbhMJbh1XE
        43BoK8zD+YEcBLnFnIgneQhsxusE74qGJkeX0J8Io2aCuX4uLy+BJ82dyC8DFQKP3OP5ECFQ
        UHsK42UJHD4k5d0zgHNc+Xe2sbMbO47k3Jhq3Jg63Jg63P+7ZxFeiWRsuk6tYnXzNGzGHJ1S
        rUvXqOZsT1Fb0J9v1/bTMXQd1Q9vsyOKRPJgyWH7ynipULlbt1dtR0Bi8jCJt2VVvFSyQ7l3
        H6tN2apNT2Z1djSZxOUyyf6A55ullEqZxiaxbCqr/fsqIAMn6VFp9eKMywdiMxWxHkqZlZAd
        Li0sKt+1aeH+h+vOCWPvCZa3dmctuxOZK16yIGLt4zpssGYNw0VkH/FlZrp7nCGfglfcVVwb
        vDwUbQ5pf/l6pV4GmwOSPpj2NfclBlUvDgrPfRPzMlG1aFfFsE9xe6Cv7EL5pjj7Xc+hZRtz
        qyZ+eVAmx3WJyqhZmFan/A1IhvhCcgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t/xu7qnGLxjDD5cEraYs34Nm8W1qw3M
        Fmeb3rBbXN41h82iZ8NWVot7a/6zWhyaupfRYtmmP0wW9/scLKa8/clucfDDE1aL3z/msDnw
        eKyZt4bR4/K1i8weO2fdZffYvELLY9OqTjaPTZ8msXucmPGbxePxr5dsHn1bVjF6rN9ylcXj
        8ya5AO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsE
        vYxzT9YzFRyQrZjXXN/AuEWii5GTQ0LARKL782u2LkYuDiGBpYwSO+69Z4dIyEicnNbACmEL
        S/y51gVV9JZRYt//Q8wgCWGBWIkvO3exgNgiAtoScw//YgYpYhb4wCTxfdoRJoiOHiaJTc9X
        sIFUsQkYSnS97QKzeQXsJB4+OQBmswioStxreAu2WlQgRmLWkz52iBpBiZMzn4Bt4BQIlJjx
        +SojiM0soC7xZ94lZghbXqJ562woW1zi1pP5TBMYhWYhaZ+FpGUWkpZZSFoWMLKsYhRJLS3O
        Tc8tNtIrTswtLs1L10vOz93ECIzwbcd+btnB2PUu+BCjAAejEg9vxyHPGCHWxLLiytxDjBIc
        zEoivJ+PecUI8aYkVlalFuXHF5XmpBYfYjQFem4is5Rocj4w+eSVxBuaGppbWBqaG5sbm1ko
        ifOeN6iMEhJITyxJzU5NLUgtgulj4uCUamA8esXi1wEJLa+CTXyPrW6LvGxoeHjJ0itG51yH
        MJd5lFRFnN77/3smCE8tfZNyxrPCqKh1leQe8a6fhgejH8e1WqW1VT7eI6hfoCWVnOLAWmhY
        zb7ypJZnZULoVg7xzyzFTFGd0yvX3r/v/vHPHJvZHoqCkf9Ozi5v8DxRuOxnV1G26IyOq0os
        xRmJhlrMRcWJACVSZnwGAwAA
X-CMS-MailID: 20190125122754eucas1p22f1e8a1622f036635033984a578bc78f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d
References: <CGME20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d@epcas2p4.samsung.com>
        <20190111151154.GA2819@jordon-HP-15-Notebook-PC>
        <241810e0-2288-c59b-6c21-6d853d9fe84a@samsung.com>
        <CAFqt6zbYHq-pS=rGx+3ncJ7rO-LvL5=iOou21oguKjrc=3qouA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Souptick,

On 2019-01-25 05:55, Souptick Joarder wrote:
> On Tue, Jan 22, 2019 at 8:37 PM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> On 2019-01-11 16:11, Souptick Joarder wrote:
>>> Convert to use vm_insert_range_buggy to map range of kernel memory
>>> to user vma.
>>>
>>> This driver has ignored vm_pgoff. We could later "fix" these drivers
>>> to behave according to the normal vm_pgoff offsetting simply by
>>> removing the _buggy suffix on the function name and if that causes
>>> regressions, it gives us an easy way to revert.
>> Just a generic note about videobuf2: videobuf2-dma-sg is ignoring vm_pgoff by design. vm_pgoff is used as a 'cookie' to select a buffer to mmap and videobuf2-core already checks that. If userspace provides an offset, which doesn't match any of the registered 'cookies' (reported to userspace via separate v4l2 ioctl), an error is returned.
> Ok, it means once the buf is selected, videobuf2-dma-sg should always
> mapped buf->pages[i]
> from index 0 ( irrespective of vm_pgoff value). So although we are
> replacing the code with
> vm_insert_range_buggy(), *_buggy* suffix will mislead others and
> should not be used.
> And if we replace this code with  vm_insert_range(), this will
> introduce bug for *non zero*
> value of vm_pgoff.
>
> Please correct me if my understanding is wrong.

You are correct. IMHO the best solution in this case would be to add
following fix:


diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c3366f9c..ca4577a7d28a 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2175,6 +2175,13 @@ int vb2_mmap(struct vb2_queue *q, struct
vm_area_struct *vma)
         goto unlock;
     }
 
+    /*
+     * vm_pgoff is treated in V4L2 API as a 'cookie' to select a buffer,
+     * not as a in-buffer offset. We always want to mmap a whole buffer
+     * from its beginning.
+     */
+    vma->vm_pgoff = 0;
+
     ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
 
 unlock:
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index aff0ab7bf83d..46245c598a18 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -186,12 +186,6 @@ static int vb2_dc_mmap(void *buf_priv, struct
vm_area_struct *vma)
         return -EINVAL;
     }
 
-    /*
-     * dma_mmap_* uses vm_pgoff as in-buffer offset, but we want to
-     * map whole buffer
-     */
-    vma->vm_pgoff = 0;
-
     ret = dma_mmap_attrs(buf->dev, vma, buf->cookie,
         buf->dma_addr, buf->size, buf->attrs);
 
-- 

Then you can simply use non-buggy version of your function in
drivers/media/common/videobuf2/videobuf2-dma-sg.c.

I can send above as a formal patch if you want.

> So what your opinion about this patch ? Shall I drop this patch from
> current series ?
> or,
> There is any better way to handle this scenario ?
>
>
>>> There is an existing bug inside gem_mmap_obj(), where user passed
>>> length is not checked against buf->num_pages. For any value of
>>> length > buf->num_pages it will end up overrun buf->pages[i],
>>> which could lead to a potential bug.
> It is not gem_mmap_obj(), it should be vb2_dma_sg_mmap().
> Sorry about it.
>
> What about this issue ? Does it looks like a valid issue ?

It is already handled in vb2_mmap(). Such call will be rejected.


> ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

