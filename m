Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:44119 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab0GaU2g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 16:28:36 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	p.wiesner@phytec.de
Subject: Re: [PATCH 01/20] mt9m111: Added indication that MT9M131 is supported by this driver
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
	<1280501618-23634-2-git-send-email-m.grzeschik@pengutronix.de>
	<87d3u31kgz.fsf@free.fr>
	<Pine.LNX.4.64.1007312215080.16769@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 31 Jul 2010 22:28:27 +0200
In-Reply-To: <Pine.LNX.4.64.1007312215080.16769@axis700.grange> (Guennadi Liakhovetski's message of "Sat\, 31 Jul 2010 22\:16\:20 +0200 \(CEST\)")
Message-ID: <878w4r1jmc.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> Why this one ? It signals a sensor was successfully detected. Maybe a
>> replacement from MT9M11x to MT9M1xx would be better ? Or if your real intention
>> is to remove the message, then transform it to dev_dbg(), and say why you did it
>> in the commit message.
>
> Robert, the message is not removed, it is moved into two chip ID switch 
> cases.

Damn, you're right.

I have no other comments on that one, looks good to me.

Cheers.

-- 
Robert
