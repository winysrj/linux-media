Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52624 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2JCAhJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 20:37:09 -0400
Message-ID: <506B889F.6010604@iki.fi>
Date: Wed, 03 Oct 2012 03:36:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 1/7] [media] ds3000: Declare MODULE_FIRMWARE usage
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com> <1348837172-11784-2-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1348837172-11784-2-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 03:59 PM, Rémi Cardona wrote:
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

> ---
>   drivers/media/dvb-frontends/ds3000.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index 4c8ac26..46874c7 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -1310,3 +1310,4 @@ MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
>   			"DS3000/TS2020 hardware");
>   MODULE_AUTHOR("Konstantin Dimitrov");
>   MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE(DS3000_DEFAULT_FIRMWARE);
>


-- 
http://palosaari.fi/
