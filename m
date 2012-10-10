Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60408 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2JJVNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 17:13:00 -0400
Message-ID: <5075E4D7.4010706@gmail.com>
Date: Wed, 10 Oct 2012 23:12:55 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <5073FDC8.8090909@samsung.com> <201210091300.24124.hverkuil@xs4all.nl> <1398413.j3yGqyN4Du@avalon> <5075D947.3080903@gmail.com> <Pine.LNX.4.64.1210102229200.31291@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210102229200.31291@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/2012 10:32 PM, Guennadi Liakhovetski wrote:
>>> We might actually not need that, it might be easier to handle the circular
>>> dependency problem from the other end. We could add a way (ioctl, sysfs, ...)
>>> to force a V4L2 bridge driver to release its subdevs. Once done, the subdev
>>> driver could be unloaded and/or the subdev device unregistered, which would
>>> release the resources used by the subdev, such as clocks. The bridge driver
>>> could then be unregistered.
>>
>> That sounds like an option. Perhaps it could be done by v4l2-core, e.g. a sysfs
>> entry could be registered for a media or video device if driver requests it.
>> I'm not sure if we should allow subdevs in "released" state, perhaps it's better
>> to just unregister subdevs entirely right away ?
> 
> What speaks against holding a clock reference only during streaming, or at
> least between open and close? Wouldn't that solve the problem naturally?
> Yes, after giving up your reference to a clock at close() and re-acquiring
> it at open() you will have to make sure the frequency hasn't change, resp.
> adjust it, but I don't see it as a huge problem, I don't think many users
> on embedded systems will compete for your camera master clock. And if they
> do, you have a different problem, IMHO;-)

I agree, normally nobody should touch these clocks except the subdev (or as of 
now the host) drivers. It depends on a sensor, video encoder, etc. how much it 
tolerates switching the clock on/off. I suppose it's best to acquire/release it
in .s_power callback, since only then the proper voltage supply, GPIO, clock 
enable/disable sequences could be ensured. I know those things are currently 
mostly ignored, but some sensors might be picky WRT their initialization/shutdown
sequences and it would be good to ensure these sequences are fully controllable 
by the sensor driver itsels, where the host's architecture allows that.

To summarize, I can't see how holding a clock only when a device is active
could cause any problems, in case of camera sensors. I'm not sure about other
devices, like e.g. tuners.

--

Regards,
Sylwester
