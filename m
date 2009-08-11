Return-path: <linux-media-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:34829 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbZHKSla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 14:41:30 -0400
Date: Tue, 11 Aug 2009 20:41:25 +0200
From: Olaf Titz <Olaf.Titz@inka.de>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca: add g_std/s_std methods
References: <E1MaElV-0004zK-7v@bigred.inka.de> <20090811194215.0dd6e3f8@tele>
In-Reply-To: <20090811194215.0dd6e3f8@tele>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <E1MawHl-0000H5-MA@bigred.inka.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:

> The vidioc_s_std() has been removed last month by Németh Márton
> according to the v4l2 API http://v4l2spec.bytesex.org/spec/x448.htm

Ah, I see. This is a recent change, which explains why it has not come
up earlier :-)
The standard clearly states that my change is incorrect, but then
v4l1-compat.c is wrong in how it implements v4l_compat_get_input_info()
and v4l1_compat_set_input(). These calls query rsp. set video input and
standard in one call, and there is no special provision for webcams in
http://v4l2spec.bytesex.org/spec/x309.htm, so these calls should not
fail. IOW, something like this would be in order instead (untested):

--- a/linux/drivers/media/video/v4l1-compat.c   Sat Aug 08 03:28:41 2009
-0300
+++ b/linux/drivers/media/video/v4l1-compat.c   Tue Aug 11 20:30:47 2009
+0200
@@ -540,7 +540,7 @@
 {
        long err;
        struct v4l2_input       input2;
-       v4l2_std_id             sid;
+       v4l2_std_id             sid = V4L2_STD_UNKNOWN;

        memset(&input2, 0, sizeof(input2));
        input2.index = chan->channel;
@@ -566,19 +566,21 @@
                break;
        }
        chan->norm = 0;
-       err = drv(file, VIDIOC_G_STD, &sid);
-       if (err < 0)
-               dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %ld\n", err);
-       if (err == 0) {
-               if (sid & V4L2_STD_PAL)
-                       chan->norm = VIDEO_MODE_PAL;
-               if (sid & V4L2_STD_NTSC)
-                       chan->norm = VIDEO_MODE_NTSC;
-               if (sid & V4L2_STD_SECAM)
-                       chan->norm = VIDEO_MODE_SECAM;
-               if (sid == V4L2_STD_ALL)
-                       chan->norm = VIDEO_MODE_AUTO;
-       }
+        {
+                int err2 = drv(file, VIDIOC_G_STD, &sid);
+                if (err2 < 0)
+                        dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %ld\n", err2);
+                if (err2 == 0) {
+                        if (sid & V4L2_STD_PAL)
+                                chan->norm = VIDEO_MODE_PAL;
+                        if (sid & V4L2_STD_NTSC)
+                                chan->norm = VIDEO_MODE_NTSC;
+                        if (sid & V4L2_STD_SECAM)
+                                chan->norm = VIDEO_MODE_SECAM;
+                        if (sid == V4L2_STD_ALL)
+                                chan->norm = VIDEO_MODE_AUTO;
+                }
+        }
 done:
        return err;
 }
@@ -609,9 +611,9 @@
                break;
        }
        if (0 != sid) {
-               err = drv(file, VIDIOC_S_STD, &sid);
-               if (err < 0)
-                       dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %ld\n", err);
+               int err2 = drv(file, VIDIOC_S_STD, &sid);
+               if (err2 < 0)
+                       dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %ld\n", err2);
        }
        return err;
 }

I'm not sure if v4l1_compat_get_tuner() needs this kind of change too.

We also should keep the input->std = V4L2_STD_ALL; because an
application may bomb with something like "Invalid standard PAL, valid
choices are:" (empty). This (and the EINVAL) breaks at least ekiga 2
with the v4l1 module (which is what Ubuntu has) run over
libv4l1compat.so. (Ekiga 3 with the v4l2 module does work.) It also
breaks xawtv, the canonical v4l test app...

Olaf

