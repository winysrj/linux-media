Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55000 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934849Ab1JEUVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 16:21:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework and add video format detection
Date: Wed, 5 Oct 2011 22:21:32 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <4E8A2F76.4020209@infradead.org> <CAAwP0s30_FxMu3iegkusk7iQkBaWKmmba7sOk2vK9tcahV3ueg@mail.gmail.com>
In-Reply-To: <CAAwP0s30_FxMu3iegkusk7iQkBaWKmmba7sOk2vK9tcahV3ueg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110052221.34188.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tuesday 04 October 2011 00:37:27 Javier Martinez Canillas wrote:
> Hello,
> 
> Reading the last emails I understand that still isn't a consensus on
> the way this has to be made. If it has to be implemented at the video
> device node level or at the sub-device level. And if it has to be made
> in kernel or user-space.
> 
> On Mon, Oct 3, 2011 at 11:56 PM, Mauro Carvalho Chehab wrote:
> > Em 03-10-2011 18:44, Laurent Pinchart escreveu:
> >> On Monday 03 October 2011 21:16:45 Mauro Carvalho Chehab wrote:
> >>> Em 03-10-2011 08:53, Laurent Pinchart escreveu:
> >>>> On Monday 03 October 2011 11:53:44 Javier Martinez Canillas wrote:

[snip]

> >> With the OMAP3 ISP, which is I believe what Javier was asking about, the
> >> application will set the format on the OMAP3 ISP resizer input and
> >> output pads to configure scaling.
> 
> Yes, that was my question about. But still is not clear to me if
> configuring the ISP resizer input and output pads with different frame
> sizes automatically means that I have to do the scale or this has to
> be configured using a S_FMT ioctl to the /dev/video? node.

The resizer is completely controlled through the formats at its sink and 
source pads. It will scale the image to achieve what is configured at its 
source pad (with x1/4..x4 limits in the zoom ratio).

> Basically what I don't know is when I have to modify the pipeline graph
> inside the ISP driver and when this has to be made from user-space via MCF.

The pipeline needs to be configured before you start video capture. This means 
setting the links according to your use case, and configuring the formats on 
pads. You will then be able to use a pure V4L2 application to capture video.

> > The V4L2 API doesn't tell where a function like scaler will be
> > implemented. So, it is fine to implement it at tvp5151 or at the omap3
> > resizer, when a V4L2 call is sent.
> 
> I don't think I can do the cropping and scaling in the tvp5151 driver
> since this is a dumb device, it only spits bytes via its parallel
> interface. The actual buffer is inside the ISP.

Cropping might be possible (I'm not too familiar with the tvp5151), but 
scaling indeed isn't. That doesn't matter much though.

-- 
Regards,

Laurent Pinchart
