Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35591 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbcFNWvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:10 -0400
Received: by mail-pf0-f193.google.com with SMTP id t190so301639pfb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:10 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 08/38] gpu: ipu-v3: Add ipu_csi_set_src()
Date: Tue, 14 Jun 2016 15:49:04 -0700
Message-Id: <1465944574-15745-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_csi_set_src() which is just a wrapper around
ipu_set_csi_src_mux().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 8 ++++++++
 include/video/imx-ipu-v3.h   | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index 06631ac..336dc06 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -609,6 +609,14 @@ int ipu_csi_set_skip_smfc(struct ipu_csi *csi, u32 skip,
 }
 EXPORT_SYMBOL_GPL(ipu_csi_set_skip_smfc);
 
+int ipu_csi_set_src(struct ipu_csi *csi, u32 vc, bool select_mipi_csi2)
+{
+	ipu_set_csi_src_mux(csi->ipu, csi->id, select_mipi_csi2);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_set_src);
+
 int ipu_csi_set_dest(struct ipu_csi *csi, enum ipu_csi_dest csi_dest)
 {
 	unsigned long flags;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 2302fc5..57b487d 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -301,6 +301,7 @@ int ipu_csi_set_mipi_datatype(struct ipu_csi *csi, u32 vc,
 			      struct v4l2_mbus_framefmt *mbus_fmt);
 int ipu_csi_set_skip_smfc(struct ipu_csi *csi, u32 skip,
 			  u32 max_ratio, u32 id);
+int ipu_csi_set_src(struct ipu_csi *csi, u32 vc, bool select_mipi_csi2);
 int ipu_csi_set_dest(struct ipu_csi *csi, enum ipu_csi_dest csi_dest);
 int ipu_csi_enable(struct ipu_csi *csi);
 int ipu_csi_disable(struct ipu_csi *csi);
-- 
1.9.1

