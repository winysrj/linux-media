Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34481 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932571AbeCIRt7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 12:49:59 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v8 06/13] [media] cobalt: add .is_unordered() for cobalt
Date: Fri,  9 Mar 2018 14:49:13 -0300
Message-Id: <20180309174920.22373-7-gustavo@padovan.org>
In-Reply-To: <20180309174920.22373-1-gustavo@padovan.org>
References: <20180309174920.22373-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

The cobalt driver may reorder the capture buffers so we need to report
it as such.

v2: - use vb2_ops_set_unordered() helper

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index e2a4c705d353..6b6611a0e190 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -430,6 +430,7 @@ static const struct vb2_ops cobalt_qops = {
 	.stop_streaming = cobalt_stop_streaming,
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
+	.is_unordered = vb2_ops_set_unordered,
 };
 
 /* V4L2 ioctls */
-- 
2.14.3
