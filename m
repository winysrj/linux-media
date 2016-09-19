Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:53910 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750790AbcISJj1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 05:39:27 -0400
Message-ID: <1474277960.25758.12.camel@mtksdaap41>
Subject: Re: [PATCH] pixfmt-reserved.rst: Improve MT21C documentation
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 19 Sep 2016 17:39:20 +0800
In-Reply-To: <82516dbf-d85e-ac69-0059-8235e4903e5a@xs4all.nl>
References: <82516dbf-d85e-ac69-0059-8235e4903e5a@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-09-19 at 09:22 +0200, Hans Verkuil wrote:
> Improve the MT21C documentation, making it clearer that this format requires the MDP
> for further processing.
> 
> Also fix the fourcc (it was a fivecc :-) )
> 
reviewed-by: Tiffany Lin <tiffany.lin@mediatek.com>

Thanks. I did not notice it become fivecc.

best regards,
Tiffany

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> index 0989e99..a019f15 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> @@ -343,13 +343,13 @@ please make a proposal on the linux-media mailing list.
> 
>         -  ``V4L2_PIX_FMT_MT21C``
> 
> -       -  'MT21C'
> +       -  'MT21'
> 
>         -  Compressed two-planar YVU420 format used by Mediatek MT8173.
>            The compression is lossless.
> -          It is an opaque intermediate format, and MDP HW could convert
> -          V4L2_PIX_FMT_MT21C to V4L2_PIX_FMT_NV12M,
> -          V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.
> +          It is an opaque intermediate format and the MDP hardware must be
> +	  used to convert ``V4L2_PIX_FMT_MT21C`` to ``V4L2_PIX_FMT_NV12M``,
> +          ``V4L2_PIX_FMT_YUV420M`` or ``V4L2_PIX_FMT_YVU420``.
> 
>  .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> 


