Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45686 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754633AbeFNIEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 04:04:16 -0400
Received: by mail-wr0-f195.google.com with SMTP id o12-v6so5320472wrm.12
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 01:04:15 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] media: v4l2-ctrl: Change control for VP8 profile
 to menu control
To: Keiichi Watanabe <keiichiw@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        s.nawrocki@samsung.com
References: <20180614074652.162796-1-keiichiw@chromium.org>
 <20180614074652.162796-2-keiichiw@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <2c5a4dbf-6640-052b-a873-76b4c50abe73@linaro.org>
Date: Thu, 14 Jun 2018 11:04:11 +0300
MIME-Version: 1.0
In-Reply-To: <20180614074652.162796-2-keiichiw@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Keiichi,

On 06/14/2018 10:46 AM, Keiichi Watanabe wrote:
> Add a menu control V4L2_CID_MPEG_VIDEO_VP8_PROFILE for VP8 profile and
> make V4L2_CID_MPEG_VIDEO_VPX_PROFILE an alias of it. This new control
> is used to select a desired profile for VP8 encoder, and query for
> supported profiles by VP8 encoder/decoder.
> 
> Though we have originally a control V4L2_CID_MPEG_VIDEO_VPX_PROFILE and its name
> contains 'VPX', it works only for VP8 because supported profiles usually differ
> between VP8 and VP9. In addition, this contorol cannot be used for querying
> since it is not a menu control but an integer control, which cannot return an
> arbitrary set of supported profiles.
> 
> The new control V4L2_CID_MPEG_VIDEO_VP8_PROFILE is a menu control as with
> controls for other codec profiles. (e.g. H264)
> 
> In addition, this patch also fixes the use of
> V4L2_CID_MPEG_VIDEO_VPX_PROFILE in drivers of Qualcomm's venus and
> Samsung's s5p-mfc.
> 
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> ---
>  .../media/uapi/v4l/extended-controls.rst      | 27 ++++++++++++++++---
>  drivers/media/platform/qcom/venus/core.h      |  2 +-
>  .../media/platform/qcom/venus/hfi_helper.h    | 12 ++++-----
>  .../media/platform/qcom/venus/vdec_ctrls.c    | 10 ++++---
>  drivers/media/platform/qcom/venus/venc.c      | 14 +++++-----
>  .../media/platform/qcom/venus/venc_ctrls.c    | 12 +++++----
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  | 15 +++++------
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 12 ++++++++-
>  include/uapi/linux/v4l2-controls.h            | 11 +++++++-
>  9 files changed, 79 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index 03931f9b1285..de99eafb0872 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1955,9 +1955,30 @@ enum v4l2_vp8_golden_frame_sel -
>  ``V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP (integer)``
>      Quantization parameter for a P frame for VP8.
> 
> -``V4L2_CID_MPEG_VIDEO_VPX_PROFILE (integer)``
> -    Select the desired profile for VPx encoder. Acceptable values are 0,
> -    1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
> +.. _v4l2-mpeg-video-vp8-profile:
> +
> +``V4L2_CID_MPEG_VIDEO_VP8_PROFILE``
> +    (enum)
> +
> +enum v4l2_mpeg_video_vp8_profile -
> +    This control allows to select the profile for VP8 encoder.
> +    This is also used to enumerate supported profiles by VP8 encoder or decoder.
> +    Possible values are:
> +
> +
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_0``
> +      - Profile 0
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_1``
> +      - Profile 1
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_2``
> +      - Profile 2
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_3``
> +      - Profile 3
> 
> 
>  High Efficiency Video Coding (HEVC/H.265) Control Reference
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 0360d295f4c8..f242e7f9f6a2 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -159,7 +159,7 @@ struct venc_controls {
>  	struct {
>  		u32 mpeg4;
>  		u32 h264;
> -		u32 vpx;
> +		u32 vp8;
>  	} profile;
>  	struct {
>  		u32 mpeg4;
> diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
> index 55d8eb21403a..07bf49dd2ec6 100644
> --- a/drivers/media/platform/qcom/venus/hfi_helper.h
> +++ b/drivers/media/platform/qcom/venus/hfi_helper.h
> @@ -333,12 +333,12 @@
>  #define HFI_VC1_LEVEL_3				0x00000040
>  #define HFI_VC1_LEVEL_4				0x00000080
> 
> -#define HFI_VPX_PROFILE_SIMPLE			0x00000001
> -#define HFI_VPX_PROFILE_ADVANCED		0x00000002
> -#define HFI_VPX_PROFILE_VERSION_0		0x00000004
> -#define HFI_VPX_PROFILE_VERSION_1		0x00000008
> -#define HFI_VPX_PROFILE_VERSION_2		0x00000010
> -#define HFI_VPX_PROFILE_VERSION_3		0x00000020
> +#define HFI_VP8_PROFILE_SIMPLE			0x00000001
> +#define HFI_VP8_PROFILE_ADVANCED		0x00000002
> +#define HFI_VP8_PROFILE_VERSION_0		0x00000004
> +#define HFI_VP8_PROFILE_VERSION_1		0x00000008
> +#define HFI_VP8_PROFILE_VERSION_2		0x00000010
> +#define HFI_VP8_PROFILE_VERSION_3		0x00000020

Please do not rename these driver internal defines, just leave VPX as it
is now.


-- 
regards,
Stan
