Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:60117 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbcCDCZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 21:25:03 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, olli.salonen@iki.fi
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix null pointer dereference in v4l_vb2q_enable_media_source()
Date: Thu,  3 Mar 2016 19:24:58 -0700
Message-Id: <1457058298-7782-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the null pointer dereference in v4l_vb2q_enable_media_source().
DVB only drivers don't have valid struct v4l2_fh pointer.

[  548.443272] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[  548.452036] IP: [<ffffffffc020ffc9>]
v4l_vb2q_enable_media_source+0x9/0x50 [videodev]
[  548.460792] PGD b820e067 PUD bb3df067 PMD 0
[  548.465582] Oops: 0000 [#1] SMP

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Reported-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/v4l2-core/v4l2-mc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 643686d..a39a3cd 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -214,6 +214,8 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 {
 	struct v4l2_fh *fh = q->owner;
 
-	return v4l_enable_media_source(fh->vdev);
+	if (fh && fh->vdev)
+		return v4l_enable_media_source(fh->vdev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
-- 
2.5.0

