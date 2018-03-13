Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54429 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751613AbeCMS3o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:29:44 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] imx.rst: fix typo
Message-ID: <0b24f8eb-1d07-9fd9-8168-7986b40aadb2@xs4all.nl>
Date: Tue, 13 Mar 2018 11:29:36 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Multpiple -> Multiple

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
index 18e3141304bb..65d3d15eb159 100644
--- a/Documentation/media/v4l-drivers/imx.rst
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -109,7 +109,7 @@ imx6-mipi-csi2
 This is the MIPI CSI-2 receiver entity. It has one sink pad to receive
 the MIPI CSI-2 stream (usually from a MIPI CSI-2 camera sensor). It has
 four source pads, corresponding to the four MIPI CSI-2 demuxed virtual
-channel outputs. Multpiple source pads can be enabled to independently
+channel outputs. Multiple source pads can be enabled to independently
 stream from multiple virtual channels.

 This entity actually consists of two sub-blocks. One is the MIPI CSI-2
