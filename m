Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44392 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753376AbeEURCF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:02:05 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 09/16] cobalt: add .is_unordered() for cobalt
Date: Mon, 21 May 2018 13:59:39 -0300
Message-Id: <20180521165946.11778-10-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

The cobalt driver may reorder the capture buffers so we need to report
it as such.

v3: set formats as unordered
v2: use vb2_ops_set_unordered() helper

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index e2a4c705d353..ccca1a96df90 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -430,6 +430,7 @@ static const struct vb2_ops cobalt_qops = {
 	.stop_streaming = cobalt_stop_streaming,
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
+	.is_unordered = vb2_ops_is_unordered,
 };
 
 /* V4L2 ioctls */
@@ -695,14 +696,17 @@ static int cobalt_enum_fmt_vid_cap(struct file *file, void *priv_fh,
 	case 0:
 		strlcpy(f->description, "YUV 4:2:2", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_YUYV;
+		f->flags |= V4L2_FMT_FLAG_UNORDERED;
 		break;
 	case 1:
 		strlcpy(f->description, "RGB24", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_RGB24;
+		f->flags |= V4L2_FMT_FLAG_UNORDERED;
 		break;
 	case 2:
 		strlcpy(f->description, "RGB32", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_BGR32;
+		f->flags |= V4L2_FMT_FLAG_UNORDERED;
 		break;
 	default:
 		return -EINVAL;
-- 
2.16.3
