Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59189 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965462AbbD1MGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 08:06:20 -0400
Date: Tue, 28 Apr 2015 15:05:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: [PATCH v6 07/10] Documentation: leds: Add description of
 v4l2-flash sub-device
Message-ID: <20150428120546.GG3188@valkosipuli.retiisi.org.uk>
References: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
 <1430205530-20873-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1430205530-20873-8-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Tue, Apr 28, 2015 at 09:18:47AM +0200, Jacek Anaszewski wrote:
...
> +On remove the v4l2_flash_release function has to be called, which takes one
> +argument - struct v4l2_flash pointer returned previously by v4l2_flash_init.
> +
> +Please refer to drivers/leds/leds-max77693.c for an exemplary usage of the
> +v4l2 flash API.

s/v4l2 flash API/V4L2 flash wrapper/ .

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
