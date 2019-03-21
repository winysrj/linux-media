Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08262C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 11:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA3D21916
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 11:51:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RjzMB1v7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfCULvy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:51:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52763 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfCULvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 07:51:53 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190321115152euoutp027d7806ca16181c0eb108e354d459e7ca~N9xQd0Zi41118811188euoutp020
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 11:51:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190321115152euoutp027d7806ca16181c0eb108e354d459e7ca~N9xQd0Zi41118811188euoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553169112;
        bh=2yWmiZORcYmuq6keKZja5kydfB6yG+gI2O3tmnryF8I=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=RjzMB1v7ffibQebKuTlxHJfrXAb2Qb++TAgo2dZutmSo17DaCt2gLHSrLAUUF2N1I
         VtMVjQgIgTc3/LeAfquqLZLhTO4w2C4oW3PMwimOCF9pjnZSNn8MxBo49ftNqDfspR
         LeqlcHqf9/yDXywRWMu3DG+M3uIgTxKLHbJsHAXs=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190321115151eucas1p28667abb880a94a6a635961f7e78d5952~N9xPveXJ51512815128eucas1p2E;
        Thu, 21 Mar 2019 11:51:51 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id F2.7E.04294.7DA739C5; Thu, 21
        Mar 2019 11:51:51 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190321115150eucas1p128f5eb471751834acef4a2d080ebc706~N9xPE8pqV1803618036eucas1p1W;
        Thu, 21 Mar 2019 11:51:50 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190321115150eusmtrp27ab4ac4c4714f4a093015d423009bc5b~N9xO6QwWK2849628496eusmtrp2H;
        Thu, 21 Mar 2019 11:51:50 +0000 (GMT)
X-AuditID: cbfec7f4-835ff700000010c6-28-5c937ad7daac
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id BB.DE.04128.6DA739C5; Thu, 21
        Mar 2019 11:51:50 +0000 (GMT)
Received: from [106.120.50.74] (unknown [106.120.50.74]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190321115149eusmtip21ab572789c77d58c6ef008fbf8a9cc02~N9xOP7_kV2421824218eusmtip2M;
        Thu, 21 Mar 2019 11:51:49 +0000 (GMT)
Subject: Re: [PATCH v2 3/4] media: s5p-cec: fix possible object reference
 leak
To:     Wen Yang <wen.yang99@zte.com.cn>
Cc:     mchehab@kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        "Hans Verkuil (hansverk)" <hansverk@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wen Yang <yellowriver2010@hotmail.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <376c5ed6-7c2d-62a1-9ed0-48a329965d06@samsung.com>
Date:   Thu, 21 Mar 2019 12:51:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <1550015279-42723-1-git-send-email-wen.yang99@zte.com.cn>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsWy7djPc7rXqybHGCxaKmSx5OcuJosPE2cy
        WlzeNYfNomfDVlaLGef3MVks2/SHyaLv9Stmi3OvfrJZLHjezmJxf9FyNgcujym/N7J6PO45
        w+axaVUnm8fnTXIea/b9YAlgjeKySUnNySxLLdK3S+DKuLT1MmvBUcGKOx9nMTYw7uDrYuTk
        kBAwkTh0bjdzFyMXh5DACkaJzd/mMEI4Xxgllix8CZX5zCjRvfIkC0zL9pZOFojEckaJlcfa
        WSGct4wSL/qmsoFUCQsESFyft48RxBYRUJE4u3QnE0gRs8BKJon/i1+ygiTYBAwlut52gTXw
        CthJ3F81hQnEZhFQlWidfQOsWVQgRuLN8ZeMEDWCEidnPgE7g1PATeLmnZdgvcwC8hLb385h
        hrDFJW49mQ+2TELgHLvEqsk/2CHudpFYceoeM4QtLPHq+BaouIzE/50wDc2MEg/PrWWHcHoY
        JS43zWCEqLKWOHz8ItDZHEArNCXW79KHCDtKTN91GiwsIcAnceOtIMQRfBKTtk1nhgjzSnS0
        CUFUq0nMOr4Obu3BC5eYJzAqzULy2iwk78xC8s4shL0LGFlWMYqnlhbnpqcWG+WllusVJ+YW
        l+al6yXn525iBKap0/+Of9nBuOtP0iFGAQ5GJR7eCIdJMUKsiWXFlbmHGCU4mJVEeHdFT44R
        4k1JrKxKLcqPLyrNSS0+xCjNwaIkzlvN8CBaSCA9sSQ1OzW1ILUIJsvEwSnVwGgtdrbQRVYi
        a8/LpNPP5Ce+3nbqWka/7RXn0F47X7llv1W9L028uvq+z7kDS28L9KQc/VKoG3XmsPEK/ijx
        w48/N+R6+nO85bVseLz+ZHv6n2k3WljyKwL1NJdtDfBj391gJH9AlrNXsNXi1d0v8+PkQybp
        bD34ZnXhdL7+lghn8z9LtNwC85VYijMSDbWYi4oTARDmF7JPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xe7rXqibHGOz4L2mx5OcuJosPE2cy
        WlzeNYfNomfDVlaLGef3MVks2/SHyaLv9Stmi3OvfrJZLHjezmJxf9FyNgcujym/N7J6PO45
        w+axaVUnm8fnTXIea/b9YAlgjdKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV
        0rezSUnNySxLLdK3S9DLuLT1MmvBUcGKOx9nMTYw7uDrYuTkkBAwkdje0snSxcjFISSwlFGi
        5cg7VoiEjMTJaQ1QtrDEn2tdbBBFrxkl/qxoZO5i5OAQFvCTmDzbAqRGREBF4uzSnUwgNcwC
        K5kkji2YxgTRMJNR4ujBaWwgVWwChhJdb7vAbF4BO4n7q6YwgdgsAqoSrbNvMILYogIxEv9u
        72WFqBGUODnzCQuIzSngJnHzzkuwXmYBM4l5mx8yQ9jyEtvfzoGyxSVuPZnPNIFRaBaS9llI
        WmYhaZmFpGUBI8sqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwKjcduznlh2MXe+CDzEKcDAq
        8fAuMJkUI8SaWFZcmXuIUYKDWUmEd1f05Bgh3pTEyqrUovz4otKc1OJDjKZAz01klhJNzgcm
        jLySeENTQ3MLS0NzY3NjMwslcd7zBpVRQgLpiSWp2ampBalFMH1MHJxSDYy7lryWK5lbe0V0
        T8nvCwcqmL9/Wea3e+ajzTGvZ1VLTDrvN28bc/Pebne9mv0pKpOLLXe2tIiv7mmYzj2h59LS
        A6pzvDNttgvLsD3VPHe9uOhB94HmkhbPHX596yr/nz30aZLIu00VVU9fXhbda9X0YFpTR9/+
        pwdEjJoubA4stdpfOX9RnNU6JZbijERDLeai4kQA389KseACAAA=
X-CMS-MailID: 20190321115150eucas1p128f5eb471751834acef4a2d080ebc706
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190212234951epcas3p3c5dff046aab328e983ecdcecb916148c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190212234951epcas3p3c5dff046aab328e983ecdcecb916148c
References: <CGME20190212234951epcas3p3c5dff046aab328e983ecdcecb916148c@epcas3p3.samsung.com>
        <1550015279-42723-1-git-send-email-wen.yang99@zte.com.cn>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi

On 2019-02-13 00:47, Wen Yang wrote:
> The call to of_parse_phandle() returns a node pointer with refcount
> incremented thus it must be explicitly decremented here after the last
> usage.
> The of_find_device_by_node() takes a reference to the underlying device
> structure, we also should release that reference.
> This patch fixes those two issues.
>
> Hans Verkuil says:
> The cec driver should never take a reference of the hdmi device.
> It never accesses the HDMI device, it only needs the HDMI device pointer as
> a key in the notifier list.
> The real problem is that several CEC drivers take a reference of the HDMI
> device and never release it. So those drivers need to be fixed.
>
> Fixes: a93d429b51fb ("[media] s5p-cec: add cec-notifier support, move out of staging")
> Suggested-by: Hans Verkuil (hansverk) <hansverk@cisco.com>
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
> Cc: Hans Verkuil (hansverk) <hansverk@cisco.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Wen Yang <yellowriver2010@hotmail.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> v2->v1:
> - move of_node_put() to just after the 'hdmi_dev = of_find_device_by_node(np)'.
> - put_device() can be done before the cec = devm_kzalloc line.
>
>   drivers/media/platform/s5p-cec/s5p_cec.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
> index 8837e26..1f5c355 100644
> --- a/drivers/media/platform/s5p-cec/s5p_cec.c
> +++ b/drivers/media/platform/s5p-cec/s5p_cec.c
> @@ -192,9 +192,11 @@ static int s5p_cec_probe(struct platform_device *pdev)
>   		return -ENODEV;
>   	}
>   	hdmi_dev = of_find_device_by_node(np);
> +	of_node_put(np);
>   	if (hdmi_dev == NULL)
>   		return -EPROBE_DEFER;
>   
> +	put_device(&hdmi_dev->dev);
>   	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
>   	if (!cec)
>   		return -ENOMEM;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

