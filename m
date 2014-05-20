Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17341 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbaETKDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 06:03:06 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5V003BLAL4KF80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 May 2014 11:03:04 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Pawel Osciak' <posciak@chromium.org>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Arun Kumar' <arun.kk@samsung.com>
References: <1400241824-18260-1-git-send-email-k.debski@samsung.com>
 <1400241824-18260-2-git-send-email-k.debski@samsung.com>
 <CACHYQ-qQ5AGFvoLbL992GF-C6vUmRToTKm2wut09tskEBEAPCQ@mail.gmail.com>
In-reply-to: <CACHYQ-qQ5AGFvoLbL992GF-C6vUmRToTKm2wut09tskEBEAPCQ@mail.gmail.com>
Subject: RE: [PATCH 2/2] v4l: s5p-mfc: Limit enum_fmt to output formats of
 current version
Date: Tue, 20 May 2014 12:03:03 +0200
Message-id: <060b01cf7412$b0e98100$12bc8300$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

> From: Pawel Osciak [mailto:posciak@chromium.org]
> Sent: Tuesday, May 20, 2014 3:47 AM
> 
> Hi Kamil,
> I like the solution as well. Two suggestions to consider below.
> 
> On Fri, May 16, 2014 at 9:03 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
> > MFC versions support a different set of formats, this specially
> > applies to the raw YUV formats. This patch changes enum_fmt, so that
> > it only reports formats that are supported by the used MFC version.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> 
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > index 9370c34..d5efb10 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > @@ -223,6 +223,7 @@ struct s5p_mfc_buf_align {  struct
> s5p_mfc_variant
> > {
> >         unsigned int version;
> >         unsigned int port_num;
> > +       u32 version_bit;
> >         struct s5p_mfc_buf_size *buf_size;
> >         struct s5p_mfc_buf_align *buf_align;
> >         char    *fw_name;
> > @@ -666,6 +667,7 @@ struct s5p_mfc_fmt {
> >         u32 codec_mode;
> >         enum s5p_mfc_fmt_type type;
> >         u32 num_planes;
> > +       u32 versions;
> >  };
> >
> >  /**
> > @@ -705,4 +707,9 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx
> *ctx);
> >  #define IS_MFCV6_PLUS(dev)     (dev->variant->version >= 0x60 ? 1 :
> 0)
> >  #define IS_MFCV7_PLUS(dev)     (dev->variant->version >= 0x70 ? 1 :
> 0)
> >
> > +#define MFC_V5 BIT(0)
> > +#define MFC_V6 BIT(1)
> > +#define MFC_V7 BIT(2)
> 
> These may be confusing. I'd suggest at least suffixing those macros
> with _BIT.
> Or better yet, please make this into an enum and also make
> variant->versions of size BITS_TO_LONGS() with max enum value.

I think I'll stick with adding the _BIT suffix. 
 
> >  /* Get format */
> > @@ -384,11 +402,9 @@ static int vidioc_try_fmt(struct file *file,
> void *priv, struct v4l2_format *f)
> >                         mfc_err("Unknown codec\n");
> >                         return -EINVAL;
> >                 }
> > -               if (!IS_MFCV6_PLUS(dev)) {
> > -                       if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
> > -                               mfc_err("Not supported format.\n");
> > -                               return -EINVAL;
> > -                       }
> > +               if ((dev->variant->version_bit & fmt->versions) == 0)
> {
> > +                       mfc_err("Unsupported format by this MFC
> version.\n");
> > +                       return -EINVAL;
> 
> What do you think of moving this check to find_format()? You wouldn't
> have to duplicate it across enum_fmt and try_fmt then...

Find_format is used as a helper for try_fmt and is not used by enum_fmt.
Enum_fmt does also some other checks and operates iterates the formats
array directly, so I think the change included in this patch is ok.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

