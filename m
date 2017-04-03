Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:40193 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdDCGPa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 02:15:30 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ONT02C07LDSY1B0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Apr 2017 15:15:28 +0900 (KST)
Subject: Re: [Patch v3 10/11] [media] s5p-mfc: Add support for HEVC encoder
 (fwd)
From: Smitha T Murthy <smitha.t@samsung.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@01.org
In-reply-to: <alpine.DEB.2.20.1704030758540.2170@hadrien>
Date: Mon, 03 Apr 2017 11:47:22 +0530
Message-id: <1491200242.24095.23.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <CGME20170403060045epcas2p215a1d85248b47cc389e20ff877505b09@epcas2p2.samsung.com>
 <alpine.DEB.2.20.1704030758540.2170@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-04-03 at 08:00 +0200, Julia Lawall wrote:
> See line 2101
> 
> julia
> 
Thank you for bringing it to my notice, I had not checked on this git.
I will upload the next version of patches soon corresponding to this
git.

Thanks,
Smitha
> --------- Forwarded message ----------
> Date: Mon, 3 Apr 2017 05:04:39 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> To: kbuild@01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: Re: [Patch v3 10/11] [media] s5p-mfc: Add support for HEVC encoder
> 
> Hi Smitha,
> 
> [auto build test WARNING on linuxtv-media/master]
> [also build test WARNING on v4.11-rc4 next-20170331]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Smitha-T-Murthy/Add-MFC-v10-10-support/20170403-033620
> base:   git://linuxtv.org/media_tree.git master
> :::::: branch date: 88 minutes ago
> :::::: commit date: 88 minutes ago
> 
> >> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:2101:6-25: WARNING: Unsigned expression compared with zero: p -> codec . hevc . level < 0
> 
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout bca072db65317d79554527391338ce8bc6fbde58
> vim +2101 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> 
> bca072db Smitha T Murthy 2017-03-31  2085  		break;
> bca072db Smitha T Murthy 2017-03-31  2086  	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:
> bca072db Smitha T Murthy 2017-03-31  2087  		p->codec.hevc.rc_b_frame_qp = ctrl->val;
> bca072db Smitha T Murthy 2017-03-31  2088  		break;
> bca072db Smitha T Murthy 2017-03-31  2089  	case V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION:
> bca072db Smitha T Murthy 2017-03-31  2090  		p->codec.hevc.rc_framerate = ctrl->val;
> bca072db Smitha T Murthy 2017-03-31  2091  		break;
> bca072db Smitha T Murthy 2017-03-31  2092  	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:
> bca072db Smitha T Murthy 2017-03-31  2093  		p->codec.hevc.rc_min_qp = ctrl->val;
> bca072db Smitha T Murthy 2017-03-31  2094  		break;
> bca072db Smitha T Murthy 2017-03-31  2095  	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:
> bca072db Smitha T Murthy 2017-03-31  2096  		p->codec.hevc.rc_max_qp = ctrl->val;
> bca072db Smitha T Murthy 2017-03-31  2097  		break;
> bca072db Smitha T Murthy 2017-03-31  2098  	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> bca072db Smitha T Murthy 2017-03-31  2099  		p->codec.hevc.level_v4l2 = ctrl->val;
> bca072db Smitha T Murthy 2017-03-31  2100  		p->codec.hevc.level = hevc_level(ctrl->val);
> bca072db Smitha T Murthy 2017-03-31 @2101  		if (p->codec.hevc.level < 0) {
> bca072db Smitha T Murthy 2017-03-31  2102  			mfc_err("Level number is wrong\n");
> bca072db Smitha T Murthy 2017-03-31  2103  			ret = p->codec.hevc.level;
> bca072db Smitha T Murthy 2017-03-31  2104  		}
> bca072db Smitha T Murthy 2017-03-31  2105  		break;
> bca072db Smitha T Murthy 2017-03-31  2106  	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> bca072db Smitha T Murthy 2017-03-31  2107  		switch (ctrl->val) {
> bca072db Smitha T Murthy 2017-03-31  2108  		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN:
> bca072db Smitha T Murthy 2017-03-31  2109  			ctrl->val = V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN;
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
> 
