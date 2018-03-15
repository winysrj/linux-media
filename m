Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36594 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932327AbeCOPab (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 11:30:31 -0400
Subject: Re: [PATCH v2 1/4] media: i2c: Copy mt9t112 soc_camera sensor driver
To: jacopo mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1520862185-17150-1-git-send-email-jacopo+renesas@jmondi.org>
 <1520862185-17150-2-git-send-email-jacopo+renesas@jmondi.org>
 <20180315113533.cwgf7g7sir7gyplk@valkosipuli.retiisi.org.uk>
 <20180315143856.GF16424@w540>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d1cfdb88-ec5d-5229-6fd7-0916905fc8e8@xs4all.nl>
Date: Thu, 15 Mar 2018 08:30:21 -0700
MIME-Version: 1.0
In-Reply-To: <20180315143856.GF16424@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2018 07:38 AM, jacopo mondi wrote:
> Hi Sakari,
>    thanks for looking into this!
> 
> On Thu, Mar 15, 2018 at 01:35:34PM +0200, Sakari Ailus wrote:
>> Hi Jacopo,
>>
>> I wonder if it'd make sense to just make all the changes to the driver and
>> then have it reviewed; I'm not sure the old driver can be said to have been
>> in a known-good state that'd be useful to compare against. I think you did
>> that with another driver as well.
>>
> 
> Well, I understand this is still debated, and I see your point.
> As far as I can tell the driver had been developed to work with SH4
> Ecovec boards and there tested.
> 
> I'm not sure I fully got you here though. Are you proposing to
> squash my next patch that cleans up the driver into this one and
> propose it as a completely new driver to be reviewed from scratch?
> 
> In the two previous driver I touched in this "remove soc_camera"
> journey (ov772x and tw9910) I have followed this same pattern: copy
> the soc_camera driver without removing the existing one, and pile on
> top my changes/cleanups in another patch. Then port the board code to
> use the new sensor driver, and the new CEU driver as well.
> 
> Also, how would you like to proceed here? Hans sent a pull request for
> the series, should I go with incremental changes on top of this?

I don't want to postpone this conversion. The i2c/mt9t112.c is bug-compatible
with i2c/soc-camera/mt9t112.c which is good enough for me. Being able to
remove soc-camera in the (hopefully very) near future is the most important
thing here.

Once Jacopo can actually test the sensor, then that's a good time to review
the driver in more detail.

This reminded me that I actually started testing this sensor a year
ago (I bought the same sensor on ebay, I completely forgot about that!).

My attempt is here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=mt9t112

I never finished it because I had no documentation on the pinout and never
got around to hooking my oscilloscope up to it to figure this out. I was
testing this with the atmel-isc.c driver.

This might be of some use to you, Jacopo, once you have the sensor.

Regards,

	Hans
