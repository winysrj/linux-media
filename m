Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbbD3OIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:52 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 06/22] m2m-deinterlace: remove dead code
Date: Thu, 30 Apr 2015 11:08:26 -0300
Message-Id: <812cec75b047f06d96385c1192f53f9a20b2d6e6.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/m2m-deinterlace.c:1063 deinterlace_probe() info: ignoring unreachable code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 92d954973ccf..c07f367aa436 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1060,7 +1060,6 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 	return 0;
 
-	v4l2_m2m_release(pcdev->m2m_dev);
 err_m2m:
 	video_unregister_device(&pcdev->vfd);
 err_ctx:
-- 
2.1.0

