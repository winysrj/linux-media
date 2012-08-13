Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab2HMTmB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 15:42:01 -0400
Message-ID: <50295881.5090000@redhat.com>
Date: Mon, 13 Aug 2012 16:41:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 11/11] au0828: use %*ph to dump small buffers
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com> <1344357792-18202-11-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-11-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-08-2012 13:43, Andy Shevchenko escreveu:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/media/video/au0828/au0828-core.c |   12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
> index 1e4ce50..49e0e92 100644
> --- a/drivers/media/video/au0828/au0828-core.c
> +++ b/drivers/media/video/au0828/au0828-core.c
> @@ -73,17 +73,7 @@ static void cmd_msg_dump(struct au0828_dev *dev)
>  	int i;
>  
>  	for (i = 0; i < sizeof(dev->ctrlmsg); i += 16)
> -		dprintk(2, "%s() %02x %02x %02x %02x %02x %02x %02x %02x "
> -				"%02x %02x %02x %02x %02x %02x %02x %02x\n",
> -			__func__,
> -			dev->ctrlmsg[i+0], dev->ctrlmsg[i+1],
> -			dev->ctrlmsg[i+2], dev->ctrlmsg[i+3],
> -			dev->ctrlmsg[i+4], dev->ctrlmsg[i+5],
> -			dev->ctrlmsg[i+6], dev->ctrlmsg[i+7],
> -			dev->ctrlmsg[i+8], dev->ctrlmsg[i+9],
> -			dev->ctrlmsg[i+10], dev->ctrlmsg[i+11],
> -			dev->ctrlmsg[i+12], dev->ctrlmsg[i+13],
> -			dev->ctrlmsg[i+14], dev->ctrlmsg[i+15]);
> +		dprintk(2, "%s() %*ph\n", __func__, 16, dev->ctrlmsg + i);
>  }
>  
>  static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
> 
That one doesn't apply anymore.

Thanks,
Mauro

