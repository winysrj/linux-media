Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39215 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753003AbdDDJRs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 05:17:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Subject: Re: [PATCH v6 3/6] documentation: media: Add documentation for new RGB and YUV bus formats
Date: Tue, 04 Apr 2017 12:18:32 +0300
Message-ID: <3288495.AjVEEfrlY9@avalon>
In-Reply-To: <1491230558-10804-4-git-send-email-narmstrong@baylibre.com>
References: <1491230558-10804-1-git-send-email-narmstrong@baylibre.com> <1491230558-10804-4-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Thank you for the patch.

On Monday 03 Apr 2017 16:42:35 Neil Armstrong wrote:
> Add documentation for added Bus Formats to describe RGB and YUV formats used
> as input to the Synopsys DesignWare HDMI TX Controller.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Archit Taneja <architt@codeaurora.org>
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/media/uapi/v4l/subdev-formats.rst | 960 ++++++++++++++++++++-
>  1 file changed, 959 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst
> b/Documentation/media/uapi/v4l/subdev-formats.rst index d6152c9..4032d97
> 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -1258,6 +1258,319 @@ The following tables list existing packed RGB
> formats. - b\ :sub:`2`
>        - b\ :sub:`1`
>        - b\ :sub:`0`
> +    * .. _MEDIA-BUS-FMT-RGB101010-1X30:
> +
> +      - MEDIA_BUS_FMT_RGB101010_1X30
> +      - 0x1018
> +      -
> +      - 0
> +      - 0
> +      - r\ :sub:`9`
> +      - r\ :sub:`8`
> +      - r\ :sub:`7`
> +      - r\ :sub:`6`
> +      - r\ :sub:`5`
> +      - r\ :sub:`4`
> +      - r\ :sub:`3`
> +      - r\ :sub:`2`
> +      - r\ :sub:`1`
> +      - r\ :sub:`0`
> +      - g\ :sub:`9`
> +      - g\ :sub:`8`
> +      - g\ :sub:`7`
> +      - g\ :sub:`6`
> +      - g\ :sub:`5`
> +      - g\ :sub:`4`
> +      - g\ :sub:`3`
> +      - g\ :sub:`2`
> +      - g\ :sub:`1`
> +      - g\ :sub:`0`
> +      - b\ :sub:`9`
> +      - b\ :sub:`8`
> +      - b\ :sub:`7`
> +      - b\ :sub:`6`
> +      - b\ :sub:`5`
> +      - b\ :sub:`4`
> +      - b\ :sub:`3`
> +      - b\ :sub:`2`
> +      - b\ :sub:`1`
> +      - b\ :sub:`0`
> +
> +.. raw:: latex
> +
> +    \endgroup
> +
> +
> +The following table list existing packed 36bit wide RGB formats.

s/list/lists/

Same comment for the other tables. Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

-- 
Regards,

Laurent Pinchart
