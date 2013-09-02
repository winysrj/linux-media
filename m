Return-path: <linux-media-owner@vger.kernel.org>
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52790 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932098Ab3IBQz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Sep 2013 12:55:58 -0400
Date: Mon, 2 Sep 2013 17:55:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v7] s5k5baf: add camera sensor driver
Message-ID: <20130902165543.GC18206@e106331-lin.cambridge.arm.com>
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
 <20130827091448.GA19893@e106331-lin.cambridge.arm.com>
 <5224BB26.9090902@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224BB26.9090902@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 02, 2013 at 05:21:58PM +0100, Sylwester Nawrocki wrote:
> Hi Mark,

Hi Sylwester,

> 
> On 08/27/2013 11:14 AM, Mark Rutland wrote:
> >> +endpoint node
> >> +-------------
> >> +
> >> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> >> +  video-interfaces.txt. This property can be only used to specify number
> >> +  of data lanes, i.e. the array's content is unused, only its length is
> >> +  meaningful. When this property is not specified default value of 1 lane
> >> +  will be used.
> > 
> > Apologies for having not replied to the last posting, but having looked
> > at the documentation I was provided last time [1], I don't think the
> > values in the data-lanes property should be described as unused. That
> > may be the way the Linux driver functions at present, but it's not how
> > the generic video-interfaces binding documentation describes the
> > property.
> > 
> > If the CSI transmitter hardware doesn't support logical remapping of
> > lanes, then the only valid values for data-lanes would be a contiguous
> > list of lane IDs starting at 1, ending at 4 at most. Valid values for
> > the property would be one of:
> > 
> > data-lanes = <1>;
> > data-lanes = <1>, <2>;
> > data-lanes = <1>, <2>, <3>;
> > data-lanes = <1>, <2>, <3>, <4>;
> > 
> > We can mention the fact the hardware doesn't support remapping of lanes,
> > and therefore the list must start with lane 1 and end with (at most)
> > lane 4. That way a dts will match the generic binding and actually
> > describe the hardware, and it's possible for Linux (or any other OS) to
> > factor out the parsing of data-lanes later as desired.
> > 
> > I don't think we should offer freedom to encode garbage in the dt when
> > we can just as easily encourage more standard use of bindings that will
> > make our lives easier in the long-term.
> 
> I entirely agree, that's a very accurate analysis.
> 
> Presumably the data-lanes property's descriptions could be improved so
> it is said explicitly that array elements 0...N - 1, where N = 4, 
> correspond to logical data lanes 1...N.

That makes sense to me.

> 
> Then considering the values in the data-lanes property, I didn't make
> the description terribly specific about the fact that pool of indexes
> 0...4 is used for the clock lane and 4 data lanes. The values could well
> be H/W specific, but it seems more sensible to enforce common range.
> It may not match exactly with documentation of various hardware. E.g.
> OMAP, see page 1661, register CSI2_COMPLEXIO_CFG [1], uses indexes 
> 1..5 to indicate position of a data lane and 0 is used to mark a lane 
> as unused.

Ah, I see. I guess this boils down to what the "physical indexes"
referred to by the video-interfaces binding actually are. If an
interface may only ever have 5 lanes, then using a logical index sounds
fine. But if we ever have the case where a CSI transmitter has more than
5 lanes (so it could communicate with multiple receviers), then the
value has to become hardware-specific. At that point, we'd possibly need
to define remapping of the clocks too. I'm not that familiar with CSI so
I'm not sure if such a device is possible.

> 
> I think we should have similarly defined value 0 to indicate an unused 
> lane. None of drivers in mainline uses this line remapping feature, so 
> changing meaning of the array values wouldn't presumably have any bad 
> side effects. I'm not sure if it's OK to make a change like this now. 
> IIUC the MIPI CSI-2 standard requires consecutive data lane indexes, 
> so valid set of data lanes could be only: <1>, <1, 2>, <1, 2, 3>, 
> <1, 2, 3, 4>. So there seems to be no issue for MIPI CSI-2. But for 
> future protocols the current convention might not have been flexible 
> enough.

Given that the video-interfaces binding refers to the clock being on
lane 0, I'm not sure it makes sense to reserve this as an unused id --
we'd be saying the lane is the clock to say it's unused, but maybe that
doesn't matter.

Thanks,
Mark.

> 
> > [1] http://www.mipi.org/specifications/camera-interface#CSI2
> 
> [2] http://www.ti.com/general/docs/lit/getliterature.tsp?literatureNumber=swpu231ao&fileType=pdf
 
> --
> Regards,
> Sylwester
> 
