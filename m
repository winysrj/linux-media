Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:11004 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab1AYAcq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 19:32:46 -0500
Subject: Re: [PATCH 13/13] [media] remove the old RC_MAP_HAUPPAUGE_NEW RC
 map
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20110124131848.59f438d3@pedra>
References: <cover.1295882104.git.mchehab@redhat.com>
	 <20110124131848.59f438d3@pedra>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 19:32:28 -0500
Message-ID: <1295915548.2420.44.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-24 at 13:18 -0200, Mauro Carvalho Chehab wrote:
> The rc-hauppauge-new map is a messy thing, as it bundles 3
> different remote controllers as if they were just one,
> discarding the address byte. Also, some key maps are wrong.
> 
> With the conversion to the new rc-core, it is likely that
> most of the devices won't be working properly, as the i2c
> driver and the raw decoders are now providing 16 bits for
> the remote, instead of just 8.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

All the patch emails didn't/haven't come through to me.

Did you miss cx23885-input.c, or is that using a map that isn't affected
by these changes?

Also one comment below:

>  delete mode 100644 drivers/media/rc/keymaps/rc-hauppauge-new.c
[...]
> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> index d2b20ad..b18373a 100644
> --- a/drivers/media/video/ir-kbd-i2c.c
> +++ b/drivers/media/video/ir-kbd-i2c.c
> @@ -300,7 +300,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		ir->get_key = get_key_haup;
>  		rc_type     = RC_TYPE_RC5;
>  		if (hauppauge == 1) {
> -			ir_codes    = RC_MAP_HAUPPAUGE_NEW;
> +			ir_codes    = RC_MAP_HAUPPAUGE;
>  		} else {
>  			ir_codes    = RC_MAP_RC5_TV;
>  		}
> @@ -327,7 +327,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		name        = "Hauppauge/Zilog Z8";
>  		ir->get_key = get_key_haup_xvr;
>  		rc_type     = RC_TYPE_RC5;
> -		ir_codes    = hauppauge ? RC_MAP_HAUPPAUGE_NEW : RC_MAP_RC5_TV;
> +		ir_codes    = hauppauge ? RC_MAP_HAUPPAUGE : RC_MAP_RC5_TV;
>  		break;
>  	}

The "hauppauge" module parameter was to make ir-kbd-i2c to default to a
keymap for the old black remote.

If you have combined the black remote's keymap with the grey remote's
keymap, why keep the "hauppauge" module parameter?

Regards,
Andy



