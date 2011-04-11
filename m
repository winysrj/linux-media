Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53840 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1DKOyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 10:54:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv1 PATCH 3/9] v4l2-ioctl: add ctrl_handler to v4l2_fh
Date: Mon, 11 Apr 2011 16:54:43 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <201104081710.32652.laurent.pinchart@ideasonboard.com> <201104081739.01073.hverkuil@xs4all.nl>
In-Reply-To: <201104081739.01073.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104111654.44323.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Friday 08 April 2011 17:39:01 Hans Verkuil wrote:
> On Friday, April 08, 2011 17:10:32 Laurent Pinchart wrote:
> > On Monday 04 April 2011 13:51:48 Hans Verkuil wrote:
> > > From: Hans Verkuil <hverkuil@xs4all.nl>
> > > 
> > > This is required to implement control events and is also needed to
> > > allow for per-filehandle control handlers.
> > 
> > Thanks for the patch.
> > 
> > Shouldn't you modify v4l2-subdev.c similarly ?
> 
> Good question. Does it make sense to have per-filehandle controls for a
> sub-device? On the other hand, does it make sense NOT to have it?

Yes, I think it does. I wrote support for per-file handler controls for 
subdevs and submitted an RFC patch to the list some time ago to implement 
bandwidth managemeng in the OMAP3 ISP driver (this has been put on hold due to 
missing information about the OMAP3 ISP though).

> I'm inclined to add this functionality if nobody objects. Although a
> use-case for this would be nice bonus.

-- 
Regards,

Laurent Pinchart
