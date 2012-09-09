Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62502 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2IISf2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:35:28 -0400
Received: by eaac11 with SMTP id c11so548814eaa.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:35:27 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/3] libv4lconvert: pac7302-devices: remove unneeded flag V4LCONTROL_WANTS_WB
Date: Sun,  9 Sep 2012 20:36:07 +0200
Message-Id: <1347215768-9843-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gspca_pac7302 driver already provides this control.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 lib/libv4lconvert/control/libv4lcontrol.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 1272256..3d7a816 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -202,14 +202,10 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 	{ 0x145f, 0x013a, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
 	{ 0x2001, 0xf115, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
 	/* Pac7302 based devices */
-	{ 0x093a, 0x2620, 0x0f, NULL, NULL,
-		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
-	{ 0x06f8, 0x3009, 0,    NULL, NULL,
-		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
-	{ 0x06f8, 0x301b, 0,    NULL, NULL,
-		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
-	{ 0x145f, 0x013c, 0,    NULL, NULL,
-		V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
+	{ 0x093a, 0x2620, 0x0f, NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x06f8, 0x3009, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x06f8, 0x301b, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
+	{ 0x145f, 0x013c, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
 	/* Pac7311 based devices */
 	{ 0x093a, 0x2600, 0x0f, NULL, NULL, V4LCONTROL_WANTS_WB },
 	/* sq905 devices */
-- 
1.7.7

