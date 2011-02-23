Return-path: <mchehab@pedra>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:31668 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1BWOQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 09:16:29 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 15:17:22 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1298368924.git.svarbanov@mm-sol.com> <Pine.LNX.4.64.1102231020330.8880@axis700.grange> <A24693684029E5489D1D202277BE894488C57571@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894488C57571@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231517.23055.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, February 23, 2011 15:06:49 Aguirre, Sergio wrote:
> Guennadi and Hans,
> 
> <snip>
> 
> > > The only static data I am concerned about are those that affect signal
> > integrity.
> > > After thinking carefully about this I realized that there is really only
> > one
> > > setting that is relevant to that: the sampling edge. The polarities do
> > not
> > > matter in this.
> 
> I respectfully disagree.
> 
> AFAIK, There is not such thing as sampling edge configuration for MIPI
> Receivers, and the polarities DO matter, since it's a differential
> signal.

The polarities do not matter for a standard parallel bus. I cannot speak for 
MIPI or CSI busses as I have no experience there. So if you say that 
polarities matter for MIPI, then for MIPI those should be specified statically 
as well.

> 
> > 
> > Ok, this is much better! I'm still not perfectly happy having to punish
> > all just for the sake of a couple of broken boards, but I can certainly
> > much better live with this, than with having to hard-code each and every
> > bit. Thanks, Hans!
> > 
> > So, I think, we can proceed with this, let's see the code now, shall we?;)
> > 
> > Currently soc-camera auto-configures the following parameters:
> > 
> > hsync polarity
> > vsync polarity
> > data polarity
> > master / slave mode
> > data bus width
> > pixel clock polarity
> > 
> > (see include/media/soc_camera.h::soc_camera_bus_param_compatible() and
> > drivers/media/video/soc_camera.c::soc_camera_apply_sensor_flags()).
> > Removing the pixclk polarity, the rest we can use as a basis for a new
> > subdev-based implementation.
> 
> Don't we need to move this out from soc_camera and make it available in
> v4l2_subdev ops? (I'm talking about both parallel and the "new" MIPI
> support)
> 
> That way both SoC_Camera, and Media Controller frameworks can use that.

I believe that is the plan, yes.

Regards,

	Hans

> 
> Regards,
> Sergio
> 
> > 
> > Thanks
> > Guennadi
> > 
> > > Unfortunately, if a subdev is set to 'sample at rising edge', then that
> > does
> > > not necessarily mean that the host should sample at the same edge.
> > Depending
> > > on the clock line routing and the integrity of the clock signal the host
> > may
> > > actually have to sample on the other edge. And yes, I've seen this.
> > >
> > > Anyway, this has been discussed to death already. I am very much opposed
> > to
> > > negotiating the sampling edge. During the Helsinki meeting in June last
> > year
> > > we decided to do this via platform data (see section 7 in the meeting
> > > minutes: http://www.linuxtv.org/news.php?entry=2010-06-22.mchehab).
> > >
> > > I will formally NACK attempts to negotiate this. Mauro is of course free
> > to
> > > override me.
> > >
> > > Something simple like this for subdev platform_data might be enough:
> > >
> > > struct v4l2_bus_config {
> > >         /* 0 - sample at falling edge, 1 - sample at rising edge */
> > >         unsigned edge_pclock:1;
> > >         /* 0 - host should use the same sampling edge, 1 - host should
> > use the
> > >            other sampling edge */
> > >         unsigned host_invert_edge_pclock:1;
> > > };
> > >
> > > The host can query the bus configuration and the subdev will return:
> > >
> > > 	edge = host_invert_edge_pclock ? !edge_pclock : edge_pclock;
> > >
> > > We might want to add bits as well to describe whether polarities are
> > inverted.
> > >
> > > This old RFC gives a good overview of the possible polarities:
> > >
> > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg09041.html
> > >
> > > Regards,
> > >
> > > 	Hans
> > >
> > > > I personally like the Stanimir's proposal as the parameters to be
> > negotiated
> > > > are pretty dynamic. Only the number of lanes could be problematic as
> > not all
> > > > lanes might be routed across different boards. Perhaps we should
> > consider specifying
> > > > an AUTO value for some negotiated parameters. Such as in case of an
> > attribute that
> > > > need to be fixed on some boards or can be fully negotiated on others,
> > a fixed
> > > > value or "auto" could be respectively set up in the host's
> > platform_data. This could
> > > > be used to override some parameters in the host driver if needed.
> > > >
> > > > IMHO, as long as we negotiate only dynamic parameters there should be
> > no special
> > > > issues.
> > > >
> > > > Regards,
> > > > Sylwester
> > > >
> > > > > about this if it wasn't for the fact that soc-camera doesn't do this
> > but instead
> > > > > negotiates it. Obviously, it isn't a pleasant prospect having to
> > change all that.
> > > > >
> > > > > Normally this would be enough of an argument for me to just
> > negotiate it. The
> > > > > reason that I don't want this in this particular case is that I know
> > from
> > > > > personal experience that incorrect settings can be extremely hard to
> > find.
> > > > >
> > > > > I also think that there is a reasonable chance that such bugs can
> > happen. Take
> > > > > a scenario like this: someone writes a new host driver. Initially
> > there is only
> > > > > support for positive polarity and detection on the rising edge,
> > because that's
> > > > > what the current board on which the driver was developed supports.
> > This is quite
> > > > > typical for an initial version of a driver.
> > > > >
> > > > > Later someone adds support for negative polarity and falling edge.
> > Suddenly the
> > > > > polarity negotiation on the previous board results in negative
> > instead of positive
> > > > > which was never tested. Now that board starts producing pixel errors
> > every so
> > > > > often. And yes, this type of hardware problems do happen as I know
> > from painful
> > > > > experience.
> > > > >
> > > > > Problems like this are next to impossible to debug without the aid
> > of an
> > > > > oscilloscope, so this isn't like most other bugs that are relatively
> > easy to
> > > > > debug.
> > > > >
> > > > > It is so much easier just to avoid this by putting it in platform
> > data. It's
> > > > > simple, unambiguous and above all, unchanging.
> > > > >
> > > > > Regards,
> > > > >
> > > > > 	Hans
> > > > >
> > > > >>
> > > > >> Thanks
> > > > >> Guennadi
> > > > >> ---
> > > > >> Guennadi Liakhovetski, Ph.D.
> > > > >> Freelance Open-Source Software Developer
> > > > >> http://www.open-technology.de/
> > > > >> --
> > > > >> To unsubscribe from this list: send the line "unsubscribe linux-
> > media" in
> > > > >> the body of a message to majordomo@vger.kernel.org
> > > > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > >>
> > > > >
> > > >
> > > >
> > >
> > > --
> > > Hans Verkuil - video4linux developer - sponsored by Cisco
> > >
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 
