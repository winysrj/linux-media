Return-path: <mchehab@localhost>
Received: from smtp6-g21.free.fr ([212.27.42.6]:38796 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab0IEQoo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 12:44:44 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH v2 11/11] mt9m111: make use of testpattern
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
	<1280833069-26993-12-git-send-email-m.grzeschik@pengutronix.de>
	<8762ytmk57.fsf@free.fr>
	<Pine.LNX.4.64.1008291954470.2987@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 05 Sep 2010 18:44:35 +0200
In-Reply-To: <Pine.LNX.4.64.1008291954470.2987@axis700.grange> (Guennadi Liakhovetski's message of "Sun\, 29 Aug 2010 20\:35\:19 +0200 \(CEST\)")
Message-ID: <87d3ssw364.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Yes, but this has another disadvantage - if you do not use s_register / 
> g_register, maybe you just have CONFIG_VIDEO_ADV_DEBUG off, then, once you 
> load the module with the testpattern parameter, you cannot switch using 
> testpatterns off again (without a reboot or a power cycle). With the 
> original version you can load the driver with the parameter set, then 
> unload it, load it without the parameter and testpattern would be cleared. 
> In general, I think, using direct register access is discouraged, 
> especially if there's a way to set the same functionality using driver's 
> supported interfaces.

I agree. If there is a way without debug registers, let's use it.

> Hm, if I'm not mistaken, it has once been mentioned, that these test-patterns
> can be nicely implemented using the S_INPUT ioctl(). Am I right? How about
> that? But we'd need a confirmation for that, I'm not 100% sure.
I can't remember that. But if there is a standard ioctl (as seems to show
videodev2.h), and that its use could mean "camera's input is a testpattern" or
"camera input is the normal optical flow", then we should use it.
If not, the old way with debug registers is the only alternative I see without
having to unload/reload the module (if it's a module and not statically embedded
in the kernel).

Cheers.

--
Robert
