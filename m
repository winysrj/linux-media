Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:50896 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751842AbdDCMNB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 08:13:01 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ONU02NVP1XNV7C0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Apr 2017 21:12:59 +0900 (KST)
Subject: Re: [Patch v3 09/11] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-reply-to: <a664a1d2-6690-c9df-a1f8-c60dee1bbf90@xs4all.nl>
Date: Mon, 03 Apr 2017 17:45:05 +0530
Message-id: <1491221705.8493.102.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
 <CGME20170331090449epcas1p423d72119a1301e478e4b1b23d14cbac6@epcas1p4.samsung.com>
 <1490951200-32070-10-git-send-email-smitha.t@samsung.com>
 <a664a1d2-6690-c9df-a1f8-c60dee1bbf90@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-04-03 at 10:22 +0200, Hans Verkuil wrote:
> On 03/31/2017 11:06 AM, Smitha T Murthy wrote:
> > Add v4l2 controls for HEVC encoder
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ctrls.c | 103 +++++++++++++++++++++++++++
> >  include/uapi/linux/v4l2-controls.h   | 133 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 236 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index b9e08e3..5fa763b 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -479,6 +479,46 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> >  		NULL,
> >  	};
> >  
> > +	static const char * const hevc_profile[] = {
> > +		"Main",
> > +		"Main still picture",
> 
> All control and control menu names should follow the english capitalization rules for
> titles. So this should become "Main Still Picture".
> 
> Please adjust this in this patch.
> 
> Regards,
> 
> 	Hans
> 
I will correct this in the next version.
Thank you for the review.
Regards,
Smitha
> > +		NULL,
> > +	};
> > +	static const char * const hevc_level[] = {
> > +		"1",
> > +		"2",
> > +		"2.1",
> > +		"3",
> > +		"3.1",
> > +		"4",
> > +		"4.1",
> > +		"5",
> > +		"5.1",
> > +		"5.2",
> > +		"6",
> > +		"6.1",
> > +		"6.2",
> > +		NULL,
> > +	};
> > +	static const char * const hevc_hierarchial_coding_type[] = {
> > +		"B",
> > +		"P",
> > +		NULL,
> > +	};
> > +	static const char * const hevc_refresh_type[] = {
> > +		"None",
> > +		"CRA",
> > +		"IDR",
> > +		NULL,
> > +	};
> > +	static const char * const hevc_size_of_length_field[] = {
> > +		"0",
> > +		"1",
> > +		"2",
> > +		"4",
> > +		NULL,
> > +	};
> > +
> >  
> >  	switch (id) {
> >  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> > @@ -574,6 +614,16 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> >  		return dv_it_content_type;
> >  	case V4L2_CID_DETECT_MD_MODE:
> >  		return detect_md_mode;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> > +		return hevc_profile;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> > +		return hevc_level;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:
> > +		return hevc_hierarchial_coding_type;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
> > +		return hevc_refresh_type;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
> > +		return hevc_size_of_length_field;
> >  
> >  	default:
> >  		return NULL;
> > @@ -775,6 +825,54 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
> >  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
> >  
> > +	/* HEVC controls */
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC I frame QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:		return "HEVC P frame QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:		return "HEVC B frame QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:			return "HEVC Minimum QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:			return "HEVC Maximum QP value";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK:		return "HEVC Dark reg adaptive rc";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH:	return "HEVC Smooth reg adaptive rc";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC:	return "HEVC Static reg adaptive rc";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY:	return "HEVC activity reg adaptive rc";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:			return "HEVC Profile";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:			return "HEVC Level";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:		return "HEVC tier_flag";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION:	return "HEVC Frame rate resolution";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:	return "HEVC Maximum coding unit depth";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES:	return "HEVC Number of reference frames";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:		return "HEVC Refresh type";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED:		return "HEVC Constant intra prediction";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU:		return "HEVC Lossless encoding";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT:		return "HEVC Wavefront";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF:			return "HEVC Loop filter";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:	return "HEVC LF across slice boundary or not";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP:		return "HEVC QP values";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:	return "HEVC Hierarchical Coding Type";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER:return "HEVC Hierarchical Coding Layer";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP:return "HEVC Hierarchical Layer QP";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER0_BITRATE:return "HEVC Hierarchical Lay 0 bit rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER1_BITRATE:return "HEVC Hierarchical Lay 1 bit rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER2_BITRATE:return "HEVC Hierarchical Lay 2 bit rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER3_BITRATE:return "HEVC Hierarchical Lay 3 bit rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER4_BITRATE:return "HEVC Hierarchical Lay 4 bit rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER5_BITRATE:return "HEVC Hierarchical Lay 5 bit rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER6_BITRATE:return "HEVC Hierarchical Lay 6 bit rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH:return "HEVC Hierarchical Coding Layer Change";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING:		return "HEVC Sign data hiding";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB:		return "HEVC General pb";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID:		return "HEVC Temporal id";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING:		return "HEVC Strong intra smoothing";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT:		return "HEVC intra pu split";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION:		return "HEVC tmv prediction";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:	return "HEVC Max number of candidate MVs";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE:	return "HEVC ENC without startcode";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC num of I frame b/w 2 IDR";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC Loop filter beta offset";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC Loop filter tc offset";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of length field";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR:	return "HEVC Prepend SPS/PPS to IDR";
> > +
> >  	/* CAMERA controls */
> >  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
> >  	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> > @@ -1063,6 +1161,11 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
> >  	case V4L2_CID_TUNE_DEEMPHASIS:
> >  	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
> >  	case V4L2_CID_DETECT_MD_MODE:
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
> >  		*type = V4L2_CTRL_TYPE_MENU;
> >  		break;
> >  	case V4L2_CID_LINK_FREQ:
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > index 0d2e1e0..1f6502a 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -579,6 +579,139 @@ enum v4l2_vp8_golden_frame_sel {
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
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP \
> > +					(V4L2_CID_MPEG_BASE + 517)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE       \
> > +					(V4L2_CID_MPEG_BASE + 518)
> > +enum v4l2_mpeg_video_hevc_hier_coding_type {
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B	= 0,
> > +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P	= 1,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER      \
> > +					(V4L2_CID_MPEG_BASE + 519)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP   \
> > +					(V4L2_CID_MPEG_BASE + 520)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_PROFILE                        \
> > +					(V4L2_CID_MPEG_BASE + 521)
> > +enum v4l2_mpeg_video_hevc_profile {
> > +	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN = 0,
> > +	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE = 1,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LEVEL                          \
> > +					(V4L2_CID_MPEG_BASE + 522)
> > +enum v4l2_mpeg_video_hevc_level {
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_1	= 0,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_2	= 1,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1	= 2,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_3	= 3,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1	= 4,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_4	= 5,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1	= 6,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_5	= 7,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1	= 8,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2	= 9,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_6	= 10,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1	= 11,
> > +	V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2	= 12,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION    \
> > +					(V4L2_CID_MPEG_BASE + 523)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG                \
> > +					(V4L2_CID_MPEG_BASE + 524)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH      \
> > +					(V4L2_CID_MPEG_BASE + 525)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES   \
> > +					(V4L2_CID_MPEG_BASE + 526)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LF		          \
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
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU		  \
> > +					(V4L2_CID_MPEG_BASE + 533)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED	  \
> > +					(V4L2_CID_MPEG_BASE + 534)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT	          \
> > +					(V4L2_CID_MPEG_BASE + 535)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING         \
> > +					(V4L2_CID_MPEG_BASE + 536)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB	          \
> > +					(V4L2_CID_MPEG_BASE + 537)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID	          \
> > +					(V4L2_CID_MPEG_BASE + 538)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING	  \
> > +					(V4L2_CID_MPEG_BASE + 539)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1  \
> > +					(V4L2_CID_MPEG_BASE + 540)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK         \
> > +					(V4L2_CID_MPEG_BASE + 541)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH       \
> > +					(V4L2_CID_MPEG_BASE + 542)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC       \
> > +					(V4L2_CID_MPEG_BASE + 543)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY     \
> > +					(V4L2_CID_MPEG_BASE + 544)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT		  \
> > +					(V4L2_CID_MPEG_BASE + 545)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION		  \
> > +					(V4L2_CID_MPEG_BASE + 546)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE	  \
> > +					(V4L2_CID_MPEG_BASE + 547)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CR              \
> > +					(V4L2_CID_MPEG_BASE + 548)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CB              \
> > +					(V4L2_CID_MPEG_BASE + 549)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD     \
> > +					(V4L2_CID_MPEG_BASE + 550)
> > +enum v4l2_cid_mpeg_video_hevc_size_of_length_field {
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_0		= 0,
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_1		= 1,
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_2		= 2,
> > +	V4L2_MPEG_VIDEO_HEVC_SIZE_4		= 3,
> > +};
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR          \
> > +					(V4L2_CID_MPEG_BASE + 551)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH   \
> > +					(V4L2_CID_MPEG_BASE + 552)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER0_BITRATE \
> > +					(V4L2_CID_MPEG_BASE + 553)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER1_BITRATE \
> > +					(V4L2_CID_MPEG_BASE + 554)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER2_BITRATE \
> > +					(V4L2_CID_MPEG_BASE + 555)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER3_BITRATE \
> > +					(V4L2_CID_MPEG_BASE + 556)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER4_BITRATE \
> > +					(V4L2_CID_MPEG_BASE + 557)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER5_BITRATE \
> > +					(V4L2_CID_MPEG_BASE + 558)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER6_BITRATE \
> > +					(V4L2_CID_MPEG_BASE + 559)
> > +
> >  /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
> >  #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
> >  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
> > 
> 
> 
> 
