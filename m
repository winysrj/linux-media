Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32911 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2IQKdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 06:33:00 -0400
Received: from localhost.localdomain (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q8HB5RF0000776
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 12:05:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] v4l2: spi modalias is an array
To: linux-media@vger.kernel.org
Date: Mon, 17 Sep 2012 11:51:27 +0100
Message-ID: <20120917105124.29964.72985.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

We want to check the contents not the array itself versus NULL

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/v4l2-core/v4l2-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 105f88c..415874f 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -443,7 +443,7 @@ struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
 
 	BUG_ON(!v4l2_dev);
 
-	if (info->modalias)
+	if (info->modalias[0])
 		request_module(info->modalias);
 
 	spi = spi_new_device(master, info);

