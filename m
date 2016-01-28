Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41841 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbcA1JFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:05:06 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 7/12] TW686x: Add enum_input() / g_input() / s_input()
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:05:03 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3y4bacbwg.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c781b3c..21efa30 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -466,6 +466,34 @@ static int tw686x_g_parm(struct file *file, void *priv,
 	return 0;
 }
 
+static int tw686x_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *inp)
+{
+	/* the chip has internal multiplexer, support can be added
+	   if the actual hw uses it */
+	if (inp->index)
+		return -EINVAL;
+
+	snprintf(inp->name, sizeof(inp->name), "Composite");
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+  	inp->std = V4L2_STD_ALL;
+	inp->capabilities = V4L2_IN_CAP_STD;
+	return 0;
+}
+
+static int tw686x_g_input(struct file *file, void *priv, unsigned *v)
+{
+	*v = 0;
+	return 0;
+}
+
+static int tw686x_s_input(struct file *file, void *priv, unsigned v)
+{
+	if (v)
+		return -EINVAL;
+	return 0;
+}
+
 const struct v4l2_file_operations tw686x_video_fops = {
 	.owner		= THIS_MODULE,
 	.open		= v4l2_fh_open,
@@ -492,6 +520,9 @@ const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
 	.vidioc_g_std			= tw686x_g_std,
 	.vidioc_s_std			= tw686x_s_std,
 	.vidioc_g_parm			= tw686x_g_parm,
+	.vidioc_enum_input		= tw686x_enum_input,
+	.vidioc_g_input			= tw686x_g_input,
+	.vidioc_s_input			= tw686x_s_input,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
