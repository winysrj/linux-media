Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56500 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754734AbcJQNyi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 09:54:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Kevin Fitch <kfitch42@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 53/57] [media] i2c: don't break long lines
Date: Mon, 17 Oct 2016 16:54:35 +0300
Message-ID: <1858182.0RpZvMcEao@avalon>
In-Reply-To: <96dbf003bc04978c5081980ab69f8b19192e3a32.1476475771.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com> <96dbf003bc04978c5081980ab69f8b19192e3a32.1476475771.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday 14 Oct 2016 17:20:41 Mauro Carvalho Chehab wrote:
> Due to the 80-cols checkpatch warnings, several strings
> were broken into multiple lines. This is not considered
> a good practice anymore, as it makes harder to grep for
> strings at the source code. So, join those continuation
> lines.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/i2c/as3645a.c          | 9 +++------
>  drivers/media/i2c/msp3400-kthreads.c | 3 +--
>  drivers/media/i2c/mt9m032.c          | 3 +--
>  drivers/media/i2c/mt9p031.c          | 3 +--
>  drivers/media/i2c/saa7115.c          | 3 +--
>  drivers/media/i2c/saa717x.c          | 3 +--
>  drivers/media/i2c/ths8200.c          | 4 +---
>  drivers/media/i2c/tvp5150.c          | 3 +--
>  drivers/media/i2c/tvp7002.c          | 3 +--
>  drivers/media/i2c/upd64083.c         | 3 +--
>  10 files changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
> index 2e90e4094b79..95fcb8f68a1a 100644
> --- a/drivers/media/i2c/as3645a.c
> +++ b/drivers/media/i2c/as3645a.c
> @@ -299,8 +299,7 @@ static int as3645a_read_fault(struct as3645a *flash)
>  		dev_dbg(&client->dev, "Inductor Peak limit fault\n");
> 
>  	if (rval & AS_FAULT_INFO_INDICATOR_LED)
> -		dev_dbg(&client->dev, "Indicator LED fault: "
> -			"Short circuit or open loop\n");
> +		dev_dbg(&client->dev, "Indicator LED fault: Short circuit or 
open
> loop\n");
> 
>  	dev_dbg(&client->dev, "%u connected LEDs\n",
>  		rval & AS_FAULT_INFO_LED_AMOUNT ? 2 : 1);
> @@ -315,8 +314,7 @@ static int as3645a_read_fault(struct as3645a *flash)
>  		dev_dbg(&client->dev, "Short circuit fault\n");
> 
>  	if (rval & AS_FAULT_INFO_OVER_VOLTAGE)
> -		dev_dbg(&client->dev, "Over voltage fault: "
> -			"Indicates missing capacitor or open connection\n");
> +		dev_dbg(&client->dev, "Over voltage fault: Indicates missing 
capacitor or
> open connection\n");
> 
>  	return rval;
>  }
> @@ -588,8 +586,7 @@ static int as3645a_registered(struct v4l2_subdev *sd)
> 
>  	/* Verify the chip model and version. */
>  	if (model != 0x01 || rfu != 0x00) {
> -		dev_err(&client->dev, "AS3645A not detected "
> -			"(model %d rfu %d)\n", model, rfu);
> +		dev_err(&client->dev, "AS3645A not detected (model %d rfu 
%d)\n", model,
> rfu); rval = -ENODEV;
>  		goto power_off;
>  	}
> diff --git a/drivers/media/i2c/msp3400-kthreads.c
> b/drivers/media/i2c/msp3400-kthreads.c index 17120804fab7..022bea68cbf0
> 100644
> --- a/drivers/media/i2c/msp3400-kthreads.c
> +++ b/drivers/media/i2c/msp3400-kthreads.c
> @@ -775,8 +775,7 @@ int msp3410d_thread(void *data)
>  		if (msp_amsound && !state->radio &&
>  		    (state->v4l2_std & V4L2_STD_SECAM) && (val != 0x0009)) {
>  			/* autodetection has failed, let backup */
> -			v4l_dbg(1, msp_debug, client, "autodetection failed,"
> -				" switching to backup standard: %s 
(0x%04x)\n",
> +			v4l_dbg(1, msp_debug, client, "autodetection failed, 
switching to backup
> standard: %s (0x%04x)\n", msp_stdlist[8].name ?
>  					msp_stdlist[8].name : "unknown", val);
>  			state->std = val = 0x0009;
> diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
> index da076796999e..a045425887d5 100644
> --- a/drivers/media/i2c/mt9m032.c
> +++ b/drivers/media/i2c/mt9m032.c
> @@ -746,8 +746,7 @@ static int mt9m032_probe(struct i2c_client *client,
> 
>  	chip_version = mt9m032_read(client, MT9M032_CHIP_VERSION);
>  	if (chip_version != MT9M032_CHIP_VERSION_VALUE) {
> -		dev_err(&client->dev, "MT9M032 not detected, wrong version "
> -			"0x%04x\n", chip_version);
> +		dev_err(&client->dev, "MT9M032 not detected, wrong version 
0x%04x\n",
> chip_version); ret = -ENODEV;
>  		goto error_sensor;
>  	}
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 237737fec09c..4d7b56b96a92 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -929,8 +929,7 @@ static int mt9p031_registered(struct v4l2_subdev
> *subdev) mt9p031_power_off(mt9p031);
> 
>  	if (data != MT9P031_CHIP_VERSION_VALUE) {
> -		dev_err(&client->dev, "MT9P031 not detected, wrong version "
> -			"0x%04x\n", data);
> +		dev_err(&client->dev, "MT9P031 not detected, wrong version 
0x%04x\n",
> data); return -ENODEV;
>  	}
> 
> diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> index 58062b41c923..5db914b7d5ae 100644
> --- a/drivers/media/i2c/saa7115.c
> +++ b/drivers/media/i2c/saa7115.c
> @@ -53,8 +53,7 @@
>  #define VRES_60HZ	(480+16)
> 
>  MODULE_DESCRIPTION("Philips SAA7111/SAA7113/SAA7114/SAA7115/SAA7118 video
> decoder driver"); -MODULE_AUTHOR(  "Maxim Yevtyushkin, Kevin Thayer, Chris
> Kennedy, " -		"Hans Verkuil, Mauro Carvalho Chehab");
> +MODULE_AUTHOR(  "Maxim Yevtyushkin, Kevin Thayer, Chris Kennedy, Hans
> Verkuil, Mauro Carvalho Chehab"); MODULE_LICENSE("GPL");
> 
>  static bool debug;
> diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
> index 1baca37f3eb6..b9eb152cf4e9 100644
> --- a/drivers/media/i2c/saa717x.c
> +++ b/drivers/media/i2c/saa717x.c
> @@ -735,8 +735,7 @@ static void get_inf_dev_status(struct v4l2_subdev *sd,
>  		reg_data3, stdres[reg_data3 & 0x1f],
>  		(reg_data3 & 0x000020) ? ",stereo" : "",
>  		(reg_data3 & 0x000040) ? ",dual"   : "");
> -	v4l2_dbg(1, debug, sd, "detailed status: "
> -		"%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s\n",
> +	v4l2_dbg(1, debug, sd, "detailed status:
> %s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s\n", (reg_data3 & 0x000080) ? "
> A2/EIAJ pilot tone "     : "",
>  		(reg_data3 & 0x000100) ? " A2/EIAJ dual "           : "",
>  		(reg_data3 & 0x000200) ? " A2/EIAJ stereo "         : "",
> diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
> index 42340e364cea..69b6c32f4690 100644
> --- a/drivers/media/i2c/ths8200.c
> +++ b/drivers/media/i2c/ths8200.c
> @@ -351,9 +351,7 @@ static void ths8200_setup(struct v4l2_subdev *sd, struct
> v4l2_bt_timings *bt) /* leave reset */
>  	ths8200_s_stream(sd, true);
> 
> -	v4l2_dbg(1, debug, sd, "%s: frame %dx%d, polarity %d\n"
> -		 "horizontal: front porch %d, back porch %d, sync %d\n"
> -		 "vertical: sync %d\n", __func__, htotal(bt), vtotal(bt),
> +	v4l2_dbg(1, debug, sd, "%s: frame %dx%d, polarity %d\nhorizontal: 
front
> porch %d, back porch %d, sync %d\nvertical: sync %d\n", __func__,
> htotal(bt), vtotal(bt), polarity, bt->hfrontporch, bt->hbackporch,
>  		 bt->hsync, bt->vsync);
>  }
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 4740da39d698..827d276c8f47 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -280,8 +280,7 @@ static inline void tvp5150_selmux(struct v4l2_subdev
> *sd) break;
>  	}
> 
> -	v4l2_dbg(1, debug, sd, "Selecting video route: route input=%i, 
output=%i "
> -			"=> tvp5150 input=%i, opmode=%i\n",
> +	v4l2_dbg(1, debug, sd, "Selecting video route: route input=%i, 
output=%i
> => tvp5150 input=%i, opmode=%i\n", decoder->input, decoder->output,
>  			input, opmode);
> 
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 3dc3341c4896..f21bda76b5ab 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -1057,8 +1057,7 @@ static int tvp7002_remove(struct i2c_client *c)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(c);
>  	struct tvp7002 *device = to_tvp7002(sd);
> 
> -	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
> -				"on address 0x%x\n", c->addr);
> +	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapteron address 0x%x\n",
> c->addr);

You could fix errors in commit messages while at it, there's clearly a space 
missing between "adapter" and "on".

> 	v4l2_async_unregister_subdev(&device->sd);
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	media_entity_cleanup(&device->sd.entity);
> diff --git a/drivers/media/i2c/upd64083.c b/drivers/media/i2c/upd64083.c
> index 77f122f2e3c9..9b080ec4e489 100644
> --- a/drivers/media/i2c/upd64083.c
> +++ b/drivers/media/i2c/upd64083.c
> @@ -139,8 +139,7 @@ static int upd64083_log_status(struct v4l2_subdev *sd)
>  	u8 buf[7];
> 
>  	i2c_master_recv(client, buf, 7);
> -	v4l2_info(sd, "Status: SA00=%02x SA01=%02x SA02=%02x SA03=%02x "
> -		      "SA04=%02x SA05=%02x SA06=%02x\n",
> +	v4l2_info(sd, "Status: SA00=%02x SA01=%02x SA02=%02x SA03=%02x 
SA04=%02x
> SA05=%02x SA06=%02x\n", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5],
> buf[6]);

I have some doubts regarding whether it makes sense to apply the rule 
explained in the commit message blindly. In this specific case for instance I 
very much doubt anyone will grep the source code for "SA03=%02x SA04=%02x". 
I'm sure this isn't the only case in this patch series where splitting 
messages in multiple lines isn't a problem.

>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

