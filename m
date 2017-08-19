Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:42317 "EHLO cnc.isely.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751614AbdHSUVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 16:21:17 -0400
Date: Sat, 19 Aug 2017 15:16:13 -0500 (CDT)
From: isely@isely.net
Reply-To: Mike Isely at pobox <isely@pobox.com>
To: Bhumika Goyal <bhumirks@gmail.com>
cc: julia.lawall@lip6.fr, wsa@the-dreams.de, jacmet@sunsite.dk,
        jglauber@cavium.com, david.daney@cavium.com,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        ezequiel@vanguardiasur.com.ar, linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 4/4] [media] usb: make i2c_adapter const
In-Reply-To: <1503138855-585-5-git-send-email-bhumirks@gmail.com>
Message-ID: <alpine.DEB.2.11.1708191515550.27909@lochley.isely.net>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com> <1503138855-585-5-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: Mike Isely <isely@pobox.com>

On Sat, 19 Aug 2017, Bhumika Goyal wrote:

> Make these const as they are only used in a copy operation.
> Done using Coccinelle
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/media/usb/au0828/au0828-i2c.c        | 2 +-
>  drivers/media/usb/cx231xx/cx231xx-i2c.c      | 2 +-
>  drivers/media/usb/em28xx/em28xx-i2c.c        | 2 +-
>  drivers/media/usb/hdpvr/hdpvr-i2c.c          | 2 +-
>  drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 2 +-
>  drivers/media/usb/stk1160/stk1160-i2c.c      | 2 +-
>  drivers/media/usb/usbvision/usbvision-i2c.c  | 4 ++--
>  7 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
> index 42b352b..9074a98 100644
> --- a/drivers/media/usb/au0828/au0828-i2c.c
> +++ b/drivers/media/usb/au0828/au0828-i2c.c
> @@ -336,7 +336,7 @@ static u32 au0828_functionality(struct i2c_adapter *adap)
>  
>  /* ----------------------------------------------------------------------- */
>  
> -static struct i2c_adapter au0828_i2c_adap_template = {
> +static const struct i2c_adapter au0828_i2c_adap_template = {
>  	.name              = KBUILD_MODNAME,
>  	.owner             = THIS_MODULE,
>  	.algo              = &au0828_i2c_algo_template,
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index 8ce6b81..23648da 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -459,7 +459,7 @@ static u32 functionality(struct i2c_adapter *adap)
>  	.functionality = functionality,
>  };
>  
> -static struct i2c_adapter cx231xx_adap_template = {
> +static const struct i2c_adapter cx231xx_adap_template = {
>  	.owner = THIS_MODULE,
>  	.name = "cx231xx",
>  	.algo = &cx231xx_algo,
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 60b195c..66c5012 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -876,7 +876,7 @@ static u32 functionality(struct i2c_adapter *i2c_adap)
>  	.functionality = functionality,
>  };
>  
> -static struct i2c_adapter em28xx_adap_template = {
> +static const struct i2c_adapter em28xx_adap_template = {
>  	.owner = THIS_MODULE,
>  	.name = "em28xx",
>  	.algo = &em28xx_algo,
> diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
> index fcab550..7329310 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
> @@ -184,7 +184,7 @@ static u32 hdpvr_functionality(struct i2c_adapter *adapter)
>  	.functionality = hdpvr_functionality,
>  };
>  
> -static struct i2c_adapter hdpvr_i2c_adapter_template = {
> +static const struct i2c_adapter hdpvr_i2c_adapter_template = {
>  	.name   = "Hauppage HD PVR I2C",
>  	.owner  = THIS_MODULE,
>  	.algo   = &hdpvr_algo,
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
> index 20a52b7..3618ace 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
> @@ -519,7 +519,7 @@ static u32 pvr2_i2c_functionality(struct i2c_adapter *adap)
>  	.functionality = pvr2_i2c_functionality,
>  };
>  
> -static struct i2c_adapter pvr2_i2c_adap_template = {
> +static const struct i2c_adapter pvr2_i2c_adap_template = {
>  	.owner         = THIS_MODULE,
>  	.class	       = 0,
>  };
> diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
> index 3f2517b..2c70173 100644
> --- a/drivers/media/usb/stk1160/stk1160-i2c.c
> +++ b/drivers/media/usb/stk1160/stk1160-i2c.c
> @@ -240,7 +240,7 @@ static u32 functionality(struct i2c_adapter *adap)
>  	.functionality = functionality,
>  };
>  
> -static struct i2c_adapter adap_template = {
> +static const struct i2c_adapter adap_template = {
>  	.owner = THIS_MODULE,
>  	.name = "stk1160",
>  	.algo = &algo,
> diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
> index 68acafb..837bd4d 100644
> --- a/drivers/media/usb/usbvision/usbvision-i2c.c
> +++ b/drivers/media/usb/usbvision/usbvision-i2c.c
> @@ -173,7 +173,7 @@ static u32 functionality(struct i2c_adapter *adap)
>  /* ----------------------------------------------------------------------- */
>  /* usbvision specific I2C functions                                        */
>  /* ----------------------------------------------------------------------- */
> -static struct i2c_adapter i2c_adap_template;
> +static const struct i2c_adapter i2c_adap_template;
>  
>  int usbvision_i2c_register(struct usb_usbvision *usbvision)
>  {
> @@ -441,7 +441,7 @@ static int usbvision_i2c_read(struct usb_usbvision *usbvision, unsigned char add
>  	return rdcount;
>  }
>  
> -static struct i2c_adapter i2c_adap_template = {
> +static const struct i2c_adapter i2c_adap_template = {
>  	.owner = THIS_MODULE,
>  	.name              = "usbvision",
>  };
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
