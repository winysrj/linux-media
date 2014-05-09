Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:61926 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaEIINA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 04:13:00 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5A00LS7S5NJG80@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 May 2014 04:12:59 -0400 (EDT)
Date: Fri, 09 May 2014 05:12:53 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Changbing Xiong"@pop3.w2.samsung.net, dheitmueller@kernellabs.com
Cc: linux-media@vger.kernel.org, Changbing Xiong <cb.xiong@samsung.com>
Subject: Re: [PATCH] au0828: Cancel stream-restart operation if frontend is
 disconnected
Message-id: <20140509051253.0417fc38.m.chehab@samsung.com>
In-reply-to: <1399611251-7746-1-git-send-email-cb.xiong@samsung.com>
References: <1399611251-7746-1-git-send-email-cb.xiong@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 09 May 2014 12:54:11 +0800
Changbing Xiong@pop3.w2.samsung.net escreveu:

> From: Changbing Xiong <cb.xiong@samsung.com>
> 
> If the tuner is already disconnected, It is meaningless to go on doing the
> stream-restart operation, It is better to cancel this operation.
> 
> Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-dvb.c |    2 ++
>  1 file changed, 2 insertions(+)
>  mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c
> 
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> old mode 100644
> new mode 100755
> index 9a6f156..fd8e798
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -403,6 +403,8 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
>  	if (dvb->frontend == NULL)
>  		return;
> 
> +	cancel_work_sync(&dev->restart_streaming);
> +
>  	dvb_net_release(&dvb->net);
>  	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
>  	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);

Seems ok on my eyes.

Btw, I think we should also call cancel_work_sync() on other
places. On some tests I did with this frontend last week, things
sometimes get badly when switching from one channel to another one,
or doing channel scan.

This thread could be the culprit. Unfortunately, I can't test it
ATM, as I'm in a business trip this week.

Anyway, from a theoretical perspective, it seems logical that
call cancel_work_sync() should also be called when:
	- stop_urb_transfer() is called;
	- when a new tuning starts.

For the second one, the patch should be somewhat similar to what 
cx23885_set_frontend_hook() does, e. g. hooking the 
fe->ops.set_frontend, in order to call cancel_work_sync() before setting
the frontend parameters for the next frequency to zap. Due to the 
DVB zigzag algorithm, I suspect that this could even improve channel
scanning.

Devin,

What do you think?

Thanks,
Mauro
