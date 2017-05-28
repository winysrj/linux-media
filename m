Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:43710 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750979AbdE1Joj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 05:44:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v4.12 3/3] cec: drop MEDIA_CEC_DEBUG
Date: Sun, 28 May 2017 11:44:26 +0200
Message-Id: <20170528094426.10089-4-hverkuil@xs4all.nl>
In-Reply-To: <20170528094426.10089-1-hverkuil@xs4all.nl>
References: <20170528094426.10089-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just depend on DEBUG_FS, no need to invent a new kernel config.
Especially since CEC can be enabled by drm without enabling
MEDIA_SUPPORT.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/Kconfig    | 6 ------
 drivers/media/cec/cec-adap.c | 2 +-
 drivers/media/cec/cec-core.c | 4 ++--
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
index 5d5091499ab1..43428cec3a01 100644
--- a/drivers/media/cec/Kconfig
+++ b/drivers/media/cec/Kconfig
@@ -4,9 +4,3 @@ config MEDIA_CEC_RC
 	depends on CEC_CORE=m || RC_CORE=y
 	---help---
 	  Pass on CEC remote control messages to the RC framework.
-
-config MEDIA_CEC_DEBUG
-	bool "HDMI CEC debugfs interface"
-	depends on CEC_CORE && DEBUG_FS
-	---help---
-	  Turns on the DebugFS interface for CEC devices.
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index f5fe01c9da8a..9dfc79800c71 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1864,7 +1864,7 @@ void cec_monitor_all_cnt_dec(struct cec_adapter *adap)
 		WARN_ON(call_op(adap, adap_monitor_all_enable, 0));
 }
 
-#ifdef CONFIG_MEDIA_CEC_DEBUG
+#ifdef CONFIG_DEBUG_FS
 /*
  * Log the current state of the CEC adapter.
  * Very useful for debugging.
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index feeb4c5afa69..2f87748ba4fc 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -323,7 +323,7 @@ int cec_register_adapter(struct cec_adapter *adap,
 	}
 
 	dev_set_drvdata(&adap->devnode.dev, adap);
-#ifdef CONFIG_MEDIA_CEC_DEBUG
+#ifdef CONFIG_DEBUG_FS
 	if (!top_cec_dir)
 		return 0;
 
@@ -395,7 +395,7 @@ static int __init cec_devnode_init(void)
 		return ret;
 	}
 
-#ifdef CONFIG_MEDIA_CEC_DEBUG
+#ifdef CONFIG_DEBUG_FS
 	top_cec_dir = debugfs_create_dir("cec", NULL);
 	if (IS_ERR_OR_NULL(top_cec_dir)) {
 		pr_warn("cec: Failed to create debugfs cec dir\n");
-- 
2.11.0
