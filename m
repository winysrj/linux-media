Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9RB1015876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 24/94] [media] em28xx-dvb: don't initialize drx-d non-used fields with zero
Date: Fri, 30 Dec 2011 13:07:21 -0200
Message-Id: <1325257711-12274-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to initialize unused fields with zero, as Kernel does
it automatically.

Removing the initialization makes the code cleaner.

This also allows the removal of the unused pll_set callback.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/em28xx/em28xx-dvb.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 3868c1e..28be043 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -302,10 +302,12 @@ static struct zl10353_config em28xx_zl10353_xc3028_no_i2c_gate = {
 };
 
 static struct drxd_config em28xx_drxd = {
-	.index = 0, .demod_address = 0x70, .demod_revision = 0xa2,
-	.demoda_address = 0x00, .pll_address = 0x00,
-	.pll_type = DRXD_PLL_NONE, .clock = 12000, .insert_rs_byte = 1,
-	.pll_set = NULL, .osc_deviation = NULL, .IF = 42800000,
+	.demod_address = 0x70,
+	.demod_revision = 0xa2,
+	.pll_type = DRXD_PLL_NONE,
+	.clock = 12000,
+	.insert_rs_byte = 1,
+	.IF = 42800000,
 	.disable_i2c_gate_ctrl = 1,
 };
 
-- 
1.7.8.352.g876a6

