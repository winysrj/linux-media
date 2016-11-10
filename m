Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51673 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbcKJISZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 03:18:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/5] doc_rst: media: New SDR formats SC16, SC18 & SC20
Date: Thu, 10 Nov 2016 10:18:25 +0200
Message-ID: <1862421.axMZCvXYDN@avalon>
In-Reply-To: <1478706284-59134-5-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1478706284-59134-5-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

Thank you for the patch.

On Wednesday 09 Nov 2016 15:44:43 Ramesh Shanmugasundaram wrote:
> This patch adds documentation for the three new SDR formats
> 
> V4L2_SDR_FMT_SCU16BE
> V4L2_SDR_FMT_SCU18BE
> V4L2_SDR_FMT_SCU20BE
> 
> Signed-off-by: Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com>
> ---
>  .../media/uapi/v4l/pixfmt-sdr-scu16be.rst          | 80 ++++++++++++++++++
>  .../media/uapi/v4l/pixfmt-sdr-scu18be.rst          | 80 ++++++++++++++++++
>  .../media/uapi/v4l/pixfmt-sdr-scu20be.rst          | 80 ++++++++++++++++++
>  Documentation/media/uapi/v4l/sdr-formats.rst       |  3 +
>  4 files changed, 243 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu20be.rst
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
> b/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst new file mode 100644
> index 0000000..7525378
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
> @@ -0,0 +1,80 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _V4L2-SDR-FMT-SCU16BE:
> +
> +******************************
> +V4L2_SDR_FMT_SCU16BE ('SC16')
> +******************************
> +
> +Sliced complex unsigned 16-bit big endian IQ sample
> +
> +Description
> +===========
> +
> +This format contains a sequence of complex number samples. Each complex
> +number consist of two parts called In-phase and Quadrature (IQ). Both I
> +and Q are represented as a 16 bit unsigned big endian number stored in
> +32 bit space. The remaining unused bits within the 32 bit space will be
> +padded with 0. I value starts first and Q value starts at an offset
> +equalling half of the buffer size (i.e.) offset = buffersize/2. Out of
> +the 16 bits, bit 15:2 (14 bit) is data and bit 1:0 (2 bit) can be any
> +value.

I've pinged Antti and Hans regarding single buffer vs. multiplanar, let's try 
to reach an agreement there.

> +
> +**Byte Order.**
> +Each cell is one byte.
> +
> +.. flat-table::
> +    :header-rows:  1
> +    :stub-columns: 0
> +
> +    * -  Offset:
> +

In the meantime, you can remove all the blank lines between table rows :-)

> +      -  Byte B0
> +
> +      -  Byte B1
> +
> +      -  Byte B2
> +
> +      -  Byte B3

[snip]

-- 
Regards,

Laurent Pinchart

