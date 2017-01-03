Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32965 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbdACVR6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 16:17:58 -0500
Date: Tue, 3 Jan 2017 15:17:55 -0600
From: Rob Herring <robh@kernel.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        mark.rutland@arm.com, linux@armlinux.org.uk,
        linus.walleij@linaro.org, gnurou@gmail.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, p.zabel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH 11/20] media: Add i.MX media core driver
Message-ID: <20170103211755.a3a3g5woi272cexe@rob-hp-laptop>
References: <1483050455-10683-1-git-send-email-steve_longerbeam@mentor.com>
 <1483050455-10683-12-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483050455-10683-12-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 29, 2016 at 02:27:26PM -0800, Steve Longerbeam wrote:
> Add the core media driver for i.MX SOC.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  Documentation/devicetree/bindings/media/imx.txt   | 205 +++++
>  Documentation/media/v4l-drivers/imx.rst           | 429 ++++++++++
>  drivers/staging/media/Kconfig                     |   2 +
>  drivers/staging/media/Makefile                    |   1 +
>  drivers/staging/media/imx/Kconfig                 |   8 +
>  drivers/staging/media/imx/Makefile                |   6 +
>  drivers/staging/media/imx/TODO                    |  18 +
>  drivers/staging/media/imx/imx-media-common.c      | 981 ++++++++++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c         | 479 +++++++++++
>  drivers/staging/media/imx/imx-media-fim.c         | 508 +++++++++++
>  drivers/staging/media/imx/imx-media-internal-sd.c | 456 ++++++++++
>  drivers/staging/media/imx/imx-media-of.c          | 291 +++++++
>  drivers/staging/media/imx/imx-media-of.h          |  25 +
>  drivers/staging/media/imx/imx-media.h             | 290 +++++++
>  include/media/imx.h                               |  15 +
>  include/uapi/Kbuild                               |   1 +
>  include/uapi/linux/v4l2-controls.h                |   4 +
>  include/uapi/media/Kbuild                         |   2 +
>  include/uapi/media/imx.h                          |  30 +
>  19 files changed, 3751 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>  create mode 100644 Documentation/media/v4l-drivers/imx.rst
>  create mode 100644 drivers/staging/media/imx/Kconfig
>  create mode 100644 drivers/staging/media/imx/Makefile
>  create mode 100644 drivers/staging/media/imx/TODO
>  create mode 100644 drivers/staging/media/imx/imx-media-common.c
>  create mode 100644 drivers/staging/media/imx/imx-media-dev.c
>  create mode 100644 drivers/staging/media/imx/imx-media-fim.c
>  create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
>  create mode 100644 drivers/staging/media/imx/imx-media-of.c
>  create mode 100644 drivers/staging/media/imx/imx-media-of.h
>  create mode 100644 drivers/staging/media/imx/imx-media.h
>  create mode 100644 include/media/imx.h
>  create mode 100644 include/uapi/media/Kbuild
>  create mode 100644 include/uapi/media/imx.h
> 
> diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
> new file mode 100644
> index 0000000..3593354
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx.txt
> @@ -0,0 +1,205 @@
> +Freescale i.MX Media Video Devices
> +
> +Video Media Controller node
> +---------------------------
> +
> +This is the parent media controller node for video capture support.
> +
> +Required properties:
> +- compatible : "fsl,imx-media";
> +- ports      : Should contain a list of phandles pointing to camera
> +  	       sensor interface ports of IPU devices
> +
> +
> +fim child node
> +--------------
> +
> +This is an optional child node of the ipu_csi port nodes. It can be used
> +to modify the default control values for the video capture Frame
> +Interval Monitor. Refer to Documentation/media/v4l-drivers/imx.rst for
> +more info on the Frame Interval Monitor.
> +
> +Optional properties:
> +- enable          : enable (1) or disable (0) the FIM;

"status" property doesn't work for you?

> +- num-avg         : how many frame intervals the FIM will average;
> +- num-skip        : how many frames the FIM will skip after a video
> +		    capture restart before beginning to sample frame
> +		    intervals;
> +- tolerance-range : a range of tolerances for the averaged frame
> +		    interval error, specified as <min max>, in usec.
> +		    The FIM will signal a frame interval error if
> +		    min < error < max. If the max is <= min, then
> +		    tolerance range is disabled (interval error if
> +		    error > min).

Needs a unit suffix (see property-units.txt).

> +- input-capture-channel: an input capture channel and channel flags,

These all need vendor prefix.

> +			 specified as <chan flags>. The channel number
> +			 must be 0 or 1. The flags can be
> +			 IRQ_TYPE_EDGE_RISING, IRQ_TYPE_EDGE_FALLING, or
> +			 IRQ_TYPE_EDGE_BOTH, and specify which input
> +			 capture signal edge will trigger the event. If
> +			 an input capture channel is specified, the FIM
> +			 will use this method to measure frame intervals
> +			 instead of via the EOF interrupt. The input capture
> +			 method is much preferred over EOF as it is not
> +			 subject to interrupt latency errors. However it
> +			 requires routing the VSYNC or FIELD output
> +			 signals of the camera sensor to one of the
> +			 i.MX input capture pads (SD1_DAT0, SD1_DAT1),
> +			 which also gives up support for SD1.
> +
> +
> +mipi_csi2 node
> +--------------
> +
> +This is the device node for the MIPI CSI-2 Receiver, required for MIPI
> +CSI-2 sensors.
> +
> +Required properties:
> +- compatible	: "fsl,imx-mipi-csi2";

This needs to be an SoC specific compatible string.

> +- reg           : physical base address and length of the register set;
> +- clocks	: the MIPI CSI-2 receiver requires three clocks: hsi_tx
> +                  (the DPHY clock), video_27m, and eim_sel;
> +- clock-names	: must contain "dphy_clk", "cfg_clk", "pix_clk";

"_clk" is redundant.

> +
> +Optional properties:
> +- interrupts	: must contain two level-triggered interrupts,
> +                  in order: 100 and 101;
> +
> +
> +video mux node
> +--------------
> +
> +This is the device node for the video multiplexer. It can control
> +either the i.MX internal video mux that selects between parallel image
> +sensors and MIPI CSI-2 virtual channels, or an external mux controlled
> +by a GPIO. It must be a child device of the syscon GPR device.

These sound like 2 completely separate things and should not both be 
"imx-video-mux".

> +
> +Required properties:
> +- compatible	: "imx-video-mux";

Needs to be SoC specific.

> +- sink-ports    : the number of sink (input) ports that follow
> +- ports		: at least 2 sink ports must be specified that define

OF graph already provides a way to handle a mux. Multiple endpoints for 
an input port is a mux (or some kind of mixer). It depends on the 
definition of the port which depends on the parent compatible string.

> +  		  the endpoint inputs to the video mux, and there must
> +		  be exactly one output port endpoint which must be the
> +		  last port endpoint defined;
> +
> +Optional properties:
> +- reg		: the GPR iomuxc register offset and bitmask of the
> +  		  internal mux bits;

This should not be optional.

> +- mux-gpios	: if reg is not specified, this must exist to define
> +    		  a GPIO to control an external mux;
> +
> +
> +SabreLite Quad with OV5642 and OV5640
> +-------------------------------------

Don't put board specifics in here. I assume these sensors are already 
documented?

> +
> +On the Sabrelite, the OV5642 module is connected to the parallel bus
> +input on the i.MX internal video mux to IPU1 CSI0. It's i2c bus connects
> +to i2c bus 2, so the ov5642 sensor node must be a child of i2c2.
> +
> +The MIPI CSI-2 OV5640 module is connected to the i.MX internal MIPI CSI-2
> +receiver, and the four virtual channel outputs from the receiver are
> +routed as follows: vc0 to the IPU1 CSI0 mux, vc1 directly to IPU1 CSI1,
> +vc2 directly to IPU2 CSI0, and vc3 to the IPU2 CSI1 mux. The OV5640 is
> +also connected to i2c bus 2 on the SabreLite, so it also must be a child
> +of i2c2. Therefore the OV5642 and OV5640 must not share the same i2c slave
> +address.
> +
> +OV5642 Required properties:
> +- compatible	: "ovti,ov5642";
> +- clocks        : the OV5642 system clock (cko2, 200 on Sabrelite);
> +- clock-names	: must be "xclk";
> +- reg           : i2c slave address (must not be default 0x3c on Sabrelite);
> +- xclk          : the system clock frequency (24000000 on Sabrelite);
> +- reset-gpios   : gpio for the reset pin to OV5642
> +- pwdn-gpios    : gpio for the powewr-down pin to OV5642
> +
> +OV5642 Endpoint Required properties:
> +- remote-endpoint : must connect to parallel sensor interface input endpoint
> +  		    on ipu1_csi0 video mux (ipu1_csi0_mux_from_parallel_sensor).
> +- bus-width       : must be 8;
> +- hsync-active    : must be 1;
> +- vsync-active    : must be 1;
> +
> +OV5640 Required properties:
> +- compatible	: "ovti,ov5640_mipi";

The "mipi" part is implied by the type of sensor or the graph 
connection.

> +- clocks        : the OV5640 system clock (pwm3 on Sabrelite);
> +- clock-names	: must be "xclk";
> +- reg           : i2c slave address (must not be default 0x3c on Sabrelite);
> +- xclk          : the system clock frequency (22000000 on Sabrelite);
> +- reset-gpios   : gpio for the reset pin to OV5640
> +- pwdn-gpios    : gpio for the power-down pin to OV5640
> +
> +OV5640 MIPI CSI-2 Endpoint Required properties:
> +- remote-endpoint : must connect to mipi_csi receiver input endpoint
> +  		    (mipi_csi_from_mipi_sensor).
> +- reg             : the MIPI CSI-2 virtual channel to transmit over;
> +- data-lanes      : must be <0 1>;
> +- clock-lanes     : must be <2>;
> +
> +OV5640/OV5642 Optional properties:
> +- DOVDD-supply  : DOVDD regulator supply;
> +- AVDD-supply   : AVDD regulator supply;
> +- DVDD-supply   : DVDD regulator supply;
> +
> +
> +SabreAuto Quad with ADV7180
> +---------------------------
> +
> +On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
> +parallel bus input on the internal video mux to IPU1 CSI0.
> +
> +Two analog video inputs are routed to the ADV7180 on the SabreAuto,
> +composite on Ain1, and composite on Ain3. Those inputs are defined
> +via inputs and input-names properties in the ADV7180 device node.
> +
> +Regulators and port expanders are required for the ADV7180 (power pin
> +is via port expander gpio on i2c3). The reset pin to the port expander
> +chip (MAX7310) is controlled by a gpio, so a reset-gpios property must
> +be defined under the port expander node to control it.
> +
> +The sabreauto uses a steering pin to select between the SDA signal on
> +i2c3 bus, and a data-in pin for an SPI NOR chip. i2cmux can be used to
> +control this steering pin. Idle state of the i2cmux selects SPI NOR.
> +This is not classic way to use i2cmux, since one side of the mux selects
> +something other than an i2c bus, but it works and is probably the cleanest
> +solution. Note that if one thread is attempting to access SPI NOR while
> +another thread is accessing i2c3, the SPI NOR access will fail since the
> +i2cmux has selected the SDA pin rather than SPI NOR data-in. This couldn't
> +be avoided in any case, the board is not designed to allow concurrent
> +i2c3 and SPI NOR functions (and the default device-tree does not enable
> +SPI NOR anyway).
> +
> +ADV7180 Required properties:
> +- compatible    : "adi,adv7180";
> +- reg           : must be 0x21;
> +
> +ADV7180 Optional properties:
> +- DOVDD-supply  : DOVDD regulator supply;
> +- AVDD-supply   : AVDD regulator supply;
> +- DVDD-supply   : DVDD regulator supply;
> +- PVDD-supply   : PVDD regulator supply;
> +- pwdn-gpios    : gpio to control ADV7180 power pin, must be
> +                  <&port_exp_b 2 GPIO_ACTIVE_LOW> on SabreAuto;
> +- interrupts    : interrupt from ADV7180, must be <27 0x8> on SabreAuto;
> +- interrupt-parent : must be <&gpio1> on SabreAuto;
> +- inputs        : list of input mux values, must be 0x00 followed by
> +                  0x02 on SabreAuto;
> +- input-names   : names of the inputs;
> +
> +ADV7180 Endpoint Required properties:
> +- remote-endpoint : must connect to parallel sensor interface input endpoint
> +  		    on ipu1_csi0 video mux (ipu1_csi0_mux_from_parallel_sensor).
> +- bus-width       : must be 8;
> +
> +
> +SabreSD Quad with OV5642 and MIPI CSI-2 OV5640
> +----------------------------------------------
> +
> +Similarly to SabreLite, the SabreSD supports a parallel interface
> +OV5642 module on IPU1 CSI0, and a MIPI CSI-2 OV5640 module. The OV5642
> +connects to i2c bus 1 (i2c1) and the OV5640 to i2c bus 2 (i2c2).
> +
> +OV5640 and OV5642 properties are as described above on SabreLite.
> +
> +The OV5642 support has not been tested yet due to lack of hardware,
> +so only OV5640 is enabled in the device tree at this time.
