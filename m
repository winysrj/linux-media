Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42216 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbcGRLzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 07:55:39 -0400
Subject: Re: [PATCH v2 3/3] [media] hva: add H.264 video encoding support
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
	linux-media@vger.kernel.org
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
 <1468250057-16395-4-git-send-email-jean-christophe.trotin@st.com>
Cc: kernel@stlinux.com,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick Fertre <yannick.fertre@st.com>,
	Hugues Fruchet <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1fe2ef16-5335-cb5c-253e-533cd3dc8b41@xs4all.nl>
Date: Mon, 18 Jul 2016 13:55:33 +0200
MIME-Version: 1.0
In-Reply-To: <1468250057-16395-4-git-send-email-jean-christophe.trotin@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2016 05:14 PM, Jean-Christophe Trotin wrote:
> This patch adds the H.264 video encoding capability in the V4L2 HVA
> video encoder driver for STMicroelectronics SoC (hva-h264.c).
> 
> The main supported features are:
> - profile: baseline, main, high, stereo high
> - level: up to 4.2
> - bitrate mode: CBR, VBR
> - entropy mode: CABAC, CAVLC
> - video aspect: 1x1 only
> 
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> ---
>  drivers/media/platform/sti/hva/Makefile   |    2 +-
>  drivers/media/platform/sti/hva/hva-h264.c | 1053 +++++++++++++++++++++++++++++
>  drivers/media/platform/sti/hva/hva-v4l2.c |  107 ++-
>  drivers/media/platform/sti/hva/hva.h      |  115 +++-
>  4 files changed, 1270 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/media/platform/sti/hva/hva-h264.c
> 

<snip>

> diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
> index 9a1b503b..a81f313 100644
> --- a/drivers/media/platform/sti/hva/hva.h
> +++ b/drivers/media/platform/sti/hva/hva.h
> @@ -23,6 +23,9 @@
>  
>  #define HVA_PREFIX "[---:----]"
>  
> +extern const struct hva_enc nv12h264enc;
> +extern const struct hva_enc nv21h264enc;
> +
>  /**
>   * struct hva_frameinfo - information about hva frame
>   *
> @@ -67,13 +70,35 @@ struct hva_streaminfo {
>   * @gop_size:       groupe of picture size
>   * @bitrate:        bitrate (in kbps)
>   * @aspect:         video aspect
> + * @profile:        H.264 profile
> + * @level:          H.264 level
> + * @entropy_mode:   H.264 entropy mode (CABAC or CVLC)
> + * @cpb_size:       coded picture buffer size (in kbps)
> + * @dct8x8:         transform mode 8x8 enable
> + * @qpmin:          minimum quantizer
> + * @qpmax:          maximum quantizer
> + * @vui_sar:        pixel aspect ratio enable
> + * @vui_sar_idc:    pixel aspect ratio identifier
> + * @sei_fp:         sei frame packing arrangement enable
> + * @sei_fp_type:    sei frame packing arrangement type
>   */
>  struct hva_controls {
> -	struct v4l2_fract			time_per_frame;
> -	enum v4l2_mpeg_video_bitrate_mode	bitrate_mode;
> -	u32					gop_size;
> -	u32					bitrate;
> -	enum v4l2_mpeg_video_aspect		aspect;
> +	struct v4l2_fract					time_per_frame;
> +	enum v4l2_mpeg_video_bitrate_mode			bitrate_mode;
> +	u32							gop_size;
> +	u32							bitrate;
> +	enum v4l2_mpeg_video_aspect				aspect;
> +	enum v4l2_mpeg_video_h264_profile			profile;
> +	enum v4l2_mpeg_video_h264_level				level;
> +	enum v4l2_mpeg_video_h264_entropy_mode			entropy_mode;
> +	u32							cpb_size;
> +	bool							dct8x8;
> +	u32							qpmin;
> +	u32							qpmax;
> +	bool							vui_sar;
> +	enum v4l2_mpeg_video_h264_vui_sar_idc			vui_sar_idc;
> +	bool							sei_fp;
> +	enum v4l2_mpeg_video_h264_sei_fp_arrangement_type	sei_fp_type;
>  };
>  
>  /**
> @@ -281,4 +306,84 @@ struct hva_enc {
>  				  struct hva_stream *stream);
>  };
>  
> +static inline const char *profile_str(unsigned int p)
> +{
> +	switch (p) {
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
> +		return "baseline profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
> +		return "main profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED:
> +		return "extended profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
> +		return "high profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10:
> +		return "high 10 profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422:
> +		return "high 422 profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_PREDICTIVE:
> +		return "high 444 predictive profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10_INTRA:
> +		return "high 10 intra profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422_INTRA:
> +		return "high 422 intra profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_INTRA:
> +		return "high 444 intra profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_CAVLC_444_INTRA:
> +		return "calvc 444 intra profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_BASELINE:
> +		return "scalable baseline profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH:
> +		return "scalable high profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH_INTRA:
> +		return "scalable high intra profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH:
> +		return "stereo high profile";
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH:
> +		return "multiview high profile";
> +	default:
> +		return "unknown profile";
> +	}
> +}
> +
> +static inline const char *level_str(enum v4l2_mpeg_video_h264_level l)
> +{
> +	switch (l) {
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
> +		return "level 1.0";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
> +		return "level 1b";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
> +		return "level 1.1";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
> +		return "level 1.2";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
> +		return "level 1.3";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
> +		return "level 2.0";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
> +		return "level 2.1";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
> +		return "level 2.2";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
> +		return "level 3.0";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
> +		return "level 3.1";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
> +		return "level 3.2";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
> +		return "level 4.0";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
> +		return "level 4.1";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
> +		return "level 4.2";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_5_0:
> +		return "level 5.0";
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_5_1:
> +		return "level 5.1";
> +	default:
> +		return "unknown level";
> +	}
> +}

These two static inlines should be replaced. You can get the menu strings directly
with v4l2_ctrl_get_menu(). No need to duplicate these strings here.

Regards,

	Hans

> +
>  #endif /* HVA_H */
> 
