Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0119EC4360F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C461B2087E
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553653522;
	bh=Z1YLSoXrzPTy8eJWeIXf4avvmwPIXBXh+2UCxym7KgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mfFPU9I9jMAt3HAvN7lceWRWw3I+zvcGY7tn5uM82HwYfwXfslXH/ZH/bh7Uo+g8j
	 HB8kty4sUbxY91AqEp1S28GGqUyfQG1V+nyiWfqFvz2rvd8bswCH+aTBsrKzllEpWE
	 oq4t2bRtMn951tZokakZZlN0ssiVcnbOhGS9U9dA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732642AbfC0CY6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 22:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732606AbfC0CY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 22:24:58 -0400
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AEA221473;
        Wed, 27 Mar 2019 02:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553653497;
        bh=Z1YLSoXrzPTy8eJWeIXf4avvmwPIXBXh+2UCxym7KgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTvRQXLvhW1ev1YUXuW6QIqXNsUjRlJTGvv6+T8r0jWkSctXy/tMqWzcNJclY8QPJ
         k38l4r1PLdEAgVxeVTJE/xYSHjsI012E6ZZc4treUOgsOtujPrTaE1T2nO4ZKNCvbd
         tE+Y29hFv9UG9/DBx1KnnfvElkouFqgN/WXkOvT0=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v12 2/5] media: change au0828 to use Media Device Allocator API
Date:   Tue, 26 Mar 2019 20:24:49 -0600
Message-Id: <bc7e8be5d620766f3bdd041430a6671262c14e97.1553634246.git.shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1553634246.git.shuah@kernel.org>
References: <cover.1553634246.git.shuah@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Media Device Allocator API to allows multiple drivers share a media device.
This API solves a very common use-case for media devices where one physical
device (an USB stick) provides both audio and video. When such media device
exposes a standard USB Audio class, a proprietary Video class, two or more
independent drivers will share a single physical USB bridge. In such cases,
it is necessary to coordinate access to the shared resource.

Using this API, drivers can allocate a media device with the shared struct
device as the key. Once the media device is allocated by a driver, other
drivers can get a reference to it. The media device is released when all
the references are released.

Change au0828 to use Media Device Allocator API to allocate media device
with the parent usb struct device as the key, so it can be shared with the
snd_usb_audio driver.

Signed-off-by: Shuah Khan <shuah@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 12 ++++--------
 drivers/media/usb/au0828/au0828.h      |  1 +
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 3f8c92a70116..8167e50b7bc4 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -155,9 +155,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	dev->media_dev->disable_source = NULL;
 	mutex_unlock(&mdev->graph_mutex);
 
-	media_device_unregister(dev->media_dev);
-	media_device_cleanup(dev->media_dev);
-	kfree(dev->media_dev);
+	media_device_delete(dev->media_dev, KBUILD_MODNAME);
 	dev->media_dev = NULL;
 #endif
 }
@@ -210,14 +208,10 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = media_device_usb_allocate(udev, KBUILD_MODNAME);
 	if (!mdev)
 		return -ENOMEM;
 
-	/* check if media device is already initialized */
-	if (!mdev->dev)
-		media_device_usb_init(mdev, udev, udev->product);
-
 	dev->media_dev = mdev;
 #endif
 	return 0;
@@ -480,6 +474,8 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
 		if (ret) {
+			media_device_delete(dev->media_dev, KBUILD_MODNAME);
+			dev->media_dev = NULL;
 			dev_err(&udev->dev,
 				"Media Device Register Error: %d\n", ret);
 			return ret;
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 425c35d16057..57b00de8d3f2 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -31,6 +31,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/media-device.h>
+#include <media/media-dev-allocator.h>
 
 /* DVB */
 #include <media/demux.h>
-- 
2.17.1

