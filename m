Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2187 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab2JQGeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 02:34:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [media-workshop] RFC: V4L2 API ambiguities
Date: Wed, 17 Oct 2012 08:34:05 +0200
Cc: media-workshop@linuxtv.org, Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
References: <201210151335.45477.hverkuil@xs4all.nl> <1758580.dogfQVcdf2@avalon>
In-Reply-To: <1758580.dogfQVcdf2@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210170834.05701.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 17 2012 02:25:00 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 15 October 2012 13:35:45 Hans Verkuil wrote:
> > During the Plumbers Conference a few weeks ago we had a session to resolve
> > V4L2 ambiguities. It was very successful, but we didn't manage to tackle
> > two of the harder topics, and a third one (timestamps) cause a lot of
> > discussion on the mailinglist after the conference.
> > 
> > So here is the list I have today. Any other ambiguities or new features that
> > should be added to the list?
> 
> Small topic that we've briefly discussed on IRC: if a device doesn't tell the 
> driver what color space it uses, should the driver guess or tell the 
> application that the color space is unknown ? I've ran into that issue for the 
> uvcvideo driver, while I agree with you that in that case the color space is 
> very likely sRGB, and that the driver is probably in a better position to make 
> that guess than the userspace application (as the driver knows it handles a 
> webcam), what should be the rule ?

I'll add it to the list.

> > 1) Make a decision how to tell userspace that the monotonic timestamp is
> > used.
> > 
> > Several proposals were made, but no decision was taken AFAIK. Can someone
> > (Sakari?) make a summary/current status of this?
> > 
> > 
> > 2) Pixel Aspect Ratio
> > 
> > Pixel aspect: currently this is only available through VIDIOC_CROPCAP. It
> > never really belonged to VIDIOC_CROPCAP IMHO. It's just not a property of
> > cropping or composing. It really belongs to the input/output timings (STD
> > or DV_TIMINGS). That's where the pixel aspect ratio is determined.
> > 
> > While it is possible to add it to the dv_timings struct, I see no way of
> > cleanly adding it to struct v4l2_standard (mostly because VIDIOC_ENUMSTD is
> > now handled inside the V4L2 core and doesn't call the drivers anymore).
> 
> Isn't that an implementation issue instead of an API issue ?

True, but it will require changing all drivers. But adding it to v4l2_standard
would be the best place for this, so perhaps we should think about doing all
this work.

Regards,

	Hans
