Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46641 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753901Ab3HaRpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 13:45:01 -0400
Date: Sat, 31 Aug 2013 20:44:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v1 14/19] v4l: Add v4l2_buffer flags for VP8-specific
 special frames.
Message-ID: <20130831174428.GB4216@valkosipuli.retiisi.org.uk>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
 <1377829038-4726-15-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377829038-4726-15-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Fri, Aug 30, 2013 at 11:17:13AM +0900, Pawel Osciak wrote:
> Add bits for previous, golden and altref frame types.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  include/uapi/linux/videodev2.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 437f1b0..c011ee0 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -687,6 +687,10 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
>  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
>  #define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x4000
> +/* VP8 special frames */
> +#define V4L2_BUF_FLAG_PREV_FRAME		0x10000  /* VP8 prev frame */
> +#define V4L2_BUF_FLAG_GOLDEN_FRAME		0x20000  /* VP8 golden frame */
> +#define V4L2_BUF_FLAG_ALTREF_FRAME		0x40000  /* VP8 altref frame */

Whichever way this patch is changed, could you rebased it on "v4l: Use full
32 bits for buffer flags"? It changes the definitions of the flags use
32-bit values.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
