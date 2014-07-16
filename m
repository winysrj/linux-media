Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933938AbaGPPf6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jul 2014 11:35:58 -0400
Message-ID: <53C69BCF.8030307@iki.fi>
Date: Wed, 16 Jul 2014 18:35:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
CC: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v4 02/21] leds: implement sysfs interface locking
 mechanism
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com> <1405087464-13762-3-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1405087464-13762-3-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

Thank you for the update!

Jacek Anaszewski wrote:
...
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 71b40d3..4d7cb31 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -126,3 +126,21 @@ void led_set_brightness(struct led_classdev *led_cdev,
>   	__led_set_brightness(led_cdev, brightness);
>   }
>   EXPORT_SYMBOL(led_set_brightness);
> +
> +/* Caller must ensure led_cdev->led_lock held */
> +void led_sysfs_lock(struct led_classdev *led_cdev)
> +{
> +	WARN_ON(!mutex_is_locked(&led_cdev->led_lock));

How about lockdep_assert_held() instead?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
