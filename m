Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbZELVCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:02:32 -0400
Message-Id: <200905122058.n4CKwj2I004399@imap1.linux-foundation.org>
Subject: [patch 4/4] zoran: fix &&/|| error
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 12 May 2009 13:39:29 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

Fix &&/|| typo. `default_norm' can be 0 (PAL), 1 (NTSC) or 2 (SECAM),
the condition tested was impossible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/zoran/zoran_card.c~zoran-fix-error drivers/media/video/zoran/zoran_card.c
--- a/drivers/media/video/zoran/zoran_card.c~zoran-fix-error
+++ a/drivers/media/video/zoran/zoran_card.c
@@ -1022,7 +1022,7 @@ zr36057_init (struct zoran *zr)
 	zr->vbuf_bytesperline = 0;
 
 	/* Avoid nonsense settings from user for default input/norm */
-	if (default_norm < 0 && default_norm > 2)
+	if (default_norm < 0 || default_norm > 2)
 		default_norm = 0;
 	if (default_norm == 0) {
 		zr->norm = V4L2_STD_PAL;
_
