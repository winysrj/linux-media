Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54477 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935158AbdDFOsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 10:48:07 -0400
Subject: Re: [Patch v4 12/12] Documention: v4l: Documentation for HEVC CIDs
To: Smitha T Murthy <smitha.t@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <f68d8bd2-a2b4-7253-0a48-6c3f509e66cd@samsung.com>
Date: Thu, 06 Apr 2017 16:47:57 +0200
MIME-version: 1.0
In-reply-to: <1491459105-16641-13-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061027epcas5p2628e0a8e0fd76e2e267fad3ea1209f65@epcas5p2.samsung.com>
 <1491459105-16641-13-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/2017 08:11 AM, Smitha T Murthy wrote:
> Added V4l2 controls for HEVC encoder

s/HEVC/H.265/HEVC ?

> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  Documentation/media/uapi/v4l/extended-controls.rst | 391 +++++++++++++++++++++
>  1 file changed, 391 insertions(+)
>
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index abb1057..85a668d 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1960,6 +1960,397 @@ enum v4l2_vp8_golden_frame_sel -
>      1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
>
>
> +HEVC Control Reference

Perhaps "High Efficiency Video Coding (HEVC/H.265) Control Reference" ?

> +---------------------
> +
> +The HEVC controls include controls for encoding parameters of HEVC video
> +codec.

s/'HEVC'/'HEVC/H.265' ?

> +
> +
> +.. _hevc-control-id:
> +
> +HEVC Control IDs

s/'HEVC'/'HEVC/H.265' ?

> +^^^^^^^^^^^^^^^
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP``
> +    Minimum quantization parameter for HEVC.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP``
> +    Maximum quantization parameter for HEVC.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP``
> +    Quantization parameter for an I frame for HEVC.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP``
> +    Quantization parameter for a P frame for HEVC.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP``
> +    Quantization parameter for a B frame for HEVC.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP``
> +    HIERARCHICAL_QP allows host to specify the quantization parameter values
> +    for each temporal layer through HIERARCHICAL_QP_LAYER. This is valid only
> +    if HIERARCHICAL_CODING_LAYER is greater than 1.
> +
> +.. _v4l2-hevc-hierarchical-coding-type:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE``
> +    (enum)
> +
> +enum v4l2_mpeg_video_hevc_hier_coding_type -
> +    Selects the hierarchical coding type for encoding. Possible values are:
> +
> +.. raw:: latex
> +
> +    \begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B``
> +      - Use the B frame for hierarchical coding.
> +    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P``
> +      - Use the P frame for hierarchical coding.
> +
> +.. raw:: latex
> +
> +    \end{adjustbox}
> +
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER``
> +    Selects the hierarchical coding layer. In normal encoding
> +    (non-hierarchial coding), it should be zero. Possible values are 0 ~ 6.
> +    0 indicates HIERARCHICAL CODING LAYER 0, 1 indicates HIERARCHICAL CODING
> +    LAYER 1 and so on.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP``
> +    Indicates the hierarchical coding layer quantization parameter.
> +    For HEVC it can have a value of 0-51. Hence in the control value passed
> +    the LSB 16 bits will indicate the quantization parameter. The MSB 16 bit
> +    will pass the layer(0-6) it is meant for.
> +
> +.. _v4l2-hevc-profile:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_PROFILE``
> +    (enum)
> +
> +enum v4l2_mpeg_video_hevc_profile -
> +    Select the desired profile for HEVC encoder.
> +
> +.. raw:: latex
> +
> +    \begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN``
> +      - Main profile.
> +    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE``
> +      - Main still picture profile.
> +
> +.. raw:: latex
> +
> +    \end{adjustbox}
> +
> +
> +.. _v4l2-hevc-level:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LEVEL``
> +    (enum)
> +
> +enum v4l2_mpeg_video_hevc_level -
> +    Select the desired level for HEVC encoder.
> +
> +.. raw:: latex
> +
> +    \begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
> +
> +.. flat-table::
> +       :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_1``
> +      - Level 1.0
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_2``
> +      - Level 2.0
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1``
> +      - Level 2.1
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_3``
> +      - Level 3.0
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1``
> +      - Level 3.1
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_4``
> +      - Level 4.0
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1``
> +      - Level 4.1
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5``
> +      - Level 5.0
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1``
> +      - Level 5.1
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2``
> +      - Level 5.2
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6``
> +      - Level 6.0
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1``
> +      - Level 6.1
> +    * - ``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2``
> +      - Level 6.2
> +
> +.. raw:: latex
> +
> +    \end{adjustbox}
> +
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION``
> +    Indicates the number of evenly spaced subintervals, called ticks, within
> +    one modulo time. One modulo time represents the fixed interval of one
> +    second. This is a 16bit unsigned integer and has a maximum value upto

s/upto/up to/

> +    0xffff.
> +
> +.. _v4l2-hevc-profile:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG``
> +    (enum)
> +
> +enum v4l2_mpeg_video_hevc_tier_flag -
> +    TIER_FLAG specifies tier information of the HEVC encoded picture. Tier were
> +    made to deal with applications that differ in terms of maximum bit rate.
> +    Setting the flag to 0 selects HEVC tier_flag as Main tier and setting this
> +    flag to 1 indicates High tier. High tier is for very demanding applications

Demanding in terms of bit rate, i.e. requiring high bit rate? It's a bit
unclear here.

> +.. raw:: latex
> +
> +    \begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_HEVC_TIER_MAIN``
> +      - Main tier.
> +    * - ``V4L2_MPEG_VIDEO_HEVC_TIER_HIGH``
> +      - High tier.
> +
> +.. raw:: latex
> +
> +    \end{adjustbox}
> +
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH``
> +    Selects HEVC maximum coding unit depth.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF``
> +    Indicates loop filtering. Control ID 0 indicates loop filtering
> +    is enabled and when set to 1 indicates no filter.

"Setting this control to 0 enables loop filtering, setting this control
to 1 disables loop filtering." ?

Couldn't the meaning be inverted, so setting the control to 0 disables
the loop filtering?

> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY``
> +    Selects whether to apply the loop filter across the slice boundary or not.
> +    If the value is 0, loop filter will not be applied across the slice boundary.
> +    If the value is 1, loop filter will be applied across the slice boundary.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2``
> +    Selects HEVC loop filter beta offset. The valid range is [-6, +6].

> +    This could be a negative value in the 2's complement expression.

I don't think second sentence is needed.

> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2``
> +    Selects HEVC loop filter tc offset. The valid range is [-6, +6].

> +    This could be a negative value in the 2's complement expression.

Ditto.

> +.. _v4l2-hevc-refresh-type:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE``
> +    (enum)
> +
> +enum v4l2_mpeg_video_hevc_hier_refresh_type -
> +    Selects refresh type for HEVC encoder.
> +    Host has to specify the period into
> +    HEVC_REFRESH_PERIOD.
> +
> +.. raw:: latex
> +
> +    \begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE``
> +      - Use the B frame for hierarchical coding.
> +    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_CRA``
> +      - Use CRA(Clean Random Access Unit) picture encoding.
> +    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR``
> +      - Use IDR picture encoding.
> +
> +.. raw:: latex
> +
> +    \end{adjustbox}
> +
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD``
> +    Selects the refresh period for HEVC encoder.
> +    This specifies the number of I picture between two CRA/IDR pictures.
> +    This is valid only if REFRESH_TYPE is not 0.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU``
> +    Indicates HEVC lossless encoding. Setting it to 0 disables lossless
> +    encoding. Setting it to 1 enables lossless encoding.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED``
> +    Indicates constant intra prediction for HEVC encoder. Specifies the
> +    constrained intra prediction in which intra largest coding unit(LCU)
> +    prediction is performed by using residual data and decoded samples of
> +    neighboring intra LCU only. Setting it to 1 enables this control ID and
> +    setting it to 0 disables the control ID.

Could you avoid "disables the control ID", "enables control ID" phrases?
And instead describe indirectly what behaviour corresponds to each value of the 
control? So the last sentence becomes something like:

"Setting the control to 0 disables ..., setting the control to 1 enables..."

> +``V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT``
> +    Indicates wavefront parallel processing for HEVC encoder. Setting it to 0
> +    disables the control ID and setting it to 1 enables the wavefront parallel
> +    processing.

Ditto.

> +``V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING``
> +    Setting it to 1 indicates sign data hiding for HEVC encoder. Setting it to
> +    0 disables the control ID.

Ditto.

> +``V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB``
> +    Setting the control ID to 1 enables general picture buffers for HEVC

s/control ID/control/

> +    encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID``
> +    Indicates temporal identifier specified as temporal_id in
> +    nal_unit_header_svc_extension() for HEVC encoder which is enabled by

What is nal_unit_header_svc_extension(), where it comes from?

> +    setting the control ID to 1.

s/control ID/control/

> +``V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING``
> +    Indicates bi-linear interpolation is conditionally used in the intra
> +    prediction filtering process in the CVS when set to 1. Indicates bi-linear
> +    interpolation is not used in the CVS when set to 0.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1``
> +    Indicates max number of merge candidate motion vectors.

s/max/maximum/ ?

> +    Values are from zero to four.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT``
> +    Indicates intra prediction unit split for HEVC Encoder. Setting it to 1
> +    disables the feature. Setting it to 1 enables the feature.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION``
> +    Indicates temporal motion vector prediction for HEVC encoder. Setting it to
> +    0 enables the prediction. Setting it to 1 disables the prediction.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE``
> +    Specifies if HEVC generates a stream with a size of length field instead of
> +    start code pattern. The size of the length field is configurable among 1,2

s/the length/length/

> +    or 4 thorugh the SIZE_OF_LENGTH_FIELD. It is not applied at SEQ_START.

s/thorugh/through/
s/SIZE_OF_LENGTH_FIELD/V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD control.
I would also drop "among 1,2 or 4" as this information belongs to the
V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD control's description.

> +    Setting it to 0 disables the control ID. Setting it to 1 will enables
> +    the control ID.

Again, please specify explicitly what behaviour corresponds to each value
of the control.

> +``V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CR``
> +    Indicates the quantization parameter CR index.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CB``
> +    Indicates the quantization parameter CB index.
> +
> +.. _v4l2-hevc-size-of-length-field:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD``
> +(enum)
> +
> +enum v4l2_mpeg_video_hevc_size_of_length_field -
> +    Indicates the size of length field.
> +    This is valid when encoding WITHOUT_STARTCODE_ENABLE is enabled.
> +
> +.. raw:: latex
> +
> +    \begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
> +
> +.. flat-table::
> +       :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_0``
> +      - Generate start code pattern (Normal).
> +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_1``
> +      - Generate size of length field instead of start code pattern and length is 1.
> +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_2``
> +      - Generate size of length field instead of start code pattern and length is 2.
> +    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_4``
> +      - Generate size of length field instead of start code pattern and length is 4.
> +
> +.. raw:: latex
> +
> +    \end{adjustbox}
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER0_BITRATE``
> +    Indicates bit rate for hierarchical coding layer 0 for HEVC encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER1_BITRATE``
> +    Indicates bit rate for hierarchical coding layer 1 for HEVC encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER2_BITRATE``
> +    Indicates bit rate for hierarchical coding layer 2 for HEVC encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER3_BITRATE``
> +    Indicates bit rate for hierarchical coding layer 3 for HEVC encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER4_BITRATE``
> +    Indicates bit rate for hierarchical coding layer 4 for HEVC encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER5_BITRATE``
> +    Indicates bit rate for hierarchical coding layer 5 for HEVC encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER6_BITRATE``
> +    Indicates bit rate for hierarchical coding layer 6 for HEVC encoder.
> +
> +
> +MFC 10.10 MPEG Controls
> +-----------------------
> +
> +The following MPEG class controls deal with MPEG decoding and encoding
> +settings that are specific to the Multi Format Codec 10.10 device present
> +in the S5P family of SoCs by Samsung.

"S5P and Exynos" ?

> +
> +.. _mfc1010-control-id:
> +
> +MFC 10.10 Control IDs
> +^^^^^^^^^^^^^^^^^^^^^
> +
> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES``
> +    Selects number of P reference picture required for HEVC encoder.

s/picture/pictures
or s/picture/frames ?

> +    P-Frame can use 1 or 2 frames for reference.
> +
> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_ADAPTIVE_RC_DARK``
> +    Indicates HEVC dark region adaptive rate control.
> +
> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH``
> +    Indicates HEVC smooth region adaptive rate control.
> +
> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_ADAPTIVE_RC_STATIC``
> +    Indicates HEVC static region adaptive rate control.
> +
> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY``
> +    Indicates HEVC activity region adaptive rate control.

For the above controls it is not clear if these are boolean controls
and which value corresponds to what behaviour.

> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR``
> +    Indicates whether to generate SPS and PPS at every IDR. Setting it to 0
> +    disables it and setting it to one enables the feature.

"Setting the control to 0 disables generating SPS, PPS at every IDR,
  setting the control to 1 enables generating SPS, PPS at every IDR."


How about using MFC10 instead of MFC1010 for the controls IDs?

-- 
Regards,
Sylwester
