Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1LSMCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 07:02:07 -0500
Date: Mon, 19 Dec 2011 13:01:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: javier Martin <javier.martin@vista-silicon.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <201112191252.24101.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1112191301070.23694@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
 <Pine.LNX.4.64.1112191237300.23694@axis700.grange>
 <201112191252.24101.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Dec 2011, Laurent Pinchart wrote:

> Hi,
> 
> On Monday 19 December 2011 12:43:28 Guennadi Liakhovetski wrote:
> > On Mon, 19 Dec 2011, javier Martin wrote:
> > > On 19 December 2011 11:58, Guennadi Liakhovetski wrote:
> > > > On Mon, 19 Dec 2011, javier Martin wrote:
> > > >> On 19 December 2011 11:41, Guennadi Liakhovetski wrote:
> > > >> > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
> > > >> >> On Monday 19 December 2011 11:13:58 Guennadi Liakhovetski wrote:
> > > >> >> > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
> > > >> >> > > On Monday 19 December 2011 09:09:34 Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > > >> >> > > > Good, this would mean, we need additional subdevice
> > > >> >> > > > operations along the lines of enum_input and enum_output,
> > > >> >> > > > and maybe also g_input and g_output?
> > > >> >> > > 
> > > >> >> > > What about implementing pad support in the subdevice ? Input
> > > >> >> > > enumeration could then be performed without a subdev
> > > >> >> > > operation.
> > > >> >> > 
> > > >> >> > soc-camera doesn't support pad operations yet.
> > > >> >> 
> > > >> >> soc-camera doesn't support enum_input yet either, so you need to
> > > >> >> implement something anyway ;-)
> > > >> >> 
> > > >> >> You wouldn't need to call a pad operation here, you would just need
> > > >> >> to iterate through the pads provided by the subdev.
> > > >> > 
> > > >> > tvp5150 doesn't implement it either yet. So, I would say, it is a
> > > >> > better solution ATM to fix this functionality independent of the
> > > >> > pad-level API.
> > > >> 
> > > >> I agree,
> > > >> I cannot contribute to implement pad-level API stuff since I can't
> > > >> test it with tvp5150.
> > > >> 
> > > >> Would you accept a patch implementing only S_INPUT?
> > > > 
> > > > Sorry, maybe I'm missing something, but how would it work? I mean, how
> > > > can we accept from the user any S_INPUT request with index != 0, if we
> > > > always return only 0 in reply to ENUM_INPUT? Ok, G_INPUT we could
> > > > implement internally in soc-camera: return 0 by default, then remember
> > > > last set input number per soc-camera device / subdev. But
> > > > ENUM_INPUT?...
> > > 
> > > It clearly is not a complete solution but at least it allows setting
> > > input 0 in broken drivers such as tvp5150 which have input 1 enabled
> > > by default, while soc-camera assumes input 0 is enabled.
> > 
> > I would really prefer an addition of an .enum_input() video subdev
> > operation.
> 
> I agree that input enumeration is needed, but I really think this should be 
> handled through pads, no with a new subdev operation. I don't like the idea of 
> introducing a new operation that will already be deprecated from the very 
> beginning.
> 
> Implementing this through pads isn't difficult. You don't need to implement 
> any pad operation in the tvp5150 driver. All you need to do is setup an array 
> of pads at probe time with information provided through platform data. soc-
> camera should then just access the pads array and implement enum_input 
> internally.

Ok, this might indeed be simple enough. Javier, could you give it a try?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
