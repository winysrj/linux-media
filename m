Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59026 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752972AbdHJN4y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 09:56:54 -0400
Date: Thu, 10 Aug 2017 16:56:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org, Rui Miguel Silva <rmfrfs@gmail.com>
Subject: Re: [PATCH v2 1/3] staging: greybus: light: fix memory leak in v4l2
 register
Message-ID: <20170810135650.d62h2g4bxqkndiaa@valkosipuli.retiisi.org.uk>
References: <20170809111555.30147-1-sakari.ailus@linux.intel.com>
 <20170809111555.30147-2-sakari.ailus@linux.intel.com>
 <cec7fc27-25eb-8769-6795-c377307c5f57@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cec7fc27-25eb-8769-6795-c377307c5f57@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Aug 10, 2017 at 03:02:46PM +0200, Hans Verkuil wrote:
> > @@ -534,25 +534,20 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
> >  {
> >  	struct gb_connection *connection = get_conn_from_light(light);
> >  	struct device *dev = &connection->bundle->dev;
> > -	struct v4l2_flash_config *sd_cfg;
> > +	struct v4l2_flash_config sd_cfg = { {0} };
> 
> Just use '= {};'

This is GCC specific whereas { {0} } is standard C. The latter is thus
obviously better IMO.

> 
> >  	struct led_classdev_flash *fled;
> >  	struct led_classdev *iled = NULL;
> >  	struct gb_channel *channel_torch, *channel_ind, *channel_flash;
> > -	int ret = 0;
> > -
> > -	sd_cfg = kcalloc(1, sizeof(*sd_cfg), GFP_KERNEL);
> > -	if (!sd_cfg)
> > -		return -ENOMEM;
> >  
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
> > @@ -561,27 +556,21 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
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
> > -	if (IS_ERR_OR_NULL(light->v4l2_flash)) {
> > -		ret = PTR_ERR(light->v4l2_flash);
> > -		goto out_free;
> > -	}
> > +					    &v4l2_flash_ops, &sd_cfg);
> > +	if (IS_ERR_OR_NULL(light->v4l2_flash))
> 
> Just IS_ERR since v4l2_flash_init() never returns NULL.

Will fix.

> 
> > +		return PTR_ERR(light->v4l2_flash);
> >  
> > -	return ret;
> > -
> > -out_free:
> > -	kfree(sd_cfg);
> > -	return ret;
> > +	return 0;
> >  }
> >  
> >  static void gb_lights_light_v4l2_unregister(struct gb_light *light)
> > 
> 
> After those two changes:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
