Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57362 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbcCEIFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 03:05:06 -0500
Subject: Re: [PATCH v2] media: add prefixes to interface types
To: Shuah Khan <shuahkh@osg.samsung.com>, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com
References: <1457126045-8108-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56DA9329.1010400@xs4all.nl>
Date: Sat, 5 Mar 2016 09:04:57 +0100
MIME-Version: 1.0
In-Reply-To: <1457126045-8108-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/04/2016 10:14 PM, Shuah Khan wrote:
> Add missing prefixes for DVB, V4L, and ALSA interface types.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
> 
> Changes since v1:
> Addresses Hans's comments on v1
> 
>  drivers/media/media-entity.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index bcd7464..e95070b 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -46,41 +46,41 @@ static inline const char *intf_type(struct media_interface *intf)
>  {
>  	switch (intf->type) {
>  	case MEDIA_INTF_T_DVB_FE:
> -		return "frontend";
> +		return "dvb-frontend";
>  	case MEDIA_INTF_T_DVB_DEMUX:
> -		return "demux";
> +		return "dvb-demux";
>  	case MEDIA_INTF_T_DVB_DVR:
> -		return "DVR";
> +		return "dvb-dvr";
>  	case MEDIA_INTF_T_DVB_CA:
> -		return  "CA";
> +		return  "dvb-ca";
>  	case MEDIA_INTF_T_DVB_NET:
> -		return "dvbnet";
> +		return "dvb-net";
>  	case MEDIA_INTF_T_V4L_VIDEO:
> -		return "video";
> +		return "v4l-video";
>  	case MEDIA_INTF_T_V4L_VBI:
> -		return "vbi";
> +		return "v4l-vbi";
>  	case MEDIA_INTF_T_V4L_RADIO:
> -		return "radio";
> +		return "v4l-radio";
>  	case MEDIA_INTF_T_V4L_SUBDEV:
> -		return "v4l2-subdev";
> +		return "v4l-subdev";
>  	case MEDIA_INTF_T_V4L_SWRADIO:
> -		return "swradio";
> +		return "v4l-swradio";
>  	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
> -		return "pcm-capture";
> +		return "alsa-pcm-capture";
>  	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
> -		return "pcm-playback";
> +		return "alsa-pcm-playback";
>  	case MEDIA_INTF_T_ALSA_CONTROL:
>  		return "alsa-control";
>  	case MEDIA_INTF_T_ALSA_COMPRESS:
> -		return "compress";
> +		return "alsa-compress";
>  	case MEDIA_INTF_T_ALSA_RAWMIDI:
> -		return "rawmidi";
> +		return "alsa-rawmidi";
>  	case MEDIA_INTF_T_ALSA_HWDEP:
> -		return "hwdep";
> +		return "alsa-hwdep";
>  	case MEDIA_INTF_T_ALSA_SEQUENCER:
> -		return "sequencer";
> +		return "alsa-sequencer";
>  	case MEDIA_INTF_T_ALSA_TIMER:
> -		return "timer";
> +		return "alsa-timer";
>  	default:
>  		return "unknown-intf";
>  	}
> 
