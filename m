Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031140AbbD1XGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:06:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 11/13] zc3xx: don't go past quality array
Date: Tue, 28 Apr 2015 20:06:18 -0300
Message-Id: <6e5347386be7eeb807715d6698219854eba7823e.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
References: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/gspca/zc3xx.c:6363 zcxx_s_ctrl() error: buffer overflow 'jpeg_qual' 3 <= 3

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index d3e1b6d8bf49..3762a045f744 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -6360,7 +6360,7 @@ static int zcxx_s_ctrl(struct v4l2_ctrl *ctrl)
 			if (ctrl->val <= jpeg_qual[i])
 				break;
 		}
-		if (i > 0 && i == qual && ctrl->val < jpeg_qual[i])
+		if (i == ARRAY_SIZE(jpeg_qual) || (i > 0 && i == qual && ctrl->val < jpeg_qual[i]))
 			i--;
 
 		/* With high quality settings we need max bandwidth */
-- 
2.1.0

