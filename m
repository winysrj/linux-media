Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52814 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2IPBqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 21:46:13 -0400
Message-ID: <50552F51.6070406@iki.fi>
Date: Sun, 16 Sep 2012 04:45:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 6/6] [media] ds3000: add module parameter to force firmware
 upload
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com> <1347614846-19046-7-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-7-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:27 PM, Rémi Cardona wrote:
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

With same comments as earlier patch.

> ---
>   drivers/media/dvb/frontends/ds3000.c |    9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
> index 970963c..3e0e9de 100644
> --- a/drivers/media/dvb/frontends/ds3000.c
> +++ b/drivers/media/dvb/frontends/ds3000.c
> @@ -30,6 +30,7 @@
>   #include "ds3000.h"
>
>   static int debug;
> +static int force_fw_upload;
>
>   #define dprintk(args...) \
>   	do { \
> @@ -396,10 +397,13 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
>   	dprintk("%s()\n", __func__);
>
>   	ret = ds3000_readreg(state, 0xb2);
> -	if (ret == 0) {
> +	if (ret == 0 && force_fw_upload == 0) {
>   		printk(KERN_INFO "%s: Firmware already uploaded, skipping\n",
>   			__func__);
>   		return ret;
> +	} else if (ret == 0 && force_fw_upload) {
> +		printk(KERN_INFO "%s: Firmware already uploaded, "
> +			"forcing upload\n", __func__);
>   	} else if (ret < 0) {
>   		return ret;
>   	}
> @@ -1308,6 +1312,9 @@ static struct dvb_frontend_ops ds3000_ops = {
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
