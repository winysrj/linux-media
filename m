Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756790AbZHFXB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:01:27 -0400
Message-Id: <200908062301.n76N1IE5030049@imap1.linux-foundation.org>
Subject: [patch 7/9] stk-webcam: read buffer overflow
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com, hverkuil@xs4all.nl, xyzzy@speakeasy.org
From: akpm@linux-foundation.org
Date: Thu, 06 Aug 2009 16:01:18 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

It tested the value of stk_sizes[i].m before checking whether i was in range.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/stk-webcam.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/stk-webcam.c~stk-webcam-read-buffer-overflow drivers/media/video/stk-webcam.c
--- a/drivers/media/video/stk-webcam.c~stk-webcam-read-buffer-overflow
+++ a/drivers/media/video/stk-webcam.c
@@ -1050,8 +1050,8 @@ static int stk_setup_format(struct stk_c
 		depth = 1;
 	else
 		depth = 2;
-	while (stk_sizes[i].m != dev->vsettings.mode
-			&& i < ARRAY_SIZE(stk_sizes))
+	while (i < ARRAY_SIZE(stk_sizes) &&
+			stk_sizes[i].m != dev->vsettings.mode)
 		i++;
 	if (i == ARRAY_SIZE(stk_sizes)) {
 		STK_ERROR("Something is broken in %s\n", __func__);
_
