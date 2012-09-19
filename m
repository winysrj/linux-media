Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40571 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2ISTFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 15:05:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: soc-camera: add selection API host operations
Date: Wed, 19 Sep 2012 21:05:59 +0200
Message-ID: <13635337.rYxAaDZnVE@avalon>
In-Reply-To: <Pine.LNX.4.64.1207111755180.18999@axis700.grange>
References: <Pine.LNX.4.64.1206221749190.17552@axis700.grange> <2010732.dj1mZZWrvn@avalon> <Pine.LNX.4.64.1207111755180.18999@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 11 July 2012 18:10:05 Guennadi Liakhovetski wrote:

Wow, that's an old mail :-)

> On Fri, 6 Jul 2012, Laurent Pinchart wrote:
> > On Friday 22 June 2012 18:40:08 Guennadi Liakhovetski wrote:
> > > Add .get_selection() and .set_selection() soc-camera host driver
> > > operations. Additionally check, that the user is not trying to change
> > > the output sizes during a running capture.
> > 
> > How will that interact with the crop operations ? The goal is to move away
> > from crop operations to selection operations, so we need to establish
> > clear rules.
> 
> Nicely:-) My understanding is, that the V4L2 core now is doing a large
> part (all of?) compatibility / conversion work? As you know, soc-camera is
> a kind of a glue layer between the V4L2 core and host drivers with some
> helper functionality for client drivers. All V4L2 API calls go via the
> soc-camera core and most of them are passed, possibly after some
> preprocessing, to host drivers. Same holds for cropping and selection
> calls. They are passed on to host drivers. As long as drivers use the
> cropping API, the soc-camera core has to support it. Only after all host
> drivers have been ported over, the soc-camera core can abandon it too. I
> don't see another way out, do you?

My point was that it might be quite complex for soc-camera clients to 
implement both crop and selection operations. As the goal is to move both 
clients and hosts to selection operations, the soc-camera core could translate 
crop calls to selection calls if crop operations are not provided. Clients 
could then replace crop callbacks with selection callbacks without having to 
implement both as an interim solution.

-- 
Regards,

Laurent Pinchart

