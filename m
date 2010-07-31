Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:55095 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab0GaUhB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 16:37:01 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	p.wiesner@phytec.de
Subject: Re: [PATCH 02/20] mt9m111: init chip after read CHIP_VERSION
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
	<1280501618-23634-3-git-send-email-m.grzeschik@pengutronix.de>
	<Pine.LNX.4.64.1007312157200.16769@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 31 Jul 2010 22:36:52 +0200
In-Reply-To: <Pine.LNX.4.64.1007312157200.16769@axis700.grange> (Guennadi Liakhovetski's message of "Sat\, 31 Jul 2010 22\:09\:48 +0200 \(CEST\)")
Message-ID: <874off1j8b.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Fri, 30 Jul 2010, Michael Grzeschik wrote:
>
>> Moved mt9m111_init after the chip version detection passage: I
>> don't like the idea of writing on a device we haven't identified
>> yet.
>
> In principle it's correct, but what do you do, if a chip cannot be probed, 
> before it is initialised / enabled? Actually, this shouldn't be the case, 
> devices should be available for probing without any initialisation. So, we 
> have to ask the original author, whether this really was necessary, 
> Robert?

Michael is right I think.
According to the specification, even before the reset, the control registers can
be read, and they'll return their current values, which can be weird before
reset, excepting the CHIP_VERSION which is hard coded.

Therefore I think Michael is right by reading chip version before doing the
reset, and I ack this patch.

Cheers.

-- 
Robert
