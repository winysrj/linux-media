Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50584 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbbA2BoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/7] [media] radio/aimslab: use mdelay instead of udelay
Date: Wed, 28 Jan 2015 22:17:42 +0100
Message-Id: <1422479867-3370921-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Large udelay values are not allowed on the ARM architecture
and result in a build error like

ERROR: "__bad_udelay" [drivers/media/radio/radio-aimslab.ko] undefined!

This changes the aimslab radio driver to use an equivalent mdelay
statement.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-aimslab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index a739ad492e7b..ea9308796741 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -129,11 +129,11 @@ static int rtrack_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 	} else if (curvol < vol) {
 		outb(0x98, isa->io);	/* volume up + sigstr + on	*/
 		for (; curvol < vol; curvol++)
-			udelay(3000);
+			mdelay(3);
 	} else if (curvol > vol) {
 		outb(0x58, isa->io);	/* volume down + sigstr + on	*/
 		for (; curvol > vol; curvol--)
-			udelay(3000);
+			mdelay(3);
 	}
 	outb(0xd8, isa->io);		/* volume steady + sigstr + on	*/
 	rt->curvol = vol;
-- 
2.1.0.rc2

