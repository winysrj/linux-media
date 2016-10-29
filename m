Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35684 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbcJ2QSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Oct 2016 12:18:06 -0400
Received: by mail-pf0-f196.google.com with SMTP id s8so4247962pfj.2
        for <linux-media@vger.kernel.org>; Sat, 29 Oct 2016 09:18:06 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kamil Debski <kamil@wypas.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH -next] [media] s5p-cec: remove unused including <linux/version.h>
Date: Sat, 29 Oct 2016 16:17:55 +0000
Message-Id: <1477757875-28793-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/staging/media/s5p-cec/s5p_cec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index 1780a08..aef962b 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 #include <media/cec.h>

