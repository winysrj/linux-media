Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36568 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754461AbaFPIx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 04:53:26 -0400
Date: Mon, 16 Jun 2014 11:53:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: "LED / flash API integration" related improvements
Message-ID: <20140616085321.GP2073@valkosipuli.retiisi.org.uk>
References: <536CE61C.8010205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536CE61C.8010205@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek and others,

Comments from the LED API folks would be highly appreciated.

(Cc linux-media as well.)

My comments below.

On Fri, May 09, 2014 at 04:28:44PM +0200, Jacek Anaszewski wrote:
> During review of "LED / flash API integration" patch sets two issues
> requiring modifications in the LED subsystem core emerged.
> I would like to consult possible ways of solving them:
> 
> 1.
> ==================================================================
> 
> Some LED devices allow to control multiple LEDs independently.
> Currently there is no direct support for this in the LED subsystem
> and existing drivers register separate devices for each LED.
> 
> LED / flash API integration effort is a good opportunity to provide
> support for exposing multiple LEDs by a single LED class device.
> 
> I would like to add following API:
> 
> /**
>  * led_get_sub_leds_number - get the number of exposed LEDs
>  * @led_cdev: the LED to query
>  * @num_leds: number of exposed leds
>  *
>  * Get the number of leds exposed by the device.
>  *
>  * Returns: 0 on success or negative error value on failure
>  */
> int led_get_sub_leds_number(struct led_classdev *led_cdev,
>                         int *num_leds);
> 
> /**
>  * led_select_sub_led - select sub led to control
>  * @led_cdev: the LED to set
>  * @led_id: id of the sub led to control
>  *
>  * Set the sub led to be the target of the LED class API calls.
>  * Maximum led_id equals num_leds - 1.
>  *
>  * Returns: 0 on success or negative error value on failure
>  */
> int led_select_sub_led(struct led_classdev *led_cdev,
>                     int led_id);

Instead of this, how about using an array indexed by LED for the other
functions?

The problem with this is that often the registers to control LED specific
properties contain the same configuration for another LED. The driver should
thus cache the information until it needs to be applied, and I don't think
configuring everything for every LED separately makes sense for either the
user nor the driver.

Caching the configuration before applying it should still be done since this
way extra register accesses can be avoided: registers often share different
kind of configurations such as timeout and current as well. The
configuration should be applied once an apply fonction is called.

> /**
>  * led_get_sub_led - get currently selected sub led
>  * @led_cdev: the LED to set
>  * @led_id: id of currently selected sub led
>  *
>  * Get id of the sub led chosen as the target of LED class
>  * API calls. Maximum led_id equals num_leds - 1.
>  *
>  * Returns: 0 on success or negative error value on failure
>  */
> int led_get_target_led(struct led_classdev *led_cdev,
>                         int* led_id);
> 
> The functions functions would be mapped on the sysfs attributes:
> - available_leds - RO
> - sub_led_id - RW

This kind of interface isn't going to be compatible with existing
applications. If you want to keep the compatibility, the LEDs would probably
need to be exposed as separate devices. If that's not a requirement, I'd use
an array here as well.

The V4L2 driver would still expose the device as a single sub-device.
Controls that apply to individual LEDs would be array controls.

> The attributes would be created only if the related callbacks
> are registered by the driver.
> 
> 2.
> ==================================================================
> 
> The second issue, refers to the work queues being used in the
> brightness_set callbacks of the LED subsystem drivers. It interferes
> with the way how V4L2 Flash controls work, which expect that setting
> flash brightness has immediate effect.
> 
> Proposed solutions:
> - move work queues out from the drivers to the LED core.
> - add brightness_set_now callback to be registered by
>   the LED drivers and intended for call by v4l2-flash driver;
>   it wouldn't schedule a work but do the job immediately

I favour the former, but the latter could be used to leave the existing
callback as a compatibility means until all drivers are converted. This
would probably be more work in total though than doing everything in a
single patchset.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
