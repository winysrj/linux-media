Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44212 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753984AbdCTOgE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:36:04 -0400
Subject: Re: [PATCH v3 3/6] documentation: media: Add documentation for new
 RGB and YUV bus formats
To: Neil Armstrong <narmstrong@baylibre.com>,
        dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
 <1488904944-14285-4-git-send-email-narmstrong@baylibre.com>
Cc: Jose.Abreu@synopsys.com, kieran.bingham@ideasonboard.com,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5b40bc25-da65-108f-9a7b-0a856cb89330@xs4all.nl>
Date: Mon, 20 Mar 2017 15:33:11 +0100
MIME-Version: 1.0
In-Reply-To: <1488904944-14285-4-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2017 05:42 PM, Neil Armstrong wrote:
> Add documentation for added Bus Formats to describe RGB and YUS formats used
> as input to the Synopsys DesignWare HDMI TX Controller.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/media/uapi/v4l/subdev-formats.rst | 4992 ++++++++++++++++++-----
>  1 file changed, 3963 insertions(+), 1029 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
> index d6152c9..feb55b5 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -114,7 +114,7 @@ The following tables list existing packed RGB formats.
>  .. it switches to long table, and there's no way to override it.
>  
>  
> -.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
> +.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
>  
>  .. _v4l2-mbus-pixelcode-rgb:
>  

<snip>

> +    * .. _MEDIA-BUS-FMT-RGB161616-1X48:
> +
> +      - MEDIA_BUS_FMT_RGB161616_1X48
> +      - 0x10

0x10 -> 0x101a

> +      -
> +      - r\ :sub:`15`

<snip>

> +    * .. _MEDIA-BUS-FMT-YUV16-1X48:
> +
> +      - MEDIA_BUS_FMT_YUV16_1X48
> +      - 0x202a

Needs an extra line:

         -

The first cell is the 'Bit' column, which should be an empty cell.

If you look at the output, then you'll see that without this the bit 0 cell is empty.

Same for the other three 48 bit YUV formats.

> +      - y\ :sub:`15`
> +      - y\ :sub:`14`
> +      - y\ :sub:`13`
> +      - y\ :sub:`12`
>        - y\ :sub:`11`
>        - y\ :sub:`10`
> -      - y\ :sub:`9`
> +      - y\ :sub:`8`

Typo: should remain 9.

>        - y\ :sub:`8`
>        - y\ :sub:`7`
>        - y\ :sub:`6`
> @@ -6203,6 +9124,26 @@ the following codes.
>        - y\ :sub:`2`
>        - y\ :sub:`1`
>        - y\ :sub:`0`
> +      - u\ :sub:`15`
> +      - u\ :sub:`14`
> +      - u\ :sub:`13`
> +      - u\ :sub:`12`
> +      - u\ :sub:`11`
> +      - u\ :sub:`10`
> +      - u\ :sub:`9`
> +      - u\ :sub:`8`
> +      - u\ :sub:`7`
> +      - u\ :sub:`6`
> +      - u\ :sub:`5`
> +      - u\ :sub:`4`
> +      - u\ :sub:`3`
> +      - u\ :sub:`2`
> +      - u\ :sub:`1`
> +      - u\ :sub:`0`
> +      - v\ :sub:`15`
> +      - v\ :sub:`14`
> +      - v\ :sub:`13`
> +      - v\ :sub:`12`
>        - v\ :sub:`11`
>        - v\ :sub:`10`
>        - v\ :sub:`9`
> @@ -6215,29 +9156,14 @@ the following codes.
>        - v\ :sub:`2`
>        - v\ :sub:`1`
>        - v\ :sub:`0`
> -    * -
> -      -
> -      -
> -      -
> -      -
> -      -
> -      -
> -      -
> -      -
> -      -
> -      -
> -      - y\ :sub:`11`
> -      - y\ :sub:`10`
> -      - y\ :sub:`9`
> -      - y\ :sub:`8`
> -      - y\ :sub:`7`
> -      - y\ :sub:`6`
> -      - y\ :sub:`5`
> -      - y\ :sub:`4`
> -      - y\ :sub:`3`
> -      - y\ :sub:`2`
> -      - y\ :sub:`1`
> -      - y\ :sub:`0`
> +    * .. _MEDIA-BUS-FMT-UYVY16-1-1X48:
> +
> +      - MEDIA_BUS_FMT_UYVY16_1_1X48
> +      - 0x202b
> +      - u\ :sub:`15`
> +      - u\ :sub:`14`
> +      - u\ :sub:`13`
> +      - u\ :sub:`12`
>        - u\ :sub:`11`
>        - u\ :sub:`10`
>        - u\ :sub:`9`
> @@ -6250,13 +9176,12 @@ the following codes.
>        - u\ :sub:`2`
>        - u\ :sub:`1`
>        - u\ :sub:`0`
> -    * .. _MEDIA-BUS-FMT-YUV10-1X30:
> -
> -      - MEDIA_BUS_FMT_YUV10_1X30
> -      - 0x2016
> -      -
> -      -
> -      -
> +      - y\ :sub:`15`
> +      - y\ :sub:`14`
> +      - y\ :sub:`13`
> +      - y\ :sub:`12`
> +      - y\ :sub:`11`
> +      - y\ :sub:`10`
>        - y\ :sub:`9`
>        - y\ :sub:`8`
>        - y\ :sub:`7`
> @@ -6267,16 +9192,30 @@ the following codes.
>        - y\ :sub:`2`
>        - y\ :sub:`1`
>        - y\ :sub:`0`
> -      - u\ :sub:`9`
> -      - u\ :sub:`8`
> -      - u\ :sub:`7`
> -      - u\ :sub:`6`
> -      - u\ :sub:`5`
> -      - u\ :sub:`4`
> -      - u\ :sub:`3`
> -      - u\ :sub:`2`
> -      - u\ :sub:`1`
> -      - u\ :sub:`0`
> +      - y\ :sub:`15`
> +      - y\ :sub:`14`
> +      - y\ :sub:`13`
> +      - y\ :sub:`12`
> +      - y\ :sub:`11`
> +      - y\ :sub:`10`
> +      - y\ :sub:`8`

8 -> 9

> +      - y\ :sub:`8`
> +      - y\ :sub:`7`
> +      - y\ :sub:`6`
> +      - y\ :sub:`5`
> +      - y\ :sub:`4`
> +      - y\ :sub:`3`
> +      - y\ :sub:`2`
> +      - y\ :sub:`1`
> +      - y\ :sub:`0`
> +    * -
> +      -
> +      - v\ :sub:`15`
> +      - v\ :sub:`14`
> +      - v\ :sub:`13`
> +      - v\ :sub:`12`
> +      - v\ :sub:`11`
> +      - v\ :sub:`10`
>        - v\ :sub:`9`
>        - v\ :sub:`8`
>        - v\ :sub:`7`
> @@ -6287,19 +9226,30 @@ the following codes.
>        - v\ :sub:`2`
>        - v\ :sub:`1`
>        - v\ :sub:`0`
> -    * .. _MEDIA-BUS-FMT-AYUV8-1X32:
> -
> -      - MEDIA_BUS_FMT_AYUV8_1X32
> -      - 0x2017
> -      -
> -      - a\ :sub:`7`
> -      - a\ :sub:`6`
> -      - a\ :sub:`5`
> -      - a\ :sub:`4`
> -      - a\ :sub:`3`
> -      - a\ :sub:`2`
> -      - a\ :sub:`1`
> -      - a\ :sub:`0`
> +      - y\ :sub:`15`
> +      - y\ :sub:`14`
> +      - y\ :sub:`13`
> +      - y\ :sub:`12`
> +      - y\ :sub:`11`
> +      - y\ :sub:`10`
> +      - y\ :sub:`9`
> +      - y\ :sub:`8`
> +      - y\ :sub:`7`
> +      - y\ :sub:`6`
> +      - y\ :sub:`5`
> +      - y\ :sub:`4`
> +      - y\ :sub:`3`
> +      - y\ :sub:`2`
> +      - y\ :sub:`1`
> +      - y\ :sub:`0`
> +      - y\ :sub:`15`
> +      - y\ :sub:`14`
> +      - y\ :sub:`13`
> +      - y\ :sub:`12`
> +      - y\ :sub:`11`
> +      - y\ :sub:`10`
> +      - y\ :sub:`8`

8 -> 9

> +      - y\ :sub:`8`
>        - y\ :sub:`7`
>        - y\ :sub:`6`
>        - y\ :sub:`5`
> @@ -6308,22 +9258,6 @@ the following codes.
>        - y\ :sub:`2`
>        - y\ :sub:`1`
>        - y\ :sub:`0`
> -      - u\ :sub:`7`
> -      - u\ :sub:`6`
> -      - u\ :sub:`5`
> -      - u\ :sub:`4`
> -      - u\ :sub:`3`
> -      - u\ :sub:`2`
> -      - u\ :sub:`1`
> -      - u\ :sub:`0`
> -      - v\ :sub:`7`
> -      - v\ :sub:`6`
> -      - v\ :sub:`5`
> -      - v\ :sub:`4`
> -      - v\ :sub:`3`
> -      - v\ :sub:`2`
> -      - v\ :sub:`1`
> -      - v\ :sub:`0`
>  
>  
>  .. raw:: latex
> 

Regards,

	Hans
