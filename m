Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52066 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751946AbdA0Vzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 16:55:54 -0500
From: Eric Anholt <eric@anholt.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH 2/6] staging: bcm2835-v4l2: Update the driver to the current VCHI API.
Date: Fri, 27 Jan 2017 13:54:59 -0800
Message-Id: <20170127215503.13208-3-eric@anholt.net>
In-Reply-To: <20170127215503.13208-1-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

49bec49fd7f2 ("staging: vc04_services: remove vchiq_copy_from_user")
removed the flags/msg_handle arguments, which were unused, and pushed
the implementation of copying using memcpy vs copy_from_user to the
caller.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/staging/media/platform/bcm2835/mmal-vchiq.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
index 781322542d5a..24bd2948136c 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
@@ -378,6 +378,14 @@ static int inline_receive(struct vchiq_mmal_instance *instance,
 	return 0;
 }
 
+static ssize_t mmal_memcpy_wrapper(void *src, void *dst,
+				   size_t offset, size_t size)
+{
+	memcpy(dst + offset, src + offset, size);
+
+	return size;
+}
+
 /* queue the buffer availability with MMAL_MSG_TYPE_BUFFER_FROM_HOST */
 static int
 buffer_from_host(struct vchiq_mmal_instance *instance,
@@ -442,10 +450,9 @@ buffer_from_host(struct vchiq_mmal_instance *instance,
 
 	vchi_service_use(instance->handle);
 
-	ret = vchi_msg_queue(instance->handle, &m,
+	ret = vchi_msg_queue(instance->handle, mmal_memcpy_wrapper, &m,
 			     sizeof(struct mmal_msg_header) +
-			     sizeof(m.u.buffer_from_host),
-			     VCHI_FLAGS_BLOCK_UNTIL_QUEUED, NULL);
+			     sizeof(m.u.buffer_from_host));
 
 	if (ret != 0) {
 		release_msg_context(msg_context);
@@ -731,9 +738,9 @@ static int send_synchronous_mmal_msg(struct vchiq_mmal_instance *instance,
 	vchi_service_use(instance->handle);
 
 	ret = vchi_msg_queue(instance->handle,
+			     mmal_memcpy_wrapper,
 			     msg,
-			     sizeof(struct mmal_msg_header) + payload_len,
-			     VCHI_FLAGS_BLOCK_UNTIL_QUEUED, NULL);
+			     sizeof(struct mmal_msg_header) + payload_len);
 
 	vchi_service_release(instance->handle);
 
-- 
2.11.0

