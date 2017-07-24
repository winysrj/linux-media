Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:36494 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754299AbdGXUxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 16:53:44 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 2/3] build: CEC_PIN and the VIDEO_OV5670 driver both require kernel 4.10 to compile
Date: Mon, 24 Jul 2017 22:53:36 +0200
Message-Id: <1500929617-13623-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1500929617-13623-1-git-send-email-jasmin@anw.at>
References: <1500929617-13623-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index ae4a14f..7d786da 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -28,6 +28,12 @@ VIDEO_S5P_MIPI_CSIS
 VIDEO_RCAR_VIN
 VIDEO_XILINX
 
+[4.10.0]
+# needs *probe_new in struct i2c_driver
+VIDEO_OV5670
+# needs ktime_t as s64
+CEC_PIN
+
 [4.7.0]
 # needs i2c_mux_alloc
 VIDEO_CX231XX
-- 
2.7.4
