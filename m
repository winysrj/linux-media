Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:45562 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728810AbeKLSZU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 13:25:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCHv2 4/5] vicodec: add tag support
Date: Mon, 12 Nov 2018 09:33:04 +0100
Message-Id: <20181112083305.22618-5-hverkuil@xs4all.nl>
In-Reply-To: <20181112083305.22618-1-hverkuil@xs4all.nl>
References: <20181112083305.22618-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Copy tags in vicodec.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b292cff26c86..4a6b9e841508 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -194,10 +194,13 @@ static int device_process(struct vicodec_ctx *ctx,
 
 	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
 		out_vb->timecode = in_vb->timecode;
+	else if (in_vb->flags & V4L2_BUF_FLAG_TAG)
+		out_vb->tag = in_vb->tag;
 	out_vb->field = in_vb->field;
 	out_vb->flags &= ~V4L2_BUF_FLAG_LAST;
 	out_vb->flags |= in_vb->flags &
 		(V4L2_BUF_FLAG_TIMECODE |
+		 V4L2_BUF_FLAG_TAG |
 		 V4L2_BUF_FLAG_KEYFRAME |
 		 V4L2_BUF_FLAG_PFRAME |
 		 V4L2_BUF_FLAG_BFRAME |
-- 
2.19.1
