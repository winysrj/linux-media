Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2192 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935422Ab3DHMql (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 08:46:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michal Lazo <michal.lazo@mdragon.org>
Subject: Re: vivi kernel driver
Date: Mon, 8 Apr 2013 14:46:33 +0200
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>
References: <CAFW1BFxJ-fe8N-=LSKUfRP=-R+XUY_it3miEUKKJ6twkZa1wZA@mail.gmail.com> <CA+MoWDpAFOgEN-ruyzVp=C-Dz_16CnOSXU30UowARB3m-eTVMQ@mail.gmail.com> <CAFW1BFwnsgUqCg5DkN5w=z8-Ph+oMQ-PrYyxg_ENTjNmEBpGHg@mail.gmail.com>
In-Reply-To: <CAFW1BFwnsgUqCg5DkN5w=z8-Ph+oMQ-PrYyxg_ENTjNmEBpGHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081446.33811.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon April 8 2013 14:42:32 Michal Lazo wrote:
> Hi
> 720x576 RGB 25, 30 fps and it take
> 
> 25% cpu load on raspberry pi(ARM 700Mhz linux 3.6.11) or 8% on x86(AMD
> 2GHz linux 3.2.0-39)
> 
> it is simply too much

No, that's what I would expect. Note that vivi was substantially improved recently
when it comes to the image generation. That will be in the upcoming 3.9 kernel.

This should reduce CPU load by quite a bit if memory serves.

Regards,

	Hans

> 
> 
> 
> 
> On Mon, Apr 8, 2013 at 9:42 AM, Peter Senna Tschudin
> <peter.senna@gmail.com> wrote:
> > Dear Michal,
> >
> > The CPU intensive part of the vivi driver is the image generation.
> > This is not an issue for real drivers.
> >
> > Regards,
> >
> > Peter
> >
> > On Sun, Apr 7, 2013 at 9:32 PM, Michal Lazo <michal.lazo@mdragon.org> wrote:
> >> Hi
> >> V4L2 driver vivi
> >> generate 25% cpu load on raspberry pi(linux 3.6.11) or 8% on x86(linux 3.2.0-39)
> >>
> >> player
> >> GST_DEBUG="*:3,v4l2src:3,v4l2:3" gst-launch-0.10 v4l2src
> >> device="/dev/video0" norm=255 ! video/x-raw-rgb, width=720,
> >> height=576, framerate=30000/1001 ! fakesink sync=false
> >>
> >> Anybody can answer me why?
> >> And how can I do it better ?
> >>
> >> I use vivi as base example for my driver
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> > --
> > Peter
> 
> 
> 
> 
