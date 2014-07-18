Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57204 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758212AbaGRBFW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 21:05:22 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/4] airspy: remove v4l2-compliance workaround
Date: Fri, 18 Jul 2014 04:05:10 +0300
Message-Id: <1405645513-25616-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance is now happy with frequency ranges where both lower
and upper limit is same.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/airspy/airspy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/airspy/airspy.c b/drivers/staging/media/airspy/airspy.c
index daecd91..5b3310f 100644
--- a/drivers/staging/media/airspy/airspy.c
+++ b/drivers/staging/media/airspy/airspy.c
@@ -62,7 +62,7 @@ static const struct v4l2_frequency_band bands[] = {
 		.index = 0,
 		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
 		.rangelow   = 20000000,
-		.rangehigh  = 20000001, /* FIXME: make v4l2-compliance happy */
+		.rangehigh  = 20000000,
 	},
 };
 
-- 
1.9.3

