Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49319 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab2JJUXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 16:23:41 -0400
Message-ID: <5075D947.3080903@gmail.com>
Date: Wed, 10 Oct 2012 22:23:35 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <5073FDC8.8090909@samsung.com> <201210091300.24124.hverkuil@xs4all.nl> <1398413.j3yGqyN4Du@avalon>
In-Reply-To: <1398413.j3yGqyN4Du@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/10/2012 03:25 PM, Laurent Pinchart wrote:
> On Tuesday 09 October 2012 13:00:24 Hans Verkuil wrote:
>> On Tue 9 October 2012 12:34:48 Sylwester Nawrocki wrote:
>>> On 10/08/2012 11:40 AM, Guennadi Liakhovetski wrote:
>>>> On Fri, 5 Oct 2012, Sylwester Nawrocki wrote:
>>>>> I would really like to see more than one user until we add any core
>>>>> code. No that it couldn't be changed afterwards, but it would be nice
>>>>> to ensure the concepts are right and proven in real life.
>>>>
>>>> Unfortunately I don't have any more systems on which I could easily
>>>> enough try this. I've got a beagleboard with a camera, but I don't think
>>>> I'm a particularly good candidate for implementing DT support for OMAP3
>>>> camera drivers;-) Apart from that I've only got soc-camera based
>>>> systems, of which none are _really_ DT-ready... At best I could try an
>>>> i.MX31 based board, but that doesn't have a very well developed .dts and
>>>> that would be soc-camera too anyway.
>>>
>>> I certainly wouldn't expect you would do all the job. I mean it would be
>>> good to possibly have some other developers adding device tree support
>>> based on that new bindings and new infrastructure related to them.
> 
> As I mentioned in another e-mail, I plan to work on DT support for the OMAP3
> ISP, but I first need generic clock framework support for OMAP3.

OK, let's hope it's available soon.

>>> There have been recently some progress in device tree support for Exynos
>>> SoCs, including common clock framework support and we hope to add FDT
>>> support to the Samsung SoC camera devices during this kernel cycle, based
>>> on the newly designed media bindings. This is going to be a second
>>> attempt, after our initial RFC from May [1]. It would still be SoC
>>> specific implementation, but not soc-camera based.
>>>
>>> I wasn't a big fan of this asynchronous sub-devices probing, but it now
>>> seems to be a most complete solution to me. I think it just need to be
>>> done right at the v4l2-core so individual drivers don't get complicated
>>> too much.
>>
>> After investigating this some more I think I agree with that. There are some
>> things where we should probably ask for advice from the i2c subsystem devs,
>> I'm thinking of putting the driver back into the deferred-probe state in
>> particular.
> 
> We might actually not need that, it might be easier to handle the circular
> dependency problem from the other end. We could add a way (ioctl, sysfs, ...)
> to force a V4L2 bridge driver to release its subdevs. Once done, the subdev
> driver could be unloaded and/or the subdev device unregistered, which would
> release the resources used by the subdev, such as clocks. The bridge driver
> could then be unregistered.

That sounds like an option. Perhaps it could be done by v4l2-core, e.g. a sysfs 
entry could be registered for a media or video device if driver requests it.
I'm not sure if we should allow subdevs in "released" state, perhaps it's better
to just unregister subdevs entirely right away ?

>> Creating v4l2-core support for this is crucial as it is quite complex and
>> without core support this is going to be a nightmare for drivers.

--

Regards,
Sylwester
