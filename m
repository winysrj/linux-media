Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbeHHRNB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 13:13:01 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/6] media: radio-wl1273: fix return code for the polling routine
Date: Wed,  8 Aug 2018 10:52:54 -0400
Message-Id: <0d8ff43fefdef24efba952540c557b8f2b418ac3.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All poll handlers should return a poll flag, and not error codes. So,
instead of returning an error, do the right thing here,
e. g. to return EPOLERR on errors, just like the V4L2 VB2 code.

Solves the following sparse warning:
    drivers/media/radio/radio-wl1273.c:1099:24: warning: incorrect type in return expression (different base types)
    drivers/media/radio/radio-wl1273.c:1099:24:    expected restricted __poll_t
    drivers/media/radio/radio-wl1273.c:1099:24:    got int

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/radio/radio-wl1273.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 8f9f8dfc3497..11aa94f189cb 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1096,7 +1096,7 @@ static __poll_t wl1273_fm_fops_poll(struct file *file,
 	struct wl1273_core *core = radio->core;
 
 	if (radio->owner && radio->owner != file)
-		return -EBUSY;
+		return EPOLLERR;
 
 	radio->owner = file;
 
-- 
2.17.1
