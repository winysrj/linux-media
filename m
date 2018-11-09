Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47935 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728097AbeKITgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 14:36:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/5] vim2m: add cookie support
Date: Fri,  9 Nov 2018 10:56:11 +0100
Message-Id: <20181109095613.28272-4-hverkuil@xs4all.nl>
In-Reply-To: <20181109095613.28272-1-hverkuil@xs4all.nl>
References: <20181109095613.28272-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Copy cookies in vim2m.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d82db738f174..daf83d01f1c8 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -245,9 +245,12 @@ static int device_process(struct vim2m_ctx *ctx,
 
 	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
 		out_vb->timecode = in_vb->timecode;
+	else if (in_vb->flags & V4L2_BUF_FLAG_COOKIE)
+		out_vb->cookie = in_vb->cookie;
 	out_vb->field = in_vb->field;
 	out_vb->flags = in_vb->flags &
 		(V4L2_BUF_FLAG_TIMECODE |
+		 V4L2_BUF_FLAG_COOKIE |
 		 V4L2_BUF_FLAG_KEYFRAME |
 		 V4L2_BUF_FLAG_PFRAME |
 		 V4L2_BUF_FLAG_BFRAME |
-- 
2.19.1
