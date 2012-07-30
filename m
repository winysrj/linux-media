Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56252 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2G3VC3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 17:02:29 -0400
Received: by bkwj10 with SMTP id j10so3011515bkw.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2012 14:02:28 -0700 (PDT)
Message-ID: <5016F662.8030807@gmail.com>
Date: Mon, 30 Jul 2012 23:02:26 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] media DT bindings
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange> <5000375B.9060100@gmail.com> <Pine.LNX.4.64.1207161257590.18978@axis700.grange> <5006EB9F.5010408@gmail.com> <20120723121420.GC8302@sirena.org.uk>
In-Reply-To: <20120723121420.GC8302@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2012 02:14 PM, Mark Brown wrote:
> On Wed, Jul 18, 2012 at 07:00:15PM +0200, Sylwester Nawrocki wrote:
> 
>> One possible solution would be to have host/bridge drivers to register
>> a clkdev entry for I2C client device, so it can acquire the clock through
>> just clk_get(). We would have to ensure the clock is not tried to be
>> accessed before it is registered by a bridge. This would require to add
>> clock handling code to all sensor/encoder subdev drivers though..
> 
> If this is done well it could just be a simple callback, and we could
> probably arrange for the framework to just implement the default
> behaviour if the driver doesn't do anything explicit.

I agree, if a clock is bound to a sub-device beforehand it could 
probably be done with just a callback as well. Implementing default 
behaviour at the framework makes a lot of sense too, it could ease 
the conversion process significantly.

> Of couse this is one of those things where we really need the generic
> clock API to be generally available...

Indeed, I hope it won't take too much time before at least some of the
platforms get converted.

--

Thanks,
Sylwester
