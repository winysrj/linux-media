Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:21982 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752209AbdCFNGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 08:06:55 -0500
Date: Mon, 6 Mar 2017 15:06:09 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Randy Li <ayaka@soulik.info>
Cc: dri-devel@lists.freedesktop.org, clinton.a.taylor@intel.com,
        daniel@fooishbar.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/3] drm_fourcc: Add new P010, P016 video format
Message-ID: <20170306130609.GT31595@intel.com>
References: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
 <1488708033-5691-2-git-send-email-ayaka@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1488708033-5691-2-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 05, 2017 at 06:00:31PM +0800, Randy Li wrote:
> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
> per channel video format.
> 
> P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits
> per channel video format.
> 
> V3: Added P012 and fixed cpp for P010
> V4: format definition refined per review
> V5: Format comment block for each new pixel format
> V6: reversed Cb/Cr order in comments
> v7: reversed Cb/Cr order in comments of header files, remove
> the wrong part of commit message.

What? Why? You just undid what Clint did in v6.

> 
> Cc: Daniel Stone <daniel@fooishbar.org>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Signed-off-by: Randy Li <ayaka@soulik.info>
> Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
> ---
>  drivers/gpu/drm/drm_fourcc.c  |  3 +++
>  include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
> index 90d2cc8..3e0fd58 100644
> --- a/drivers/gpu/drm/drm_fourcc.c
> +++ b/drivers/gpu/drm/drm_fourcc.c
> @@ -165,6 +165,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
>  		{ .format = DRM_FORMAT_UYVY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>  		{ .format = DRM_FORMAT_VYUY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>  		{ .format = DRM_FORMAT_AYUV,		.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = DRM_FORMAT_P010,		.depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
> +		{ .format = DRM_FORMAT_P012,		.depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
> +		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
>  	};
>  
>  	unsigned int i;
> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
> index ef20abb..306f979 100644
> --- a/include/uapi/drm/drm_fourcc.h
> +++ b/include/uapi/drm/drm_fourcc.h
> @@ -128,6 +128,27 @@ extern "C" {
>  #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
>  
>  /*
> + * 2 plane YCbCr MSB aligned
> + * index 0 = Y plane, [15:0] Y:x [10:6] little endian
> + * index 1 = Cb:Cr plane, [31:0] Cb:x:Cr:x [10:6:10:6] little endian
> + */
> +#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cb:Cr plane 10 bits per channel */
> +
> +/*
> + * 2 plane YCbCr MSB aligned
> + * index 0 = Y plane, [15:0] Y:x [12:4] little endian
> + * index 1 = Cb:Cr plane, [31:0] Cb:x:Cr:x [12:4:12:4] little endian
> + */
> +#define DRM_FORMAT_P012		fourcc_code('P', '0', '1', '2') /* 2x2 subsampled Cb:Cr plane 12 bits per channel */
> +
> +/*
> + * 2 plane YCbCr MSB aligned
> + * index 0 = Y plane, [15:0] Y little endian
> + * index 1 = Cb:Cr plane, [31:0] Cb:Cr [16:16] little endian
> + */
> +#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cb:Cr plane 16 bits per channel */
> +
> +/*
>   * 3 plane YCbCr
>   * index 0: Y plane, [7:0] Y
>   * index 1: Cb plane, [7:0] Cb
> -- 
> 2.7.4

-- 
Ville Syrjälä
Intel OTC
