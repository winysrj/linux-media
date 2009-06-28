Return-path: <linux-media-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1114 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbZF1Q1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:36 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, ivtv-users@ivtvdriver.org,
	ivtv-devel@ivtvdriver.org
Subject: [PATCH 23/62] drivers/media/video/ivtv/ivtv-driver.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:28 -0700
Message-Id: <c27c39ac544f3e2409668f58da294b4fbe3e9520.1246173681.git.joe@perches.com>
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/ivtv/ivtv-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 558f8a8..fa360d3 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -218,7 +218,7 @@ MODULE_PARM_DESC(ivtv_yuv_mode,
 		 "\t\t\tDefault: 0 (interlaced)");
 MODULE_PARM_DESC(ivtv_yuv_threshold,
 		 "If ivtv_yuv_mode is 2 (auto) then playback content as\n\t\tprogressive if src height <= ivtv_yuvthreshold\n"
-		 "\t\t\tDefault: 480");;
+		 "\t\t\tDefault: 480");
 MODULE_PARM_DESC(enc_mpg_buffers,
 		 "Encoder MPG Buffers (in MB)\n"
 		 "\t\t\tDefault: " __stringify(IVTV_DEFAULT_ENC_MPG_BUFFERS));
-- 
1.6.3.1.10.g659a0.dirty

