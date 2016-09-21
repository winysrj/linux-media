Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36849 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757579AbcIUPNc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 11:13:32 -0400
Received: by mail-pf0-f193.google.com with SMTP id n24so2507323pfb.3
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 08:13:06 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] cx88: fix error return code in cx8802_dvb_probe()
Date: Wed, 21 Sep 2016 15:12:58 +0000
Message-Id: <1474470778-8469-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENODEV from the error handling case
instead of 0(err maybe overwrited to 0 in the for loop), as
done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/pci/cx88/cx88-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index ac2392d..d76a175 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1779,6 +1779,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 		if (fe == NULL) {
 			printk(KERN_ERR "%s() failed to get frontend(%d)\n",
 					__func__, i);
+			err = -ENODEV;
 			goto fail_probe;
 		}
 		q = &fe->dvb.dvbq;

