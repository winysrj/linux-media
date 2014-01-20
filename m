Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39335 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaATWQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 17:16:48 -0500
Message-ID: <52DDA04B.90809@gmail.com>
Date: Mon, 20 Jan 2014 23:16:43 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Sebastian Reichel <sre@debian.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
References: <20131103220315.GA11659@earth.universe> <20140115194127.GA30988@earth.universe> <20140120041904.GH9997@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140120041904.GH9997@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/20/2014 05:19 AM, Sakari Ailus wrote:
> Hi Sebastian,
>
> I've also been working on this (besides others); what I have however are
> mostly experimental patches. I'm also using patches from Laurent, Florian
> Vaussard (IOMMU) and Hiroshi Doyu (IOMMU as well). My tree is here:
>
> <URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=summary>
>
> The branch is rm696-035-dt. The intent is to get the N9/N950 camera support
> to mainline. Most patches in that branch are experimental. What is missing
> entirely is constucting subdev groups off of the devices found. The rest
> will likely contain lots of bugs.
>
> Seems like you've started with documentation which I'm lacking entirely.
> Good! :)
>
> You might want to take a look at least at this one as well:
>
> <URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=commitdiff;h=58f7754099539178f47dcca97981bf2ba4c73e54>
>
> On Wed, Jan 15, 2014 at 08:41:28PM +0100, Sebastian Reichel wrote:
>> Hi,
>>
>> I finally found some time to update the proposed binding
>> documentation for omap3isp according to the comments on RFCv1.
>>
>> Changes since v1:
>>   * Use common DT clock bindings to provide isp-xclk
>>   * Use common DT video-interface bindings to specify device connections
>>   * Apply style updates suggested by Mark Rutland
>>   * I renamed ti,enable-crc to ti,disable-crc, since I think its supposed
>>     to be used for remote hw adding broken crc values. I can't see other
>>     reasons for disabling it :)
>>   * I've kept the clocks the same for now. I think somebody else should look
>>     over them. Changing the actual referenced clocks / renaming them is just
>>     a small change and can be done at a later time in the omap3isp DT process
>>     IMHO.
>>   * I've kept the reg reference as a list for now, since that's how the
>>     omap3isp driver currently works and I can't see any disadvantages
>>     in making the memory segmentation visible in the DTS file.
>>
>> So here is the proposed DT binding documentation:
>>
>> Binding for the OMAP3 Camera subsystem with the image signal processor (ISP)
>> feature. The binding follows the common video-interfaces Device Tree binding,
>> so it is recommended to read the common binding description first. This description
>
> Over 80 characters per line.
>
>> can be found in Documentation/devicetree/bindings/media/video-interfaces.txt
>>
>> omap3isp node
>> -------------
>>
>> Required properties:
>>
>> - compatible    : should be "ti,omap3isp" for OMAP3.
>> - reg       : physical addresses and length of the registers set.
>> - clocks    : list of clock specifiers, corresponding to entries in
>>            clock-names property.
>> - clock-names   : must contain "cam_ick", "cam_mclk", "csi2_96m_fck",
>>            "l3_ick" entries, matching entries in the clocks property.
>> - interrupts    : must contain mmu interrupt.
>> - ti,iommu  : phandle to isp mmu.
>
> Is the TI specific? I'd assume not. Hiroshi's patches assume that at least.
>
>> - #address-cells: Should be set to<1>.
>> - #size-cells   : Should be set to<0>.
>
> The ISP also exports clocks. Shouldn't you add
>
> #clock-cells =<1>;

If we treat the omap3isp node as the clock provider node then yes, it
should be added. And I think it is reasonable to do so, instead of e.g.
adding a separate DT node for the clocks provider.

>> Optional properties:
>>
>> - vdd-csiphy1-supply    : regulator for csi phy1
>> - vdd-csiphy2-supply    : regulator for csi phy2
>>
>> isp-xclk subnode
>> ----------------
>>
>> The omap3 ISP provides two external clocks, which are available as subnodes of
>> the omap3isp node. Devices using one of these clock devices are supposed to follow
>> the common Device Tree clock bindings described in
>>
>> Documentation/devicetree/bindings/clock/clock-bindings.txt
>>
>> Required properties:
>>   - compatible   : should contain "ti,omap3-cam-xclk"
>>   - reg      : should be set to
>>    *<0>  for cam_xclka
>>    *<1>  for cam_xclkb
>>   - #clock-cells : should be set to<0>
>
> Or to do this instead. I'm not an expert (or perhaps not even a little less)
> in DT so I don't know. The ISP is still a single device, and I think you
> might not need these to just refer to the clocks from elsewhere in the DT.

This doesn't seem to follow the common clock bindings.

Instead, you could define value of #clock-cells to be 1 and allow clocks
consumers to reference the provider node in a standard way, e.g.:

/* clk provider node */
omap3isp-clocks {
	#clock-cells = <1>;
};

camera-sensor-0 {
	clocks = <&omap3isp-clocks 0>; /* XCLK A */
	clock-names = ...
};

camera-sensor-1 {	
	clocks = <&omap3isp-clocks 1>; /* XCLK B */
	clock-names = ...
};

>> port subnode
>> ------------
>>
>> The omap3 ISP provides three different physical interfaces for camera
>> connections. Each of them is described using a port node.
>>
>> Required properties:
>>   - reg : Should be set to one of the following values
>>     *<0>  for the parallel interface (CPI)
>>     *<1>  for the first serial interface (CSI1)
>>     *<2>  for the second serial interface (CSI2)
>
> There are two PHYs in 3630 but three receivers. Currently the two are
> combined in the configuration. I think I agree with your approach.
>
>> endpoint subnode for parallel interface
>> ---------------------------------------
>>
>> The endpoint subnode describes the connection between the port and the remote
>> camera device.
>>
>> Required properties:
>>   - remote-endpoint  : phandle to remote device
>>
>> Optional properties:
>>   - data-shift       : integer describing how far the data lanes are shifted.
>>   - pclk-sample      : integer describing if clk should be interpreted on
>>                rising (<1>) or falling edge (<0>). Default is<1>.
>>   - hsync-active     : integer describing if hsync is active high (<1>) or
>>                active low (<0>). Default is<1>.
>>   - vsync-active     : integer describing if vsync is active high (<1>) or
>>                active low (<0>). Default is<1>.
>>   - ti,data-ones-complement : boolean, describing that the data's polarity is
>>                   one's complement.
>>
>> endpoint subnode for serial interfaces
>> --------------------------------------
>>
>> Required properties:
>>   - ti,isp-interface-type    : should be one of the following values
>
> I think the interface type should be standardised at V4L2 level. We
> currently do not do that, but instead do a little bit of guessing.

I'm all for such a standard property. It seems much more clear to use such
a property. And I already run into issues with deriving the bus interface
type from existing properties, please see https://linuxtv.org/patch/19937

I assume it would be fine to add a string type property like 
"interface-type"
or "bus-type".

>>    *<0>  to use the phy in CSI mode
>>    *<1>  to use the phy in CCP mode
>>    *<2>  to use the phy in CCP mode, but configured for MIPI CSI2
>
> Hmm. I'm not entirely sure what does this last option mean. I could be
> forgetting something, though.
>
>>   - ti,isp-clock-divisor     : integer used for configuration of the
>>                    video port output clock control.
>>
>> Optional properties:
>>   - ti,disable-crc       : boolean, which disables crc checking.
>
> I think crc should be standardised as well.

Definitely something we should have a common definition for.

>>   - ti,strobe-mode       : boolean, which setups data/strobe physical
>>                    layer instead of data/clock physical layer.
>>   - pclk-sample          : integer describing if clk should be interpreted on
>>                    rising (<1>) or falling edge (<0>). Default is<1>.
>
> I see different values on the N9 platform data for CCP2 and CSI2 (front and
> back camera). I'm not sure the bus type is related to this or not.
>
>> - data-lanes: an array of physical data lane indexes. Position of an entry
>>    determines the logical lane number, while the value of an entry indicates
>>    physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
>>    "data-lanes =<1 2>;", assuming the clock lane is on hardware lane 0.
>>    This property is valid for serial busses only (e.g. MIPI CSI-2).
>> - clock-lanes: an array of physical clock lane indexes. Position of an entry
>>    determines the logical lane number, while the value of an entry indicates
>>    physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes =<0>;",
>>    which places the clock lane on hardware lane 0. This property is valid for
>>    serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 bus this
>>    array contains only one entry.
>
> I'd rather refer to
> Documentation/devicetree/bindings/media/video-interfaces.txt than copy from
> it. It's important that there's a single definition for the standard
> properties. Just mentioning the property by name should be enough. What do
> you think?

+1

>> Example for Nokia N900
>> ----------------------
>>
>> omap3isp: isp@480BC000 {
>>      compatible = "ti,omap3isp";
>>      reg =<0x480BC000 0x070>, /* base */
>>          <0x480BC100 0x078>, /* cbuf */
>>          <0x480BC400 0x1F0>, /* cpp2 */
>>          <0x480BC600 0x0A8>, /* ccdc */
>>          <0x480BCA00 0x048>, /* hist */
>>          <0x480BCC00 0x060>, /* h3a  */
>>          <0x480BCE00 0x0A0>, /* prev */
>>          <0x480BD000 0x0AC>, /* resz */
>>          <0x480BD200 0x0FC>, /* sbl  */
>>          <0x480BD400 0x070>; /* mmu  */
>
> Mmu is a separate device. (Please see my patches.)
>
>>      clocks =<&cam_ick>,
>>           <&cam_mclk>,
>>           <&csi2_96m_fck>,
>>           <&l3_ick>;
>>      clock-names = "cam_ick",
>>                "cam_mclk",
>>                "csi2_96m_fck",
>>                "l3_ick";
>>
>>      interrupts =<24>;
>>
>>      ti,iommu =<&mmu_isp>;


>>      isp_xclk1: isp-xclk@0 {
>>          compatible = "ti,omap3-isp-xclk";
>>          reg =<0>;
>>          #clock-cells =<0>;
>>      };
>>
>>      isp_xclk2: isp-xclk@1 {
>>          compatible = "ti,omap3-isp-xclk";
>>          reg =<1>;
>>          #clock-cells =<0>;
>>      };

I think these whole 2 nodes could be omitted...

>>      #address-cells =<1>;
>>      #size-cells =<0>;

.. if you add here:

	#clock-cells =<1>;

>>      port@0 {
>>          reg =<0>;
>>
>>          /* parallel interface is not used on Nokia N900 */
>>          parallel_ep: endpoint {};
>>      };
>>
>>      port@1 {
>>          reg =<1>;
>>
>>          csi1_ep: endpoint {
>>              remote-endpoint =<&switch_in>;
>>              ti,isp-clock-divisor =<1>;
>>              ti,strobe-mode;
>>          };
>>      }
>>
>>      port@2 {
>>          reg =<2>;
>>
>>          /* second serial interface is not used on Nokia N900 */
>>          csi2_ep: endpoint {};
>>      }
>> };
>>
>> camera-switch {
>>      /*
>>       * TODO:
>>       *  - check if the switching code is generic enough to use a
>>       *    more generic name like "gpio-camera-switch".
>>       *  - document the camera-switch binding
>>       */
>>      compatible = "nokia,n900-camera-switch";
>
> Indeed. I don't think the hardware engineers realised what kind of a long
> standing issue they created for us when they chose that solution. ;)
>
> Writing a small driver for this that exports a sub-device would probably be
> the best option as this is hardly very generic. Should this be shown to the
> user space or not? Probably it'd be nice to avoid showing the related sub-device
> if there would be one.

Probably we should avoid exposing such a hardware detail to user space.
OTOH it would be easy to handle as a media entity through the media 
controller
API.

> I'm still trying to get N9 support working first, the drivers are in a
> better shape and there are no such hardware hacks.
>
>>      gpios =<&gpio4 1>; /* 97 */

I think the binding should be defining how state of the GPIO corresponds
to state of the mux.

>>      port@0 {
>>          switch_in: endpoint {
>>              remote-endpoint =<&csi1_ep>;
>>          };
>>
>>          switch_out1: endpoint {
>>              remote-endpoint =<&et8ek8>;
>>          };
>>
>>          switch_out2: endpoint {
>>              remote-endpoint =<&smiapp_dfl>;
>>          };
>>      };

This won't work, since names of the nodes are identical they will be 
combined
by the dtc into a single 'endpoint' node with single 'remote-endpoint' 
property
- might not be exactly something that you want.
So it could be rewritten like:

  port@0 {
	#address-cells = <1>;
	#size-cells = <0>;

	switch_in: endpoint@0 {
		reg = <0>;
		remote-endpoint =<&csi1_ep>;
	};

         switch_out1: endpoint@1 {
		reg = <1>;
		remote-endpoint =<&et8ek8>;
	};

	switch_out2: endpoint@2 {
		reg = <2>;
		remote-endpoint =<&smiapp_dfl>;
	};
  };

However, simplifying a bit, the 'endpoint' nodes are supposed to describe
the configuration of a bus interface (port) for a specific remote device.
Then what you need might be something like:

  camera-switch {
	compatible = "nokia,n900-camera-switch";

	#address-cells = <1>;
	#size-cells = <0>;

	switch_in: port@0 {
		reg = <0>;
		endpoint {
			remote-endpoint =<&csi1_ep>;
		};
	};

         switch_out1: port@1 {
		reg = <1>;
		endpoint {
			remote-endpoint =<&et8ek8>;
		};
	};

	switch_out2: port@2 {
		endpoint {
			reg = <2>;
			remote-endpoint =<&smiapp_dfl>;
		};
	};
  };

I'm just wondering if we need to be describing this in DT in such detail.

--
Thanks,
Sylwester
