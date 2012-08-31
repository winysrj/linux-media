Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:49103 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab2HaGqu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 02:46:50 -0400
From: Nicolas THERY <nicolas.thery@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Benjamin GAIGNARD <benjamin.gaignard@st.com>,
	Willy POISSON <willy.poisson@st.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>
Date: Fri, 31 Aug 2012 08:46:23 +0200
Subject: Re: [RFC v4] V4L DT bindings
Message-ID: <50405DBF.9000209@st.com>
References: <Pine.LNX.4.64.1208242356051.20710@axis700.grange>
 <503F8471.5000406@st.com> <503FCB37.5080706@gmail.com>
In-Reply-To: <503FCB37.5080706@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Thanks for the feedback.

On 2012-08-30 22:21, Sylwester Nawrocki wrote:
> On 08/30/2012 05:19 PM, Nicolas THERY wrote:

[snip]

>> In imx074@0x1a above, the data-lanes property is<1>,<2>.  Is it
>> reversed here to show that lanes are swapped between the sensor and the
>> CSI rx?  If not, how to express lane swapping?
> 
> Yes, this indicates lanes remapping at the receiver.
> 
> Probably we could make it a single value with length determined by
> 'bus-width', since we're going to use 'bus-width' for CSI buses as well, 
> (optionally) in addition to 'clock-lanes' and 'data-lanes' ?

Looks good to me.

[snip]

>> How to express that the positive and negative signals of a given
>> clock/data lane are inversed?  Is it somehow with the hsync-active
>> property?
> 
> Hmm, I don't think this is covered in this RFC. hsync-active is mostly
> intended for the parallel buses. We need to come up with new properties
> to handle CSI data/clock lane polarity swapping. There was a short
> discussion about that already:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg41724.html
> 
>> Actually there may be two positive/negative inversion cases to consider:
>>
>> - the positive/negative signals are inversed both in low-power and
>>    high-speed modes (e.g. physical lines between sensor module and SoC
>>    are swapped on the PCB);
>>
>> - the positive/negative signals are inversed in high-speed mode only
>>    (the sensor and CSI rx use opposite polarities in high-speed mode).
> 
> Then is this positive/negative LVDS lines swapping separately configurable
> in hardware for low-power and high-speed mode ? 

Yes.

> What is an advantage of it ?

I suspect our hardware people after years of experience with
not-so-compliant sensors and weird PCBs have adopted a
belt-and-suspenders approach and made configurable everything they
thought could go wrong.

In the "inversion in high-speed mode only" case, that could be because
the sensor does not use the standard-specified polarity.

> One possible solution would be to have a one to two elements array property,
> e.g.
> 
> lanes-polarity = <0 0 0 0 0>, <1 1 1 1 1>;
> 
> where the first entry would indicate lanes polarity for high speed mode and
> the second one for low power mode. For receivers/transmitters that don't
> allow to configure the polarities separately for different bus states there
> could be just one entry. The width of each element could be determined by 
> value of the 'bus-width' property + 1.
> 
> Would it make sense ?

Yes, that looks fine.

Incidentally is it okay to extend DT nodes with manufacturer-specific
properties?  I'm asking because our CSI rx supports other esoteric
lane-related configuration knobs, e.g. for impedance tuning.  We'd like
to put them in the DT but they probably don't warrant an official
property.

Thanks a lot again.

Best regards,
Nicolas