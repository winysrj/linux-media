Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3043 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaHUUTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/12] cx25821: fix sparse warning
Date: Thu, 21 Aug 2014 22:19:27 +0200
Message-Id: <1408652376-39525-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cx25821/cx25821-video-upstream.c:334:25: warning: incorrect type in argument 2 (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video-upstream.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 1f43be0..a664997 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -330,8 +330,9 @@ int cx25821_write_frame(struct cx25821_channel *chan,
 
 	if (frame_size - curpos < count)
 		count = frame_size - curpos;
-	memcpy((char *)out->_data_buf_virt_addr + frame_offset + curpos,
-			data, count);
+	if (copy_from_user((__force char *)out->_data_buf_virt_addr + frame_offset + curpos,
+				data, count))
+		return -EFAULT;
 	curpos += count;
 	if (curpos == frame_size) {
 		out->_frame_count++;
-- 
2.1.0.rc1

