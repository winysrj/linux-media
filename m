Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:56528 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1BVNbr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 08:31:47 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Tue, 22 Feb 2011 14:32:50 +0100
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <Pine.LNX.4.64.1102221215350.1380@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102221215350.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221432.50847.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, February 22, 2011 12:40:32 Guennadi Liakhovetski wrote:
> On Tue, 22 Feb 2011, Stanimir Varbanov wrote:
> 
> > This RFC patch adds a new subdev sensor operation named g_interface_parms.
> > It is planned as a not mandatory operation and it is driver's developer
> > decision to use it or not.
> > 
> > Please share your opinions and ideas.

Stanimir, thanks for the RFC. I think it is time that we create a good 
solution for this. This is currently the last remaining issue preventing soc-
camera subdevs from being used generally. (Control handling is also still 
special, but this is being worked on.)

> Yes, I like the idea in principle (/me pulling his bullet-proof vest on), 

:-)

> as some of you might guess, because I feel it's going away from the idea, 
> that I've been hard pressed to accept of hard-coding the media-bus 
> configuration and in the direction of direct communication of 
> bus-parameters between the (sub-)devices, e.g., a camera host and a camera 
> device in soc-camera terminology.
> 
> But before reviewing the patch as such, I'd like to discuss the strategy, 
> that we want to pursue here - what exactly do we want to hard-code and 
> what we want to configure dynamically? As explained before, my preference 
> would be to only specify the absolute minimum in the platform data, i.e., 
> parameters that either are ambiguous or special for this platform. So, 
> once again, my approach to configure interface parameters like signal 
> polarities and edge sensitivity is:
> 
> 1. if at least one side has a fixed value of the specific parameter, 
> usually no need to specify it in platform data. Example: sensor only 
> supports HSYNC active high, host supports both, normally "high" should be 
> selected.
> 
> 2. as above, but there's an inverter on the board in the signal path. The 
> "invert" parameter must be specified in the platform data and the host 
> will configure itself to "low" and send "high" confirmed to the sensor.
> 
> 3. both are configurable. In this case the platform data has to specify, 
> which polarity shall be used.
> 
> This is simple, it is implemented, it has worked that way with no problem 
> for several years now.
> 
> The configuration procedure in this case looks like:
> 
> 1. host requests supported interface configurations from the client 
> (sensor)
> 
> 2. host matches returned parameters against platform data and its own 
> capabilities
> 
> 3. if no suitable configuration possible - error out
> 
> 4. the single possible configuration is identified and sent to the sensor 
> back for its configuration
> 
> This way we need one more method: s_interface_parms.
> 
> Shortly talking to Laurent earlier today privately, he mentioned, that one 
> of the reasons for this move is to support dynamic bus reconfiguration, 
> e.g., the number of used CSI lanes. The same is useful for parallel 
> interfaces. E.g., I had to hack the omap3spi driver to capture only 8 
> (parallel) data lanes from the sensor, connected with all its 10 lanes to 
> get a format, easily supported by user-space applications. Ideally you 
> don't want to change anything in the code for this. If the user is 
> requesting the 10-bit format, all 10 lanes are used, if only 8 - the 
> interface is reconfigured accordingly.

I have no problems with dynamic bus reconfiguration as such. So if the host 
driver wants to do lane reconfiguration, then that's fine by me.

When it comes to signal integrity (polarity, rising/falling edge), then I 
remain convinced that this should be set via platform data. This is not 
something that should be negotiated since this depends not only on the sensor 
and host devices, but also on the routing of the lines between them on the 
actual board, how much noise there is on those lines, the quality of the clock 
signal, etc. Not really an issue with PAL/NTSC type signals, but when you get 
to 1080p60 and up, then such things become much more important.

So these settings should not be negotiated, but set explicitly.

It actually doesn't have to be done through platform data (although that makes 
the most sense), as long as it is explicitly set based on board-specific data.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
> > ---
> > It tries to create a common API for getting the sensor interface type
> > - serial or parallel, modes and interface clocks. The interface clocks
> > then are used in the host side to calculate it's configuration, check
> > that the clocks are not beyond host limitations etc.
> > 
> > "phy_rate" in serial interface (CSI DDR clk) is used to calculate
> > the CSI2 PHY receiver timing parameters: ths_settle, ths_term,
> > clk_settle and clk_term.
> > 
> > As the "phy_rate" depends on current sensor mode (configuration of the
> > sensor's PLL and internal clock domains) it can be treated as dynamic
> > parameter and can vary (could be different for viewfinder and still 
> > capture), in this context g_interface_parms should be called after
> > s_fmt.
> > 
> > "pix_clk" for parallel interface reflects the current sensor pixel
> > clock. With this clock the image data is clocked out of the sensor.
> > 
> > "pix_clk" for serial interface reflects the current sensor pixel
> > clock at which image date is read from sensor matrix.
> > 
> > "lanes" for serial interface reflects the number of PHY lanes used from
> > the sensor to output image data. This should be known from the host
> > side before the streaming is started. For some sensor modes it's
> > enough to use one lane, for bigger resolutions two lanes and more
> > are used.
> > 
> > "channel" for serial interface is also needed from host side to
> > configure it's PHY receiver at particular virtual channel.
> > 
> > ---
> > Some background and inspiration.
> > 
> > - Currently in the OMAP3 ISP driver we use a set of platform data
> > callbacks to provide the above parameters and this comes to very
> > complicated platform code, driver implementation and unneeded 
> > sensor driver <-> host driver dependences. 
> > 
> > - In the present time we seeing growing count of sensor drivers and
> > host (bridge) drivers but without standard API's for communication.
> > Currently the subdev sensor operations have only one operation -
> > g_skip_top_lines.
> > 
> > Stanimir Varbanov (1):
> >   v4l: Introduce sensor operation for getting interface configuration
> > 
> >  include/media/v4l2-subdev.h |   42 
++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 42 insertions(+), 0 deletions(-)
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
