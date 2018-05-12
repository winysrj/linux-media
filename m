Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:45969 "EHLO
        homiemail-a124.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751033AbeELPbn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 11:31:43 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, jasmin@anw.at, hverkuil@xs4all.nl
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] kernel version limitation fixup
Date: Sat, 12 May 2018 10:31:34 -0500
Message-Id: <1526139094-14932-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes: 95ee4c285022 ("Disable additional drivers requiring gpio/consumer.h")

Duplicate entries in 3.13.0 removed, they exist in 3.17.0 and
cause build failure any earlier.

The four remaining drivers from the commit were moved to
3.17.0 after determining they too require GPIOD_OUT_LOW/HIGH.

Reported-by: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index ecd2ea4..167d0d3 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -93,6 +93,10 @@ VIDEO_OV9650
 VIDEO_OV2685
 VIDEO_TW9910
 SOC_CAMERA_TW9910
+VIDEO_MT9T112
+SOC_CAMERA_MT9T112
+VIDEO_OV772X
+SOC_CAMERA_OV772X
 # needs component_match_add
 VIDEO_VIMC
 
@@ -111,15 +115,6 @@ VIDEO_VIM2M
 [3.13.0]
 # needs gpio/consumer.h
 RADIO_SI4713
-VIDEO_OV2685
-VIDEO_OV5695
-VIDEO_OV9650
-VIDEO_MT9T112
-SOC_CAMERA_MT9T112
-VIDEO_OV772X
-SOC_CAMERA_OV772X
-VIDEO_TW9910
-SOC_CAMERA_TW9910
 
 [3.12.0]
 # BIN_ATTR_RW was changed
-- 
2.7.4
