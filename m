Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58201 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaG1S7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 14:59:53 -0400
Date: Mon, 28 Jul 2014 20:59:49 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	slongerbeam@gmail.com
Subject: Re: i.MX6 status for IPU/VPU/GPU
Message-ID: <20140728185949.GS13730@pengutronix.de>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Jul 28, 2014 at 06:24:45PM +0200, Jean-Michel Hautbois wrote:
> We have a custom board, based on i.MX6 SoC.
> We are currently using Freescale's release of Linux, but this is a
> 3.10.17 kernel, and several drivers are lacking (adv7611 for instance)
> or badly written (all the MXC part).
> As we want to have nice things :) we would like to use a mainline
> kernel, or at least a tree which can be mainlined.
> 
> It seems (#v4l told me so) that some people (Steeve :) ?) are working
> on a rewriting of the IPU and all DRM part for i.MX6.
> What is the current status (compared to Freescale's release maybe) ?
> And what can we expect in a near future? Maybe, how can we help too ?

Pengutronix is continuously working on mainlining more parts of the
i.MX6 video and graphics subsystem, including the components you have
mentioned. We are posting patches here when they are ready for mainline
review.

Regards,
Robert (for commercial help, please contact me by email)
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
