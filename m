Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:47617 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648AbZDQKyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 06:54:19 -0400
Date: Fri, 17 Apr 2009 12:54:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] tda7432: Delete old driver history
Message-ID: <20090417125407.43ff3695@hyperion.delvare>
In-Reply-To: <20090407175517.34102671@hyperion.delvare>
References: <20090407175517.34102671@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Apr 2009 17:55:17 +0200, Jean Delvare wrote:
> The history of changes does belong to git.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> In general I wouldn't care too much but it happens that this specific
> comment triggers a false positive in one of my scripts, so I'd rather
> get rid of it.
> 
>  linux/drivers/media/video/tda7432.c |   14 --------------
>  1 file changed, 14 deletions(-)
> 

Mauro, can you please apply this patch? Thanks.

> --- v4l-dvb.orig/linux/drivers/media/video/tda7432.c	2009-04-06 10:10:25.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/tda7432.c	2009-04-07 17:44:59.000000000 +0200
> @@ -20,20 +20,6 @@
>   * loudness - set between 0 and 15 for varying degrees of loudness effect
>   *
>   * maxvol   - set maximium volume to +20db (1), default is 0db(0)
> - *
> - *
> - *  Revision: 0.7 - maxvol module parm to set maximium volume 0db or +20db
> - *  				store if muted so we can return it
> - *  				change balance only if flaged to
> - *  Revision: 0.6 - added tone controls
> - *  Revision: 0.5 - Fixed odd balance problem
> - *  Revision: 0.4 - added muting
> - *  Revision: 0.3 - Fixed silly reversed volume controls.  :)
> - *  Revision: 0.2 - Cleaned up #defines
> - *			fixed volume control
> - *          Added I2C_DRIVERID_TDA7432
> - *			added loudness insmod control
> - *  Revision: 0.1 - initial version
>   */
>  
>  #include <linux/module.h>
> 
> 


-- 
Jean Delvare
