Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49717 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3BGLsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 06:48:30 -0500
Message-id: <5113948A.5070209@samsung.com>
Date: Thu, 07 Feb 2013 12:48:26 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LDOC <linux-doc@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] media: add support for decoder as one of media entity
 types
References: <1359373843-15956-1-git-send-email-prabhakar.lad@ti.com>
In-reply-to: <1359373843-15956-1-git-send-email-prabhakar.lad@ti.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 01/28/2013 12:50 PM, Prabhakar Lad wrote:
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 0ef8833..dac06d7 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -56,6 +56,8 @@ struct media_device_info {
>  #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
>  #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
>  #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
> +/* DECODER: Converts analogue video to digital */

The patch looks good to me, I would just change this comment to
something like:

/* A converter of analogue video to its digital representation. */

But that's really a nitpicking.

> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
>  
>  #define MEDIA_ENT_FL_DEFAULT		(1 << 0)

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Thanks,
Sylwester
