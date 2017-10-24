Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:57073 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751336AbdJXXOH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 19:14:07 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>,
        "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Subject: RE: [PATCH v5 2/3] doc-rst: add IPU3 raw10 bayer pixel format
 definitions
Date: Tue, 24 Oct 2017 23:14:00 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2C5E8@ORSMSX106.amr.corp.intel.com>
References: <1507333141-28242-1-git-send-email-yong.zhi@intel.com>
 <1507333141-28242-3-git-send-email-yong.zhi@intel.com>
 <20171010083239.7qjdkyee42fbileg@valkosipuli.retiisi.org.uk>
In-Reply-To: <20171010083239.7qjdkyee42fbileg@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

Thanks for the feedback.

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Tuesday, October 10, 2017 1:33 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com;
> hans.verkuil@cisco.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>;
> tfiga@chromium.org; Mani, Rajmohan <rajmohan.mani@intel.com>;
> Toivonen, Tuukka <tuukka.toivonen@intel.com>; Yang, Hyungwoo
> <hyungwoo.yang@intel.com>; Vijaykumar, Ramya
> <ramya.vijaykumar@intel.com>; Rapolu, Chiranjeevi
> <chiranjeevi.rapolu@intel.com>
> Subject: Re: [PATCH v5 2/3] doc-rst: add IPU3 raw10 bayer pixel format
> definitions
> 
> Hi Yong,
> 
> On Fri, Oct 06, 2017 at 06:39:00PM -0500, Yong Zhi wrote:
> > The formats added by this patch are:
> >
> >     V4L2_PIX_FMT_IPU3_SBGGR10
> >     V4L2_PIX_FMT_IPU3_SGBRG10
> >     V4L2_PIX_FMT_IPU3_SGRBG10
> >     V4L2_PIX_FMT_IPU3_SRGGB10
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Signed-off-by: Hyungwoo Yang <hyungwoo.yang@intel.com>
> > ---
> >  Documentation/media/uapi/v4l/pixfmt-rgb.rst        |   1 +
> >  .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         | 166
> +++++++++++++++++++++
> >  2 files changed, 167 insertions(+)
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> > b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> > index 4cc27195dc79..cf2ef7df9616 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> > @@ -16,6 +16,7 @@ RGB Formats
> >      pixfmt-srggb10p
> >      pixfmt-srggb10alaw8
> >      pixfmt-srggb10dpcm8
> > +    pixfmt-srggb10-ipu3
> >      pixfmt-srggb12
> >      pixfmt-srggb12p
> >      pixfmt-srggb16
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> > b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> > new file mode 100644
> > index 000000000000..50292186a8b4
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> > @@ -0,0 +1,166 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _V4L2_PIX_FMT_IPU3_SBGGR10:
> > +.. _V4L2_PIX_FMT_IPU3_SGBRG10:
> > +.. _V4L2_PIX_FMT_IPU3_SGRBG10:
> > +.. _V4L2_PIX_FMT_IPU3_SRGGB10:
> > +
> >
> +***************************************************************
> ******
> >
> +***************************************************************
> ******
> > +****
> > +V4L2_PIX_FMT_IPU3_SBGGR10 ('ip3b'), V4L2_PIX_FMT_IPU3_SGBRG10
> > +('ip3g'), V4L2_PIX_FMT_IPU3_SGRBG10 ('ip3G'),
> > +V4L2_PIX_FMT_IPU3_SRGGB10 ('ip3r')
> >
> +***************************************************************
> ******
> >
> +***************************************************************
> ******
> > +****
> > +
> > +10-bit Bayer formats
> > +
> > +Description
> > +===========
> > +
> > +These four pixel formats are used by Intel IPU3 driver, they are raw
> > +sRGB / Bayer formats with 10 bits per sample with every 25 pixels
> > +packed to 32 bytes leaving 6 most significant bits padding in the last byte.
> > +The format is little endian.
> > +
> > +In other respects this format is similar to :ref:`V4L2-PIX-FMT-SRGGB10`.
> 
> You could add:
> 
> Below is an example of a small image in V4L2_PIX_FMT_IPU3_SBGGR10
> format.
> 

Ack.

> > +
> > +**Byte Order.**
> > +Each cell is one byte.
> > +
> > +.. raw:: latex
> > +
> > +    \newline\newline\begin{adjustbox}{width=\columnwidth}
> > +
> > +.. tabularcolumns::
> >
> +|p{1.3cm}|p{1.0cm}|p{10.9cm}|p{10.9cm}|p{10.9cm}|p{1.0cm}|p{1.0cm}|p
> {
> >
> +10.9cm}|p{10.9cm}|p{10.9cm}|p{1.0cm}|p{1.0cm}|p{10.9cm}|p{10.9cm}|p{
> 1
> >
> +0.9cm}|p{1.0cm}|p{1.0cm}|p{10.9cm}|p{10.9cm}|p{10.9cm}|p{1.0cm}|p{1.
> 0
> >
> +cm}|p{10.9cm}|p{10.9cm}|p{10.9cm}|p{1.0cm}|p{1.0cm}|p{10.9cm}|p{10.9
> c
> > +m}|p{10.9cm}|p{1.0cm}|p{1.0cm}|p{10.9cm}|
> 
> The width of this table is over one metre. Could you use fewer columns in it,
> say, four or eight?
> 

Sure, will do four columns in next update.

(snip)
> 
> --
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
