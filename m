Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:44588 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbZEVQoT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 12:44:19 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC 09/10 v2] v4l2-subdev: re-add s_standby to v4l2_subdev_core_ops
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
	<Pine.LNX.4.64.0905151907460.4658@axis700.grange>
	<200905211533.34827.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0905221611160.4418@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 22 May 2009 18:44:06 +0200
In-Reply-To: <Pine.LNX.4.64.0905221611160.4418@axis700.grange> (Guennadi Liakhovetski's message of "Fri\, 22 May 2009 16\:23\:36 +0200 \(CEST\)")
Message-ID: <873aaxxf3d.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> Usual question: why do you need an init and halt? What do they do?
>
> Hm, maybe you're right, I don't need them. init() was used in soc_camera 
> drivers on first open() to possibly reset the chip and put it in some 
> reasonably pre-defined low-power state. But we can do this at the end of 
> probe(), which even would be more correct, because even the first open 
> should not change chip's configuration. And halt() (was called release() 
> originally) is called on last close(). And it seems you shouldn't really 
> do this at all - the chip should preserve its configuration between 
> open/close cycles. Am I right?


> Does anyone among cc'ed authors have any objections against this change? The
> actual disable should indeed migrate to some PM functions, if implemented.
If I understand correctly, what was done before was that on last close, the
sensor was disabled (through sensor->release() call). What will be done now is
leave the sensor on.

On an embedded system, the power eaten by an active sensor is usually too much
compared to the other components.

So, if there is a solution which enables, on last close, to power down the
device (or put it in low power mode), in the new API, I'm OK, even if it's a new
powersaving function. If there is no such function and there will be a gap
(let's say kernel 2.6.31 to 2.6.35) where the sensor will be left activated all
the time, then I'm against.

Let me be even more precise about a usecase :
 - a user takes a picture with his smartphone
 - the same user then uses his phone to call his girlfriend
 - the girlfriend has a lot of things to say, it lasts for 1 hour
In that case, the sensor _has_ to be switched off.

Cheers.

--
Robert
