Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52007 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751127AbdHaKbS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 06:31:18 -0400
Subject: Re: [PATCHv3 3/5] dt-bindings: document the CEC GPIO bindings
To: Linus Walleij <linus.walleij@linaro.org>
References: <20170830161044.26571-1-hverkuil@xs4all.nl>
 <20170830161044.26571-4-hverkuil@xs4all.nl>
 <CACRpkdZxoHbM2T-McdinK3gJJ9uEq9hwX+mH=13s0AkGArhJFw@mail.gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c80b4369-b592-228f-3781-d1a32af6278a@xs4all.nl>
Date: Thu, 31 Aug 2017 12:31:13 +0200
MIME-Version: 1.0
In-Reply-To: <CACRpkdZxoHbM2T-McdinK3gJJ9uEq9hwX+mH=13s0AkGArhJFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/08/17 11:20, Linus Walleij wrote:
> On Wed, Aug 30, 2017 at 6:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Document the bindings for the cec-gpio module for hardware where the
>> CEC pin and optionally the HPD pin are connected to GPIO pins.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I usually refer to GPIO "lines" rather than "pins" for clarity.
> It's because some systems also have pin control, and then it becomes
> a bit muddy what is a pin.

I'll change the terminology.

>> +* HDMI CEC GPIO driver
>> +
>> +The HDMI CEC GPIO module supports CEC implementations where the CEC pin
>> +is hooked up to a pull-up GPIO pin and - optionally - the HPD pin is
>> +hooked up to a pull-down GPIO pin.
>> +
>> +Required properties:
>> +  - compatible: value must be "cec-gpio"
>> +  - cec-gpio: gpio that the CEC line is connected to
>> +
>> +Optional property:
>> +  - hpd-gpio: gpio that the HPD line is connected to
>> +
>> +Example for the Raspberry Pi 3 where the CEC line is connected to
>> +pin 26 aka BCM7 aka CE1 on the GPIO pin header and the HPD line is
>> +connected to pin 11 aka BCM17:
>> +
>> +cec-gpio@7 {
>> +       compatible = "cec-gpio";
>> +       cec-gpio = <&gpio 7 GPIO_ACTIVE_HIGH>;
>> +       hpd-gpio = <&gpio 17 GPIO_ACTIVE_HIGH>;
>> +};
> 
> So what I understood from the driver is that the cec-gpio is maybe actually
> an open drain output line, so in that case it should be stated in the docs and
> cec-gpio  = <&gpio 7 GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN>
> or GPIO_LINE_OPEN_DRAIN if it is not also single-ended.

Yes, I agree, it's open drain. I'm not sure whether or not it is single-ended.
I'm not sure what the difference is, and I have no electronics background.

Looking at fwnode_get_named_gpiod() it seems that it has to be single-ended
for GPIO_OPEN_DRAIN to be set, so I am going with that. It works, so it is
probably right :-)

Regards,

	Hans
