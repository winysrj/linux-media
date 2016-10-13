Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:63327 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbcJMOk3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 10:40:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] s5p-cec: mark PM functions as __maybe_unused again
Date: Thu, 13 Oct 2016 16:39:04 +0200
Message-Id: <20161013143939.3977105-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A bugfix removed the two callers of s5p_cec_runtime_suspend
and s5p_cec_runtime_resume, leading to the return of a harmless
warning that I had previously fixed in commit aee8937089b1
("[media] s5p_cec: mark suspend/resume as __maybe_unused"):

staging/media/s5p-cec/s5p_cec.c:234:12: error: ‘s5p_cec_runtime_suspend’ defined but not used [-Werror=unused-function]
staging/media/s5p-cec/s5p_cec.c:242:12: error: ‘s5p_cec_runtime_resume’ defined but not used [-Werror=unused-function]

This adds the __maybe_unused annotations to the function that
were not removed and that are now unused when CONFIG_PM
is disabled.

Fixes: 57b978ada073 ("[media] s5p-cec: fix system and runtime PM integration")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/s5p-cec/s5p_cec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index 1780a08b73c9..58d756231136 100644
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
2.9.0

