Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7289EC07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 23:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058622081C
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 23:31:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 058622081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbeLIXbH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 18:31:07 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50420 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726319AbeLIXbH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Dec 2018 18:31:07 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 51637634C7F;
        Mon, 10 Dec 2018 01:31:04 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gW8XQ-0000Ew-41; Mon, 10 Dec 2018 01:31:04 +0200
Date:   Mon, 10 Dec 2018 01:31:04 +0200
From:   sakari.ailus@iki.fi
To:     Edgar Thier <info@edgarthier.net>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] v4l: Add simple packed Bayer raw12 pixel formats
Message-ID: <20181209233103.eu377vpxvk5ks3ch@valkosipuli.retiisi.org.uk>
References: <8632f42f-f274-b271-be1a-08d940c78487@edgarthier.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8632f42f-f274-b271-be1a-08d940c78487@edgarthier.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Edgar,

Apologies for the late reply. I was going through the pending patches in
Patchwork, and noticed this one.

On Thu, Aug 23, 2018 at 08:56:50AM +0200, Edgar Thier wrote:
> 
> These formats are compressed 12-bit raw bayer formats with four different
> pixel orders. They are similar to 10-bit bayer formats 'IPU3'.
> The formats added by this patch are
> 
> V4L2_PIX_FMT_SBGGR12SP
> V4L2_PIX_FMT_SGBRG12SP
> V4L2_PIX_FMT_SGRBG12SP
> V4L2_PIX_FMT_SRGGB12SP
> 
> Signed-off-by: Edgar Thier <info@edgarthier.net>
> ---
> Documentation/media/uapi/v4l/pixfmt-rgb.rst   |   1 +
> .../media/uapi/v4l/pixfmt-srggb12sp.rst       | 123 ++++++++++++++++++
> drivers/media/usb/uvc/uvc_driver.c            |  20 +++
> drivers/media/usb/uvc/uvcvideo.h              |  14 +-
> include/uapi/linux/videodev2.h                |   7 +
> 5 files changed, 164 insertions(+), 1 deletion(-)
> create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> index 1f9a7e3a07c9..5da00bd085f1 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> @@ -19,5 +19,6 @@ RGB Formats
> pixfmt-srggb10-ipu3
> pixfmt-srggb12
> pixfmt-srggb12p
> +    pixfmt-srggb12sp

Extra spaces.

> pixfmt-srggb14p
> pixfmt-srggb16
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
> b/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
> new file mode 100644
> index 000000000000..e99359709c90
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
> @@ -0,0 +1,123 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _v4l2-pix-fmt-sbggr12sp:
> +.. _v4l2-pix-fmt-sgbrg12sp:
> +.. _v4l2-pix-fmt-sgrbg12sp:
> +.. _v4l2-pix-fmt-srggb12sp:
> +
> +******************************************************************************************************************************************************
> +V4L2_PIX_FMT_SBGGR12SP ('SRGGB12SP'), V4L2_PIX_FMT_SGBRG12SP ('SGBRG12SP'), V4L2_PIX_FMT_SGRBG12SP
> ('SGRBG12SP'), V4L2_PIX_FMT_SRGGB12SP ('SRGGB12SP')
> +******************************************************************************************************************************************************
> +
> +12-bit Bayer formats
> +
> +Description
> +===========
> +
> +These four pixel formats are used by Intel IPU3 driver, they are raw

I think this comes from the IPU3 packed raw Bayer documentation, and does
not hold for these formats. Which devices did support it again? I have a
vague recollection this was a somewhat device specific format, not adhering
to a standard.

> +sRGB / Bayer formats with 12 bits per sample with every 8 pixels packed
> +to 24 bytes.
> +The format is little endian.
> +
> +In other respects this format is similar to :ref:`V4L2-PIX-FMT-SRGGB10-IPU3`.
> +Below is an example of a small image in V4L2_PIX_FMT_SBGGR12SP format.
> +
> +**Byte Order.**
> +Each cell is one byte.
> +
> +.. tabularcolumns:: |p{0.8cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|
> +
> +.. flat-table::
> +
> +    * - start + 0:
> +      - B\ :sub:`0000low`
> +      - G\ :sub:`0001low`\ (bits 7--4)
> +
> +        B\ :sub:`0000high`\ (bits 0--3)
> +
> +      - G\ :sub:`0001high`\
> +      - B\ :sub:`0002low`
> +
> +    * - start + 4:
> +      - G\ :sub:`0003low`\ (bits 7--4)
> +
> +        B\ :sub:`0002high`\ (bits 0--3)
> +      - G\ :sub:`0003high`
> +      - B\ :sub:`0004low`
> +      - G\ :sub:`0005low`\ (bits 7--2)
> +
> +        B\ :sub:`0004high`\ (bits 1--0)
> +
> +    * - start + 8:
> +      - G\ :sub:`0005high`
> +      - B\ :sub:`0006low`
> +      - G\ :sub:`0007low`\ (bits 7--4)
> +        B\ :sub:`0006high`\ (bits 3--0)
> +      - G\ :sub:`0007high`
> +
> +    * - start + 12:
> +      - G\ :sub:`0008low`
> +      - R\ :sub:`0009low`\ (bits 7--4)
> +
> +        G\ :sub:`0008high`\ (bits 3--0)
> +      - R\ :sub:`0009high`
> +      - G\ :sub:`0010low`
> +
> +    * - start + 16:
> +      - R\ :sub:`0011low`\ (bits 7--4)
> +        G\ :sub:`00010high`\ (bits 3--0)
> +      - R\ :sub:`0011high`
> +      - G\ :sub:`0012low`
> +      - R\ :sub:`0013low`\ (bits 7--4)
> +        G\ :sub:`0012high`\ (bits 3--0)
> +
> +    * - start + 20
> +      - R\ :sub:`0013high`
> +      - G\ :sub:`0014low`
> +      - R\ :sub:`0015low`\ (bits 7--4)
> +        G\ :sub:`0014high`\ (bits 3--0)
> +      - R\ :sub:`0015high`
> +
> +    * - start + 24:
> +      - B\ :sub:`0016low`
> +      - G\ :sub:`0017low`\ (bits 7--4)
> +        B\ :sub:`0016high`\ (bits 0--3)
> +      - G\ :sub:`0017high`\
> +      - B\ :sub:`0018low`
> +
> +    * - start + 28:
> +      - G\ :sub:`0019low`\ (bits 7--4)
> +        B\ :sub:`00018high`\ (bits 0--3)
> +      - G\ :sub:`0019high`
> +      - B\ :sub:`0020low`
> +      - G\ :sub:`0021low`\ (bits 7--2)
> +        B\ :sub:`0020high`\ (bits 1--0)
> +
> +    * - start + 32:
> +      - G\ :sub:`0021high`
> +      - B\ :sub:`0022low`
> +      - G\ :sub:`0023low`\ (bits 7--4)
> +        B\ :sub:`0022high`\ (bits 3--0)
> +      - G\ :sub:`0024high`
> +
> +    * - start + 36:
> +      - G\ :sub:`0025low`
> +      - R\ :sub:`0026low`\ (bits 7--4)
> +        G\ :sub:`0025high`\ (bits 3--0)
> +      - R\ :sub:`0026high`
> +      - G\ :sub:`0027low`
> +
> +    * - start + 40:
> +      - R\ :sub:`0028low`\ (bits 7--4)
> +        G\ :sub:`00027high`\ (bits 3--0)
> +      - R\ :sub:`0028high`
> +      - G\ :sub:`0029low`
> +      - R\ :sub:`0030low`\ (bits 7--4)
> +        G\ :sub:`0029high`\ (bits 3--0)
> +
> +    * - start + 44:
> +      - R\ :sub:`0030high`
> +      - G\ :sub:`0031low`
> +      - R\ :sub:`0033low`\ (bits 7--4)
> +        G\ :sub:`0032high`\ (bits 3--0)
> +      - R\ :sub:`0033high`
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index d46dc432456c..9c9703bab717 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -179,6 +179,26 @@ static struct uvc_format_desc uvc_fmts[] = {
> .guid		= UVC_GUID_FORMAT_RW10,
> .fcc		= V4L2_PIX_FMT_SRGGB10P,
> },
> +	{

Could you align the alignment with what's already there?

I guess it could be changed, but for now I wouldn't change an established
practice.

Cc Laurent as well.

> +		.name		= "Bayer 12-bit simple packed (SBGGR12SP)",
> +		.guid		= UVC_GUID_FORMAT_BG12SP,
> +		.fcc		= V4L2_PIX_FMT_SBGGR12SP,
> +	},
> +	{
> +		.name		= "Bayer 12-bit simple packed (SGBRG12SP)",
> +		.guid		= UVC_GUID_FORMAT_GB12SP,
> +		.fcc		= V4L2_PIX_FMT_SGBRG12SP,
> +	},
> +	{
> +		.name		= "Bayer 12-bit simple packed (SRGGB12P)",
> +		.guid		= UVC_GUID_FORMAT_RG12SP,
> +		.fcc		= V4L2_PIX_FMT_SRGGB12SP,
> +	},
> +	{
> +		.name		= "Bayer 12-bit simple packed (SGRBG12P_ME)",
> +		.guid		= UVC_GUID_FORMAT_GR12SP,
> +		.fcc		= V4L2_PIX_FMT_SGRBG12SP,
> +	},
> {
> .name		= "Bayer 16-bit (SBGGR16)",
> .guid		= UVC_GUID_FORMAT_BG16,
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index e5f5d84f1d1d..3cf4a6d17dc1 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -108,7 +108,19 @@
> #define UVC_GUID_FORMAT_RGGB \
> { 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
> 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> -#define UVC_GUID_FORMAT_BG16 \
> +#define UVC_GUID_FORMAT_BG12SP \
> +	{ 'B',  'G',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_GB12SP \
> +	{ 'G',  'B',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_RG12SP \
> +	{ 'R',  'G',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_GR12SP \
> +	{ 'G',  'R',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_BG16                         \
> { 'B',  'G',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
> 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> #define UVC_GUID_FORMAT_GB16 \
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 5d1a3685bea9..56807acf8c6d 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -610,6 +610,13 @@ struct v4l2_pix_format {
> #define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
> #define V4L2_PIX_FMT_SGRBG12P v4l2_fourcc('p', 'g', 'C', 'C')
> #define V4L2_PIX_FMT_SRGGB12P v4l2_fourcc('p', 'R', 'C', 'C')
> +
> +	/* 12bit raw bayer simple packed, 6 bytes for every 4 pixels */

Begin the comment at the start of the line, please.

> +#define V4L2_PIX_FMT_SBGGR12SP v4l2_fourcc('B', 'G', 'C', 'p')
> +#define V4L2_PIX_FMT_SGBRG12SP v4l2_fourcc('G', 'B', 'C', 'p')
> +#define V4L2_PIX_FMT_SGRBG12SP v4l2_fourcc('G', 'R', 'C', 'p')
> +#define V4L2_PIX_FMT_SRGGB12SP v4l2_fourcc('R', 'G', 'C', 'p')
> +
> /* 14bit raw bayer packed, 7 bytes for every 4 pixels */
> #define V4L2_PIX_FMT_SBGGR14P v4l2_fourcc('p', 'B', 'E', 'E')
> #define V4L2_PIX_FMT_SGBRG14P v4l2_fourcc('p', 'G', 'E', 'E')

-- 
Kind regards,

Sakari Ailus
