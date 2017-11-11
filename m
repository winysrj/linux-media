Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:47404 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752386AbdKKVaJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 16:30:09 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: VIDEO_IMX274 driver requires kernel 3.18.0 to compile
Date: Sat, 11 Nov 2017 22:29:57 +0100
Message-Id: <1510435797-14993-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index dab91c7..4ee0840 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -69,6 +69,7 @@ VIDEO_OV2640
 VIDEO_OV5645
 VIDEO_OV7670
 VIDEO_OV5640
+VIDEO_IMX274
 IR_GPIO_TX
 IR_GPIO_CIR
 # needs component_match_add
-- 
2.7.4
