Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34889 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756860AbeDZR1h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:37 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/7] Disable additional drivers requiring gpio/consumer.h
Date: Thu, 26 Apr 2018 12:19:17 -0500
Message-Id: <1524763162-4865-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One driver migrated to 3.13 from 3.5

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index ae0731d..2306830 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -107,6 +107,15 @@ VIDEO_VIM2M
 [3.13.0]
 # needs gpio/consumer.h
 RADIO_SI4713
+VIDEO_OV2685
+VIDEO_OV5695
+VIDEO_OV9650
+VIDEO_MT9T112
+SOC_CAMERA_MT9T112
+VIDEO_OV772X
+SOC_CAMERA_OV772X
+VIDEO_TW9910
+SOC_CAMERA_TW9910
 
 [3.12.0]
 # BIN_ATTR_RW was changed
@@ -221,7 +230,6 @@ SOC_CAMERA
 SOC_CAMERA_MT9V022
 SOC_CAMERA_MT9M001
 SOC_CAMERA_MT9T031
-SOC_CAMERA_OV772X
 SOC_CAMERA_PLATFORM
 # Needs of_match_ptr
 VIDEO_THS8200
-- 
2.7.4
