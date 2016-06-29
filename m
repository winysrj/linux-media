Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:50017 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbcF2OZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 10:25:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [media] s5p_cec: mark suspend/resume as __maybe_unused
Date: Wed, 29 Jun 2016 16:26:34 +0200
Message-Id: <20160629142749.4125434-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The suspend/resume functions in the s5p-cec driver are only
referenced when CONFIG_PM is enabled, so we get a warning
about unused functions otherwise:

drivers/staging/media/s5p-cec/s5p_cec.c:260:12: error: 's5p_cec_resume' defined but not used [-Werror=unused-function]
 static int s5p_cec_resume(struct device *dev)
            ^~~~~~~~~~~~~~
drivers/staging/media/s5p-cec/s5p_cec.c:253:12: error: 's5p_cec_suspend' defined but not used [-Werror=unused-function]
 static int s5p_cec_suspend(struct device *dev)

This marks them as __maybe_unused to avoid the warning without
having to introduce an extra #ifdef.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/s5p-cec/s5p_cec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index f90b7c4e48fe..78333273c4e5 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -250,14 +250,14 @@ static int s5p_cec_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static int s5p_cec_suspend(struct device *dev)
+static int __maybe_unused s5p_cec_suspend(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
 		return 0;
 	return s5p_cec_runtime_suspend(dev);
 }
 
-static int s5p_cec_resume(struct device *dev)
+static int __maybe_unused s5p_cec_resume(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
 		return 0;
-- 
2.9.0

