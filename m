Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:2619 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1BVPQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 10:16:52 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Tue, 22 Feb 2011 16:17:55 +0100
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102221432.50847.hansverk@cisco.com> <Pine.LNX.4.64.1102221456590.1380@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102221456590.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221617.55726.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, February 22, 2011 15:11:49 Guennadi Liakhovetski wrote:
> On Tue, 22 Feb 2011, Hans Verkuil wrote:

<snip>

> > I have no problems with dynamic bus reconfiguration as such. So if the 
host 
> > driver wants to do lane reconfiguration, then that's fine by me.
> > 
> > When it comes to signal integrity (polarity, rising/falling edge), then I 
> > remain convinced that this should be set via platform data. This is not 
> > something that should be negotiated since this depends not only on the 
sensor 
> > and host devices, but also on the routing of the lines between them on the 
> > actual board, how much noise there is on those lines, the quality of the 
clock 
> > signal, etc. Not really an issue with PAL/NTSC type signals, but when you 
get 
> > to 1080p60 and up, then such things become much more important.
> 
> I understand this, but my point is: forcing this parameters in the 
> platform data doesn't give you any _practical_ enhancements, only 
> _psychological_, meaning, that you think, that if these parameters are 
> compulsory, programmers, writing board integration code, will be forced to 
> think, what values to configure. Whereas if this is not compulsory, 
> programmers will hope on automagic and things will break. So, this is 
> purely psychological. And that's the whole question - fo we trust 
> programmers, that they will anyway take care to set correct parameters, or 
> do we not trust them and therefore want to punish everyone because of 
> them. Besides, I'm pretty convinced, that even if those parameters will be 
> compulsory, most programmers will anyway just copy-paste them from 
> "similar" set ups...

First of all, I don't trust myself, let alone someone else :-)

So forcing people to think about it is a good thing in my mind.

Secondly, if we rely on negotiations, then someone at some time might change 
things and suddenly the negotiation gives different results which may not work 
on some boards. And such bugs can be extremely hard to track down. So that is 
why I don't want to rely on negotiations of these settings. People are free to 
copy and paste, though. I assume (and hope) that they will test before sending 
a patch, so if it works with the copy-and-pasted settings, then that's good 
enough for me.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
> > So these settings should not be negotiated, but set explicitly.
> > 
> > It actually doesn't have to be done through platform data (although that 
makes 
> > the most sense), as long as it is explicitly set based on board-specific 
data.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > 
> > > Thanks
> > > Guennadi
> > > 
> > > > ---
> > > > It tries to create a common API for getting the sensor interface type
> > > > - serial or parallel, modes and interface clocks. The interface clocks
> > > > then are used in the host side to calculate it's configuration, check
> > > > that the clocks are not beyond host limitations etc.
> > > > 
> > > > "phy_rate" in serial interface (CSI DDR clk) is used to calculate
> > > > the CSI2 PHY receiver timing parameters: ths_settle, ths_term,
> > > > clk_settle and clk_term.
> > > > 
> > > > As the "phy_rate" depends on current sensor mode (configuration of the
> > > > sensor's PLL and internal clock domains) it can be treated as dynamic
> > > > parameter and can vary (could be different for viewfinder and still 
> > > > capture), in this context g_interface_parms should be called after
> > > > s_fmt.
> > > > 
> > > > "pix_clk" for parallel interface reflects the current sensor pixel
> > > > clock. With this clock the image data is clocked out of the sensor.
> > > > 
> > > > "pix_clk" for serial interface reflects the current sensor pixel
> > > > clock at which image date is read from sensor matrix.
> > > > 
> > > > "lanes" for serial interface reflects the number of PHY lanes used 
from
> > > > the sensor to output image data. This should be known from the host
> > > > side before the streaming is started. For some sensor modes it's
> > > > enough to use one lane, for bigger resolutions two lanes and more
> > > > are used.
> > > > 
> > > > "channel" for serial interface is also needed from host side to
> > > > configure it's PHY receiver at particular virtual channel.
> > > > 
> > > > ---
> > > > Some background and inspiration.
> > > > 
> > > > - Currently in the OMAP3 ISP driver we use a set of platform data
> > > > callbacks to provide the above parameters and this comes to very
> > > > complicated platform code, driver implementation and unneeded 
> > > > sensor driver <-> host driver dependences. 
> > > > 
> > > > - In the present time we seeing growing count of sensor drivers and
> > > > host (bridge) drivers but without standard API's for communication.
> > > > Currently the subdev sensor operations have only one operation -
> > > > g_skip_top_lines.
> > > > 
> > > > Stanimir Varbanov (1):
> > > >   v4l: Introduce sensor operation for getting interface configuration
> > > > 
> > > >  include/media/v4l2-subdev.h |   42 
> > ++++++++++++++++++++++++++++++++++++++++++
> > > >  1 files changed, 42 insertions(+), 0 deletions(-)
> > > > 
> > > 
> > > ---
> > > Guennadi Liakhovetski, Ph.D.
> > > Freelance Open-Source Software Developer
> > > http://www.open-technology.de/
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" 
in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
> 
