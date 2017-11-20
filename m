Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36156 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752696AbdKTU46 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 15:56:58 -0500
From: Jesse Chan <jc@linux.com>
Cc: Jesse Chan <jc@linux.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: tegra-cec: add missing MODULE_DESCRIPTION/AUTHOR/LICENSE
Date: Mon, 20 Nov 2017 12:56:52 -0800
Message-Id: <20171120205652.86405-1-jc@linux.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change resolves a new compile-time warning
when built as a loadable module:

WARNING: modpost: missing MODULE_LICENSE() in drivers/media/platform/tegra-cec/tegra_cec.o
see include/linux/module.h for more information

This adds the license as "GPL v2", which matches the header of the file.

MODULE_DESCRIPTION and MODULE_AUTHOR are also added.

Signed-off-by: Jesse Chan <jc@linux.com>
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index 807c94c70049..92f93a880015 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -493,3 +493,8 @@ static struct platform_driver tegra_cec_driver = {
 };
 
 module_platform_driver(tegra_cec_driver);
+
+MODULE_DESCRIPTION("Tegra HDMI CEC driver");
+MODULE_AUTHOR("NVIDIA CORPORATION");
+MODULE_AUTHOR("Cisco Systems, Inc. and/or its affiliates");
+MODULE_LICENSE("GPL v2");
-- 
2.14.1
