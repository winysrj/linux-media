Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2833 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3H3Gmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 02:42:55 -0400
Message-ID: <52203EDB.8080308@xs4all.nl>
Date: Fri, 30 Aug 2013 08:42:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <posciak@chromium.org>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v1 14/19] v4l: Add v4l2_buffer flags for VP8-specific
 special frames.
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-15-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-15-git-send-email-posciak@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2013 04:17 AM, Pawel Osciak wrote:
> Add bits for previous, golden and altref frame types.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>

Kamil, is this something that applies as well to your MFC driver?

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

Would it be an idea to use the same bit values as for KEYFRAME/PFRAME/BFRAME?
After all, these can never be used at the same time. I'm a bit worried that the
bits in this field are eventually all used up by different encoder flags.

Regards,

	Hans

>  
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
> 

