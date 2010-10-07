Return-path: <mchehab@pedra>
Received: from gateway14.websitewelcome.com ([69.93.154.35]:34689 "HELO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753035Ab0JGQmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 12:42:55 -0400
Subject: Re: [PATCH 05/16] go7007: Don't use module names to load I2C
 modules
From: Pete Eberlein <pete@sensoray.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1285337654-5044-6-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1285337654-5044-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 09:33:19 -0700
Message-ID: <1286469199.2477.11.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Acked-by: Pete Eberlein <pete@sensoray.com>

On Fri, 2010-09-24 at 16:14 +0200, Laurent Pinchart wrote:
> With the v4l2_i2c_new_subdev* functions now supporting loading modules
> based on modaliases, replace the hardcoded module name passed to those
> functions by NULL.
> 
> All corresponding I2C modules have been checked, and all of them include
> a module aliases table with names corresponding to what the go7007
> driver uses.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/staging/go7007/go7007-driver.c |   43 ++-----------------------------
>  1 files changed, 3 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
> index 372a7c6..0a1d925 100644
> --- a/drivers/staging/go7007/go7007-driver.c
> +++ b/drivers/staging/go7007/go7007-driver.c
> @@ -194,51 +194,15 @@ int go7007_reset_encoder(struct go7007 *go)
>   * Attempt to instantiate an I2C client by ID, probably loading a module.
>   */
>  static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
> -			   int id, int addr)
> +			   int addr)
>  {
>  	struct go7007 *go = i2c_get_adapdata(adapter);
>  	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
> -	char *modname;
>  
> -	switch (id) {
> -	case I2C_DRIVERID_WIS_SAA7115:
> -		modname = "wis-saa7115";
> -		break;
> -	case I2C_DRIVERID_WIS_SAA7113:
> -		modname = "wis-saa7113";
> -		break;
> -	case I2C_DRIVERID_WIS_UDA1342:
> -		modname = "wis-uda1342";
> -		break;
> -	case I2C_DRIVERID_WIS_SONY_TUNER:
> -		modname = "wis-sony-tuner";
> -		break;
> -	case I2C_DRIVERID_WIS_TW9903:
> -		modname = "wis-tw9903";
> -		break;
> -	case I2C_DRIVERID_WIS_TW2804:
> -		modname = "wis-tw2804";
> -		break;
> -	case I2C_DRIVERID_WIS_OV7640:
> -		modname = "wis-ov7640";
> -		break;
> -	case I2C_DRIVERID_S2250:
> -		modname = "s2250";
> -		break;
> -	default:
> -		modname = NULL;
> -		break;
> -	}
> -
> -	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, modname, type, addr, NULL))
> +	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, NULL, type, addr, NULL))
>  		return 0;
>  
> -	if (modname != NULL)
> -		printk(KERN_INFO
> -			"go7007: probing for module %s failed\n", modname);
> -	else
> -		printk(KERN_INFO
> -			"go7007: sensor %u seems to be unsupported!\n", id);
> +	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", type);
>  	return -1;
>  }
>  
> @@ -277,7 +241,6 @@ int go7007_register_encoder(struct go7007 *go)
>  		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
>  			init_i2c_module(&go->i2c_adapter,
>  					go->board_info->i2c_devs[i].type,
> -					go->board_info->i2c_devs[i].id,
>  					go->board_info->i2c_devs[i].addr);
>  		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
>  			i2c_clients_command(&go->i2c_adapter,


