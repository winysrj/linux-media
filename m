Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44056 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753748AbdIRJMH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 05:12:07 -0400
Date: Mon, 18 Sep 2017 12:12:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: as3645a flash userland interface
Message-ID: <20170918091204.245dewmyruxtfhyb@valkosipuli.retiisi.org.uk>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd>
 <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Tue, Sep 12, 2017 at 08:53:33PM +0200, Jacek Anaszewski wrote:
> Hi Pavel,
> 
> On 09/12/2017 12:36 PM, Pavel Machek wrote:
> > Hi!
> > 
> > There were some changes to as3645a flash controller. Before we have
> > stable interface we have to keep forever I want to ask:
> 
> Note that we have already two LED flash class drivers - leds-max77693
> and leds-aat1290. They have been present in mainline for over two years
> now.
> 
> > What directory are the flash controls in?
> > 
> > /sys/class/leds/led-controller:flash ?
> > 
> > Could we arrange for something less generic, like
> > 
> > /sys/class/leds/main-camera:flash ?
> 
> I'd rather avoid overcomplicating this. LED class device name pattern
> is well defined to devicename:colour:function
> (see Documentation/leds/leds-class.txt, "LED Device Naming" section).
> 
> In this case "flash" in place of the "function" segment makes the
> things clear enough I suppose.

Oh. I have to admit I've completely missed this. :-o

I'll address this in v2 of the as3645a fixes, plus submit related V4L2
flash class documentation fixes a little later.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
