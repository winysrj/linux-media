Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3542 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2GSUp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 16:45:58 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id q6JKjtJh045981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 22:45:56 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.195])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 4969A35E0007
	for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 22:45:50 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] vivi: remove pointless video_nr++
Date: Thu, 19 Jul 2012 22:45:49 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207192245.49852.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the pointless video_nr++. It doesn't do anything useful and it has
the unexpected side-effect of changing the video_nr module option, so
cat /sys/module/vivi/parameters/video_nr gives a different value back
then what was specified with modprobe.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 1e8c4f3..679e329 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1330,9 +1330,6 @@ static int __init vivi_create_instance(int inst)
 	/* Now that everything is fine, let's add it to device list */
 	list_add_tail(&dev->vivi_devlist, &vivi_devlist);
 
-	if (video_nr != -1)
-		video_nr++;
-
 	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
 		  video_device_node_name(vfd));
 	return 0;
