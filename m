Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59472 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2HaTiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 15:38:52 -0400
Message-ID: <504112C7.4060905@gmail.com>
Date: Fri, 31 Aug 2012 21:38:47 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Nicolas THERY <nicolas.thery@st.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
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
Subject: Re: [RFC v4] V4L DT bindings
References: <Pine.LNX.4.64.1208242356051.20710@axis700.grange> <503F8471.5000406@st.com> <503FCB37.5080706@gmail.com> <50405DBF.9000209@st.com>
In-Reply-To: <50405DBF.9000209@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2012 08:46 AM, Nicolas THERY wrote:
> Hello,
> 
> Thanks for the feedback.
> 
> On 2012-08-30 22:21, Sylwester Nawrocki wrote:
>> On 08/30/2012 05:19 PM, Nicolas THERY wrote:
> 
> [snip]
> 
>>> In imx074@0x1a above, the data-lanes property is<1>,<2>.  Is it
>>> reversed here to show that lanes are swapped between the sensor and the
>>> CSI rx?  If not, how to express lane swapping?
>>
>> Yes, this indicates lanes remapping at the receiver.
>>
>> Probably we could make it a single value with length determined by
>> 'bus-width', since we're going to use 'bus-width' for CSI buses as well,
>> (optionally) in addition to 'clock-lanes' and 'data-lanes' ?
> 
> Looks good to me.
> 
> [snip]
> 
>>> How to express that the positive and negative signals of a given
>>> clock/data lane are inversed?  Is it somehow with the hsync-active
>>> property?
>>
>> Hmm, I don't think this is covered in this RFC. hsync-active is mostly
>> intended for the parallel buses. We need to come up with new properties
>> to handle CSI data/clock lane polarity swapping. There was a short
>> discussion about that already:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg41724.html
>>
>>> Actually there may be two positive/negative inversion cases to consider:
>>>
>>> - the positive/negative signals are inversed both in low-power and
>>>     high-speed modes (e.g. physical lines between sensor module and SoC
>>>     are swapped on the PCB);
>>>
>>> - the positive/negative signals are inversed in high-speed mode only
>>>     (the sensor and CSI rx use opposite polarities in high-speed mode).
>>
>> Then is this positive/negative LVDS lines swapping separately configurable
>> in hardware for low-power and high-speed mode ?
> 
> Yes.
> 
>> What is an advantage of it ?
> 
> I suspect our hardware people after years of experience with
> not-so-compliant sensors and weird PCBs have adopted a
> belt-and-suspenders approach and made configurable everything they
> thought could go wrong.
> 
> In the "inversion in high-speed mode only" case, that could be because
> the sensor does not use the standard-specified polarity.

OK, thanks for the clarification.

>> One possible solution would be to have a one to two elements array property,
>> e.g.
>>
>> lanes-polarity =<0 0 0 0 0>,<1 1 1 1 1>;
>>
>> where the first entry would indicate lanes polarity for high speed mode and
>> the second one for low power mode. For receivers/transmitters that don't
>> allow to configure the polarities separately for different bus states there
>> could be just one entry. The width of each element could be determined by
>> value of the 'bus-width' property + 1.
>>
>> Would it make sense ?
> 
> Yes, that looks fine.
> 
> Incidentally is it okay to extend DT nodes with manufacturer-specific
> properties?  I'm asking because our CSI rx supports other esoteric
> lane-related configuration knobs, e.g. for impedance tuning.  We'd like
> to put them in the DT but they probably don't warrant an official
> property.

My understanding is that it's just fine to have uncommon DT properties, 
as long as they describe hardware in OS agnostic way. I believe our goal 
is to define as many common bindings as possible, in order to make it 
possible to have devices from various manufacturers and their drivers 
interworking seamlessly, possibly without a need for S/W interfaces 
modifications. Hence it's useful to list in these discussions as many 
hardware properties, that may seem device-specific at first glance, 
as possible. 

I would expect some share of device specific bindings in most of 
the cases. We're mostly trying to avoid having same things defined 
in different ways.

--

Regards,
Sylwester
