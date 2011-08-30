Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55405 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab1H3PSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 11:18:53 -0400
Received: by vws1 with SMTP id 1so5460356vws.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 08:18:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108301600020.19151@axis700.grange>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <201108081750.07000.laurent.pinchart@ideasonboard.com> <4E5A2657.7030605@gmail.com>
 <201108291508.59649.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1108300018490.5065@axis700.grange>
 <20110830134148.GA14976@sirena.org.uk> <20110830135609.GC1355@ponder.secretlab.ca>
 <Pine.LNX.4.64.1108301600020.19151@axis700.grange>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 30 Aug 2011 09:18:31 -0600
Message-ID: <CACxGe6tCLJ6F-Rsf=1ENj98YzXHRm9p9xr4-TAiWTHpQbQVOVA@mail.gmail.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devicetree-discuss@lists.ozlabs.org,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 8:03 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Grant
>
> On Tue, 30 Aug 2011, Grant Likely wrote:
>
>> On Tue, Aug 30, 2011 at 02:41:48PM +0100, Mark Brown wrote:
>> > On Tue, Aug 30, 2011 at 12:20:09AM +0200, Guennadi Liakhovetski wrote:
>> > > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
>> >
>> > > > My idea was to let the kernel register all devices based on the DT or board
>> > > > code. When the V4L2 host/bridge driver gets registered, it will then call a
>> > > > V4L2 core function with a list of subdevs it needs. The V4L2 core would store
>> > > > that information and react to bus notifier events to notify the V4L2
>> > > > host/bridge driver when all subdevs are present. At that point the host/bridge
>>
>> Sounds a lot like what ASoC is currently doing.
>>
>> > > > driver will get hold of all the subdevs and call (probably through the V4L2
>> > > > core) their .registered operation. That's where the subdevs will get access to
>> > > > their clock using clk_get().
>> >
>> > > Correct me, if I'm wrong, but this seems to be the case of sensor (and
>> > > other i2c-client) drivers having to succeed their probe() methods without
>> > > being able to actually access the hardware?
>>
>> It indeed sounds like that, which also concerns me.  ASoC and other
>> subsystems have exactly the same problem where the 'device' is
>> actually an aggregate of multiple devices attached to different
>> busses.  My personal opinion is that the best way to handle this is to
>> support deferred probing
>
> Yes, that's also what I think should be done. But I was thinking about a
> slightly different approach - a dependency-based probing. I.e., you should
> be able to register a device, depending on another one (parent?), and only
> after the latter one has successfully probed, the driver core should be
> allowed to probe the child. Of course, devices can depend on multiple
> other devices, so, a single parent might not be enough.

Yes, a dependency system would be lovely... but it gets really complex
in a hurry, especially when faced with heterogeneous device
registrations.  A deferral system ends up being really simple to
implement and probably work just as well.

g.
