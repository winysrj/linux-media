Return-path: <linux-media-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:47755 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZHIUca (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Aug 2009 16:32:30 -0400
Date: Sun, 09 Aug 2009 22:13:12 +0200
From: Olaf Titz <Olaf.Titz@inka.de>
MIME-Version: 1.0
To: moinejf@free.fr
CC: linux-media@vger.kernel.org
Subject: [PATCH] gspca: add g_std/s_std methods
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Message-ID: <E1MaElV-0004zK-7v@bigred.inka.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some applications are unhappy about getting EINVAL errors for query/set
TV standard operations, especially (or only?) when working over the
v4l1compat.so bridge. This patch adds the appropriate methods to the
gspca driver (claim to support all TV modes, setting TV mode does nothing).

Signed-off-by: Olaf Titz <olaf@bigred.inka.de>

--- a/linux/drivers/media/video/gspca/gspca.c   Sat Aug 08 03:28:41 2009
-0300
+++ b/linux/drivers/media/video/gspca/gspca.c   Sun Aug 09 22:00:03 2009
+0200
@@ -1249,6 +1249,7 @@
        if (input->index != 0)
                return -EINVAL;
        input->type = V4L2_INPUT_TYPE_CAMERA;
+       input->std = V4L2_STD_ALL;
        input->status = gspca_dev->cam.input_flags;
        strncpy(input->name, gspca_dev->sd_desc->name,
                sizeof input->name);
@@ -1624,6 +1625,17 @@
        return ret;
 }

+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+       *norm = V4L2_STD_UNKNOWN;
+       return 0;
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+       return 0;
+}
+
 /*
  * wait for a video frame
  *
@@ -1958,6 +1970,8 @@
        .vidioc_s_fmt_vid_cap   = vidioc_s_fmt_vid_cap,
        .vidioc_streamon        = vidioc_streamon,
        .vidioc_queryctrl       = vidioc_queryctrl,
+       .vidioc_g_std           = vidioc_g_std,
+       .vidioc_s_std           = vidioc_s_std,
        .vidioc_g_ctrl          = vidioc_g_ctrl,
        .vidioc_s_ctrl          = vidioc_s_ctrl,
        .vidioc_g_audio         = vidioc_g_audio,

