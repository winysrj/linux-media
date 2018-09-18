Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26993 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbeISFPP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 01:15:15 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: RE: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
Date: Tue, 18 Sep 2018 23:38:33 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5981505CA3@fmsmsx122.amr.corp.intel.com>
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
 <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
 <749a58a4-24f7-672f-70a9-cfd584af0171@xs4all.nl>
 <20180813174950.6fd3915f@coco.lan>
 <CAAFQd5BAqkusfzfX6s7OW0QyMs+55LX+4OTcD0aZDPaJ0RyfrQ@mail.gmail.com>
 <20180828091559.2scsfpfbhy5w3ywm@kekkonen.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A5981502659@fmsmsx122.amr.corp.intel.com>
 <20180913073713.lf44qaxfxper6mka@paasikivi.fi.intel.com>
In-Reply-To: <20180913073713.lf44qaxfxper6mka@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Thursday, September 13, 2018 12:37 AM
> To: Mani, Rajmohan <rajmohan.mani@intel.com>
> Cc: Tomasz Figa <tfiga@chromium.org>; Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org>; Hans Verkuil <hverkuil@xs4all.nl>; Zhi,
> Yong <yong.zhi@intel.com>; Linux Media Mailing List <linux-
> media@vger.kernel.org>; Mauro Carvalho Chehab <mchehab@kernel.org>;
> Hans Verkuil <hans.verkuil@cisco.com>; Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>; Zheng, Jian Xu
> <jian.xu.zheng@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Li, Chao C
> <chao.c.li@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>
> Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
> 
> Hi Raj, Mauro,
> 
> On Fri, Aug 31, 2018 at 10:40:22PM +0000, Mani, Rajmohan wrote:
> > Hi Sakari, Mauro,
> >
> > > -----Original Message-----
> > > From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> > > Sent: Tuesday, August 28, 2018 2:16 AM
> > > To: Tomasz Figa <tfiga@chromium.org>
> > > Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>; Hans
> Verkuil
> > > <hverkuil@xs4all.nl>; Mani, Rajmohan <rajmohan.mani@intel.com>; Zhi,
> > > Yong <yong.zhi@intel.com>; Linux Media Mailing List <linux-
> > > media@vger.kernel.org>; Mauro Carvalho Chehab
> <mchehab@kernel.org>;
> > > Hans Verkuil <hans.verkuil@cisco.com>; Laurent Pinchart
> > > <laurent.pinchart@ideasonboard.com>; Zheng, Jian Xu
> > > <jian.xu.zheng@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Li,
> > > Chao C <chao.c.li@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>
> > > Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
> > >
> > > Hi Tomasz,
> > >
> > > On Tue, Aug 28, 2018 at 05:56:37PM +0900, Tomasz Figa wrote:
> > > > On Tue, Aug 14, 2018 at 5:50 AM Mauro Carvalho Chehab
> > > > <mchehab+samsung@kernel.org> wrote:
> > > > >
> > > > > Em Mon, 13 Aug 2018 15:42:34 +0200 Hans Verkuil
> > > > > <hverkuil@xs4all.nl> escreveu:
> > > > >
> > > > > > On 15/06/18 05:29, Yong Zhi wrote:
> > > > > > > These meta formats are used on Intel IPU3 ImgU video queues
> > > > > > > to carry 3A statistics and ISP pipeline parameters.
> > > > > > >
> > > > > > > V4L2_META_FMT_IPU3_3A
> > > > > > > V4L2_META_FMT_IPU3_PARAMS
> > > > > > >
> > > > > > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > > > > > Signed-off-by: Chao C Li <chao.c.li@intel.com>
> > > > > > > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > > > > > > ---
> > > > > > >  Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
> > > > > > >  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  174 ++
> > > > > > >  include/uapi/linux/intel-ipu3.h                    | 2816
> > > ++++++++++++++++++++
> > > > > > >  3 files changed, 2991 insertions(+)  create mode 100644
> > > > > > > Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > > > > > >  create mode 100644 include/uapi/linux/intel-ipu3.h
> > > > > > >
> > > > > > > diff --git a/Documentation/media/uapi/v4l/meta-formats.rst
> > > > > > > b/Documentation/media/uapi/v4l/meta-formats.rst
> > > > > > > index 0c4e1ec..b887fca 100644
> > > > > > > --- a/Documentation/media/uapi/v4l/meta-formats.rst
> > > > > > > +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> > > > > > > @@ -12,6 +12,7 @@ These formats are used for the
> > > > > > > :ref:`metadata`
> > > interface only.
> > > > > > >  .. toctree::
> > > > > > >      :maxdepth: 1
> > > > > > >
> > > > > > > +    pixfmt-meta-intel-ipu3
> > > > > > >      pixfmt-meta-uvc
> > > > > > >      pixfmt-meta-vsp1-hgo
> > > > > > >      pixfmt-meta-vsp1-hgt
> > > > > > > diff --git
> > > > > > > a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > > > > > > b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > > > > > > new file mode 100644
> > > > > > > index 0000000..5c050e6
> > > > > > > --- /dev/null
> > > > > > > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rs
> > > > > > > +++ t
> > > > > > > @@ -0,0 +1,174 @@
> > > > > > > +.. -*- coding: utf-8; mode: rst -*-
> > > > > > > +
> > > > > > > +.. _intel-ipu3:
> > > > > > > +
> > > > > > >
> > >
> +***************************************************************
> > > > > > > +*** V4L2_META_FMT_IPU3_PARAMS ('ip3p'),
> > > V4L2_META_FMT_IPU3_3A
> > > > > > > +('ip3s')
> > > > > > >
> > >
> +***************************************************************
> > > > > > > +***
> > > > > > > +
> > > > > > > +.. c:type:: ipu3_uapi_stats_3a
> > > > > > > +
> > > > > > > +3A statistics
> > > > > > > +=============
> > > > > > > +
> > > > > > > +For IPU3 ImgU, the 3A statistics accelerators collect
> > > > > > > +different statistics over an input bayer frame. Those
> > > > > > > +statistics, defined in data struct
> > > > > > > +:c:type:`ipu3_uapi_stats_3a`, are meta output obtained
> > > from "ipu3-imgu 3a stat"
> > > > > > > +video node, which are then passed to user space for
> > > > > > > +statistics analysis using :c:type:`v4l2_meta_format` interface.
> > > > > > > +
> > > > > > > +The statistics collected are AWB (Auto-white balance) RGBS
> > > > > > > +cells, AWB filter
> > > > >
> > > > > Just like you did with AWB, AF and AE, please place the full
> > > > > name in parenthesis for RGBS and AWB.
> > > > >
> > > > > > > +response, AF (Auto-focus) filter response, and AE
> > > > > > > +(Auto-exposure)
> > > histogram.
> > > > > > > +
> > > > > > > +struct :c:type:`ipu3_uapi_4a_config` saves configurable
> > > > > > > +parameters for
> > > all above.
> > > > > > > +
> > > > > > > +
> > > > > > > +.. code-block:: c
> > > > > > > +
> > > > > > > +
> > > > > > > +     struct ipu3_uapi_stats_3a {
> > > > > > > +   IPU3_ALIGN struct ipu3_uapi_awb_raw_buffer
> > > > > > > + awb_raw_buffer;
> > > > > >
> > > > > > IPU3_ALIGN? What's that?
> > > > > >
> > > > > > OK, after reading the header I see what it does, but I think
> > > > > > you should drop it in the documentation since it doesn't help the
> reader.
> > > > >
> > > > > Yeah, that IPU3_ALIGN is confusing.
> > > > >
> > > > > Yet, instead of just dropping, I would replace it by a comment
> > > > > to explain that the struct is 32-bytes aligned.
> > > > >
> > > > > On a separate (but related) comment, you're declaring it as:
> > > > >
> > > > >         #define IPU3_ALIGN
> > > __attribute__((aligned(IPU3_UAPI_ISP_WORD_BYTES)))
> > > > >
> > > > > This is a gcc-specific dialect. Better to use, instead,
> > > > > __aligned(x) which is defined as:
> > > > >
> > > > > #define __aligned(x)            __attribute__((aligned(x)))
> > > > >
> > > >
> > > > Note that this is an uapi/ header. Is the __aligned() macro okay
> > > > to use in uapi headers? I couldn't find any header there using it
> > > > and we had problems with our user space compiling with it.
> > > >
> > > > By the way, I wonder if this is the right approach for controlling
> > > > the layout of ABI structs. I don't see many headers using any
> > > > alignment in uapi/ in general. Perhaps explicit padding bytes
> > > > would be more appropriate? They are also less tricky when one
> > > > structure needs to be embedded inside two or more different
> > > > structures with different alignments, which can't be done easily
> > > > if you specify __aligned() on the child struct.
> > >
> > > One of the reasons there are not so many are probably what you just
> > > elaborated above. That said, there are a few points to note here:
> > >
> > > - the alignment is generally the same here as it's due to DMA word size
> > >   AFAIK,
> > >
> > > - the device can be only found in an Intel SoC which limits the
> > >   architectures where the driver can actually be used to x86, 64- or
> > >   32-bit.
> > >
> > > Together these should in theory make if fairly safe. Padding in
> > > principle would be more explicit way to force struct memory layout
> > > without relying so much on the compiler doing the right thing but
> > > it'll lead to a *lot* of reserved fields, which I think is likely
> > > one of the reasons why it didn't catch up back then --- I've suggested it
> earlier.
> > >
> > > FWIW, the rest of the uAPI headers appear to be using
> > > __attribute__((aligned(x))).
> > >
> >
> > There are no compilation errors when using __attribute__((aligned(x)))
> > in the user space code.
> >
> > When using __aligned(x) (as Mauro recommended) as Tomasz pointed,
> > these compilation errors pop up (since __aligned(x) is defined nowhere).
> >
> > The definition of __aligned(x) is not available under include/uapi/*.
> > This is available in the kernel header include/linux/compiler_types.h
> >
> > There are other header files under include/uapi that use this format
> > (__attribute__((aligned(x))).
> >
> > Should we stick with __attribute__((aligned(x))) or is there a way out?
> 
> My suggestion is to stick with __attribute__((aligned(x))).

Ack

> 
> --
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
