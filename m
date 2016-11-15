Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33666 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965919AbcKOFsK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 00:48:10 -0500
References: <87h97achun.fsf@edgarthier.net> <20161114141425.GT3217@valkosipuli.retiisi.org.uk>
From: Edgar Thier <info@edgarthier.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Add bayer 16-bit format patterns
In-reply-to: <20161114141425.GT3217@valkosipuli.retiisi.org.uk>
Date: Tue, 15 Nov 2016 06:48:08 +0100
Message-ID: <874m395m5j.fsf@edgarthier.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sakari,

Sorry for the waiting. I hope the patch I just submitted is alright.

I took the freedom and uploaded the lsusb -v output for 3 cameras with
bayer 16-bit patterns. You can find them here:

dfk23up1300_16bitbayer_RG.lsusb:  http://pastebin.com/PDdY7rs0
dfk23ux249_16bitbayer_GB.lsusb: http://pastebin.com/gtjF3Q2k
dfk33ux250_16bitbayer_GR.lsusb: http://pastebin.com/Errz5UMr

Cheers,

Edgar

> Hi Edgar,
>
> On Mon, Nov 14, 2016 at 02:26:56PM +0100, Edgar Thier wrote:
>> From aec97c931cb4b91f91dd0ed38f74d866d4f13347 Mon Sep 17 00:00:00 2001
>> From: Edgar Thier <info@edgarthier.net>
>> Date: Mon, 14 Nov 2016 14:17:57 +0100
>> Subject: [PATCH] uvcvideo: Add bayer 16-bit format patterns
>>
>> Add bayer 16-bit GUIDs to uvcvideo and associated them with the
>> corresponding V4L2 pixel formats.
>>
>> Signed-off-by: Edgar Thier <info@edgarthier.net>
>> ---
>
> ...
>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 4364ce6..6bdf592 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -605,6 +605,9 @@ struct v4l2_pix_format {
>> #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
>> #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
>> #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
>> +#define V4L2_PIX_FMT_SGBRG16 v4l2_fourcc('G', 'B', '1', '6') /* 16  GBGB.. RGRG.. */
>> +#define V4L2_PIX_FMT_SRGGB16 v4l2_fourcc('R', 'G', '1', '6') /* 16  RGRG.. GBGB.. */
>> +#define V4L2_PIX_FMT_SGRBG16 v4l2_fourcc('G', 'R', '1', '6') /* 16  GRGR.. BGBG.. */
>
> Thanks for the patch!
>
> Could you rebase your uvcvideo changes on this patch, dropping the framework
> changes from yours?
>
> Cc Laurent. Laurent, could you take both of the patches to your tree after
> the rebase?
>
> The patch is also available here:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=packed12-postponed2&id=c5b60538b33f993109248a642c8e9b74f7d1abd1>
>
>
> From c5b60538b33f993109248a642c8e9b74f7d1abd1 Mon Sep 17 00:00:00 2001
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> Date: Mon, 27 Jun 2016 16:46:16 +0300
> Subject: [PATCH 1/1] v4l: Add 16-bit raw bayer pixel formats
>
> The formats added by this patch are:
>
> 	V4L2_PIX_FMT_SBGGR16
> 	V4L2_PIX_FMT_SGBRG16
> 	V4L2_PIX_FMT_SGRBG16
>
> V4L2_PIX_FMT_SRGGB16 already existed before the patch. Rework the
> documentation to match that of the other sample depths.
>
> Also align the description of V4L2_PIX_FMT_SRGGB16 to match with other
> similar formats.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Documentation/media/uapi/v4l/pixfmt-rgb.rst     |  2 +-
>  Documentation/media/uapi/v4l/pixfmt-sbggr16.rst | 62 ----------------------
>  Documentation/media/uapi/v4l/pixfmt-srggb16.rst | 69 +++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c            |  5 +-
>  include/uapi/linux/videodev2.h                  |  3 ++
>  5 files changed, 77 insertions(+), 64 deletions(-)
>  delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb16.rst
>
> diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> index 9cc9808..b0f3513 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> @@ -12,9 +12,9 @@ RGB Formats
>
>      pixfmt-packed-rgb
>      pixfmt-srggb8
> -    pixfmt-sbggr16
>      pixfmt-srggb10
>      pixfmt-srggb10p
>      pixfmt-srggb10alaw8
>      pixfmt-srggb10dpcm8
>      pixfmt-srggb12
> +    pixfmt-srggb16
> diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
> deleted file mode 100644
> index 6f7f327..0000000
> --- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
> +++ /dev/null
> @@ -1,62 +0,0 @@
> -.. -*- coding: utf-8; mode: rst -*-
> -
> -.. _V4L2-PIX-FMT-SBGGR16:
> -
> -*****************************
> -V4L2_PIX_FMT_SBGGR16 ('BYR2')
> -*****************************
> -
> -Bayer RGB format
> -
> -
> -Description
> -===========
> -
> -This format is similar to
> -:ref:`V4L2_PIX_FMT_SBGGR8 <V4L2-PIX-FMT-SBGGR8>`, except each pixel
> -has a depth of 16 bits. The least significant byte is stored at lower
> -memory addresses (little-endian).
> -
> -**Byte Order.**
> -Each cell is one byte.
> -
> -.. flat-table::
> -    :header-rows:  0
> -    :stub-columns: 0
> -
> -    * - start + 0:
> -      - B\ :sub:`00low`
> -      - B\ :sub:`00high`
> -      - G\ :sub:`01low`
> -      - G\ :sub:`01high`
> -      - B\ :sub:`02low`
> -      - B\ :sub:`02high`
> -      - G\ :sub:`03low`
> -      - G\ :sub:`03high`
> -    * - start + 8:
> -      - G\ :sub:`10low`
> -      - G\ :sub:`10high`
> -      - R\ :sub:`11low`
> -      - R\ :sub:`11high`
> -      - G\ :sub:`12low`
> -      - G\ :sub:`12high`
> -      - R\ :sub:`13low`
> -      - R\ :sub:`13high`
> -    * - start + 16:
> -      - B\ :sub:`20low`
> -      - B\ :sub:`20high`
> -      - G\ :sub:`21low`
> -      - G\ :sub:`21high`
> -      - B\ :sub:`22low`
> -      - B\ :sub:`22high`
> -      - G\ :sub:`23low`
> -      - G\ :sub:`23high`
> -    * - start + 24:
> -      - G\ :sub:`30low`
> -      - G\ :sub:`30high`
> -      - R\ :sub:`31low`
> -      - R\ :sub:`31high`
> -      - G\ :sub:`32low`
> -      - G\ :sub:`32high`
> -      - R\ :sub:`33low`
> -      - R\ :sub:`33high`
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
> new file mode 100644
> index 0000000..06facc9
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
> @@ -0,0 +1,69 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _V4L2-PIX-FMT-SRGGB16:
> +.. _v4l2-pix-fmt-sbggr16:
> +.. _v4l2-pix-fmt-sgbrg16:
> +.. _v4l2-pix-fmt-sgrbg16:
> +
> +
> +***************************************************************************************************************************
> +V4L2_PIX_FMT_SRGGB16 ('RG16'), V4L2_PIX_FMT_SGRBG16 ('GR16'), V4L2_PIX_FMT_SGBRG16 ('GB16'), V4L2_PIX_FMT_SBGGR16 ('BYR2'),
> +***************************************************************************************************************************
> +
> +
> +16-bit Bayer formats
> +
> +
> +Description
> +===========
> +
> +These four pixel formats are raw sRGB / Bayer formats with 16 bits per
> +sample. Each sample is stored in a 16-bit word. Each n-pixel row contains
> +n/2 green samples and n/2 blue or red samples, with alternating red and blue
> +rows. Bytes are stored in memory in little endian order. They are
> +conventionally described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is
> +an example of one of these formats:
> +
> +**Byte Order.**
> +Each cell is one byte.
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - start + 0:
> +      - B\ :sub:`00low`
> +      - B\ :sub:`00high`
> +      - G\ :sub:`01low`
> +      - G\ :sub:`01high`
> +      - B\ :sub:`02low`
> +      - B\ :sub:`02high`
> +      - G\ :sub:`03low`
> +      - G\ :sub:`03high`
> +    * - start + 8:
> +      - G\ :sub:`10low`
> +      - G\ :sub:`10high`
> +      - R\ :sub:`11low`
> +      - R\ :sub:`11high`
> +      - G\ :sub:`12low`
> +      - G\ :sub:`12high`
> +      - R\ :sub:`13low`
> +      - R\ :sub:`13high`
> +    * - start + 16:
> +      - B\ :sub:`20low`
> +      - B\ :sub:`20high`
> +      - G\ :sub:`21low`
> +      - G\ :sub:`21high`
> +      - B\ :sub:`22low`
> +      - B\ :sub:`22high`
> +      - G\ :sub:`23low`
> +      - G\ :sub:`23high`
> +    * - start + 24:
> +      - G\ :sub:`30low`
> +      - G\ :sub:`30high`
> +      - R\ :sub:`31low`
> +      - R\ :sub:`31high`
> +      - G\ :sub:`32low`
> +      - G\ :sub:`32high`
> +      - R\ :sub:`33low`
> +      - R\ :sub:`33high`
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 181381d..61d2d65 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1191,7 +1191,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_PIX_FMT_SGBRG10DPCM8:	descr = "8-bit Bayer GBGB/RGRG (DPCM)"; break;
>  	case V4L2_PIX_FMT_SGRBG10DPCM8:	descr = "8-bit Bayer GRGR/BGBG (DPCM)"; break;
>  	case V4L2_PIX_FMT_SRGGB10DPCM8:	descr = "8-bit Bayer RGRG/GBGB (DPCM)"; break;
> -	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR (Exp.)"; break;
> +	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR"; break;
> +	case V4L2_PIX_FMT_SGBRG16:	descr = "16-bit Bayer GBGB/RGRG"; break;
> +	case V4L2_PIX_FMT_SGRBG16:	descr = "16-bit Bayer GRGR/BGBG"; break;
> +	case V4L2_PIX_FMT_SRGGB16:	descr = "16-bit Bayer RGRG/GBGB"; break;
>  	case V4L2_PIX_FMT_SN9C20X_I420:	descr = "GSPCA SN9C20X I420"; break;
>  	case V4L2_PIX_FMT_SPCA501:	descr = "GSPCA SPCA501"; break;
>  	case V4L2_PIX_FMT_SPCA505:	descr = "GSPCA SPCA505"; break;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 4364ce6..ba352b6 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -605,6 +605,9 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
>  #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
>  #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
> +#define V4L2_PIX_FMT_SGBRG16 v4l2_fourcc('G', 'B', '1', '6') /* 16  GBGB.. RGRG.. */
> +#define V4L2_PIX_FMT_SGRBG16 v4l2_fourcc('G', 'R', '1', '6') /* 16  GRGR.. BGBG.. */
> +#define V4L2_PIX_FMT_SRGGB16 v4l2_fourcc('R', 'G', '1', '6') /* 16  RGRG.. GBGB.. */
>
>  /* HSV formats */
>  #define V4L2_PIX_FMT_HSV24 v4l2_fourcc('H', 'S', 'V', '3')
> --
> 2.1.4
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
