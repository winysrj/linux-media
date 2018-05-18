Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33544 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbeERJ2x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 05:28:53 -0400
Received: by mail-wr0-f193.google.com with SMTP id a15-v6so1181826wrm.0
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 02:28:53 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        linux-clk@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v5 12/12] media: staging/imx: add i.MX7 entries to TODO file
Date: Fri, 18 May 2018 10:28:06 +0100
Message-Id: <20180518092806.3829-13-rui.silva@linaro.org>
In-Reply-To: <20180518092806.3829-1-rui.silva@linaro.org>
References: <20180518092806.3829-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add some i.MX7 related entries to TODO file.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/TODO | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
index aeeb15494a49..6f29b5ca5324 100644
--- a/drivers/staging/media/imx/TODO
+++ b/drivers/staging/media/imx/TODO
@@ -45,3 +45,12 @@
 
      Which means a port must not contain mixed-use endpoints, they
      must all refer to media links between V4L2 subdevices.
+
+- i.MX7: all of the above, since it uses the imx media core
+
+- i.MX7: use Frame Interval Monitor
+
+- i.MX7: runtime testing with parallel sensor, links setup and streaming
+
+- i.MX7: runtime testing with different formats, for the time only 10-bit bayer
+  is tested
-- 
2.17.0
