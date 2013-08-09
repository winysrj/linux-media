Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50858 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966223Ab3HIKSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 06:18:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: s5c73m3: Add format propagation for TRY formats
Date: Fri, 09 Aug 2013 12:19:36 +0200
Message-ID: <6649975.HfKdDgB88q@avalon>
In-Reply-To: <52048B0A.7010700@samsung.com>
References: <1374677852-2006-1-git-send-email-s.nawrocki@samsung.com> <3766107.LzC3gBYZDo@avalon> <52048B0A.7010700@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On Friday 09 August 2013 08:24:10 Andrzej Hajda wrote:
> On 08/09/2013 12:58 AM, Laurent Pinchart wrote:
> > On Wednesday 24 July 2013 16:57:32 Sylwester Nawrocki wrote:
> >> From: Andrzej Hajda <a.hajda@samsung.com>
> >> 
> >> Resolution set on ISP pad of S5C73M3-OIF subdev should be
> >> propagated to source pad for TRY and ACTIVE formats.
> >> The patch adds missing propagation for TRY format.
> > 
> > I might be missing something, but where's the propagation for the ACTIVE
> > format ?
> 
> In case of active format there are no separate containers
> for the format of each pad, instead they shares common fields,
> precisely .oif_pix_size and .mbus_code.
> This way there is no need for extra code for format propagation.

I got confused by the s5c73m3_oif_get_fmt() implementation that retrieves the 
pixel code and frame size from different internal state fields for the soruce 
pad. The code looks correct.

> >> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> ---
> >> 
> >>  drivers/media/i2c/s5c73m3/s5c73m3-core.c |    5 +++++
> >>  1 file changed, 5 insertions(+)
> >> 
> >> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> >> b/drivers/media/i2c/s5c73m3/s5c73m3-core.c index 825ea86..b76ec0e 100644
> >> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> >> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> >> @@ -1111,6 +1111,11 @@ static int s5c73m3_oif_set_fmt(struct v4l2_subdev
> >> *sd, if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> >> 
> >>  		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
> >>  		*mf = fmt->format;
> >> 
> >> +		if (fmt->pad == OIF_ISP_PAD) {
> >> +			mf = v4l2_subdev_get_try_format(fh, OIF_SOURCE_PAD);
> >> +			mf->width = fmt->format.width;
> >> +			mf->height = fmt->format.height;
> >> +		}
> >> 
> >>  	} else {
> >>  	
> >>  		switch (fmt->pad) {
> >>  		case OIF_ISP_PAD:
-- 
Regards,

Laurent Pinchart

