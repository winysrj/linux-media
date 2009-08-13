Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34057 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbZHMSzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 14:55:12 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n7DIt8Jt010914
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 13:55:13 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id n7DIt834003686
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 13:55:08 -0500 (CDT)
Received: from dsbe71.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n7DIt7Cs007553
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 13:55:07 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 13 Aug 2009 13:58:59 -0500
Subject: RE: [RFC][PATCH] v4l2: Add other RAW Bayer 10bit component orders
Message-ID: <A24693684029E5489D1D202277BE89444A7839CC@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE89444A7839B7@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89444A7839B7@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Aguirre Rodriguez, Sergio Alberto
> Sent: Thursday, August 13, 2009 1:51 PM
> To: linux-media@vger.kernel.org
> Subject: [RFC][PATCH] v4l2: Add other RAW Bayer 10bit component orders
> 
> From: Sergio Aguirre <saaguirre@ti.com>
> 
> This helps clarifying different pattern orders for RAW Bayer 10 bit
> cases.

My intention with this patch is to help sensor drivers letting know the userspace (or a v4l2_device master) the exact order of components a sensor is outputting...

Please share your comments/thoughts/kicks :)

Regards,
Sergio
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  include/linux/videodev2.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 9e66c50..8aa6255 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -327,6 +327,9 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0')
>  /* 10bit raw bayer DPCM compressed to 8 bits */
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> +#define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0')
> +#define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0')
> +#define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0')
>  #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16
> BGBG.. GRGR.. */
> 
>  /* compressed formats */
> --
> 1.6.3.2

