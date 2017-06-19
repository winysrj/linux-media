Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751768AbdFSVSo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 17:18:44 -0400
Subject: Re: [PATCH v3 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <cover.1497630695.git.joabreu@synopsys.com>
 <51851d7b2335cc8a10fba17056314d7fa8ce88d1.1497630695.git.joabreu@synopsys.com>
 <f58aaeaa-3e49-3cbc-0ed8-8c3a6ebd3907@gmail.com>
 <28d2ca0e-d9bc-816a-313c-e367aaed166e@synopsys.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <4c75eb0d-04a6-571d-f4a2-5887ff57695f@kernel.org>
Date: Mon, 19 Jun 2017 23:18:35 +0200
MIME-Version: 1.0
In-Reply-To: <28d2ca0e-d9bc-816a-313c-e367aaed166e@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2017 11:01 AM, Jose Abreu wrote:
> Using fixed-clock was already in my todo list. Regarding phy I
> need to pass pdata so that the callbacks between controller and
> phy are established. I also need to make sure that phy driver
> will be loaded by the controller driver. Hmm, and also address of
> the phy on th JTAG bus is fed to the controller driver not to the
> phy driver. Maybe leave the property as is (the
> "snps,hdmi-phy-jtag-addr") or parse it from the phy node?

I think the RX controller can parse it's child phy node to retrieve JTAG 
address from the reg property.  That seems better than creating custom 
property for device address on the bus.

Does the PHY support any other type of control bus, e.g. I2C or SPI?

> I also need to pass pdata to the controller driver (the callbacks
> for 5v handling) which are agnostic of the controller. These

Is this about detecting +5V coming from the HDMI connector? Or some
other voltage supply?

> reasons prevented me from adding compatible strings to both
> drivers and just use a wrapper driver instead. This way i do

If you add struct of_device_id instance to your module and define
MODULE_DEVICE_ALIAS(of, ...) there, it will allow the module to be loaded 
when device with matching compatible string is created in the kernel. 
User space is notified with uevent about device creation.

> "modprobe wrapper_driver" and I get all the drivers loaded via
> request_module(). Still, I like your approach much better. I saw
> that I can pass pdata using of_platform_populate, could you
> please confirm if I can still maintain this architecture (i.e.
> prevent modules from loading until I get all the chain setup)?

You could try to pass platform data this way, that should work. But 
I doubt it's the right directions, I would rather see things done 
in the V4L2 layer. 

> Following your approach I could get something like this:
> 
> hdmi_system@YYYY {
>      compatible = "snps,dw-hdmi-rx-wrapper";

This would need to refer to some hardware block, we should avoid virtual 
device nodes in DT.

>      reg = <0xYYYY 0xZZZZ>;
>      interrupts = <3>;
>      #address-cells = <1>;
>      #size-cells = <1>;

You would need also an (empty) 'ranges' property here.

>      hdmi_controller@0 {
>          compatible = "snps,dw-hdmi-rx-controller";
>          reg = <0x0 0x10000>;
>          interrupts = <1>;
>          edid-phandle = <&hdmi_system>;
>          clocks = <&refclk>;
>          clock-names = "ref-clk";
>          #address-cells = <1>;
>          #size-cells = <0>;
> 
>          hdmi_phy@f3 {
>              compatible = "snps,dw-hdmi-phy-e405";
>              reg = <0xf3>;
>              clocks = <&cfgclk>;
>              clock-names = "cfg-clk";
>          }
>      }
> };
> 
> And then snps,dw-hdmi-rx-wrapper would call of_platform_populate
> for controller which would instead call of_platform_populate for
> phy. Is this possible, and maintainable? Isn't the controller
> driver get auto loaded because of the compatible string match?

As I mentioned above, auto loading should work if you have instance 
of MODULE_DEVICE_TABLE() defined in the module, but the module might
not be available immediately after creating devices with 
of_platform_populate().  You may want to have a look at the v4l2-async 
API (drivers/media/v4l2-core/v4l2-async.c). It allows one driver
to register a notifier for its sub-devices. And the parent driver
can complete initialization when it gets all its v4l2 subdevs
registered.

But I'm not sure about calls from the PHY back to the RX controller, 
possibly v4l2_set_subdev_hostdata()/v4l2_get_subdev_hostdata() could 
be used for passing the ops.

> And one more thing: The reg address of the hdmi_controller: Isn't
> this relative to the parent node? I mean isn't this going to be
> 0xYYYY + 0x0? Because I don't want that :/

Address space of child nodes doesn't need to be relative to 'reg' range 
of parent node, these can be entirely distinct address ranges. See for 
example I2C bus controllers, the I2C addresses of slave devices are not 
much related to the memory mapped IO registers region of the bus controller.

--
Regards,
Sylwester
