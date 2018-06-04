Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53953 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752786AbeFDLrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 16/35] davinci_vpfe: remove bogus vb2->state check
Date: Mon,  4 Jun 2018 13:46:29 +0200
Message-Id: <20180604114648.26159-17-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no need to check the vb2 state in the buf_prepare
callback: it can never be wrong.

Since VB2_BUF_STATE_PREPARED will be removed in the next patch
we'll remove this unnecessary check (and use of that state) first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 390fc98d07dd..edcb07bf653c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1135,10 +1135,6 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_prepare\n");
 
-	if (vb->state != VB2_BUF_STATE_ACTIVE &&
-	    vb->state != VB2_BUF_STATE_PREPARED)
-		return 0;
-
 	/* Initialize buffer */
 	vb2_set_plane_payload(vb, 0, video->fmt.fmt.pix.sizeimage);
 	if (vb2_plane_vaddr(vb, 0) &&
-- 
2.17.0
