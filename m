Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbcFXPcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/19] adv7842: comment out a table useful for debug
Date: Fri, 24 Jun 2016 12:31:59 -0300
Message-Id: <60eb9579c1af6e2c077cbc795969f4ee49041c34.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 6.1 warns about an unused table:

drivers/media/i2c/adv7842.c:2400:27: warning: 'prim_mode_txt' defined but not used [-Wunused-const-variable=]
 static const char * const prim_mode_txt[] = {
                           ^~~~~~~~~~~~~

That seems to be useful for debug, and likely were used before.
While we could simply remove, let's comment it out, for now.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/adv7842.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index ecaacb0a6fa1..8081ef78ec05 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2397,6 +2397,8 @@ static void adv7842_log_infoframes(struct v4l2_subdev *sd)
 		log_infoframe(sd, &cri[i]);
 }
 
+#if 0
+/* Let's keep it here for now, as it could be useful for debug */
 static const char * const prim_mode_txt[] = {
 	"SDP",
 	"Component",
@@ -2415,6 +2417,7 @@ static const char * const prim_mode_txt[] = {
 	"Reserved",
 	"Reserved",
 };
+#endif
 
 static int adv7842_sdp_log_status(struct v4l2_subdev *sd)
 {
-- 
2.7.4


