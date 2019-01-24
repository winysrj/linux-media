Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29F9C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 17:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80EE12184C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 17:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfAXRP7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 12:15:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:35837 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbfAXRP7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 12:15:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2019 09:15:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,517,1539673200"; 
   d="scan'208";a="141012994"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2019 09:15:58 -0800
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 24 Jan 2019 09:15:57 -0800
Received: from orsmsx106.amr.corp.intel.com ([169.254.1.54]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.107]) with mapi id 14.03.0415.000;
 Thu, 24 Jan 2019 09:15:57 -0800
From:   "Zhi, Yong" <yong.zhi@intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v2] media: ipu3: update meta format documentation
Thread-Topic: [PATCH v2] media: ipu3: update meta format documentation
Thread-Index: AQHUs1O09OMWmBFCS0OIH69xyGlicKW+i1aAgAAeDQA=
Date:   Thu, 24 Jan 2019 17:15:56 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB54D64@ORSMSX106.amr.corp.intel.com>
References: <1548272156-1368-1-git-send-email-yong.zhi@intel.com>
 <20190124072510.qsrjow4x2t6hgfoa@paasikivi.fi.intel.com>
In-Reply-To: <20190124072510.qsrjow4x2t6hgfoa@paasikivi.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZGY1MjYyOTUtMmUxZC00YzU1LWJkMzEtOGU1YWM4MzcxZDVlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTU4zRGg0MzJLdms0MTdvenAzOVlqK3hoTEcyZFRmMUFydXZtQUZhK2VRejA1TThOZCthc3pRdE10ZU9yZVwvQVwvIn0=
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi, Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Wednesday, January 23, 2019 11:25 PM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; laurent.pinchart@ideasonboard.com;
> Mani, Rajmohan <rajmohan.mani@intel.com>; tfiga@chromium.org;
> hans.verkuil@cisco.com; mchehab@kernel.org; Qiu, Tian Shu
> <tian.shu.qiu@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
> Subject: Re: [PATCH v2] media: ipu3: update meta format documentation
> 
> Hi Yong,
> 
> On Wed, Jan 23, 2019 at 11:35:56AM -0800, Yong Zhi wrote:
> > Make changes based on Laurent's v8 review:
> > https://www.spinics.net/lists/linux-media/msg144408.html
> 
> Could you outline the changes made by this patch, instead of referring to an
> e-mail on a list, please? A short summary is sufficient. Such as:
> 
> Language improvements, fix entity naming, make pipeline a graph and move
> device usage documentation to device documentation (out of format
> documentation).
> 
> I'd put the struch rename in the header into a separate patch: it's not about
> documentation.
> 

Sure, Tomasz also suggested few struct name changes, I will put them together in the header patch.

> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> > v2
> >
> > Rename stats_4a_config to stats_3a_config in intel-ipu3.h.
> >
> >  Documentation/media/uapi/v4l/meta-formats.rst      |   2 +-
> >  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      | 119 ++---------------
> >  Documentation/media/v4l-drivers/ipu3.rst           | 147
> +++++++++++++++++++++
> >  drivers/staging/media/ipu3/include/intel-ipu3.h    |   8 +-
> >  4 files changed, 163 insertions(+), 113 deletions(-)
> >
> > diff --git a/Documentation/media/uapi/v4l/meta-formats.rst
> > b/Documentation/media/uapi/v4l/meta-formats.rst
> > index 5f956fa..b10ca9e 100644
> > --- a/Documentation/media/uapi/v4l/meta-formats.rst
> > +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> > @@ -19,8 +19,8 @@ These formats are used for the :ref:`metadata`
> interface only.
> >  .. toctree::
> >      :maxdepth: 1
> >
> > -    pixfmt-meta-intel-ipu3
> >      pixfmt-meta-d4xx
> > +    pixfmt-meta-intel-ipu3
> >      pixfmt-meta-uvc
> >      pixfmt-meta-vsp1-hgo
> >      pixfmt-meta-vsp1-hgt
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > index 659e58a..7fb5433 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > @@ -30,21 +30,22 @@
> >  V4L2_META_FMT_IPU3_PARAMS ('ip3p'), V4L2_META_FMT_IPU3_3A
> ('ip3s')
> >
> ****************************************************************
> **
> >
> > -.. c:type:: ipu3_uapi_stats_3a
> > +.. ipu3_uapi_stats_3a
> >
> >  3A statistics
> >  =============
> >
> > -For IPU3 ImgU, the 3A statistics accelerators collect different
> > statistics over -an input bayer frame. Those statistics, defined in
> > data struct :c:type:`ipu3_uapi_stats_3a`, -are obtained from
> > "ipu3-imgu 3a stat" metadata capture video node, which are then -passed
> to user space for statistics analysis using :c:type:`v4l2_meta_format` interface.
> > +The IPU3 ImgU 3A statistics accelerators collect different statistics
> > +over an input Bayer frame. Those statistics are obtained from the
> > +"ipu3-imgu [01] 3a stat" metadata capture video nodes, using the
> > +:c:type:`v4l2_meta_format` interface. They are formatted as described
> > +by the :c:type:`ipu3_uapi_stats_3a` structure.
> >
> >  The statistics collected are AWB (Auto-white balance) RGBS (Red,
> > Green, Blue and  Saturation measure) cells, AWB filter response, AF
> > (Auto-focus) filter response,  and AE (Auto-exposure) histogram.
> >
> > -struct :c:type:`ipu3_uapi_4a_config` saves configurable parameters for all
> above.
> > +The struct :c:type:`ipu3_uapi_4a_config` saves all configurable parameters.
> >
> >  .. code-block:: c
> >
> > @@ -60,105 +61,14 @@ struct :c:type:`ipu3_uapi_4a_config` saves
> configurable parameters for all above
> >  		struct ipu3_uapi_ff_status stats_3a_status;
> >  	};
> >
> > -.. c:type:: ipu3_uapi_params
> > +.. ipu3_uapi_params
> >
> >  Pipeline parameters
> >  ===================
> >
> > -IPU3 pipeline has a number of image processing stages, each of which
> > takes a -set of parameters as input. The major stages of pipelines are
> shown here:
> > -
> > -Raw pixels -> Bayer Downscaling -> Optical Black Correction ->
> > -
> > -Linearization -> Lens Shading Correction -> White Balance / Exposure
> > /
> > -
> > -Focus Apply -> Bayer Noise Reduction -> ANR -> Demosaicing -> Color
> > -
> > -Correction Matrix -> Gamma correction -> Color Space Conversion ->
> > -
> > -Chroma Down Scaling -> Chromatic Noise Reduction -> Total Color
> > -
> > -Correction -> XNR3 -> TNR -> DDR
> > -
> > -The table below presents a description of the above algorithms.
> > -
> > -========================
> =======================================================
> > -Name			 Description
> > -========================
> > =======================================================
> > -Optical Black Correction Optical Black Correction block subtracts a pre-
> defined
> > -			 value from the respective pixel values to obtain
> better
> > -			 image quality.
> > -			 Defined in :c:type:`ipu3_uapi_obgrid_param`.
> > -Linearization		 This algo block uses linearization parameters to
> > -			 address non-linearity sensor effects. The Lookup
> table
> > -			 table is defined in
> > -			 :c:type:`ipu3_uapi_isp_lin_vmem_params`.
> > -SHD			 Lens shading correction is used to correct spatial
> > -			 non-uniformity of the pixel response due to optical
> > -			 lens shading. This is done by applying a different
> gain
> > -			 for each pixel. The gain, black level etc are
> > -			 configured in :c:type:`ipu3_uapi_shd_config_static`.
> > -BNR			 Bayer noise reduction block removes image noise by
> > -			 applying a bilateral filter.
> > -			 See :c:type:`ipu3_uapi_bnr_static_config` for details.
> > -ANR			 Advanced Noise Reduction is a block based algorithm
> > -			 that performs noise reduction in the Bayer domain.
> The
> > -			 convolution matrix etc can be found in
> > -			 :c:type:`ipu3_uapi_anr_config`.
> > -Demosaicing		 Demosaicing converts raw sensor data in Bayer
> format
> > -			 into RGB (Red, Green, Blue) presentation. Then add
> > -			 outputs of estimation of Y channel for following
> stream
> > -			 processing by Firmware. The struct is defined as
> > -			 :c:type:`ipu3_uapi_dm_config`. (TODO)
> > -Color Correction	 Color Correction algo transforms sensor specific
> color
> > -			 space to the standard "sRGB" color space. This is
> done
> > -			 by applying 3x3 matrix defined in
> > -			 :c:type:`ipu3_uapi_ccm_mat_config`.
> > -Gamma correction	 Gamma
> correction :c:type:`ipu3_uapi_gamma_config` is a
> > -			 basic non-linear tone mapping correction that is
> > -			 applied per pixel for each pixel component.
> > -CSC			 Color space conversion transforms each pixel from
> the
> > -			 RGB primary presentation to YUV (Y: brightness,
> > -			 UV: Luminance) presentation. This is done by
> applying
> > -			 a 3x3 matrix defined in
> > -			 :c:type:`ipu3_uapi_csc_mat_config`
> > -CDS			 Chroma down sampling
> > -			 After the CSC is performed, the Chroma Down
> Sampling
> > -			 is applied for a UV plane down sampling by a factor
> > -			 of 2 in each direction for YUV 4:2:0 using a 4x2
> > -			 configurable filter :c:type:`ipu3_uapi_cds_params`.
> > -CHNR			 Chroma noise reduction
> > -			 This block processes only the chrominance pixels
> and
> > -			 performs noise reduction by cleaning the high
> > -			 frequency noise.
> > -			 See struct :c:type:`ipu3_uapi_yuvp1_chnr_config`.
> > -TCC			 Total color correction as defined in struct
> > -			 :c:type:`ipu3_uapi_yuvp2_tcc_static_config`.
> > -XNR3			 eXtreme Noise Reduction V3 is the third
> revision of
> > -			 noise reduction algorithm used to improve image
> > -			 quality. This removes the low frequency noise in the
> > -			 captured image. Two related structs are  being
> defined,
> > -			 :c:type:`ipu3_uapi_isp_xnr3_params` for ISP data
> memory
> > -			 and :c:type:`ipu3_uapi_isp_xnr3_vmem_params` for
> vector
> > -			 memory.
> > -TNR			 Temporal Noise Reduction block compares
> successive
> > -			 frames in time to remove anomalies / noise in pixel
> > -			 values. :c:type:`ipu3_uapi_isp_tnr3_vmem_params`
> and
> > -			 :c:type:`ipu3_uapi_isp_tnr3_params` are defined for
> ISP
> > -			 vector and data memory respectively.
> > -========================
> > =======================================================
> > -
> > -A few stages of the pipeline will be executed by firmware running on
> > the ISP -processor, while many others will use a set of fixed hardware
> > blocks also -called accelerator cluster (ACC) to crunch pixel data and
> produce statistics.
> > -
> > -ACC parameters of individual algorithms, as defined by
> > -:c:type:`ipu3_uapi_acc_param`, can be chosen to be applied by the
> > user -space through struct :c:type:`ipu3_uapi_flags` embedded in
> > -:c:type:`ipu3_uapi_params` structure. For parameters that are
> > configured as -not enabled by the user space, the corresponding
> > structs are ignored by the -driver, in which case the existing
> > configuration of the algorithm will be -preserved.
> > +The pipeline parameters are passed to the "ipu3-imgu [01] parameters"
> > +metadata output video nodes, using the :c:type:`v4l2_meta_format`
> > +interface. They are formatted as described by
> the :c:type:`ipu3_uapi_params` structure.
> >
> >  Both 3A statistics and pipeline parameters described here are closely
> > tied to  the underlying camera sub-system (CSS) APIs. They are usually
> > consumed and @@ -166,13 +76,6 @@ produced by dedicated user space
> > libraries that comprise the important tuning  tools, thus freeing the
> > developers from being bothered with the low level  hardware and
> algorithm details.
> >
> > -It should be noted that IPU3 DMA operations require the addresses of
> > all data -structures (that includes both input and output) to be
> > aligned on 32 byte -boundaries.
> > -
> > -The meta data :c:type:`ipu3_uapi_params` will be sent to "ipu3-imgu
> parameters"
> > -video node in ``V4L2_BUF_TYPE_META_CAPTURE`` format.
> > -
> >  .. code-block:: c
> >
> >  	struct ipu3_uapi_params {
> > diff --git a/Documentation/media/v4l-drivers/ipu3.rst
> > b/Documentation/media/v4l-drivers/ipu3.rst
> > index 804f373..c9f7804 100644
> > --- a/Documentation/media/v4l-drivers/ipu3.rst
> > +++ b/Documentation/media/v4l-drivers/ipu3.rst
> > @@ -357,6 +357,153 @@
> > https://chromium.googlesource.com/chromiumos/platform/arc-
> camera/+/mas
> > ter/
> >
> >  The source can be located under hal/intel directory.
> >
> > +Overview of IPU3 pipeline
> > +=========================
> > +
> > +IPU3 pipeline has a number of image processing stages, each of which
> > +takes a set of parameters as input. The major stages of pipelines are
> shown here:
> > +
> > +.. kernel-render:: DOT
> > +   :alt: IPU3 ImgU Pipeline
> > +   :caption: IPU3 ImgU Pipeline Diagram
> > +
> > +   digraph "IPU3 ImgU" {
> > +       node [shape=box]
> > +       splines="ortho"
> > +       rankdir="LR"
> > +
> > +       a [label="Raw pixels"]
> > +       b [label="Bayer Downscaling"]
> > +       c [label="Optical Black Correction"]
> > +       d [label="Linearization"]
> > +       e [label="Lens Shading Correction"]
> > +       f [label="White Balance / Exposure / Focus Apply"]
> > +       g [label="Bayer Noise Reduction"]
> > +       h [label="ANR"]
> > +       i [label="Demosaicing"]
> > +       j [label="Color Correction Matrix"]
> > +       k [label="Gamma correction"]
> > +       l [label="Color Space Conversion"]
> > +       m [label="Chroma Down Scaling"]
> > +       n [label="Chromatic Noise Reduction"]
> > +       o [label="Total Color Correction"]
> > +       p [label="XNR3"]
> > +       q [label="TNR"]
> > +       r [label="DDR"]
> > +
> > +       { rank=same; a -> b -> c -> d -> e -> f }
> > +       { rank=same; g -> h -> i -> j -> k -> l }
> > +       { rank=same; m -> n -> o -> p -> q -> r }
> > +
> > +       a -> g -> m [style=invis, weight=10]
> > +
> > +       f -> g
> > +       l -> m
> > +   }
> > +
> > +The table below presents a description of the above algorithms.
> > +
> > +========================
> =======================================================
> > +Name			 Description
> > +========================
> > +=======================================================
> > +Optical Black Correction Optical Black Correction block subtracts a pre-
> defined
> > +			 value from the respective pixel values to obtain
> better
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
> > +DM			 Demosaicing converts raw sensor data in Bayer
> format
> > +			 into RGB (Red, Green, Blue) presentation. Then add
> > +			 outputs of estimation of Y channel for following
> stream
> > +			 processing by Firmware. The struct is defined as
> > +			 :c:type:`ipu3_uapi_dm_config`.
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
> > +=======================================================
> > +
> > +Other often encountered acronyms not listed in above table:
> > +
> > +	ACC
> > +		Accelerator cluster
> > +	AWB_FR
> > +		Auto white balance filter response statistics
> > +	BDS
> > +		Bayer downscaler parameters
> > +	CCM
> > +		Color correction matrix coefficients
> > +	IEFd
> > +		Image enhancement filter directed
> > +	Obgrid
> > +		Optical black level compensation
> > +	OSYS
> > +		Output system configuration
> > +	ROI
> > +		Region of interest
> > +	YDS
> > +		Y down sampling
> > +	YTM
> > +		Y-tone mapping
> > +
> > +A few stages of the pipeline will be executed by firmware running on
> > +the ISP processor, while many others will use a set of fixed hardware
> > +blocks also called accelerator cluster (ACC) to crunch pixel data and
> produce statistics.
> > +
> > +ACC parameters of individual algorithms, as defined by
> > +:c:type:`ipu3_uapi_acc_param`, can be chosen to be applied by the
> > +user space through struct :c:type:`ipu3_uapi_flags` embedded in
> > +:c:type:`ipu3_uapi_params` structure. For parameters that are
> > +configured as not enabled by the user space, the corresponding
> > +structs are ignored by the driver, in which case the existing
> > +configuration of the algorithm will be preserved.
> > +
> >  References
> >  ==========
> >
> > diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h
> > b/drivers/staging/media/ipu3/include/intel-ipu3.h
> > index eb6f52a..bd75f87 100644
> > --- a/drivers/staging/media/ipu3/include/intel-ipu3.h
> > +++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
> > @@ -453,7 +453,7 @@ struct ipu3_uapi_awb_fr_config_s {  }
> > __attribute__((aligned(32))) __packed;
> >
> >  /**
> > - * struct ipu3_uapi_4a_config - 4A config
> > + * struct ipu3_uapi_3a_config - 3A config
> >   *
> >   * @awb_config: &ipu3_uapi_awb_config_s, default resolution 16x16
> >   * @ae_grd_config: auto exposure statistics &ipu3_uapi_ae_grid_config
> > @@ -461,7 +461,7 @@ struct ipu3_uapi_awb_fr_config_s {
> >   * @af_config: auto focus config &ipu3_uapi_af_config_s
> >   * @awb_fr_config: &ipu3_uapi_awb_fr_config_s, default resolution 16x16
> >   */
> > -struct ipu3_uapi_4a_config {
> > +struct ipu3_uapi_3a_config {
> >  	struct ipu3_uapi_awb_config_s awb_config
> __attribute__((aligned(32)));
> >  	struct ipu3_uapi_ae_grid_config ae_grd_config;
> >  	__u8 padding[20];
> > @@ -534,7 +534,7 @@ struct ipu3_uapi_ff_status {
> >   * @ae_raw_buffer: auto exposure raw data
> &ipu3_uapi_ae_raw_buffer_aligned
> >   * @af_raw_buffer: &ipu3_uapi_af_raw_buffer for auto focus meta data
> >   * @awb_fr_raw_buffer: value as specified by
> > &ipu3_uapi_awb_fr_raw_buffer
> > - * @stats_4a_config: 4a statistics config as defined by
> &ipu3_uapi_4a_config.
> > + * @stats_3a_config: 3a statistics config as defined by
> &ipu3_uapi_3a_config.
> >   * @ae_join_buffers: 1 to use ae_raw_buffer.
> >   * @padding: padding config
> >   * @stats_3a_bubble_per_stripe: a
> > &ipu3_uapi_stats_3a_bubble_info_per_stripe
> > @@ -546,7 +546,7 @@ struct ipu3_uapi_stats_3a {
> >  			ae_raw_buffer[IPU3_UAPI_MAX_STRIPES];
> >  	struct ipu3_uapi_af_raw_buffer af_raw_buffer;
> >  	struct ipu3_uapi_awb_fr_raw_buffer awb_fr_raw_buffer;
> > -	struct ipu3_uapi_4a_config stats_4a_config;
> > +	struct ipu3_uapi_3a_config stats_3a_config;
> >  	__u32 ae_join_buffers;
> >  	__u8 padding[28];
> >  	struct ipu3_uapi_stats_3a_bubble_info_per_stripe
> > --
> > 2.7.4
> >
> 
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
