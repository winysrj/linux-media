Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34920 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751381AbdILKrY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 06:47:24 -0400
Date: Tue, 12 Sep 2017 13:47:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: as3645a flash userland interface
Message-ID: <20170912104720.ifyouc5pa5et6gzk@valkosipuli.retiisi.org.uk>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170912103628.GB27117@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Sep 12, 2017 at 12:36:28PM +0200, Pavel Machek wrote:
> Hi!
> 
> There were some changes to as3645a flash controller. Before we have
> stable interface we have to keep forever I want to ask:
> 
> What directory are the flash controls in?
> 
> /sys/class/leds/led-controller:flash ?
> 
> Could we arrange for something less generic, like
> 
> /sys/class/leds/main-camera:flash ?
> 
> Thanks,

The LEDs are called as3645a:flash and as3645a:indicator currently, based on
the name of the LED controller's device node. There are no patches related
to this set though; these have already been merged.

The label should be a "human readable string describing the device" (from
ePAPR, please excuse me for not having a newer spec), and the led common
bindings define it as:

- label : The label for this LED. If omitted, the label is taken from the node
          name (excluding the unit address). It has to uniquely identify
          a device, i.e. no other LED class device can be assigned the same
          label.

I don't think that you should be looking to use this to associate it with
the camera as such. The association information with the sensor is
available to the kernel but there's no interface that could meaningfully
expose it to the user right now.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
