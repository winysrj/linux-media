Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34515 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753779AbdHIQJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 12:09:16 -0400
Date: Wed, 9 Aug 2017 17:09:12 +0100
From: Rui Miguel Silva <rmfrfs@gmail.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org
Subject: Re: [PATCH v2 2/3] v4l2-flash-led-class: Create separate sub-devices
 for indicators
Message-ID: <20170809160912.GC10002@arch-late.localdomain>
References: <20170809111555.30147-1-sakari.ailus@linux.intel.com>
 <20170809111555.30147-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809111555.30147-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Wed, Aug 09, 2017 at 02:15:54PM +0300, Sakari Ailus wrote:
> The V4L2 flash interface allows controlling multiple LEDs through a single
> sub-devices if, and only if, these LEDs are of different types. This
> approach scales badly for flash controllers that drive multiple flash LEDs
> or for LED specific associations. Essentially, the original assumption of a
> LED driver chip that drives a single flash LED and an indicator LED is no
> longer valid.
> 
> Address the matter by registering one sub-device per LED.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/leds/leds-aat1290.c                    |   4 +-
>  drivers/leds/leds-max77693.c                   |   4 +-
>  drivers/media/v4l2-core/v4l2-flash-led-class.c | 113 +++++++++++++++----------
>  drivers/staging/greybus/light.c                |  23 +++--

For greybus/light:
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>

---
Cheers,
	Rui
