Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:41269 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbeJMWGh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 18:06:37 -0400
Subject: Re: [PATCH 1/7] dt-bindings: mfd: ds90ux9xx: add description of TI
 DS90Ux9xx ICs
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-2-vz@mleia.com> <1884479.fINZhmP2Mi@avalon>
CC: Vladimir Zapolskiy <vz@mleia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sandeep Jain <Sandeep_Jain@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <55fe6c51-20e0-a10b-97fd-23c6f030acac@mentor.com>
Date: Sat, 13 Oct 2018 17:28:30 +0300
MIME-Version: 1.0
In-Reply-To: <1884479.fINZhmP2Mi@avalon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

thank you for review, please find my comments below.

On 10/12/2018 02:44 PM, Laurent Pinchart wrote:
> Hi Vladimir,
> 
> Thank you for the patch.
> 
> On Tuesday, 9 October 2018 00:11:59 EEST Vladimir Zapolskiy wrote:
>> From: Sandeep Jain <Sandeep_Jain@mentor.com>
>>
>> The change adds device tree binding description of TI DS90Ux9xx
>> series of serializer and deserializer controllers which support video,
>> audio and control data transmission over FPD-III Link connection.
>>
>> Signed-off-by: Sandeep Jain <Sandeep_Jain@mentor.com>
>> [vzapolskiy: various updates and corrections of secondary importance]
>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>> ---
>>  .../devicetree/bindings/mfd/ti,ds90ux9xx.txt  | 66 +++++++++++++++++++
>>  1 file changed, 66 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
>> b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt new file mode
>> 100644
>> index 000000000000..0733da88f7ef
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
>> @@ -0,0 +1,66 @@
>> +Texas Instruments DS90Ux9xx de-/serializer controllers
>> +
>> +Required properties:
>> +- compatible: Must contain a generic "ti,ds90ux9xx" value and
>> +	may contain one more specific value from the list:
> 
> If it "may" contain one more specific value, when should that value be 
> present, and when can it be absent ?

Practically you can always omit a specific compatible, because (with a number
of minor exceptions like DS90UH925Q case, see a quirk in the code) it is
possible to read out the IC type in runtime.

Nevertheless I prefer to have a complete list of all specific compatibles
to avoid problems with maintenance in future, recently I had a long discussion
with Jassi Brar about iMX* mailbox compatibles on the DT mailing list,
the arguments remain the same, but I don't feel enough internal power to start
another such an exhaustive discussion right at the moment.

>> +	"ti,ds90ub925q",
>> +	"ti,ds90uh925q",
>> +	"ti,ds90ub927q",
>> +	"ti,ds90uh927q",
>> +	"ti,ds90ub926q",
>> +	"ti,ds90uh926q",
>> +	"ti,ds90ub928q",
>> +	"ti,ds90uh928q",
>> +	"ti,ds90ub940q",
>> +	"ti,ds90uh940q".
>> +
>> +Optional properties:
>> +- reg : Specifies the I2C slave address of a local de-/serializer.
> 
> You should explain when the reg property is required and when it isn't. This

Talking about TI DS90Ux9xx IC series, ideally I'd like to shift from
serializer/deserializer concept and promote "remote" and "local" IC, by the
way, and if I'm not mistaken, MOST ICs are truly identical on both ends.

So, here "reg" property is need only if the IC (serializer or deserializer,
it does not matter) is on the "local" side, i.e. it is a slave I2C device
discovered on an I2C bus, which is under control by an application processor.

If IC is on the "remote" side, in other words separated by the serial link
from the "local" IC, then "reg" property is not needed.

> will in my opinion require a more detailed explanation of the DT model for 
> this device.
> 
>> +- power-gpios : GPIO line to control supplied power to the device.
> 
> As Marek mentioned, a regulator would be better. I would make it a mandatory 
> property, as the device always needs to be powered.
> 

I get a memory flashback. Did we discuss recently a right property name to
control panel power by a GPIO or was it something else?

There are quite many properties of exactly the same functionality:
* powerdown-gpios
* pd-gpios
* pdn-gpios
* power-gpios
* powerdn-gpio
* power-down-gpios
* ...

Probably device tree maintainers should unify the names, but my point is that
your argument should be applicable to all such device tree nodes / property
descriptions and usages. Do I understand you correctly?

I would prefer to reference to a regulator while dealing with the power
rails, and reference to a GPIO in case of power control only like in the
case above.

>> +- ti,backward-compatible-mode : Overrides backward compatibility mode.
>> +	Possible values are "<1>" or "<0>".
>> +	If "ti,backward-compatible-mode" is not mentioned, the backward
>> +	compatibility mode is not touched and given by hardware pin strapping.
> 
> This doesn't seem to be a device description to me, it's a software 
> configuration. You should handle it in drivers.
> 

No, it is a hardware description which allows to connect/discover ICs of
different series, please reference to the datasheet for examples of its
usage.

>> +- ti,low-frequency-mode : Overrides low frequency mode.
>> +	Possible values are "<1>" or "<0>".
>> +	If "ti,low-frequency-mode" is not mentioned, the low frequency mode
>> +	is not touched and given by hardware pin strapping.
> 
> This sounds the same. How about giving a real life example of a case where you 
> need to set these two properties to override the pin strapping, for the 
> purpose of discussing the DT bindings ?

I have to ask, what do you mean by "a software configuration"?

Both properties are IC controls (= hardware configuration in my language),
and these hardware properties shall be set (if needed of course) on a "local" IC
*before* a discovery of some "remote" IC, thus the property are in the DT.

>> +- ti,video-map-select-msb: Sets video bridge pins to MSB mode, if it is set
>> +	MAPSEL pin value is ignored.
>> +- ti,video-map-select-lsb: Sets video bridge pins to LSB mode, if it is set
>> +	MAPSEL pin value is ignored.
> 
> I assume those two are mutually exclusive, this should be documented, or you 
> could merge the two properties into one. Same comment as above though, why do 
> you need an override in DT ?
> 

The property are mutually exclusive, but it is a tristate property, please
see my answer to a similar question from Marek.

>> +- ti,pixel-clock-edge : Selects Pixel Clock Edge.
>> +	Possible values are "<1>" or "<0>".
>> +	If "ti,pixel-clock-edge" is High <1>, output data is strobed on the
>> +	Rising edge of the PCLK. If ti,pixel-clock-edge is Low <0>, data is
>> +	strobed on the Falling edge of the PCLK.
>> +	If "ti,pixel-clock-edge" is not mentioned, the pixel clock edge
>> +	value is not touched and given by hardware pin strapping.
> 
> We have a standard property in Documentation/devicetree/bindings/media/video-
> interfaces.txt for this, please use it.
> 

Okay, thank you for the link.

>> +- ti,spread-spectrum-clock-generation : Spread Sprectrum Clock Generation.
>> +	Possible values are from "<0>" to "<7>". The same value will be
>> +	written to SSC register. If "ti,spread-spectrum-clock-gen" is not
>> +	found, then SSCG will be disabled.
> 
> This makes sense in DT in my opinion, as EMC is a system property. I wonder 
> however if exposing the hardware register directly is the best option. Could 
> you elaborate on how a system designer will select which value to use, in 
> order to find the best DT description ?
> 

Hm, I suppose IC datasheets should serve as a better source of information.

>> +TI DS90Ux9xx serializers and deserializer device nodes may contain a number
>> +of children device nodes to describe and enable particular subcomponents
>> +found on ICs.
> 
> As mentioned in my review of the cover letter I don't think this is necessary. 

It is, in my humble opinion if an IC can be described as "a _pinmux_ + loads
of other functions" it makes it an MFD.

> You can make the serializer and deserializer I2C controllers without subnodes. 
> Same goes for GPIO control.
> 

I have to define pinmuxes, one of the complicated and essential parts of IC
configuration is unfairly excluded from the consideration.

>> +Example:
>> +
>> +serializer: serializer@c {
>> +	compatible = "ti,ds90ub927q", "ti,ds90ux9xx";
>> +	reg = <0xc>;
>> +	power-gpios = <&gpio5 12 GPIO_ACTIVE_HIGH>;
>> +	ti,backward-compatible-mode = <0>;
>> +	ti,low-frequency-mode = <0>;
>> +	ti,pixel-clock-edge = <0>;
>> +	...
>> +}
>> +
>> +deserializer: deserializer@3c {
>> +	compatible = "ti,ds90ub940q", "ti,ds90ux9xx";
>> +	reg = <0x3c>;
>> +	power-gpios = <&gpio6 31 GPIO_ACTIVE_HIGH>;
>> +	...
>> +}
>> +
> 
> Extra blank line ?
> 

Right, thank you for comments.

--
Best wishes,
Vladimir
