Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56410 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbbA2UUP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 15:20:15 -0500
Date: Thu, 29 Jan 2015 21:19:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
In-Reply-To: <54CA7BBF.6070607@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1501292118020.7281@axis700.grange>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
 <1422548388-28861-6-git-send-email-william.towle@codethink.co.uk>
 <54CA6869.9060100@cogentembedded.com> <Pine.LNX.4.64.1501291915100.30602@axis700.grange>
 <54CA7BBF.6070607@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2015, Sergei Shtylyov wrote:

> Hello.
> 
> On 01/29/2015 09:18 PM, Guennadi Liakhovetski wrote:
> 
> > > > This adds V4L2_MBUS_FMT_RGB888_1X24 input format support
> > > > which is used by the ADV7612 chip.
> 
> > > > Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
> 
> > >     I wonder why it hasn't been merged still? It's pending since 2013, and
> > > I'm
> > > seeing no objections to it...
> 
> > Indeed, strange. I'm saving it for me to look at it for the next merge...
> > and I'll double-check that series. Maybe the series had some objections,
> 
>    Indeed, I'm now seeing the patch #1 was objected to. Patch #2 has been
> merged somewhat later.

Right, and since this RGB888 format support was needed for the ADV761X 
driver from patch #1, this patch wasn't merged either. Do you need it now 
for something different?

Thanks
Guennadi
