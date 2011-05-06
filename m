Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60220 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1EFOoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 10:44:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH] OMAP3: ISP: Fix unbalanced use of omap3isp_get().
Date: Fri, 6 May 2011 16:45:14 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1304603588-3178-1-git-send-email-javier.martin@vista-silicon.com> <201105051602.49814.laurent.pinchart@ideasonboard.com> <BANLkTik64pqpg3XtnixjtgLHAdP1t81uHg@mail.gmail.com>
In-Reply-To: <BANLkTik64pqpg3XtnixjtgLHAdP1t81uHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105061645.14687.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Friday 06 May 2011 12:42:19 javier Martin wrote:
> Hi Laurent,
> 
> > This won't work. Let's assume the following sequence of events:
> > 
> > - Userspace opens the sensor subdev device node
> > - The sensor driver calls to board code to turn the sensor clock on
> > - Board code calls to the ISP driver to turn XCLK on
> > - The ISP driver calls isp_enable_clocks()
> > ...
> > - Userspace opens an ISP video device node
> > - The ISP driver calls isp_get(), incrementing the reference count
> > - Userspace closes the ISP video device node
> > - The ISP driver calls isp_put(), decrementing the reference count
> > - The reference count reaches 0, the ISP driver calls
> > isp_disable_clocks()
> > 
> > The sensor will then loose its clock, even though the sensor subdev
> > device node is still opened.
> 
> Of course, you are right, I hadn't thought of it this way.
> 
> > Could you please explain why the existing code doesn't work on your
> > hardware ?
> 
> Apparently, it is a mistake related to the sensor driver. Sorry about that.

OK. No worries.

> Just one question.
> As I can see from mt9v032 driver, open callback is used to enable clock and
> close callback is used to disable clock.
> Does this mean that if sensor device node is not held open video won't
> work? i.e, the following wouldn't work since (2) opens the sensor (enables
> clock) and closes it again (disables clock) and (3) only opens CCDC device
> node (enables clock with a wrong setting, since it was
> previously set to 0 by (2) ) :
> 
> (1)  ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1],
> "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> (2)  ./media-ctl -f '"mt9p031 2-0048":0[SGRBG8 320x240], "OMAP3 ISP
> CCDC":1[SGRBG8 320x240]'
> (3)  ./yavta  -f SGRBG8 -s 320x240 -n 4 --capture=100 --skip 3 -F
> `./media-ctl -e "OMAP3 ISP CCDC output"

Clocks are enabled/disabled by the mt9v032_set_power() function, called both 
by the open() and close() handlers and by the ISP driver through the subdev 
core::s_power operation. If the sensor is part of the pipeline, the OMAP3 ISP 
driver will power it up when the output video node is opened. (3) will thus 
power the sensor up.

-- 
Regards,

Laurent Pinchart
