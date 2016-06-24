Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 16/19] vivid: remove some unused vars
Date: Fri, 24 Jun 2016 12:31:57 -0300
Message-Id: <ba4cd399c57e9056c5c4fb69561a74e9dd3c53c4.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 6.1 warns about some unused vars. Remove them:
drivers/media/platform/vivid/vivid-vid-cap.c:40:2: warning: 'tpf_default' defined but not used [-Wunused-const-variable=]
  tpf_default = {.numerator = 1,  .denominator = 30};
  ^~~~~~~~~~~
drivers/media/platform/vivid/vivid-sdr-cap.c:54:27: warning: 'NUM_FORMATS' defined but not used [-Wunused-const-variable=]
 static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
                           ^~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/vivid/vivid-sdr-cap.c | 2 --
 drivers/media/platform/vivid/vivid-vid-cap.c | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 3d1604cb982f..1428e31a2875 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -51,8 +51,6 @@ static const struct vivid_format formats[] = {
 	},
 };
 
-static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
-
 static const struct v4l2_frequency_band bands_adc[] = {
 	{
 		.tuner = 0,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 4f730f355a17..fdca33fc20b0 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -36,8 +36,7 @@
 /* timeperframe: min/max and default */
 static const struct v4l2_fract
 	tpf_min     = {.numerator = 1,		.denominator = FPS_MAX},
-	tpf_max     = {.numerator = FPS_MAX,	.denominator = 1},
-	tpf_default = {.numerator = 1,		.denominator = 30};
+	tpf_max     = {.numerator = FPS_MAX,	.denominator = 1};
 
 static const struct vivid_fmt formats_ovl[] = {
 	{
-- 
2.7.4


