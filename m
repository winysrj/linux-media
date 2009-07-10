Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56833 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbZGJXtM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 19:49:12 -0400
Message-ID: <4A57D371.4070307@iki.fi>
Date: Sat, 11 Jul 2009 02:49:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nils Kassube <kassube@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: Fix for crash in dvb-usb-af9015
References: <200907071232.00459.kassube@gmx.net> <4A532ACA.1070607@iki.fi> <200907071634.00168.kassube@gmx.net>
In-Reply-To: <200907071634.00168.kassube@gmx.net>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heips Nils,

On 07/07/2009 05:33 PM, Nils Kassube wrote:
> Hi Antti,
>
> Antti Palosaari wrote:
>> Nils Kassube wrote:
>>> As I'm not familiar with the hardware, I can't say what buffer size
>>> would be appropriate but I can say that for my device the parameter
>> I see the problem but your fix is not ideally correct for my eyes.
>
> You're probably right - like I wrote, I'm not familiar with the
> hardware.
>
>> I
>> don't have currently access to sniffs to ensure that but I think BOOT
>> should be write command. Now it is defined as read. I think moving
>> BOOT from read to write fixes problem.
>
> Yes, that makes a lot of sense to me. Therefore I changed the code to
> make it a write command like this:
>
> --- orig/linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-06-30
> 11:34:45.000000000 +0200
> +++ linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-07-07
> 14:58:27.000000000 +0200
> @@ -81,7 +81,6 @@
>
>   	switch (req->cmd) {
>   	case GET_CONFIG:
> -	case BOOT:
>   	case READ_MEMORY:
>   	case RECONNECT_USB:
>   	case GET_IR_CODE:
> @@ -100,6 +99,7 @@
>   	case WRITE_VIRTUAL_MEMORY:
>   	case COPY_FIRMWARE:
>   	case DOWNLOAD_FIRMWARE:
> +	case BOOT:
>   		break;
>   	default:
>   		err("unknown command:%d", req->cmd);
>
> And of course I removed the earlier change. With this modification it
> works as well.

I need your signed off by tag in order to forward this mainline. Patch 
is correct and I tested it also.
About tags http://kerneltrap.org/node/8329

regards
Antti
-- 
http://palosaari.fi/
