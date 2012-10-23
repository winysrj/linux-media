Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:50283 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab2JWRHG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 13:07:06 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] [media] vivi: Kill TSTAMP_* macros
Date: Tue, 23 Oct 2012 21:07:55 +0400
Message-Id: <1351012075-4845-1-git-send-email-kirr@mns.spb.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Usage of TSTAMP_* macros has gone in 2010 in 730947bc (V4L/DVB: vivi:
clean up and a major overhaul) but the macros remain. Say goodbye to
them.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 3adea58..bfac13d 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -356,11 +356,6 @@ static void precalculate_bars(struct vivi_dev *dev)
 	}
 }
 
-#define TSTAMP_MIN_Y	24
-#define TSTAMP_MAX_Y	(TSTAMP_MIN_Y + 15)
-#define TSTAMP_INPUT_X	10
-#define TSTAMP_MIN_X	(54 + TSTAMP_INPUT_X)
-
 /* 'odd' is true for pixels 1, 3, 5, etc. and false for pixels 0, 2, 4, etc. */
 static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 {
-- 
1.8.0.rc3.331.g5b9a629

