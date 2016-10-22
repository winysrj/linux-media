Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35011 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbcJVH0m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 03:26:42 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, mchehab@s-opensource.com,
        corbet@lwn.net, linux-doc@vger.kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [linux-next] v4l: doc: Fix typo in vidioc-g-tuner.rst
Date: Sat, 22 Oct 2016 16:26:37 +0900
Message-Id: <20161022072637.14840-1-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix spelling typos found in vidioc-g-tuner.xml.
This xml file was created from vidioc-g-tuner.rst,
I have to fix typos in vidioc-g-tuner.rst.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index e8aa8cd7065f..57c79fa43866 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -201,10 +201,10 @@ To change the radio frequency the
     * - ``V4L2_TUNER_SDR``
       - 4
       - Tuner controls the A/D and/or D/A block of a
-	Sofware Digital Radio (SDR)
+	Software Digital Radio (SDR)
     * - ``V4L2_TUNER_RF``
       - 5
-      - Tuner controls the RF part of a Sofware Digital Radio (SDR)
+      - Tuner controls the RF part of a Software Digital Radio (SDR)
 
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-- 
2.10.1.502.g6598894

