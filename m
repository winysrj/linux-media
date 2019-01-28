Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4103C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 15:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8554220880
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 15:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548690364;
	bh=RxptdGV+4lXa+UrJ0V0gXU2CCI3yBbOLulbz1uCUKWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eADmQCO+RfsqBVVj1wNIJ/YjWEgeQWrfrfpzYAqpz0xkzEBrFW6c3CcjfaQM5GRTt
	 3BGHzKbRjC/cyricC5E60DCYNypNXcn5X7QygWWIEJZTqgnIDhCDO9ScaSnpKx5b8U
	 7KIFau6SPA5n6fR20omZPMJ4798b9Pl/B+uygMPI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfA1PqD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfA1PqC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 10:46:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B01CF2177E;
        Mon, 28 Jan 2019 15:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690361;
        bh=RxptdGV+4lXa+UrJ0V0gXU2CCI3yBbOLulbz1uCUKWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQQ/s8UZLB7i0a6drN72Y+p/e/ayMVIKFAs3rxbUs0Xk5QzaLs0XV0KqO/meUuT0k
         VNqQ1ti2xb59IlVLLKHRItmcveXl8lL3EH/McLEWjdEvfLzio6by6VB/aZkNqwpPXq
         4xmkbav9xDumtaK/mMTyz2qsKycUy7J9tZIEEqrQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 064/304] media: video-i2c: avoid accessing released memory area when removing driver
Date:   Mon, 28 Jan 2019 10:39:41 -0500
Message-Id: <20190128154341.47195-64-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit c764da98a600a4b068d25c77164f092f159cecec ]

The video device release() callback for video-i2c driver frees the whole
struct video_i2c_data.  If there is no user left for the video device
when video_unregister_device() is called, the release callback is executed.

However, in video_i2c_remove() some fields (v4l2_dev, lock, and queue_lock)
in struct video_i2c_data are still accessed after video_unregister_device()
is called.

This fixes the use after free by moving the code from video_i2c_remove()
to the release() callback.

Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")

Reviewed-by: Matt Ranostay <matt.ranostay@konsulko.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/video-i2c.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 4d49af86c15e..ec0758dca2fc 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -510,7 +510,12 @@ static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
 
 static void video_i2c_release(struct video_device *vdev)
 {
-	kfree(video_get_drvdata(vdev));
+	struct video_i2c_data *data = video_get_drvdata(vdev);
+
+	v4l2_device_unregister(&data->v4l2_dev);
+	mutex_destroy(&data->lock);
+	mutex_destroy(&data->queue_lock);
+	kfree(data);
 }
 
 static int video_i2c_probe(struct i2c_client *client,
@@ -608,10 +613,6 @@ static int video_i2c_remove(struct i2c_client *client)
 	struct video_i2c_data *data = i2c_get_clientdata(client);
 
 	video_unregister_device(&data->vdev);
-	v4l2_device_unregister(&data->v4l2_dev);
-
-	mutex_destroy(&data->lock);
-	mutex_destroy(&data->queue_lock);
 
 	return 0;
 }
-- 
2.19.1

