Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58404 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2GZN2j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 09:28:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH] mt9v032: Provide link frequency control
Date: Thu, 26 Jul 2012 15:28:46 +0200
Message-ID: <2673019.TNX5Epv3lK@avalon>
In-Reply-To: <201207261516.04868.hverkuil@xs4all.nl>
References: <1343307416-23172-1-git-send-email-laurent.pinchart@ideasonboard.com> <201207261516.04868.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Thursday 26 July 2012 15:16:04 Hans Verkuil wrote:
> On Thu 26 July 2012 14:56:56 Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/mt9v032.c |   48 ++++++++++++++++++++++++++++++++----
> >  include/media/mt9v032.h       |    3 ++
> >  2 files changed, 46 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
> > index 2203a6f..39217b8 100644
> > --- a/drivers/media/video/mt9v032.c
> > +++ b/drivers/media/video/mt9v032.c

[snip]

> > @@ -505,6 +514,16 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
> >  		return mt9v032_write(client, MT9V032_TOTAL_SHUTTER_WIDTH,
> >  				     ctrl->val);
> > 
> > +	case V4L2_CID_PIXEL_RATE:
> > +	case V4L2_CID_LINK_FREQ:
> > +		if (mt9v032->link_freq == NULL)
> > +			break;
> > +
> > +		freq = mt9v032->pdata->link_freqs[mt9v032->link_freq->val];
> > +		mt9v032->pixel_rate->cur.val = freq;
> 
> That should be 'mt9v032->pixel_rate->val = freq;'.
> 
> It used to be cur.val some time ago, but that was changed. You never set
> cur.val anymore inside a s_ctrl handler.

Thanks. I'll fix that.

-- 
Regards,

Laurent Pinchart

