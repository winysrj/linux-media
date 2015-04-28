Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59141 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965373AbbD1MBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 08:01:39 -0400
Date: Tue, 28 Apr 2015 15:01:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v6 06/10] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20150428120135.GF3188@valkosipuli.retiisi.org.uk>
References: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
 <1430205530-20873-7-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1430205530-20873-7-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Tue, Apr 28, 2015 at 09:18:46AM +0200, Jacek Anaszewski wrote:
...
> +enum ctrl_init_data_id {
> +	LED_MODE,
> +	TORCH_INTENSITY,
> +	FLASH_INTENSITY,
> +	INDICATOR_INTENSITY,
> +	FLASH_TIMEOUT,
> +	STROBE_SOURCE,
> +	/*
> +	 * Only above values are applicable to
> +	 * the 'ctrls' array in the struct v4l2_flash.
> +	 */
> +	FLASH_STROBE,
> +	STROBE_STOP,
> +	STROBE_STATUS,
> +	FLASH_FAULT,
> +	NUM_FLASH_CTRLS,
> +};

How about moving these to the .c file and allocating space for struct
v4l2_flash.ctrls?

I don't object this enum as such, but the names are pretty generic and
there's a single instance of using them in the header which easily can be
avoided.

With this change,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
