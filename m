Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0FHDoy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 23:44:54 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o583iscK015113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jun 2010 23:44:54 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] libv4l1: move VIDIOCGAUDIO,VIDIOCSAUDIO,VIDIOCGVBIFMT,VIDIOCSVBIFMT
Date: Tue,  8 Jun 2010 09:12:57 +0530
Message-Id: <1275968577-28067-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@redhat.com>

merged two previous patches, now uses v4l2_set_control and
v4l2_get_control

Signed-of-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
---
 lib/libv4l1/libv4l1-priv.h |    7 ++
 lib/libv4l1/libv4l1.c      |  172 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+), 0 deletions(-)

diff --git a/lib/libv4l1/libv4l1-priv.h b/lib/libv4l1/libv4l1-priv.h
index 11f4fd0..11ee57a 100644
--- a/lib/libv4l1/libv4l1-priv.h
+++ b/lib/libv4l1/libv4l1-priv.h
@@ -60,6 +60,13 @@ extern FILE *v4l1_log_file;
 #define min(a, b) (((a) < (b)) ? (a) : (b))
 #endif
 
+#define DIV_ROUND_CLOSEST(x, divisor)(                  \
+{                                                       \
+	typeof(divisor) __divisor = divisor;            \
+	(((x) + ((__divisor) / 2)) / (__divisor));      \
+}                                                       \
+)
+
 struct v4l1_dev_info {
 	int fd;
 	int flags;
diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index 2981c40..830ed6b 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -983,6 +983,178 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 
 		break;
 	}
+
+	case VIDIOCSAUDIO: {
+		struct video_audio *aud = arg;
+		struct v4l2_audio aud2 = { 0, };
+		struct v4l2_tuner tun2 = { 0, };
+
+		aud2.index = aud->audio;
+		result = v4l2_ioctl(fd, VIDIOC_S_AUDIO, &aud2);
+		if (result < 0)
+			break;
+
+		v4l2_set_control(fd, V4L2_CID_AUDIO_VOLUME,
+			aud->volume);
+		v4l2_set_control(fd, V4L2_CID_AUDIO_BASS,
+			aud->bass);
+		v4l2_set_control(fd, V4L2_CID_AUDIO_TREBLE,
+			aud->treble);
+		v4l2_set_control(fd, V4L2_CID_AUDIO_BALANCE,
+			aud->balance);
+		v4l2_set_control(fd, V4L2_CID_AUDIO_MUTE,
+			!!(aud->flags & VIDEO_AUDIO_MUTE));
+
+		result = v4l2_ioctl(fd, VIDIOC_G_TUNER, &tun2);
+		if (result < 0)
+			break;
+		if (result == 0) {
+			switch (aud->mode) {
+			default:
+			case VIDEO_SOUND_MONO:
+			case VIDEO_SOUND_LANG1:
+				tun2.audmode = V4L2_TUNER_MODE_MONO;
+				break;
+			case VIDEO_SOUND_STEREO:
+				tun2.audmode = V4L2_TUNER_MODE_STEREO;
+				break;
+			case VIDEO_SOUND_LANG2:
+				tun2.audmode = V4L2_TUNER_MODE_LANG2;
+				break;
+			}
+			result = v4l2_ioctl(fd, VIDIOC_S_TUNER, &tun2);
+		}
+		break;
+	}
+
+	case VIDIOCGAUDIO: {
+		int i;
+		struct video_audio *aud = arg;
+		struct v4l2_queryctrl qctrl2;
+		struct v4l2_audio aud2 = { 0, };
+		struct v4l2_tuner tun2;
+
+		result = v4l2_ioctl(fd, VIDIOC_G_AUDIO, &aud2);
+		if (result < 0)
+			break;
+
+		memcpy(aud->name, aud2.name,
+			min(sizeof(aud->name), sizeof(aud2.name)));
+		aud->name[sizeof(aud->name) - 1] = 0;
+		aud->audio = aud2.index;
+		aud->flags = 0;
+		i = v4l2_get_control(fd, V4L2_CID_AUDIO_VOLUME);
+		if (i >= 0) {
+			aud->volume = i;
+			aud->flags |= VIDEO_AUDIO_VOLUME;
+		}
+		i = v4l2_get_control(fd, V4L2_CID_AUDIO_BASS);
+		if (i >= 0) {
+			aud->bass = i;
+			aud->flags |= VIDEO_AUDIO_BASS;
+		}
+		i = v4l2_get_control(fd, V4L2_CID_AUDIO_TREBLE);
+		if (i >= 0) {
+			aud->treble = i;
+			aud->flags |= VIDEO_AUDIO_TREBLE;
+		}
+		i = v4l2_get_control(fd, V4L2_CID_AUDIO_BALANCE);
+		if (i >= 0) {
+			aud->balance = i;
+			aud->flags |= VIDEO_AUDIO_BALANCE;
+		}
+		i = v4l2_get_control(fd, V4L2_CID_AUDIO_MUTE);
+		if (i >= 0) {
+			if (i)
+				aud->flags |= VIDEO_AUDIO_MUTE;
+
+			aud->flags |= VIDEO_AUDIO_MUTABLE;
+		}
+		aud->step = 1;
+		qctrl2.id = V4L2_CID_AUDIO_VOLUME;
+		if (v4l2_ioctl(fd, VIDIOC_QUERYCTRL, &qctrl2) == 0 &&
+			!(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED))
+			aud->step = qctrl2.step;
+		aud->mode = 0;
+
+		result = v4l2_ioctl(fd, VIDIOC_G_TUNER, &tun2);
+		if (result < 0)
+			break;
+
+		if (tun2.rxsubchans & V4L2_TUNER_SUB_LANG2)
+			aud->mode = VIDEO_SOUND_LANG1 | VIDEO_SOUND_LANG2;
+		else if (tun2.rxsubchans & V4L2_TUNER_SUB_STEREO)
+			aud->mode = VIDEO_SOUND_STEREO;
+		else if (tun2.rxsubchans & V4L2_TUNER_SUB_MONO)
+			aud->mode = VIDEO_SOUND_MONO;
+
+	}
+
+	case VIDIOCSVBIFMT: {
+		struct vbi_format *fmt = arg;
+		struct v4l2_format fmt2;
+
+		if (VIDEO_PALETTE_RAW != fmt->sample_format) {
+			result = -EINVAL;
+			break;
+		}
+
+		fmt2.type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		fmt2.fmt.vbi.samples_per_line = fmt->samples_per_line;
+		fmt2.fmt.vbi.sampling_rate    = fmt->sampling_rate;
+		fmt2.fmt.vbi.sample_format    = V4L2_PIX_FMT_GREY;
+		fmt2.fmt.vbi.start[0]         = fmt->start[0];
+		fmt2.fmt.vbi.count[0]         = fmt->count[0];
+		fmt2.fmt.vbi.start[1]         = fmt->start[1];
+		fmt2.fmt.vbi.count[1]         = fmt->count[1];
+		fmt2.fmt.vbi.flags            = fmt->flags;
+
+		result  = v4l2_ioctl(fd, VIDIOC_TRY_FMT, fmt2);
+		if (result < 0)
+			break;
+
+		if (fmt2.fmt.vbi.samples_per_line != fmt->samples_per_line ||
+		fmt2.fmt.vbi.sampling_rate    != fmt->sampling_rate    ||
+		fmt2.fmt.vbi.sample_format    != V4L2_PIX_FMT_GREY     ||
+		fmt2.fmt.vbi.start[0]         != fmt->start[0]         ||
+		fmt2.fmt.vbi.count[0]         != fmt->count[0]         ||
+		fmt2.fmt.vbi.start[1]         != fmt->start[1]         ||
+		fmt2.fmt.vbi.count[1]         != fmt->count[1]         ||
+		fmt2.fmt.vbi.flags            != fmt->flags) {
+			result = -EINVAL;
+			break;
+		}
+		result = v4l2_ioctl(fd, VIDIOC_S_FMT, fmt2);
+
+	}
+
+	case VIDIOCGVBIFMT: {
+		struct vbi_format *fmt = arg;
+		struct v4l2_format fmt2 = { 0, };
+
+		fmt2.type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		result = v4l2_ioctl(fd, VIDIOC_G_FMT, &fmt2);
+
+		if (result < 0)
+			break;
+
+		if (fmt2.fmt.vbi.sample_format != V4L2_PIX_FMT_GREY) {
+			result = -EINVAL;
+			break;
+		}
+
+		fmt->samples_per_line = fmt2.fmt.vbi.samples_per_line;
+		fmt->sampling_rate    = fmt2.fmt.vbi.sampling_rate;
+		fmt->sample_format    = VIDEO_PALETTE_RAW;
+		fmt->start[0]         = fmt2.fmt.vbi.start[0];
+		fmt->count[0]         = fmt2.fmt.vbi.count[0];
+		fmt->start[1]         = fmt2.fmt.vbi.start[1];
+		fmt->count[1]         = fmt2.fmt.vbi.count[1];
+		fmt->flags            = fmt2.fmt.vbi.flags & 0x03;
+
+		break;
+	}
+
 	default:
 		/* Pass through libv4l2 for applications which are using v4l2 through
 		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
-- 
1.6.6.1

