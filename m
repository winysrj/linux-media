Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeEEKfl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 06:35:41 -0400
Date: Sat, 5 May 2018 07:35:38 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT FIXES FOR v4.17] UVC fixes
Message-ID: <20180505073538.3999f6b0@vento.lan>
In-Reply-To: <2618618.x2Pkc03X4B@avalon>
References: <2618618.x2Pkc03X4B@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Apr 2018 03:37:00 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:                                                                                                                              
>                                                                                                                                                                                                           
>   Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)                                                                                                                                                              
>                                                                                                                                                                                                           
> are available in the Git repository at:                                                                                                                                                                   
>                                                                                                                                                                                                           
>   git://linuxtv.org/pinchartl/media.git uvc/fixes                                                                                                                                                         
>                                                                                                                                                                                                           
> for you to fetch changes up to 3f22b63e8a488156467da43cdf9a3a7bd683f161:                                                                                                                                  
>                                                                                                                                                                                                           
>   media: uvcvideo: Prevent setting unavailable flags (2018-04-25 03:16:42 
> +0300)                                                                                                                          
>                                                                                                                                                           
Not sure what happened here, but this e-mail is completely mangled.
This way, patchwork won't parse it.

I manually applied it, but next time please check if your emailer
is not messing with pull requests.

Thanks,
Mauro
                                                
> ----------------------------------------------------------------                                                                                                                                          
> Kieran Bingham (1):                                                                                                                                                                                       
>       media: uvcvideo: Prevent setting unavailable flags                                                                                                                                                  
>                                                                                                                                                                                                           
>  drivers/media/usb/uvc/uvc_ctrl.c | 17 +++++++++--------                                                                                                                                                  
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 



Thanks,
Mauro
