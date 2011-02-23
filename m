Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:45093 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1BWRpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 12:45:19 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 23 Feb 2011 11:45:08 -0600
Subject: RE: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Message-ID: <A24693684029E5489D1D202277BE894488D6F9F5@dlee02.ent.ti.com>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <201102231630.43759.laurent.pinchart@ideasonboard.com>
 <201102231702.57636.hansverk@cisco.com>
 <201102231714.41770.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894488C577A3@dlee02.ent.ti.com>
 <Pine.LNX.4.64.1102231729280.11581@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102231729280.11581@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: Wednesday, February 23, 2011 10:46 AM
> To: Aguirre, Sergio
> Cc: Laurent Pinchart; Hans Verkuil; Sylwester Nawrocki; Stan; linux-
> media@vger.kernel.org
> Subject: RE: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
> 
> On Wed, 23 Feb 2011, Aguirre, Sergio wrote:
> 
> > Hi,
> >
> > > -----Original Message-----
> > > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > > Sent: Wednesday, February 23, 2011 10:15 AM
> > > To: Hans Verkuil
> > > Cc: Aguirre, Sergio; Guennadi Liakhovetski; Hans Verkuil; Sylwester
> > > Nawrocki; Stan; linux-media@vger.kernel.org
> > > Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation
> g_interface_parms
> > >
> > > On Wednesday 23 February 2011 17:02:57 Hans Verkuil wrote:
> > > > On Wednesday, February 23, 2011 16:30:42 Laurent Pinchart wrote:
> > > > > On Wednesday 23 February 2011 15:06:49 Aguirre, Sergio wrote:
> > > > > > <snip>
> > > > > >
> > > > > > > > The only static data I am concerned about are those that
> affect
> > > > > > > > signal integrity.
> > > > > > > >
> > > > > > > > After thinking carefully about this I realized that there is
> > > really
> > > > > > > > only one setting that is relevant to that: the sampling
> edge.
> > > The
> > > > > > > > polarities do not matter in this.
> > > > > >
> > > > > > I respectfully disagree.
> > > > >
> > > > > So do I. Sampling edge is related to polarities, so you need to
> take
> > > both
> > > > > into account.
> > > >
> > > > When you switch polarity for data/field/hsync/vsync signals on a
> simple
> > > bus
> > > > you just invert whether a 1 bit is output as high or low voltage. So
> you
> > > > just change the meaning of the bit. This does not matter for signal
> > > > integrity, since you obviously have to be able to sample both low
> and
> > > high
> > > > voltages. It is *when* you sample that can have a major effect.
> > >
> > > When you switch the polarity you will likely have to sample on the
> > > opposite
> > > edge. If, for signal integrity reasons, you can only sample on a given
> > > edge,
> > > you will want to use a fixed polarity and not negotiate it.
> >
> > I guess this should be reason enough to decide this in platform data in
> the
> > board file.
> >
> > >
> > > Given the very small number of parameters that are negotiated by soc-
> > > camera at
> > > the moment, I'm very much in favour of hardcoding all of them in
> platform
> > > data
> > > and just adding a g_interface_parms subdev operation.
> >
> > I'll second that.
> >
> > Negotiating all this adds unnecessary complexity, and just makes the
> code
> > More prone to errors, and even probably causing hardware damage due to
> > misconfiguration. It's better to keep this static and make the board
> config
> > fully conscious of it.
> 
> Sorry, I accept different opinions, and in the end only one of the two
> possibilities will be implemented, and either way it'll all work in the
> end, but, I don't buy either of these arguments.

> Complexity - the code is
> already there, it is working, it is simple, it has not broken since it has
> been implemented. I had it hard-coded in the beginning and I went over to
> negotiation and never regretted it.

First of all, it seems that this discussion is heavily parallel i/f
oriented, and soc_camera focused, and it's just not like that.

Now, _just_ for soc_camera framework, yeah... it works and it's there, but
still not providing a solution for other v4l2_subdev users (like Media
Controller).

Complexity comes only when trying to make this truly generic, and avoid
fragmentation of solutions (1 for soc, 1 for MC), plus adding support for
serial (MIPI) interfaces

Now, also, the patch originally proposed by Stan doesn't actually deal with
putting polarities as part of the interface parameters, which is something
you're currently negotiating in soc_camera framework, again, just for
parallel interfaces.

Now, just for the sake of clarifying my understanding, I guess what you're
saying is to make sensor driver expose all possible polarities and physical
details configurable, and make the platform data limit the actual options due to the physical layout.

For example, if in my board A, I have:

	- OV5640 sensor driver, which supports both Parallel and CSI2
        Interfaces (with up to 2 datalanes)
	- Rx subdev (or host) driver(s) which support Parallel, CSI2-A and
        CSI2-B interfaces (with 2 and 1 datalanes respectively).

I should specify in my boardfile integration details, such as the
sensor is actually wired to the CSI2-B I/f, so make the sensor
negotiate with the other side of the bus and enable CSI2 i/f with
given details, like just use 1 datalane, and match datalane
position/polarity.

Am I understanding right?

> 
> Hardware damage - if this were the case, I'd probably be surrounded only
> by bricks. How configuring a wrong hsync polarity can damage your
> hardware?

Ok, I'll regret my statement on this one. I guess I was a bit too dramatic
to point out consequences of HW mismatches. Nevermind this.

Regards,
Sergio

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
