Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2827 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3EaKDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 13/21] radio-timb: actually load the requested subdevs
Date: Fri, 31 May 2013 12:02:33 +0200
Message-Id: <1369994561-25236-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For some reason the tuner and dsp subdevs were never actually loaded.
Added the relevant code to do that.

Also remove bogus calls to video_device_release_empty().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/radio/radio-timb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 99694dd..1931ef7 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -126,6 +126,15 @@ static int timbradio_probe(struct platform_device *pdev)
 
 	tr->video_dev.v4l2_dev = &tr->v4l2_dev;
 
+	tr->sd_tuner = v4l2_i2c_new_subdev_board(&tr->v4l2_dev,
+		i2c_get_adapter(pdata->i2c_adapter), pdata->tuner, NULL);
+	tr->sd_dsp = v4l2_i2c_new_subdev_board(&tr->v4l2_dev,
+		i2c_get_adapter(pdata->i2c_adapter), pdata->dsp, NULL);
+	if (tr->sd_tuner == NULL || tr->sd_dsp == NULL)
+		goto err_video_req;
+
+	tr->v4l2_dev.ctrl_handler = tr->sd_dsp->ctrl_handler;
+
 	err = video_register_device(&tr->video_dev, VFL_TYPE_RADIO, -1);
 	if (err) {
 		dev_err(&pdev->dev, "Error reg video\n");
@@ -138,7 +147,6 @@ static int timbradio_probe(struct platform_device *pdev)
 	return 0;
 
 err_video_req:
-	video_device_release_empty(&tr->video_dev);
 	v4l2_device_unregister(&tr->v4l2_dev);
 err:
 	dev_err(&pdev->dev, "Failed to register: %d\n", err);
@@ -151,10 +159,7 @@ static int timbradio_remove(struct platform_device *pdev)
 	struct timbradio *tr = platform_get_drvdata(pdev);
 
 	video_unregister_device(&tr->video_dev);
-	video_device_release_empty(&tr->video_dev);
-
 	v4l2_device_unregister(&tr->v4l2_dev);
-
 	return 0;
 }
 
-- 
1.7.10.4

