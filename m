Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32896 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdIMRyD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 13:54:03 -0400
Subject: Re: as3645a flash userland interface
To: Pavel Machek <pavel@ucw.cz>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd> <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
 <20170912215529.GA17218@amd>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <21824758-28a1-7007-6db5-86a900025d14@gmail.com>
Date: Wed, 13 Sep 2017 19:53:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170912215529.GA17218@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2017 11:55 PM, Pavel Machek wrote:
> On Tue 2017-09-12 20:53:33, Jacek Anaszewski wrote:
>> Hi Pavel,
>>
>> On 09/12/2017 12:36 PM, Pavel Machek wrote:
>>> Hi!
>>>
>>> There were some changes to as3645a flash controller. Before we have
>>> stable interface we have to keep forever I want to ask:
>>
>> Note that we have already two LED flash class drivers - leds-max77693
>> and leds-aat1290. They have been present in mainline for over two years
>> now.
> 
> Well.. that's ok. No change there is neccessary.
> 
>>> What directory are the flash controls in?
>>>
>>> /sys/class/leds/led-controller:flash ?
>>>
>>> Could we arrange for something less generic, like
>>>
>>> /sys/class/leds/main-camera:flash ?
>>
>> I'd rather avoid overcomplicating this. LED class device name pattern
>> is well defined to devicename:colour:function
>> (see Documentation/leds/leds-class.txt, "LED Device Naming" section).
>>
>> In this case "flash" in place of the "function" segment makes the
>> things clear enough I suppose.
> 
> It does not.
> 
> Phones usually have two cameras, front and back, and these days both
> cameras have their flash.
> 
> And poor userspace flashlight application can not know if as3645
> drivers front LED or back LED. Thus, I'd set devicename to
> front-camera or main-camera -- because that's what it is associated
> with. Userspace does not care what hardware drives the LED, but needs
> to know if it is front or back camera.

The name of a LED flash class device isn't fixed and is derived
from DT label property. Name in the example of some DT bindings
will not force people to apply similar pattern for the other
drivers and even for the related one. No worry about having
to keep anything forever basing on that.

-- 
Best regards,
Jacek Anaszewski
