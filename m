Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10387 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2JJPmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:42:25 -0400
Message-id: <5075975C.3090306@samsung.com>
Date: Wed, 10 Oct 2012 17:42:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	'linux-arm-kernel' <linux-arm-kernel@lists.infradead.org>
Subject: [RFC] Samsung SoC camera DT bindings
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

The following is a brief description of Samsung SoC architecture from the 
camera point of view and a corresponding device tree structure. It is based 
on the media devices DT bindings design from Guennadi [1]. I  incorporated
some changes proposed during reviews (e.g. s/link/endpoint). It seems the 
common media bindings are more or less settled now and the discussions are 
mostly about implementation of the common parsers and core code.

This RFC is just about an example of the media bindings for fairly complex
SoC architecture. I would be happy to get any feedback on that, while I'm
about to start adding support for this at the driver.

In Samsung SoCs there are multiple capture interfaces that can be attached
to each physical camera port, either parallel video bus or serial MIPI CSI-2.

                                          c02    +-------------+
                                  c01 |   |   |  |             |
                                    ------o----->+  CAM_IF.0   |--> memory
+---------------------+  +--------+   |   |   |  |             |
| sensor A (MIPI CSI2)|  | CSI-RX |   |   |   |  +-------------+
+---------------------+>-+--------+->-|---o-  |
                                      |   |   o------<----------- from ISP
+----------------------+              |   |   |
| sensor B (parallel)  |              |   |   |
+----------------------+------->------o-  |   |
                                      |   |   |  +-------------+
                                  c11 |   | c12  |             |
                                    ----------o->+  CAM_IF.1   |--> memory
                                      |   |   |  |             |
                                      |   |   |  +-------------+
                                      .   .   .
                                      |   |   |  +-------------+
                                  c21 |   |c22|  |             |  to ISP 
                                    --o--------->+  CAM_IF_L.0 |--> (SoC
                                      |   |   |  |             |  internal
                                                 +-------------+  data bus)

As in the above figure, each external sensor can be connected to any of the 
CAM_IFs at run-time. It's also possible to connect two CAM_IFs to a single 
sensor in parallel. CSI-RX devices and parallel video bus port are connected 
to CAM_IF.N devices internally through some sort of crossbar interconnect.

On some SoCs there is also an ISP, which can use one of the two limited 
capture interfaces (CAM_IF_L.0) as front-ends and return video data to
a CAM_IF.N that acts as a DMA engine. Following configurations are possible:

sensor A -> mipi-csi2 slave (CSI-RX) -> CAM_IF.? -> memory
sensor B -> CAM_IF.? -> memory

sensor A -> mipi-csi2 slave (CSI-RX) -> CAM_IF_LITE.? -> memory
sensor B -> CAM_IF_LITE.? -> memory

sensor B -> CAM_IF_LITE.? -> ISP -> CAM_IF.? -> memory
sensor A -> mipi-csi2 slave (CSI-RX) -> CAM_IF_LITE.? -> ISP -> CAM_IF.? 
-> memory

Describing all these possible links by our port/endpoint convention would
result in unnecessarily complex structure. These SoC's internal data routing
could well be coded in the driver, depending on the available hardware 
entities and based only on the compatible property. 

On the other hand it would be useful to specify certain initial active link 
configurations, so the device is in known and valid state after the driver
has initialized. I chose to specify only those default internal SoC links
in DT, leaving sorting out all possible routes for the driver.

The below device tree structure contains two camera sensors controlled over
an I2C bus, where m5mols is connected to the SoC through MIPI CSI-2 bus 
and s5k5bafx is on a parallel video bus. There are following default links
specified there:
  1) m5mols -> csis0 -> fimc0,
  2) s5k4bafx -> fimc1.

Any comments and suggestions are welcome.

/*===========================================================================*/

   /* Aliases for assigning platform entity indexes at the drivers */
    aliases {
        csis0 = &csis_0;
        csis1 = &csis_1;
        fimc0 = &fimc_0;
        fimc1 = &fimc_1;
        fimc2 = &fimc_2;
        fimc3 = &fimc_3;
        fimc_lite0 = &fimc_lite_0;
        fimc_lite1 = &fimc_lite_1;
    };

    i2c0: i2c@0xfff20000 {
        ...
        /* Parallel bus IF sensor */
        s5k5bafx: sensor@0x21 {
            compatible = "samsung,s5k5bafx";
            reg = <0x21>;
            vddio-supply = <&regulator1>;
            vddcore-supply = <&regulator2>;

            clock-frequency = <20000000>;
            clocks = <&mclk0>;
            clock-names = "mclk";

            port {
                s5k5bafx_1: endpoint {
                    remote-endpoint = <&cam_a_endpoint>;
                    bus-width = <8>;
                    hsync-active = <0>;
                    hsync-active = <1>;
                    pclk-sample = <1>;
                };
            };
        };

        /* MIPI CSI-2 bus IF sensor */
        m5mols: sensor@0x1a {
            compatible = "samsung,m5mols";
            reg = <0x1a>;
            vddio-supply = <&regulator1>;
            vddcore-supply = <&regulator2>;

            clock-frequency = <30000000>;  /* shared clock with ov772x_1 */
            clocks = <&mclk0>;
            clock-names = "mclk";  /* assuming this is the name in the datasheet */

            port {
                    m5mols_1: endpoint {
                        data-lanes = <1>, <2>, <3>, <4>;
                        remote-endpoint = <&csis0_cam_endpoint>;
                    };
            };
        };
    };

    /* An aggregate node to gather properties common and shared among
       all the SoC camera devices.  */

    camera {
        compatible = "samsung,fimc";

        /* These two clocks are common for all fimc and fimc_lite devices */
        mclk0: sclk_cam@0 {
            #clock-cells = <0>;
            /* the sclk_cam_0 phandle comes from clock bindings not shown here */
            clocks = <&sclk_cam_0>;
            clock-output-names = "fimc_sclk_cam0";
        };

        mclk1: sclk_cam@1 {
            #clock-cells = <0>;
            clocks = <&sclk_cam_1>;
            clock-output-names = "fimc_sclk_cam1";
        };

        /* parallel video port A */
        parallel_camera_port@1 {
            cam_port_a: port@1 {
                #address-cells = <1>;
                #size-cells = <0>;
                reg = <1>;   /* reg also determines FIMC input type: port = { A, B, C, D } 
                               <=> reg = { 1, 2 , 3, 4 }. A, B are parallel, C is serial
                              from CSIS, D is internal FIFO link from an internal SoC 
                              processing block. */

                cam_a_endpoint: endpoint {
                    remote-endpoint = <&s5k5bafx_1>;  /* remote endpoint phandle */
                    bus-width = <8>;     /* used data lines */
                    hsync-active = <1>;  /* active high */
                    vsync-active = <0>;  /* active low */
                    pclk-sample = <1>;   /* rising */
                };
            };

            /* SoC internal port for the physical parallel camera port A */
            port@0 {
                reg = <0>; /* 0 always indicates SoC internal port */

                cam_a_soc_endpoint: endpoint {
		/* There is more possible remote endpoints, we just specify 
                   the one default that will be seen active. This remote endpoint 
                   can be switched over at run-time. The list of endpoints possible 
                   to select is hard coded in the driver, depending on the 
                   compatible property.
                 */
                    remote-endpoint = <&fimc0_endpoint>;
                };
            };
        };

        /* The camera ports (pinmux) configuration, these are common for all
           fimc and fimc_lite devices */
        pinctrl-names = "default";
        pinctrl-0 = <&camera_port_a &camera_port_c>;

        /* MIPI-CSIS.0 */
        csis0: csis@11880000 {
            compatible = "samsung,exynos4210-csis";
            reg = <0x11880000 0x1000>;
            interrupts = <0 78 0>;

            cam_port_c: port@2 {
                #address-cells = <1>;
                #size-cells = <0>;
                reg = <2>;    /* (MIPI CSI-2) LVDS port C  */

                csis0_cam_endpoint: endpoint {
                    remote-endpoint = <&m5mols_1>;
                    data-lanes = <1>, <2>, <3>,  <4>;
                };
            };

            /* SoC internal port for the physical parallel camera port A */
            port@0 {
                   reg = <0>;

                   csis0_endpoint: endpoint {
		       /* There is more possible remote endpoints, we just
                          specify the one default that will be seen active.
                          This remote endpoint can be switched over at run-time.
                          The list of endpoints possible to select is hard coded
                          in the driver, depending on the compatible property.
                        */
                       remote-endpoint = <&fimc1_endpoint>;
                   };
            };
        };

        /* MIPI-CSIS.1 */
        csis1: csis@11890000 {
            compatible = "samsung,exynos4210-csis";
            reg = <0x11890000 0x1000>;
            interrupts = <0 79 0>;
        };

        /* FIMC.0 (CAM_IF.0) */
        fimc0: fimc@11800000 {
            compatible = "samsung,exynos4x12-fimc";
            reg = <0x11800000 0x1000>;
            interrupts = <0 84 0>;

            port {
	          /* Link to the physical parallel camera port A */
                   fimc0_endpoint: endpoint {
                       remote-endpoint = <&cam_a_soc_endpoint>;
                   };
           };
        };

        fimc1: fimc@11900000 {
            compatible = "samsung,exynos4x12-fimc";
            reg = <0x11900000 0x1000>;
            interrupts = <0 85 0>;
            port {
	          /* Link to the MIPI CSI-2  front-end (csis0) */
                   fimc1_endpoint: endpoint {
                       remote-endpoint = <&csis0_cam_endpoint>;
                   };
           };
        };

        fimc2: fimc@11a00000 {
            compatible = "samsung,exynos4x12-fimc";
            reg = <0x11a00000 0x1000>;
             interrupts = <0 86 0>;
        };

        fimc3: fimc@11b00000 {
            compatible = "samsung,exynos4x12-fimc";
            reg = <0x11b00000 0x1000>;
            interrupts = <0 87 0>;
        };

        /* FIMC-LITE.0 (CAM_IF_LITE.0) */
        fimc_lite0: fimc_lite@12000000 {
            compatible = "samsung,exynos4x12-fimc";
            reg = <0x12000000 0x1000>;
            interrupts = <0 90 0>;
        };

        fimc_lite1: fimc_lite@12100000 {
            compatible = "samsung,exynos4x12-fimc";
            reg = <0x12100000 0x1000>;
            interrupts = <0 91 0>;
        };
    };

/*===========================================================================*/

--- 

Regards,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg54023.html
