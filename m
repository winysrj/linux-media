Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51414 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751034AbeBINZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 08:25:51 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-device: zero reserved media_links_enum field
Message-ID: <1ad7443b-db60-c140-3ab8-f1a865f26db8@xs4all.nl>
Date: Fri, 9 Feb 2018 14:25:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zero the reserved field of struct media_links_enum.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index afbf23a19e16..7af6fadd206d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -155,6 +155,8 @@ static long media_device_enum_links(struct media_device *mdev,
 	if (entity == NULL)
 		return -EINVAL;

+	memset(links->reserved, 0, sizeof(links->reserved));
+
 	if (links->pads) {
 		unsigned int p;
