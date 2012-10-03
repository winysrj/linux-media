Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35863 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab2JCAil (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 20:38:41 -0400
Message-ID: <506B88FB.1090707@iki.fi>
Date: Wed, 03 Oct 2012 03:38:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 6/7] [media] ds3000: add module parameter to force firmware
 upload
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com> <1348837172-11784-7-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1348837172-11784-7-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 03:59 PM, Rémi Cardona wrote:
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/dvb-frontends/ds3000.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index 59184a8..c66d731 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -30,6 +30,7 @@
>   #include "ds3000.h"
>
>   static int debug;
> +static int force_fw_upload;
>
>   #define dprintk(args...) \
>   	do { \
> @@ -396,7 +397,7 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
>   	dprintk("%s()\n", __func__);
>
>   	ret = ds3000_readreg(state, 0xb2);
> -	if (ret == 0) {
> +	if (ret == 0 && force_fw_upload == 0) {
>   		/* Firmware already uploaded, skipping */
>   		return ret;
>   	} else if (ret < 0) {
> @@ -1307,6 +1308,9 @@ static struct dvb_frontend_ops ds3000_ops = {
>   module_param(debug, int, 0644);
>   MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
>
> +module_param(force_fw_upload, int, 0644);
> +MODULE_PARM_DESC(force_fw_upload, "Force firmware upload (default:0)");
> +
>   MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
>   			"DS3000/TS2020 hardware");
>   MODULE_AUTHOR("Konstantin Dimitrov");
>


-- 
http://palosaari.fi/
