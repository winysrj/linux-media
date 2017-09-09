Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33612 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750935AbdIIWGN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 18:06:13 -0400
Date: Sun, 10 Sep 2017 01:06:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [RFC] et8ek8: Add support for flash and lens devices
Message-ID: <20170909220610.mireq3wv6leokvjk@valkosipuli.retiisi.org.uk>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-18-sakari.ailus@linux.intel.com>
 <20170909214724.GA18677@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170909214724.GA18677@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Sat, Sep 09, 2017 at 11:47:24PM +0200, Pavel Machek wrote:
> 
> Parse async sub-devices by using
> v4l2_subdev_fwnode_reference_parse_sensor_common().
> 
> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the et8ek8 driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz> # Not yet ready -- broken whitespace
> 
> ---
> 
> Whitespace is horribly bad. But otherwise... does it look ok?

It mostly mirrors the smiapp driver implementation and, well, is an issue.
Namely it's lacking releasing the notifier's resources, just like the
smiapp driver. I'll update the smiapp patch --- the notifier's resources
need to be released by calling v4l2_async_notifier_release(); see the 5th
patch.

Other than that it seems good.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
