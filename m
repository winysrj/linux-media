Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:34706 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754291AbdDGI3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 04:29:47 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OO102K8169LQ750@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Apr 2017 17:29:45 +0900 (KST)
Subject: Re: [Patch v4 10/12] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, a.hajda@samsung.com,
        pankaj.dubey@samsung.com, kamil@wypas.org, krzk@kernel.org,
        jtp.park@samsung.com, kyungmin.park@samsung.com,
        mchehab@kernel.org, m.szyprowski@samsung.com
In-reply-to: <374939c7-241a-fcca-c87e-5c4290bdb6aa@samsung.com>
Date: Fri, 07 Apr 2017 14:01:34 +0530
Message-id: <1491553894.15698.1142.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061023epcas5p2a3fa65c4254e17a58f71c68d413e6bfd@epcas5p2.samsung.com>
 <1491459105-16641-11-git-send-email-smitha.t@samsung.com>
 <374939c7-241a-fcca-c87e-5c4290bdb6aa@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-04-06 at 15:14 +0200, Sylwester Nawrocki wrote:
> On 04/06/2017 08:11 AM, Smitha T Murthy wrote:
> > @@ -775,6 +832,47 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
> >  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
> >  
> > +	/* HEVC controls */
> [...]
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:	return "HEVC LF Across Slice Boundary or Not";
> 
> Please make sure the names are no longer than 31 characters to avoid
> truncation during control enumeration in user space.
> Data structures like struct v4l2_queryctrl, struct v4l2_query_ext_ctrl
> have only 32 bytes long array dedicated for the control name.

I will try to make the names less than 31 characters long without losing
the context. But there are many control names in this file which are
longer than 31 characters like
V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP,
V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD etc so I assumed it was
alright to have such long names. But I will shorten them as per your
suggestion.

> 
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP:		return "HEVC QP Values";
> 
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:	return "HEVC Hierarchical Coding Type";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER:return "HEVC Hierarchical Coding Layer";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP:return "HEVC Hierarchical Layer QP";
> 
> How about s/HIERARCHICAL_/HIER_ for the above 3 control IDs?
> 
Ok I will change it.

> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER0_BITRATE:return "HEVC Hierarchical Lay 0 Bit Rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER1_BITRATE:return "HEVC Hierarchical Lay 1 Bit Rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER2_BITRATE:return "HEVC Hierarchical Lay 2 Bit Rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER3_BITRATE:return "HEVC Hierarchical Lay 3 Bit Rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER4_BITRATE:return "HEVC Hierarchical Lay 4 Bit Rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER5_BITRATE:return "HEVC Hierarchical Lay 5 Bit Rate";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER6_BITRATE:return "HEVC Hierarchical Lay 6 Bit Rate";
> 
> Using single letter L instead of LAYER would make the control ID shorter
> and more consistent with existing controls, e.g. 
> V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BITRATE.
> 
Ok I will change it.

> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING:		return "HEVC Sign Data Hiding";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB:		return "HEVC General PB";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID:		return "HEVC Temporal ID";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING:		return "HEVC Strong Intra Smoothing";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT:		return "HEVC Intra PU Split";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION:		return "HEVC TMV Prediction";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:	return "HEVC Max Number of Candidate MVs";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE:	return "HEVC ENC Without Startcode";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC Num of I Frame b/w 2 IDR";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC Loop Filter Beta Offset";
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC Loop Filter tc Offset";
> 
> s/tc/Tc or s/tc/TC ?
> 
I will correct it.
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of Length Field";
> 
> --
> Thanks,
> Sylwester
> 
Thank you for the review.

Regards,
Smitha
