Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44886 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1BZOpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 09:45:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Sat, 26 Feb 2011 15:45:02 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <4D67F3AF.7060808@maxwell.research.nokia.com> <201102261350.12833.hverkuil@xs4all.nl>
In-Reply-To: <201102261350.12833.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261545.03396.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Saturday 26 February 2011 13:50:12 Hans Verkuil wrote:
> On Friday, February 25, 2011 19:23:43 Sakari Ailus wrote:
> > Guennadi Liakhovetski wrote:
> > > On Wed, 23 Feb 2011, Hans Verkuil wrote:
> > >> On Tuesday, February 22, 2011 22:42:58 Sylwester Nawrocki wrote:
> > >>> Clock values are often being rounded at runtime and do not always
> > >>> reflect exactly the numbers fixed at compile time. And negotiation
> > >>> could help to obtain exact values at both sensor and host side.
> > >> 
> > >> The only static data I am concerned about are those that affect signal
> > >> integrity. After thinking carefully about this I realized that there
> > >> is really only one setting that is relevant to that: the sampling
> > >> edge. The polarities do not matter in this.
> > > 
> > > Ok, this is much better! I'm still not perfectly happy having to punish
> > > all just for the sake of a couple of broken boards, but I can certainly
> > > much better live with this, than with having to hard-code each and
> > > every bit. Thanks, Hans!
> > 
> > How much punishing would actually take place without autonegotiation?
> > How many boards do we have in total? I counted around 26 of
> > soc_camera_link declarations under arch/. Are there more?
> > 
> > An example of hardware which does care about clock polarity is the
> > N8[01]0. The parallel clock polarity is inverted since this actually
> > does improve reliability. In an ideal hardware this likely wouldn't
> > happen but sometimes the hardware is not exactly ideal. Both the sensor
> > and the camera block support non-inverted and inverted clock signal.
> > 
> > So at the very least it should be possible to provide this information
> > in the board code even if both ends share multiple common values for
> > parameters.
> > 
> > There have been many comments on the dangers of the autonegotiation and
> > I share those concerns. One of my main concerns is that it creates an
> > unnecessary dependency from all the boards to the negotiation code, the
> > behaviour of which may not change.
> 
> OK, let me summarize this and if there are no objections then Stan can
> start implementing this.
> 
> 1) We need two subdev ops: one reports the bus config capabilities and one
> that sets it up. Note that these ops should be core ops since this
> functionality is relevant for both sensors and video receive/transmit
> devices.

Could you elaborate on this ? Stan's original proposal is to report the subdev 
configuration so that the host can configure itself at streamon time. Why do 
we need an operation to setup the subdev ?

> 2) The clock sampling edge and polarity should not be negotiated but must
> be set from board code for both subdevs and host. In the future this might
> even require a callback with the clock frequency as argument.
> 
> 3) We probably need a utility function that given the host and subdev
> capabilities will return the required subdev/host settings.
> 
> 4) soc-camera should switch to these new ops.
> 
> Of course, we also need MIPI support in this API. The same considerations
> apply to MIPI as to the parallel bus: settings that depend on the hardware
> board design should come from board code, others can be negotiated. Since
> I know next to nothing about MIPI I will leave that to the experts...
> 
> One thing I am not sure about is if we want separate ops for parallel bus
> and MIPI, or if we merge them. I am leaning towards separate ops as I
> think that might be easier to implement.

-- 
Regards,

Laurent Pinchart
