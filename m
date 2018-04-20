Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:44902 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754537AbeDTJ7R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 05:59:17 -0400
Received: by mail-ua0-f195.google.com with SMTP id r10so265612uak.11
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 02:59:17 -0700 (PDT)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com. [209.85.213.47])
        by smtp.gmail.com with ESMTPSA id c187sm1734194vkf.46.2018.04.20.02.59.15
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Apr 2018 02:59:16 -0700 (PDT)
Received: by mail-vk0-f47.google.com with SMTP id 203so4902455vka.12
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 02:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com> <20180419154536.17846-1-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180419154536.17846-1-paul.kocialkowski@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 20 Apr 2018 09:51:49 +0000
Message-ID: <CAAFQd5Dq4OeshtFaoxFK2357+-_=hzh0C7W=zksTWtaDuDCiGg@mail.gmail.com>
Subject: Re: [PATCH v2 05/10] media: v4l: Add definitions for MPEG2 frame
 format and header metadata
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, wens@csie.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Fri, Apr 20, 2018 at 12:46 AM Paul Kocialkowski <
paul.kocialkowski@bootlin.com> wrote:
[snip]
> +struct v4l2_ctrl_mpeg2_frame_hdr {
> +       __u32 slice_len;
> +       __u32 slice_pos;
> +       enum { MPEG1, MPEG2 } type;

Is enum suitable for UAPI?

> +
> +       __u16 width;
> +       __u16 height;
> +
> +       enum { PCT_I = 1, PCT_P, PCT_B, PCT_D } picture_coding_type;

Ditto.

> +       __u8 f_code[2][2];
> +
> +       __u8 intra_dc_precision;
> +       __u8 picture_structure;
> +       __u8 top_field_first;
> +       __u8 frame_pred_frame_dct;
> +       __u8 concealment_motion_vectors;
> +       __u8 q_scale_type;
> +       __u8 intra_vlc_format;
> +       __u8 alternate_scan;
> +
> +       __u8 backward_ref_index;
> +       __u8 forward_ref_index;
> +};
> +
>   #endif
> diff --git a/include/uapi/linux/videodev2.h
b/include/uapi/linux/videodev2.h
> index 31b5728b56e9..4b8336f7bcf0 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -635,6 +635,7 @@ struct v4l2_pix_format {
>   #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /*
SMPTE 421M Annex L compliant stream */
>   #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
>   #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
> +#define V4L2_PIX_FMT_MPEG2_FRAME v4l2_fourcc('M', 'G', '2', 'F') /*
MPEG2 frame */

>   /*  Vendor-specific formats   */
>   #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1
YUV */
> @@ -1586,6 +1587,7 @@ struct v4l2_ext_control {
>                  __u8 __user *p_u8;
>                  __u16 __user *p_u16;
>                  __u32 __user *p_u32;
> +               struct v4l2_ctrl_mpeg2_frame_hdr __user
*p_mpeg2_frame_hdr;
>                  void __user *ptr;
>          };
>   } __attribute__ ((packed));
> @@ -1631,6 +1633,7 @@ enum v4l2_ctrl_type {
>          V4L2_CTRL_TYPE_U8            = 0x0100,
>          V4L2_CTRL_TYPE_U16           = 0x0101,
>          V4L2_CTRL_TYPE_U32           = 0x0102,
> +       V4L2_CTRL_TYPE_MPEG2_FRAME_HDR = 0x0109,

Why 0x0109?

Best regards,
Tomasz
