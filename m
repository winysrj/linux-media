Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52098 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752027AbdA0Vzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 16:55:54 -0500
From: Eric Anholt <eric@anholt.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH 6/6] staging: bcm2835-v4l2: Apply spelling fixes from checkpatch.
Date: Fri, 27 Jan 2017 13:55:03 -0800
Message-Id: <20170127215503.13208-7-eric@anholt.net>
In-Reply-To: <20170127215503.13208-1-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Generated with checkpatch.pl --fix-inplace and git add -p out of the
results.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/staging/media/platform/bcm2835/bcm2835-camera.c |  6 +++---
 drivers/staging/media/platform/bcm2835/mmal-vchiq.c     | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index 4541a363905c..105d88102cd9 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -1027,7 +1027,7 @@ static int mmal_setup_components(struct bm2835_mmal_dev *dev,
 
 		dev->capture.encode_component = NULL;
 	}
-	/* format dependant port setup */
+	/* format dependent port setup */
 	switch (mfmt->mmal_component) {
 	case MMAL_COMPONENT_CAMERA:
 		/* Make a further decision on port based on resolution */
@@ -1336,7 +1336,7 @@ int vidioc_enum_framesizes(struct file *file, void *fh,
 	return 0;
 }
 
-/* timeperframe is arbitrary and continous */
+/* timeperframe is arbitrary and continuous */
 static int vidioc_enum_frameintervals(struct file *file, void *priv,
 				      struct v4l2_frmivalenum *fival)
 {
@@ -1359,7 +1359,7 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 
 	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
 
-	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
+	/* fill in stepwise (step=1.0 is required by V4L2 spec) */
 	fival->stepwise.min  = tpf_min;
 	fival->stepwise.max  = tpf_max;
 	fival->stepwise.step = (struct v4l2_fract) {1, 1};
diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
index cc968442adc4..f71dc3e9c3ae 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
@@ -239,7 +239,7 @@ static int bulk_receive(struct vchiq_mmal_instance *instance,
 		pr_err("buffer list empty trying to submit bulk receive\n");
 
 		/* todo: this is a serious error, we should never have
-		 * commited a buffer_to_host operation to the mmal
+		 * committed a buffer_to_host operation to the mmal
 		 * port without the buffer to back it up (underflow
 		 * handling) and there is no obvious way to deal with
 		 * this - how is the mmal servie going to react when
@@ -352,7 +352,7 @@ static int inline_receive(struct vchiq_mmal_instance *instance,
 		pr_err("buffer list empty trying to receive inline\n");
 
 		/* todo: this is a serious error, we should never have
-		 * commited a buffer_to_host operation to the mmal
+		 * committed a buffer_to_host operation to the mmal
 		 * port without the buffer to back it up (with
 		 * underflow handling) and there is no obvious way to
 		 * deal with this. Less bad than the bulk case as we
@@ -653,7 +653,7 @@ static void service_callback(void *param,
 			break;
 
 		default:
-			/* messages dependant on header context to complete */
+			/* messages dependent on header context to complete */
 
 			/* todo: the msg.context really ought to be sanity
 			 * checked before we just use it, afaict it comes back
@@ -780,7 +780,7 @@ static void dump_port_info(struct vchiq_mmal_port *port)
 		 port->current_buffer.num,
 		 port->current_buffer.size, port->current_buffer.alignment);
 
-	pr_debug("elementry stream: type:%d encoding:0x%x varient:0x%x\n",
+	pr_debug("elementry stream: type:%d encoding:0x%x variant:0x%x\n",
 		 port->format.type,
 		 port->format.encoding, port->format.encoding_variant);
 
@@ -883,7 +883,7 @@ static int port_info_set(struct vchiq_mmal_instance *instance,
 	return ret;
 }
 
-/* use port info get message to retrive port information */
+/* use port info get message to retrieve port information */
 static int port_info_get(struct vchiq_mmal_instance *instance,
 			 struct vchiq_mmal_port *port)
 {
@@ -923,7 +923,7 @@ static int port_info_get(struct vchiq_mmal_instance *instance,
 	/* copy the values out of the message */
 	port->handle = rmsg->u.port_info_get_reply.port_handle;
 
-	/* port type and index cached to use on port info set becuase
+	/* port type and index cached to use on port info set because
 	 * it does not use a port handle
 	 */
 	port->type = rmsg->u.port_info_get_reply.port_type;
-- 
2.11.0

