Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:45977 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeH1Mra (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 08:47:30 -0400
Received: by mail-yb0-f194.google.com with SMTP id v13-v6so291092ybq.12
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 01:56:51 -0700 (PDT)
Received: from mail-yb0-f170.google.com (mail-yb0-f170.google.com. [209.85.213.170])
        by smtp.gmail.com with ESMTPSA id 84-v6sm190832ywo.15.2018.08.28.01.56.49
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Aug 2018 01:56:50 -0700 (PDT)
Received: by mail-yb0-f170.google.com with SMTP id z12-v6so295764ybg.9
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 01:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
 <1529033373-15724-3-git-send-email-yong.zhi@intel.com> <749a58a4-24f7-672f-70a9-cfd584af0171@xs4all.nl>
 <20180813174950.6fd3915f@coco.lan>
In-Reply-To: <20180813174950.6fd3915f@coco.lan>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 28 Aug 2018 17:56:37 +0900
Message-ID: <CAAFQd5BAqkusfzfX6s7OW0QyMs+55LX+4OTcD0aZDPaJ0RyfrQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>, chao.c.li@intel.com,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 14, 2018 at 5:50 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Mon, 13 Aug 2018 15:42:34 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
> > On 15/06/18 05:29, Yong Zhi wrote:
> > > These meta formats are used on Intel IPU3 ImgU video queues
> > > to carry 3A statistics and ISP pipeline parameters.
> > >
> > > V4L2_META_FMT_IPU3_3A
> > > V4L2_META_FMT_IPU3_PARAMS
> > >
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > Signed-off-by: Chao C Li <chao.c.li@intel.com>
> > > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > > ---
> > >  Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
> > >  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  174 ++
> > >  include/uapi/linux/intel-ipu3.h                    | 2816 ++++++++++++++++++++
> > >  3 files changed, 2991 insertions(+)
> > >  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > >  create mode 100644 include/uapi/linux/intel-ipu3.h
> > >
> > > diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
> > > index 0c4e1ec..b887fca 100644
> > > --- a/Documentation/media/uapi/v4l/meta-formats.rst
> > > +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> > > @@ -12,6 +12,7 @@ These formats are used for the :ref:`metadata` interface only.
> > >  .. toctree::
> > >      :maxdepth: 1
> > >
> > > +    pixfmt-meta-intel-ipu3
> > >      pixfmt-meta-uvc
> > >      pixfmt-meta-vsp1-hgo
> > >      pixfmt-meta-vsp1-hgt
> > > diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > > new file mode 100644
> > > index 0000000..5c050e6
> > > --- /dev/null
> > > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > > @@ -0,0 +1,174 @@
> > > +.. -*- coding: utf-8; mode: rst -*-
> > > +
> > > +.. _intel-ipu3:
> > > +
> > > +******************************************************************
> > > +V4L2_META_FMT_IPU3_PARAMS ('ip3p'), V4L2_META_FMT_IPU3_3A ('ip3s')
> > > +******************************************************************
> > > +
> > > +.. c:type:: ipu3_uapi_stats_3a
> > > +
> > > +3A statistics
> > > +=============
> > > +
> > > +For IPU3 ImgU, the 3A statistics accelerators collect different statistics over
> > > +an input bayer frame. Those statistics, defined in data struct
> > > +:c:type:`ipu3_uapi_stats_3a`, are meta output obtained from "ipu3-imgu 3a stat"
> > > +video node, which are then passed to user space for statistics analysis
> > > +using :c:type:`v4l2_meta_format` interface.
> > > +
> > > +The statistics collected are AWB (Auto-white balance) RGBS cells, AWB filter
>
> Just like you did with AWB, AF and AE, please place the full name in parenthesis
> for RGBS and AWB.
>
> > > +response, AF (Auto-focus) filter response, and AE (Auto-exposure) histogram.
> > > +
> > > +struct :c:type:`ipu3_uapi_4a_config` saves configurable parameters for all above.
> > > +
> > > +
> > > +.. code-block:: c
> > > +
> > > +
> > > +     struct ipu3_uapi_stats_3a {
> > > +   IPU3_ALIGN struct ipu3_uapi_awb_raw_buffer awb_raw_buffer;
> >
> > IPU3_ALIGN? What's that?
> >
> > OK, after reading the header I see what it does, but I think you should
> > drop it in the documentation since it doesn't help the reader.
>
> Yeah, that IPU3_ALIGN is confusing.
>
> Yet, instead of just dropping, I would replace it by a comment
> to explain that the struct is 32-bytes aligned.
>
> On a separate (but related) comment, you're declaring it as:
>
>         #define IPU3_ALIGN      __attribute__((aligned(IPU3_UAPI_ISP_WORD_BYTES)))
>
> This is a gcc-specific dialect. Better to use, instead, __aligned(x)
> which is defined as:
>
> #define __aligned(x)            __attribute__((aligned(x)))
>

Note that this is an uapi/ header. Is the __aligned() macro okay to
use in uapi headers? I couldn't find any header there using it and we
had problems with our user space compiling with it.

By the way, I wonder if this is the right approach for controlling the
layout of ABI structs. I don't see many headers using any alignment in
uapi/ in general. Perhaps explicit padding bytes would be more
appropriate? They are also less tricky when one structure needs to be
embedded inside two or more different structures with different
alignments, which can't be done easily if you specify __aligned() on
the child struct.

Best regards,
Tomasz
