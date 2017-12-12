Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:29021 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdLLJrP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 04:47:15 -0500
Subject: Re: [Patch v6 10/12] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
To: Smitha T Murthy <smitha.t@samsung.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <10a80dd4-737d-2c96-1679-3b04cfc45a5d@samsung.com>
Date: Tue, 12 Dec 2017 10:46:46 +0100
MIME-version: 1.0
In-reply-to: <1513046086.22129.2.camel@smitha-fedora>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
        <CGME20171208093702epcas2p32a30a9f624e06fb543f7dd757c805077@epcas2p3.samsung.com>
        <1512724105-1778-11-git-send-email-smitha.t@samsung.com>
        <5b96b332-71a9-083a-2242-8bdf5554f010@linaro.org>
        <1513046086.22129.2.camel@smitha-fedora>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2017 03:34 AM, Smitha T Murthy wrote:
>> s/Lay/Layer here and below
>>
> Ok I will change it.

While it's fine to make such change for controls up to V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP...

>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP:	return "HEVC Hierarchical Lay 1 QP";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP:	return "HEVC Hierarchical Lay 2 QP";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP:	return "HEVC Hierarchical Lay 3 QP";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP:	return "HEVC Hierarchical Lay 4 QP";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP:	return "HEVC Hierarchical Lay 5 QP";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP:	return "HEVC Hierarchical Lay 6 QP";

...for the controls below we may need to replace "Lay" with "L." 
to make sure the length of the string don't exceed 31 characters 
(32 with terminating NULL). The names below seem to be 1 character 
too long and will be truncated when running VIDIOC_QUERY_CTRL ioctl.

>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR:	return "HEVC Hierarchical Lay 0 Bit Rate";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR:	return "HEVC Hierarchical Lay 1 Bit Rate";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR:	return "HEVC Hierarchical Lay 2 Bit Rate";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR:	return "HEVC Hierarchical Lay 3 Bit Rate";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR:	return "HEVC Hierarchical Lay 4 Bit Rate";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR:	return "HEVC Hierarchical Lay 5 Bit Rate";
>>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR:	return "HEVC Hierarchical Lay 6 Bit Rate";

--
Regards,
Sylwester
