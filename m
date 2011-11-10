Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1KJXeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:34:50 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:34:50 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 01/25] added PCTV80e information to cardlist file
Date: Thu, 10 Nov 2011 17:31:21 -0600
Message-Id: <1320967905-7932-2-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 Documentation/video4linux/CARDLIST.em28xx |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index d8c8544..319a9b2 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -78,3 +78,4 @@
  78 -> PCTV nanoStick T2 290e                   (em28174)
  79 -> Terratec Cinergy H5                      (em2884)        [0ccd:0043,0ccd:10a2]
  80 -> PCTV DVB-S2 Stick (460e)                 (em28174)
+81 -> Pinnacle PCTV HD Mini                    (em2874)        [2304:023f]
-- 
1.7.5.4

