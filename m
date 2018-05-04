Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54066 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbeEDUIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 16:08:10 -0400
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
Subject: [PATCH v9 08/15] cobalt: set queue as unordered
Date: Fri,  4 May 2018 17:06:05 -0300
Message-Id: <20180504200612.8763-9-ezequiel@collabora.com>
In-Reply-To: <20180504200612.8763-1-ezequiel@collabora.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

The cobalt driver may reorder the capture buffers so we need to report
it as such.

v3: set unordered as a property
v2: use vb2_ops_set_unordered() helper

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index e2a4c705d353..8f06cc7f1c81 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1236,6 +1236,7 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	q->min_buffers_needed = 2;
 	q->lock = &s->lock;
 	q->dev = &cobalt->pci_dev->dev;
+	q->unordered = 1;
 	vdev->queue = q;
 
 	video_set_drvdata(vdev, s);
-- 
2.16.3
