Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1932 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaGRTfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 15:35:18 -0400
Message-ID: <53C976E8.9070501@xs4all.nl>
Date: Fri, 18 Jul 2014 21:35:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] v4l: videodev2: add buffer size to SDR format
References: <1405711769-8463-1-git-send-email-crope@iki.fi>
In-Reply-To: <1405711769-8463-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 09:29 PM, Antti Palosaari wrote:
> Add buffer size field to struct v4l2_sdr_format. It is used for
> negotiate streaming buffer size between application and driver.

Yes, that's what I had in mind. Can you provide a DocBook patch as
well?

This patch:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  include/uapi/linux/videodev2.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 25ab057..0dd5ffb 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1724,10 +1724,12 @@ struct v4l2_pix_format_mplane {
>  /**
>   * struct v4l2_sdr_format - SDR format definition
>   * @pixelformat:	little endian four character code (fourcc)
> + * @buffersize:		maximum size in bytes required for data
>   */
>  struct v4l2_sdr_format {
>  	__u32				pixelformat;
> -	__u8				reserved[28];
> +	__u32				buffersize;
> +	__u8				reserved[24];
>  } __attribute__ ((packed));
>  
>  /**
> 

