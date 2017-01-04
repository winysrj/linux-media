Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:58737 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967226AbdADP4h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jan 2017 10:56:37 -0500
Date: Wed, 4 Jan 2017 17:56:32 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Randy Li <ayaka@soulik.info>
Cc: dri-devel@lists.freedesktop.org, randy.li@rock-chips.com,
        linux-kernel@vger.kernel.org, daniel.vetter@intel.com,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] drm_fourcc: Add new P010 video format
Message-ID: <20170104155632.GI31595@intel.com>
References: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
 <1483347004-32593-2-git-send-email-ayaka@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1483347004-32593-2-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 02, 2017 at 04:50:03PM +0800, Randy Li wrote:
> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
> per channel video format. Rockchip's vop support this
> video format(little endian only) as the input video format.
> 
> Signed-off-by: Randy Li <ayaka@soulik.info>
> ---
>  include/uapi/drm/drm_fourcc.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
> index 9e1bb7f..d2721da 100644
> --- a/include/uapi/drm/drm_fourcc.h
> +++ b/include/uapi/drm/drm_fourcc.h
> @@ -119,6 +119,7 @@ extern "C" {
>  #define DRM_FORMAT_NV61		fourcc_code('N', 'V', '6', '1') /* 2x1 subsampled Cb:Cr plane */
>  #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
>  #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
> +#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */

We could use a better description of the format here. IIRC there is
10bits of actual data contained in each 16bits. So there should be a
proper comment explaning in which way the bits are stored.

>  
>  /*
>   * 3 plane YCbCr
> -- 
> 2.7.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel OTC
