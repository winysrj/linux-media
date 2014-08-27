Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49914 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaH0JUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 05:20:10 -0400
Message-ID: <1409131199.3623.30.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC] [media] v4l2: add V4L2 pixel format array and helper
 functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de
Date: Wed, 27 Aug 2014 11:19:59 +0200
In-Reply-To: <Pine.LNX.4.64.1408262217090.7329@axis700.grange>
References: <1408962839-25165-1-git-send-email-p.zabel@pengutronix.de>
	 <Pine.LNX.4.64.1408262217090.7329@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Am Dienstag, den 26.08.2014, 22:18 +0200 schrieb Guennadi Liakhovetski:
> Hi Philipp,
> 
> On Mon, 25 Aug 2014, Philipp Zabel wrote:
> 
> > This patch adds an array of V4L2 pixel formats and descriptions that can be
> > used by drivers so that each driver doesn't have to provide its own slightly
> > different format descriptions for VIDIOC_ENUM_FMT.
> 
> In case you missed it, soc-camera is doing something rather similar along 
> the lines of:
> 
> drivers/media/platform/soc_camera/soc_mediabus.c
> include/media/soc_mediabus.h
> 
> Feel free to re-use.

thank you for the pointer. It is unfortunate that there is a bit of
overlap in the names, but not much in the rest of the information.
I don't see how the data could be reused in a meaningful way, but maybe
I should try to match the patterns.

I like the idea of soc_mbus_find_fmtdesc being called with a driver
specific lookup array. Although that currently causes drivers to again
duplicate all the names, it side-steps the issue of a linear lookup in a
large global array. Maybe a helper to fill this driver specific array
from the global array would be a good idea for consistency?

What is the reason for the separation between struct soc_mbus_lookup and
struct soc_mbus pixelformat (as opposed to including enum
v4l2_mbus_pixelcode in struct soc_mbus_pixelformat directly)?

regards
Philipp


