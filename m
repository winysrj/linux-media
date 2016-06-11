Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:57055 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbcFKWkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 18:40:15 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-media@vger.kernel.org, steve_longerbeam@mentor.com
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH 2/2] media: mx6-camif: add V4L2_FRMIVAL_TYPE_STEPWISE & _CONTINUOUS
Date: Sun, 12 Jun 2016 00:31:10 +0200
Message-Id: <1465684270-12506-1-git-send-email-phdm@macqel.be>
In-Reply-To: <1465684199-12438-1-git-send-email-phdm@macqel.be>
References: <1465684199-12438-1-git-send-email-phdm@macqel.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 drivers/staging/media/imx6/capture/mx6-camif.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx6/capture/mx6-camif.c b/drivers/staging/media/imx6/capture/mx6-camif.c
index b36f9d1..137733e 100644
--- a/drivers/staging/media/imx6/capture/mx6-camif.c
+++ b/drivers/staging/media/imx6/capture/mx6-camif.c
@@ -1344,8 +1344,19 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
-	fival->discrete = fie.interval;
+	if (fie.max_interval.numerator == 0) {
+		fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+		fival->discrete = fie.interval;
+	} else if (fie.step_interval.numerator == 0) {
+		fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
+		fival->stepwise.min = fie.interval;
+		fival->stepwise.max = fie.max_interval;
+	} else {
+		fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+		fival->stepwise.min = fie.interval;
+		fival->stepwise.max = fie.max_interval;
+		fival->stepwise.step = fie.step_interval;
+	}
 	return 0;
 }
 
-- 
1.8.1.4

