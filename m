Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC13C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 12:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8905820665
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 12:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZmCEu6H7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfAGMEY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 07:04:24 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35699 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfAGMEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 07:04:24 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190107120422euoutp01cd767d93bdce3845320e44a6546def88~3j2VbqfVv2312323123euoutp01t;
        Mon,  7 Jan 2019 12:04:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190107120422euoutp01cd767d93bdce3845320e44a6546def88~3j2VbqfVv2312323123euoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1546862662;
        bh=iI8RbsnQt6T6oUGkyuhicTX6KV6s3Z9+0rdfzteeVVI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ZmCEu6H7Waf+NmqKarGTzzIgPbu8y/1cDORIVUTauymapCKSGPIJboS4SAhFVNyJc
         2/jcg7SJDScsVz4MaYeqQwDlwaKI7fYs7TdDcCMIVJKxOwYlqQBjKpzIQzrzP4Qfbr
         PIGdM9IVqTix3MYTxNSLQVH2wFzVfg+rYkXT0DTk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190107120421eucas1p230ab82d5c7b954ee422517842603a98e~3j2Ut6-PL3085630856eucas1p2k;
        Mon,  7 Jan 2019 12:04:21 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id EC.47.04806.540433C5; Mon,  7
        Jan 2019 12:04:21 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190107120420eucas1p179b227d5ff0e040540ed9f48573e6e73~3j2T6HfzB1288112881eucas1p1b;
        Mon,  7 Jan 2019 12:04:20 +0000 (GMT)
X-AuditID: cbfec7f5-79db79c0000012c6-1f-5c334045f3e4
Received: from eusync4.samsung.com ( [203.254.199.214]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 53.F8.04284.440433C5; Mon,  7
        Jan 2019 12:04:20 +0000 (GMT)
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset="UTF-8"
Received: from AMDC2765.digital.local ([106.116.147.25]) by
        eusync4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PKY004K9MV5AT00@eusync4.samsung.com>;
        Mon, 07 Jan 2019 12:04:20 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH] media: s5p-mfc: fix incorrect bus assignment in virtual
 child device
Date:   Mon, 07 Jan 2019 13:04:14 +0100
Message-id: <20190107120414.30622-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWy7djPc7quDsYxBrfaxCxurTvHatGzYSur
        xYzz+5gs1h65y27x43gfs8XhN+2sDmweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSu
        jP27djIWHOSsWLhjOVMD4zyOLkZODgkBE4mbS56ygdhCAisYJboWpnQxcgHZnxklbu67z9rF
        yAFWdPtIJkR8GaPElb8HmEEaeAUEJX5MvscCUsMsIC9x5FI2SJhZQFNi6+717BD1DUwS137M
        YAdJsAkYSnS97QJbJiLgJLFw1l+wImaB44wSr6d8BUsIC4RLbP16hAXEZhFQlfjxcQcbxDJb
        iY8zl7FDXC0vsXoDyBFcQHYPm8Tfjv9Ql7pItC/0gKgRlnh1fAtUvYxEZ8dBJoj6ZkaJ9hmz
        2KGaGSW2zoHYICFgLXH4+EVWiB/4JCZtm84MMZRXoqNNCKLEQ2Je2xxGkLCQQKxE7yG2CYzS
        s5DCYhYiLGYhhcUCRuZVjOKppcW56anFxnmp5XrFibnFpXnpesn5uZsYgTF9+t/xrzsY9/1J
        OsQowMGoxMNrEGAUI8SaWFZcmXuIUYKDWUmEN+epYYwQb0piZVVqUX58UWlOavEhRmkOFiVx
        3mqGB9FCAumJJanZqakFqUUwWSYOTqkGxhkmn3u3P/v6gzlteqtR+7Lc9b8lv73a0SGTWneH
        YdfuPXwGa9KszOIW/U8OKgyduqRlxeyZO1vya8u9O6Xs9tk+OK/mq8zHFtUd33rwT6n8uuW7
        Tizs37Tg66TdW22evLmU5/Us4cPaufVTfm1MN5Rc03UlZK6xl8LB75lfvY9vv9fTzXpmrpwS
        S3FGoqEWc1FxIgCuM0wC5QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xa7ouDsYxBos/q1rcWneO1aJnw1ZW
        ixnn9zFZrD1yl93ix/E+ZovDb9pZHdg8ds66y+7Rt2UVo8fnTXIBzFFcNimpOZllqUX6dglc
        Gft37WQsOMhZsXDHcqYGxnkcXYwcHBICJhK3j2R2MXJyCAksYZTY/94FxOYVEJT4MfkeC0gJ
        s4C8xJFL2SBhZgF1iUnzFjF3MXIBlTcxSZx5+5EdJMEmYCjR9baLDcQWEXCSWDjrLztEw0lG
        ietPhUBsYYFwifkXfoLVsAioSvz4uIMNYpetxMeZy8DqJYB2rd5wgHkCI+8sJGfMQjhjFpIz
        FjAyr2IUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAgMu23Hfm7ewXhpY/AhRgEORiUeXoMAoxgh
        1sSy4srcQ4wSHMxKIrw5Tw1jhHhTEiurUovy44tKc1KLDzFKc7AoifOeN6iMEhJITyxJzU5N
        LUgtgskycXBKNTBmaK/SqDo/YZF0p9gZ5vj6NfunXV1VolF2ZmFHyiahh2+LHCxWHnryJT17
        Ats9VQHj9V/n7ee6WKvYomrapfH1yq0LbNaZ+00fHIxIfnL1XOgWtlk7HCRFjA0/9k/yFWnm
        bcw3Xxz4ZbnurK4Jm13vxMwRq9AVf1PxZkvIStNee8Vv7ly6ijFKLMUZiYZazEXFiQBmwAkc
        NwIAAA==
X-CMS-MailID: 20190107120420eucas1p179b227d5ff0e040540ed9f48573e6e73
X-Msg-Generator: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190107120420eucas1p179b227d5ff0e040540ed9f48573e6e73
References: <CGME20190107120420eucas1p179b227d5ff0e040540ed9f48573e6e73@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Virtual MFC codec's child devices must not be assigned to platform bus,
because they are allocated as raw 'struct device' and don't have the
corresponding 'platform' part. This fixes NULL pointer access revealed
recently by commit a66d972465d1 ("devres: Align data[] to
ARCH_KMALLOC_MINALIGN").

Reported-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
Fixes: c79667dd93b0 ("media: s5p-mfc: replace custom reserved memory handling code with generic one")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 927a1235408d..ca11f8a7569d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1089,7 +1089,6 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 	device_initialize(child);
 	dev_set_name(child, "%s:%s", dev_name(dev), name);
 	child->parent = dev;
-	child->bus = dev->bus;
 	child->coherent_dma_mask = dev->coherent_dma_mask;
 	child->dma_mask = dev->dma_mask;
 	child->release = s5p_mfc_memdev_release;
-- 
2.17.1

