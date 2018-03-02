Return-path: <linux-media-owner@vger.kernel.org>
Received: from skyboo.net ([94.40.87.198]:32830 "EHLO skyboo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164860AbeCBIUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 03:20:36 -0500
From: Mariusz Bialonczyk <manio@skyboo.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mariusz Bialonczyk <manio@skyboo.net>
Date: Fri,  2 Mar 2018 08:55:24 +0100
Message-Id: <20180302075524.27868-1-manio@skyboo.net>
Subject: [PATCH] w1: fix w1_ds2438 documentation
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
---
 Documentation/w1/slaves/w1_ds2438 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/w1/slaves/w1_ds2438 b/Documentation/w1/slaves/w1_ds2438
index b99f3674c5b4..e64f65a09387 100644
--- a/Documentation/w1/slaves/w1_ds2438
+++ b/Documentation/w1/slaves/w1_ds2438
@@ -60,4 +60,4 @@ vad: general purpose A/D input (VAD)
 vdd: battery input (VDD)
 
 After the voltage conversion the value is returned as decimal ASCII.
-Note: The value is in mV, so to get a volts the value has to be divided by 10.
+Note: To get a volts the value has to be divided by 100.
-- 
2.16.2
