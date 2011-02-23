Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:52629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWJby (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 04:31:54 -0500
Date: Wed, 23 Feb 2011 10:31:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sylwester Nawrocki <snjw23@gmail.com>, Stan <svarbanov@mm-sol.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	saaguirre@ti.com
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <201102230910.43069.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <201102221800.49914.hverkuil@xs4all.nl> <4D642DE2.3090705@gmail.com>
 <201102230910.43069.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 23 Feb 2011, Hans Verkuil wrote:

> On Tuesday, February 22, 2011 22:42:58 Sylwester Nawrocki wrote:
> > Hi everybody,
> > 
> > On 02/22/2011 06:00 PM, Hans Verkuil wrote:
> > > On Tuesday, February 22, 2011 17:27:47 Guennadi Liakhovetski wrote:
> > >> On Tue, 22 Feb 2011, Stan wrote:
> > >>
> > >>> In principle I agree with this bus negotiation.
> > >>>
> > >>>   - So. let's start thinking how this could be fit to the subdev sensor
> > >>> operations.
> > >>
> > >> Well, I'm afraid not everyone is convinced yet, so, it is a bit early to
> > >> start designing interfaces;)
> > >>
> > >>>   - howto isolate your current work into some common place and reuse it,
> > >>> even on platform part.
> > >>>   - and is it possible.
> > >>>
> > >>> The discussion becomes very emotional and this is not a good adviser :)
> > >>
> > >> No, no emotions at least on this side:) But it's also not technical,
> > >> unfortunately. I'm prepared to discuss technical benefits or drawbacks of
> > >> each of these approaches, but these arguments - can we trust programmers
> > >> or can we not? or will anyone at some time in the future break it or not?
> > >> Sorry, I am not a psychologist:) Personally, I would _exclusively_
> > >> consider technical arguments. Of course, things like "clean and simple
> > >> APIs," "proper separation / layering" etc. are also important, but even
> > >> they already can become difficult to discuss and are already on the border
> > >> between technical issues and personal preferences... So, don't know, in
> > >> the end, I think, it will just come down to who is making decisions and
> > >> who is implementing them:) I just expressed my opinion, we don't have to
> > >> agree, eventually, the maintainer will decide whether to apply patches or
> > >> not:)
> > > 
> > > In my view at least it *is* a technical argument. It makes perfect sense to
> > > me from a technical point of view to put static, board-specific configuration
> > > in platform_data. I don't think there would have been much, if any, discussion
> > 
> > We should not be forgetting that there often will be two or more sets 
> > of platform_data. For sensor, MIPI interface, for the host interface driver.. 
> > By negotiating setups we could avoid situations when corresponding parameters
> > are not matched. That is not so meaningful benefit though. 
> >
> > Clock values are often being rounded at runtime and do not always reflect exactly
> > the numbers fixed at compile time. And negotiation could help to obtain exact
> > values at both sensor and host side.
> 
> The only static data I am concerned about are those that affect signal integrity.
> After thinking carefully about this I realized that there is really only one
> setting that is relevant to that: the sampling edge. The polarities do not
> matter in this.

Ok, this is much better! I'm still not perfectly happy having to punish 
all just for the sake of a couple of broken boards, but I can certainly 
much better live with this, than with having to hard-code each and every 
bit. Thanks, Hans!

So, I think, we can proceed with this, let's see the code now, shall we?;)

Currently soc-camera auto-configures the following parameters:

hsync polarity
vsync polarity
data polarity
master / slave mode
data bus width
pixel clock polarity

(see include/media/soc_camera.h::soc_camera_bus_param_compatible() and 
drivers/media/video/soc_camera.c::soc_camera_apply_sensor_flags()). 
Removing the pixclk polarity, the rest we can use as a basis for a new 
subdev-based implementation.

Thanks
Guennadi

> Unfortunately, if a subdev is set to 'sample at rising edge', then that does
> not necessarily mean that the host should sample at the same edge. Depending
> on the clock line routing and the integrity of the clock signal the host may
> actually have to sample on the other edge. And yes, I've seen this.
> 
> Anyway, this has been discussed to death already. I am very much opposed to
> negotiating the sampling edge. During the Helsinki meeting in June last year
> we decided to do this via platform data (see section 7 in the meeting
> minutes: http://www.linuxtv.org/news.php?entry=2010-06-22.mchehab).
> 
> I will formally NACK attempts to negotiate this. Mauro is of course free to
> override me.
> 
> Something simple like this for subdev platform_data might be enough:
> 
> struct v4l2_bus_config {
>         /* 0 - sample at falling edge, 1 - sample at rising edge */
>         unsigned edge_pclock:1;
>         /* 0 - host should use the same sampling edge, 1 - host should use the
>            other sampling edge */
>         unsigned host_invert_edge_pclock:1;
> };
> 
> The host can query the bus configuration and the subdev will return:
> 
> 	edge = host_invert_edge_pclock ? !edge_pclock : edge_pclock;
> 
> We might want to add bits as well to describe whether polarities are inverted.
> 
> This old RFC gives a good overview of the possible polarities:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg09041.html
> 
> Regards,
> 
> 	Hans
> 
> > I personally like the Stanimir's proposal as the parameters to be negotiated
> > are pretty dynamic. Only the number of lanes could be problematic as not all
> > lanes might be routed across different boards. Perhaps we should consider specifying
> > an AUTO value for some negotiated parameters. Such as in case of an attribute that
> > need to be fixed on some boards or can be fully negotiated on others, a fixed
> > value or "auto" could be respectively set up in the host's platform_data. This could
> > be used to override some parameters in the host driver if needed.
> > 
> > IMHO, as long as we negotiate only dynamic parameters there should be no special
> > issues.
> > 
> > Regards,
> > Sylwester 
> > 
> > > about this if it wasn't for the fact that soc-camera doesn't do this but instead
> > > negotiates it. Obviously, it isn't a pleasant prospect having to change all that.
> > > 
> > > Normally this would be enough of an argument for me to just negotiate it. The
> > > reason that I don't want this in this particular case is that I know from
> > > personal experience that incorrect settings can be extremely hard to find.
> > > 
> > > I also think that there is a reasonable chance that such bugs can happen. Take
> > > a scenario like this: someone writes a new host driver. Initially there is only
> > > support for positive polarity and detection on the rising edge, because that's
> > > what the current board on which the driver was developed supports. This is quite
> > > typical for an initial version of a driver.
> > > 
> > > Later someone adds support for negative polarity and falling edge. Suddenly the
> > > polarity negotiation on the previous board results in negative instead of positive
> > > which was never tested. Now that board starts producing pixel errors every so
> > > often. And yes, this type of hardware problems do happen as I know from painful
> > > experience.
> > > 
> > > Problems like this are next to impossible to debug without the aid of an
> > > oscilloscope, so this isn't like most other bugs that are relatively easy to
> > > debug.
> > > 
> > > It is so much easier just to avoid this by putting it in platform data. It's
> > > simple, unambiguous and above all, unchanging.
> > > 
> > > Regards,
> > > 
> > > 	Hans
> > > 
> > >>
> > >> Thanks
> > >> Guennadi
> > >> ---
> > >> Guennadi Liakhovetski, Ph.D.
> > >> Freelance Open-Source Software Developer
> > >> http://www.open-technology.de/
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>
> > > 
> > 
> > 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by Cisco
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
