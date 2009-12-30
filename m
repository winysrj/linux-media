Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52954 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZL3V3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 16:29:08 -0500
Message-ID: <4B3BC61E.8080706@freemail.hu>
Date: Wed, 30 Dec 2009 22:29:02 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>, cocci@diku.dk
Subject: [PATCH] gspca: make sd_desc const
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The function callbacks in sd_desc are defined at compile time and
they do not change at runtime. Make the sd_desc initializations const.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@c@
identifier x;
@@
	static const struct sd_desc x = ...;
@depends on !c@
identifier x;
@@
	static
+	const
	struct sd_desc x = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: cocci@diku.dk
---

diff -r 62ee2b0f6556 linux/drivers/media/video/gspca/conex.c
--- a/linux/drivers/media/video/gspca/conex.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/gspca/conex.c	Wed Dec 30 22:27:04 2009 +0100
@@ -1032,7 +1032,7 @@
 }

 /* sub-driver description */
-static struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
diff -r 62ee2b0f6556 linux/drivers/media/video/gspca/etoms.c
--- a/linux/drivers/media/video/gspca/etoms.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/gspca/etoms.c	Wed Dec 30 22:27:04 2009 +0100
@@ -857,7 +857,7 @@
 }

 /* sub-driver description */
-static struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
diff -r 62ee2b0f6556 linux/drivers/media/video/gspca/gl860/gl860.c
--- a/linux/drivers/media/video/gspca/gl860/gl860.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/gspca/gl860/gl860.c	Wed Dec 30 22:27:04 2009 +0100
@@ -161,7 +161,7 @@

 /*==================== sud-driver structure initialisation =================*/

-static struct sd_desc sd_desc_mi1320 = {
+static const struct sd_desc sd_desc_mi1320 = {
 	.name        = MODULE_NAME,
 	.ctrls       = sd_ctrls_mi1320,
 	.nctrls      = GL860_NCTRLS,
@@ -174,7 +174,7 @@
 	.dq_callback = sd_callback,
 };

-static struct sd_desc sd_desc_mi2020 = {
+static const struct sd_desc sd_desc_mi2020 = {
 	.name        = MODULE_NAME,
 	.ctrls       = sd_ctrls_mi2020,
 	.nctrls      = GL860_NCTRLS,
@@ -187,7 +187,7 @@
 	.dq_callback = sd_callback,
 };

-static struct sd_desc sd_desc_mi2020b = {
+static const struct sd_desc sd_desc_mi2020b = {
 	.name        = MODULE_NAME,
 	.ctrls       = sd_ctrls_mi2020b,
 	.nctrls      = GL860_NCTRLS,
@@ -200,7 +200,7 @@
 	.dq_callback = sd_callback,
 };

-static struct sd_desc sd_desc_ov2640 = {
+static const struct sd_desc sd_desc_ov2640 = {
 	.name        = MODULE_NAME,
 	.ctrls       = sd_ctrls_ov2640,
 	.nctrls      = GL860_NCTRLS,
@@ -213,7 +213,7 @@
 	.dq_callback = sd_callback,
 };

-static struct sd_desc sd_desc_ov9655 = {
+static const struct sd_desc sd_desc_ov9655 = {
 	.name        = MODULE_NAME,
 	.ctrls       = sd_ctrls_ov9655,
 	.nctrls      = GL860_NCTRLS,
diff -r 62ee2b0f6556 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Wed Dec 30 22:27:04 2009 +0100
@@ -1232,7 +1232,7 @@
 #endif

 /* sub-driver description for pac7302 */
-static struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
diff -r 62ee2b0f6556 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7311.c	Wed Dec 30 22:27:04 2009 +0100
@@ -870,7 +870,7 @@
 }

 /* sub-driver description for pac7311 */
-static struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
diff -r 62ee2b0f6556 linux/drivers/media/video/gspca/spca500.c
--- a/linux/drivers/media/video/gspca/spca500.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca500.c	Wed Dec 30 22:27:04 2009 +0100
@@ -1064,7 +1064,7 @@
 }

 /* sub-driver description */
-static struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
diff -r 62ee2b0f6556 linux/drivers/media/video/gspca/spca506.c
--- a/linux/drivers/media/video/gspca/spca506.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca506.c	Wed Dec 30 22:27:04 2009 +0100
@@ -673,7 +673,7 @@
 }

 /* sub-driver description */
-static struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
