Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37982 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751658AbdGZPEC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 11:04:02 -0400
Date: Wed, 26 Jul 2017 16:03:56 +0100
From: Rui Miguel Silva <rmfrfs@gmail.com>
To: Johan Hovold <johan@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] staging: greybus: light: Don't leak memory for no
 gain
Message-ID: <20170726150356.GA21301@arch-late.localdomain>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
 <20170718184107.10598-2-sakari.ailus@linux.intel.com>
 <20170725123031.GB27516@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725123031.GB27516@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Tue, Jul 25, 2017 at 02:30:31PM +0200, Johan Hovold wrote:
> [ +CC: Rui and Greg ]

Thanks Johan. I only got this because of you.

> 
> On Tue, Jul 18, 2017 at 09:41:06PM +0300, Sakari Ailus wrote:
> > Memory for struct v4l2_flash_config is allocated in
> > gb_lights_light_v4l2_register() for no gain and yet the allocated memory is
> > leaked; the struct isn't used outside the function. Fix this.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/staging/greybus/light.c | 17 ++++++-----------
> >  1 file changed, 6 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
> > index 129ceed39829..b25c117ec41a 100644
> > --- a/drivers/staging/greybus/light.c
> > +++ b/drivers/staging/greybus/light.c
> > @@ -534,25 +534,21 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
> >  {
> >  	struct gb_connection *connection = get_conn_from_light(light);
> >  	struct device *dev = &connection->bundle->dev;
> > -	struct v4l2_flash_config *sd_cfg;
> > +	struct v4l2_flash_config sd_cfg = { 0 };
> >  	struct led_classdev_flash *fled;
> >  	struct led_classdev *iled = NULL;
> >  	struct gb_channel *channel_torch, *channel_ind, *channel_flash;
> >  	int ret = 0;
> >  
> > -	sd_cfg = kcalloc(1, sizeof(*sd_cfg), GFP_KERNEL);
> > -	if (!sd_cfg)
> > -		return -ENOMEM;
> > -
> >  	channel_torch = get_channel_from_mode(light, GB_CHANNEL_MODE_TORCH);
> >  	if (channel_torch)
> >  		__gb_lights_channel_v4l2_config(&channel_torch->intensity_uA,
> > -						&sd_cfg->torch_intensity);
> > +						&sd_cfg.torch_intensity);
> >  
> >  	channel_ind = get_channel_from_mode(light, GB_CHANNEL_MODE_INDICATOR);
> >  	if (channel_ind) {
> >  		__gb_lights_channel_v4l2_config(&channel_ind->intensity_uA,
> > -						&sd_cfg->indicator_intensity);
> > +						&sd_cfg.indicator_intensity);
> >  		iled = &channel_ind->fled.led_cdev;
> >  	}
> >  
> > @@ -561,17 +557,17 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
> >  
> >  	fled = &channel_flash->fled;
> >  
> > -	snprintf(sd_cfg->dev_name, sizeof(sd_cfg->dev_name), "%s", light->name);
> > +	snprintf(sd_cfg.dev_name, sizeof(sd_cfg.dev_name), "%s", light->name);
> >  
> >  	/* Set the possible values to faults, in our case all faults */
> > -	sd_cfg->flash_faults = LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
> > +	sd_cfg.flash_faults = LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
> >  		LED_FAULT_OVER_TEMPERATURE | LED_FAULT_SHORT_CIRCUIT |
> >  		LED_FAULT_OVER_CURRENT | LED_FAULT_INDICATOR |
> >  		LED_FAULT_UNDER_VOLTAGE | LED_FAULT_INPUT_VOLTAGE |
> >  		LED_FAULT_LED_OVER_TEMPERATURE;
> >  
> >  	light->v4l2_flash = v4l2_flash_init(dev, NULL, fled, iled,
> > -					    &v4l2_flash_ops, sd_cfg);
> > +					    &v4l2_flash_ops, &sd_cfg);
> >  	if (IS_ERR_OR_NULL(light->v4l2_flash)) {
> >  		ret = PTR_ERR(light->v4l2_flash);
> >  		goto out_free;
> > @@ -580,7 +576,6 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
> >  	return ret;
> >  
> >  out_free:
> > -	kfree(sd_cfg);
> 
> This looks a bit lazy, even if I just noticed that you repurpose this
> error label (without renaming it) in you second patch.
> 
> 
> >  	return ret;
> >  }
> 
> And while it's fine to take this through linux-media, it would still be
> good to keep the maintainers on CC.

Sakari, if you could resend the all series to the right lists and
maintainers for proper review that would be great.

I did not get 0/2 and 2/2 patches.

---
Cheers,
	Rui
