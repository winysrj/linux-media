Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFC7C43444
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D8F820873
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WxB/wrsj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfANMm3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 07:42:29 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52464 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfANMm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 07:42:29 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190114124227euoutp0247736420ce42efdce8f9f9bd1ec38d2f~5t4lnsLgy3112031120euoutp02w
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 12:42:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190114124227euoutp0247736420ce42efdce8f9f9bd1ec38d2f~5t4lnsLgy3112031120euoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1547469747;
        bh=JkEUB/1etH5HwCAXK5XQVE51QY576xSQ+oOLRoEdTo4=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=WxB/wrsjzNm/oPYCYyWojDl04dJdH/qcSBe0q5NXZ+fhCzZkQAjhODUe0E2+5EKEU
         5ecllJTmSrTr6I8faFf2kUn6aPVEREmFbf3Y57KCpE1m9Vpyy8kDRpH7dZzoop83Tn
         PGDyvDmz0X4LR5Ma/jqkemIISb1dfvcB3kfeXmhw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190114124226eucas1p18c02e40c1d8f2e16dc9b8301b473a9bb~5t4k4zJlz2526725267eucas1p10;
        Mon, 14 Jan 2019 12:42:26 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id E3.96.04806.2B38C3C5; Mon, 14
        Jan 2019 12:42:26 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190114124225eucas1p1b6a3be0a59408c78ce17ff2e27665f99~5t4jrTm-12526825268eucas1p1z;
        Mon, 14 Jan 2019 12:42:25 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190114124225eusmtrp2d17053cb57772f09b8c7dcd061959277~5t4jcf_cZ0469204692eusmtrp2O;
        Mon, 14 Jan 2019 12:42:25 +0000 (GMT)
X-AuditID: cbfec7f5-367ff700000012c6-f1-5c3c83b28e63
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C8.0D.04128.1B38C3C5; Mon, 14
        Jan 2019 12:42:25 +0000 (GMT)
Received: from [106.116.147.30] (unknown [106.116.147.30]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190114124224eusmtip2baec9451d28ae77dfcf4ef3317c0caf8~5t4i0jU620772007720eusmtip2J;
        Mon, 14 Jan 2019 12:42:24 +0000 (GMT)
Subject: Re: [PATCH 3/3] videobuf2: replace a layering violation with
 dma_map_resource
To:     Christoph Hellwig <hch@lst.de>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <6f8892ac-c2aa-10df-c74f-ba032bf75160@samsung.com>
Date:   Mon, 14 Jan 2019 13:42:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190111181731.11782-4-hch@lst.de>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRju29nOjkdnX1PzRaVkXcBuGvrjhCJ2o4MQBCFYrXLl8VI6ZZsu
        NcwLqYlYdKFaywwyy+i2vMecTnKIt8qalkQXTSszS7M0l+U8Wv57nud7n/d5XvgoQmoVeVCx
        Sg2nUiriZCQtrGya6FhryA6S+zVU+zA3bz0SMMWmQKYt67OYMfRaRUxnrZ5kCu5ViBjzOSNi
        Jn9OiZjrBpuAedW8hjk7NCEOcWQ7rU8I1lB2gmQfXDvGnukuRWzHhauIffgig2R7f30k2YHO
        nyRbWF6G2FHDkh30bjookouLTeZUvsERdExe+TkiMcvzyP2SfkEGGnHLRw4U4ADoudwiykc0
        JcU3ENRNtiOefEcw3jop5MkogvrWL2jOkm38PWspRfCm0kTyZBhBWa5+2kJRLjgcxvq32XVX
        bETQnnNyxkFgGwJLUdvMKhKvh/yhfNKOJTgYupvqZ3QhXgFVL20zi9ywHI530vzIImi+2Ce0
        YwfsB8b3zwV2TOClUDWkJ3jsDi/7rgjsWYDHxGC1nZ+tvWW66aCQxy7wyVIu5rEX/KmZM2Qj
        yL2gE/OkAEGFvprkpwKh0fJEZG9EYB+4W+vLyxvhQ2EpYZcBO0P30CK+hDOcrjw/K0sgL0fK
        T68EneXOv9iGx0+JU0imm3eabt45unnn6P7nFiNhGXLnktTx0ZzaX8lp16kV8eokZfS6gwnx
        BjT921qmLGPVqM52wIwwhWROErgUKJeKFMnqlHgzAoqQuUqSNwXJpZJIRUoqp0rYr0qK49Rm
        5EkJZe6StAVv9khxtELDHea4RE419yqgHDwy0Ab3XSMLnF9rvMMoL9fxfaOtobethyA0Ki5s
        kNDS2H/5ri4iJtySec/W80A+bEqLGq5olNZouj3Ss5Rfn30L6TIlKMXlRzM35/gHLI5VlqaK
        8oZXE7FZb53afPv1EXuB3lqiCQLTzgQn74Uj2vSigRvL9m3Rbm//4Ug3vZPXyITqGMX6VYRK
        rfgLloMPVWkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xe7obm21iDB7eEbNYufook8WC/dYW
        Z5vesFtsenyN1eLyrjlsFj0btrJaHJq6l9Hi9/d/rBbLNv1hsrh7Usdiytuf7A7cHpevXWT2
        2LSqk81j85J6j8k3ljN6nJ+xkNFj980GNo/Hv16yeTy//J3No2/LKkaPz5vkArii9GyK8ktL
        UhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DI6tkxlLmiSrti4
        9BlTA+Mn0S5GTg4JAROJ5r1/WbsYuTiEBJYySix9upEVIiEjcXJaA5QtLPHnWhcbRNFbRok9
        234ydzFycAgLREh8feYOEhcR2Msocf/0XbAiZoF/jBLze3cwQnSsZJR48r8JbBSbgKFE11uQ
        UZwcvAJ2EjeOHWAEsVkEVCW23/rDAmKLCsRIzHrSxw5RIyhxcuYTsDingIHE3qdXmUBsZgF1
        iT/zLjFD2PIS29/OgbLFJW49mc80gVFoFpL2WUhaZiFpmYWkZQEjyypGkdTS4tz03GIjveLE
        3OLSvHS95PzcTYzAaN527OcWoIfeBR9iFOBgVOLhlZhtHSPEmlhWXJl7iFGCg1lJhLfMySZG
        iDclsbIqtSg/vqg0J7X4EKMp0HMTmaVEk/OBiSavJN7Q1NDcwtLQ3Njc2MxCSZz3vEFllJBA
        emJJanZqakFqEUwfEwenVAOjzW6udM6jHy4tWq/LuP22+OQF8zKdmJyCnpdcOPCsZK3U3JLy
        /l9Viqff6RQqrchZ/bD7kQHrtlwb8X9r1I879nPWvj57yiFt0c6961ZGzf756wfHDC1ujx9q
        ku/X1uzbYLzNNGyP2ZdP8zoyz67cMeOT6vfIyyKLmHIOCv++v8nVkWEJ7+ciSSWW4oxEQy3m
        ouJEACyoswL8AgAA
X-CMS-MailID: 20190114124225eucas1p1b6a3be0a59408c78ce17ff2e27665f99
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190111181812epcas2p1eeb68a16701631513eaf297073f7299f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190111181812epcas2p1eeb68a16701631513eaf297073f7299f
References: <20190111181731.11782-1-hch@lst.de>
        <CGME20190111181812epcas2p1eeb68a16701631513eaf297073f7299f@epcas2p1.samsung.com>
        <20190111181731.11782-4-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Christoph,

On 2019-01-11 19:17, Christoph Hellwig wrote:
> vb2_dc_get_userptr pokes into arm direct mapping details to get the
> resemblance of a dma address for a a physical address that does is
> not backed by a page struct.  Not only is this not portable to other
> architectures with dma direct mapping offsets, but also not to uses
> of IOMMUs of any kind.  Switch to the proper dma_map_resource /
> dma_unmap_resource interface instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

There are checks for IOMMU presence in other places in vb2-dma-contig,
so it was used only when no IOMMU is available, but I agree that the
hacky code should be replaced by a generic code if possible.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

V4L2 pipeline works fine on older Exynos-based boards with CMA and IOMMU
disabled.

> ---
>  .../common/videobuf2/videobuf2-dma-contig.c   | 41 ++++---------------
>  1 file changed, 9 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> index aff0ab7bf83d..82389aead6ed 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> @@ -439,42 +439,14 @@ static void vb2_dc_put_userptr(void *buf_priv)
>  				set_page_dirty_lock(pages[i]);
>  		sg_free_table(sgt);
>  		kfree(sgt);
> +	} else {
> +		dma_unmap_resource(buf->dev, buf->dma_addr, buf->size,
> +				   buf->dma_dir, 0);
>  	}
>  	vb2_destroy_framevec(buf->vec);
>  	kfree(buf);
>  }
>  
> -/*
> - * For some kind of reserved memory there might be no struct page available,
> - * so all that can be done to support such 'pages' is to try to convert
> - * pfn to dma address or at the last resort just assume that
> - * dma address == physical address (like it has been assumed in earlier version
> - * of videobuf2-dma-contig
> - */
> -
> -#ifdef __arch_pfn_to_dma
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
> -{
> -	return (dma_addr_t)__arch_pfn_to_dma(dev, pfn);
> -}
> -#elif defined(__pfn_to_bus)
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
> -{
> -	return (dma_addr_t)__pfn_to_bus(pfn);
> -}
> -#elif defined(__pfn_to_phys)
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
> -{
> -	return (dma_addr_t)__pfn_to_phys(pfn);
> -}
> -#else
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
> -{
> -	/* really, we cannot do anything better at this point */
> -	return (dma_addr_t)(pfn) << PAGE_SHIFT;
> -}
> -#endif
> -
>  static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>  	unsigned long size, enum dma_data_direction dma_dir)
>  {
> @@ -528,7 +500,12 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>  		for (i = 1; i < n_pages; i++)
>  			if (nums[i-1] + 1 != nums[i])
>  				goto fail_pfnvec;
> -		buf->dma_addr = vb2_dc_pfn_to_dma(buf->dev, nums[0]);
> +		buf->dma_addr = dma_map_resource(buf->dev,
> +				__pfn_to_phys(nums[0]), size, buf->dma_dir, 0);
> +		if (dma_mapping_error(buf->dev, buf->dma_addr)) {
> +			ret = -ENOMEM;
> +			goto fail_pfnvec;
> +		}
>  		goto out;
>  	}
>  

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

