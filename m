Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:38938 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdCNLhB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 07:37:01 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OMS0277AYXN1X80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Mar 2017 20:36:59 +0900 (KST)
Subject: Re: [Patch v2 09/11] v4l2: Add v4l2 control IDs for HEVC encoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-reply-to: <0b93b507-ae3b-f580-7c31-ddf814e0f27b@samsung.com>
Date: Tue, 14 Mar 2017 17:09:00 +0530
Message-id: <1489491540.27807.140.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090508epcas1p2ff5f5849d680c3558c564e77444fce53@epcas1p2.samsung.com>
 <1488532036-13044-10-git-send-email-smitha.t@samsung.com>
 <0b93b507-ae3b-f580-7c31-ddf814e0f27b@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-03-07 at 09:48 +0100, Andrzej Hajda wrote: 
> On 03.03.2017 10:07, Smitha T Murthy wrote:
> > Add v4l2 controls for HEVC encoder
> >
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ctrls.c |   51 +++++++++++++
> >  include/uapi/linux/v4l2-controls.h   |  129 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 180 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index 47001e2..b3ec7a3 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -775,6 +775,57 @@ static bool is_new_manual(const struct v4l2_ctrl *master)
> >  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
> >  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
> >  
> > +	/* HEVC controls */
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC I frame QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:		return "HEVC P frame QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:		return "HEVC B frame QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:			return "HEVC Minimum QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:			return "HEVC Maximum QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK:		return "HEVC Dark region adaptive";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH:	return "HEVC Smooth region adaptive";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC:	return "HEVC Static region adaptive";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY:	return "HEVC Region adaptive rate control";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:			return "HEVC Profile";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:			return "HEVC Level";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:		return "HEVC tier_flag default is Main";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE:		return "HEVC Frame rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:	return "HEVC Maximum coding unit depth";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES:	return "HEVC Number of reference frames for P Frames";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:		return "HEVC Refresh type";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE:	return "HEVC Constant intra prediction enable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE:	return "HEVC Lossless encoding enable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE:		return "HEVC Wavefront enable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE:		return "HEVC Loop filter disable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:	return "HEVC Loop filtering across slice boundary or not";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE:		return "HEVC long term reference enable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP_ENABLE:	return "HEVC QP values for temporal layer";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:	return "HEVC Hierarchical Coding Type";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER:return "HEVC Hierarchical Coding Layer";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP:return "HEVC Hierarchical Coding Layer QP";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT0:return "HEVC Hierarchical Coding Layer BIT0";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT1:return "HEVC Hierarchical Coding Layer BIT1";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT2:return "HEVC Hierarchical Coding Layer BIT2";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT3:return "HEVC Hierarchical Coding Layer BIT3";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT4:return "HEVC Hierarchical Coding Layer BIT4";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT5:return "HEVC Hierarchical Coding Layer BIT5";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT6:return "HEVC Hierarchical Coding Layer BIT6";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH:return "HEVC Hierarchical Coding Layer Change";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING:		return "HEVC Sign data hiding";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB_ENABLE:	return "HEVC General pb enable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID_ENABLE:	return "HEVC Temporal id enable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOTHING_FLAG:	return "HEVC Strong intra smoothing flag";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_INTRA_PU_SPLIT:	return "HEVC Disable intra pu split";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_TMV_PREDICTION:	return "HEVC Disable tmv prediction";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:	return "HEVC Max number of candidate MVs";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE_ENABLE:	return "HEVC ENC without startcode enable";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC Number of reference picture";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC Loop filter beta offset";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC Loop filter tc offset";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of length field";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_USE_REF:			return "HEVC User long term reference frame";
> 
> s/User/Use/
> 
> As I said previously I am not HEVC expert, it would be good if someone
> with better skills look at it.
> >From my side after fixing typo above you can add:
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> 
> Regards
> Andrzej
> 
I will correct it. Thank you so much for the review.
Regards,
Smitha T Murthy 
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_STORE_REF:		return "HEVC Store long term reference frame";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR:	return "HEVC Prepend SPS/PPS to every IDR";
> > +
> >  	/* CAMERA controls */
> >  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
> >  	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > index 0d2e1e0..11a13c3 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -579,6 +579,135 @@ enum v4l2_vp8_golden_frame_sel {
> >  #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
> >  #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
> >  
> > +/* CIDs for HEVC encoding. Number gaps are for compatibility */
> > +
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP                         \
> > +					(V4L2_CID_MPEG_BASE + 512)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP                         \
> > +					(V4L2_CID_MPEG_BASE + 513)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP                     \
> > +					(V4L2_CID_MPEG_BASE + 514)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP                     \
> > +					(V4L2_CID_MPEG_BASE + 515)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP                     \
> > +					(V4L2_CID_MPEG_BASE + 516)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP_ENABLE \
> > +					(V4L2_CID_MPEG_BASE + 517)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE       \
> > +					(V4L2_CID_MPEG_BASE + 518)
> > +enum v4l2_mpeg_video_hevc_hier_coding_type {
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B	= 0,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P	= 1,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER      \
> > +					(V4L2_CID_MPEG_BASE + 519)
> > +enum v4l2_mpeg_video_hevc_hierarchial_coding_layer {
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER0	= 0,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER1	= 1,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER2	= 2,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER3	= 3,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER4	= 4,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER5	= 5,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER6	= 6,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP   \
> > +					(V4L2_CID_MPEG_BASE + 520)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_PROFILE                        \
> > +					(V4L2_CID_MPEG_BASE + 521)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LEVEL                          \
> > +					(V4L2_CID_MPEG_BASE + 522)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE            \
> > +					(V4L2_CID_MPEG_BASE + 523)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG                \
> > +					(V4L2_CID_MPEG_BASE + 524)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH      \
> > +					(V4L2_CID_MPEG_BASE + 525)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES   \
> > +					(V4L2_CID_MPEG_BASE + 526)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE               \
> > +					(V4L2_CID_MPEG_BASE + 527)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY        \
> > +					(V4L2_CID_MPEG_BASE + 528)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2      \
> > +					(V4L2_CID_MPEG_BASE + 529)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2        \
> > +					(V4L2_CID_MPEG_BASE + 530)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE             \
> > +					(V4L2_CID_MPEG_BASE + 531)
> > +enum v4l2_cid_mpeg_video_hevc_refresh_type {
> > +	V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE		= 0,
> > +	V4L2_MPEG_VIDEO_HEVC_REFRESH_CRA		= 1,
> > +	V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR		= 2,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD           \
> > +					(V4L2_CID_MPEG_BASE + 532)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE       \
> > +					(V4L2_CID_MPEG_BASE + 533)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE  \
> > +					(V4L2_CID_MPEG_BASE + 534)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE         \
> > +					(V4L2_CID_MPEG_BASE + 535)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE               \
> > +					(V4L2_CID_MPEG_BASE + 536)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_USE_REF                  \
> > +					(V4L2_CID_MPEG_BASE + 537)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_STORE_REF                \
> > +					(V4L2_CID_MPEG_BASE + 538)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING         \
> > +					(V4L2_CID_MPEG_BASE + 539)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB_ENABLE        \
> > +					(V4L2_CID_MPEG_BASE + 540)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID_ENABLE       \
> > +					(V4L2_CID_MPEG_BASE + 541)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOTHING_FLAG     \
> > +					(V4L2_CID_MPEG_BASE + 542)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1  \
> > +					(V4L2_CID_MPEG_BASE + 543)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK         \
> > +					(V4L2_CID_MPEG_BASE + 544)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH       \
> > +					(V4L2_CID_MPEG_BASE + 545)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC       \
> > +					(V4L2_CID_MPEG_BASE + 546)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY     \
> > +					(V4L2_CID_MPEG_BASE + 547)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_INTRA_PU_SPLIT   \
> > +					(V4L2_CID_MPEG_BASE + 548)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_TMV_PREDICTION   \
> > +					(V4L2_CID_MPEG_BASE + 549)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE_ENABLE \
> > +					(V4L2_CID_MPEG_BASE + 550)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CR              \
> > +					(V4L2_CID_MPEG_BASE + 551)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CB              \
> > +					(V4L2_CID_MPEG_BASE + 552)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD     \
> > +					(V4L2_CID_MPEG_BASE + 553)
> > +enum v4l2_cid_mpeg_video_hevc_size_of_length_field {
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_0		= 0,
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_1		= 1,
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_2		= 2,
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_4		= 3,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR          \
> > +					(V4L2_CID_MPEG_BASE + 554)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH   \
> > +					(V4L2_CID_MPEG_BASE + 555)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT0 \
> > +					(V4L2_CID_MPEG_BASE + 556)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT1 \
> > +					(V4L2_CID_MPEG_BASE + 557)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT2 \
> > +					(V4L2_CID_MPEG_BASE + 558)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT3 \
> > +					(V4L2_CID_MPEG_BASE + 559)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT4 \
> > +					(V4L2_CID_MPEG_BASE + 560)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT5 \
> > +					(V4L2_CID_MPEG_BASE + 561)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT6 \
> > +					(V4L2_CID_MPEG_BASE + 562)
> > +
> >  /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
> >  #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
> >  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
> 
> 
> 
