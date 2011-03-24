Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab1CXUHG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 16:07:06 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, devel@driverdev.osuosl.org
Subject: [PATCH] tm6000: fix vbuf may be used uninitialized
Date: Thu, 24 Mar 2011 16:07:00 -0400
Message-Id: <1300997220-4354-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
CC: devel@driverdev.osuosl.org
---
 drivers/staging/tm6000/tm6000-video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c80a316..bfebedd 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -228,7 +228,7 @@ static int copy_streams(u8 *data, unsigned long len,
 	unsigned long header = 0;
 	int rc = 0;
 	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
-	struct tm6000_buffer *vbuf;
+	struct tm6000_buffer *vbuf = NULL;
 	char *voutp = NULL;
 	unsigned int linewidth;
 
-- 
1.7.1

