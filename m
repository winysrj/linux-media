Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80295C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC1AD20870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jLGR6Mzo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC1AD20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbeLMNbi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:31:38 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56340 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbeLMNbh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:31:37 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20181213133136euoutp015f40af4c3e2d74a2913490c5b2255444~v56W7869C1030810308euoutp01J;
        Thu, 13 Dec 2018 13:31:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20181213133136euoutp015f40af4c3e2d74a2913490c5b2255444~v56W7869C1030810308euoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1544707896;
        bh=ZtCcY8UOey8IpByRC06DpyLtrHRmuOHUxmvO3Z/iMZU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=jLGR6Mzo6thcWlAgpQrnWUcfGbfnYQvwYcWtErxUoCx9IRPpRKjICZItLRBNLvYMS
         WOV2YZqgD5O6wwuYL+berLDV8haBSPUyXVcf2tcxQWzP6BbKbmAP0MU7EjMF+yMq+h
         8eAOicCopnHXq1w+pxkopkog2Ecg40wMBvThuB6s=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20181213133135eucas1p28b3ffb4c5db9b4e0f41e783f80756e76~v56WB2H5C2481624816eucas1p2d;
        Thu, 13 Dec 2018 13:31:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 9C.AC.04294.63F521C5; Thu, 13
        Dec 2018 13:31:34 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20181213133134eucas1p2d8a80fb77e65cf2979ba936c36c45eb9~v56VZmG9u2481424814eucas1p2O;
        Thu, 13 Dec 2018 13:31:34 +0000 (GMT)
X-AuditID: cbfec7f4-835ff700000010c6-c6-5c125f36e77e
Received: from eusync1.samsung.com ( [203.254.199.211]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 94.F8.04128.63F521C5; Thu, 13
        Dec 2018 13:31:34 +0000 (GMT)
Received: from mcdsrvbld02.digital.local ([106.116.37.23]) by
        eusync1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PJO00G9TG836Q50@eusync1.samsung.com>;
        Thu, 13 Dec 2018 13:31:34 +0000 (GMT)
From:   Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To:     linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc:     Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: [PATCH] media: Change Andrzej Pietrasiewicz's e-mail address
Date:   Thu, 13 Dec 2018 14:31:07 +0100
Message-id: <20181213133107.5385-1-andrzej.p@samsung.com>
X-Mailer: git-send-email 2.11.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7djPc7pm8UIxBgfX2VjMetnOYrFizRNG
        i40z1rNa3N66gcXibNMbdotNj6+xWvRs2MpqsfbIXXaLZZv+MFlMefuT3YHLY+esu+wem1Z1
        snlsXlLv8fjXSzaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyvj3QaZgjmbFhhMPWRoY25S7
        GDk5JARMJI6unsbcxcjFISSwglGi4f90JgjnM6PErJ6pjDBVU+6+g6paxihx6MVdKKeJSaLn
        yH5mkCo2AWOJvQc7wDpEBFwltm65CWYzC3xjkpizlQPEFgaKd/1YxAZiswioSnx9/I8dxOYV
        sJTYd3UqE8Q2eYldbRdZQRZICHSwSazqmg51hovEoYctbBC2sMSr41vYIWwZicuTu1kg7HqJ
        TV/2QNVMYZS4N9cbwraWOHwcZCjIQXwSk7ZNBzqaAyjOK9HRJgRR4iHxvbcHbJWQQKzEx6N7
        2CcwSixgZFjFKJ5aWpybnlpslJdarlecmFtcmpeul5yfu4kRGIun/x3/soNx15+kQ4wCHIxK
        PLwHZAVjhFgTy4orcw8xSnAwK4nwPo4CCvGmJFZWpRblxxeV5qQWH2KU5mBREuetZngQLSSQ
        nliSmp2aWpBaBJNl4uCUamCsPP/oc/Xyhq2V6Qes1Dx2s7v6b99z/N/mMxoM5nVGxQopfE6O
        LzTN/yTaerlrBjE2dM64yPy7fLKg59SSGJVt12vfPLJOP3zwcSTn5XnfL8v4OJ/X3CL3/PaD
        u9PnfX3VXBzmdUZQfsZ6F/+vJ+VedGsJx124fnC6YFjB5fW1M+vudfduO+etxFKckWioxVxU
        nAgArdXTXMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e/4ZV2zeKEYg6kT+CxmvWxnsVix5gmj
        xcYZ61ktbm/dwGJxtukNu8Wmx9dYLXo2bGW1WHvkLrvFsk1/mCymvP3J7sDlsXPWXXaPTas6
        2Tw2L6n3ePzrJZtH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZfz7IFMwR7Niw4mHLA2Mbcpd
        jJwcEgImElPuvmPuYuTiEBJYwijRf+EbE4TTwiQx/dEHVpAqNgFjib0HOxhBbBEBV4mtW24y
        ghQxC/xgkliwohesSBgo0fVjERuIzSKgKvH18T92EJtXwFJi39WpTBDr5CV2tV1kncDItYCR
        YRWjSGppcW56brGRXnFibnFpXrpecn7uJkZgyGw79nPLDsaud8GHGAU4GJV4eA/ICsYIsSaW
        FVfmHmKU4GBWEuF9HAUU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznveoDJKSCA9sSQ1OzW1ILUI
        JsvEwSnVwHi6yWbKbz29Da0TOp243q/QUHvNwV0sn8zsLffffc/FzVmc3+e1Ou2auHXljaon
        bBc516sWtl0vi5m36dc3513zrI3nnHb6eFY1cI7BJ2WpjtfqHfFeBab6XUKWjS/m5Re8dAru
        uj3j24u6yKuWqeeLfn574+osOV+/ZMevBc37ijXuJF+ZskmJpTgj0VCLuag4EQACGlDLFQIA
        AA==
X-CMS-MailID: 20181213133134eucas1p2d8a80fb77e65cf2979ba936c36c45eb9
X-Msg-Generator: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20181213133134eucas1p2d8a80fb77e65cf2979ba936c36c45eb9
References: <CGME20181213133134eucas1p2d8a80fb77e65cf2979ba936c36c45eb9@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

My @samusung.com address is going to cease existing soon, so change it to
an address which can actually be used to contact me.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c       | 4 ++--
 drivers/media/platform/s5p-jpeg/jpeg-core.h       | 2 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c     | 2 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h     | 2 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h       | 2 +-
 include/media/videobuf2-dma-sg.h                  | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 015e737..f02876d 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2010 Samsung Electronics
  *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 3f9000b..580d6d0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
  * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -3220,7 +3220,7 @@ static struct platform_driver s5p_jpeg_driver = {
 
 module_platform_driver(s5p_jpeg_driver);
 
-MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
+MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>");
 MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
 MODULE_DESCRIPTION("Samsung JPEG codec driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index a46465e..90fda4b 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -3,7 +3,7 @@
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
index b5f20e7..59c6263 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
index f208fa3..bfe746f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
@@ -3,7 +3,7 @@
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
index df790b1..574f0e8 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-regs.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
@@ -5,7 +5,7 @@
  * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
  * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 52afa0e..f28fcb0 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2010 Samsung Electronics
  *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ * Author: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
2.7.4

