Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50486 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751164AbdIOIk7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 04:40:59 -0400
Subject: Re: [PATCHv4 3/5] dt-bindings: document the CEC GPIO bindings
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170831110156.11018-1-hverkuil@xs4all.nl>
 <20170831110156.11018-4-hverkuil@xs4all.nl>
 <20170912144308.j53eclicbhay5dsz@rob-hp-laptop>
 <30a2fa9d-1aa9-84c1-7842-05167eee73d3@xs4all.nl>
Message-ID: <89739d22-bce2-e31e-fd00-5e7c2fae2148@xs4all.nl>
Date: Fri, 15 Sep 2017 10:40:53 +0200
MIME-Version: 1.0
In-Reply-To: <30a2fa9d-1aa9-84c1-7842-05167eee73d3@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 09/13/17 10:21, Hans Verkuil wrote:
> On 09/12/2017 04:43 PM, Rob Herring wrote:
>> On Thu, Aug 31, 2017 at 01:01:54PM +0200, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Document the bindings for the cec-gpio module for hardware where the
>>> CEC line and optionally the HPD line are connected to GPIO lines.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>>  .../devicetree/bindings/media/cec-gpio.txt         | 22 ++++++++++++++++++++++
>>>  1 file changed, 22 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
>>> new file mode 100644
>>> index 000000000000..db20a7452dbd
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
>>> @@ -0,0 +1,22 @@
>>> +* HDMI CEC GPIO driver
>>> +
>>> +The HDMI CEC GPIO module supports CEC implementations where the CEC line
>>> +is hooked up to a pull-up GPIO line and - optionally - the HPD line is
>>> +hooked up to another GPIO line.
>>> +
>>> +Required properties:
>>> +  - compatible: value must be "cec-gpio"
>>> +  - cec-gpio: gpio that the CEC line is connected to
>>
>> cec-gpios
> 
> Will change.
> 
>>
>>> +
>>> +Optional property:
>>> +  - hpd-gpio: gpio that the HPD line is connected to
>>
>> hpd-gpios
> 
> Will change.
> 
>>
>> However, HPD is already part of the HDMI connector binding. Having it in 
>> 2 places would be wrong.
> 
> No. This is not an HDMI receiver/transmitter. There are two use-cases for this
> driver:
> 
> 1) For HDMI receivers/transmitters that connect the CEC pin of an HDMI connector
>    to a GPIO pin. In that case the HPD goes to the HDMI transmitter/receiver and
>    not to this driver. As you say, that would not make any sense.
> 
>    But currently no such devices are in the kernel (I know they exist, though).
>    Once such a driver would appear in the kernel then these bindings need to be
>    extended with an hdmi-phandle.
> 
> 2) This driver is used for debugging CEC like this:
> 
> 	https://hverkuil.home.xs4all.nl/rpi3-cec.jpg
> 
>    Here the CEC pin of an HDMI breakout connector is hooked up to a Raspberry Pi
>    GPIO pin and the RPi monitors it. It's a cheap but very effective CEC analyzer.
>    In this use-case it is very helpful to also monitor the HPD pin since some
>    displays do weird things with the HPD and knowing the state of the HPD helps
>    a lot when debugging CEC problems. It's optional and it only monitors the pin.
> 
>    Actually, there does not have to be an HDMI connector involved at all: you can
>    make two cec-gpio instances and just connect the two GPIO pins together in
>    order to emulate two CEC adapters and play with that.

Is it OK to define a binding but not (yet) implement it? I have seen that in other
bindings (well, OK, one other binding :-) ). If that is fine, then I can write the
following:

----------------------------------------------------------------
Required properties:
  - compatible: value must be "cec-gpio".
  - cec-gpios: gpio that the CEC line is connected to.

If the CEC line is associated with an HDMI receiver/transmitter, then the following
property is also required:

  - hdmi-phandle - phandle to the HDMI controller, see also cec.txt.

If the CEC line is not associated with an HDMI receiver/transmitter, then the
following property is optional:

  - hpd-gpios: gpio that the HPD line is connected to.
----------------------------------------------------------------

I have plans to support hdmi-phandle in the driver, but that probably won't be ready
in time for 4.15.

Regards,

	Hans

> 
>>
>> I think we should have either:
>>
>> hdmi-connector {
>> 	compatible = 'hdmi-connector-a";
>> 	hpd-gpios = <...>;
>> 	cec-gpios = <...>;
>> 	ports {
>> 		// port to HDMI controller
>> 	...
>> 	};
>> };
>>
>> Or:
>>
>> hdmi-connector {
>>         compatible = 'hdmi-connector-a";
>>         hpd-gpios = <...>;
>>         cec = <&cec>;
>>         ... 
>> };
>>
>> cec: cec-gpio {
>> 	compatible = "cec-gpio";
>> 	cec-gpios = <...>;
>> };
>>
>> My preference is probably the former. The latter just helps create a 
>> device to bind to a driver, but DT is not the only way to create 
>> devices. Then again, if you have a phandle to real CEC controllers in 
>> the HDMI connector node, it may make sense to do the same thing with 
>> cec-gpio. 
>>
>>> +
>>> +Example for the Raspberry Pi 3 where the CEC line is connected to
>>> +pin 26 aka BCM7 aka CE1 on the GPIO pin header and the HPD line is
>>> +connected to pin 11 aka BCM17:
>>> +
>>> +cec-gpio@7 {
>>
>> unit address is not valid. Build your dts's with W=2.
> 
> I'll do that.
> 
>>
>>> +       compatible = "cec-gpio";
>>> +       cec-gpio = <&gpio 7 GPIO_OPEN_DRAIN>;
>>> +       hpd-gpio = <&gpio 17 GPIO_ACTIVE_HIGH>;
>>> +};
>>> -- 
>>> 2.14.1
> 
> Regards,
> 
> 	Hans
> 
