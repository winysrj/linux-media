Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37206 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167992AbcKAIYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2016 04:24:30 -0400
Received: by mail-wm0-f45.google.com with SMTP id t79so93445591wmt.0
        for <linux-media@vger.kernel.org>; Tue, 01 Nov 2016 01:24:30 -0700 (PDT)
Subject: Re: [PATCH v6 1/2] media: i2c/ov5645: add the device tree binding
 document
To: Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <5771512.gQUqkxEut4@avalon> <5807398F.9060802@linaro.org>
 <7858186.8cvAlZeXi2@avalon>
 <CAL_JsqJ+58t=ZH6m8vGC-hA_bt8ZR0fX5v+_-7mHOQpBXC2a1Q@mail.gmail.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>, matrandg@cisco.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5818513A.4040006@linaro.org>
Date: Tue, 1 Nov 2016 10:24:26 +0200
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJ+58t=ZH6m8vGC-hA_bt8ZR0fX5v+_-7mHOQpBXC2a1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/26/2016 09:53 PM, Rob Herring wrote:
> On Wed, Oct 19, 2016 at 4:21 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Todor,
>>
>> On Wednesday 19 Oct 2016 12:14:55 Todor Tomov wrote:
>>> On 10/19/2016 11:49 AM, Laurent Pinchart wrote:
>>>> On Friday 14 Oct 2016 15:01:08 Todor Tomov wrote:
>>>>> On 09/08/2016 03:22 PM, Laurent Pinchart wrote:
>>>>>> On Thursday 08 Sep 2016 12:13:54 Todor Tomov wrote:
>>>>>>> Add the document for ov5645 device tree binding.
>>>>>>>
>>>>>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>>>>>> ---
>>>>>>>
>>>>>>>  .../devicetree/bindings/media/i2c/ov5645.txt       | 52 ++++++++++++++
>>>>>>>  1 file changed, 52 insertions(+)
>>>>>>>  create mode 100644
>>>>>>>  Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>>>>>
>>>>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>>>>> b/Documentation/devicetree/bindings/media/i2c/ov5645.txt new file mode
>>>>>>> 100644
>>>>>>> index 0000000..bcf6dba
>>>>>>> --- /dev/null
>>>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>>>>> @@ -0,0 +1,52 @@
>>>>>>> +* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
>>>>>>> +
>>>>>>> +The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image
>>>>>>> sensor with
>>>>>>> +an active array size of 2592H x 1944V. It is programmable through a
>>>>>>> serial I2C
>>>>>>> +interface.
>>>>>>> +
>>>>>>> +Required Properties:
>>>>>>> +- compatible: Value should be "ovti,ov5645".
>>>>>>> +- clocks: Reference to the xclk clock.
>>>>>>> +- clock-names: Should be "xclk".
>>>>>>> +- clock-frequency: Frequency of the xclk clock.
>>>>>>> +- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH.
>>>>
>>>> By the way, isn't the pin called pwdnb and isn't it active low ?
>>>
>>> Yes, the pin is called "pwdnb" and is active low (must be up for power to be
>>> up). I have changed the name to "enable" as it is more generally used -
>>> this change was suggested by Rob Herring. As the logic switches with this
>>> change of the name I have stated it is active high which ends up in the
>>> same condition (enable must be up for the power to be up). I think this is
>>> correct, isn't it?
>>
>> I thought that the rule was to name the GPIO properties based on the name of
>> the pin. I could be wrong though. Rob, what's your opinion ?
> 
> Generally, yes that is the rule. However, an enable (or powerdown
> being the inverse) pin is so common that I think it makes sense to use
> a common name. Then generic power sequencing code can power up devices
> (in the simple cases at least).

Ok, so what can we decide about this case? I personally have a slight preference
for the name same as documentation. But I think most important is to follow the
rule if we have such a rule. If we don't have a single rule to follow every time
then it is not really important which one we will choose.

> 
> Rob
> 

-- 
Best regards,
Todor Tomov
