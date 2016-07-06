Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35934 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbcGFXHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:31 -0400
Received: by mail-pf0-f196.google.com with SMTP id i123so95271pfg.3
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:31 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 09/28] gpu: ipu-v3: Add ipu_ic_set_src()
Date: Wed,  6 Jul 2016 16:06:39 -0700
Message-Id: <1467846418-12913-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_ic_set_src() which is just aa wrapper around
ipu_set_ic_src_mux().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c | 10 ++++++++++
 include/video/imx-ipu-v3.h  |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 1dcb96c..f306a9c 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -629,6 +629,16 @@ unlock:
 }
 EXPORT_SYMBOL_GPL(ipu_ic_task_idma_init);
 
+int ipu_ic_set_src(struct ipu_ic *ic, int csi_id, bool vdi)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+
+	ipu_set_ic_src_mux(priv->ipu, csi_id, vdi);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_ic_set_src);
+
 int ipu_ic_enable(struct ipu_ic *ic)
 {
 	struct ipu_ic_priv *priv = ic->priv;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 57b487d..8f77ddb 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -334,6 +334,7 @@ void ipu_ic_task_disable(struct ipu_ic *ic);
 int ipu_ic_task_idma_init(struct ipu_ic *ic, struct ipuv3_channel *channel,
 			  u32 width, u32 height, int burst_size,
 			  enum ipu_rotate_mode rot);
+int ipu_ic_set_src(struct ipu_ic *ic, int csi_id, bool vdi);
 int ipu_ic_enable(struct ipu_ic *ic);
 int ipu_ic_disable(struct ipu_ic *ic);
 struct ipu_ic *ipu_ic_get(struct ipu_soc *ipu, enum ipu_ic_task task);
-- 
1.9.1

