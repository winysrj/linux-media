Return-path: <mchehab@pedra>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:42976 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab1DDUTB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 16:19:01 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 5/5] tm6000: add CARDLIST
Date: Mon,  4 Apr 2011 22:18:44 +0200
Message-Id: <1301948324-27186-5-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

add CARDLIST


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/CARDLIST |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/tm6000/CARDLIST

diff --git a/drivers/staging/tm6000/CARDLIST b/drivers/staging/tm6000/CARDLIST
new file mode 100644
index 0000000..b5edce4
--- /dev/null
+++ b/drivers/staging/tm6000/CARDLIST
@@ -0,0 +1,16 @@
+  1 -> Generic tm5600 board                   (tm5600)          [6000:0001]
+  2 -> Generic tm6000 board                   (tm6000)          [6000:0001]
+  3 -> Generic tm6010 board                   (tm6010)          [6000:0002]
+  4 -> 10Moons UT821                          (tm5600)          [6000:0001]
+  5 -> 10Moons UT330                          (tm5600)
+  6 -> ADSTech Dual TV                        (tm6000)          [06e1:f332]
+  7 -> FreeCom and similar                    (tm6000)          [14aa:0620]
+  8 -> ADSTech Mini Dual TV                   (tm6000)          [06e1:b339]
+  9 -> Hauppauge WinTV HVR-900H/USB2 Stick    (tm6010)          [2040:6600,2040:6601,2040:6610,2040:6611]
+ 10 -> Beholder Wander                        (tm6010)          [6000:dec0]
+ 11 -> Beholder Voyager                       (tm6010)          [6000:dec1]
+ 12 -> TerraTec Cinergy Hybrid XE/Cinergy Hybrid Stick (tm6010) [0ccd:0086,0ccd:00a5]
+ 13 -> TwinHan TU501                          (tm6010)          [13d3:3240,13d3:3241,13d3:3243,13d3:3264]
+ 14 -> Beholder Wander Lite                   (tm6010)          [6000:dec2]
+ 15 -> Beholder Voyager Lite                  (tm6010)          [6000:dec3]
+
-- 
1.7.3.4

