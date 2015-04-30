Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46927 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbbD3Rr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 13:47:28 -0400
Date: Thu, 30 Apr 2015 19:47:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH v6 05/10] leds: Add driver for AAT1290 flash LED
 controller
Message-ID: <20150430174724.GD23579@amd>
References: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
 <1430205530-20873-6-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1430205530-20873-6-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> +struct aat1290_led_config_data {
> +	/* maximum LED current in movie mode */
> +	u32 max_mm_current;
> +	/* maximum LED current in flash mode */
> +	u32 max_flash_current;
> +	/* maximum flash timeout */
> +	u32 max_flash_tm;

Ok, the comments tell us what should be already obvious from the
variable names... but it would be nice to add units. (mA? uA? msec?)
(I guess in subsequent patch).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
