Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34449 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753464AbeCQP2j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Mar 2018 11:28:39 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 5/5] media: staging: tegra-vde: Correct included header
Date: Sat, 17 Mar 2018 18:28:15 +0300
Message-Id: <7654606b88a5b6d74762ad9a4fe96266009dedac.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is Open Firmware driver, hence 'of_device.h' should be included
instead of 'platform_device.h'. Right now OF headers happen to be included
indirectly and this may break in the future, so let's correct the header.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 9e542c6288f1..90177a59b97c 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -16,7 +16,7 @@
 #include <linux/iopoll.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
+#include <linux/of_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
 #include <linux/slab.h>
-- 
2.16.1
