Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52165 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaGYXQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 19:16:35 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A00IZNJBM3H00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 19:16:34 -0400 (EDT)
Date: Fri, 25 Jul 2014 20:16:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 45/49] rc-ir-raw: add various rc_events
Message-id: <20140725201631.6303ce8b.m.chehab@samsung.com>
In-reply-to: <20140403233503.27099.89532.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
 <20140403233503.27099.89532.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:35:03 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Reporting pulse/space events via the /dev/rc/rcX device node is an
> important step towards having feature parity with LIRC.

Why to duplicate LIRC?

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-ir-raw.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index bf5215b..3b68975 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -71,6 +71,17 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
>  	IR_dprintk(2, "sample: (%05dus %s)\n",
>  		   TO_US(ev->duration), TO_STR(ev->pulse));
>  
> +	if (ev->reset)
> +		rc_event(dev, RC_IR, RC_IR_RESET, 1);
> +	else if (ev->carrier_report)
> +		rc_event(dev, RC_IR, RC_IR_CARRIER, ev->carrier);
> +	else if (ev->timeout)
> +		rc_event(dev, RC_IR, RC_IR_STOP, 1);
> +	else if (ev->pulse)
> +		rc_event(dev, RC_IR, RC_IR_PULSE, ev->duration);
> +	else
> +		rc_event(dev, RC_IR, RC_IR_SPACE, ev->duration);
> +
>  	if (kfifo_in(&dev->raw->kfifo, ev, 1) != 1)
>  		return -ENOMEM;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
