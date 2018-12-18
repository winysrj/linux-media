Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA69C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 18:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7245E21873
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545156015;
	bh=vcOpZ64UbpuHVzYcsDfSgK+DUBae7FEIqil/27Ei2oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LHZDc27vDNwtsRUXEYoAGnweWsP90NevfCZ+d/W3srjwevvazcd6aj87QMsh1uctP
	 +SNY9HmOqugYcKjbC3TIJNTMYZzqUvD3EevOXqbCjwcw77ZZrS2lJ+UGQLRGypQ6Xq
	 f5A3A6ODLZsh375QwQi5ifPgAvaqn/RBxG4r7zqo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbeLRSAJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 13:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbeLRR7p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 12:59:45 -0500
Received: from localhost.localdomain (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0A821873;
        Tue, 18 Dec 2018 17:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545155984;
        bh=vcOpZ64UbpuHVzYcsDfSgK+DUBae7FEIqil/27Ei2oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQRXHxSy/1Z8SUKHNvUB+YEW/9/1Uh2J4UDgYYbGK9CF0mB7+0F9W+gffqqvoO/G4
         35FpP/nJouEKDq6wQO+hUdQfOzLUH+n370FpSR8vnVrGILNEw1gjp8JxxkPzvCnu4f
         YcFqKWbaodTMrhbEuz6kXju+Qrj44xs2IL4kSwCg=
From:   shuah@kernel.org
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v9 2/4] media: change au0828 to use Media Device Allocator API
Date:   Tue, 18 Dec 2018 10:59:37 -0700
Message-Id: <cb64bdd0a90c7084b23857160b6471118cd80c94.1545154778.git.shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1545154777.git.shuah@kernel.org>
References: <cover.1545154777.git.shuah@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Shuah Khan <shuah@kernel.org>

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
index 1fdb1601dc65..4b0a395d59aa 100644
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
index 004eadef55c7..7dbe3db15ebe 100644
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

