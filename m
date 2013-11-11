Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44040 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3KKB1V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 20:27:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 14/19] v4l: Add v4l2_buffer flags for VP8-specific special frames.
Date: Mon, 11 Nov 2013 02:27:56 +0100
Message-ID: <6957886.N8km1roI0D@avalon>
In-Reply-To: <1377829038-4726-15-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-15-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:13 Pawel Osciak wrote:
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

This required documentation in Documentation/DocBook/media/ :-)

>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> descriptor
-- 
Regards,

Laurent Pinchart

