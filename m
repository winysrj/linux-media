Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34205 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755463AbdCKDCP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 22:02:15 -0500
From: Derek Robson <robsonde@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        swarren@wwwdotorg.org, lee@kernel.org, eric@anholt.net,
        arnd@arndb.de, robsonde@gmail.com, mzoran@crowfest.net,
        dan.carpenter@oracle.com
Cc: bcm-kernel-feedback-list@broadcom.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] Staging: bcm2835: Fixed style of block comments
Date: Sat, 11 Mar 2017 16:01:59 +1300
Message-Id: <20170311030159.3451-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed style of block comments across whole driver
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
Version #1 had ugly long subject name.

 .../media/platform/bcm2835/bcm2835-camera.c        | 24 ++++++++++++++--------
 drivers/staging/media/platform/bcm2835/controls.c  | 22 +++++++++++---------
 .../staging/media/platform/bcm2835/mmal-msg-port.h |  6 ++++--
 drivers/staging/media/platform/bcm2835/mmal-msg.h  | 18 ++++++++--------
 .../staging/media/platform/bcm2835/mmal-vchiq.c    |  3 ++-
 .../staging/media/platform/bcm2835/mmal-vchiq.h    |  4 ++--
 6 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index ca15a698e018..25beca62a8a9 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -239,8 +239,9 @@ static struct mmal_fmt *get_format(struct v4l2_format *f)
 }
 
 /* ------------------------------------------------------------------
-	Videobuf queue operations
-   ------------------------------------------------------------------*/
+ *	Videobuf queue operations
+ * ------------------------------------------------------------------
+ */
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
@@ -668,8 +669,9 @@ static struct vb2_ops bm2835_mmal_video_qops = {
 };
 
 /* ------------------------------------------------------------------
-	IOCTL operations
-   ------------------------------------------------------------------*/
+ *	IOCTL operations
+ * ------------------------------------------------------------------
+ */
 
 static int set_overlay_params(struct bm2835_mmal_dev *dev,
 			      struct vchiq_mmal_port *port)
@@ -834,7 +836,8 @@ static int vidioc_g_fbuf(struct file *file, void *fh,
 			 struct v4l2_framebuffer *a)
 {
 	/* The video overlay must stay within the framebuffer and can't be
-	   positioned independently. */
+	 * positioned independently.
+	 */
 	struct bm2835_mmal_dev *dev = video_drvdata(file);
 	struct vchiq_mmal_port *preview_port =
 		    &dev->component[MMAL_COMPONENT_CAMERA]->
@@ -1291,7 +1294,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	}
 
 	/* If the format is unsupported v4l2 says we should switch to
-	 * a supported one and not return an error. */
+	 * a supported one and not return an error.
+	 */
 	mfmt = get_format(f);
 	if (!mfmt) {
 		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
@@ -1485,7 +1489,8 @@ static const struct v4l2_ioctl_ops camera0_ioctl_ops_gstreamer = {
 	.vidioc_qbuf = vb2_ioctl_qbuf,
 	.vidioc_dqbuf = vb2_ioctl_dqbuf,
 	/* Remove this function ptr to fix gstreamer bug
-	.vidioc_enum_framesizes = vidioc_enum_framesizes, */
+	 * .vidioc_enum_framesizes = vidioc_enum_framesizes,
+	 */
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 	.vidioc_g_parm        = vidioc_g_parm,
 	.vidioc_s_parm        = vidioc_s_parm,
@@ -1498,8 +1503,9 @@ static const struct v4l2_ioctl_ops camera0_ioctl_ops_gstreamer = {
 };
 
 /* ------------------------------------------------------------------
-	Driver init/finalise
-   ------------------------------------------------------------------*/
+ *	Driver init/finalise
+ * ------------------------------------------------------------------
+ */
 
 static const struct v4l2_file_operations camera0_fops = {
 	.owner = THIS_MODULE,
diff --git a/drivers/staging/media/platform/bcm2835/controls.c b/drivers/staging/media/platform/bcm2835/controls.c
index a40987b2e75d..16fa40c904e7 100644
--- a/drivers/staging/media/platform/bcm2835/controls.c
+++ b/drivers/staging/media/platform/bcm2835/controls.c
@@ -90,7 +90,8 @@ struct bm2835_mmal_v4l2_ctrl {
 	u32 id; /* v4l2 control identifier */
 	enum bm2835_mmal_ctrl_type type;
 	/* control minimum value or
-	 * mask for MMAL_CONTROL_TYPE_STD_MENU */
+	 * mask for MMAL_CONTROL_TYPE_STD_MENU
+	 */
 	s32 min;
 	s32 max; /* maximum value of control */
 	s32 def;  /* default value of control */
@@ -398,10 +399,10 @@ static int ctrl_set_metering_mode(struct bm2835_mmal_dev *dev,
 		break;
 
 	/* todo matrix weighting not added to Linux API till 3.9
-	case V4L2_EXPOSURE_METERING_MATRIX:
-		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_MATRIX;
-		break;
-	*/
+	 * case V4L2_EXPOSURE_METERING_MATRIX:
+	 *	dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_MATRIX;
+	 *	break;
+	 */
 	}
 
 	if (dev->scene_mode == V4L2_SCENE_MODE_NONE) {
@@ -982,8 +983,9 @@ static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
 		false
 	},
 /*	{
-		0, MMAL_CONTROL_TYPE_CLUSTER, 3, 1, 0, NULL, 0, NULL
-	}, */
+ *		0, MMAL_CONTROL_TYPE_CLUSTER, 3, 1, 0, NULL, 0, NULL
+ *	},
+ */
 	{
 		V4L2_CID_EXPOSURE_AUTO, MMAL_CONTROL_TYPE_STD_MENU,
 		~0x03, 3, V4L2_EXPOSURE_AUTO, 0, NULL,
@@ -992,9 +994,9 @@ static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
 		false
 	},
 /* todo this needs mixing in with set exposure
-	{
-	       V4L2_CID_SCENE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
-	},
+ *	{
+ *		V4L2_CID_SCENE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
+ *	},
  */
 	{
 		V4L2_CID_EXPOSURE_ABSOLUTE, MMAL_CONTROL_TYPE_STD,
diff --git a/drivers/staging/media/platform/bcm2835/mmal-msg-port.h b/drivers/staging/media/platform/bcm2835/mmal-msg-port.h
index a55c1ea2eceb..c47c25e325d6 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-msg-port.h
+++ b/drivers/staging/media/platform/bcm2835/mmal-msg-port.h
@@ -26,12 +26,14 @@ enum mmal_port_type {
 #define MMAL_PORT_CAPABILITY_PASSTHROUGH                       0x01
 /** The port wants to allocate the buffer payloads.
  * This signals a preference that payload allocation should be done
- * on this port for efficiency reasons. */
+ * on this port for efficiency reasons.
+ */
 #define MMAL_PORT_CAPABILITY_ALLOCATION                        0x02
 /** The port supports format change events.
  * This applies to input ports and is used to let the client know
  * whether the port supports being reconfigured via a format
- * change event (i.e. without having to disable the port). */
+ * change event (i.e. without having to disable the port).
+ */
 #define MMAL_PORT_CAPABILITY_SUPPORTS_EVENT_FORMAT_CHANGE      0x04
 
 /* mmal port structure (MMAL_PORT_T)
diff --git a/drivers/staging/media/platform/bcm2835/mmal-msg.h b/drivers/staging/media/platform/bcm2835/mmal-msg.h
index 67b1076015a5..12c47d89cdb3 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-msg.h
+++ b/drivers/staging/media/platform/bcm2835/mmal-msg.h
@@ -108,9 +108,9 @@ struct mmal_msg_component_create {
 
 /* reply from VC to component creation request */
 struct mmal_msg_component_create_reply {
-	u32 status; /** enum mmal_msg_status - how does this differ to
-		     * the one in the header?
-		     */
+	u32 status;	/* enum mmal_msg_status - how does this differ to
+			 * the one in the header?
+			 */
 	u32 component_handle; /* VideoCore handle for component */
 	u32 input_num;        /* Number of input ports */
 	u32 output_num;       /* Number of output ports */
@@ -234,10 +234,12 @@ struct mmal_msg_port_action_reply {
 /** Signals that the current payload is a keyframe (i.e. self decodable) */
 #define MMAL_BUFFER_HEADER_FLAG_KEYFRAME               (1<<3)
 /** Signals a discontinuity in the stream of data (e.g. after a seek).
- * Can be used for instance by a decoder to reset its state */
+ * Can be used for instance by a decoder to reset its state
+ */
 #define MMAL_BUFFER_HEADER_FLAG_DISCONTINUITY          (1<<4)
 /** Signals a buffer containing some kind of config data for the component
- * (e.g. codec config data) */
+ * (e.g. codec config data)
+ */
 #define MMAL_BUFFER_HEADER_FLAG_CONFIG                 (1<<5)
 /** Signals an encrypted payload */
 #define MMAL_BUFFER_HEADER_FLAG_ENCRYPTED              (1<<6)
@@ -321,9 +323,9 @@ struct mmal_msg_port_parameter_set {
 };
 
 struct mmal_msg_port_parameter_set_reply {
-	u32 status; /** enum mmal_msg_status todo: how does this
-		     * differ to the one in the header?
-		     */
+	u32 status;	/* enum mmal_msg_status todo: how does this
+			 * differ to the one in the header?
+			 */
 };
 
 /* port parameter getting */
diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
index fdfb6a620a43..d5e635ef3185 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
@@ -1429,7 +1429,8 @@ static int port_enable(struct vchiq_mmal_instance *instance,
 
 /* ------------------------------------------------------------------
  * Exported API
- *------------------------------------------------------------------*/
+ *------------------------------------------------------------------
+ */
 
 int vchiq_mmal_port_set_format(struct vchiq_mmal_instance *instance,
 			       struct vchiq_mmal_port *port)
diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.h b/drivers/staging/media/platform/bcm2835/mmal-vchiq.h
index 9d1d11e4a53e..029f9f1fe81e 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-vchiq.h
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.h
@@ -109,8 +109,8 @@ int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance);
 int vchiq_mmal_finalise(struct vchiq_mmal_instance *instance);
 
 /* Initialise a mmal component and its ports
-*
-*/
+ *
+ */
 int vchiq_mmal_component_init(
 		struct vchiq_mmal_instance *instance,
 		const char *name,
-- 
2.12.0
