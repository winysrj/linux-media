Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:46133 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab0GaUKN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 16:10:13 -0400
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	p.wiesner@phytec.de
Subject: Re: [PATCH 01/20] mt9m111: Added indication that MT9M131 is supported by this driver
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
	<1280501618-23634-2-git-send-email-m.grzeschik@pengutronix.de>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 31 Jul 2010 22:10:04 +0200
Message-ID: <87d3u31kgz.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Grzeschik <m.grzeschik@pengutronix.de> writes:

> From: Philipp Wiesner <p.wiesner@phytec.de>
>
> Added this info to Kconfig and mt9m111.c, some comment cleanup,
> replaced 'mt9m11x'-statements by clarifications or driver name.
> Driver is fully compatible to mt9m131 which has only additional functions
> compared to mt9m111. Those aren't used anyway at the moment.

<zip>
>  
> -	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
> -

Why this one ? It signals a sensor was successfully detected. Maybe a
replacement from MT9M11x to MT9M1xx would be better ? Or if your real intention
is to remove the message, then transform it to dev_dbg(), and say why you did it
in the commit message.

Cheers.

--
Robert
