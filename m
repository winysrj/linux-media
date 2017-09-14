Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39594 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbdINLB2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 07:01:28 -0400
Subject: Re: as3645a flash userland interface
To: Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1f34a891-edb1-251c-86a8-ba4a90c485d3@samsung.com>
Date: Thu, 14 Sep 2017 13:01:19 +0200
MIME-version: 1.0
In-reply-to: <20170914100718.GA3843@amd>
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
        <4bf12e8e-beff-0199-cdee-4a52ebe7cdaf@samsung.com>
        <20170914100718.GA3843@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2017 12:07 PM, Pavel Machek wrote:
>> Isn't the V4L2 subdev/Media Controller API supposed to provide means
>> for associating flash LEDs with camera sensors? You seem to be insisting
>> on using the sysfs leds interface for that, which is not a primary
>> interface for camera flash AFAICT.
 >
> a) subdev/media controller API currently does not provide such means.

Yes, but it should, that's what it was designed for AFAIK.

> b) if we have /sys/class/leds interface to userland, it should be
> useful.

At the same time we shouldn't overcomplicate it with the camera
functionality.

> c) having flashlight application going through media controller API is
> a bad joke.

It doesn't have to, maybe I misunderstood what you exactly ask for.
Nevertheless what's missing is some user visible name/label for each
flash LED, right? Currently enumerating flash LEDs can be done by looking
at the function part of /sys/class/leds/<led-controller>:<colour>:
<function> path.

Could additional information be appended to the <function> part, so
user can identify which LED is which? E.g. "flash(rear)", "flash(front)",
etc. This could be achieved by simply adding label property in DT.
Or is the list of supported <function> strings already standardized?

-- 
Regards,
Sylwester
