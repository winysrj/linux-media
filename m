Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47327 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751524AbbCUWzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 18:55:36 -0400
Date: Sun, 22 Mar 2015 00:55:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v1 03/11] leds: Add driver for AAT1290 current regulator
Message-ID: <20150321225502.GF16613@valkosipuli.retiisi.org.uk>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-4-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426863811-12516-4-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Mar 20, 2015 at 04:03:23PM +0100, Jacek Anaszewski wrote:
...
> +static int aat1290_led_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct aat1290_led *led;
> +	struct led_classdev *led_cdev;
> +	struct led_classdev_flash *fled_cdev;
> +	struct aat1290_led_settings settings;
> +	int ret;
> +
> +	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->pdev = pdev;
> +	platform_set_drvdata(pdev, led);
> +
> +	fled_cdev = &led->fled_cdev;
> +	led_cdev = &fled_cdev->led_cdev;
> +
> +	ret = aat1290_led_parse_dt(led);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!led_cdev->name)
> +		led_cdev->name = AAT1290_NAME;
> +
> +	/* Init flash settings */
> +	aat1290_init_flash_settings(led, &settings);
> +
> +	fled_cdev->timeout = settings.flash_timeout;
> +	fled_cdev->ops = &flash_ops;
> +
> +	/* Init LED class */
> +	led_cdev->brightness_set = aat1290_led_brightness_set;
> +	led_cdev->brightness_set_sync = aat1290_led_brightness_set_sync;
> +	led_cdev->max_brightness = AAT1290_MM_CURRENT_SCALE_SIZE;
> +	led_cdev->flags |= LED_DEV_CAP_FLASH;
> +
> +	INIT_WORK(&led->work_brightness_set, aat1290_brightness_set_work);
> +
> +	/* Register in the LED subsystem. */
> +	ret = led_classdev_flash_register(&pdev->dev, fled_cdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_init(&led->lock);

I think you must initialise the mutex before led_classdev_flash_register(),
as this exposes the device to the user. Remember mutex_destroy() in error
handling.

> +	return 0;
> +}
> +
> +static int aat1290_led_remove(struct platform_device *pdev)
> +{
> +	struct aat1290_led *led = platform_get_drvdata(pdev);
> +
> +	led_classdev_flash_unregister(&led->fled_cdev);
> +	cancel_work_sync(&led->work_brightness_set);
> +
> +	mutex_destroy(&led->lock);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id aat1290_led_dt_match[] = {
> +	{.compatible = "skyworks,aat1290"},

{ .compatible ... 1290" },

With the two issues fixed,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +	{},
> +};
> +
> +static struct platform_driver aat1290_led_driver = {
> +	.probe		= aat1290_led_probe,
> +	.remove		= aat1290_led_remove,
> +	.driver		= {
> +		.name	= "aat1290",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = aat1290_led_dt_match,
> +	},
> +};
> +
> +module_platform_driver(aat1290_led_driver);
> +
> +MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
> +MODULE_DESCRIPTION("Skyworks Current Regulator for Flash LEDs");
> +MODULE_LICENSE("GPL v2");

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
