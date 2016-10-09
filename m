Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36595 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbcJIBbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2016 21:31:25 -0400
Date: Sat, 8 Oct 2016 20:29:39 -0500
From: Rob Herring <robh@kernel.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] devicetree/bindings: display: Add bindings for LVDS
 panels
Message-ID: <20161009012939.GY18158@rob-hp-laptop>
References: <1475598210-26857-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1475598210-26857-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475598210-26857-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 04, 2016 at 07:23:29PM +0300, Laurent Pinchart wrote:
> LVDS is a physical layer specification defined in ANSI/TIA/EIA-644-A.
> Multiple incompatible data link layers have been used over time to
> transmit image data to LVDS panels. This binding supports display panels
> compatible with the JEIDA-59-1999, Open-LDI and VESA SWPG
> specifications.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  .../bindings/display/panel/panel-lvds.txt          | 119 +++++++++++++++++++++
>  1 file changed, 119 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/display/panel/panel-lvds.txt
> 
> diff --git a/Documentation/devicetree/bindings/display/panel/panel-lvds.txt b/Documentation/devicetree/bindings/display/panel/panel-lvds.txt
> new file mode 100644
> index 000000000000..250861f2673e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/display/panel/panel-lvds.txt
> @@ -0,0 +1,119 @@
> +Generic LVDS Panel
> +==================
> +
> +LVDS is a physical layer specification defined in ANSI/TIA/EIA-644-A. Multiple
> +incompatible data link layers have been used over time to transmit image data
> +to LVDS panels. This bindings supports display panels compatible with the
> +following specifications.
> +
> +[JEIDA] "Digital Interface Standards for Monitor", JEIDA-59-1999, February
> +1999 (Version 1.0), Japan Electronic Industry Development Association (JEIDA)
> +[LDI] "Open LVDS Display Interface", May 1999 (Version 0.95), National
> +Semiconductor
> +[VESA] "VESA Notebook Panel Standard", October 2007 (Version 1.0), Video
> +Electronics Standards Association (VESA)
> +
> +Device compatible with those specifications have been marketed under the
> +FPD-Link and FlatLink brands.
> +
> +
> +Required properties:
> +- compatible: shall contain "panel-lvds"

Maybe as a fallback, but on its own, no way.

> +- width-mm: panel display width in millimeters
> +- height-mm: panel display height in millimeters

This is already documented for all panels IIRC.

> +- data-mapping: the color signals mapping order, "jeida-18", "jeida-24"
> +  or "vesa-24"

Maybe this should be part of the compatible.

> +
> +Optional properties:
> +- label: a symbolic name for the panel

Could be for any panel or display connector.

> +- avdd-supply: reference to the regulator that powers the panel 
analog supply
> +- dvdd-supply: reference to the regulator that powers the panel digital supply

Which one has to be powered on first, what voltage, and with what time 
in between? This is why "generic" or "simple" bindings don't work.

> +- data-mirror: if set, reverse the bit order on all data lanes (6 to 0 instead
> +  of 0 to 6)
> +
> +Required nodes:
> +- One "panel-timing" node containing video timings, in accordance with the
> +  display timing bindings defined in
> +  Documentation/devicetree/bindings/display/display-timing.txt.

I'll let Thierry comment on this one.

> +- One "port" child node for the LVDS input port, in accordance with the
> +  video interface bindings defined in
> +  Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +
> +LVDS data mappings are defined as follows.
> +
> +- "jeida-18" - 18-bit data mapping compatible with the [JEIDA], [LDI] and
> +  [VESA] specifications. Data are transferred as follows on 3 LVDS lanes.
> +
> +Slot	    0       1       2       3       4       5       6
> +	________________                         _________________
> +Clock	                \_______________________/
> +	  ______  ______  ______  ______  ______  ______  ______
> +DATA0	><__G0__><__R5__><__R4__><__R3__><__R2__><__R1__><__R0__><
> +DATA1	><__B1__><__B0__><__G5__><__G4__><__G3__><__G2__><__G1__><
> +DATA2	><_CTL2_><_CTL1_><_CTL0_><__B5__><__B4__><__B3__><__B2__><
> +
> +- "jeida-24" - 24-bit data mapping compatible with the [DSIM] and [LDI]
> +  specifications. Data are transferred as follows on 4 LVDS lanes.
> +
> +Slot	    0       1       2       3       4       5       6
> +	________________                         _________________
> +Clock	                \_______________________/
> +	  ______  ______  ______  ______  ______  ______  ______
> +DATA0	><__G2__><__R7__><__R6__><__R5__><__R4__><__R3__><__R2__><
> +DATA1	><__B3__><__B2__><__G7__><__G6__><__G5__><__G4__><__G3__><
> +DATA2	><_CTL2_><_CTL1_><_CTL0_><__B7__><__B6__><__B5__><__B4__><
> +DATA3	><_CTL3_><__B1__><__B0__><__G1__><__G0__><__R1__><__R0__><
> +
> +- "vesa-24" - 24-bit data mapping compatible with the [VESA] specification.
> +  Data are transferred as follows on 4 LVDS lanes.
> +
> +Slot	    0       1       2       3       4       5       6
> +	________________                         _________________
> +Clock	                \_______________________/
> +	  ______  ______  ______  ______  ______  ______  ______
> +DATA0	><__G0__><__R5__><__R4__><__R3__><__R2__><__R1__><__R0__><
> +DATA1	><__B1__><__B0__><__G5__><__G4__><__G3__><__G2__><__G1__><
> +DATA2	><_CTL2_><_CTL1_><_CTL0_><__B5__><__B4__><__B3__><__B2__><
> +DATA3	><_CTL3_><__B7__><__B6__><__G7__><__G6__><__R7__><__R6__><
> +
> +
> +Control signals are mapped as follows.
> +
> +CTL0: HSync
> +CTL1: VSync
> +CTL2: Data Enable
> +CTL3: 0
> +
> +
> +Example
> +-------
> +
> +panel {
> +	compatible = "mitsubishi,aa121td01", "panel-lvds";
> +	label = "lcd";

Kind of useless in your example.

> +
> +	width-mm = <261>;
> +	height-mm = <163>;
> +
> +	data-mapping = "jeida-24";
> +
> +	panel-timing {
> +		/* 1280x800 @60Hz */
> +		clock-frequency = <71000000>;
> +		hactive = <1280>;
> +		vactive = <800>;
> +		hsync-len = <70>;
> +		hfront-porch = <20>;
> +		hback-porch = <70>;
> +		vsync-len = <5>;
> +		vfront-porch = <3>;
> +		vback-porch = <15>;
> +	};
> +
> +	port {
> +		panel_in: endpoint {
> +			remote-endpoint = <&lvds_connector>;
> +		};
> +	};
> +};
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
