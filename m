Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34377 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752553AbaATETn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 23:19:43 -0500
Date: Mon, 20 Jan 2014 06:19:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@debian.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
Message-ID: <20140120041904.GH9997@valkosipuli.retiisi.org.uk>
References: <20131103220315.GA11659@earth.universe>
 <20140115194127.GA30988@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115194127.GA30988@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

I've also been working on this (besides others); what I have however are
mostly experimental patches. I'm also using patches from Laurent, Florian
Vaussard (IOMMU) and Hiroshi Doyu (IOMMU as well). My tree is here:

<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=summary>

The branch is rm696-035-dt. The intent is to get the N9/N950 camera support
to mainline. Most patches in that branch are experimental. What is missing
entirely is constucting subdev groups off of the devices found. The rest
will likely contain lots of bugs.

Seems like you've started with documentation which I'm lacking entirely.
Good! :)

You might want to take a look at least at this one as well:

<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=commitdiff;h=58f7754099539178f47dcca97981bf2ba4c73e54>

On Wed, Jan 15, 2014 at 08:41:28PM +0100, Sebastian Reichel wrote:
> Hi,
> 
> I finally found some time to update the proposed binding
> documentation for omap3isp according to the comments on RFCv1.
> 
> Changes since v1:
>  * Use common DT clock bindings to provide isp-xclk
>  * Use common DT video-interface bindings to specify device connections
>  * Apply style updates suggested by Mark Rutland
>  * I renamed ti,enable-crc to ti,disable-crc, since I think its supposed
>    to be used for remote hw adding broken crc values. I can't see other
>    reasons for disabling it :)
>  * I've kept the clocks the same for now. I think somebody else should look
>    over them. Changing the actual referenced clocks / renaming them is just
>    a small change and can be done at a later time in the omap3isp DT process
>    IMHO.
>  * I've kept the reg reference as a list for now, since that's how the
>    omap3isp driver currently works and I can't see any disadvantages
>    in making the memory segmentation visible in the DTS file.
> 
> So here is the proposed DT binding documentation:
> 
> Binding for the OMAP3 Camera subsystem with the image signal processor (ISP)
> feature. The binding follows the common video-interfaces Device Tree binding,
> so it is recommended to read the common binding description first. This description

Over 80 characters per line.

> can be found in Documentation/devicetree/bindings/media/video-interfaces.txt
> 
> omap3isp node
> -------------
> 
> Required properties:
> 
> - compatible    : should be "ti,omap3isp" for OMAP3.
> - reg       : physical addresses and length of the registers set.
> - clocks    : list of clock specifiers, corresponding to entries in
>           clock-names property.
> - clock-names   : must contain "cam_ick", "cam_mclk", "csi2_96m_fck",
>           "l3_ick" entries, matching entries in the clocks property.
> - interrupts    : must contain mmu interrupt.
> - ti,iommu  : phandle to isp mmu.

Is the TI specific? I'd assume not. Hiroshi's patches assume that at least.

> - #address-cells: Should be set to <1>.
> - #size-cells   : Should be set to <0>.

The ISP also exports clocks. Shouldn't you add

#clock-cells = <1>;

> Optional properties:
> 
> - vdd-csiphy1-supply    : regulator for csi phy1
> - vdd-csiphy2-supply    : regulator for csi phy2
> 
> isp-xclk subnode
> ----------------
> 
> The omap3 ISP provides two external clocks, which are available as subnodes of
> the omap3isp node. Devices using one of these clock devices are supposed to follow
> the common Device Tree clock bindings described in
> 
> Documentation/devicetree/bindings/clock/clock-bindings.txt
> 
> Required properties:
>  - compatible   : should contain "ti,omap3-cam-xclk"
>  - reg      : should be set to
>   * <0> for cam_xclka
>   * <1> for cam_xclkb
>  - #clock-cells : should be set to <0>

Or to do this instead. I'm not an expert (or perhaps not even a little less)
in DT so I don't know. The ISP is still a single device, and I think you
might not need these to just refer to the clocks from elsewhere in the DT.

> port subnode
> ------------
> 
> The omap3 ISP provides three different physical interfaces for camera
> connections. Each of them is described using a port node.
> 
> Required properties:
>  - reg : Should be set to one of the following values
>    * <0> for the parallel interface (CPI)
>    * <1> for the first serial interface (CSI1)
>    * <2> for the second serial interface (CSI2)

There are two PHYs in 3630 but three receivers. Currently the two are
combined in the configuration. I think I agree with your approach.

> endpoint subnode for parallel interface
> ---------------------------------------
> 
> The endpoint subnode describes the connection between the port and the remote
> camera device.
> 
> Required properties:
>  - remote-endpoint  : phandle to remote device
> 
> Optional properties:
>  - data-shift       : integer describing how far the data lanes are shifted.
>  - pclk-sample      : integer describing if clk should be interpreted on
>               rising (<1>) or falling edge (<0>). Default is <1>.
>  - hsync-active     : integer describing if hsync is active high (<1>) or
>               active low (<0>). Default is <1>.
>  - vsync-active     : integer describing if vsync is active high (<1>) or
>               active low (<0>). Default is <1>.
>  - ti,data-ones-complement : boolean, describing that the data's polarity is
>                  one's complement.
> 
> endpoint subnode for serial interfaces
> --------------------------------------
> 
> Required properties:
>  - ti,isp-interface-type    : should be one of the following values

I think the interface type should be standardised at V4L2 level. We
currently do not do that, but instead do a little bit of guessing.

>   * <0> to use the phy in CSI mode
>   * <1> to use the phy in CCP mode
>   * <2> to use the phy in CCP mode, but configured for MIPI CSI2

Hmm. I'm not entirely sure what does this last option mean. I could be
forgetting something, though.

>  - ti,isp-clock-divisor     : integer used for configuration of the
>                   video port output clock control.
> 
> Optional properties:
>  - ti,disable-crc       : boolean, which disables crc checking.

I think crc should be standardised as well.

>  - ti,strobe-mode       : boolean, which setups data/strobe physical
>                   layer instead of data/clock physical layer.
>  - pclk-sample          : integer describing if clk should be interpreted on
>                   rising (<1>) or falling edge (<0>). Default is <1>.

I see different values on the N9 platform data for CCP2 and CSI2 (front and
back camera). I'm not sure the bus type is related to this or not.

> - data-lanes: an array of physical data lane indexes. Position of an entry
>   determines the logical lane number, while the value of an entry indicates
>   physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
>   "data-lanes = <1 2>;", assuming the clock lane is on hardware lane 0.
>   This property is valid for serial busses only (e.g. MIPI CSI-2).
> - clock-lanes: an array of physical clock lane indexes. Position of an entry
>   determines the logical lane number, while the value of an entry indicates
>   physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes = <0>;",
>   which places the clock lane on hardware lane 0. This property is valid for
>   serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 bus this
>   array contains only one entry.

I'd rather refer to
Documentation/devicetree/bindings/media/video-interfaces.txt than copy from
it. It's important that there's a single definition for the standard
properties. Just mentioning the property by name should be enough. What do
you think?

> Example for Nokia N900
> ----------------------
> 
> omap3isp: isp@480BC000 {
>     compatible = "ti,omap3isp";
>     reg =   <0x480BC000 0x070>, /* base */
>         <0x480BC100 0x078>, /* cbuf */
>         <0x480BC400 0x1F0>, /* cpp2 */
>         <0x480BC600 0x0A8>, /* ccdc */
>         <0x480BCA00 0x048>, /* hist */
>         <0x480BCC00 0x060>, /* h3a  */
>         <0x480BCE00 0x0A0>, /* prev */
>         <0x480BD000 0x0AC>, /* resz */
>         <0x480BD200 0x0FC>, /* sbl  */
>         <0x480BD400 0x070>; /* mmu  */

Mmu is a separate device. (Please see my patches.)

>     clocks = <&cam_ick>,
>          <&cam_mclk>,
>          <&csi2_96m_fck>,
>          <&l3_ick>;
>     clock-names = "cam_ick",
>               "cam_mclk",
>               "csi2_96m_fck",
>               "l3_ick";
> 
>     interrupts = <24>;
> 
>     ti,iommu = <&mmu_isp>;
> 
>     isp_xclk1: isp-xclk@0 {
>         compatible = "ti,omap3-isp-xclk";
>         reg = <0>;
>         #clock-cells = <0>;
>     };
> 
>     isp_xclk2: isp-xclk@1 {
>         compatible = "ti,omap3-isp-xclk";
>         reg = <1>;
>         #clock-cells = <0>;
>     };
> 
>     #address-cells = <1>;
>     #size-cells = <0>;
> 
>     port@0 {
>         reg = <0>;
> 
>         /* parallel interface is not used on Nokia N900 */
>         parallel_ep: endpoint {};
>     };
> 
>     port@1 {
>         reg = <1>;
> 
>         csi1_ep: endpoint {
>             remote-endpoint = <&switch_in>;
>             ti,isp-clock-divisor = <1>;
>             ti,strobe-mode;
>         };
>     }
> 
>     port@2 {
>         reg = <2>;
> 
>         /* second serial interface is not used on Nokia N900 */
>         csi2_ep: endpoint {};
>     }
> };
> 
> camera-switch {
>     /*
>      * TODO: 
>      *  - check if the switching code is generic enough to use a
>      *    more generic name like "gpio-camera-switch".
>      *  - document the camera-switch binding
>      */
>     compatible = "nokia,n900-camera-switch";

Indeed. I don't think the hardware engineers realised what kind of a long
standing issue they created for us when they chose that solution. ;)

Writing a small driver for this that exports a sub-device would probably be
the best option as this is hardly very generic. Should this be shown to the
user space or not? Probably it'd be nice to avoid showing the related sub-device
if there would be one.

I'm still trying to get N9 support working first, the drivers are in a
better shape and there are no such hardware hacks.

>     gpios = <&gpio4 1>; /* 97 */
> 
>     port@0 {
>         switch_in: endpoint {
>             remote-endpoint = <&csi1_ep>;
>         };
> 
>         switch_out1: endpoint {
>             remote-endpoint = <&et8ek8>;
>         };
> 
>         switch_out2: endpoint {
>             remote-endpoint = <&smiapp_dfl>;
>         };
>     };
> };

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
