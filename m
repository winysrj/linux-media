Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdHQSNI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 14:13:08 -0400
Date: Thu, 17 Aug 2017 11:13:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Johan Hovold <johan@kernel.org>, greybus-dev@lists.linaro.org,
        jacek.anaszewski@gmail.com, viresh.kumar@linaro.org,
        linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3.2 2/3] v4l2-flash-led-class: Create separate
 sub-devices for indicators
Message-ID: <20170817181310.GA4227@kroah.com>
References: <20170810154947.2283-3-sakari.ailus@linux.intel.com>
 <20170815112811.17212-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170815112811.17212-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 15, 2017 at 02:28:11PM +0300, Sakari Ailus wrote:
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
> Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com> (for greybus/light)
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> since v3.2:

"3.2"?

Isn't that just "v5"?  Please don't be cute with version numbering, we
have a hard time telling what is going on, make it obvious...

thanks,

greg k-h
