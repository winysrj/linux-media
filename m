Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbbFEO2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 07/11] [media] tm6000: remove needless check
Date: Fri,  5 Jun 2015 11:27:40 -0300
Message-Id: <c849e2ce6d9085a6b3ee5c61db3d87a6ffa4c9b6.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch reports a warning:
	drivers/media/usb/tm6000/tm6000-video.c:646 tm6000_prepare_isoc() error: we previously assumed 'dev->urb_buffer' could be null (see line 624)

This is not really a problem, but it actually shows that the check
if urb_buffer is NULL is being done twice: at the if and at
tm6000_alloc_urb_buffers().

We don't need to do it twice. So, remove the extra check. The code
become cleaner, and, as a collateral effect, smatch becomes happy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 77ce9efe1f24..5287d2960282 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -621,7 +621,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 		    dev->isoc_in.maxsize, size);
 
 
-	if (!dev->urb_buffer && tm6000_alloc_urb_buffers(dev) < 0) {
+	if (tm6000_alloc_urb_buffers(dev) < 0) {
 		tm6000_err("cannot allocate memory for urb buffers\n");
 
 		/* call free, as some buffers might have been allocated */
-- 
2.4.2

