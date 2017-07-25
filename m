Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45467 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdGYFMY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 01:12:24 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20170725051222epoutp01572b476748e1ff4dfa0a54b1de686e59~UesBRTI7F1748217482epoutp01S
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 05:12:22 +0000 (GMT)
Subject: Re: [Patch v5 12/12] Documention: v4l: Documentation for HEVC CIDs
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <44dec947-83e8-d8fe-4da1-425aed3d0fb6@xs4all.nl>
Date: Tue, 25 Jul 2017 10:18:40 +0530
Message-ID: <1500958120.16819.3277.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052521epcas5p36a0bc384d10809dcfe775e6da87ed37b@epcas5p3.samsung.com>
        <1497849055-26583-13-git-send-email-smitha.t@samsung.com>
        <44dec947-83e8-d8fe-4da1-425aed3d0fb6@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-07-20 at 16:50 +0200, Hans Verkuil wrote:
> On 19/06/17 07:10, Smitha T Murthy wrote:
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
> > +High Efficiency Video Coding (HEVC/H.265) Control Reference
> > +-----------------------------------------------------------
> > +
> > +The HEVC/H.265 controls include controls for encoding parameters of HEVC/H.265
> > +video codec.
> > +
> > +
> > +.. _hevc-control-id:
> > +
> > +HEVC/H.265 Control IDs
> > +^^^^^^^^^^^^^^^^^^^^^^
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP (integer)``
> > +    Minimum quantization parameter for HEVC.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP (integer)``
> > +    Maximum quantization parameter for HEVC.
> 
> It's a bit ambiguous. Are these supposed to be read-only parameters?
> Normally min-max is already implied in the control range, so this is a
> bit odd. Perhaps it is clear for people who know HEVC, but I'm not
> quite sure what to make of it.
> 
These controls are used to set the QP bound for encoding.
This control is present for all other codecs as well.

> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP (integer)``
> > +    Quantization parameter for an I frame for HEVC.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP (integer)``
> > +    Quantization parameter for a P frame for HEVC.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP (integer)``
> > +    Quantization parameter for a B frame for HEVC.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP (boolean)``
> > +    HIERARCHICAL_QP allows host to specify the quantization parameter values
> > +    for each temporal layer through HIERARCHICAL_QP_LAYER. This is valid only
> > +    if HIERARCHICAL_CODING_LAYER is greater than 1. Setting the control value
> > +    to 1 enables setting of the QP values for the layers.
> > +
> > +.. _v4l2-hevc-hier-coding-type:
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE``
> > +    (enum)
> > +
> > +enum v4l2_mpeg_video_hevc_hier_coding_type -
> > +    Selects the hierarchical coding type for encoding. Possible values are:
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
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B``
> > +      - Use the B frame for hierarchical coding.
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P``
> > +      - Use the P frame for hierarchical coding.
> > +
> > +.. raw:: latex
> > +
> > +    \end{adjustbox}
> > +
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER (integer)``
> > +    Selects the hierarchical coding layer. In normal encoding
> > +    (non-hierarchial coding), it should be zero. Possible values are 0 ~ 6.
> > +    0 indicates HIERARCHICAL CODING LAYER 0, 1 indicates HIERARCHICAL CODING
> > +    LAYER 1 and so on.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER_QP (integer)``
> > +    Indicates the hierarchical coding layer quantization parameter.
> > +    For HEVC it can have a value of 0-51. Hence in the control value passed
> > +    the LSB 16 bits will indicate the quantization parameter. The MSB 16 bit
> > +    will pass the layer(0-6) it is meant for.
> 
> This is ugly. Why not make this an array control? This really is an array of
> 7 values, right? An alternative is to split this in 7 controls just as you did
> with V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L?_BR.
> 
> The way it is now doesn't work either since G_CTRL(V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER_QP)
> would just return the QP for whatever was the last layer you set it for and you can't
> query it for another layer.
> 
Ok I will add this as an array control.

> > +
> > +.. _v4l2-hevc-profile:
> > +
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
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE``
> > +      - Main still picture profile.
> > +
> > +.. raw:: latex
> > +
> > +    \end{adjustbox}
> > +
> > +
> > +.. _v4l2-hevc-level:
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_LEVEL``
> > +    (enum)
> > +
> > +enum v4l2_mpeg_video_hevc_level -
> > +    Selects the desired level for HEVC encoder.
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
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_1``
> > +      - Level 1.0
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_2``
> > +      - Level 2.0
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1``
> > +      - Level 2.1
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_3``
> > +      - Level 3.0
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1``
> > +      - Level 3.1
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_4``
> > +      - Level 4.0
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1``
> > +      - Level 4.1
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5``
> > +      - Level 5.0
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1``
> > +      - Level 5.1
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2``
> > +      - Level 5.2
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6``
> > +      - Level 6.0
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1``
> > +      - Level 6.1
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2``
> > +      - Level 6.2
> > +
> > +.. raw:: latex
> > +
> > +    \end{adjustbox}
> > +
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION (integer)``
> > +    Indicates the number of evenly spaced subintervals, called ticks, within
> > +    one second. This is a 16bit unsigned integer and has a maximum value up to
> 
> 16bit -> 16 bit
> 
I will correct it.

> > +    0xffff.
> 
> Is there a HEVC-defined minimum value as well? You mention the max value, but not
> the min value, so it made me wonder...
> 
Yes the minimum value is 1. I can mention the same in the next patch
version.

> > +
> > +.. _v4l2-hevc-tier-flag:
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG``
> > +    (enum)
> > +
> > +enum v4l2_mpeg_video_hevc_tier_flag -
> > +    TIER_FLAG specifies tiers information of the HEVC encoded picture. Tier
> > +    were made to deal with applications that differ in terms of maximum bit
> > +    rate. Setting the flag to 0 selects HEVC tier_flag as Main tier and setting
> > +    this flag to 1 indicates High tier. High tier is for applications requiring
> > +    high bit rates.
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
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_TIER_MAIN``
> > +      - Main tier.
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_TIER_HIGH``
> > +      - High tier.
> > +
> > +.. raw:: latex
> > +
> > +    \end{adjustbox}
> > +
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH (integer)``
> > +    Selects HEVC maximum coding unit depth.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_LF (boolean)``
> > +    Indicates loop filtering. Control value 1 indicates loop filtering
> > +    is enabled and when set to 0 indicates loop filtering is disabled.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY (boolean)``
> > +    Selects whether to apply the loop filter across the slice boundary or not.
> > +    If the value is 0, loop filter will not be applied across the slice boundary.
> > +    If the value is 1, loop filter will be applied across the slice boundary.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2 (integer)``
> > +    Selects HEVC loop filter beta offset. The valid range is [-6, +6].
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2 (integer)``
> > +    Selects HEVC loop filter tc offset. The valid range is [-6, +6].
> > +
> > +.. _v4l2-hevc-refresh-type:
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE``
> > +    (enum)
> > +
> > +enum v4l2_mpeg_video_hevc_hier_refresh_type -
> > +    Selects refresh type for HEVC encoder.
> > +    Host has to specify the period into
> > +    HEVC_REFRESH_PERIOD.
> 
> 'into HEVC_REFRESH_PERIOD' -> with the ``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD`` control
> 
I will correct it.

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
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE``
> > +      - Use the B frame for hierarchical coding.
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_CRA``
> > +      - Use CRA (Clean Random Access Unit) picture encoding.
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR``
> > +      - Use IDR picture encoding.
> > +
> > +.. raw:: latex
> > +
> > +    \end{adjustbox}
> > +
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD (integer)``
> > +    Selects the refresh period for HEVC encoder.
> > +    This specifies the number of I pictures between two CRA/IDR pictures.
> > +    This is valid only if REFRESH_TYPE is not 0.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU (boolean)``
> > +    Indicates HEVC lossless encoding. Setting it to 0 disables lossless
> > +    encoding. Setting it to 1 enables lossless encoding.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED (boolean)``
> > +    Indicates constant intra prediction for HEVC encoder. Specifies the
> > +    constrained intra prediction in which intra largest coding unit (LCU)
> > +    prediction is performed by using residual data and decoded samples of
> > +    neighboring intra LCU only. Setting the value to 1 enables constant intra
> > +    prediction and setting the value to 0 disables constant inta prediction.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT (boolean)``
> > +    Indicates wavefront parallel processing for HEVC encoder. Setting it to 0
> > +    disables the feature and setting it to 1 enables the wavefront parallel
> > +    processing.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB (boolean)``
> > +    Setting the value to 1 enables combination of P and B frame for HEVC
> > +    encoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID (boolean)``
> > +    Indicates temporal identifier for HEVC encoder which is enabled by
> > +    setting the value to 1.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING (boolean)``
> > +    Indicates bi-linear interpolation is conditionally used in the intra
> > +    prediction filtering process in the CVS when set to 1. Indicates bi-linear
> > +    interpolation is not used in the CVS when set to 0.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1 (integer)``
> > +    Indicates maximum number of merge candidate motion vectors.
> > +    Values are from zero to four.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION (boolean)``
> > +    Indicates temporal motion vector prediction for HEVC encoder. Setting it to
> > +    1 enables the prediction. Setting it to 0 disables the prediction.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE (boolean)``
> > +    Specifies if HEVC generates a stream with a size of the length field
> > +    instead of start code pattern. The size of the length field is configurable
> > +    through the V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD control. Setting
> > +    the value to 0 disables encoding without startcode pattern. Setting the
> > +    value to 1 will enables encoding without startcode pattern.
> > +
> > +.. _v4l2-hevc-size-of-length-field:
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD``
> > +(enum)
> > +
> > +enum v4l2_mpeg_video_hevc_size_of_length_field -
> > +    Indicates the size of length field.
> > +    This is valid when encoding WITHOUT_STARTCODE_ENABLE is enabled.
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
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_0``
> > +      - Generate start code pattern (Normal).
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_1``
> > +      - Generate size of length field instead of start code pattern and length is 1.
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_2``
> > +      - Generate size of length field instead of start code pattern and length is 2.
> > +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_4``
> > +      - Generate size of length field instead of start code pattern and length is 4.
> > +
> > +.. raw:: latex
> > +
> > +    \end{adjustbox}
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR (integer)``
> > +    Indicates bit rate for hierarchical coding layer 0 for HEVC encoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR (integer)``
> > +    Indicates bit rate for hierarchical coding layer 1 for HEVC encoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR (integer)``
> > +    Indicates bit rate for hierarchical coding layer 2 for HEVC encoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR (integer)``
> > +    Indicates bit rate for hierarchical coding layer 3 for HEVC encoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR (integer)``
> > +    Indicates bit rate for hierarchical coding layer 4 for HEVC encoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR (integer)``
> > +    Indicates bit rate for hierarchical coding layer 5 for HEVC encoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR (integer)``
> > +    Indicates bit rate for hierarchical coding layer 6 for HEVC encoder.
> > +
> > +
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
> > +
> >  .. _camera-controls:
> >  
> >  Camera Control Reference
> > 
> 
> Regards,
> 
> 	Hans
> 
> 
Thank you for the review.

Regards,
Smitha
