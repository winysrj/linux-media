Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:43651 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbdILSy2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 14:54:28 -0400
Subject: Re: as3645a flash userland interface
To: Pavel Machek <pavel@ucw.cz>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
Date: Tue, 12 Sep 2017 20:53:33 +0200
MIME-Version: 1.0
In-Reply-To: <20170912103628.GB27117@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On 09/12/2017 12:36 PM, Pavel Machek wrote:
> Hi!
> 
> There were some changes to as3645a flash controller. Before we have
> stable interface we have to keep forever I want to ask:

Note that we have already two LED flash class drivers - leds-max77693
and leds-aat1290. They have been present in mainline for over two years
now.

> What directory are the flash controls in?
> 
> /sys/class/leds/led-controller:flash ?
> 
> Could we arrange for something less generic, like
> 
> /sys/class/leds/main-camera:flash ?

I'd rather avoid overcomplicating this. LED class device name pattern
is well defined to devicename:colour:function
(see Documentation/leds/leds-class.txt, "LED Device Naming" section).

In this case "flash" in place of the "function" segment makes the
things clear enough I suppose.

-- 
Best regards,
Jacek Anaszewski
