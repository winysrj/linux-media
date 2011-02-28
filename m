Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50924 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1B1KLj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 05:11:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
Date: Mon, 28 Feb 2011 11:11:47 +0100
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Edward Hervey <bilboed@gmail.com>,
	johan.mossberg.lml@gmail.com,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	"ST-Ericsson LT Mailing List" <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com> <201102261312.43125.hverkuil@xs4all.nl>
In-Reply-To: <201102261312.43125.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281111.47666.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 26 February 2011 13:12:42 Hans Verkuil wrote:
> On Friday, February 25, 2011 18:22:51 Linus Walleij wrote:
> > 2011/2/24 Edward Hervey <bilboed@gmail.com>:
> > >  What *needs* to be solved is an API for data allocation/passing at the
> > > 
> > > kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
> > > userspace (like GStreamer) can pass around, monitor and know about.
> > 
> > I think the patches sent out from ST-Ericsson's Johan Mossberg to
> > linux-mm for "HWMEM" (hardware memory) deals exactly with buffer
> > passing, pinning of buffers and so on. The CMA (Contigous Memory
> > Allocator) has been slightly modified to fit hand-in-glove with HWMEM,
> > so CMA provides buffers, HWMEM pass them around.
> > 
> > Johan, when you re-spin the HWMEM patchset, can you include
> > linaro-dev and linux-media in the CC?
> 
> Yes, please. This sounds promising and we at linux-media would very much
> like to take a look at this. I hope that the CMA + HWMEM combination is
> exactly what we need.

Once again let me restate what I've been telling for some time: CMA must be 
*optional*. Not all hardware need contiguous memory. I'll have a look at the 
next HWMEM version.

-- 
Regards,

Laurent Pinchart
