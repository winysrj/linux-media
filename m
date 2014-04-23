Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2741 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaDWOcP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 10:32:15 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s3NEWBJd000189
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 16:32:13 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7DA9A2A199E
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 16:32:11 +0200 (CEST)
Message-ID: <5357CEEB.5040809@xs4all.nl>
Date: Wed, 23 Apr 2014 16:32:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-pci-skeleton: fix typo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 53dd346..46904fe 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -174,7 +174,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		 * You cannot use read() with FIELD_ALTERNATE since the field
 		 * information (TOP/BOTTOM) cannot be passed back to the user.
 		 */
-		if (vb2_fileio_is_active(q))
+		if (vb2_fileio_is_active(vq))
 			return -EINVAL;
 		skel->field = V4L2_FIELD_TOP;
 	}
