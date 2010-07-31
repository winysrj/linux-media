Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:53000 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752540Ab0GaUQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 16:16:24 -0400
Date: Sat, 31 Jul 2010 22:16:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	p.wiesner@phytec.de
Subject: Re: [PATCH 01/20] mt9m111: Added indication that MT9M131 is supported
 by this driver
In-Reply-To: <87d3u31kgz.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1007312215080.16769@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280501618-23634-2-git-send-email-m.grzeschik@pengutronix.de>
 <87d3u31kgz.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 31 Jul 2010, Robert Jarzmik wrote:

> Michael Grzeschik <m.grzeschik@pengutronix.de> writes:
> 
> > From: Philipp Wiesner <p.wiesner@phytec.de>
> >
> > Added this info to Kconfig and mt9m111.c, some comment cleanup,
> > replaced 'mt9m11x'-statements by clarifications or driver name.
> > Driver is fully compatible to mt9m131 which has only additional functions
> > compared to mt9m111. Those aren't used anyway at the moment.
> 
> <zip>
> >  
> > -	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
> > -
> 
> Why this one ? It signals a sensor was successfully detected. Maybe a
> replacement from MT9M11x to MT9M1xx would be better ? Or if your real intention
> is to remove the message, then transform it to dev_dbg(), and say why you did it
> in the commit message.

Robert, the message is not removed, it is moved into two chip ID switch 
cases.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
