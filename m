Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34813 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753474AbdFVVeE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 17:34:04 -0400
Date: Thu, 22 Jun 2017 16:34:01 -0500
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kbingham@kernel.org>
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)"
        <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] media: i2c: adv748x: add adv748x driver
Message-ID: <20170622213401.jdktgcx5tbsxhh5d@rob-hp-laptop>
References: <cover.90fc3153078e79a3f74af832de923ac675eb29ad.1497469745.git-series.kieran.bingham+renesas@ideasonboard.com>
 <de701d3899e68ddf8a2ad0316459b8f1868132b5.1497469745.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de701d3899e68ddf8a2ad0316459b8f1868132b5.1497469745.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 14, 2017 at 08:58:12PM +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Provide support for the ADV7481 and ADV7482.
> 
> The driver is modelled with 4 subdevices to allow simultaneous streaming
> from the AFE (Analog front end) and HDMI inputs though two CSI TX
> entities.
> 
> The HDMI entity is linked to the TXA CSI bus, whilst the AFE is linked
> to the TXB CSI bus.
> 
> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
> and an earlier rework by Niklas Söderlund.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> 
> v2:
>  - Implement DT parsing
>  - adv748x: Add CSI2 entity
>  - adv748x: Rework pad allocations and fmts
>  - Give AFE 8 input pads and move pad defines
>  - Use the enums to ensure pads are referenced correctly.
>  - adv748x: Rename AFE/HDMI entities
>    Now they are 'just afe' and 'just hdmi'
>  - Reorder the entity enum and structures
>  - Added pad-format for the CSI2 entities
>  - CSI2 s_stream pass through
>  - CSI2 control pass through (with link following)
> 
> v3:
>  - dt: Extend DT documentation to specify interrupt mappings
>  - simplify adv748x_parse_dt
>  - core: Add banner to header file describing ADV748x variants
>  - Use entity structure pointers rather than global state pointers where
>    possible
>  - afe: Reduce indent on afe_status
>  - hdmi: Add error checking to the bt->pixelclock values.
>  - Remove all unnecessary pad checks: handled by core
>  - Fix all probe cleanup paths
>  - adv748x_csi2_probe() now fails if it has no endpoint
>  - csi2: Fix small oneliners for is_txa and get_remote_sd()
>  - csi2: Fix checkpatch warnings
>  - csi2: Fix up s_stream pass-through
>  - csi2: Fix up Pixel Rate passthrough
>  - csi2: simplify adv748x_csi2_get_pad_format()
>  - Remove 'async notifiers' from AFE/HDMI
>    Using async notifiers was overkill, when we have access to the
>    subdevices internally and can register them directly.
>  - Use state lock in control handlers and clean up s_ctrls
>  - remove _interruptible mutex locks
> 
> v4:
>  - all: Convert hex 0xXX to lowercase
>  - all: Use defines instead of hardcoded register values
>  - all: Use regmap
>  - afe, csi2, hdmi: _probe -> _init
>  - afe, csi2, hdmi: _remove -> _cleanup
>  - afe, hdmi: Convert pattern generator to a control
>  - afe, hdmi: get/set-fmt refactor
>  - afe, hdmi, csi2: Convert to internal calls for pixelrate
>  - afe: Allow the AFE to configure the Input Select from DT
>  - afe: Reduce indent on adv748x_afe_status switch
>  - afe: Remove ununsed macro definitions AIN0-7
>  - afe: Remove extraneous control checks handled by core
>  - afe: Comment fixups
>  - afe: Rename error label
>  - afe: Correct control names on the SDP
>  - afe: Use AIN0-7 rather than AIN1-8 to match ports and MC pads
>  - core: adv748x_parse_dt references to nodes, and catch multiple
>    endpoints in a port.
>  - core: adv748x_dt_cleanup to simplify releasing DT nodes
>  - core: adv748x_print_info renamed to adv748x_identify_chip
>  - core: reorganise ordering of probe sequence
>  - core: No need for of_match_ptr
>  - core: Fix up i2c read/writes (regmap still on todo list)
>  - core: Set specific functions from the entities on subdev-init
>  - core: Use kzalloc for state instead of devm
>  - core: Improve probe error reporting
>  - core: Track unknown BIT(6) in tx{a,b}_power
>  - csi2: Improve adv748x_csi2_get_remote_sd as adv748x_csi2_get_source_sd
>  - csi2: -EPIPE instead of -ENODEV
>  - csi2: adv_dbg, instead of adv_info
>  - csi2: adv748x_csi2_set_format fix
>  - csi2: remove async notifier and sd member variables
>  - csi2: register links from the CSI2
>  - csi2: create virtual channel helper function
>  - dt: Remove numbering from endpoints
>  - dt: describe ports and interrupts as optional
>  - dt: Re-tab
>  - hdmi: adv748x_hdmi_have_signal -> adv748x_hdmi_has_signal
>  - hdmi: fix adv748x_hdmi_read_pixelclock return checks
>  - hdmi: improve adv748x_hdmi_set_video_timings
>  - hdmi: Fix tmp variable as polarity
>  - hdmi: Improve adv748x_hdmi_s_stream
>  - hdmi: Clean up adv748x_hdmi_s_ctrl register definitions and usage
>  - hdmi: Fix up adv748x_hdmi_s_dv_timings with macro names for register
>  - hdmi: Add locking to adv748x_hdmi_g_dv_timings
>    writes and locking
>  - hdmi: adv748x_hdmi_set_de_timings function added to clarify DE writes
>  - hdmi: Use CP in control register naming to match component processor
>  - hdmi: clean up adv748x_hdmi_query_dv_timings()
>  - KConfig: Fix up dependency and capitalisation
> 
> v5:
>  - afe,hdmi: _set_pixelrate -> _propagate_pixelrate
>  - hdmi: Fix arm32 compilation failure : Use DIV_ROUND_CLOSEST_ULL
>  - core: remove unused link functions
>  - csi2: Use immutable links for HDMI->TXA, AFE->TXB
> 
>  Documentation/devicetree/bindings/media/i2c/adv748x.txt |  96 +-

This should be a separate patch.

>  MAINTAINERS                                             |   6 +-
>  drivers/media/i2c/Kconfig                               |  11 +-
>  drivers/media/i2c/Makefile                              |   1 +-
>  drivers/media/i2c/adv748x/Makefile                      |   7 +-
>  drivers/media/i2c/adv748x/adv748x-afe.c                 | 570 ++++++-
>  drivers/media/i2c/adv748x/adv748x-core.c                | 831 +++++++++-
>  drivers/media/i2c/adv748x/adv748x-csi2.c                | 327 ++++-
>  drivers/media/i2c/adv748x/adv748x-hdmi.c                | 651 +++++++-
>  drivers/media/i2c/adv748x/adv748x.h                     | 415 ++++-
>  10 files changed, 2915 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
>  create mode 100644 drivers/media/i2c/adv748x/Makefile
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x.h
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> new file mode 100644
> index 000000000000..b17f8983c992
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> @@ -0,0 +1,96 @@
> +* Analog Devices ADV748X video decoder with HDMI receiver
> +
> +The ADV7481, and ADV7482 are multi format video decoders with an integrated
> +HDMI receiver. They can output CSI-2 on two independent outputs TXA and TXB
> +from three input sources HDMI, analog and TTL.
> +
> +Required Properties:
> +
> +  - compatible: Must contain one of the following
> +    - "adi,adv7481" for the ADV7481
> +    - "adi,adv7482" for the ADV7482
> +
> +  - reg: I2C slave address
> +
> +Optional Properties:
> +
> +  - interrupt-names: Should specify the interrupts as "intrq1", "intrq2" and/or
> +		     "intrq3". All interrupts are optional. The "intrq3" interrupt
> +		     is only available on the adv7481
> +  - interrupts: Specify the interrupt lines for the ADV748x
> +
> +The device node must contain one 'port' child node per device input and output
> +port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> +are numbered as follows.
> +
> +	  Name		Type		Port
> +	---------------------------------------
> +	  AIN0		sink		0
> +	  AIN1		sink		1
> +	  AIN2		sink		2
> +	  AIN3		sink		3
> +	  AIN4		sink		4
> +	  AIN5		sink		5
> +	  AIN6		sink		6
> +	  AIN7		sink		7
> +	  HDMI		sink		8
> +	  TTL		sink		9
> +	  TXA		source		10
> +	  TXB		source		11
> +
> +The digital output port nodes must contain at least one endpoint.
> +
> +Ports are optional if they are not connected to anything at the hardware level,
> +but the driver may not provide any support for ports which are not described.

What the driver does is not relevant to the binding.

> +
> +Example:
> +
> +	video_receiver@70 {

video-receiver@70

> +		compatible = "adi,adv7482";
> +		reg = <0x70>;
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		interrupt-parent = <&gpio6>;
> +		interrupt-names = "intrq1", "intrq2";
> +		interrupts = <30 IRQ_TYPE_LEVEL_LOW>,
> +			     <31 IRQ_TYPE_LEVEL_LOW>;
> +
> +		port@7 {
> +			reg = <7>;
> +
> +			adv7482_ain7: endpoint {
> +				remote-endpoint = <&cvbs_in>;
> +			};
> +		};
> +
> +		port@8 {
> +			reg = <8>;
> +
> +			adv7482_hdmi: endpoint {
> +				remote-endpoint = <&hdmi_in>;
> +			};
> +		};
> +
> +		port@10 {
> +			reg = <10>;
> +
> +			adv7482_txa: endpoint {
> +				clock-lanes = <0>;
> +				data-lanes = <1 2 3 4>;
> +				remote-endpoint = <&csi40_in>;
> +			};
> +		};
> +
> +		port@11 {
> +			reg = <11>;
> +
> +			adv7482_txb: endpoint {
> +				clock-lanes = <0>;
> +				data-lanes = <1>;
> +				remote-endpoint = <&csi20_in>;
> +			};
> +		};
> +	};
