Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52989 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1BWLPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 06:15:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 12:15:31 +0100
Cc: Hans Verkuil <hansverk@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102221432.50847.hansverk@cisco.com> <A24693684029E5489D1D202277BE894488C56A9A@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894488C56A9A@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231215.31782.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sergio,

On Tuesday 22 February 2011 15:01:57 Aguirre, Sergio wrote:
> On Tuesday, February 22, 2011 7:33 AM Hans Verkuil wrote: > > On Tuesday, 
February 22, 2011 12:40:32 Guennadi Liakhovetski wrote:
> > > On Tue, 22 Feb 2011, Stanimir Varbanov wrote:
> > > > This RFC patch adds a new subdev sensor operation named
> > > > g_interface_parms.
> > > >
> > > > It is planned as a not mandatory operation and it is driver's
> > > > developer decision to use it or not.
> > > > 
> > > > Please share your opinions and ideas.
> > 
> > Stanimir, thanks for the RFC. I think it is time that we create a good
> > solution for this. This is currently the last remaining issue preventing
> > soc-camera subdevs from being used generally. (Control handling is also
> > still special, but this is being worked on.)
> > 
> > > Yes, I like the idea in principle (/me pulling his bullet-proof vest
> > > on), :-) :
> > > as some of you might guess, because I feel it's going away from the
> > > idea, that I've been hard pressed to accept of hard-coding the media-bus
> > > configuration and in the direction of direct communication of
> > > bus-parameters between the (sub-)devices, e.g., a camera host and a
> > > camera device in soc-camera terminology.
> > > 
> > > But before reviewing the patch as such, I'd like to discuss the
> > > strategy, that we want to pursue here - what exactly do we want to
> > > hard-code and what we want to configure dynamically? As explained
> > > before, my preference would be to only specify the absolute minimum in
> > > the platform data, i.e., parameters that either are ambiguous or special
> > > for this platform. So, once again, my approach to configure interface
> > > parameters like signal polarities and edge sensitivity is:
> > > 
> > > 1. if at least one side has a fixed value of the specific parameter,
> > > usually no need to specify it in platform data. Example: sensor only
> > > supports HSYNC active high, host supports both, normally "high" should
> > > be selected.
> > > 
> > > 2. as above, but there's an inverter on the board in the signal path.
> > > The "invert" parameter must be specified in the platform data and the
> > > host will configure itself to "low" and send "high" confirmed to the
> > > sensor.
> > > 
> > > 3. both are configurable. In this case the platform data has to
> > > specify, which polarity shall be used.
> > > 
> > > This is simple, it is implemented, it has worked that way with no
> > > problem for several years now.
> > > 
> > > The configuration procedure in this case looks like:
> > > 
> > > 1. host requests supported interface configurations from the client
> > > (sensor)
> > > 
> > > 2. host matches returned parameters against platform data and its own
> > > capabilities
> > > 
> > > 3. if no suitable configuration possible - error out
> > > 
> > > 4. the single possible configuration is identified and sent to the
> > > sensor back for its configuration
> > > 
> > > This way we need one more method: s_interface_parms.
> > > 
> > > Shortly talking to Laurent earlier today privately, he mentioned, that
> > > one of the reasons for this move is to support dynamic bus
> > > reconfiguration, e.g., the number of used CSI lanes. The same is useful
> > > for parallel interfaces. E.g., I had to hack the omap3spi driver to
> > > capture only 8 (parallel) data lanes from the sensor, connected with all
> > > its 10 lanes to get a format, easily supported by user-space
> > > applications. Ideally you don't want to change anything in the code for
> > > this. If the user is requesting the 10-bit format, all 10 lanes are
> > > used, if only 8 - the interface is reconfigured accordingly.
> > 
> > I have no problems with dynamic bus reconfiguration as such. So if the
> > host driver wants to do lane reconfiguration, then that's fine by me.
> > 
> > When it comes to signal integrity (polarity, rising/falling edge), then I
> > remain convinced that this should be set via platform data. This is not
> > something that should be negotiated since this depends not only on the
> > sensor and host devices, but also on the routing of the lines between them
> > on the actual board, how much noise there is on those lines, the quality
> > of the clock signal, etc. Not really an issue with PAL/NTSC type signals,
> > but when you get to 1080p60 and up, then such things become much more
> > important.
> > 
> > So these settings should not be negotiated, but set explicitly.
> > 
> > It actually doesn't have to be done through platform data (although that
> > makes the most sense), as long as it is explicitly set based on board-
> > specific data.

I agree with Hans here. I don't think negotiation is a good idea.

> My 2 cents here is that I think this consists in 2 parts, and should be
> divided properly.
> 
> 1. You know required # of lanes & clockspeed after you had set the format.
> For example:
> 
> - VGA @ 30fps
>   DDR Clk: 330 MHz
>   Number of Datalanes: 1
> 
> - VGA @ 60fps
>   DDR Clk: 330 MHz
>   Number of Datalanes: 2
> 
> - 12MPix @ 10fps
>   DDR Clk: 480 MHz
>   Number of Datalanes: 2
> 
> This usually is something you know from the sensor config selected based
> on your params.
> 
> So, I think this is something that the host should ask to the client
> after setting size & framerate, or just before VIDIOC_STREAMON.
> 
> THIS I think must be handle dynamically by introducing it as part of
> a V4l2_subdev sensor_ops entry. If this can't be done, then how?

Sounds good to me, that's what this RFC is about. The host needs to retrieve 
interface parameters from the client at streamon time, and a new subdev 
operation looks like an easy solution. The client will obviously need to get 
the acceptable  set of parameters from platform data.

> 2. Specifying polarity and lanes physical position.
> 
> For example, at least OMAP3 & 4 has the following pin pairs:
> 
> CSI2_DX0, CSI2_DY0
> CSI2_DX1, CSI2_DY1
> CSI2_DX2, CSI2_DY2
> CSI2_DX3, CSI2_DY3
> CSI2_DX4, CSI2_DY4
> 
> So, what you do is that, you can control where do you want the clock,
> where do you want each datalane pair, and also the pin polarity
> (X: +, Y: -, or viceversa). And this is something that is static.
> THIS I think should go in the host driver's platform data.
> 
> Of course, I'm here discarding the fact that at least some sensors that
> I know of can change the primary data lane position in sensor configuration
> (at least some OmniVision sensors do), but I'll assume this is usually
> Locked, and assume the host is better at that.

-- 
Regards,

Laurent Pinchart
