Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:46004 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0GaUv0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 16:51:26 -0400
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	p.wiesner@phytec.de
Subject: Re: [PATCH 06/20] mt9m111: changed MAX_{HEIGHT,WIDTH} values to silicon pixelcount
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
	<1280501618-23634-7-git-send-email-m.grzeschik@pengutronix.de>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 31 Jul 2010 22:51:17 +0200
In-Reply-To: <1280501618-23634-7-git-send-email-m.grzeschik@pengutronix.de> (Michael Grzeschik's message of "Fri\, 30 Jul 2010 16\:53\:24 +0200")
Message-ID: <87r5ijz86y.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Grzeschik <m.grzeschik@pengutronix.de> writes:

> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mt9m111.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index 5f0c55e..2080615 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -131,8 +131,8 @@
>  
>  #define MT9M111_MIN_DARK_ROWS	8
>  #define MT9M111_MIN_DARK_COLS	24
> -#define MT9M111_MAX_HEIGHT	1024
> -#define MT9M111_MAX_WIDTH	1280
> +#define MT9M111_MAX_HEIGHT	1032
> +#define MT9M111_MAX_WIDTH	1288

If we're going down that path, my specification says in chapter "Pixel Data
Format/Pixel Array Structure" that there are :
 - 1289 optical active pixels in width
 - 1033 optical active pixels in height

So why don't we use the real values here ?

Cheers.

--
Robert
