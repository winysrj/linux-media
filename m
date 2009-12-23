Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:60986 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbZLWNFQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 08:05:16 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
	Erik Andren <erik.andren@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH 3/3] [V4L/DVB] gspca: Storage class should be before const qualifier
Date: Wed, 23 Dec 2009 13:53:14 +0100
Message-Id: <1261572794-8369-3-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1261572794-8369-2-git-send-email-tklauser@distanz.ch>
References: <1261572794-8369-1-git-send-email-tklauser@distanz.ch>
 <1261572794-8369-2-git-send-email-tklauser@distanz.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Erik Andren <erik.andren@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/media/video/gspca/m5602/m5602_mt9m111.c |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.c  |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.h  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/m5602/m5602_mt9m111.c b/drivers/media/video/gspca/m5602/m5602_mt9m111.c
index 8d071df..3285957 100644
--- a/drivers/media/video/gspca/m5602/m5602_mt9m111.c
+++ b/drivers/media/video/gspca/m5602/m5602_mt9m111.c
@@ -48,7 +48,7 @@ static struct v4l2_pix_format mt9m111_modes[] = {
 	}
 };
 
-const static struct ctrl mt9m111_ctrls[] = {
+static const struct ctrl mt9m111_ctrls[] = {
 #define VFLIP_IDX 0
 	{
 		{
diff --git a/drivers/media/video/gspca/m5602/m5602_ov7660.c b/drivers/media/video/gspca/m5602/m5602_ov7660.c
index 2a28b74..62c1cbf 100644
--- a/drivers/media/video/gspca/m5602/m5602_ov7660.c
+++ b/drivers/media/video/gspca/m5602/m5602_ov7660.c
@@ -33,7 +33,7 @@ static int ov7660_set_hflip(struct gspca_dev *gspca_dev, __s32 val);
 static int ov7660_get_vflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int ov7660_set_vflip(struct gspca_dev *gspca_dev, __s32 val);
 
-const static struct ctrl ov7660_ctrls[] = {
+static const struct ctrl ov7660_ctrls[] = {
 #define GAIN_IDX 1
 	{
 		{
diff --git a/drivers/media/video/gspca/m5602/m5602_ov7660.h b/drivers/media/video/gspca/m5602/m5602_ov7660.h
index f5588eb..4d9dcf2 100644
--- a/drivers/media/video/gspca/m5602/m5602_ov7660.h
+++ b/drivers/media/video/gspca/m5602/m5602_ov7660.h
@@ -94,7 +94,7 @@ int ov7660_start(struct sd *sd);
 int ov7660_stop(struct sd *sd);
 void ov7660_disconnect(struct sd *sd);
 
-const static struct m5602_sensor ov7660 = {
+static const struct m5602_sensor ov7660 = {
 	.name = "ov7660",
 	.i2c_slave_id = 0x42,
 	.i2c_regW = 1,
-- 
1.6.3.3

