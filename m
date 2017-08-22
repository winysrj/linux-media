Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0047.outbound.protection.outlook.com ([104.47.41.47]:58821
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751061AbdHVQjU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 12:39:20 -0400
Subject: Re: [PATCH 1/4] i2c: busses: make i2c_adapter const
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr,
        wsa@the-dreams.de, jacmet@sunsite.dk, jglauber@cavium.com,
        david.daney@cavium.com, hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
 <1503138855-585-2-git-send-email-bhumirks@gmail.com>
From: David Daney <ddaney@caviumnetworks.com>
Message-ID: <9831a3fd-829d-9165-20f9-9cd341e5646b@caviumnetworks.com>
Date: Tue, 22 Aug 2017 09:39:14 -0700
MIME-Version: 1.0
In-Reply-To: <1503138855-585-2-git-send-email-bhumirks@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2017 03:34 AM, Bhumika Goyal wrote:
> Make these const as they are only used in a copy operation.
> Done using Coccinelle.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>



i2c-octeon-platdrv.c and i2c-thunderx-pcidrv.c changes:

Acked-by: David Daney <david.daney@cavium.com>

Thanks.

> ---
>   drivers/i2c/busses/i2c-kempld.c          | 2 +-
>   drivers/i2c/busses/i2c-ocores.c          | 2 +-
>   drivers/i2c/busses/i2c-octeon-platdrv.c  | 2 +-
>   drivers/i2c/busses/i2c-thunderx-pcidrv.c | 2 +-
>   drivers/i2c/busses/i2c-xiic.c            | 2 +-
>   5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-kempld.c b/drivers/i2c/busses/i2c-kempld.c
> index 25993d2..e879190 100644
> --- a/drivers/i2c/busses/i2c-kempld.c
> +++ b/drivers/i2c/busses/i2c-kempld.c
> @@ -289,7 +289,7 @@ static u32 kempld_i2c_func(struct i2c_adapter *adap)
>   	.functionality	= kempld_i2c_func,
>   };
>   
> -static struct i2c_adapter kempld_i2c_adapter = {
> +static const struct i2c_adapter kempld_i2c_adapter = {
>   	.owner		= THIS_MODULE,
>   	.name		= "i2c-kempld",
>   	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
> index 34f1889..8c42ca7 100644
> --- a/drivers/i2c/busses/i2c-ocores.c
> +++ b/drivers/i2c/busses/i2c-ocores.c
> @@ -276,7 +276,7 @@ static u32 ocores_func(struct i2c_adapter *adap)
>   	.functionality = ocores_func,
>   };
>   
> -static struct i2c_adapter ocores_adapter = {
> +static const struct i2c_adapter ocores_adapter = {
>   	.owner = THIS_MODULE,
>   	.name = "i2c-ocores",
>   	.class = I2C_CLASS_DEPRECATED,
> diff --git a/drivers/i2c/busses/i2c-octeon-platdrv.c b/drivers/i2c/busses/i2c-octeon-platdrv.c
> index 917524c..64bda83 100644
> --- a/drivers/i2c/busses/i2c-octeon-platdrv.c
> +++ b/drivers/i2c/busses/i2c-octeon-platdrv.c
> @@ -126,7 +126,7 @@ static u32 octeon_i2c_functionality(struct i2c_adapter *adap)
>   	.functionality = octeon_i2c_functionality,
>   };
>   
> -static struct i2c_adapter octeon_i2c_ops = {
> +static const struct i2c_adapter octeon_i2c_ops = {
>   	.owner = THIS_MODULE,
>   	.name = "OCTEON adapter",
>   	.algo = &octeon_i2c_algo,
> diff --git a/drivers/i2c/busses/i2c-thunderx-pcidrv.c b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
> index ea35a895..df0976f 100644
> --- a/drivers/i2c/busses/i2c-thunderx-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
> @@ -75,7 +75,7 @@ static u32 thunderx_i2c_functionality(struct i2c_adapter *adap)
>   	.functionality = thunderx_i2c_functionality,
>   };
>   
> -static struct i2c_adapter thunderx_i2c_ops = {
> +static const struct i2c_adapter thunderx_i2c_ops = {
>   	.owner	= THIS_MODULE,
>   	.name	= "ThunderX adapter",
>   	.algo	= &thunderx_i2c_algo,
> diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
> index 34b27bf..ae6ed25 100644
> --- a/drivers/i2c/busses/i2c-xiic.c
> +++ b/drivers/i2c/busses/i2c-xiic.c
> @@ -721,7 +721,7 @@ static u32 xiic_func(struct i2c_adapter *adap)
>   	.functionality = xiic_func,
>   };
>   
> -static struct i2c_adapter xiic_adapter = {
> +static const struct i2c_adapter xiic_adapter = {
>   	.owner = THIS_MODULE,
>   	.name = DRIVER_NAME,
>   	.class = I2C_CLASS_DEPRECATED,
> 
