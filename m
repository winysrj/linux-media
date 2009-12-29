Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:60464 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZL2Vp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 16:45:59 -0500
Message-ID: <4B3A7890.7060109@freemail.hu>
Date: Tue, 29 Dec 2009 22:45:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: cocci@diku.dk
Subject: [PATCH] gspca: make control descriptors constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The ctrls field of struct sd_desc is declared as const
in gspca.h. It is worth to initialize the content also with
constant values.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@m@
identifier x;
identifier y;
identifier sd_desc;
@@
	static struct x sd_desc = {
		...
		.ctrls = y,
		...
	};
@c depends on m@
identifier m.y;
identifier ctrl;
@@
	static const struct ctrl y[] = ...;
@depends on m && !c@
identifier m.y;
identifier ctrl;
@@
	static
+	const
	struct ctrl y[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: cocci@diku.dk
---
diff -r 563555b04382 linux/drivers/media/video/gspca/benq.c
--- a/linux/drivers/media/video/gspca/benq.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/benq.c	Tue Dec 29 21:03:28 2009 +0100
@@ -32,7 +32,7 @@
 };

 /* V4L2 controls supported by the driver */
-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 };

 static const struct v4l2_pix_format vga_mode[] = {
diff -r 563555b04382 linux/drivers/media/video/gspca/conex.c
--- a/linux/drivers/media/video/gspca/conex.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/conex.c	Tue Dec 29 21:03:28 2009 +0100
@@ -52,7 +52,7 @@
 static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	    {
 		.id	 = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/etoms.c
--- a/linux/drivers/media/video/gspca/etoms.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/etoms.c	Tue Dec 29 21:03:28 2009 +0100
@@ -52,7 +52,7 @@
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	 {
 	  .id = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/mars.c
--- a/linux/drivers/media/video/gspca/mars.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/mars.c	Tue Dec 29 21:03:28 2009 +0100
@@ -54,7 +54,7 @@
 static int sd_setsharpness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getsharpness(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/mr97310a.c
--- a/linux/drivers/media/video/gspca/mr97310a.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/mr97310a.c	Tue Dec 29 21:03:28 2009 +0100
@@ -107,7 +107,7 @@
 static void setgain(struct gspca_dev *gspca_dev);

 /* V4L2 controls supported by the driver */
-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 /* Separate brightness control description for Argus QuickClix as it has
    different limits from the other mr97310a cameras */
 	{
diff -r 563555b04382 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/ov534.c	Tue Dec 29 21:03:28 2009 +0100
@@ -106,7 +106,7 @@
 static int sd_setfreq(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls_ov772x[] = {
+static const struct ctrl sd_ctrls_ov772x[] = {
     {							/* 0 */
 	{
 		.id      = V4L2_CID_BRIGHTNESS,
@@ -277,7 +277,7 @@
 	.get = sd_getvflip,
     },
 };
-static struct ctrl sd_ctrls_ov965x[] = {
+static const struct ctrl sd_ctrls_ov965x[] = {
     {							/* 0 */
 	{
 		.id      = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac207.c	Tue Dec 29 21:03:28 2009 +0100
@@ -77,7 +77,7 @@
 static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 #define SD_BRIGHTNESS 0
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Tue Dec 29 21:03:28 2009 +0100
@@ -124,7 +124,7 @@
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 /* This control is pac7302 only */
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7311.c	Tue Dec 29 21:03:28 2009 +0100
@@ -88,7 +88,7 @@
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 /* This control is for both the 7302 and the 7311 */
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/sn9c20x.c
--- a/linux/drivers/media/video/gspca/sn9c20x.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/sn9c20x.c	Tue Dec 29 21:03:28 2009 +0100
@@ -131,7 +131,7 @@
 static int sd_setautoexposure(struct gspca_dev *gspca_dev, s32 val);
 static int sd_getautoexposure(struct gspca_dev *gspca_dev, s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 #define BRIGHTNESS_IDX 0
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/sonixb.c	Tue Dec 29 21:03:28 2009 +0100
@@ -145,7 +145,7 @@
 static int sd_setfreq(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 #define BRIGHTNESS_IDX 0
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/sonixj.c
--- a/linux/drivers/media/video/gspca/sonixj.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/sonixj.c	Tue Dec 29 21:03:28 2009 +0100
@@ -102,7 +102,7 @@
 static int sd_setfreq(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 #define BRIGHTNESS_IDX 0
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/spca500.c
--- a/linux/drivers/media/video/gspca/spca500.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca500.c	Tue Dec 29 21:03:28 2009 +0100
@@ -68,7 +68,7 @@
 static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/spca501.c
--- a/linux/drivers/media/video/gspca/spca501.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca501.c	Tue Dec 29 21:03:28 2009 +0100
@@ -59,7 +59,7 @@
 static int sd_setred_balance(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getred_balance(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 #define MY_BRIGHTNESS 0
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/spca505.c
--- a/linux/drivers/media/video/gspca/spca505.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca505.c	Tue Dec 29 21:03:28 2009 +0100
@@ -42,7 +42,7 @@
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/spca506.c
--- a/linux/drivers/media/video/gspca/spca506.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca506.c	Tue Dec 29 21:03:28 2009 +0100
@@ -51,7 +51,7 @@
 static int sd_sethue(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_gethue(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 #define SD_BRIGHTNESS 0
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/spca508.c
--- a/linux/drivers/media/video/gspca/spca508.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca508.c	Tue Dec 29 21:03:28 2009 +0100
@@ -45,7 +45,7 @@
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/spca561.c
--- a/linux/drivers/media/video/gspca/spca561.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca561.c	Tue Dec 29 21:03:28 2009 +0100
@@ -953,7 +953,7 @@
 }

 /* control tables */
-static struct ctrl sd_ctrls_12a[] = {
+static const struct ctrl sd_ctrls_12a[] = {
 	{
 	    {
 		.id = V4L2_CID_HUE,
@@ -995,7 +995,7 @@
 	},
 };

-static struct ctrl sd_ctrls_72a[] = {
+static const struct ctrl sd_ctrls_72a[] = {
 	{
 	    {
 		.id = V4L2_CID_HUE,
diff -r 563555b04382 linux/drivers/media/video/gspca/stk014.c
--- a/linux/drivers/media/video/gspca/stk014.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/stk014.c	Tue Dec 29 21:03:28 2009 +0100
@@ -53,7 +53,7 @@
 static int sd_setfreq(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/stv0680.c
--- a/linux/drivers/media/video/gspca/stv0680.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/stv0680.c	Tue Dec 29 21:03:28 2009 +0100
@@ -45,7 +45,7 @@
 };

 /* V4L2 controls supported by the driver */
-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 };

 static int stv_sndctrl(struct gspca_dev *gspca_dev, int set, u8 req, u16 val,
diff -r 563555b04382 linux/drivers/media/video/gspca/sunplus.c
--- a/linux/drivers/media/video/gspca/sunplus.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/sunplus.c	Tue Dec 29 21:03:28 2009 +0100
@@ -67,7 +67,7 @@
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/t613.c
--- a/linux/drivers/media/video/gspca/t613.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/t613.c	Tue Dec 29 21:03:28 2009 +0100
@@ -78,7 +78,7 @@
 static int sd_querymenu(struct gspca_dev *gspca_dev,
 			struct v4l2_querymenu *menu);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	 {
 	  .id = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/tv8532.c
--- a/linux/drivers/media/video/gspca/tv8532.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/tv8532.c	Tue Dec 29 21:03:28 2009 +0100
@@ -39,7 +39,7 @@
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 	{
 	 {
 	  .id = V4L2_CID_BRIGHTNESS,
diff -r 563555b04382 linux/drivers/media/video/gspca/vc032x.c
--- a/linux/drivers/media/video/gspca/vc032x.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/vc032x.c	Tue Dec 29 21:03:28 2009 +0100
@@ -78,7 +78,7 @@
 static int sd_setsharpness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getsharpness(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 #define BRIGHTNESS_IDX 0
 	{
 	    {
diff -r 563555b04382 linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Sun Dec 27 17:18:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Tue Dec 29 21:03:28 2009 +0100
@@ -92,7 +92,7 @@
 static int sd_setsharpness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getsharpness(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static const struct ctrl sd_ctrls[] = {
 #define BRIGHTNESS_IDX 0
 #define SD_BRIGHTNESS 0
 	{

