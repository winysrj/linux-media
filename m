Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:33025 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeH0Xqe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 19:46:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: y2038@lists.linaro.org, awalls@md.metrocast.net,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/5] media: dvb: move most compat_ioctl handling into drivers
Date: Mon, 27 Aug 2018 21:56:24 +0200
Message-Id: <20180827195649.4170969-4-arnd@arndb.de>
In-Reply-To: <20180827195649.4170969-1-arnd@arndb.de>
References: <20180827195649.4170969-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most DVB audio and video ioctl commands are completely compatible,
and are implemented by just two drivers: ttpci and ivtv. In both
cases, we can use the same ioctl handler for both native and
compat ioctl handling, and remove the entries from the global
lookup table.

In case of ttpci, this directly hooks into the file_operations
structure, and for ivtv, we have to set the compat_ioctl32
method in v4l2_file_operations. For all I can tell, setting it
to video_ioctl2 will still do the right thing for all commands.

Note that for the VIDEO_STILLPICTURE and VIDEO_GET_EVENT commands,
a translation handler in fs/compat_ioctl.c is still used. This
works because the command numbers are different on 32-bit
systems.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/ivtv/ivtv-streams.c |  9 ++++++++
 drivers/media/pci/ttpci/av7110_av.c   |  2 ++
 fs/compat_ioctl.c                     | 31 ---------------------------
 3 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
index d27c6df97566..a641f20e3f86 100644
--- a/drivers/media/pci/ivtv/ivtv-streams.c
+++ b/drivers/media/pci/ivtv/ivtv-streams.c
@@ -51,6 +51,9 @@ static const struct v4l2_file_operations ivtv_v4l2_enc_fops = {
 	.write = ivtv_v4l2_write,
 	.open = ivtv_v4l2_open,
 	.unlocked_ioctl = video_ioctl2,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = video_ioctl2, /* for ivtv_default() */
+#endif
 	.release = ivtv_v4l2_close,
 	.poll = ivtv_v4l2_enc_poll,
 };
@@ -61,6 +64,9 @@ static const struct v4l2_file_operations ivtv_v4l2_dec_fops = {
 	.write = ivtv_v4l2_write,
 	.open = ivtv_v4l2_open,
 	.unlocked_ioctl = video_ioctl2,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = video_ioctl2, /* for ivtv_default() */
+#endif
 	.release = ivtv_v4l2_close,
 	.poll = ivtv_v4l2_dec_poll,
 };
@@ -69,6 +75,9 @@ static const struct v4l2_file_operations ivtv_v4l2_radio_fops = {
 	.owner = THIS_MODULE,
 	.open = ivtv_v4l2_open,
 	.unlocked_ioctl = video_ioctl2,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = video_ioctl2, /* for ivtv_default() */
+#endif
 	.release = ivtv_v4l2_close,
 	.poll = ivtv_v4l2_enc_poll,
 };
diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index ef1bc17cdc4d..e738b2cef6f6 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -1533,6 +1533,7 @@ static const struct file_operations dvb_video_fops = {
 	.owner		= THIS_MODULE,
 	.write		= dvb_video_write,
 	.unlocked_ioctl	= dvb_generic_ioctl,
+	.compat_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_video_open,
 	.release	= dvb_video_release,
 	.poll		= dvb_video_poll,
@@ -1552,6 +1553,7 @@ static const struct file_operations dvb_audio_fops = {
 	.owner		= THIS_MODULE,
 	.write		= dvb_audio_write,
 	.unlocked_ioctl	= dvb_generic_ioctl,
+	.compat_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_audio_open,
 	.release	= dvb_audio_release,
 	.poll		= dvb_audio_poll,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 33f48933a865..7a1fac9cd1c2 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1164,37 +1164,6 @@ COMPATIBLE_IOCTL(HIDIOCGFLAG)
 COMPATIBLE_IOCTL(HIDIOCSFLAG)
 COMPATIBLE_IOCTL(HIDIOCGCOLLECTIONINDEX)
 COMPATIBLE_IOCTL(HIDIOCGCOLLECTIONINFO)
-/* dvb */
-COMPATIBLE_IOCTL(AUDIO_STOP)
-COMPATIBLE_IOCTL(AUDIO_PLAY)
-COMPATIBLE_IOCTL(AUDIO_PAUSE)
-COMPATIBLE_IOCTL(AUDIO_CONTINUE)
-COMPATIBLE_IOCTL(AUDIO_SELECT_SOURCE)
-COMPATIBLE_IOCTL(AUDIO_SET_MUTE)
-COMPATIBLE_IOCTL(AUDIO_SET_AV_SYNC)
-COMPATIBLE_IOCTL(AUDIO_SET_BYPASS_MODE)
-COMPATIBLE_IOCTL(AUDIO_CHANNEL_SELECT)
-COMPATIBLE_IOCTL(AUDIO_GET_STATUS)
-COMPATIBLE_IOCTL(AUDIO_GET_CAPABILITIES)
-COMPATIBLE_IOCTL(AUDIO_CLEAR_BUFFER)
-COMPATIBLE_IOCTL(AUDIO_SET_ID)
-COMPATIBLE_IOCTL(AUDIO_SET_MIXER)
-COMPATIBLE_IOCTL(AUDIO_SET_STREAMTYPE)
-COMPATIBLE_IOCTL(VIDEO_STOP)
-COMPATIBLE_IOCTL(VIDEO_PLAY)
-COMPATIBLE_IOCTL(VIDEO_FREEZE)
-COMPATIBLE_IOCTL(VIDEO_CONTINUE)
-COMPATIBLE_IOCTL(VIDEO_SELECT_SOURCE)
-COMPATIBLE_IOCTL(VIDEO_SET_BLANK)
-COMPATIBLE_IOCTL(VIDEO_GET_STATUS)
-COMPATIBLE_IOCTL(VIDEO_SET_DISPLAY_FORMAT)
-COMPATIBLE_IOCTL(VIDEO_FAST_FORWARD)
-COMPATIBLE_IOCTL(VIDEO_SLOWMOTION)
-COMPATIBLE_IOCTL(VIDEO_GET_CAPABILITIES)
-COMPATIBLE_IOCTL(VIDEO_CLEAR_BUFFER)
-COMPATIBLE_IOCTL(VIDEO_SET_STREAMTYPE)
-COMPATIBLE_IOCTL(VIDEO_SET_FORMAT)
-COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
 /* joystick */
 COMPATIBLE_IOCTL(JSIOCGVERSION)
 COMPATIBLE_IOCTL(JSIOCGAXES)
-- 
2.18.0
