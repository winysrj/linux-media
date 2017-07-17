Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44570 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdGQLke (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 07:40:34 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20170717114032epoutp01a28a979d42d02c67f260437a16629d83~SG0qGJEpZ2903529035epoutp01k
        for <linux-media@vger.kernel.org>; Mon, 17 Jul 2017 11:40:32 +0000 (GMT)
Subject: Re: [Patch v5 12/12] Documention: v4l: Documentation for HEVC CIDs
From: Smitha T Murthy <smitha.t@samsung.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <617cb1c5-074c-3f47-0096-fe7568dab8be@linaro.org>
Date: Mon, 17 Jul 2017 16:48:56 +0530
Message-ID: <1500290336.16819.6.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052521epcas5p36a0bc384d10809dcfe775e6da87ed37b@epcas5p3.samsung.com>
        <1497849055-26583-13-git-send-email-smitha.t@samsung.com>
        <617cb1c5-074c-3f47-0096-fe7568dab8be@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-07-07 at 17:59 +0300, Stanimir Varbanov wrote:
> Hi,
> 
> On 06/19/2017 08:10 AM, Smitha T Murthy wrote:
> > Added V4l2 controls for HEVC encoder
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > ---
> >  Documentation/media/uapi/v4l/extended-controls.rst | 364 +++++++++++++++++++++
> >  1 file changed, 364 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> > index abb1057..7767c70 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -1960,6 +1960,370 @@ enum v4l2_vp8_golden_frame_sel -
> >      1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
> >  
> >  
> 
> <cut>
> 
> > +``V4L2_CID_MPEG_VIDEO_HEVC_PROFILE``
> > +    (enum)
> > +
> > +enum v4l2_mpeg_video_hevc_profile -
> > +    Select the desired profile for HEVC encoder.
> > +
> > +.. raw:: latex
> > +
> > +    \begin{adjustbox}{width=\columnwidth}
> > +
> > +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN``
> > +      - Main profile.
> 
> MAIN10?
> 
No just MAIN.

> > +    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE``
> > +      - Main still picture profile.
> > +
> > +.. raw:: latex
> > +
> > +    \end{adjustbox}
> > +
> > +
> 
> <cut>
> 
> > +MFC 10.10 MPEG Controls
> > +-----------------------
> > +
> > +The following MPEG class controls deal with MPEG decoding and encoding
> > +settings that are specific to the Multi Format Codec 10.10 device present
> > +in the S5P and Exynos family of SoCs by Samsung.
> > +
> > +
> > +.. _mfc1010-control-id:
> > +
> > +MFC 10.10 Control IDs
> > +^^^^^^^^^^^^^^^^^^^^^
> > +
> > +``V4L2_CID_MPEG_MFC10_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES (integer)``
> > +    Selects number of P reference pictures required for HEVC encoder.
> > +    P-Frame can use 1 or 2 frames for reference.
> > +
> > +``V4L2_CID_MPEG_MFC10_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR (integer)``
> > +    Indicates whether to generate SPS and PPS at every IDR. Setting it to 0
> > +    disables generating SPS and PPS at every IDR. Setting it to one enables
> > +    generating SPS and PPS at every IDR.
> > +
> 
> I'm not sure those two should be driver specific, have to check does
> venus driver has similar controls.
> 
Yes please check and let me know if you have similar controls, I will
move it out.
> > +
> >  .. _camera-controls:
> >  
> >  Camera Control Reference
> > 
> 
