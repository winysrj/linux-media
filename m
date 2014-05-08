Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:37228 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaEHIME (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 04:12:04 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5800KQGXG2B110@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 May 2014 04:12:02 -0400 (EDT)
Date: Thu, 08 May 2014 05:11:57 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Changbing Xiong <cb.xiong@samsung.com>
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 2/2] au0828: Cancel stream-restart operation if frontend is
 disconnected
Message-id: <20140508051157.5ac6ef41.m.chehab@samsung.com>
In-reply-to: <1399530503-6820-1-git-send-email-cb.xiong@samsung.com>
References: <1399530503-6820-1-git-send-email-cb.xiong@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Changbing,

Em Thu, 08 May 2014 14:28:23 +0800
Changbing Xiong <cb.xiong@samsung.com> escreveu:

> If the tuner is already disconnected, It is meaningless to go on doing the
> stream-restart operation, It is better to cancel this operation.
> 
> Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-dvb.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> index 878f66f..6995309 100755
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -422,6 +422,8 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
>  	dvb_unregister_frontend(dvb->frontend);
>  	dvb_frontend_detach(dvb->frontend);
>  	dvb_unregister_adapter(&dvb->adapter);
> +
> +	cancel_work_sync(&dev->restart_streaming);

I'm wandering that, if you move the cancel_work_sync() to be called 
earlier in this function (before the dvb_unregister calls),
then maybe we can avoid the first patch.

>  }
> 
>  /* All the DVB attach calls go here, this function get's modified
> --
> 1.7.9.5
> 


-- 

Regards,
Mauro
