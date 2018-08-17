Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:55409 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbeHQM5T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 08:57:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Todor Tomov <todor.tomov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hansverk@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: camss: mark PM functions as __maybe_unused
Date: Fri, 17 Aug 2018 11:53:42 +0200
Message-Id: <20180817095425.2630974-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The empty suspend/resume functions cause a build warning
when they are unused:

drivers/media/platform/qcom/camss/camss.c:1001:12: error: 'camss_runtime_resume' defined but not used [-Werror=unused-function]
drivers/media/platform/qcom/camss/camss.c:996:12: error: 'camss_runtime_suspend' defined but not used [-Werror=unused-function]

Mark them as __maybe_unused so the compiler can silently drop them.

Fixes: 02afa816dbbf ("media: camss: Add basic runtime PM support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/qcom/camss/camss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index dcc0c30ef1b1..9f19d5f5966b 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -993,12 +993,12 @@ static const struct of_device_id camss_dt_match[] = {
 
 MODULE_DEVICE_TABLE(of, camss_dt_match);
 
-static int camss_runtime_suspend(struct device *dev)
+static int __maybe_unused camss_runtime_suspend(struct device *dev)
 {
 	return 0;
 }
 
-static int camss_runtime_resume(struct device *dev)
+static int __maybe_unused camss_runtime_resume(struct device *dev)
 {
 	return 0;
 }
-- 
2.18.0
