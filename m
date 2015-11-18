Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbbKROz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 09:55:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] [media] fix dvb_frontend_sleep_until() logic
Date: Wed, 18 Nov 2015 12:55:47 -0200
Message-Id: <aa7a865d4f9ca8b7e668ac126a8980af79ec272f.1447858534.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed by Laurent Navet:
	"Calling ktime_add_us() seems useless as is only useful
	 for it's return value which is ignored."

That's reported by coverity CID 1309761.

Laurent proposed to just remove ktime_add_us, but the fact is that
the logic of this function is broken. Instead, we need to use the
value of the timeout, and ensure that it will work on the loops
to emulate the legacy DiSEqC ioctl (FE_DISHNETWORK_SEND_LEGACY_CMD).

Please notice that the logic was also broken if, for any reason,
msleep() would sleep a little less than what it was expected, as
newdelta would be smaller than delta, and udelay() would not be called.

It should also be noticed that nobody noticed that trouble before
likely because the FE_DISHNETWORK_SEND_LEGACY_CMD is not used
anymore by modern DVB applications.

Reported-by: Laurent Navet <laurent.navet@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 0b52cfc2d53d..291093b8cd05 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -899,14 +899,13 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
  */
 void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec)
 {
-	s32 delta, newdelta;
+	s32 delta;
 
-	ktime_add_us(*waketime, add_usec);
+	*waketime = ktime_add_us(*waketime, add_usec);
 	delta = ktime_us_delta(ktime_get_real(), *waketime);
 	if (delta > 2500) {
 		msleep((delta - 1500) / 1000);
-		newdelta = ktime_us_delta(ktime_get_real(), *waketime);
-		delta = (newdelta > delta) ? 0 : newdelta;
+		delta = ktime_us_delta(ktime_get_real(), *waketime);
 	}
 	if (delta > 0)
 		udelay(delta);
-- 
2.5.0

