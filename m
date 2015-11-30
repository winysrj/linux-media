Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59683 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbbK3U1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/11] cx25840: relax a Vsrc check
Date: Mon, 30 Nov 2015 21:27:16 +0100
Message-Id: <1448915241-415-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cx23888 reports a slightly different Vsrc value than the other
chip variants do. Relax the check by 1, otherwise cx25840_set_fmt()
would fail for the cx23888.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index a741c30..d8b5343 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1390,8 +1390,14 @@ static int cx25840_set_fmt(struct v4l2_subdev *sd,
 
 	Vlines = fmt->height + (is_50Hz ? 4 : 7);
 
+	/*
+	 * We keep 1 margin for the Vsrc < Vlines check since the
+	 * cx23888 reports a Vsrc of 486 instead of 487 for the NTSC
+	 * height. Without that margin the cx23885 fails in this
+	 * check.
+	 */
 	if ((fmt->width * 16 < Hsrc) || (Hsrc < fmt->width) ||
-			(Vlines * 8 < Vsrc) || (Vsrc < Vlines)) {
+			(Vlines * 8 < Vsrc) || (Vsrc + 1 < Vlines)) {
 		v4l_err(client, "%dx%d is not a valid size!\n",
 				fmt->width, fmt->height);
 		return -ERANGE;
-- 
2.6.2

