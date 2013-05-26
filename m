Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f180.google.com ([209.85.213.180]:53151 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3EZJS5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 05:18:57 -0400
Received: by mail-ye0-f180.google.com with SMTP id r11so601407yen.39
        for <linux-media@vger.kernel.org>; Sun, 26 May 2013 02:18:56 -0700 (PDT)
From: Diego Viola <diego.viola@gmail.com>
To: linux-media@vger.kernel.org
Cc: Diego Viola <diego.viola@gmail.com>
Subject: [PATCH] Fix spelling of Qt in .desktop file (typo)
Date: Sun, 26 May 2013 04:15:51 -0400
Message-Id: <1369556151-4614-1-git-send-email-diego.viola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Proper spelling of Qt is Qt, not QT.  "QT" is often confused with
QuickTime, here is a minor patch to fix this issue in the .desktop file.

Signed-off-by: Diego Viola <diego.viola@gmail.com>
---
 utils/qv4l2/qv4l2.desktop | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/qv4l2/qv4l2.desktop b/utils/qv4l2/qv4l2.desktop
index 00f3e33..69413e1 100644
--- a/utils/qv4l2/qv4l2.desktop
+++ b/utils/qv4l2/qv4l2.desktop
@@ -1,5 +1,5 @@
 [Desktop Entry]
-Name=QT V4L2 test Utility
+Name=Qt V4L2 test Utility
 Name[pt]=Utilitário de teste V4L2
 Comment=Allow testing Video4Linux devices
 Comment[pt]=Permite testar dispositivos Video4Linux
-- 
1.8.2.3

