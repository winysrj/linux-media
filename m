Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:43167 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbeANJf4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 04:35:56 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Disabled VIDEO_OV7740 for Kernels older than 4.3
Date: Sun, 14 Jan 2018 10:35:45 +0000
Message-Id: <1515926145-5494-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index ed1e056..945e1c3 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -35,6 +35,8 @@ VIDEO_SOLO6X10
 [4.3.0]
 # needs regmap_write_bits
 MEDIA_TUNER_TDA18250
+# Needs struct reg_sequence
+VIDEO_OV7740
 
 [4.2.0]
 # needs led_trigger_remove
-- 
2.7.4
