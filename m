Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41793 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932575AbcIUN3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 09:29:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/7] ov7670: add devicetree support
Date: Wed, 21 Sep 2016 16:30:41 +0300
Message-ID: <1604903.n7jWqSPYYZ@avalon>
In-Reply-To: <86f01ea7-984c-0b9e-477a-c04f61d44db1@xs4all.nl>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl> <3513546.0HAk52lbkG@avalon> <86f01ea7-984c-0b9e-477a-c04f61d44db1@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 26 Aug 2016 09:45:25 Hans Verkuil wrote:
> On 08/17/2016 02:44 PM, Laurent Pinchart wrote:
> > On Wednesday 17 Aug 2016 08:29:41 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> Add DT support. Use it to get the reset and pwdn pins (if there are any).
> >> Tested with one sensor requiring reset/pwdn and one sensor that doesn't
> >> have reset/pwdn pins.
> >> 
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >> 
> >>  .../devicetree/bindings/media/i2c/ov7670.txt       | 44 ++++++++++++++
> >>  MAINTAINERS                                        |  1 +
> >>  drivers/media/i2c/ov7670.c                         | 51 ++++++++++++++++
> >>  3 files changed, 96 insertions(+)
> >>  create mode 100644
> >>  Documentation/devicetree/bindings/media/i2c/ov7670.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> >> b/Documentation/devicetree/bindings/media/i2c/ov7670.txt new file mode
> >> 100644
> >> index 0000000..3231c47
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> >> @@ -0,0 +1,44 @@
> >> +* Omnivision OV7670 CMOS sensor
> >> +
> >> +The Omnivision OV7670 sensor support multiple resolutions output, such
> >> as
> > 
> > s/support/supports/
> > 
> >> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
> >> +output format.
> > 
> > s/format/formats/ (and possibly s/can support/can support the/)
> > 
> >> +
> >> +Required Properties:
> >> +- compatible: should be "ovti,ov7670"
> >> +- clocks: reference to the xvclk input clock.
> >> +- clock-names: should be "xvclk".
> >> +
> >> +Optional Properties:
> >> +- resetb-gpios: reference to the GPIO connected to the resetb pin, if
> >> any.
> >> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
> >> +
> >> +The device node must contain one 'port' child node for its digital
> >> output
> >> +video port, in accordance with the video interface bindings defined in
> >> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> >> +
> >> +Example:
> >> +
> >> +	i2c1: i2c@f0018000 {
> >> +		status = "okay";
> >> +
> >> +		ov7670: camera@0x21 {
> >> +			compatible = "ovti,ov7670";
> >> +			reg = <0x21>;
> >> +			pinctrl-names = "default";
> >> +			pinctrl-0 = <&pinctrl_pck0_as_isi_mck
> >> &pinctrl_sensor_power
> >> &pinctrl_sensor_reset>;
> > 
> > The pinctrl properties should be part of the clock provider DT node.
> 
> Do you have examples of that?

Sure, it's pretty simple. The pinctrl_pck0_as_isi_mck can just be moved to the 
isi DT node, as the isi is the clock provider for the sensor.

The two other properties, however, have to stay here (I think I've overlooked 
them in my previous review e-mail), so I'm also not totally opposed to keeping 
all three pinctrl entries together.

> I just copied this from existing atmel dts code
> (arch/arm/boot/dts/sama5d3xmb.dtsi).
>
> >> +			resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
> >> +			pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
> >> +			clocks = <&pck0>;
> >> +			clock-names = "xvclk";

I missed this, isn't the pin named "xclk" in the datasheet ?

> >> +			assigned-clocks = <&pck0>;
> >> +			assigned-clock-rates = <24000000>;
> > 
> > You should compute and set the clock rate dynamically in the driver, not
> > hardcode it in DT.
> 
> Do you have an example of that? Again, I just copied this from the same
> sama5d3xmb.dtsi.

Please see my reply to Sakari's e-mail in the same thread.

-- 
Regards,

Laurent Pinchart
