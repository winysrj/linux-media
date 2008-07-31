Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VKOBSL008574
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 16:24:11 -0400
Received: from mailrelay003.isp.belgacom.be (mailrelay003.isp.belgacom.be
	[195.238.6.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6VKO0Vr010050
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 16:24:00 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 31 Jul 2008 22:23:57 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_d9hkIjU8tV/zoyz"
Message-Id: <200807312223.57610.laurent.pinchart@skynet.be>
Cc: Bruce Schmid <duck@freescale.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: don't use stack-based buffers for USB transfers.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--Boundary-00=_d9hkIjU8tV/zoyz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Data buffers on the stack are not allowed for USB I/O. Use dynamically
allocated buffers instead.

Signed-off-by: Bruce Schmid <duck@freescale.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_ctrl.c  |   33 +++++++++++++++++++++------------
 drivers/media/video/uvc/uvc_video.c |   33 ++++++++++++++++++++++-----------
 2 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c 
b/drivers/media/video/uvc/uvc_ctrl.c
index 626f4ad..6ef3e52 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -585,13 +585,17 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
 	struct uvc_control_mapping *mapping;
 	struct uvc_menu_info *menu;
 	unsigned int i;
-	__u8 data[8];
+	__u8 *data;
 	int ret;
 
 	ctrl = uvc_find_control(video, v4l2_ctrl->id, &mapping);
 	if (ctrl == NULL)
 		return -EINVAL;
 
+	data = kmalloc(8, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
 	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id = mapping->id;
 	v4l2_ctrl->type = mapping->v4l2_type;
@@ -604,8 +608,8 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
 	if (ctrl->info->flags & UVC_CONTROL_GET_DEF) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_DEF, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->default_value = uvc_get_le_value(data, mapping);
 	}
 
@@ -623,13 +627,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
 			}
 		}
 
-		return 0;
+		ret = 0;
+		goto out;
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		v4l2_ctrl->minimum = 0;
 		v4l2_ctrl->maximum = 1;
 		v4l2_ctrl->step = 1;
-		return 0;
+		ret = 0;
+		goto out;
 
 	default:
 		break;
@@ -638,26 +644,29 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
 	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_MIN, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->minimum = uvc_get_le_value(data, mapping);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_MAX) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_MAX, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->maximum = uvc_get_le_value(data, mapping);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_RES) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_RES, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->step = uvc_get_le_value(data, mapping);
 	}
 
-	return 0;
+	ret = 0;
+out:
+	kfree(data);
+	return ret;
 }
 
 
diff --git a/drivers/media/video/uvc/uvc_video.c 
b/drivers/media/video/uvc/uvc_video.c
index ad63794..6854ac7 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -90,17 +90,20 @@ static void uvc_fixup_buffer_size(struct uvc_video_device 
*video,
 static int uvc_get_video_ctrl(struct uvc_video_device *video,
 	struct uvc_streaming_control *ctrl, int probe, __u8 query)
 {
-	__u8 data[34];
-	__u8 size;
+	__u8 *data;
+	__u16 size;
 	int ret;
 
 	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
+	data = kmalloc(size, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
 	ret = __uvc_query_ctrl(video->dev, query, 0, video->streaming->intfnum,
-		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
 		UVC_CTRL_STREAMING_TIMEOUT);
-
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ctrl->bmHint = le16_to_cpup((__le16 *)&data[0]);
 	ctrl->bFormatIndex = data[2];
@@ -136,17 +139,22 @@ static int uvc_get_video_ctrl(struct uvc_video_device 
*video,
 	 */
 	uvc_fixup_buffer_size(video, ctrl);
 
-	return 0;
+out:
+	kfree(data);
+	return ret;
 }
 
 int uvc_set_video_ctrl(struct uvc_video_device *video,
 	struct uvc_streaming_control *ctrl, int probe)
 {
-	__u8 data[34];
-	__u8 size;
+	__u8 *data;
+	__u16 size;
+	int ret;
 
 	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
-	memset(data, 0, sizeof data);
+	data = kzalloc(size, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 
 	*(__le16 *)&data[0] = cpu_to_le16(ctrl->bmHint);
 	data[2] = ctrl->bFormatIndex;
@@ -174,10 +182,13 @@ int uvc_set_video_ctrl(struct uvc_video_device *video,
 		data[33] = ctrl->bMaxVersion;
 	}
 
-	return __uvc_query_ctrl(video->dev, SET_CUR, 0,
+	ret = __uvc_query_ctrl(video->dev, SET_CUR, 0,
 		video->streaming->intfnum,
-		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
 		UVC_CTRL_STREAMING_TIMEOUT);
+
+	kfree(data);
+	return ret;
 }
 
 int uvc_probe_video(struct uvc_video_device *video,
-- 
1.5.4.5


--Boundary-00=_d9hkIjU8tV/zoyz
Content-Type: text/x-diff; charset="us-ascii";
	name="0001-uvcvideo-don-t-use-stack-based-buffers-for-USB-tran.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-uvcvideo-don-t-use-stack-based-buffers-for-USB-tran.patch"

=46rom 03e6e98d70f0e9b0e614155830b616fa9c9b92b2 Mon Sep 17 00:00:00 2001
=46rom: Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Thu, 31 Jul 2008 22:11:12 +0200
Subject: [PATCH] uvcvideo: don't use stack-based buffers for USB transfers.

Data buffers on the stack are not allowed for USB I/O. Use dynamically
allocated buffers instead.

Signed-off-by: Bruce Schmid <duck@freescale.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
=2D--
 drivers/media/video/uvc/uvc_ctrl.c  |   33 +++++++++++++++++++++----------=
=2D-
 drivers/media/video/uvc/uvc_video.c |   33 ++++++++++++++++++++++---------=
=2D-
 2 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/u=
vc_ctrl.c
index 626f4ad..6ef3e52 100644
=2D-- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -585,13 +585,17 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *vide=
o,
 	struct uvc_control_mapping *mapping;
 	struct uvc_menu_info *menu;
 	unsigned int i;
=2D	__u8 data[8];
+	__u8 *data;
 	int ret;
=20
 	ctrl =3D uvc_find_control(video, v4l2_ctrl->id, &mapping);
 	if (ctrl =3D=3D NULL)
 		return -EINVAL;
=20
+	data =3D kmalloc(8, GFP_KERNEL);
+	if (data =3D=3D NULL)
+		return -ENOMEM;
+
 	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id =3D mapping->id;
 	v4l2_ctrl->type =3D mapping->v4l2_type;
@@ -604,8 +608,8 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
 	if (ctrl->info->flags & UVC_CONTROL_GET_DEF) {
 		if ((ret =3D uvc_query_ctrl(video->dev, GET_DEF, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
=2D				&data, ctrl->info->size)) < 0)
=2D			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->default_value =3D uvc_get_le_value(data, mapping);
 	}
=20
@@ -623,13 +627,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *vide=
o,
 			}
 		}
=20
=2D		return 0;
+		ret =3D 0;
+		goto out;
=20
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		v4l2_ctrl->minimum =3D 0;
 		v4l2_ctrl->maximum =3D 1;
 		v4l2_ctrl->step =3D 1;
=2D		return 0;
+		ret =3D 0;
+		goto out;
=20
 	default:
 		break;
@@ -638,26 +644,29 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device *vide=
o,
 	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {
 		if ((ret =3D uvc_query_ctrl(video->dev, GET_MIN, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
=2D				&data, ctrl->info->size)) < 0)
=2D			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->minimum =3D uvc_get_le_value(data, mapping);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_MAX) {
 		if ((ret =3D uvc_query_ctrl(video->dev, GET_MAX, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
=2D				&data, ctrl->info->size)) < 0)
=2D			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->maximum =3D uvc_get_le_value(data, mapping);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_RES) {
 		if ((ret =3D uvc_query_ctrl(video->dev, GET_RES, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
=2D				&data, ctrl->info->size)) < 0)
=2D			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->step =3D uvc_get_le_value(data, mapping);
 	}
=20
=2D	return 0;
+	ret =3D 0;
+out:
+	kfree(data);
+	return ret;
 }
=20
=20
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/=
uvc_video.c
index ad63794..6854ac7 100644
=2D-- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -90,17 +90,20 @@ static void uvc_fixup_buffer_size(struct uvc_video_devi=
ce *video,
 static int uvc_get_video_ctrl(struct uvc_video_device *video,
 	struct uvc_streaming_control *ctrl, int probe, __u8 query)
 {
=2D	__u8 data[34];
=2D	__u8 size;
+	__u8 *data;
+	__u16 size;
 	int ret;
=20
 	size =3D video->dev->uvc_version >=3D 0x0110 ? 34 : 26;
+	data =3D kmalloc(size, GFP_KERNEL);
+	if (data =3D=3D NULL)
+		return -ENOMEM;
+
 	ret =3D __uvc_query_ctrl(video->dev, query, 0, video->streaming->intfnum,
=2D		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
 		UVC_CTRL_STREAMING_TIMEOUT);
=2D
 	if (ret < 0)
=2D		return ret;
+		goto out;
=20
 	ctrl->bmHint =3D le16_to_cpup((__le16 *)&data[0]);
 	ctrl->bFormatIndex =3D data[2];
@@ -136,17 +139,22 @@ static int uvc_get_video_ctrl(struct uvc_video_device=
 *video,
 	 */
 	uvc_fixup_buffer_size(video, ctrl);
=20
=2D	return 0;
+out:
+	kfree(data);
+	return ret;
 }
=20
 int uvc_set_video_ctrl(struct uvc_video_device *video,
 	struct uvc_streaming_control *ctrl, int probe)
 {
=2D	__u8 data[34];
=2D	__u8 size;
+	__u8 *data;
+	__u16 size;
+	int ret;
=20
 	size =3D video->dev->uvc_version >=3D 0x0110 ? 34 : 26;
=2D	memset(data, 0, sizeof data);
+	data =3D kzalloc(size, GFP_KERNEL);
+	if (data =3D=3D NULL)
+		return -ENOMEM;
=20
 	*(__le16 *)&data[0] =3D cpu_to_le16(ctrl->bmHint);
 	data[2] =3D ctrl->bFormatIndex;
@@ -174,10 +182,13 @@ int uvc_set_video_ctrl(struct uvc_video_device *video,
 		data[33] =3D ctrl->bMaxVersion;
 	}
=20
=2D	return __uvc_query_ctrl(video->dev, SET_CUR, 0,
+	ret =3D __uvc_query_ctrl(video->dev, SET_CUR, 0,
 		video->streaming->intfnum,
=2D		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
 		UVC_CTRL_STREAMING_TIMEOUT);
+
+	kfree(data);
+	return ret;
 }
=20
 int uvc_probe_video(struct uvc_video_device *video,
=2D-=20
1.5.4.5


--Boundary-00=_d9hkIjU8tV/zoyz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_d9hkIjU8tV/zoyz--
