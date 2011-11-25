Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1KYRuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 12:50:46 -0500
Message-ID: <4ECFD56E.3040200@infradead.org>
Date: Fri, 25 Nov 2011 15:50:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Peter Huewe <peterhuewe@gmx.de>,
	Steven Toth <stoth@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] saa7164: fix endian conversion in saa7164_bus_set()
References: <20111123070911.GA8561@elgon.mountain>
In-Reply-To: <20111123070911.GA8561@elgon.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-11-2011 05:09, Dan Carpenter escreveu:
> The msg->command field is 32 bits, and we should fill it with a call
> to cpu_to_le32().  The current code is broken on big endian systems,
> and on little endian systems it just truncates the 32 bit value to
> 16 bits.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is a static checker bug.  I haven't tested it.
> 
> diff --git a/drivers/media/video/saa7164/saa7164-bus.c b/drivers/media/video/saa7164/saa7164-bus.c
> index 466e1b0..8f853d1 100644
> --- a/drivers/media/video/saa7164/saa7164-bus.c
> +++ b/drivers/media/video/saa7164/saa7164-bus.c
> @@ -149,7 +149,7 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmComResInfo* msg,
>  	saa7164_bus_verify(dev);
>  
>  	msg->size = cpu_to_le16(msg->size);
> -	msg->command = cpu_to_le16(msg->command);
> +	msg->command = cpu_to_le32(msg->command);
>  	msg->controlselector = cpu_to_le16(msg->controlselector);
>  
>  	if (msg->size > dev->bus.m_wMaxReqSize) {

Hmm... I don't have this hardware, but:

peekout:
        msg->size = le16_to_cpu(msg->size);
        msg->command = le16_to_cpu(msg->command);
        msg->controlselector = le16_to_cpu(msg->controlselector);
        ret = SAA_OK;
out:
        mutex_unlock(&bus->lock);
        saa7164_bus_verify(dev);
        return ret;
}

le16_to_cpu() is used for command. If one place needs fix, so the other one also
requires it.

Regards,
Mauro
