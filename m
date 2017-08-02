Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37112 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdHBDUP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 23:20:15 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v5 2/6] extended-controls.rst: add PorterDuff mode control
Date: Wed,  2 Aug 2017 11:19:43 +0800
Message-Id: <1501643987-27847-3-git-send-email-jacob-chen@iotwrt.com>
In-Reply-To: <1501643987-27847-1-git-send-email-jacob-chen@iotwrt.com>
References: <1501643987-27847-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PorterDuff mode control are used to determine
how two images are combined.

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index abb1057..b713581 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3021,6 +3021,11 @@ Image Process Control IDs
     The video deinterlacing mode (such as Bob, Weave, ...). The menu items are
     driver specific and are documented in :ref:`v4l-drivers`.
 
+``V4L2_CID_PORTER_DUFF_MODE (menu)``
+    The PorterDuff blend modes. PorterDuff is a method to overlay, combine and
+    trim images as if they were pieces of cardboard. The device uses this to
+    determine how two images are combined. For more information see
+    `PorterDuff.Mode <https://developer.android.com/reference/android/graphics/PorterDuff.Mode.html>`__.
 
 .. _dv-controls:
 
-- 
2.7.4
