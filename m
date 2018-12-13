Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E0DC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D252C20880
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HGbdegIO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D252C20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbeLMNgz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:36:55 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46285 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729422AbeLMNgy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:36:54 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20181213133652euoutp02d9cde9638d90ae948cfc88f362b5dc2e~v5_91S9Xn2788027880euoutp02s;
        Thu, 13 Dec 2018 13:36:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20181213133652euoutp02d9cde9638d90ae948cfc88f362b5dc2e~v5_91S9Xn2788027880euoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1544708212;
        bh=jIxJPn6eBex0qkK4BE4E2hF66HdFbVMHCNxswfgF0H0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=HGbdegIOv6ZLYcCDmKpYvnoytnHbDMgjpQZyy07jg2oDbznaFSrcyQ3WCCfa/T7mm
         l36hPQ5veq7qhBYYYNYs42clXET7YcueqMLOlI36tKKsQmQDyur5t11PqiN63yddqM
         R6xvfY353C9wYgrx2NnnV6P1murRFRBh4EUFmT0A=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20181213133652eucas1p200c39e2cd5a1fcb9f32fee31d7b4cc31~v5_9PbbB80160201602eucas1p2h;
        Thu, 13 Dec 2018 13:36:52 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 6C.CC.04441.370621C5; Thu, 13
        Dec 2018 13:36:51 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20181213133651eucas1p11e936033c184c6f4046564e4cdea3b67~v5_8fxin-2509725097eucas1p1I;
        Thu, 13 Dec 2018 13:36:51 +0000 (GMT)
X-AuditID: cbfec7f2-5e3ff70000001159-bb-5c126073b60a
Received: from eusync3.samsung.com ( [203.254.199.213]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7E.A9.04128.370621C5; Thu, 13
        Dec 2018 13:36:51 +0000 (GMT)
Received: from mcdsrvbld02.digital.local ([106.116.37.23]) by
        eusync3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PJO00GDJGHA8I20@eusync3.samsung.com>;
        Thu, 13 Dec 2018 13:36:51 +0000 (GMT)
From:   Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To:     linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc:     Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] MAINTAINERS: Change s5p-jpeg maintainer information.
Date:   Thu, 13 Dec 2018 14:36:38 +0100
Message-id: <20181213133638.6079-1-andrzej.p@samsung.com>
X-Mailer: git-send-email 2.11.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWy7djP87rFCUIxBmvum1rMetnOYrFizRNG
        i40z1rNa3N66gcXibNMbdotNj6+xWvRs2MpqsfbIXXaLZZv+MFlMefuT3eLwm3ZWB26PnbPu
        sntsWtXJ5rF5Sb3H418v2Tz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr49TtuoIt7BWnJl9h
        a2BcxNbFyMkhIWAicXvmfHYQW0hgBaNE2yamLkYuIPszo8TMqbNZYYper1zNApFYxigx8fxa
        VginiUli8qFDLCBVbALGEnsPdjCC2CICrhJbt9xkBCliFljMLNH35C/YPmGgxLT7s8CKWARU
        JZ7t7QOyOTh4BSwlVj5XgdgmL7Gr7SLU5h42idkNqRC2i8Smy9PZIWxhiVfHt0DZMhKXJ3ez
        QNj1Epu+7IF6bQqjxL253hC2tcTh4xAzmQX4JCZtm84MslZCgFeio00IosRDYkXbXFaQsJBA
        rMTV+UYTGCUWMDKsYhRPLS3OTU8tNsxLLdcrTswtLs1L10vOz93ECIzH0/+Of9rB+PVS0iFG
        AQ5GJR7eA7KCMUKsiWXFlbmHGCU4mJVEeB9HAYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzVjM8
        iBYSSE8sSc1OTS1ILYLJMnFwSjUwln828NTW3WHwSelYzJYnH79fU75S77ls5tTG0rSbT/8q
        32S/FSyc4BPG6eN+6FDsPi+Tc4G3+F5aGP8UrVx+oH3rozvpl6xrFRc8qVtdwHxS/9N+5Xm6
        Z8qMcq3nP5ysbDgr56TrrMhrj30PTVJZ8Ng/68+PL6U5N6/KfneKPl/iG/NdVLj+lxJLcUai
        oRZzUXEiANCbZqjDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Vd3iBKEYg7ZJYhazXrazWKxY84TR
        YuOM9awWt7duYLE42/SG3WLT42usFj0btrJarD1yl91i2aY/TBZT3v5ktzj8pp3Vgdtj56y7
        7B6bVnWyeWxeUu/x+NdLNo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKOHW7rmALe8WpyVfY
        GhgXsXUxcnJICJhIvF65mqWLkYtDSGAJo8TOrjagBAeQ08IkcYoPpIZNwFhi78EORhBbRMBV
        YuuWm4wg9cwCy5klfj2YwwKSEAZKTLs/C6yIRUBV4tnePkaQObwClhIrn6tA7JKX2NV2kXUC
        I9cCRoZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgWGz7djPLTsYu94FH2IU4GBU4uE9ICsY
        I8SaWFZcmXuIUYKDWUmE93EUUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjveYPKKCGB9MSS1OzU
        1ILUIpgsEwenVAPjQuuyKZ0v22XKz/H8MzCZtXFD7rEHJq7Sn1ha1QLareZo6bSvvbb9390T
        U0oFV06oEny7kPmh9MtAjwPvBJJevXtgt2pR9tN3r5bqbhC8v/T9uY4ctkX8qsYro10ldoru
        c6/3LhL//5nnZcSfUxZaYvGzJux67LlCQbr5vv90/l8TL777tl9/phJLcUaioRZzUXEiAOPZ
        NZ4XAgAA
X-CMS-MailID: 20181213133651eucas1p11e936033c184c6f4046564e4cdea3b67
X-Msg-Generator: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20181213133651eucas1p11e936033c184c6f4046564e4cdea3b67
References: <CGME20181213133651eucas1p11e936033c184c6f4046564e4cdea3b67@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

My @samusung.com address is going to cease existing soon, so change it to
an address which can actually be used to contact me.

Adding Sylwester Nawrocki, who still has access to a wide spectrum
of Exynos-based hardware.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8119141..9a9acd3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2048,8 +2048,9 @@ F:	drivers/media/platform/s5p-cec/
 F:	Documentation/devicetree/bindings/media/s5p-cec.txt
 
 ARM/SAMSUNG S5P SERIES JPEG CODEC SUPPORT
-M:	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+M:	Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
 M:	Jacek Anaszewski <jacek.anaszewski@gmail.com>
+M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-- 
2.7.4

