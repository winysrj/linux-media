Return-path: <linux-media-owner@vger.kernel.org>
Received: from [216.32.180.188] ([216.32.180.188]:19256 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753091Ab2JJJVG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 05:21:06 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: AW: omap3-isp-live does not allocate big enough buffers?
Date: Wed, 10 Oct 2012 09:19:37 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E85467100659AB@AM2PRD0710MB375.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E8546710061917@AM2PRD0710MB375.eurprd07.prod.outlook.com>
 <2456438.fJBUg8mpFd@avalon>
In-Reply-To: <2456438.fJBUg8mpFd@avalon>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for your fast answer. 

Laurent Pinchart wrote on 2012-10-08:

> The OMAP3 ISP resizer can't scale down 1944 pixels (the native sensor
> height) to exactly 480 pixels as that would exceed the resizer limits.
> You will thus have to crop the sensor image slightly. Cropping is
> supported by libomap3isp and by the snapshot application but not by the live application.
> Ideally the live application or the libomap3isp library should realize
> that the ISP limits are exceeded and configure cropping on the sensor
> accordingly. As an interim solution you could add manual crop support
> to the live application using the snapshot application crop support code as an example.

I have seen, that the resizer "only" supports downscaling by 0.25, so with all the cropping, 1944 lines will come down to 482 which is too big for my framebuffer.
If I apply some cropping in the omap3_isp_viewfinder_setup function, the output will work as expected.
Now I'm going to crop on the sensor (or better on the first entity that supports cropping, as in your code) if the ratio "sensor input -> viewfinder output" exceeds 0.25. Are you interested in a patch for this?

Regards,
Florian



