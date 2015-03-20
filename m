Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51140 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbbCTLaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 07:30:12 -0400
Message-ID: <550C04BD.9030503@xs4all.nl>
Date: Fri, 20 Mar 2015 12:30:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] v4l2-ctl: Add support for CVT, GTF modeline calculation
References: <1426833213-7777-1-git-send-email-prladdha@cisco.com> <1426833213-7777-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1426833213-7777-2-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prashant,

Thanks for the patch, but I have one small comment:

On 03/20/2015 07:33 AM, Prashant Laddha wrote:
> This patch adds support for calculating v4l2_bt_timings based on
> CVT and GTF standards. The timings are calculated for a given
> standard, CVT or GTF using a set of parameters- width, height,
> refresh rate and flags like whether it is an interlaced format,
> and whether to use reduced blanking.
> 
> CVT Modeline calculation -
> Implements Coordinated Video Timings (CVT) Standard Ver 1.2 Feb 08,
> 2013. The timing calculations are based on VESA CVT Generator Rev 1.2
> by Graham Loveridge May 28, 2013.
> 
> GTF modeline calculation -
> Implements Generalized Timing Formula (GTF) Standard Ver 1.1 Sept 02,
> 1999. The timing calculations are based on GTF timing spreadsheet by
> Andy Morrish. The default GTF timings are used if flag for reduced
> blanking is false, otherwise secondary GTF timings are used.
> 
> Suggested by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
> ---
>  utils/v4l2-ctl/Makefile.am        |   3 +-
>  utils/v4l2-ctl/v4l2-ctl-modes.cpp | 512 ++++++++++++++++++++++++++++++++++++++
>  utils/v4l2-ctl/v4l2-ctl.h         |   8 +
>  3 files changed, 522 insertions(+), 1 deletion(-)
>  create mode 100644 utils/v4l2-ctl/v4l2-ctl-modes.cpp
> 

> diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
> new file mode 100644
> index 0000000..5157fea
> --- /dev/null
> +++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp

<snip>

> +	if (cvt->interlaced == V4L2_DV_INTERLACED) {
> +		cvt->il_vfrontporch = v_fp;
> +		cvt->il_vsync = v_sync;
> +		cvt->il_vbackporch = v_bp;
> +		/* For interlaced format, add half lines to front and back
> +		 * porches of odd and even fields respectively */
> +		cvt->flags |= V4L2_DV_FL_HALF_LINE;
> +		cvt->vfrontporch += 1;
> +		cvt->il_vbackporch += 1;

This isn't right, you should do the +1 only for the il_vbackporch. Otherwise
V4L2_DV_BT_FRAME_HEIGHT(bt) would be one too big.

The HALF_LINE flag means that, if drivers support it, they can add a half-line
to the vfrontporch of the odd field and subtract a half-line for the vbackporch
of the even field.

BTW, the V4L2_DV_FL_HALF_LINE documentation in the spec should be improved to
state the above. Right now it doesn't specify to which porch the half-lines go.

This same bug is in the detect_gtf function.

Regards,

	Hans
