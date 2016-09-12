Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:49348 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932628AbcILPdy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 11:33:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] atmel-isc: mark PM functions as __maybe_unused
Date: Mon, 12 Sep 2016 17:32:58 +0200
Message-Id: <20160912153322.3098750-2-arnd@arndb.de>
In-Reply-To: <20160912153322.3098750-1-arnd@arndb.de>
References: <20160912153322.3098750-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added atmel-isc driver uses SET_RUNTIME_PM_OPS() to
refer to its suspend/resume functions, causing a warning when
CONFIG_PM is not set:

media/platform/atmel/atmel-isc.c:1477:12: error: 'isc_runtime_resume' defined but not used [-Werror=unused-function]
media/platform/atmel/atmel-isc.c:1467:12: error: 'isc_runtime_suspend' defined but not used [-Werror=unused-function]

This adds __maybe_unused annotations to avoid the warning without
adding an error-prone #ifdef around it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/atmel/atmel-isc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index db6773de92f0..a9ab7ae89f04 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1464,7 +1464,7 @@ static int atmel_isc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int isc_runtime_suspend(struct device *dev)
+static int __maybe_unused isc_runtime_suspend(struct device *dev)
 {
 	struct isc_device *isc = dev_get_drvdata(dev);
 
@@ -1474,7 +1474,7 @@ static int isc_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int isc_runtime_resume(struct device *dev)
+static int __maybe_unused isc_runtime_resume(struct device *dev)
 {
 	struct isc_device *isc = dev_get_drvdata(dev);
 	int ret;
-- 
2.9.0

