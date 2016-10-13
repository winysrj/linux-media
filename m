Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:49853 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932284AbcJMORG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 10:17:06 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] s5p_cec: Mark runtime suspend/resume as __maybe_unused
Date: Thu, 13 Oct 2016 16:16:30 +0200
Message-Id: <1476368190-31042-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_PM_SLEEP=n:

    drivers/staging/media/s5p-cec/s5p_cec.c:235: warning: ‘s5p_cec_runtime_suspend’ defined but not used
    drivers/staging/media/s5p-cec/s5p_cec.c:243: warning: ‘s5p_cec_runtime_resume’ defined but not used

Mark these functions as__maybe_unused to fix this without introducing
an #ifdef.

Fixes: 57b978ada073106d ("[media] s5p-cec: fix system and runtime PM integration")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
The above commit didn't take into account Arnd's previous fix...

 drivers/staging/media/s5p-cec/s5p_cec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index 1780a08b73c96193..58d7562311360b7f 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -231,7 +231,7 @@ static int s5p_cec_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int s5p_cec_runtime_suspend(struct device *dev)
+static int __maybe_unused s5p_cec_runtime_suspend(struct device *dev)
 {
 	struct s5p_cec_dev *cec = dev_get_drvdata(dev);
 
@@ -239,7 +239,7 @@ static int s5p_cec_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int s5p_cec_runtime_resume(struct device *dev)
+static int __maybe_unused s5p_cec_runtime_resume(struct device *dev)
 {
 	struct s5p_cec_dev *cec = dev_get_drvdata(dev);
 	int ret;
-- 
1.9.1

