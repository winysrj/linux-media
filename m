Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60335 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2JESbF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 14:31:05 -0400
Message-ID: <506F2763.6050808@gmail.com>
Date: Fri, 05 Oct 2012 20:30:59 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1210021142210.15778@axis700.grange> <506ABE40.9070504@samsung.com> <201210051241.52205.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2012 12:58 PM, Guennadi Liakhovetski wrote:
>> One area that I do not yet completely understand is the i2c bus notifications
>> (or asynchronous loading of i2c modules).
>>
>> I would have expected that using OF the i2c devices are still initialized
>> before the host/bridge driver is initialized. But I gather that's not the
>> case?
> 
> No, it's not. I'm not sure, whether it depends on the order of devices in
> the .dts, but, I think, it's better to not have to mandate a certain order
> and I also seem to have seen devices being registered in different order
> with the same DT, but I'm not 100% sure about that.

The device instantiation (and initialization) order is not something that
is supposed to be ensured by a specific device tree source layout, IIUC.
The initialization sequence is probably something that is specific to a
particular operating system. I checked the device tree compiler but couldn't
find if it is free to reorder anything when converting from the human 
readable device tree to its binary representation.

The deferred probing was introduced in Linux to resolve resource 
inter-dependencies in case of FDT based booting AFAIK.

>> If this deferred probing is a general problem, then I think we need a general
>> solution as well that's part of the v4l2 core.
> 
> That can be done, perhaps. But we can do it as a next step. As soon as
> we're happy with the OF implementation as such, we can commit that,
> possibly leaving soc-camera patches out for now, then we can think where
> to put async I2C handling.

I would really like to see more than one user until we add any core code.
No that it couldn't be changed afterwards, but it would be nice to ensure 
the concepts are right and proven in real life.

--

Regards,
Sylwester
