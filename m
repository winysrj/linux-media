Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54022 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751887AbeEDUH7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 16:07:59 -0400
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
Subject: [PATCH v9 05/15] vb2: add unordered vb2_queue property for drivers
Date: Fri,  4 May 2018 17:06:02 -0300
Message-Id: <20180504200612.8763-6-ezequiel@collabora.com>
In-Reply-To: <20180504200612.8763-1-ezequiel@collabora.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Explicit synchronization benefits a lot from ordered queues, they fit
better in a pipeline with DRM for example so create a opt-in way for
drivers notify videobuf2 that the queue is unordered.

v5: go back to a bitfield property for the unordered property.

v4: rename it to vb2_ops_is_unordered() (Hans Verkuil)

v3: - make it bool (Hans)
    - create vb2_ops_set_unordered() helper

v2: improve comments for is_unordered flag (Hans Verkuil)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 include/media/videobuf2-core.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f9633de0386c..364e4cb41b10 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -467,6 +467,8 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return %EPOLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @unordered:	tell if the queue is unordered, i.e. buffers can be
+ *		dequeued in a different order from how they were queued.
  * @lock:	pointer to a mutex that protects the &struct vb2_queue. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -533,6 +535,7 @@ struct vb2_queue {
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
+	unsigned			unordered:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
 
 	struct mutex			*lock;
-- 
2.16.3
