Return-path: <linux-media-owner@vger.kernel.org>
Received: from symlink.to.noone.org ([85.10.207.172]:51454 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZDZMst (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 08:48:49 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: erik.andren@gmail.com
Cc: linux-media@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] gspca - m5602: Storage class should be before const qualifier
Date: Sun, 26 Apr 2009 14:30:18 +0200
Message-Id: <1240749018-9043-1-git-send-email-tklauser@distanz.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the
beginning of the declaration specifiers in a declaration is an
obsolescent feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/media/video/gspca/m5602/m5602_mt9m111.c |    2 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.h |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c  |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_po1030.c  |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c  |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/gspca/m5602/m5602_mt9m111.c b/drivers/media/video/gspca/m5602/m5602_mt9m111.c
index 7d3f9e3..0167987 100644
--- a/drivers/media/video/gspca/m5602/m5602_mt9m111.c
+++ b/drivers/media/video/gspca/m5602/m5602_mt9m111.c
@@ -31,7 +31,7 @@ static struct v4l2_pix_format mt9m111_modes[] = {
 	}
 };
 
-const static struct ctrl mt9m111_ctrls[] = {
+static const struct ctrl mt9m111_ctrls[] = {
 	{
 		{
 			.id		= V4L2_CID_VFLIP,
diff --git a/drivers/media/video/gspca/m5602/m5602_mt9m111.h b/drivers/media/video/gspca/m5602/m5602_mt9m111.h
index 00c6db0..6bedf9d 100644
--- a/drivers/media/video/gspca/m5602/m5602_mt9m111.h
+++ b/drivers/media/video/gspca/m5602/m5602_mt9m111.h
@@ -94,7 +94,7 @@ int mt9m111_set_hflip(struct gspca_dev *gspca_dev, __s32 val);
 int mt9m111_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
 int mt9m111_set_gain(struct gspca_dev *gspca_dev, __s32 val);
 
-const static struct m5602_sensor mt9m111 = {
+static const struct m5602_sensor mt9m111 = {
 	.name = "MT9M111",
 
 	.i2c_slave_id = 0xba,
diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.c b/drivers/media/video/gspca/m5602/m5602_ov9650.c
index fc4548f..6c3baca 100644
--- a/drivers/media/video/gspca/m5602/m5602_ov9650.c
+++ b/drivers/media/video/gspca/m5602/m5602_ov9650.c
@@ -68,7 +68,7 @@ static
 	{}
 };
 
-const static struct ctrl ov9650_ctrls[] = {
+static const struct ctrl ov9650_ctrls[] = {
 #define EXPOSURE_IDX 0
 	{
 		{
diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.h b/drivers/media/video/gspca/m5602/m5602_ov9650.h
index fcc54e4..2ca0e88 100644
--- a/drivers/media/video/gspca/m5602/m5602_ov9650.h
+++ b/drivers/media/video/gspca/m5602/m5602_ov9650.h
@@ -159,7 +159,7 @@ int ov9650_set_auto_white_balance(struct gspca_dev *gspca_dev, __s32 val);
 int ov9650_get_auto_gain(struct gspca_dev *gspca_dev, __s32 *val);
 int ov9650_set_auto_gain(struct gspca_dev *gspca_dev, __s32 val);
 
-const static struct m5602_sensor ov9650 = {
+static const struct m5602_sensor ov9650 = {
 	.name = "OV9650",
 	.i2c_slave_id = 0x60,
 	.i2c_regW = 1,
diff --git a/drivers/media/video/gspca/m5602/m5602_po1030.c b/drivers/media/video/gspca/m5602/m5602_po1030.c
index eaddf48..b06e229 100644
--- a/drivers/media/video/gspca/m5602/m5602_po1030.c
+++ b/drivers/media/video/gspca/m5602/m5602_po1030.c
@@ -31,7 +31,7 @@ static struct v4l2_pix_format po1030_modes[] = {
 	}
 };
 
-const static struct ctrl po1030_ctrls[] = {
+static const struct ctrl po1030_ctrls[] = {
 	{
 		{
 			.id 		= V4L2_CID_GAIN,
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
index 4306d59..bab6cb4 100644
--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
@@ -64,7 +64,7 @@ static struct v4l2_pix_format s5k4aa_modes[] = {
 	}
 };
 
-const static struct ctrl s5k4aa_ctrls[] = {
+static const struct ctrl s5k4aa_ctrls[] = {
 	{
 		{
 			.id 		= V4L2_CID_VFLIP,
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k83a.c b/drivers/media/video/gspca/m5602/m5602_s5k83a.c
index 42c86aa..689afbc 100644
--- a/drivers/media/video/gspca/m5602/m5602_s5k83a.c
+++ b/drivers/media/video/gspca/m5602/m5602_s5k83a.c
@@ -32,7 +32,7 @@ static struct v4l2_pix_format s5k83a_modes[] = {
 	}
 };
 
-const static struct ctrl s5k83a_ctrls[] = {
+static const struct ctrl s5k83a_ctrls[] = {
 	{
 		{
 			.id = V4L2_CID_BRIGHTNESS,
-- 
1.6.2.4

