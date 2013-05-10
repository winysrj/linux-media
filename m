Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51470 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3EJMNu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 08:13:50 -0400
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 05/11] media/si4713-i2c: take usecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:23 +0300
Message-Id: <1368188011-23661-5-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use usecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/media/radio/si4713-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index bd61b3b..09eb6b9 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -252,7 +252,7 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
 
 	/* Wait response from interrupt */
 	if (!wait_for_completion_timeout(&sdev->work,
-				usecs_to_jiffies(usecs) + 1))
+				usecs_to_jiffies_min(usecs)))
 		v4l2_warn(&sdev->sd,
 				"(%s) Device took too much time to answer.\n",
 				__func__);
@@ -494,7 +494,7 @@ static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
 
 	/* Wait response from STC interrupt */
 	if (!wait_for_completion_timeout(&sdev->work,
-			usecs_to_jiffies(usecs) + 1))
+			usecs_to_jiffies_min(usecs)))
 		v4l2_warn(&sdev->sd,
 			"%s: device took too much time to answer (%d usec).\n",
 				__func__, usecs);
-- 
1.7.10.4

