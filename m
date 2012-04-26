Return-path: <linux-media-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:40634 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab2DZUNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 16:13:17 -0400
From: Chris Ball <cjb@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] marvell-cam: fix an ARM build error
References: <20120420102250.1389bca8@lwn.net>
Date: Thu, 26 Apr 2012 16:13:37 -0400
In-Reply-To: <20120420102250.1389bca8@lwn.net> (Jonathan Corbet's message of
	"Fri, 20 Apr 2012 10:22:50 -0600")
Message-ID: <878vhi9rpq.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Apr 20 2012, Jonathan Corbet wrote:
> One of the OLPC changes lost a little in its translation to mainline,
> leading to build errors on the ARM architecture.  Remove the offending
> line, and all will be well.
>
> Reported-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
>
> diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
> index d235523..c4c17fe 100644
> --- a/drivers/media/video/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/video/marvell-ccic/mmp-driver.c
> @@ -181,7 +181,6 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&cam->devlist);
>  
>  	mcam = &cam->mcam;
> -	mcam->platform = MHP_Armada610;
>  	mcam->plat_power_up = mmpcam_power_up;
>  	mcam->plat_power_down = mmpcam_power_down;
>  	mcam->dev = &pdev->dev;

Tested-by: Chris Ball <cjb@laptop.org>

Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
