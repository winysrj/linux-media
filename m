Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52866 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934704AbdDFNeD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 09:34:03 -0400
Subject: Re: [Patch v4 12/12] Documention: v4l: Documentation for HEVC CIDs
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061027epcas5p2628e0a8e0fd76e2e267fad3ea1209f65@epcas5p2.samsung.com>
 <1491459105-16641-13-git-send-email-smitha.t@samsung.com>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fd79a716-8acb-f119-5c78-89c02ce14cfb@xs4all.nl>
Date: Thu, 6 Apr 2017 15:33:50 +0200
MIME-Version: 1.0
In-Reply-To: <1491459105-16641-13-git-send-email-smitha.t@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/2017 08:11 AM, Smitha T Murthy wrote:
> Added V4l2 controls for HEVC encoder
> 
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>

General comment: don't forget to build the pdf and check that as well.

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
> +---------------------
> +
> +The HEVC controls include controls for encoding parameters of HEVC video
> +codec.
> +
> +
> +.. _hevc-control-id:
> +
> +HEVC Control IDs
> +^^^^^^^^^^^^^^^
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP``

You need to add the type of the control in parenthesis. It is probably '(integer)'
for this one. Just follow what is done for other controls.

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

So "one modulo time" == "one second"? Perhaps just say that instead?

> +    0xffff.
> +
> +.. _v4l2-hevc-profile:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG``
> +    (enum)
> +
> +enum v4l2_mpeg_video_hevc_tier_flag -
> +    TIER_FLAG specifies tier information of the HEVC encoded picture. Tier were

s/Tier/Tiers/

> +    made to deal with applications that differ in terms of maximum bit rate.
> +    Setting the flag to 0 selects HEVC tier_flag as Main tier and setting this
> +    flag to 1 indicates High tier. High tier is for very demanding applications
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

s/ID/value/

> +    is enabled and when set to 1 indicates no filter.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY``
> +    Selects whether to apply the loop filter across the slice boundary or not.
> +    If the value is 0, loop filter will not be applied across the slice boundary.
> +    If the value is 1, loop filter will be applied across the slice boundary.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2``
> +    Selects HEVC loop filter beta offset. The valid range is [-6, +6].
> +    This could be a negative value in the 2's complement expression.

I'd drop this last line. The range you specify already indicates that it can
be negative.

> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2``
> +    Selects HEVC loop filter tc offset. The valid range is [-6, +6].
> +    This could be a negative value in the 2's complement expression.

Ditto.

> +
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

Add space after CRA.

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

s/I picture/I pictures/

> +    This is valid only if REFRESH_TYPE is not 0.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU``
> +    Indicates HEVC lossless encoding. Setting it to 0 disables lossless
> +    encoding. Setting it to 1 enables lossless encoding.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED``
> +    Indicates constant intra prediction for HEVC encoder. Specifies the
> +    constrained intra prediction in which intra largest coding unit(LCU)

Space before (LCU)

> +    prediction is performed by using residual data and decoded samples of
> +    neighboring intra LCU only. Setting it to 1 enables this control ID and
> +    setting it to 0 disables the control ID.

s/control ID/feature/

> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT``
> +    Indicates wavefront parallel processing for HEVC encoder. Setting it to 0
> +    disables the control ID and setting it to 1 enables the wavefront parallel
> +    processing.

Ditto. Please check this document for more mis-use of the term "control ID", I won't
comment on this anymore.

> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING``
> +    Setting it to 1 indicates sign data hiding for HEVC encoder. Setting it to
> +    0 disables the control ID.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB``
> +    Setting the control ID to 1 enables general picture buffers for HEVC
> +    encoder.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID``
> +    Indicates temporal identifier specified as temporal_id in
> +    nal_unit_header_svc_extension() for HEVC encoder which is enabled by
> +    setting the control ID to 1.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING``
> +    Indicates bi-linear interpolation is conditionally used in the intra
> +    prediction filtering process in the CVS when set to 1. Indicates bi-linear
> +    interpolation is not used in the CVS when set to 0.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1``
> +    Indicates max number of merge candidate motion vectors.
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
> +    or 4 thorugh the SIZE_OF_LENGTH_FIELD. It is not applied at SEQ_START.
> +    Setting it to 0 disables the control ID. Setting it to 1 will enables
> +    the control ID.
> +
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
> +
> +
> +.. _mfc1010-control-id:
> +
> +MFC 10.10 Control IDs
> +^^^^^^^^^^^^^^^^^^^^^
> +
> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES``
> +    Selects number of P reference picture required for HEVC encoder.
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
> +
> +``V4L2_CID_MPEG_MFC1010_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR``
> +    Indicates whether to generate SPS and PPS at every IDR. Setting it to 0
> +    disables it and setting it to one enables the feature.
> +
> +
>  .. _camera-controls:
>  
>  Camera Control Reference
> 

Regards,

	Hans
