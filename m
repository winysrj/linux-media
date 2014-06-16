Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1058 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaFPHcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 03:32:53 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s5G7WnkT038785
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 09:32:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 22F552A1FCC
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 09:32:37 +0200 (CEST)
Message-ID: <539E9D95.2060003@xs4all.nl>
Date: Mon, 16 Jun 2014 09:32:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.16] saa7134: use unlocked_ioctl instead of ioctl.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The saa7134 driver uses core-locking, so there is no longer any need
to use the ioctl op instead of the unlocked_ioctl op. This change
was forgotten for the saa7134-empress.c, so fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index e65c760..0006d6b 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -179,7 +179,7 @@ static const struct v4l2_file_operations ts_fops =
 	.read	  = vb2_fop_read,
 	.poll	  = vb2_fop_poll,
 	.mmap	  = vb2_fop_mmap,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops ts_ioctl_ops = {
-- 
2.0.0

