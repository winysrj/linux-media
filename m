Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:38976 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755241AbdGWMMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 08:12:19 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 2/3] build: Disable VIDEO_OV5670 for Kernels older that 3.17
Date: Sun, 23 Jul 2017 14:12:03 +0200
Message-Id: <1500811924-4559-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1500811924-4559-1-git-send-email-jasmin@anw.at>
References: <1500811924-4559-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index ae4a14f..1dd9a2b 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -68,6 +68,7 @@ VIDEO_ADV7180
 VIDEO_ET8EK8
 VIDEO_OV2640
 VIDEO_OV7670
+VIDEO_OV5670
 
 [3.15.0]
 # needs reset_control_get_optional
-- 
2.7.4
