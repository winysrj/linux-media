Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcBCWcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2016 17:32:03 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] [media] vb2-core: call threadio->fnc() if !VB2_BUF_STATE_ERROR
Date: Wed,  3 Feb 2016 20:30:46 -0200
Message-Id: <788b10195174037a7d3d3011c9f2a4a7170bc0a8.1454538542.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 70433a152f0 ("media: videobuf2: Refactor vb2_fileio_data
and vb2_thread") broke videobuf2-dvb.

The root cause is that, instead of calling threadio->fnc() for
all types of events except for VB2_BUF_STATE_ERROR, it was calling
it only for VB2_BUF_STATE_DONE.

With that, the DVB thread were never called.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Junghak Sung <jh1009.sung@samsung.com>
Cc: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

This patch should be applied after https://patchwork.linuxtv.org/patch/32734/

 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 27b3ed01ce4d..dab94080ec3a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2743,7 +2743,7 @@ static int vb2_thread(void *data)
 			break;
 		try_to_freeze();
 
-		if (vb->state == VB2_BUF_STATE_DONE)
+		if (vb->state != VB2_BUF_STATE_ERROR)
 			if (threadio->fnc(vb, threadio->priv))
 				break;
 		call_void_qop(q, wait_finish, q);
-- 
2.5.0


