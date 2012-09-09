Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42876 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2IISfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:35:33 -0400
Received: by mail-ee0-f46.google.com with SMTP id c1so651506eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:35:32 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/3] libv4lconvert: update the list of pac7302 webcams
Date: Sun,  9 Sep 2012 20:36:08 +0200
Message-Id: <1347215768-9843-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All pac7302 webcams need image rotation, so synchronize the list with the driver.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 lib/libv4lconvert/control/libv4lcontrol.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 3d7a816..6eea121 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -202,10 +202,21 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 	{ 0x145f, 0x013a, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
 	{ 0x2001, 0xf115, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
 	/* Pac7302 based devices */
-	{ 0x093a, 0x2620, 0x0f, NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
 	{ 0x06f8, 0x3009, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
 	{ 0x06f8, 0x301b, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2620, 0x0f, NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2611, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2622, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2624, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2625, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2626, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2627, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2628, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x2629, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x262a, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x093a, 0x262c, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
 	{ 0x145f, 0x013c, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x1ae7, 0x2001, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
 	/* Pac7311 based devices */
 	{ 0x093a, 0x2600, 0x0f, NULL, NULL, V4LCONTROL_WANTS_WB },
 	/* sq905 devices */
-- 
1.7.7

