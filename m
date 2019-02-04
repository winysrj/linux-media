Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB02C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13DAD214DA
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Er8bjbmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfBDMBO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:01:14 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39045 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729312AbfBDMBM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:01:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id y8so13093581wmi.4
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aThCrwrFteI0wzip9ugvjHUOdfJZCazMyUiwd8Wh9g0=;
        b=Er8bjbmOj/UAT0srJj1qugps9UxFI6DTguRWAk2mbXu5lYp5LsLmmcLcJ/H/b3eA13
         ap4P2sREJ3SH89nP/iIRiSGUIiD670jFK5fV92tWZb85sot7E0NgTHHAUzK8+0wvI25R
         j1TEsTkzEV5bOcYoPtA8CYgKDFKQtSdNzVJzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aThCrwrFteI0wzip9ugvjHUOdfJZCazMyUiwd8Wh9g0=;
        b=BFnHrEt46hcUKfmMZK+di11nekKLqgF99bGLzNpAa+7VQulpCK370h17c26wNWYzVR
         MYTcMDNc5AhBnukhNgG1qoTBF37FwdUqGqPLnG/gUVRRqi68SrZf/g86S+on0jCrGWCQ
         ElbjRrV4Jj7pNXvgZTYYRgvMQGKbwqS4xDT42vcmo5DZZwRRcWPeZ8IKI5r3khM9HMQh
         ESYA//1PsXCB3zSB7RavV2NDGDKrI6rsCWB9u4LYVpebpKlWDKF3NiaP1wFq6I85z8zi
         wk+up/AGRsB7TCr8cNx7xa2bAuus5WDZU/u5SMlaAiHT4EhVaqDu0faf+vFSC40+T23F
         ykFw==
X-Gm-Message-State: AHQUAuaZJw5gUYcdUrE8sZ6SkrVkuDZZOUpascmFUA0V8EfkdfcmrYHq
        5aWOnJVuxxUJyWfaobT1sZ7ARQ==
X-Google-Smtp-Source: AHgI3IbVhGg6CLJobkChctUhpcXJ9OZhpUnV1yOtTOeDf8adG0MiBvAlMqceXffmIwT5+nL3qHjtNw==
X-Received: by 2002:a1c:570d:: with SMTP id l13mr13443134wmb.139.1549281670933;
        Mon, 04 Feb 2019 04:01:10 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.01.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:01:10 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 10/13] media: imx7.rst: add documentation for i.MX7 media driver
Date:   Mon,  4 Feb 2019 12:00:36 +0000
Message-Id: <20190204120039.1198-11-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add rst document to describe the i.MX7 media driver and also a working
example from the Warp7 board usage with a OV2680 sensor.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/v4l-drivers/imx7.rst  | 157 ++++++++++++++++++++++
 Documentation/media/v4l-drivers/index.rst |   1 +
 2 files changed, 158 insertions(+)
 create mode 100644 Documentation/media/v4l-drivers/imx7.rst

diff --git a/Documentation/media/v4l-drivers/imx7.rst b/Documentation/media/v4l-drivers/imx7.rst
new file mode 100644
index 000000000000..cd1195d391c5
--- /dev/null
+++ b/Documentation/media/v4l-drivers/imx7.rst
@@ -0,0 +1,157 @@
+i.MX7 Video Capture Driver
+==========================
+
+Introduction
+------------
+
+The i.MX7 contrary to the i.MX5/6 family does not contain an Image Processing
+Unit (IPU); because of that the capabilities to perform operations or
+manipulation of the capture frames are less feature rich.
+
+For image capture the i.MX7 has three units:
+- CMOS Sensor Interface (CSI)
+- Video Multiplexer
+- MIPI CSI-2 Receiver
+
+::
+                                           |\
+   MIPI Camera Input ---> MIPI CSI-2 --- > | \
+                                           |  \
+                                           | M |
+                                           | U | ------>  CSI ---> Capture
+                                           | X |
+                                           |  /
+   Parallel Camera Input ----------------> | /
+                                           |/
+
+For additional information, please refer to the latest versions of the i.MX7
+reference manual [#f1]_.
+
+Entities
+--------
+
+imx7-mipi-csi2
+--------------
+
+This is the MIPI CSI-2 receiver entity. It has one sink pad to receive the pixel
+data from MIPI CSI-2 camera sensor. It has one source pad, corresponding to the
+virtual channel 0. This module is compliant to previous version of Samsung
+D-phy, and supports two D-PHY Rx Data lanes.
+
+csi_mux
+-------
+
+This is the video multiplexer. It has two sink pads to select from either camera
+sensor with a parallel interface or from MIPI CSI-2 virtual channel 0.  It has
+a single source pad that routes to the CSI.
+
+csi
+---
+
+The CSI enables the chip to connect directly to external CMOS image sensor. CSI
+can interface directly with Parallel and MIPI CSI-2 buses. It has 256 x 64 FIFO
+to store received image pixel data and embedded DMA controllers to transfer data
+from the FIFO through AHB bus.
+
+This entity has one sink pad that receives from the csi_mux entity and a single
+source pad that routes video frames directly to memory buffers. This pad is
+routed to a capture device node.
+
+Usage Notes
+-----------
+
+To aid in configuration and for backward compatibility with V4L2 applications
+that access controls only from video device nodes, the capture device interfaces
+inherit controls from the active entities in the current pipeline, so controls
+can be accessed either directly from the subdev or from the active capture
+device interface. For example, the sensor controls are available either from the
+sensor subdevs or from the active capture device.
+
+Warp7 with OV2680
+-----------------
+
+On this platform an OV2680 MIPI CSI-2 module is connected to the internal MIPI
+CSI-2 receiver. The following example configures a video capture pipeline with
+an output of 800x600, and BGGR 10 bit bayer format:
+
+.. code-block:: none
+   # Setup links
+   media-ctl -l "'ov2680 1-0036':0 -> 'imx7-mipi-csis.0':0[1]"
+   media-ctl -l "'imx7-mipi-csis.0':1 -> 'csi_mux':1[1]"
+   media-ctl -l "'csi_mux':2 -> 'csi':0[1]"
+   media-ctl -l "'csi':1 -> 'csi capture':0[1]"
+
+   # Configure pads for pipeline
+   media-ctl -V "'ov2680 1-0036':0 [fmt:SBGGR10_1X10/800x600 field:none]"
+   media-ctl -V "'csi_mux':1 [fmt:SBGGR10_1X10/800x600 field:none]"
+   media-ctl -V "'csi_mux':2 [fmt:SBGGR10_1X10/800x600 field:none]"
+   media-ctl -V "'imx7-mipi-csis.0':0 [fmt:SBGGR10_1X10/800x600 field:none]"
+   media-ctl -V "'csi':0 [fmt:SBGGR10_1X10/800x600 field:none]"
+
+After this streaming can start. The v4l2-ctl tool can be used to select any of
+the resolutions supported by the sensor.
+
+.. code-block:: none
+    root@imx7s-warp:~# media-ctl -p
+    Media controller API version 4.17.0
+
+    Media device information
+    ------------------------
+    driver          imx-media
+    model           imx-media
+    serial
+    bus info
+    hw revision     0x0
+    driver version  4.17.0
+
+    Device topology
+    - entity 1: csi (2 pads, 2 links)
+		type V4L2 subdev subtype Unknown flags 0
+		device node name /dev/v4l-subdev0
+	    pad0: Sink
+		    [fmt:SBGGR10_1X10/800x600 field:none]
+		    <- "csi_mux":2 [ENABLED]
+	    pad1: Source
+		    [fmt:SBGGR10_1X10/800x600 field:none]
+		    -> "csi capture":0 [ENABLED]
+
+    - entity 4: csi capture (1 pad, 1 link)
+		type Node subtype V4L flags 0
+		device node name /dev/video0
+	    pad0: Sink
+		    <- "csi":1 [ENABLED]
+
+    - entity 10: csi_mux (3 pads, 2 links)
+		type V4L2 subdev subtype Unknown flags 0
+		device node name /dev/v4l-subdev1
+	    pad0: Sink
+		    [fmt:unknown/0x0]
+	    pad1: Sink
+		    [fmt:unknown/800x600 field:none]
+		    <- "imx7-mipi-csis.0":1 [ENABLED]
+	    pad2: Source
+		    [fmt:unknown/800x600 field:none]
+		    -> "csi":0 [ENABLED]
+
+    - entity 14: imx7-mipi-csis.0 (2 pads, 2 links)
+		type V4L2 subdev subtype Unknown flags 0
+		device node name /dev/v4l-subdev2
+	    pad0: Sink
+		    [fmt:SBGGR10_1X10/800x600 field:none]
+		    <- "ov2680 1-0036":0 [ENABLED]
+	    pad1: Source
+		    [fmt:SBGGR10_1X10/800x600 field:none]
+		    -> "csi_mux":1 [ENABLED]
+
+    - entity 17: ov2680 1-0036 (1 pad, 1 link)
+		type V4L2 subdev subtype Sensor flags 0
+		device node name /dev/v4l-subdev3
+	    pad0: Source
+		    [fmt:SBGGR10_1X10/800x600 field:none]
+		    -> "imx7-mipi-csis.0":0 [ENABLED]
+
+
+References
+----------
+
+.. [#f1] https://www.nxp.com/docs/en/reference-manual/IMX7SRM.pdf
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index f28570ec9e42..dfd4b205937c 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -44,6 +44,7 @@ For more details see the file COPYING in the source distribution of Linux.
 	davinci-vpbe
 	fimc
 	imx
+	imx7
 	ipu3
 	ivtv
 	max2175
-- 
2.20.1

