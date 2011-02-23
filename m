Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:60024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1BWQqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 11:46:14 -0500
Date: Wed, 23 Feb 2011 17:46:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <A24693684029E5489D1D202277BE894488C577A3@dlee02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1102231729280.11581@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <201102231630.43759.laurent.pinchart@ideasonboard.com>
 <201102231702.57636.hansverk@cisco.com> <201102231714.41770.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894488C577A3@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 23 Feb 2011, Aguirre, Sergio wrote:

> Hi,
> 
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: Wednesday, February 23, 2011 10:15 AM
> > To: Hans Verkuil
> > Cc: Aguirre, Sergio; Guennadi Liakhovetski; Hans Verkuil; Sylwester
> > Nawrocki; Stan; linux-media@vger.kernel.org
> > Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
> > 
> > On Wednesday 23 February 2011 17:02:57 Hans Verkuil wrote:
> > > On Wednesday, February 23, 2011 16:30:42 Laurent Pinchart wrote:
> > > > On Wednesday 23 February 2011 15:06:49 Aguirre, Sergio wrote:
> > > > > <snip>
> > > > >
> > > > > > > The only static data I am concerned about are those that affect
> > > > > > > signal integrity.
> > > > > > >
> > > > > > > After thinking carefully about this I realized that there is
> > really
> > > > > > > only one setting that is relevant to that: the sampling edge.
> > The
> > > > > > > polarities do not matter in this.
> > > > >
> > > > > I respectfully disagree.
> > > >
> > > > So do I. Sampling edge is related to polarities, so you need to take
> > both
> > > > into account.
> > >
> > > When you switch polarity for data/field/hsync/vsync signals on a simple
> > bus
> > > you just invert whether a 1 bit is output as high or low voltage. So you
> > > just change the meaning of the bit. This does not matter for signal
> > > integrity, since you obviously have to be able to sample both low and
> > high
> > > voltages. It is *when* you sample that can have a major effect.
> > 
> > When you switch the polarity you will likely have to sample on the
> > opposite
> > edge. If, for signal integrity reasons, you can only sample on a given
> > edge,
> > you will want to use a fixed polarity and not negotiate it.
> 
> I guess this should be reason enough to decide this in platform data in the
> board file.
> 
> > 
> > Given the very small number of parameters that are negotiated by soc-
> > camera at
> > the moment, I'm very much in favour of hardcoding all of them in platform
> > data
> > and just adding a g_interface_parms subdev operation.
> 
> I'll second that.
> 
> Negotiating all this adds unnecessary complexity, and just makes the code
> More prone to errors, and even probably causing hardware damage due to
> misconfiguration. It's better to keep this static and make the board config
> fully conscious of it.

Sorry, I accept different opinions, and in the end only one of the two 
possibilities will be implemented, and either way it'll all work in the 
end, but, I don't buy either of these arguments. Complexity - the code is 
already there, it is working, it is simple, it has not broken since it has 
been implemented. I had it hard-coded in the beginning and I went over to 
negotiation and never regretted it.

Hardware damage - if this were the case, I'd probably be surrounded only 
by bricks. How configuring a wrong hsync polarity can damage your 
hardware?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
