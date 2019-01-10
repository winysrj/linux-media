Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2997C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 18:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B49A420874
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 18:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfAJSfO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 13:35:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:32007 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfAJSfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 13:35:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 10:35:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="113748464"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jan 2019 10:35:11 -0800
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 10 Jan 2019 10:35:12 -0800
Received: from orsmsx106.amr.corp.intel.com ([169.254.1.179]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.192]) with mapi id 14.03.0415.000;
 Thu, 10 Jan 2019 10:35:12 -0800
From:   "Zhi, Yong" <yong.zhi@intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v8 15/17] media: v4l: Add Intel IPU3 meta buffer formats
Thread-Topic: [PATCH v8 15/17] media: v4l: Add Intel IPU3 meta buffer formats
Thread-Index: AQHUjcjiu26CCKyCXUOnsfGXsr8nLaV6DRAAgC72FVA=
Date:   Thu, 10 Jan 2019 18:35:11 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB52FDB@ORSMSX106.amr.corp.intel.com>
References: <1544144622-29791-1-git-send-email-yong.zhi@intel.com>
 <1544144622-29791-16-git-send-email-yong.zhi@intel.com>
 <2743727.5LazzqFdDF@avalon>
In-Reply-To: <2743727.5LazzqFdDF@avalon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWZkZmI3YjktMzhmYS00YTgyLTk3NjItYTAzN2FlZjE3NjdiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoia3F4RVwvQWFsdDd2MGdTbDBRaGtjYXJjQmtBXC82RG1lMUtWVXdEWUJnN0ZLMnpTaWpHdlBzZFwvY1N0UzRRUkh1ciJ9
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi, Laurent,

Thanks for the review.

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, December 11, 2018 6:59 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com;
> tfiga@chromium.org; Mani, Rajmohan <rajmohan.mani@intel.com>;
> Toivonen, Tuukka <tuukka.toivonen@intel.com>; Hu, Jerry W
> <jerry.w.hu@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>;
> hans.verkuil@cisco.com; mchehab@kernel.org; Cao, Bingbu
> <bingbu.cao@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>
> Subject: Re: [PATCH v8 15/17] media: v4l: Add Intel IPU3 meta buffer formats
> 
> Hello Yong,
> 
> Thank you for the patch.
> 
> On Friday, 7 December 2018 03:03:40 EET Yong Zhi wrote:
> > Add IPU3-specific meta formats for processing parameters and 3A
> > statistics.
> >
> >   V4L2_META_FMT_IPU3_PARAMS
> >   V4L2_META_FMT_IPU3_STAT_3A
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> My Reviewed-by tag was related to the format part only (v4l2-ioctl.c and
> videodev2.h) :-) Please see below for more comments about the
> documentation.
> 
> > ---
> >  Documentation/media/uapi/v4l/meta-formats.rst      |   1 +
> >  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      | 178
> ++++++++++++++++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
> >  include/uapi/linux/videodev2.h                     |   4 +
> >  4 files changed, 185 insertions(+)
> >  create mode 100644
> > Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/meta-formats.rst
> > b/Documentation/media/uapi/v4l/meta-formats.rst index
> > 438bd244bd2f..5f956fa784b7 100644
> > --- a/Documentation/media/uapi/v4l/meta-formats.rst
> > +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> > @@ -19,6 +19,7 @@ These formats are used for the :ref:`metadata`
> > interface only.
> >  .. toctree::
> >      :maxdepth: 1
> >
> > +    pixfmt-meta-intel-ipu3
> >      pixfmt-meta-d4xx
> >      pixfmt-meta-uvc
> >      pixfmt-meta-vsp1-hgo
> 
> Please keep this list alphabetically sorted.
> 

Ack.

> > diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst new file
> > mode
> > 100644
> > index 000000000000..8cd30ffbf8b8
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > @@ -0,0 +1,178 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _v4l2-meta-fmt-params:
> > +.. _v4l2-meta-fmt-stat-3a:
> > +
> >
> +***************************************************************
> ***
> > +V4L2_META_FMT_IPU3_PARAMS ('ip3p'), V4L2_META_FMT_IPU3_3A
> ('ip3s')
> >
> +***************************************************************
> ***
> > +
> > +.. c:type:: ipu3_uapi_stats_3a
> 
> No need for c:type:: here, the structure is already properly defined in
> drivers/staging/media/ipu3/include/intel-ipu3.h
> 

Ack.

> > +3A statistics
> > +=============
> > +
> > +For IPU3 ImgU, the 3A statistics accelerators collect different
> > +statistics
> 
> I'd write "The IPU3 ImgU 3A statistics accelerators collect" or "The IPU3 ImgU
> includes 3A statistics accelerators that collect"
> 
> > over +an input bayer frame. Those statistics, defined in data struct
> 
> bayer should be spelled Bayer (here and below).
> 
> > :c:type:`ipu3_uapi_stats_3a`, +are obtained from "ipu3-imgu 3a stat"
> > metadata capture video node, which are then +passed to user space for
> > statistics analysis using :c:type:`v4l2_meta_format` interface.
> 
> How about simply
> 
> "Those statistics are obtained from the "ipu3-imgu [01] 3a stat" metadata
> capture video nodes, using the :c:type:`v4l2_meta_format` interface. They
> are formatted as described by the :c:type:`ipu3_uapi_stats_3a` structure."
> 

Thanks for refining and improving the text :)

> > +
> > +The statistics collected are AWB (Auto-white balance) RGBS (Red,
> > +Green,
> > Blue and +Saturation measure) cells, AWB filter response, AF
> > (Auto-focus) filter response, +and AE (Auto-exposure) histogram.
> 
> Could you please wrap lines at the 80 columns boundary ?
> 

Ack.

> > +struct :c:type:`ipu3_uapi_4a_config` saves configurable parameters
> > +for all
> > above.
> 
> I would write it as "The
> 
> By the way why "4a" when the documentation talks about 3A ? Shouldn't the
> structure be called ipu3_uapi_3a_config ?
> 

The 4th "a" refers to the AWB filter response config.

> > +
> > +.. code-block:: c
> > +
> > +	struct ipu3_uapi_stats_3a {
> > +		struct ipu3_uapi_awb_raw_buffer awb_raw_buffer;
> > +		struct ipu3_uapi_ae_raw_buffer_aligned
> > ae_raw_buffer[IPU3_UAPI_MAX_STRIPES];
> > +		struct ipu3_uapi_af_raw_buffer
> > af_raw_buffer;
> > +		struct ipu3_uapi_awb_fr_raw_buffer awb_fr_raw_buffer;
> > +		struct ipu3_uapi_4a_config stats_4a_config;
> > +		__u32 ae_join_buffers;
> > +		__u8 padding[28];
> > +		struct ipu3_uapi_stats_3a_bubble_info_per_stripe
> > stats_3a_bubble_per_stripe;
> > +		struct ipu3_uapi_ff_status stats_3a_status;
> > +	};
> >
> > +.. c:type:: ipu3_uapi_params
> 
> No need for c:type:: here either.
> 

Ack.

> > +Pipeline parameters
> > +===================
> > +
> > +IPU3 pipeline has a number of image processing stages, each of which
> > +takes
> 
> s/IPU3/The IPU3/
> 
> > a +set of parameters as input. The major stages of pipelines are shown
> > here:
> > +
> > +Raw pixels -> Bayer Downscaling -> Optical Black Correction ->
> > +
> > +Linearization -> Lens Shading Correction -> White Balance / Exposure
> > +/
> > +
> > +Focus Apply -> Bayer Noise Reduction -> ANR -> Demosaicing -> Color
> > +
> > +Correction Matrix -> Gamma correction -> Color Space Conversion ->
> > +
> > +Chroma Down Scaling -> Chromatic Noise Reduction -> Total Color
> > +
> > +Correction -> XNR3 -> TNR -> DDR
> 
> You can replace this list with
> 
> .. kernel-render:: DOT
>    :alt: IPU3 ImgU Pipeline
>    :caption: IPU3 ImgU Pipeline Diagram
> 
>    digraph "IPU3 ImgU" {
>        node [shape=box]
>        splines="ortho"
>        rankdir="LR"
> 
>        a [label="Raw pixels"]
>        b [label="Bayer Downscaling"]
>        c [label="Optical Black Correction"]
>        d [label="Linearization"]
>        e [label="Lens Shading Correction"]
>        f [label="White Balance / Exposure / Focus Apply"]
>        g [label="Bayer Noise Reduction"]
>        h [label="ANR"]
>        i [label="Demosaicing"]
>        j [label="Color Correction Matrix"]
>        k [label="Gamma correction"]
>        l [label="Color Space Conversion"]
>        m [label="Chroma Down Scaling"]
>        n [label="Chromatic Noise Reduction"]
>        o [label="Total Color Correction"]
>        p [label="XNR3"]
>        q [label="TNR"]
>        r [label="DDR"]
> 
>        { rank=same; a -> b -> c -> d -> e -> f }
>        { rank=same; g -> h -> i -> j -> k -> l }
>        { rank=same; m -> n -> o -> p -> q -> r }
> 
>        a -> g -> m [style=invis, weight=10]
> 
>        f -> g
>        l -> m
>    }
> 
> to get a nicer diagram.
> 

The generated block diagram looks better indeed, thanks for sharing!!

> > +The table below presents a description of the above algorithms.
> > +
> > +========================
> > =======================================================
> > +Name			Description
> > +========================
> > =======================================================
> > +Optical Black
> > Correction Optical Black Correction block subtracts a pre-defined +
> 
> > value from the respective pixel values to obtain better
> > +			 image quality.
> > +			 Defined in :c:type:`ipu3_uapi_obgrid_param`.
> > +Linearization		 This algo block uses linearization parameters
> to
> > +			 address non-linearity sensor effects. The Lookup
> table
> > +			 table is defined in
> > +			 :c:type:`ipu3_uapi_isp_lin_vmem_params`.
> > +SHD			 Lens shading correction is used to correct spatial
> > +			 non-uniformity of the pixel response due to optical
> > +			 lens shading. This is done by applying a different
> gain
> > +			 for each pixel. The gain, black level etc are
> > +			 configured in :c:type:`ipu3_uapi_shd_config_static`.
> > +BNR			 Bayer noise reduction block removes image noise by
> > +			 applying a bilateral filter.
> > +			 See :c:type:`ipu3_uapi_bnr_static_config` for details.
> > +ANR			 Advanced Noise Reduction is a block based algorithm
> > +			 that performs noise reduction in the Bayer domain.
> The
> > +			 convolution matrix etc can be found in
> > +			 :c:type:`ipu3_uapi_anr_config`.
> > +Demosaicing		 Demosaicing converts raw sensor data in
> Bayer format
> > +			 into RGB (Red, Green, Blue) presentation. Then add
> > +			 outputs of estimation of Y channel for following
> stream
> > +			 processing by Firmware. The struct is defined as
> > +			 :c:type:`ipu3_uapi_dm_config`. (TODO)
> > +Color Correction	 Color Correction algo transforms sensor specific
> color
> > +			 space to the standard "sRGB" color space. This is
> done
> > +			 by applying 3x3 matrix defined in
> > +			 :c:type:`ipu3_uapi_ccm_mat_config`.
> > +Gamma correction	 Gamma
> correction :c:type:`ipu3_uapi_gamma_config` is a
> > +			 basic non-linear tone mapping correction that is
> > +			 applied per pixel for each pixel component.
> > +CSC			 Color space conversion transforms each pixel from
> the
> > +			 RGB primary presentation to YUV (Y: brightness,
> > +			 UV: Luminance) presentation. This is done by
> applying
> > +			 a 3x3 matrix defined in
> > +			 :c:type:`ipu3_uapi_csc_mat_config`
> > +CDS			 Chroma down sampling
> > +			 After the CSC is performed, the Chroma Down
> Sampling
> > +			 is applied for a UV plane down sampling by a factor
> > +			 of 2 in each direction for YUV 4:2:0 using a 4x2
> > +			 configurable filter :c:type:`ipu3_uapi_cds_params`.
> > +CHNR			 Chroma noise reduction
> > +			 This block processes only the chrominance pixels
> and
> > +			 performs noise reduction by cleaning the high
> > +			 frequency noise.
> > +			 See struct :c:type:`ipu3_uapi_yuvp1_chnr_config`.
> > +TCC			 Total color correction as defined in struct
> > +			 :c:type:`ipu3_uapi_yuvp2_tcc_static_config`.
> > +XNR3			 eXtreme Noise Reduction V3 is the third
> revision of
> > +			 noise reduction algorithm used to improve image
> > +			 quality. This removes the low frequency noise in the
> > +			 captured image. Two related structs are  being
> defined,
> > +			 :c:type:`ipu3_uapi_isp_xnr3_params` for ISP data
> memory
> > +			 and :c:type:`ipu3_uapi_isp_xnr3_vmem_params` for
> vector
> > +			 memory.
> > +TNR			 Temporal Noise Reduction block compares
> successive
> > +			 frames in time to remove anomalies / noise in pixel
> > +			 values. :c:type:`ipu3_uapi_isp_tnr3_vmem_params`
> and
> > +			 :c:type:`ipu3_uapi_isp_tnr3_params` are defined for
> ISP
> > +			 vector and data memory respectively.
> > +========================
> > =======================================================
> > +
> > +A few stages of the pipeline will be executed by firmware running on
> > +the
> > ISP +processor, while many others will use a set of fixed hardware
> > blocks also +called accelerator cluster (ACC) to crunch pixel data and
> > produce statistics.
> > +
> > +ACC parameters of individual algorithms, as defined by
> > +:c:type:`ipu3_uapi_acc_param`, can be chosen to be applied by the
> > +user space through struct :c:type:`ipu3_uapi_flags` embedded in
> > +:c:type:`ipu3_uapi_params` structure. For parameters that are
> > +configured as not enabled by the user space, the corresponding
> > +structs are ignored by
> > the +driver, in which case the existing configuration of the algorithm
> > will be +preserved.
> > +
> > +Both 3A statistics and pipeline parameters described here are closely
> > +tied
> > to +the underlying camera sub-system (CSS) APIs. They are usually
> > consumed and +produced by dedicated user space libraries that comprise
> > the important tuning +tools, thus freeing the developers from being
> > bothered with the low level +hardware and algorithm details.
> > +
> > +It should be noted that IPU3 DMA operations require the addresses of
> > +all
> > data +structures (that includes both input and output) to be aligned
> > on 32 byte +boundaries.
> 
> I think most of the above (from the diagram to here) belongs to
> Documentation/ media/v4l-drivers/ipu3.rst. It can be referenced here, but
> this file should focus on the description of the metadata formats, not on the
> description of the IPU3 ImgU internals.
> 

Ack, will move block diagram to /media/v4l-drivers/ipu3.rst as suggested. I prefer to leave the above short description here though.

> > +The meta data :c:type:`ipu3_uapi_params` will be sent to "ipu3-imgu
> > parameters" +video node in ``V4L2_BUF_TYPE_META_CAPTURE`` format.
> 
> To be consistent with the statistics documentation, how about the following ?
> 
> "The pipeline parameters are passed to the "ipu3-imgu [01] parameters"
> metadata output video nodes, using the :c:type:`v4l2_meta_format` interface.
> They are formatted as described by the :c:type:`ipu3_uapi_params`
> structure."
> 

Sure, thanks!

> > +.. code-block:: c
> > +
> > +	struct ipu3_uapi_params {
> > +		/* Flags which of the settings below are to be applied */
> > +		struct ipu3_uapi_flags use;
> > +
> > +		/* Accelerator cluster parameters */
> > +		struct ipu3_uapi_acc_param acc_param;
> > +
> > +		/* ISP vector address space parameters */
> > +		struct ipu3_uapi_isp_lin_vmem_params lin_vmem_params;
> > +		struct ipu3_uapi_isp_tnr3_vmem_params
> tnr3_vmem_params;
> > +		struct ipu3_uapi_isp_xnr3_vmem_params
> xnr3_vmem_params;
> > +
> > +		/* ISP data memory (DMEM) parameters */
> > +		struct ipu3_uapi_isp_tnr3_params tnr3_dmem_params;
> > +		struct ipu3_uapi_isp_xnr3_params xnr3_dmem_params;
> > +
> > +		/* Optical black level compensation */
> > +		struct ipu3_uapi_obgrid_param obgrid_param;
> > +	};
> > +
> > +Intel IPU3 ImgU uAPI data types
> > +===============================
> > +
> > +.. kernel-doc:: include/uapi/linux/intel-ipu3.h
> 
> This file has moved to drivers/staging/media/ipu3/include/intel-ipu3.h.
> 

Ack, Sakari has already taken care of this one.

> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c index
> > a1806d3a1c41..0701cb8a03ef
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1300,6 +1300,8 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc
> *fmt)
> > case V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram";
> break;
> > case V4L2_META_FMT_VSP1_HGT:	descr = "R-Car VSP1 2-D Histogram";
> break;
> > case V4L2_META_FMT_UVC:		descr = "UVC payload header
> metadata"; break;
> > +	case V4L2_META_FMT_IPU3_PARAMS:	descr = "IPU3 processing
> parameters";
> > break; +	case V4L2_META_FMT_IPU3_STAT_3A:	descr = "IPU3 3A
> statistics";
> > break;
> >
> >  	default:
> >  		/* Compressed formats */
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index a9d47b1b9437..f2b973b36e29
> > 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -721,6 +721,10 @@ struct v4l2_pix_format {
> >  #define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC
> > Payload Header metadata */ #define V4L2_META_FMT_D4XX
> > v4l2_fourcc('D', '4', 'X', 'X') /* D4XX Payload Header metadata */
> >
> > +/* Vendor specific - used for IPU3 camera sub-system */
> > +#define V4L2_META_FMT_IPU3_PARAMS	v4l2_fourcc('i', 'p', '3', 'p') /*
> IPU3
> > processing parameters */ +#define
> > V4L2_META_FMT_IPU3_STAT_3A	v4l2_fourcc('i', 'p', '3', 's') /* IPU3 3A
> > statistics */ +
> >  /* priv field value to indicates that subsequent fields are valid. */
> >  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
> 
> --
> Regards,
> 
> Laurent Pinchart
> 
> 

