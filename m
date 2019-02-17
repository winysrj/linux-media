Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80565C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 14:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504C721917
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 14:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfBQOMq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 09:12:46 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:35836 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbfBQOMq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 09:12:46 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id vNBRgUWWQ4HFnvNBUgx1U0; Sun, 17 Feb 2019 15:12:44 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: two unregistration fixes
Message-ID: <f017af06-4810-9307-4de3-e32b3185bfa6@xs4all.nl>
Date:   Sun, 17 Feb 2019 15:12:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGddqE37B8OqkVfXTotirie4NVMuihMFZueleHyK7kOY0j1ZuKmFfbVmCEOaqGnRXoxXM9P+uC2vMoEsfQG7mtPKJggPCVEAsrHYW/7hZBqp85vElhfx
 f4sw4NIXW63wgkAuru6BzZYyl1t5Jnzwsjf70/wRtx27ZPtsvpRgSYe1FnFltqhzztdP0i6lOIRoYw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When the media device registration fails, don't call media_device_unregister
since the device was never actually registered.

When removing the module also call media_device_cleanup() to avoid a memory leak.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 29e7b14fa704..342e0e6c103b 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1478,9 +1478,6 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	return 0;

 unreg_dev:
-#ifdef CONFIG_MEDIA_CONTROLLER
-	media_device_unregister(&dev->mdev);
-#endif
 	video_unregister_device(&dev->radio_tx_dev);
 	video_unregister_device(&dev->radio_rx_dev);
 	video_unregister_device(&dev->sdr_cap_dev);
@@ -1553,6 +1550,7 @@ static int vivid_remove(struct platform_device *pdev)

 #ifdef CONFIG_MEDIA_CONTROLLER
 		media_device_unregister(&dev->mdev);
+		media_device_cleanup(&dev->mdev);
 #endif

 		if (dev->has_vid_cap) {
