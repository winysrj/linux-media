Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:54550 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751097Ab0G3Ph4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 11:37:56 -0400
Date: Fri, 30 Jul 2010 17:38:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, p.wiesner@phytec.de
Subject: Re: [PATCH 00/20] MT9M111/MT9M131
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1007301734540.7194@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael

Thanks for the patches, and for taking care about my holiday - now I will 
definitely not have to be bored, while lying around on tropical beaches of 
Denmark;)

Ok, I will review them, and I hope you realise, this has practically 0 
chance to get into 2.6.36, unless Linus decides to release a couple more 
-rc's. So, I think we shall take our time and prepare these for 2.6.37.

Thanks
Guennadi

On Fri, 30 Jul 2010, Michael Grzeschik wrote:

> Hi everyone,
> 
> the following patchseries was created in a rewrite process of the
> mt9m111 camera driver while it was tested for support of the very
> similar silicon mt9m121. Some patches add functionality like panning or
> test pattern generation or adjust rectengular positioning while others
> do some restructuring. It has been tested as functional. Comments on
> this are very welcome.
> 
> Michael Grzeschik (19):
>   mt9m111: init chip after read CHIP_VERSION
>   mt9m111: register cleanup hex to dec bitoffset
>   mt9m111: added new bit offset defines
>   mt9m111: added default row/col/width/height values
>   mt9m111: changed MAX_{HEIGHT,WIDTH} values to silicon pixelcount
>   mt9m111: changed MIN_DARK_COLS to MT9M131 spec count
>   mt9m111: cropcap use defined default rect properties in defrect
>   mt9m111: cropcap check if type is CAPTURE
>   mt9m111: rewrite make_rect for positioning in debug
>   mt9m111: added mt9m111 format structure
>   mt9m111: s_crop add calculation of output size
>   mt9m111: s_crop check for VIDEO_CAPTURE type
>   mt9m111: added reg_mask function
>   mt9m111: rewrite setup_rect, added soft_crop for smooth panning
>   mt9m111: added more supported BE colour formats
>   mt9m111: rewrite set_pixfmt
>   mt9m111: make use of testpattern in debug mode
>   mt9m111: try_fmt rewrite to use preset values
>   mt9m111: s_fmt make use of try_fmt
> 
> Philipp Wiesner (1):
>   mt9m111: Added indication that MT9M131 is supported by this driver
> 
>  drivers/media/video/Kconfig   |    5 +-
>  drivers/media/video/mt9m111.c |  596 ++++++++++++++++++++++++++---------------
>  2 files changed, 377 insertions(+), 224 deletions(-)
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
