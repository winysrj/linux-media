Return-path: <mchehab@localhost.localdomain>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4049 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0IMIIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 04:08:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] Illuminators control
Date: Mon, 13 Sep 2010 10:07:58 +0200
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20100911110350.02c55173@tele> <201009130908.37133.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201009130908.37133.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131007.58665.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Monday, September 13, 2010 09:08:36 Laurent Pinchart wrote:
> Hi,
> 
> On Saturday 11 September 2010 11:03:50 Jean-Francois Moine wrote:
> 
> > @@ -419,6 +421,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum 
> v4l2_ctrl_type *type,
> >  	case V4L2_CID_AUDIO_LIMITER_ENABLED:
> >  	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> >  	case V4L2_CID_PILOT_TONE_ENABLED:
> > +	case V4L2_CID_ILLUMINATORS_1:
> > +	case V4L2_CID_ILLUMINATORS_2:
> >  		*type = V4L2_CTRL_TYPE_BOOLEAN;
> >  		*min = 0;
> >  		*max = *step = 1;
> 
> I would prefer integer controls for this, as we will need to support dimmable 
> illuminators.
> 
> 

Don't. That should be a separate control. I expect that the brightness is
something you touch a lot less than the on/of controls. Anyway, I think it
makes a lot more sense to separate these two functions.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
