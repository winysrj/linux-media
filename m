Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:60903 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753016Ab0H0PLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 11:11:01 -0400
Date: Fri, 27 Aug 2010 17:11:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH 04/11] mt9m111: added new bit offset defines
In-Reply-To: <1280833069-26993-5-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008271710400.28043@axis700.grange>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280833069-26993-5-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 3 Aug 2010, Michael Grzeschik wrote:

> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

I don't see these being used in any of your patches...

Thanks
Guennadi

> ---
>  drivers/media/video/mt9m111.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index 8c076e5..1b21522 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -63,6 +63,12 @@
>  #define MT9M111_RESET_RESTART_FRAME	(1 << 1)
>  #define MT9M111_RESET_RESET_MODE	(1 << 0)
>  
> +#define MT9M111_RM_FULL_POWER_RD	(0 << 10)
> +#define MT9M111_RM_LOW_POWER_RD		(1 << 10)
> +#define MT9M111_RM_COL_SKIP_4X		(1 << 5)
> +#define MT9M111_RM_ROW_SKIP_4X		(1 << 4)
> +#define MT9M111_RM_COL_SKIP_2X		(1 << 3)
> +#define MT9M111_RM_ROW_SKIP_2X		(1 << 2)
>  #define MT9M111_RMB_MIRROR_COLS		(1 << 1)
>  #define MT9M111_RMB_MIRROR_ROWS		(1 << 0)
>  #define MT9M111_CTXT_CTRL_RESTART	(1 << 15)
> -- 
> 1.7.1
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
