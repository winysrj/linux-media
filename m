Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51016 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdDFNPL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 09:15:11 -0400
Subject: Re: [Patch v4 10/12] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
To: Smitha T Murthy <smitha.t@samsung.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        a.hajda@samsung.com, pankaj.dubey@samsung.com, kamil@wypas.org,
        krzk@kernel.org, jtp.park@samsung.com, kyungmin.park@samsung.com,
        mchehab@kernel.org, m.szyprowski@samsung.com
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <374939c7-241a-fcca-c87e-5c4290bdb6aa@samsung.com>
Date: Thu, 06 Apr 2017 15:14:51 +0200
MIME-version: 1.0
In-reply-to: <1491459105-16641-11-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061023epcas5p2a3fa65c4254e17a58f71c68d413e6bfd@epcas5p2.samsung.com>
 <1491459105-16641-11-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/2017 08:11 AM, Smitha T Murthy wrote:
> @@ -775,6 +832,47 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
>  
> +	/* HEVC controls */
[...]
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:	return "HEVC LF Across Slice Boundary or Not";

Please make sure the names are no longer than 31 characters to avoid
truncation during control enumeration in user space.
Data structures like struct v4l2_queryctrl, struct v4l2_query_ext_ctrl
have only 32 bytes long array dedicated for the control name.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP:		return "HEVC QP Values";

> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:	return "HEVC Hierarchical Coding Type";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER:return "HEVC Hierarchical Coding Layer";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP:return "HEVC Hierarchical Layer QP";

How about s/HIERARCHICAL_/HIER_ for the above 3 control IDs?

> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER0_BITRATE:return "HEVC Hierarchical Lay 0 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER1_BITRATE:return "HEVC Hierarchical Lay 1 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER2_BITRATE:return "HEVC Hierarchical Lay 2 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER3_BITRATE:return "HEVC Hierarchical Lay 3 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER4_BITRATE:return "HEVC Hierarchical Lay 4 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER5_BITRATE:return "HEVC Hierarchical Lay 5 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER6_BITRATE:return "HEVC Hierarchical Lay 6 Bit Rate";

Using single letter L instead of LAYER would make the control ID shorter
and more consistent with existing controls, e.g. 
V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BITRATE.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING:		return "HEVC Sign Data Hiding";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB:		return "HEVC General PB";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID:		return "HEVC Temporal ID";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING:		return "HEVC Strong Intra Smoothing";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT:		return "HEVC Intra PU Split";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION:		return "HEVC TMV Prediction";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:	return "HEVC Max Number of Candidate MVs";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE:	return "HEVC ENC Without Startcode";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC Num of I Frame b/w 2 IDR";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC Loop Filter Beta Offset";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC Loop Filter tc Offset";

s/tc/Tc or s/tc/TC ?

> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of Length Field";

--
Thanks,
Sylwester
