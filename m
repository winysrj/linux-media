Return-path: <mchehab@pedra>
Received: from fallback-out2.mxes.net ([216.86.168.191]:40809 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757633Ab0JVQbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 12:31:15 -0400
Received: from mxout-07.mxes.net (mxout-07.mxes.net [216.86.168.182])
	by fallback-in1.mxes.net (Postfix) with ESMTP id 521732FD7B6
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 12:22:12 -0400 (EDT)
Message-ID: <4CC1B9F1.7070505@kde.org>
Date: Fri, 22 Oct 2010 18:21:05 +0200
From: =?ISO-8859-1?Q?Aur=E9lien_G=E2teau?= <agateau@kde.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: agateau@kde.org
Subject: [PATCH] flip camera for Asus P81IJ
Content-Type: multipart/mixed;
 boundary="------------050307010005050303020903"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------050307010005050303020903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi,

Here is a simple patch to flip camera for the Asus P81IJ laptop.

Aurélien

--------------050307010005050303020903
Content-Type: text/x-diff;
 name="0001-Added-Asus-P81IJ.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Added-Asus-P81IJ.patch"

>From 015e4bcf34bd7569f7593958099276b989c08bac Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Aur=C3=A9lien=20G=C3=A2teau?= <agateau@kde.org>
Date: Fri, 22 Oct 2010 18:15:51 +0200
Subject: [PATCH] Added Asus P81IJ

---
 libv4lconvert/control/libv4lcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/libv4lconvert/control/libv4lcontrol.c b/libv4lconvert/control/libv4lcontrol.c
index f74bb3a..a2950e0 100644
--- a/libv4lconvert/control/libv4lcontrol.c
+++ b/libv4lconvert/control/libv4lcontrol.c
@@ -232,6 +232,8 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
     V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
   { 0x13d3, 0x5094, 0, "ASUSTeK Computer Inc.        ", "P50IJ     ",
     V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
+  { 0x13d3, 0x5094, 0, "ASUSTeK Computer Inc.        ", "P81IJ     ",
+    V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
   { 0x174f, 0x5a35, 0, "ASUSTeK Computer Inc.        ", "F3Ka      ",
     V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED },
   { 0x174f, 0x5a35, 0, "ASUSTeK Computer Inc.        ", "F3Ke      ",
-- 
1.7.1


--------------050307010005050303020903--
