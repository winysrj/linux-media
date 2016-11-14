Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46970 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932176AbcKNKBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 05:01:23 -0500
Subject: Re: [RFC 03/10] v4l: Add sunxi Video Engine pixel format
To: Florent Revest <florent.revest@free-electrons.com>,
        linux-media@vger.kernel.org
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
 <1472117989-21455-4-git-send-email-florent.revest@free-electrons.com>
Cc: linux-sunxi@googlegroups.com, maxime.ripard@free-electrons.com,
        posciak@chromium.org, hans.verkuil@cisco.com,
        thomas.petazzoni@free-electrons.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, wens@csie.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1440b042-2ee7-4e65-52e5-2b16eb7f4e05@xs4all.nl>
Date: Mon, 14 Nov 2016 11:01:16 +0100
MIME-Version: 1.0
In-Reply-To: <1472117989-21455-4-git-send-email-florent.revest@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2016 11:39 AM, Florent Revest wrote:
> Add support for the allwinner's proprietary pixel format described in
> details here: http://linux-sunxi.org/File:Ve_tile_format_v1.pdf
> 
> This format is similar to V4L2_PIX_FMT_NV12M but the planes are divided
> in tiles of 32x32px.
> 
> Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
> ---
>  include/uapi/linux/videodev2.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 904c44c..96e034d 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -627,6 +627,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_Y8I      v4l2_fourcc('Y', '8', 'I', ' ') /* Greyscale 8-bit L/R interleaved */
>  #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
>  #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
> +#define V4L2_PIX_FMT_SUNXI    v4l2_fourcc('S', 'X', 'I', 'Y') /* Sunxi VE's 32x32 tiled NV12 */

This is very similar to V4L2_PIX_FMT_NV12MT_16X16. I think it can be added as
V4L2_PIX_FMT_NV12MT_32X32.

This needs to be documented in the V4L2 spec as well, of course.

Regards,

	Hans

>  
>  /* SDR formats - used only for Software Defined Radio devices */
>  #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
> 
