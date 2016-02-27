Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbcB0Nkd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 08:40:33 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	istaff124@gmail.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] v4lconvert: Add "PEGATRON CORPORATION" to asus_board_vendor
Date: Sat, 27 Feb 2016 14:40:24 +0100
Message-Id: <1456580424-9627-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1456580424-9627-1-git-send-email-hdegoede@redhat.com>
References: <1456580424-9627-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some Asus laptops actually have "PEGATRON CORPORATION" in board_vendor,
add this to the list of strings used to recognize Asus as vendor.

This also allows us to remove a bunch of PEGATRON entries from the static
v4lcontrol_flags table.

Note that 2 PEGATRON entries remain in the static v4lcontrol_flags table,
one for a "H54" board_name entry since "H54" is not in the asus_board_name
array, and one "PEGATRON CORP." board which does not have a usable
board_name at all.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1311545
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4lconvert/control/libv4lcontrol.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index e1832a9..0c45a26 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -75,9 +75,6 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 	/* A re-branded ASUS notebook */
 	{ 0x04f2, 0xb012, 0, "Founder PC", "T14MF",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
-	/* Note no whitespace padding for board vendor, this is not a typo */
-	{ 0x04f2, 0xb012, 0, "PEGATRON CORPORATION", "X71TL     ",
-		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
 	/* These 3 PACKARD BELL's seem to be Asus notebook in disguise */
 	{ 0x04f2, 0xb012, 0, "Packard Bell BV", "T32A      ",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
@@ -152,10 +149,6 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 	{ 0x064e, 0xa111, 0, "Acer, Inc.", "Prespa1         ", 
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED, 0,
 		"Acer, inc.", "Aspire 5570     " },
-	{ 0x064e, 0xa111, 0, "PEGATRON CORPORATION         ", "F5C     ",
-		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
-	{ 0x064e, 0xa111, 0, "PEGATRON CORPORATION         ", "F5SR    ",
-		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
 	/* 2 reports:
 	   Unknown laptop model -> System Vendor: "  IDEALMAX"
 	   Síragon SL-6120      -> System Vendor: "PEGA PC"
@@ -165,8 +158,6 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
 		NULL, "H34" },
 	{ 0x064e, 0xa212, 0, "MEDIONAG", "WeTab ",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
-	{ 0x174f, 0x5a35, 0, "PEGATRON CORPORATION         ", "F5SL    ",
-		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
 	{ 0x174f, 0x6a51, 0, NULL, "S96S",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED, 0,
 		"MicroLink", "S96S" },
@@ -270,6 +261,7 @@ static const char *asus_board_vendor[] = {
 	"ASUSTeK Computer Inc.",
 	"ASUSTeK Computer INC.",
 	"ASUS CORPORATION",
+	"PEGATRON CORPORATION",
 	NULL };
 
 static const char *asus_board_name[] = {
-- 
2.7.1

