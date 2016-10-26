Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754315AbcJZSyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 14:54:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D0721203AA
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 18:54:08 +0000 (UTC)
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com [209.85.161.177])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D956203A0
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 18:54:05 +0000 (UTC)
Received: by mail-yw0-f177.google.com with SMTP id h14so15896963ywa.2
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 11:54:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7858186.8cvAlZeXi2@avalon>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <5771512.gQUqkxEut4@avalon> <5807398F.9060802@linaro.org> <7858186.8cvAlZeXi2@avalon>
From: Rob Herring <robh+dt@kernel.org>
Date: Wed, 26 Oct 2016 13:53:44 -0500
Message-ID: <CAL_JsqJ+58t=ZH6m8vGC-hA_bt8ZR0fX5v+_-7mHOQpBXC2a1Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] media: i2c/ov5645: add the device tree binding document
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Todor Tomov <todor.tomov@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>, matrandg@cisco.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 19, 2016 at 4:21 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Todor,
>
> On Wednesday 19 Oct 2016 12:14:55 Todor Tomov wrote:
>> On 10/19/2016 11:49 AM, Laurent Pinchart wrote:
>> > On Friday 14 Oct 2016 15:01:08 Todor Tomov wrote:
>> >> On 09/08/2016 03:22 PM, Laurent Pinchart wrote:
>> >>> On Thursday 08 Sep 2016 12:13:54 Todor Tomov wrote:
>> >>>> Add the document for ov5645 device tree binding.
>> >>>>
>> >>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> >>>> ---
>> >>>>
>> >>>>  .../devicetree/bindings/media/i2c/ov5645.txt       | 52 ++++++++++++++
>> >>>>  1 file changed, 52 insertions(+)
>> >>>>  create mode 100644
>> >>>>  Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> >>>>
>> >>>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> >>>> b/Documentation/devicetree/bindings/media/i2c/ov5645.txt new file mode
>> >>>> 100644
>> >>>> index 0000000..bcf6dba
>> >>>> --- /dev/null
>> >>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> >>>> @@ -0,0 +1,52 @@
>> >>>> +* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
>> >>>> +
>> >>>> +The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image
>> >>>> sensor with
>> >>>> +an active array size of 2592H x 1944V. It is programmable through a
>> >>>> serial I2C
>> >>>> +interface.
>> >>>> +
>> >>>> +Required Properties:
>> >>>> +- compatible: Value should be "ovti,ov5645".
>> >>>> +- clocks: Reference to the xclk clock.
>> >>>> +- clock-names: Should be "xclk".
>> >>>> +- clock-frequency: Frequency of the xclk clock.
>> >>>> +- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH.
>> >
>> > By the way, isn't the pin called pwdnb and isn't it active low ?
>>
>> Yes, the pin is called "pwdnb" and is active low (must be up for power to be
>> up). I have changed the name to "enable" as it is more generally used -
>> this change was suggested by Rob Herring. As the logic switches with this
>> change of the name I have stated it is active high which ends up in the
>> same condition (enable must be up for the power to be up). I think this is
>> correct, isn't it?
>
> I thought that the rule was to name the GPIO properties based on the name of
> the pin. I could be wrong though. Rob, what's your opinion ?

Generally, yes that is the rule. However, an enable (or powerdown
being the inverse) pin is so common that I think it makes sense to use
a common name. Then generic power sequencing code can power up devices
(in the simple cases at least).

Rob
