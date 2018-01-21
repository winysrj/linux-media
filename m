Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43726 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751079AbeAUKSs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 05:18:48 -0500
Subject: Re: [PATCH v6 6/9] media: i2c: ov772x: Remove soc_camera dependencies
To: jacopo mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <00f1dd19-6420-26ab-0529-a97f2b0de682@xs4all.nl>
 <20180119111917.76wosrokgracbdrz@valkosipuli.retiisi.org.uk>
 <2694661.NEH0HeGgLD@avalon> <20180121093117.GK24926@w540>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        festevam@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8fd4699c-0d51-6cd8-c915-45283b628062@xs4all.nl>
Date: Sun, 21 Jan 2018 11:18:43 +0100
MIME-Version: 1.0
In-Reply-To: <20180121093117.GK24926@w540>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/18 10:31, jacopo mondi wrote:
> Hello Hans, Laurent, Sakari,
> 
> On Fri, Jan 19, 2018 at 02:23:21PM +0200, Laurent Pinchart wrote:
>> Hello,
>>
>> On Friday, 19 January 2018 13:19:18 EET Sakari Ailus wrote:
>>> On Fri, Jan 19, 2018 at 11:47:33AM +0100, Hans Verkuil wrote:
>>>> On 01/19/18 11:24, Hans Verkuil wrote:
>>>>> On 01/16/18 22:44, Jacopo Mondi wrote:
>>>>>> Remove soc_camera framework dependencies from ov772x sensor driver.
>>>>>> - Handle clock and gpios
>>>>>> - Register async subdevice
>>>>>> - Remove soc_camera specific g/s_mbus_config operations
>>>>>> - Change image format colorspace from JPEG to SRGB as the two use the
>>>>>>   same colorspace information but JPEG makes assumptions on color
>>>>>>   components quantization that do not apply to the sensor
>>>>>> - Remove sizes crop from get_selection as driver can't scale
>>>>>> - Add kernel doc to driver interface header file
>>>>>> - Adjust build system
>>>>>>
>>>>>> This commit does not remove the original soc_camera based driver as
>>>>>> long as other platforms depends on soc_camera-based CEU driver.
>>>>>>
>>>>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>>>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>>
>>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Un-acked.
>>>>
>>>> I just noticed that this sensor driver has no enum_frame_interval and
>>>> g/s_parm support. How would a driver ever know the frame rate of the
>>>> sensor without that?
> 
> Does it make any difference if I point out that this series hasn't
> removed any of that code, and the driver was not supporting that
> already? Or was it handled through soc_camera?

That last question is a good one. Can you check?

There are two sh boards that use this sensor. Are you able to test on one
of those boards?

There is reversed engineered code for the ox772x here:
drivers/media/usb/gspca/ov534.c

That appears to handle framerates.

I am very uncomfortable promoting this driver to drivers/media/i2c without
having functioning frame interval handling. It could be as simple as a single
fixed framerate, it doesn't have to be fancy. Without it it is basically
unusable by applications since those typically expect support for this.

Moving it to staging might be another option, with a TODO mentioning this
missing feature.

> 
>>>
>>> s/_parm/_frame_interval/ ?
>>>
>>> We should have wrappers for this or rather to convert g/s_parm users to
>>> g/s_frame_interval so drivers don't need to implement both.
>>
>> There are two ways to set the frame interval, either explicitly through the
>> s_frame_interval operation, or implicitly through control of the pixel clock,
>> horizontal blanking and vertical blanking (which in turn can be influenced by
>> the exposure time).
>>
>> Having two ways to perform the same operation seems sub-optimal to me, but I
>> could understand if they covered different use cases. As far as I know we
>> don't document the use cases for those methods. What's your opinion on that ?
>>
> 
> -If- I have to implement that in this series to have it accepted,
> please let me know which one of the two is the preferred one :)

g/s_frame_interval. The other is (I think) for highly specialized devices. For
regular normal sensors I do not think it makes much sense. Certainly not for
fairly old sensors like this one.

Regards,

	Hans
