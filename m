Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4316 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3JDOCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/14] radio-keene: fix sparse warning
Date: Fri,  4 Oct 2013 16:01:47 +0200
Message-Id: <1380895312-30863-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/radio/radio-keene.c:126:45: warning: dubious: !x | y

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-keene.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 21db23b..fa39640 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -123,7 +123,7 @@ static int keene_cmd_set(struct keene_device *radio)
 	/* If bit 0 is set, then transmit mono, otherwise stereo.
 	   If bit 2 is set, then enable 75 us preemphasis, otherwise
 	   it is 50 us. */
-	radio->buffer[3] = (!radio->stereo) | (radio->preemph_75_us ? 4 : 0);
+	radio->buffer[3] = (radio->stereo ? 0 : 1) | (radio->preemph_75_us ? 4 : 0);
 	radio->buffer[4] = 0x00;
 	radio->buffer[5] = 0x00;
 	radio->buffer[6] = 0x00;
-- 
1.8.3.2

