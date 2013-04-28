Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab3D1Pr5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:47:57 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFlv4p027454
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:47:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 7/9] [media] drxk_hard.h: don't use more than 80 columns
Date: Sun, 28 Apr 2013 12:47:49 -0300
Message-Id: <1367164071-11468-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Almost all 80-col warnings are related to comments. There's
one, however, that it is due to a one-line enum declaration
for enum agc_ctrl_mode.

Break it into one line per enumered data.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.h b/drivers/media/dvb-frontends/drxk_hard.h
index e77d9f0..bae9c71 100644
--- a/drivers/media/dvb-frontends/drxk_hard.h
+++ b/drivers/media/dvb-frontends/drxk_hard.h
@@ -93,7 +93,12 @@ enum drx_power_mode {
 #endif
 
 
-enum agc_ctrl_mode { DRXK_AGC_CTRL_AUTO = 0, DRXK_AGC_CTRL_USER, DRXK_AGC_CTRL_OFF };
+enum agc_ctrl_mode {
+	DRXK_AGC_CTRL_AUTO = 0,
+	DRXK_AGC_CTRL_USER,
+	DRXK_AGC_CTRL_OFF
+};
+
 enum e_drxk_state {
 	DRXK_UNINITIALIZED = 0,
 	DRXK_STOPPED,
-- 
1.8.1.4

