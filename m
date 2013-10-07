Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:59763 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3JGLd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 07:33:56 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	ismael.luceno@corp.bluecherry.net
Date: Mon, 07 Oct 2013 13:33:55 +0200
MIME-Version: 1.0
Message-ID: <m3pprh8gd8.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] SOLO6x10: Fix video frame type (I/P/B).
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 7a2fd98..27e9a0a 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -506,6 +506,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		return -EIO;
 
 	/* If this is a key frame, add extra header */
+	vb->v4l2_buf.flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME);
 	if (!vop_type(vh)) {
 		skip = solo_enc->vop_len;
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
