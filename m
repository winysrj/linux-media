Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1709 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3CRMcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 18/19] solo6x10: disable the 'priv' abuse.
Date: Mon, 18 Mar 2013 13:32:17 +0100
Message-Id: <1363609938-21735-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index e53c985..642ebbf 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -860,8 +860,16 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	/* This does not change the encoder at all */
 	solo_enc->fmt = pix->pixelformat;
 
+	/*
+	 * More information is needed about these 'extended' types. As far
+	 * as I can tell these are basically additional video streams with
+	 * different MPEG encoding attributes that can run in parallel with
+	 * the main stream. If so, then this should be implemented as a
+	 * second video node. Abusing priv like this is certainly not the
+	 * right approach.
 	if (pix->priv)
 		solo_enc->type = SOLO_ENC_TYPE_EXT;
+	 */
 	return 0;
 }
 
-- 
1.7.10.4

