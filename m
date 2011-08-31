Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab1HaTp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 15:45:28 -0400
Message-ID: <4E5E8F54.8000106@redhat.com>
Date: Wed, 31 Aug 2011 16:45:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 06/21] [staging] tm6000: Increase maximum I2C packet size.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-7-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-7-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 04:14, Thierry Reding escreveu:
> The TM6010 supports much larger I2C transfers than currently specified.
> In fact the Windows driver seems to use 81 bytes per packet by default.
> This commit improves the speed of firmware loading a bit.
> ---
>  drivers/staging/tm6000/tm6000-cards.c |    1 +
>  drivers/staging/tm6000/tm6000-i2c.c   |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index c3b84c9..a5d2a71 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -929,6 +929,7 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
>  		memset(&ctl, 0, sizeof(ctl));
>  
>  		ctl.demod = XC3028_FE_ZARLINK456;
> +		ctl.max_len = 81;
>  
>  		xc2028_cfg.tuner = TUNER_XC2028;
>  		xc2028_cfg.priv  = &ctl;
> diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
> index 21cd9f8..2cb7573 100644
> --- a/drivers/staging/tm6000/tm6000-i2c.c
> +++ b/drivers/staging/tm6000/tm6000-i2c.c
> @@ -50,7 +50,7 @@ static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
>  	unsigned int i2c_packet_limit = 16;
>  
>  	if (dev->dev_type == TM6010)
> -		i2c_packet_limit = 64;
> +		i2c_packet_limit = 256;

This shouldn't work fine. As said at USB 2.0 specification:

	An endpoint for control transfers specifies the maximum data payload size that the endpoint can accept from
	or transmit to the bus. The allowable maximum control transfer data payload sizes for full-speed devices is
	8, 16, 32, or 64 bytes; for high-speed devices, it is 64 bytes and for low-speed devices, it is 8 bytes. This
	maximum applies to the data payloads of the Data packets following a Setup; i.e., the size specified is for
	the data field of the packet as defined in Chapter 8, not including other information that is required by the
	protocol. A Setup packet is always eight bytes. A control pipe (including the Default Control Pipe) always
	uses its wMaxPacketSize value for data payloads.
	(Item 5.5.3 Control Transfer Packet Size Constraints).

Using a value higher than 64 may cause troubles with some USB devices
(hubs, USB adapters, etc).

Cheers,
Mauro
