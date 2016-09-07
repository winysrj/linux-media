Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52576 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751259AbcIGJYJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 05:24:09 -0400
Subject: Re: [PATCH 2/4] docs-rst: Add compressed video formats used on MT8173
 codec driver
To: Tiffany Lin <tiffany.lin@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
References: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-2-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-3-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <246f1aca-0b46-b2f1-edd0-158a2a07b1d9@xs4all.nl>
Date: Wed, 7 Sep 2016 11:23:55 +0200
MIME-Version: 1.0
In-Reply-To: <1473231403-14900-3-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/16 08:56, Tiffany Lin wrote:
> Add V4L2_PIX_FMT_MT21C documentation
>
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  Documentation/media/uapi/v4l/pixfmt-reserved.rst |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> index 0dd2f7f..2e21fbc 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> @@ -339,7 +339,13 @@ please make a proposal on the linux-media mailing list.
>  	  array. Anything what's in between the UYVY lines is JPEG data and
>  	  should be concatenated to form the JPEG stream.
>
> +    -  .. _V4L2-PIX-FMT-MT21C:
>
> +       -  ``V4L2_PIX_FMT_MT21C``
> +
> +       -  'MT21C'
> +
> +       -  Compressed two-planar YVU420 format used by Mediatek MT8173.

This really needs to be expanded.

Ideally this should reference the precise specification of this format if
available.

It certainly should explain which HW blocks of the mediatek SoC use this
format, it should explain that is it meant as an opaque intermediate format
between those blocks.

If you have some characteristics (i.e. is it lossy or lossless 
compression, I
presume it's lossless), then that will be useful to add as well.

We like to have as much information about formats as possible.

Regards,

	Hans

>
>  .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
>
>
