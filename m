Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55846 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756593AbdDGJwt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 05:52:49 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OO102M59A3YJUD0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Apr 2017 18:52:46 +0900 (KST)
Subject: Re: [Patch v4 10/12] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, a.hajda@samsung.com,
        pankaj.dubey@samsung.com, kamil@wypas.org, krzk@kernel.org,
        jtp.park@samsung.com, kyungmin.park@samsung.com,
        mchehab@kernel.org, m.szyprowski@samsung.com
In-reply-to: <9f81ed3a-4adb-7827-6094-88847bc0787a@samsung.com>
Date: Fri, 07 Apr 2017 15:24:26 +0530
Message-id: <1491558866.15698.1227.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061023epcas5p2a3fa65c4254e17a58f71c68d413e6bfd@epcas5p2.samsung.com>
 <1491459105-16641-11-git-send-email-smitha.t@samsung.com>
 <374939c7-241a-fcca-c87e-5c4290bdb6aa@samsung.com>
 <1491553894.15698.1142.camel@smitha-fedora>
 <9f81ed3a-4adb-7827-6094-88847bc0787a@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-04-07 at 11:25 +0200, Sylwester Nawrocki wrote:
> On 04/07/2017 10:31 AM, Smitha T Murthy wrote:
> > On Thu, 2017-04-06 at 15:14 +0200, Sylwester Nawrocki wrote:
> >> On 04/06/2017 08:11 AM, Smitha T Murthy wrote:
> >>> @@ -775,6 +832,47 @@ const char *v4l2_ctrl_get_name(u32 id)
> >>>  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
> >>>  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
> >>>
> >>> +	/* HEVC controls */
> >> [...]
> >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:	return "HEVC LF Across Slice Boundary or Not";
> >> Please make sure the names are no longer than 31 characters to avoid
> >> truncation during control enumeration in user space.
> >> Data structures like struct v4l2_queryctrl, struct v4l2_query_ext_ctrl
> >> have only 32 bytes long array dedicated for the control name.
>  >
> > I will try to make the names less than 31 characters long without losing
> > the context. But there are many control names in this file which are
> > longer than 31 characters like
> > V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP,
> > V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD etc so I assumed it was
> > alright to have such long names. But I will shorten them as per your
> > suggestion.
> 
> Apologies if it wasn't clean enough but my comment referred to the
> length of the character string being returned (e.g. "HEVC LF Across
> Slice Boundary or Not") and not to the name of the enum.
> 
> --
> Regards,
> Sylwester
> 
Sorry I misunderstood I will take care of it in the next version.

Thank you,
Smitha
