Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:46197 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbdLBF7q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 00:59:46 -0500
Received: by mail-pl0-f66.google.com with SMTP id i6so7461020plt.13
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 21:59:46 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: hans.verkuil@cisco.com, mchehab@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org
Cc: trivial@kernel.org, Daniel Axtens <dja@axtens.net>
Subject: [PATCH] media: tegra-cec: add MODULE_LICENSE()
Date: Sat,  2 Dec 2017 16:59:18 +1100
Message-Id: <20171202055918.15989-1-dja@axtens.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the following warning in an allmodconfig build:
WARNING: modpost: missing MODULE_LICENSE() in drivers/media/platform/tegra-cec/tegra_cec.o

The license matches the header.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index 807c94c70049..680884a69f9f 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -493,3 +493,5 @@ static struct platform_driver tegra_cec_driver = {
 };
 
 module_platform_driver(tegra_cec_driver);
+
+MODULE_LICENSE("GPL v2");
-- 
2.11.0
