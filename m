Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A340AC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 09:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C5BF21872
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 09:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfBAJ5e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 04:57:34 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47054 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbfBAJ5e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 04:57:34 -0500
Received: from [IPv6:2001:983:e9a7:1:c10c:bd23:3f0c:b7eb] ([IPv6:2001:983:e9a7:1:c10c:bd23:3f0c:b7eb])
        by smtp-cloud9.xs4all.net with ESMTPA
        id pVZjgS704RO5ZpVZlgYMEd; Fri, 01 Feb 2019 10:57:33 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] uvc: use usb_make_path to fill in usb_info
Message-ID: <13e25527-e44b-2c6d-120c-b6d5d4f3432c@xs4all.nl>
Date:   Fri, 1 Feb 2019 10:57:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfENQTiXRYXpBFqzOxRbQqRWFsOifKvUs9cSDv8V8X7mOXOmrG5wcd/st2bXbEOqXxgpHg0Xl3qIeBVntoeP1vd0eEbM6iZ/hj01HueXwf0ypkQiq60HY
 jLVVnG2Emb9mXe4NY+rfWKhsZ9zh4DaiLmeGHj3lJU4ycCNpSJB3SY31rEnGJRH8HukIebGNfHPmKvBCh4Wp512DZO6Mn+lWI3Yn4lkC8t0o8oG1cqb6H8Ri
 OIdILn1Ik9REnxs4lX7RGXO0qT9w81XIXK3QAMIFVXq80otJLqjFagnG/8QjyEOa8JUm8Zsw5yio2iS5B0oIy8Qkuh+2SvnfRzSx7x/kHzU=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The uvc driver uses this function to fill in bus_info for VIDIOC_QUERYCAP,
so use the same function when filling in the bus_info for the media device.

The current implementation only fills in part of the info. E.g. if the full
bus_info is usb-0000:01:00.0-1.4.2, then the media bus_info only has 1.4.2.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index b62cbd800111..068cabf141c1 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2175,7 +2175,7 @@ static int uvc_probe(struct usb_interface *intf,
 	if (udev->serial)
 		strscpy(dev->mdev.serial, udev->serial,
 			sizeof(dev->mdev.serial));
-	strscpy(dev->mdev.bus_info, udev->devpath, sizeof(dev->mdev.bus_info));
+	usb_make_path(udev, dev->mdev.bus_info, sizeof(dev->mdev.bus_info));
 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	media_device_init(&dev->mdev);

