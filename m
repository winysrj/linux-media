Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaICUd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:27 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Changbing Xiong <cb.xiong@samsung.com>
Subject: [PATCH 01/46] [media] dmxdev: don't use before checking file->private_data
Date: Wed,  3 Sep 2014 17:32:33 -0300
Message-Id: <313ddec45cf1a7b3778eaa9fd3acb31f994b2e88.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/dvb-core/dmxdev.c:1091 dvb_demux_poll() warn: variable dereferenced before check 'dmxdevfilter' (see line 1088)

This was introduced by changeset d102cac8097c.

We need to test if dmxdevfilter exists before using it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 42b5e70d5ca7..abff803ad69a 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1085,10 +1085,9 @@ static long dvb_demux_ioctl(struct file *file, unsigned int cmd,
 static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
 {
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
-	struct dmxdev *dmxdev = dmxdevfilter->dev;
 	unsigned int mask = 0;
 
-	if ((!dmxdevfilter) || (dmxdev->exit))
+	if ((!dmxdevfilter) || dmxdevfilter->dev->exit)
 		return POLLERR;
 
 	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
-- 
1.9.3

