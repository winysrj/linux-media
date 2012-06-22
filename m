Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2013 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab2FVMVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 20/34] v4l2-ioctl: remove v4l_(i2c_)print_ioctl
Date: Fri, 22 Jun 2012 14:21:14 +0200
Message-Id: <3577c3b3ced10c47b536e4fe81b4271dc3cbda50.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l_i2c_print_ioctl wasn't used and v4l_print_ioctl could be replaced by
v4l_printk_ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    4 ++--
 drivers/media/video/sn9c102/sn9c102.h      |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c         |    2 +-
 drivers/media/video/v4l2-ioctl.c           |   34 +++++++---------------------
 include/media/v4l2-ioctl.h                 |   20 +++-------------
 5 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 7bddfae..81ac586 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -965,7 +965,7 @@ static long pvr2_v4l2_ioctl(struct file *file,
 	long ret = -EINVAL;
 
 	if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL)
-		v4l_print_ioctl(pvr2_hdw_get_driver_name(hdw), cmd);
+		v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw), cmd);
 
 	if (!pvr2_hdw_dev_ok(hdw)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
@@ -998,7 +998,7 @@ static long pvr2_v4l2_ioctl(struct file *file,
 				pvr2_trace(PVR2_TRACE_V4LIOCTL,
 					   "pvr2_v4l2_do_ioctl failure, ret=%ld"
 					   " command was:", ret);
-				v4l_print_ioctl(pvr2_hdw_get_driver_name(hdw),
+				v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw),
 						cmd);
 			}
 		}
diff --git a/drivers/media/video/sn9c102/sn9c102.h b/drivers/media/video/sn9c102/sn9c102.h
index 22ea211..2bc153e 100644
--- a/drivers/media/video/sn9c102/sn9c102.h
+++ b/drivers/media/video/sn9c102/sn9c102.h
@@ -182,7 +182,7 @@ do {                                                                          \
 #	define V4LDBG(level, name, cmd)                                       \
 do {                                                                          \
 	if (debug >= (level))                                                 \
-		v4l_print_ioctl(name, cmd);                                   \
+		v4l_printk_ioctl(name, cmd);                                  \
 } while (0)
 #	define KDBG(level, fmt, args...)                                      \
 do {                                                                          \
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 759bef8..f00db30 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1051,7 +1051,7 @@ static long uvc_v4l2_ioctl(struct file *file,
 {
 	if (uvc_trace_param & UVC_TRACE_IOCTL) {
 		uvc_printk(KERN_DEBUG, "uvc_v4l2_ioctl(");
-		v4l_printk_ioctl(cmd);
+		v4l_printk_ioctl(NULL, cmd);
 		printk(")\n");
 	}
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 2e1421b..efbb3db 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -28,27 +28,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 
-#define dbgarg(cmd, fmt, arg...) \
-		do {							\
-		    if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {		\
-			printk(KERN_DEBUG "%s: ",  vfd->name);		\
-			v4l_printk_ioctl(cmd);				\
-			printk(" " fmt,  ## arg);			\
-		    }							\
-		} while (0)
-
-#define dbgarg2(fmt, arg...) \
-		do {							\
-		    if (vfd->debug & V4L2_DEBUG_IOCTL_ARG)		\
-			printk(KERN_DEBUG "%s: " fmt, vfd->name, ## arg);\
-		} while (0)
-
-#define dbgarg3(fmt, arg...) \
-		do {							\
-		    if (vfd->debug & V4L2_DEBUG_IOCTL_ARG)		\
-			printk(KERN_CONT "%s: " fmt, vfd->name, ## arg);\
-		} while (0)
-
 /* Zero out the end of the struct pointed to by p.  Everything after, but
  * not including, the specified field is cleared. */
 #define CLEAR_AFTER_FIELD(p, field) \
@@ -1955,10 +1934,13 @@ bool v4l2_is_known_ioctl(unsigned int cmd)
 
 /* Common ioctl debug function. This function can be used by
    external ioctl messages as well as internal V4L ioctl */
-void v4l_printk_ioctl(unsigned int cmd)
+void v4l_printk_ioctl(const char *prefix, unsigned int cmd)
 {
 	const char *dir, *type;
 
+	if (prefix)
+		printk(KERN_DEBUG "%s: ", prefix);
+
 	switch (_IOC_TYPE(cmd)) {
 	case 'd':
 		type = "v4l2_int";
@@ -2002,8 +1984,8 @@ static long __video_do_ioctl(struct file *file,
 	long ret = -ENOTTY;
 
 	if (ops == NULL) {
-		printk(KERN_WARNING "videodev: \"%s\" has no ioctl_ops.\n",
-				vfd->name);
+		pr_warn("%s: has no ioctl_ops.\n",
+				video_device_node_name(vfd));
 		return ret;
 	}
 
@@ -2033,7 +2015,7 @@ static long __video_do_ioctl(struct file *file,
 
 	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
 	if (write_only && debug > V4L2_DEBUG_IOCTL) {
-		v4l_print_ioctl(vfd->name, cmd);
+		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
 		pr_cont(": ");
 		info->debug(arg, write_only);
 	}
@@ -2061,7 +2043,7 @@ done:
 					video_device_node_name(vfd), ret);
 			return ret;
 		}
-		v4l_print_ioctl(vfd->name, cmd);
+		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
 		if (ret < 0)
 			pr_cont(": error %ld\n", ret);
 		else if (debug == V4L2_DEBUG_IOCTL)
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index d8b76f7..dfd984f 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -295,28 +295,14 @@ struct v4l2_ioctl_ops {
 #define V4L2_DEBUG_IOCTL     0x01
 #define V4L2_DEBUG_IOCTL_ARG 0x02
 
-/* Use this macro for non-I2C drivers. Pass the driver name as the first arg. */
-#define v4l_print_ioctl(name, cmd)  		 \
-	do {  					 \
-		printk(KERN_DEBUG "%s: ", name); \
-		v4l_printk_ioctl(cmd);		 \
-	} while (0)
-
-/* Use this macro in I2C drivers where 'client' is the struct i2c_client
-   pointer */
-#define v4l_i2c_print_ioctl(client, cmd) 		   \
-	do {      					   \
-		v4l_client_printk(KERN_DEBUG, client, ""); \
-		v4l_printk_ioctl(cmd);			   \
-	} while (0)
-
 /*  Video standard functions  */
 extern const char *v4l2_norm_to_name(v4l2_std_id id);
 extern void v4l2_video_std_frame_period(int id, struct v4l2_fract *frameperiod);
 extern int v4l2_video_std_construct(struct v4l2_standard *vs,
 				    int id, const char *name);
-/* Prints the ioctl in a human-readable format */
-extern void v4l_printk_ioctl(unsigned int cmd);
+/* Prints the ioctl in a human-readable format. If prefix != NULL,
+   then do printk(KERN_DEBUG "%s: ", prefix) first. */
+extern void v4l_printk_ioctl(const char *prefix, unsigned int cmd);
 
 /* names for fancy debug output */
 extern const char *v4l2_field_names[];
-- 
1.7.10

