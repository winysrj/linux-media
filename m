Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46205 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbdINJYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 05:24:18 -0400
Subject: Re: as3645a flash userland interface
To: Pavel Machek <pavel@ucw.cz>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <4bf12e8e-beff-0199-cdee-4a52ebe7cdaf@samsung.com>
Date: Thu, 14 Sep 2017 11:24:10 +0200
MIME-version: 1.0
In-reply-to: <21824758-28a1-7007-6db5-86a900025d14@gmail.com>
Content-type: text/plain; charset="windows-1252"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
        <20170912084236.1154-25-sakari.ailus@linux.intel.com>
        <20170912103628.GB27117@amd>
        <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
        <20170912215529.GA17218@amd>
        <21824758-28a1-7007-6db5-86a900025d14@gmail.com>
        <CGME20170914092415epcas2p26c049a698851778673034c16afb290b9@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/13/2017 07:53 PM, Jacek Anaszewski wrote:
> On 09/12/2017 11:55 PM, Pavel Machek wrote:
>> On Tue 2017-09-12 20:53:33, Jacek Anaszewski wrote:
>>> On 09/12/2017 12:36 PM, Pavel Machek wrote:

>>>> What directory are the flash controls in?
>>>>
>>>> /sys/class/leds/led-controller:flash ?
>>>>
>>>> Could we arrange for something less generic, like
>>>>
>>>> /sys/class/leds/main-camera:flash ?
>>>
>>> I'd rather avoid overcomplicating this. LED class device name pattern
>>> is well defined to devicename:colour:function
>>> (see Documentation/leds/leds-class.txt, "LED Device Naming" section).
>>>
>>> In this case "flash" in place of the "function" segment makes the
>>> things clear enough I suppose.
>>
>> It does not.
>>
>> Phones usually have two cameras, front and back, and these days both
>> cameras have their flash.
>>
>> And poor userspace flashlight application can not know if as3645
>> drivers front LED or back LED. Thus, I'd set devicename to
>> front-camera or main-camera -- because that's what it is associated
>> with. Userspace does not care what hardware drives the LED, but needs
>> to know if it is front or back camera.
> 
> The name of a LED flash class device isn't fixed and is derived
> from DT label property. Name in the example of some DT bindings
> will not force people to apply similar pattern for the other
> drivers and even for the related one. No worry about having
> to keep anything forever basing on that.

Isn't the V4L2 subdev/Media Controller API supposed to provide means
for associating flash LEDs with camera sensors? You seem to be insisting
on using the sysfs leds interface for that, which is not a primary
interface for camera flash AFAICT.

-- 
Regards,
Sylwester
