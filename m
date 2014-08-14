Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3794 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbaHNJyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 08/20] cx23885: map invalid fields to a valid field.
Date: Thu, 14 Aug 2014 11:53:53 +0200
Message-Id: <1408010045-24016-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ad02912..9bb19fd 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -948,7 +948,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	case V4L2_FIELD_INTERLACED:
 		break;
 	default:
-		return -EINVAL;
+		field = V4L2_FIELD_INTERLACED;
+		break;
 	}
 
 	f->fmt.pix.field = field;
-- 
2.1.0.rc1

