Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:50214 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbdHZCJg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 22:09:36 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: ddbridge can be now compiled for kernels older than 3.8
Date: Sat, 26 Aug 2017 04:09:30 +0200
Message-Id: <1503713370-32220-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1503713370-32220-1-git-send-email-jasmin@anw.at>
References: <1503713370-32220-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 6f27929..7634038 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -126,8 +126,6 @@ IR_SPI
 [3.8.0]
 # needs regmap lock/unlock ops
 DVB_TS2020
-# needs the PCI_DEVICE_SUB macro
-DVB_DDBRIDGE
 
 [3.7.0]
 # i2c_add_mux_adapter prototype change
-- 
2.7.4
