Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DDEC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FFAB2146D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gQxdlhTK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FFAB2146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbeLGKCQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:02:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21801 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbeLGKCQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 05:02:16 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20181207100212epoutp0238fe060b13e7c9a710e2a1541cddbe8f~uBL0M4Wa-0948309483epoutp02D;
        Fri,  7 Dec 2018 10:02:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20181207100212epoutp0238fe060b13e7c9a710e2a1541cddbe8f~uBL0M4Wa-0948309483epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1544176932;
        bh=rZKQ1M5S5j5L6GvVcrpiuC9wN7ZRU6c8T9VTe4VUg1I=;
        h=Subject:To:Cc:From:Date:In-reply-to:References:From;
        b=gQxdlhTKYqRzr//2ucTW1HBT3na4fFwDJUUAsJQVt4cLuNNM9L19HFe95P3UhYzy+
         y2I2weMZdEtOIvmAyBz7mMOfQWbvSbfOhBwR9j0hEJOmPcj63j3XIBL1RvMK1XYUIn
         cLBOl9n0rhhBBE5bJm1QH0NF7pMTWTThTvi6bzhQ=
Received: from epsmges1p1.samsung.com (unknown [182.195.42.53]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20181207100211epcas1p3e38405e80fb4cf89f5ede22dbcd24ff5~uBLz5eL5C1074310743epcas1p3D;
        Fri,  7 Dec 2018 10:02:11 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.C3.04058.3254A0C5; Fri,  7 Dec 2018 19:02:11 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20181207100211epcas1p2caa3a1da5152bd7c1476d795e788e776~uBLzoQwSg2495024950epcas1p2F;
        Fri,  7 Dec 2018 10:02:11 +0000 (GMT)
X-AuditID: b6c32a35-e37ff70000000fda-e4-5c0a4523b456
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p1new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 85.65.03601.3254A0C5; Fri,  7 Dec
        2018 19:02:11 +0900 (KST)
Received: from [106.116.147.40] by mmp2.samsung.com (Oracle Communications
        Messaging Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PJD009RX2JI0B40@mmp2.samsung.com>; Fri, 07 Dec 2018 19:02:11 +0900 (KST)
Subject: Re: [PATCH v2] media: Use of_node_name_eq for node name comparisons
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>
From:   Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <63971417-f761-e891-f410-9efa26dd2c6d@samsung.com>
Date:   Fri, 07 Dec 2018 11:02:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.2.1
MIME-version: 1.0
In-reply-to: <20181206193519.13367-1-robh@kernel.org>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7bCmrq6yK1eMwZkXphbf+ltZLOYfOcdq
        Mbm1i82i//FrZovz5zewW5xtesNu0TlxCbvFpsfXWC0u75rDZtGzYSurxYzz+5gslm36w2Tx
        7mWExf89O9gd+Dxmd8xk9di0qpPNY/OSeo++LasYPY7f2M7k8XmTnMfez79ZAtijuGxSUnMy
        y1KL9O0SuDLOf9jKXnCbueLMmr1sDYy9zF2MnBwSAiYSb4/tYu1i5OIQEtjBKPHs+1QmCOc7
        o0Tfo2dMMFVr9v9lh0hsYJS4Oa+VEcK5zyhxrvk6G0iVsICPxL5591hAbBEBRYnfbdPA5jIL
        vGaWuNr3gR0kwSZgKNF7tI8RxOYVsJN4OPMB0CEcHCwCqhIbHySChEUFIiQ67q9mgygRlPgx
        GWImp4CpxNarT8AuYhbQlHjxZRILhC0ucez+TUYIW15i85q3zCB7JQT62SWe3IPYKyHgInG5
        9w2ULSzx6vgWdpC9EgLSEpeO2kKEqyV2be+G6u1glGi5sB0aSNYSh49fZIVYwCfx7msPK0Qv
        r0RHmxBEiYfEkpuPoYEC1Hvxw37GCYyys5D8MAvJ3bOQ3D0Lyd0LGFlWMYqlFhTnpqcWGxYY
        6hUn5haX5qXrJefnbmIEJyUt0x2MU875HGIU4GBU4uG94MQZI8SaWFZcmXuIUYKDWUmEV8mW
        K0aINyWxsiq1KD++qDQntfgQozQHi5I47xOpudFCAumJJanZqakFqUUwWSYOTqkGxsh32Ufr
        bh1b45zBknKY+6z2/V0HKmwWze1d47jHsHe2iM9/geLjxUn7UpJd2H5f+bdgjvTJ6WL8amla
        Tn/X/j9VWDN1Z7r7v7dSMp17MsvTg3/c8przN/PRcztvo71Hfm659HRL9/mjuReO9rZNOWF4
        INblwCYGzTzb0qrlM1O3n57scZyrJlSJpTgj0VCLuag4EQDyp+TERgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQV1lV64Yg1VbZC2+9beyWMw/co7V
        YnJrF5tF/+PXzBbnz29gtzjb9IbdonPiEnaLTY+vsVpc3jWHzaJnw1ZWixnn9zFZLNv0h8ni
        3csIi/97drA78HnM7pjJ6rFpVSebx+Yl9R59W1Yxehy/sZ3J4/MmOY+9n3+zBLBHcdmkpOZk
        lqUW6dslcGWc/7CVveA2c8WZNXvZGhh7mbsYOTkkBEwk1uz/y97FyMUhJLCOUWL9vF5WCOch
        o8TO91eYQKqEBXwk9s27xwJiiwgoSvxumwZWxCzwllli0umzbCAJIaBRq98/A7PZBAwleo/2
        MYLYvAJ2Eg9nPgBax8HBIqAqsfFBIkhYVCBC4uzLdVAlghI/JkPM5xQwldh69QkTSDmzgLrE
        lCm5IGFmAXGJY/dvMkLY8hKb17xlnsAoMAtJ9yyEjllIOmYh6VjAyLKKUTK1oDg3PbfYqMAw
        L7Vcrzgxt7g0L10vOT93EyMwsrYd1urbwXh/SfwhRgEORiUe3goHzhgh1sSy4srcQ4wSHMxK
        IrxKtlwxQrwpiZVVqUX58UWlOanFhxilOViUxHlv5x2LFBJITyxJzU5NLUgtgskycXBKNTC2
        XNx9qv/ZrP0v1fk4Lzw78f7slJU6+kyFZ+u2vQ62WtVwaa98GNcd9hvWqdaLU+JUPFMW+0lO
        MvPU9Qy7o7k8I+z7rS2zjh7ZWn//S1bcrb4LWzMCRB8fj87tiWKtZdWqfT3rZBRbUnXlUaGT
        pvsWZkTVaso8n8n/+2+k+crnJ/r/7Fj76JWhEktxRqKhFnNRcSIAjSqNMqgCAAA=
X-CMS-MailID: 20181207100211epcas1p2caa3a1da5152bd7c1476d795e788e776
X-Msg-Generator: CA
CMS-TYPE: 101P
X-CMS-RootMailID: 20181207100211epcas1p2caa3a1da5152bd7c1476d795e788e776
References: <20181206193519.13367-1-robh@kernel.org>
        <CGME20181207100211epcas1p2caa3a1da5152bd7c1476d795e788e776@epcas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/6/18 20:35, Rob Herring wrote:
> Convert string compares of DT node names to use of_node_name_eq helper
> instead. This removes direct access to the node name pointer.

> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v2:
> - Also convert tabs to spaces between the 'if' and '('

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
