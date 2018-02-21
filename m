Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59149 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932556AbeBULp6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 06:45:58 -0500
Subject: Re: [PATCH] v4l2-compliance: Relax g/s_parm type check
To: Jacopo Mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org
References: <1519058764-30045-1-git-send-email-jacopo@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bf6f33d8-efed-29b1-47f0-426c1450910b@xs4all.nl>
Date: Wed, 21 Feb 2018 12:45:53 +0100
MIME-Version: 1.0
In-Reply-To: <1519058764-30045-1-git-send-email-jacopo@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

I've made a different implementation which is simpler. It's just been
committed.

Thanks for the report and suggested patch though!

Regards,

	Hans

On 02/19/18 17:46, Jacopo Mondi wrote:
> Since commit
> 
> commit 2e564ee56978874ddd4a8d061d37be088f130fd9
> Author: Hans Verkuil <hans.verkuil@cisco.com>
> 	vidioc-g-parm.rst: also allow _MPLANE buffer types
> 
> V4L2 allows _MPLANE buffer types for capture/output on s/g_parm
> operations.
> 
> Relax v4l2-compliance check to comply with this.
> 
> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
> ---
>  utils/v4l2-compliance/v4l2-test-formats.cpp | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
> index b7a32fe..25c4da5 100644
> --- a/utils/v4l2-compliance/v4l2-test-formats.cpp
> +++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
> @@ -1235,9 +1235,20 @@ int testParm(struct node *node)
>  			    type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
>  			    type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  				return fail("G/S_PARM is only allowed for video capture/output\n");
> -			if (!(node->g_caps() & buftype2cap[type]))
> -				return fail("%s cap not set, but G/S_PARM worked\n",
> -						buftype2s(type).c_str());
> +
> +			if (!((node->g_caps() & V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +					node->g_caps() & V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)) &&
> +					((buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +					buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)))
> +						return fail("%s cap not set, but G/S_PARM worked\n",
> +								buftype2s(type).c_str());
> +
> +			if (!((node->g_caps() & V4L2_BUF_TYPE_VIDEO_OUTPUT ||
> +					node->g_caps() & V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)) &&
> +					((buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_OUTPUT ||
> +					buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)))
> +						return fail("%s cap not set, but G/S_PARM worked\n",
> +								buftype2s(type).c_str());
>  		}
>  	}
> 
> --
> 2.7.4
> 
