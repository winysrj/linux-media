Return-path: <mchehab@localhost>
Received: from equal.cluenet.org ([109.74.200.177]:60232 "EHLO
	equal.cluenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1GFMLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 08:11:14 -0400
From: =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@nullroute.eu.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@nullroute.eu.org>
Subject: [PATCH] libv4l: add Asus K52JT to upside down device table
Date: Wed,  6 Jul 2011 15:04:04 +0300
Message-Id: <1309953844-3500-2-git-send-email-grawity@nullroute.eu.org>
In-Reply-To: <1309953844-3500-1-git-send-email-grawity@nullroute.eu.org>
References: <1309953844-3500-1-git-send-email-grawity@nullroute.eu.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

---
 lib/libv4lconvert/control/libv4lcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 2fddf43..c8a636b 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -288,6 +288,8 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
 	{ 0x04f2, 0xb1e5, 0, "ASUSTeK Computer Inc.        ", "K52Jc",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
+	{ 0x04f2, 0xb1e5, 0, "ASUSTeK Computer Inc.        ", "K52JT",
+		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
 	{ 0x04f2, 0xb1e5, 0, "ASUSTeK Computer Inc.        ", "K52N",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
 	{ 0x04f2, 0xb1e5, 0, "ASUSTeK Computer Inc.        ", "P52F",
-- 
1.7.6

