Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2573 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2HAHcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 03:32:36 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id q717WXPe057811
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 1 Aug 2012 09:32:34 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.186])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 7A0C746A0001
	for <linux-media@vger.kernel.org>; Wed,  1 Aug 2012 09:32:33 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.6] Fix mem2mem_testdev querycap regression
Date: Wed, 1 Aug 2012 09:32:33 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208010932.33074.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trival but important patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 7efe9ad..0b91a5c 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -431,7 +431,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
 	strlcpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
