Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:33294 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbeJWQjI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 12:39:08 -0400
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD
 driver
From: Vladimir Zapolskiy <vz@mleia.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kieran.bingham@ideasonboard.com, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181008211205.2900-1-vz@mleia.com>
 <506c03d7-7986-44dd-3290-92d16a8106ad@mentor.com>
 <4a807a53-1592-a895-f140-54e7acc473b3@ideasonboard.com>
 <3599186.afdMBtdL0k@avalon> <735126c6-9780-a9ef-4fd0-699d6876ed37@mleia.com>
Message-ID: <f0a52a64-a7e7-b266-a402-1279036fad36@mleia.com>
Date: Tue, 23 Oct 2018 09:16:44 +0100
MIME-Version: 1.0
In-Reply-To: <735126c6-9780-a9ef-4fd0-699d6876ed37@mleia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/12/2018 02:59 PM, Vladimir Zapolskiy wrote:
> Hello Laurent.
> 
> On 10/12/2018 04:01 PM, Laurent Pinchart wrote:
>> Hello Vladimir,
>>

...

>> then move to the driver side. In that area I would like to have a full example 
>> of a system using these chips, as the "initial support" is too limited for a 
>> proper review. This won't come as a surprise, but I will expect the OF graph 
>> bindings to be used to model data connections.
>>
> 
> The leverage of "the initial support" to "the complete support" requires:
> * audio bridge cell driver -- trivial, just one mute/unmute control,
> * interrupt controller cell driver -- trivial, but for sake of perfection
>   it requires some minimal changes in drivers/base/regmap/regmap-irq.c
> * DS90Ux940 MIPI CSI-2 -- non-trivial one, but we have it ready, I just
>   don't want to add it to the pile at the moment, otherwise we'll continue
>   discussing cameras, and I'd like to postpone it :)
> 
> No more than that is needed to get absolutely complete support of 5 claimed
> DS90UB9xx ICs, really. 5 other DS90UH9xx will require HDCP support in addition.
> 
> I'll try to roll out an example of DTS snippet soon.

Below I share an example of the serializer and deserializer equipped boards
described in DT.

The example naturally describes *two* simplistic boards in device tree
representation -- main board with an application SoC (ordinary i.MX6*)
and panel display module board. For demonstation I select a simple
FPD-Link III connection between two boards, note that significantly
more advanced configurations are also supported by the published
drivers, for example deliberately I skip audio bridging functionality.

The main board features:
* TI DS90UB927Q serializer (LVDS input) at 0xc, connected to SoC over I2C2,
  SoC GPIO5[10] signal is connected to the IC PDB pin,
* a status LED connected to DS90UB927Q GPIO2, it shall turn on,
  if FPD-Link III connection is established,
* TI DS90UB928Q GPIO0 line signal is pulled-up,
* TI DS90UB927Q GPIO3 line serves as generic GPIO, it is supposed to be
  controlled from userspace,
* TI DS90UB927Q INTB line is connected to SoC GPIO5[4], the line serves
  as an interrupt line routed from a touchscreen controller on a panel
  display module.

The panel display module board features:
* TI DS90UB928Q deserializer (LVDS output), *mapped* to have 0x3b address,
* AUO C070EAT01 panel,
* I2C EEPROM at 0x50, *mapped* to have 0x52 address on SoC I2C bus,
* Atmel MaxTouch touchscreen controller at 0x4b, *mapped* to have 0x60
  address on SoC I2C bus, power-up control signal is connected to DS90UB928Q GPIO4,
* a status LED connected to DS90UB928Q GPIO0, its on/off status shall
  repeat a user-defined status of DS90UB927Q GPIO0 on the main board,
* TI DS90UB928Q GPIO1 controls panel backlight, bridges DS90UB927Q
  GPIO1 signal level, which in turn is connected to a SoC controlled GPIO,
* TI DS90UB928Q GPIO2 line signal is pulled-up,
* TI DS90UB928Q GPIO3 line serves as generic GPIOs, it is supposed to be
  controlled from userspace.

All OF hard-coded controls like pinmuxing, I2C bridging of a remote
deserializer and I2C devices behind it, GPIO line state setting and so
forth must be applied with no interaction from a user -- and it just
works with the current / published versions of the drivers, in other
words a panel display module as a whole is truly hot-pluggable over
FPD-Link III connection.

The example is quite close to ones found in reality, if we put aside
production main boards from the real world, *the panel display modules*
or sensor modules (in case of a reverted serializer to deserializer link
connection to SoC) are even more complex, they host FPGAs, all kinds of
sensors, RF tuners, audio sources and sinks, and loads of other
incredible and fascinating stuff.

The published drivers allow to support very intricate and fine grained
control of "remote" PCBs, and reducing the complexity to "just a media
device" level could be done only if various IC functions are excluded
from the consideration. Here my purpose is to demonstrate that
* pinmux and GPIO controller functions are crucial and non-replaceable,
* I2C bridge function modeled as another cell device actually does not
  fit into the existing I2C host/mux device driver models, and it is
  a completely new abstraction with custom device tree properties,
* video bridge is absolutely transparent, thus trivial, and is modeled
  as another cell device, if needed it would be possible to write a
  DRM driver at no cost,
* reusing OF graph model fits naturally, bus vs. link discussion can
  be started separately, note that LVDS (a.k.a FPD-Link) is formally
  an electric bus, so please define the difference,
* to sum up I see no real objections to the given model of IC series
  support in Linux as an MFD parent device driver, plus pinmux/GPIO
  controller cell device driver, plus other needed cell device drivers.

For video bridging I fabricated a "video-bridge" device driver, it can
be substituted by your "lvds-encoder" driver, here I just need a simple
transparent video bridge driver with NO media controls, its only purpose
is to establish OF graph links, also note that on "remote" side a
video bridge cell node can be omitted (but it may ).

The example is NOT build tested and it may contain errors of secondary
importance, but it tends to repeat the real usage and description of
TI DS90Ux9xx equipped boards.

======== The panel display module board device tree description ========

/ {
	display-module {
		panel {
			compatible = "auo,c070eat01", "panel-lvds";
			pinctrl-names = "default";
			pinctrl-0 = <&panel_pins>;

			width-mm = <153>;
			height-mm = <90>;

			data-mapping = "jeida-24";

			panel-timing {
				clock-frequency = <71000000>;
				hactive = <1280>;
				vactive = <800>;
				hsync-len = <70>;
				hfront-porch = <20>;
				hback-porch = <70>;
				vsync-len = <5>;
				vfront-porch = <3>;
				vback-porch = <15>;
			};

			port {
				panel_input: endpoint {
					remote-endpoint = <&ds90ub928_output>;
				};
			};
		};

		deserializer: deserializer {
			compatible = "ti,ds90ub928q", "ti,ds90ux9xx";

			i2c-bridge {
				compatible = "ti,ds90ux9xx-i2c-bridge";
				#address-cells = <1>;
				#size-cells = <0>;

				touchscreen@4b {
					compatible = "atmel,maxtouch";
					reg = <0x4b>;
					pinctrl-names = "default";
					pinctrl-0 = <&touchscreen_pins>;
					interrupt-parent = <&ds90ub927_intc>;
					interrupts = <0>;
					atmel,mtu = <200>;
				};

				eeprom@50 {
					compatible = "microchip,24lc128";
					reg = <0x50>;
					pagesize = <64>;
				};
			};

			ds90ub928_pctrl: pin-controller {
				compatible = "ti,ds90ub928q-pinctrl", "ti,ds90ux9xx-pinctrl";
				gpio-controller;
				#gpio-cells = <2>;
				gpio-ranges = <&ds90ub928_pctrl 0 0 8>;

				pinctrl-names = "default";
				pinctrl-0 = <&led_pins>;

				led_pins: pinmux {
					gpio-remote {
						pins = "gpio0";
						function = "gpio-remote";
					};
				};

				panel_pins: panel-pwm {
					gpio-remote {
						pins = "gpio1";
						function = "gpio-remote";
					};
				};

				touchscreen_pins: touchscreen-power-up {
					gpio-hog;
					gpios = <4 GPIO_ACTIVE_HIGH>;
					output-high;
				};
			};

			/*
			 * For simplicity video-bridge can be simply removed here
			 * by "connecting" ds90ub927_fpd to &panel_input directly.
			 */
			video-bridge {
				compatible = "ti,ds90ux9xx-video-bridge", "video-bridge";

				ports {
					#address-cells = <1>;
					#size-cells = <0>;

					port@0 {
						reg = <0>;
						ds90ub928_fpd: endpoint {
							remote-endpoint = <&ds90ub927_fpd>;
						};
					};

					port@1 {
						reg = <1>;
						ds90ub928_output: endpoint {
							remote-endpoint = <&panel_input>;
						};
					};
				};
			};
		};
	};
};

======== The main board device tree description ========

/ {
	/* iMX6 series SoC for demonstration purpose */

	&ldb {
		status = "okay";

		lvds-channel@1 {
			status = "okay";
			fsl,data-mapping = "jeida";
			fsl,data-width = <24>;

			port@4 {
				reg = <4>;

				lvds1_out: endpoint {
					remote-endpoint = <&ds90ub927_lvds>;
				};
			};
		};
	};

	&i2c2 {
		status = "okay";
		clock-frequency = <400000>;

		serializer: serializer@c {
			compatible = "ti,ds90ub927q", "ti,ds90ux9xx";
			reg = <0xc>;
			power-gpios = <&gpio5 10 GPIO_ACTIVE_HIGH>;
			ti,backward-compatible-mode = <0>;
			ti,low-frequency-mode = <0>;

			i2c-bridge {
				compatible = "ti,ds90ux9xx-i2c-bridge";
				ti,i2c-bridges = <&deserializer 0 0x3b>;
				ti,i2c-bridge-maps = <0 0x4b 0x60>, <0 0x50 0x52>;
			};

			ds90ub927_intc: interrupt-controller {
				compatible = "ti,ds90ub927-intc";
				interrupt-parent = <&gpio5>;
				interrupts = <4 IRQ_TYPE_EDGE_RISING>;
				interrupt-controller;
				#interrupt-cells = <1>;
			};

			ds90ub927_pctrl: pin-controller {
				compatible = "ti,ds90ub927b-pinctrl", "ti,ds90ux9xx-pinctrl";
				gpio-controller;
				#gpio-cells = <2>;
				gpio-ranges = <&ds90ub927_pctrl 0 0 8>;

				/* Wired to some SoC controlled GPIO */
				pwm-backlight {
					gpio-hog;
					gpios = <1 GPIO_ACTIVE_HIGH>;
					input;
				};

				led_pins: pinmux {
					gpio-remote {
						pins = "gpio2";
						function = "gpio-remote";
					};
				};
			};

			video-bridge {
				compatible = "ti,ds90ux9xx-video-bridge", "video-bridge";

				ports {
					#address-cells = <1>;
					#size-cells = <0>;

					port@0 {
						reg = <0>;
						ds90ub927_lvds: endpoint {
							remote-endpoint = <&lvds1_out>;
						};
					};

					port@1 {
						reg = <1>;
						ds90ub927_fpd: endpoint {
							remote-endpoint = <&ds90ub928_fpd>;
						};
					};
				};
			};
		};
	};
};

==== end of example =====

--
Best wishes,
Vladimir
