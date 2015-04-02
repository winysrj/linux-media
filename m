Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39452 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbbDBOlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2015 10:41:36 -0400
Date: Thu, 2 Apr 2015 16:41:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
Message-ID: <20150402144134.GA18125@amd>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 2015-03-31 15:52:37, Jacek Anaszewski wrote:
> Description of flash LEDs related properties was not precise regarding
> the state of corresponding settings in case a property is missing.
> Add relevant statements.
> Removed is also the requirement making the flash-max-microamp
> property obligatory for flash LEDs. It was inconsistent as the property
> is defined as optional. Devices which require the property will have
> to assert this in their DT bindings.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Acked-by: Pavel Machek <pavel@ucw.cz>

> diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
> index 747c538..21a25e4 100644
> --- a/Documentation/devicetree/bindings/leds/common.txt
> +++ b/Documentation/devicetree/bindings/leds/common.txt
> @@ -29,13 +29,15 @@ Optional properties for child nodes:
>       "ide-disk" - LED indicates disk activity
>       "timer" - LED flashes at a fixed, configurable rate
>  
> -- max-microamp : maximum intensity in microamperes of the LED
> -		 (torch LED for flash devices)
> -- flash-max-microamp : maximum intensity in microamperes of the
> -                       flash LED; it is mandatory if the LED should
> -		       support the flash mode
> -- flash-timeout-us : timeout in microseconds after which the flash
> -                     LED is turned off
> +- max-microamp : Maximum intensity in microamperes of the LED
> +		 (torch LED for flash devices). If omitted this will default
> +		 to the maximum current allowed by the device.
> +- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
> +		       If omitted this will default to the maximum
> +		       current allowed by the device.
> +- flash-timeout-us : Timeout in microseconds after which the flash
> +                     LED is turned off. If omitted this will default to the
> +		     maximum timeout allowed by the device.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
