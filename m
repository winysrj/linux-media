Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8329 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750787AbeAYEpJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 23:45:09 -0500
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, andy.yeh@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov13858: Avoid possible null first frame
Date: Wed, 24 Jan 2018 20:34:39 -0800
Message-Id: <1516854879-15029-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, the sensor, with default settings, was outputting SOF without
data. This results in frame sync error on the receiver side.

Now, configure the sensor to output SOF with MIPI data for all frames. This
avoids possible null first frame on the bus.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
---
 drivers/media/i2c/ov13858.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index bf7d06f..2964d5c 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -194,6 +194,7 @@ struct ov13858_mode {
 	{0x3624, 0x1c},
 	{0x3640, 0x10},
 	{0x3641, 0x70},
+	{0x3660, 0x04},
 	{0x3661, 0x80},
 	{0x3662, 0x12},
 	{0x3664, 0x73},
@@ -384,6 +385,7 @@ struct ov13858_mode {
 	{0x3624, 0x1c},
 	{0x3640, 0x10},
 	{0x3641, 0x70},
+	{0x3660, 0x04},
 	{0x3661, 0x80},
 	{0x3662, 0x10},
 	{0x3664, 0x73},
@@ -574,6 +576,7 @@ struct ov13858_mode {
 	{0x3624, 0x1c},
 	{0x3640, 0x10},
 	{0x3641, 0x70},
+	{0x3660, 0x04},
 	{0x3661, 0x80},
 	{0x3662, 0x10},
 	{0x3664, 0x73},
@@ -764,6 +767,7 @@ struct ov13858_mode {
 	{0x3624, 0x1c},
 	{0x3640, 0x10},
 	{0x3641, 0x70},
+	{0x3660, 0x04},
 	{0x3661, 0x80},
 	{0x3662, 0x08},
 	{0x3664, 0x73},
-- 
1.9.1
