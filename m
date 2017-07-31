Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34529 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdGaPda (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 11:33:30 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v4 2/6] [media] extended-controls.rst: add PorterDuff mode control
Date: Mon, 31 Jul 2017 23:32:58 +0800
Message-Id: <1501515182-26705-3-git-send-email-jacob-chen@iotwrt.com>
In-Reply-To: <1501515182-26705-1-git-send-email-jacob-chen@iotwrt.com>
References: <1501515182-26705-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PorterDuff mode control are used to determine
how two images are combined.

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index abb1057..f9c93bb 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3021,6 +3021,10 @@ Image Process Control IDs
     The video deinterlacing mode (such as Bob, Weave, ...). The menu items are
     driver specific and are documented in :ref:`v4l-drivers`.
 
+``V4L2_CID_PORTER_DUFF_MODE (menu)``
+    The PorterDuff blend modes. PorterDuff is way to overlay, combine and
+    trim images as if they were pieces of cardboard, device could use to
+    determine how two images are combined.
 
 .. _dv-controls:
 
-- 
2.7.4
