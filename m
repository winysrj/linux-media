Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0FGMp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 08:45:58 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o57Cjvu5018382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jun 2010 08:45:57 -0400
Message-ID: <4C0CEA72.4090308@redhat.com>
Date: Mon, 07 Jun 2010 14:47:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: huzaifas@redhat.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4l1: move VIDIOCGAUDIO and VIDIOCSAUDIO to libv4l1
References: <1275904258-25889-1-git-send-email-huzaifas@redhat.com>
In-Reply-To: <1275904258-25889-1-git-send-email-huzaifas@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

See comments inline.

On 06/07/2010 11:50 AM, huzaifas@redhat.com wrote:
> From: Huzaifa Sidhpurwala<huzaifas@redhat.com>
>
> move VIDIOCGAUDIO and VIDIOCSAUDIO to libv4l1
>
> Signed-of-by: Huzaifa Sidhpurwala<huzaifas@redhat.com>
> ---
>   lib/libv4l1/libv4l1-priv.h |    7 ++
>   lib/libv4l1/libv4l1.c      |  160 ++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 167 insertions(+), 0 deletions(-)
>
> diff --git a/lib/libv4l1/libv4l1-priv.h b/lib/libv4l1/libv4l1-priv.h
> index 11f4fd0..11ee57a 100644
> --- a/lib/libv4l1/libv4l1-priv.h
> +++ b/lib/libv4l1/libv4l1-priv.h
> @@ -60,6 +60,13 @@ extern FILE *v4l1_log_file;
>   #define min(a, b) (((a)<  (b)) ? (a) : (b))
>   #endif
>
> +#define DIV_ROUND_CLOSEST(x, divisor)(                  \
> +{                                                       \
> +	typeof(divisor) __divisor = divisor;            \
> +	(((x) + ((__divisor) / 2)) / (__divisor));      \
> +}                                                       \
> +)
> +
>   struct v4l1_dev_info {
>   	int fd;
>   	int flags;
> diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
> index 2981c40..263d564 100644
> --- a/lib/libv4l1/libv4l1.c
> +++ b/lib/libv4l1/libv4l1.c
> @@ -233,6 +233,59 @@ static int v4l1_set_format(int index, unsigned int width,
>   	return result;
>   }
>
> +static int set_v4l_control(int fd, int cid, int value)
> +{
> +	struct v4l2_queryctrl qctrl2;
> +	struct v4l2_control ctrl2;
> +	int result;
> +
> +	qctrl2.id = cid;
> +	result = v4l2_ioctl(fd, VIDIOC_QUERYCTRL,&qctrl2);
> +	if (result<  0)
> +		return 0;
> +	if (result == 0&&
> +	!(qctrl2.flags&  V4L2_CTRL_FLAG_DISABLED)&&
> +	!(qctrl2.flags&  V4L2_CTRL_FLAG_GRABBED)) {
> +		if (value<  0)
> +			value = 0;
> +		if (value>  65535)
> +			value = 65535;
> +		if (value&&  qctrl2.type == V4L2_CTRL_TYPE_BOOLEAN)
> +			value = 65535;
> +			ctrl2.id = qctrl2.id;
> +			ctrl2.value =
> +			(value * (qctrl2.maximum - qctrl2.minimum)
> +			+ 32767)
> +			/ 65535;
> +		ctrl2.value += qctrl2.minimum;
> +		result = v4l2_ioctl(fd, VIDIOC_S_CTRL,&ctrl2);
> +	}
> +	return 0;
> +}
> +
> +static int get_v4l_control(int fd, int cid)
> +{
> +	struct v4l2_queryctrl qctrl2;
> +	struct v4l2_control ctrl2;
> +	int result;
> +
> +	qctrl2.id = cid;
> +	result = v4l2_ioctl(fd, VIDIOC_QUERYCTRL,&qctrl2);
> +	if (result<  0)
> +		return 0;
> +	if (result == 0&&  !(qctrl2.flags&  V4L2_CTRL_FLAG_DISABLED)) {
> +		ctrl2.id = qctrl2.id;
> +		result = v4l2_ioctl(fd, VIDIOC_G_CTRL,&ctrl2);
> +		if (result<  0)
> +			return 0;
> +
> +		return DIV_ROUND_CLOSEST((ctrl2.value-qctrl2.minimum) * 65535,
> +			qctrl2.maximum - qctrl2.minimum);
> +	}
> +	return 0;
> +}
> +
> +

These 2 functions are already present in libv4l2, they are called
v4l2_set_control and v4l2_get_control resp.

Regards,

Hans


>   static void v4l1_find_min_and_max_size(int index, struct v4l2_format *fmt2)
>   {
>   	int i;
> @@ -983,6 +1036,113 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
>
>   		break;
>   	}
> +
> +	case VIDIOCSAUDIO: {
> +		struct video_audio *aud = arg;
> +		struct v4l2_audio aud2 = { 0, };
> +		struct v4l2_tuner tun2 = { 0, };
> +
> +		aud2.index = aud->audio;
> +		result = v4l2_ioctl(fd, VIDIOC_S_AUDIO,&aud2);
> +		if (result<  0)
> +			break;
> +
> +		set_v4l_control(fd, V4L2_CID_AUDIO_VOLUME,
> +			aud->volume);
> +		set_v4l_control(fd, V4L2_CID_AUDIO_BASS,
> +			aud->bass);
> +		set_v4l_control(fd, V4L2_CID_AUDIO_TREBLE,
> +			aud->treble);
> +		set_v4l_control(fd, V4L2_CID_AUDIO_BALANCE,
> +			aud->balance);
> +		set_v4l_control(fd, V4L2_CID_AUDIO_MUTE,
> +			!!(aud->flags&  VIDEO_AUDIO_MUTE));
> +
> +		result = v4l2_ioctl(fd, VIDIOC_G_TUNER,&tun2);
> +		if (result<  0)
> +			break;
> +		if (result == 0) {
> +			switch (aud->mode) {
> +			default:
> +			case VIDEO_SOUND_MONO:
> +			case VIDEO_SOUND_LANG1:
> +				tun2.audmode = V4L2_TUNER_MODE_MONO;
> +				break;
> +			case VIDEO_SOUND_STEREO:
> +				tun2.audmode = V4L2_TUNER_MODE_STEREO;
> +				break;
> +			case VIDEO_SOUND_LANG2:
> +				tun2.audmode = V4L2_TUNER_MODE_LANG2;
> +				break;
> +			}
> +			result = v4l2_ioctl(fd, VIDIOC_S_TUNER,&tun2);
> +		}
> +		break;
> +	}
> +
> +	case VIDIOCGAUDIO: {
> +		int i;
> +		struct video_audio *aud = arg;
> +		struct v4l2_queryctrl qctrl2;
> +		struct v4l2_audio aud2 = { 0, };
> +		struct v4l2_tuner tun2;
> +
> +		result = v4l2_ioctl(fd, VIDIOC_G_AUDIO,&aud2);
> +		if (result<  0)
> +			break;
> +
> +		memcpy(aud->name, aud2.name,
> +			min(sizeof(aud->name), sizeof(aud2.name)));
> +		aud->name[sizeof(aud->name) - 1] = 0;
> +		aud->audio = aud2.index;
> +		aud->flags = 0;
> +		i = get_v4l_control(fd, V4L2_CID_AUDIO_VOLUME);
> +		if (i>= 0) {
> +			aud->volume = i;
> +			aud->flags |= VIDEO_AUDIO_VOLUME;
> +		}
> +		i = get_v4l_control(fd, V4L2_CID_AUDIO_BASS);
> +		if (i>= 0) {
> +			aud->bass = i;
> +			aud->flags |= VIDEO_AUDIO_BASS;
> +		}
> +		i = get_v4l_control(fd, V4L2_CID_AUDIO_TREBLE);
> +		if (i>= 0) {
> +			aud->treble = i;
> +			aud->flags |= VIDEO_AUDIO_TREBLE;
> +		}
> +		i = get_v4l_control(fd, V4L2_CID_AUDIO_BALANCE);
> +		if (i>= 0) {
> +			aud->balance = i;
> +			aud->flags |= VIDEO_AUDIO_BALANCE;
> +		}
> +		i = get_v4l_control(fd, V4L2_CID_AUDIO_MUTE);
> +		if (i>= 0) {
> +			if (i)
> +				aud->flags |= VIDEO_AUDIO_MUTE;
> +
> +			aud->flags |= VIDEO_AUDIO_MUTABLE;
> +		}
> +		aud->step = 1;
> +		qctrl2.id = V4L2_CID_AUDIO_VOLUME;
> +		if (v4l2_ioctl(fd, VIDIOC_QUERYCTRL,&qctrl2) == 0&&
> +			!(qctrl2.flags&  V4L2_CTRL_FLAG_DISABLED))
> +			aud->step = qctrl2.step;
> +		aud->mode = 0;
> +
> +		result = v4l2_ioctl(fd, VIDIOC_G_TUNER,&tun2);
> +		if (result<  0)
> +			break;
> +
> +		if (tun2.rxsubchans&  V4L2_TUNER_SUB_LANG2)
> +			aud->mode = VIDEO_SOUND_LANG1 | VIDEO_SOUND_LANG2;
> +		else if (tun2.rxsubchans&  V4L2_TUNER_SUB_STEREO)
> +			aud->mode = VIDEO_SOUND_STEREO;
> +		else if (tun2.rxsubchans&  V4L2_TUNER_SUB_MONO)
> +			aud->mode = VIDEO_SOUND_MONO;
> +
> +	}
> +
>   	default:
>   		/* Pass through libv4l2 for applications which are using v4l2 through
>   		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
