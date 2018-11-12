Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:46324 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728847AbeKLSZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 13:25:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCHv2 3/5] vim2m: add tag support
Date: Mon, 12 Nov 2018 09:33:03 +0100
Message-Id: <20181112083305.22618-4-hverkuil@xs4all.nl>
In-Reply-To: <20181112083305.22618-1-hverkuil@xs4all.nl>
References: <20181112083305.22618-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Copy tags in vim2m.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d82db738f174..e6ae5a9ac77e 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -245,9 +245,12 @@ static int device_process(struct vim2m_ctx *ctx,
 
 	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
 		out_vb->timecode = in_vb->timecode;
+	else if (in_vb->flags & V4L2_BUF_FLAG_TAG)
+		out_vb->tag = in_vb->tag;
 	out_vb->field = in_vb->field;
 	out_vb->flags = in_vb->flags &
 		(V4L2_BUF_FLAG_TIMECODE |
+		 V4L2_BUF_FLAG_TAG |
 		 V4L2_BUF_FLAG_KEYFRAME |
 		 V4L2_BUF_FLAG_PFRAME |
 		 V4L2_BUF_FLAG_BFRAME |
-- 
2.19.1
