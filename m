Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46412 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdHXBBr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 21:01:47 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: gpio_ir_tx needs 4.10 at least
Date: Thu, 24 Aug 2017 03:01:41 +0200
Message-Id: <1503536501-20252-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index b038a81..6f27929 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -39,6 +39,7 @@ VIDEO_XILINX
 VIDEO_OV5670
 # needs ktime_t as s64
 CEC_PIN
+IR_GPIO_TX
 
 [4.7.0]
 # needs i2c_mux_alloc
-- 
2.7.4
