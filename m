Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:39020 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1BWQUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 11:20:38 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 23 Feb 2011 10:20:17 -0600
Subject: RE: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Message-ID: <A24693684029E5489D1D202277BE894488C577A3@dlee02.ent.ti.com>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <201102231630.43759.laurent.pinchart@ideasonboard.com>
 <201102231702.57636.hansverk@cisco.com>
 <201102231714.41770.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102231714.41770.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Wednesday, February 23, 2011 10:15 AM
> To: Hans Verkuil
> Cc: Aguirre, Sergio; Guennadi Liakhovetski; Hans Verkuil; Sylwester
> Nawrocki; Stan; linux-media@vger.kernel.org
> Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
> 
> On Wednesday 23 February 2011 17:02:57 Hans Verkuil wrote:
> > On Wednesday, February 23, 2011 16:30:42 Laurent Pinchart wrote:
> > > On Wednesday 23 February 2011 15:06:49 Aguirre, Sergio wrote:
> > > > <snip>
> > > >
> > > > > > The only static data I am concerned about are those that affect
> > > > > > signal integrity.
> > > > > >
> > > > > > After thinking carefully about this I realized that there is
> really
> > > > > > only one setting that is relevant to that: the sampling edge.
> The
> > > > > > polarities do not matter in this.
> > > >
> > > > I respectfully disagree.
> > >
> > > So do I. Sampling edge is related to polarities, so you need to take
> both
> > > into account.
> >
> > When you switch polarity for data/field/hsync/vsync signals on a simple
> bus
> > you just invert whether a 1 bit is output as high or low voltage. So you
> > just change the meaning of the bit. This does not matter for signal
> > integrity, since you obviously have to be able to sample both low and
> high
> > voltages. It is *when* you sample that can have a major effect.
> 
> When you switch the polarity you will likely have to sample on the
> opposite
> edge. If, for signal integrity reasons, you can only sample on a given
> edge,
> you will want to use a fixed polarity and not negotiate it.

I guess this should be reason enough to decide this in platform data in the
board file.

> 
> Given the very small number of parameters that are negotiated by soc-
> camera at
> the moment, I'm very much in favour of hardcoding all of them in platform
> data
> and just adding a g_interface_parms subdev operation.

I'll second that.

Negotiating all this adds unnecessary complexity, and just makes the code
More prone to errors, and even probably causing hardware damage due to
misconfiguration. It's better to keep this static and make the board config
fully conscious of it.

Regards,
Sergio

> 
> > This might be different for differential clocks. I have no experience
> with
> > this, so I can't say anything sensible about that.
> 
> --
> Regards,
> 
> Laurent Pinchart
