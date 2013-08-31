Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46657 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753501Ab3HaRxA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 13:53:00 -0400
Date: Sat, 31 Aug 2013 20:52:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v1 18/19] v4l: Add V4L2_PIX_FMT_VP8_SIMULCAST format.
Message-ID: <20130831175256.GC4216@valkosipuli.retiisi.org.uk>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
 <1377829038-4726-19-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377829038-4726-19-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thanks for the patchset.

On Fri, Aug 30, 2013 at 11:17:17AM +0900, Pawel Osciak wrote:
> This format is used by UVC 1.5 VP8-encoding cameras. When it is used, the camera
> may encode captured frames into one or more streams, each of which may
> be configured differently. This allows simultaneous capture of streams
> with different resolutions, bitrates, and other settings, depending on the
> camera capabilities.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  include/uapi/linux/videodev2.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index c011ee0..8b0d4ad 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -402,6 +402,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
>  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
>  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
> +#define V4L2_PIX_FMT_VP8_SIMULCAST v4l2_fourcc('V', 'P', '8', 'S') /* VP8 simulcast */
>  
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
> @@ -691,6 +692,9 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_PREV_FRAME		0x10000  /* VP8 prev frame */
>  #define V4L2_BUF_FLAG_GOLDEN_FRAME		0x20000  /* VP8 golden frame */
>  #define V4L2_BUF_FLAG_ALTREF_FRAME		0x40000  /* VP8 altref frame */
> +/* Simulcast layer structure. */
> +#define V4L2_BUF_FLAG_LAYER_STRUCTURE_SHIFT	19  /* Bits 19-20 for layer */
> +#define V4L2_BUF_FLAG_LAYER_STRUCTURE_MASK	0x3 /* structure information. */

What do these bits signify? It'd be also nice to document them.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
