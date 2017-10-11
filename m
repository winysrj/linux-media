Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36386 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751906AbdJKTgK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 15:36:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] Simplify major/minor non-dynamic logic
Date: Wed, 11 Oct 2017 15:36:04 -0400
Message-Id: <8382e556b1a2f30c4bf866f021b33577a64f9ebf.1507750393.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 6bbf7a855d20 ("media: dvbdev: convert DVB device types into an enum")
added a new warning on gcc 6:

>> drivers/media/dvb-core/dvbdev.c:86:1: warning: control reaches end of non-void function [-Wreturn-type]

That's because gcc is not smart enough to see that all types are
present at the switch. Also, the current code is not too optimized.

So, replace it to a more optimized one, based on a static table.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Fixes: 6bbf7a855d20 ("media: dvbdev: convert DVB device types into an enum")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
I actually suggested this patch to be fold with changeset 6bbf7a855d20.
Unfortunately, I actually forgot to do that (I guess I did, but on a different
machine than the one I used today to pick it).

Anyway, that saves some code space with static minors and cleans up
a warning. So, let's apply it.

 drivers/media/dvb-core/dvbdev.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index a53eb53a4fd5..060c60ddfcc3 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -68,22 +68,20 @@ static const char * const dnames[] = {
 #else
 #define DVB_MAX_IDS		4
 
-static int nums2minor(int num, enum dvb_device_type type, int id)
-{
-	int n = (num << 6) | (id << 4);
+static const u8 minor_type[] = {
+       [DVB_DEVICE_VIDEO]      = 0,
+       [DVB_DEVICE_AUDIO]      = 1,
+       [DVB_DEVICE_SEC]        = 2,
+       [DVB_DEVICE_FRONTEND]   = 3,
+       [DVB_DEVICE_DEMUX]      = 4,
+       [DVB_DEVICE_DVR]        = 5,
+       [DVB_DEVICE_CA]         = 6,
+       [DVB_DEVICE_NET]        = 7,
+       [DVB_DEVICE_OSD]        = 8,
+};
 
-	switch (type) {
-	case DVB_DEVICE_VIDEO:		return n;
-	case DVB_DEVICE_AUDIO:		return n | 1;
-	case DVB_DEVICE_SEC:		return n | 2;
-	case DVB_DEVICE_FRONTEND:	return n | 3;
-	case DVB_DEVICE_DEMUX:		return n | 4;
-	case DVB_DEVICE_DVR:		return n | 5;
-	case DVB_DEVICE_CA:		return n | 6;
-	case DVB_DEVICE_NET:		return n | 7;
-	case DVB_DEVICE_OSD:		return n | 8;
-	}
-}
+#define nums2minor(num, type, id) \
+       (((num) << 6) | ((id) << 4) | minor_type[type])
 
 #define MAX_DVB_MINORS		(DVB_MAX_ADAPTERS*64)
 #endif
-- 
2.13.6
