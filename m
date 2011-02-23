Return-path: <mchehab@pedra>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:3832 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab1BWQ13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 11:27:29 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 17:28:39 +0100
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102231702.57636.hansverk@cisco.com> <201102231714.41770.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102231714.41770.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231728.40075.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, February 23, 2011 17:14:41 Laurent Pinchart wrote:
> On Wednesday 23 February 2011 17:02:57 Hans Verkuil wrote:
> > On Wednesday, February 23, 2011 16:30:42 Laurent Pinchart wrote:
> > > On Wednesday 23 February 2011 15:06:49 Aguirre, Sergio wrote:
> > > > <snip>
> > > > 
> > > > > > The only static data I am concerned about are those that affect
> > > > > > signal integrity.
> > > > > > 
> > > > > > After thinking carefully about this I realized that there is 
really
> > > > > > only one setting that is relevant to that: the sampling edge. The
> > > > > > polarities do not matter in this.
> > > > 
> > > > I respectfully disagree.
> > > 
> > > So do I. Sampling edge is related to polarities, so you need to take 
both
> > > into account.
> > 
> > When you switch polarity for data/field/hsync/vsync signals on a simple 
bus
> > you just invert whether a 1 bit is output as high or low voltage. So you
> > just change the meaning of the bit. This does not matter for signal
> > integrity, since you obviously have to be able to sample both low and high
> > voltages. It is *when* you sample that can have a major effect.
> 
> When you switch the polarity you will likely have to sample on the opposite 
> edge. If, for signal integrity reasons, you can only sample on a given edge, 
> you will want to use a fixed polarity and not negotiate it.

You are confusing clock polarity (which is relevant) with data, field, hsync 
and vsync polarities which just invert the meaning of those pins.

I wish I had a whiteboard to draw it, much easier to explain that way.

> 
> Given the very small number of parameters that are negotiated by soc-camera 
at 
> the moment, I'm very much in favour of hardcoding all of them in platform 
data 
> and just adding a g_interface_parms subdev operation.

Just for the record: I have no problem with hardcoding these polarities. After 
all, that was my original idea. But they can be negotiated as well.

Regards,

	Hans

> 
> > This might be different for differential clocks. I have no experience with
> > this, so I can't say anything sensible about that.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
