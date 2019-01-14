Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3038C43444
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E4FA20659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FgVPJBlF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfANLnH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:43:07 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42380 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfANLnG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 06:43:06 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190114114305euoutp015c9b0340a04d7f19c8351295b0c2ecb4~5tEvwzM5x0352403524euoutp01g
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 11:43:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190114114305euoutp015c9b0340a04d7f19c8351295b0c2ecb4~5tEvwzM5x0352403524euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1547466185;
        bh=U9uIC6yWPkSg7QSEG2aexBV6gezSOjVmFO2Om9ea8Ak=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=FgVPJBlF3jJrsuHKM2+yyrrUbSOboLaPqCid5vxNMVaIZHzSUM4+iUGkS3JRBZtRc
         BMaMagHe6EMaOSR9qlFn/o2minxACshnFQZWY60w+p7IafwTgL/N9/N1b5ggfZgDG2
         /fxUpgFW2v5gk59tB53lKJGlxEz2Ki0vv4xQGCwc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190114114304eucas1p1d12bde6b0139100fb9af9e609a05de8a~5tEu8oscA2130921309eucas1p1M;
        Mon, 14 Jan 2019 11:43:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 23.EB.04806.8C57C3C5; Mon, 14
        Jan 2019 11:43:04 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190114114303eucas1p2c028bcf1ca155e9aa91c83c2f4ba57f0~5tEt68Tgb0174101741eucas1p2Q;
        Mon, 14 Jan 2019 11:43:03 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190114114303eusmtrp2adf80bdabbfdd277b4a176dfece853da~5tEtsMr-c2057220572eusmtrp2w;
        Mon, 14 Jan 2019 11:43:03 +0000 (GMT)
X-AuditID: cbfec7f5-34dff700000012c6-e1-5c3c75c835d3
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 91.3F.04284.6C57C3C5; Mon, 14
        Jan 2019 11:43:02 +0000 (GMT)
Received: from [106.116.147.30] (unknown [106.116.147.30]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190114114302eusmtip1e002d0c52e9dd06c708d580f39700661~5tEtIIoqq2681126811eusmtip1K;
        Mon, 14 Jan 2019 11:43:02 +0000 (GMT)
Subject: Re: fix a layering violation in videobuf2 and improve
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
Message-ID: <141501f5-a9f4-98d7-e958-ca40fc870454@samsung.com>
Date:   Mon, 14 Jan 2019 12:43:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190111181731.11782-1-hch@lst.de>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUwTYRD163a3S7Xmo6BM0KhpgomNB0RjNikiGo0b/3j8Exu1yqYYoZou
        RdEghMOjqRdi0BYFjBHEM5VLaBExWA1ChSLigaLUKMZa5FIOUdoV5d97M29m3kuGJuRtZCi9
        W5fI6XWaeAUlFZc/GnIuemyIVIeXGEnm2vV6EVNwX8U0pn+VMNauNpJxVeVRjOlOGcnUnbMj
        ZuTHGMlctY6KmI4nC5kcz5AkeirramsmWGvJcYq9eyWVPdtehFjn+ULEVr9Mo9iu4W6K/eT6
        QbEnS0sQ22eds1EaI42M5eJ3J3H6JVE7pHH5vUfRvhPUgcGXuVQaGhAbUQANeBm0WnrGsZSW
        42IELd4WJJB+BGmvhymB9CEoNrnRxIj1tZfyYTkuQpD7USqIvAi8rgbS1wjCm8Bz6rPE1wjG
        dgRNR06RPkLgUQSOS43+VRSOAKPH6F8lw1Fg+1ztdyXGYZBpey4yIpqegdWQ5ZIKkkB4csHt
        lwTgcHhnL5D4MIHnQoUnjxBwCLxy54t8twB/l8DlogpKsL0G3veP/E0dBF8cpRIBz4bf9yYG
        MhAcPW+WCMSEoCyv8u+0Ch46mkmfIwIvgNtVS4TyKuh5keEvA54O7Z5AwcR0yC7PJYSyDI4d
        kQvq+WB23Pp39sGzFuI0UpgnRTNPimOeFMf8/24BEpegEM7AJ2g5fqmO27+Y1yTwBp128a69
        CVY0/m0NY46BSlQzurMOYRoppsnAolLLSU0Sn5xQh4AmFMGypNWRarksVpN8kNPv3a43xHN8
        HZpFixUhskNTOrfKsVaTyO3huH2cfqIrogNC01CEaQVa8W3z2dZ161IaCp1qVe0vzVOM+ubZ
        PNqVOZ1RTc7WLPeHwp/ZxeUblmbwhwdaiAWSzSHa6uGL9plnwuvTq4a2pXj7o2udjt5eW0Vi
        r3KOrmAwtVK5xRt9Mzw/dOZJy421OW+734StV8ZYM7NHMhWhNbUiy/K24OMdXx6fUYj5OE2E
        ktDzmj+7Wk/zaQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t/xu7rHSm1iDH5etLJYufook8WC/dYW
        Z5vesFtsenyN1eLyrjlsFj0btrJaHJq6l9Hi9/d/rBbLNv1hsrh7Usdiytuf7A7cHpevXWT2
        2LSqk81j85J6j8k3ljN6nJ+xkNFj980GNo/Hv16yeTy//J3No2/LKkaPz5vkArii9GyK8ktL
        UhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLmf2pnLOhlq/h2
        czpbA+NXli5GTg4JAROJTbffs3UxcnEICSxllOi5sYYdIiEjcXJaAyuELSzx51oXVNFbRom/
        F+aBJYQFAiXe9r9gB0mICOxllLh/+i5YFbPAP0aJ+b07GCFamhkl/i8+xATSwiZgKNH1FmQW
        JwevgJ3Enhe7wQ5hEVCVaNlzFaxGVCBGYtaTPnaIGkGJkzOfgNVwChhI3N+7ACzOLKAu8Wfe
        JWYIW15i+9s5ULa4xK0n85kmMArNQtI+C0nLLCQts5C0LGBkWcUoklpanJueW2yoV5yYW1ya
        l66XnJ+7iREYz9uO/dy8g/HSxuBDjAIcjEo8vBKzrWOEWBPLiitzDzFKcDArifCWOdnECPGm
        JFZWpRblxxeV5qQWH2I0BXpuIrOUaHI+MNXklcQbmhqaW1gamhubG5tZKInznjeojBISSE8s
        Sc1OTS1ILYLpY+LglGpgtN/qdPhqrqPJzOrX3xSutYvret7ascU7aer/7Eea9i+3fT3yV0Ts
        yOvkvrpL+/Ym+Riz82Ut+Pmbpzfwka/TdHPX2Jye96xpc6wern7gdtB7e13YjkWmAsV2G4WX
        3ylgsTjNma3/yjskk7G0Jiq2Su1Qq3mfJfu/x2v7/+64J9WStfSF4DUmJZbijERDLeai4kQA
        8HzmnP0CAAA=
X-CMS-MailID: 20190114114303eucas1p2c028bcf1ca155e9aa91c83c2f4ba57f0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190111181841epcas3p2d7c0bf8f5c11a9863e22ec1b12da6e1b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190111181841epcas3p2d7c0bf8f5c11a9863e22ec1b12da6e1b
References: <CGME20190111181841epcas3p2d7c0bf8f5c11a9863e22ec1b12da6e1b@epcas3p2.samsung.com>
        <20190111181731.11782-1-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Christoph,

On 2019-01-11 19:17, Christoph Hellwig wrote:
> Hi all,
>
> this series fixes a rather gross layering violation in videobuf2, which
> pokes into arm DMA mapping internals to get a DMA address for memory that
> does not have a page structure, and to do so fixes up the dma_map_resource
> implementation to be practically useful.

Thanks for rewriting this 'temporary code'! It predates
dma_map_resource() and that time this was the only way to get it working
somehow. Good that now it is possible to implement in it a clean way
without any unwritten assumptions about the DMA mapping internals. Feel
free to add my:

Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

