Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2021 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1BZNjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:39:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Sat, 26 Feb 2011 14:39:11 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102261350.12833.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102261405330.31455@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102261405330.31455@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261439.11538.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, February 26, 2011 14:14:29 Guennadi Liakhovetski wrote:
> On Sat, 26 Feb 2011, Hans Verkuil wrote:
> 
> > On Friday, February 25, 2011 19:23:43 Sakari Ailus wrote:
> > > Hi Guennadi and others,
> > > 
> > > Apologies for the late reply...
> > > 
> > > Guennadi Liakhovetski wrote:
> > > > On Wed, 23 Feb 2011, Hans Verkuil wrote:
> > > > 
> > > >> On Tuesday, February 22, 2011 22:42:58 Sylwester Nawrocki wrote:
> > > >>> Clock values are often being rounded at runtime and do not always reflect exactly
> > > >>> the numbers fixed at compile time. And negotiation could help to obtain exact
> > > >>> values at both sensor and host side.
> > > >>
> > > >> The only static data I am concerned about are those that affect signal integrity.
> > > >> After thinking carefully about this I realized that there is really only one
> > > >> setting that is relevant to that: the sampling edge. The polarities do not
> > > >> matter in this.
> > > > 
> > > > Ok, this is much better! I'm still not perfectly happy having to punish 
> > > > all just for the sake of a couple of broken boards, but I can certainly 
> > > > much better live with this, than with having to hard-code each and every 
> > > > bit. Thanks, Hans!
> > > 
> > > How much punishing would actually take place without autonegotiation?
> > > How many boards do we have in total? I counted around 26 of
> > > soc_camera_link declarations under arch/. Are there more?
> > > 
> > > An example of hardware which does care about clock polarity is the
> > > N8[01]0. The parallel clock polarity is inverted since this actually
> > > does improve reliability. In an ideal hardware this likely wouldn't
> > > happen but sometimes the hardware is not exactly ideal. Both the sensor
> > > and the camera block support non-inverted and inverted clock signal.
> > > 
> > > So at the very least it should be possible to provide this information
> > > in the board code even if both ends share multiple common values for
> > > parameters.
> > > 
> > > There have been many comments on the dangers of the autonegotiation and
> > > I share those concerns. One of my main concerns is that it creates an
> > > unnecessary dependency from all the boards to the negotiation code, the
> > > behaviour of which may not change.
> 
> Sorry, didn't want to comment on this... But to me this sounds like a void 
> argument... Yes, there are _many_ inter-dependencies in the kernel, and if 
> you break code something will stop working... What's new about it??? But 
> no, I do not want to continue this discussion endlessly...
> 
> > OK, let me summarize this and if there are no objections then Stan can start
> > implementing this.
> > 
> > 1) We need two subdev ops: one reports the bus config capabilities and one that
> > sets it up. Note that these ops should be core ops since this functionality is
> > relevant for both sensors and video receive/transmit devices.
> > 
> > 2) The clock sampling edge and polarity should not be negotiated but must be set
> > from board code for both subdevs and host. In the future this might even require
> > a callback with the clock frequency as argument.
> > 
> > 3) We probably need a utility function that given the host and subdev capabilities
> > will return the required subdev/host settings.
> > 
> > 4) soc-camera should switch to these new ops.
> 
> ...remains only to find, who will do this;)
> 
> So, I'm in minority here, if we don't count all those X systems, 
> successfully using soc-camera with its evil auto-negotiation. If you just 
> decide to do this and push the changes - sure, there's nothing I can do 
> against this. But if you decide to postpone a final decision on this until 
> we meet personally and will not have to circulate the same arguments 100 
> times - just because the delay is shorter - maybe we can find a solution, 
> that will keep everyone happy.

No, I am no longer willing to postpone this. Sorry. Discussing this in a
brainstorm meeting or whatever won't bring us any closer. We did that in
the last Helsinki meeting already. Heck, we've gone over this for a year and a
half now, if not more. The arguments haven't changed in all that time. Enough
is enough.

Let Stan implement the new subdev core ops (Stan, please confirm that you can
work on this!), then we can use it in soc-camera for everything except the clock.
The final step will be to remove the clock negotiation from soc-camera.

By the time we are ready for that final step we'll see who can do this. It's
several months in the future anyway.

Regards,

	Hans

> > Of course, we also need MIPI support in this API. The same considerations apply to
> > MIPI as to the parallel bus: settings that depend on the hardware board design
> > should come from board code, others can be negotiated. Since I know next to nothing
> > about MIPI I will leave that to the experts...
> > 
> > One thing I am not sure about is if we want separate ops for parallel bus and MIPI,
> > or if we merge them. I am leaning towards separate ops as I think that might be
> > easier to implement.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
