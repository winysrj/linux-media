Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48540 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755439AbeEHRYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 13:24:30 -0400
Subject: Re: [PATCH v3 13/14] media: imx7.rst: add documentation for i.MX7
 media driver
To: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-media@vger.kernel.org
References: <20180507162152.2545-1-rui.silva@linaro.org>
 <20180507162152.2545-14-rui.silva@linaro.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c4f8d144-0ab8-d72a-7bff-3dc4d1598380@infradead.org>
Date: Tue, 8 May 2018 10:24:21 -0700
MIME-Version: 1.0
In-Reply-To: <20180507162152.2545-14-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a few editing suggestions below...

On 05/07/2018 09:21 AM, Rui Miguel Silva wrote:
> Add rst document to describe the i.MX7 media driver and also a working example
> from the Warp7 board usage with a OV2680 sensor.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  Documentation/media/v4l-drivers/imx7.rst  | 157 ++++++++++++++++++++++
>  Documentation/media/v4l-drivers/index.rst |   1 +
>  2 files changed, 158 insertions(+)
>  create mode 100644 Documentation/media/v4l-drivers/imx7.rst
> 
> diff --git a/Documentation/media/v4l-drivers/imx7.rst b/Documentation/media/v4l-drivers/imx7.rst
> new file mode 100644
> index 000000000000..64b97b442277
> --- /dev/null
> +++ b/Documentation/media/v4l-drivers/imx7.rst
> @@ -0,0 +1,157 @@
> +i.MX7 Video Capture Driver
> +==========================
> +
> +Introduction
> +------------
> +
> +The i.MX7 contrary to the i.MX5/6 family does not contain an Image Processing
> +Unit (IPU), because of that the capabilities to perform operations or

s/,/;/

> +manipulation of the capture frames is less feature rich.

                                      are less

> +
> +For image capture the i.MX7 have three units:

                               has

> +- CMOS Sensor Interface (CSI)
> +- Video Multiplexer
> +- MIPI CSI-2 Receiver
> +
> +::
> +                                           |\
> +   MIPI Camera Input ---> MIPI CSI-2 --- > | \
> +                                           |  \
> +                                           | M |
> +                                           | U | ------>  CSI ---> Capture
> +                                           | X |
> +                                           |  /
> +   Parallel Camera Input ----------------> | /
> +                                           |/
> +
> +For additional information, please refer to the latest versions of the i.MX7
> +reference manual [#f1]_.
> +
> +Entities
> +--------
> +
> +imx7-mipi-csi2
> +--------------
> +
> +This is the MIPI CSI-2 recevier entity. It has one sink pad to receive the pixel

                          receiver

> +data from MIPI CSI-2 camera sensor. It has one source pad, corresponding to the
> +virtual channel 0. This module is compliant to previous version of Samsung
> +D-phy, and support two D-PHY Rx Data lanes.

              supports

> +
> +csi_mux
> +-------
> +
> +This is the video multiplexer. It has two sink pads to select from either camera
> +sensors with a parallel interface or from MIPI CSI-2 virtual channel 0.  It has

   sensor

> +a single source pad that routes to the CSI.
> +
> +csi
> +---
> +
> +The CSI enables the chip to connect directly to external CMOS image sensor. CSI
> +can interfaces directly with Parallel and MIPI CSI-2 buses. It has 256 x 64 FIFO

       interface

> +to store received image pixel data and embedded DMA controllers to transfer data
> +from the FIFO through AHB bus.
> +
> +This entity has one sink pad that receive from the csi_mux entity and a single

                                     receives

> +source pad that route video frames directly to memory buffers, this pad is

                   routes                                buffers. This pad is

> +routed to a capture device node.
> +
> +Usage Notes
> +-----------
> +
> +To aid in configuration and for backward compatibility with V4L2 applications
> +that access controls only from video device nodes, the capture device interfaces
> +inherit controls from the active entities in the current pipeline, so controls
> +can be accessed either directly from the subdev or from the active capture
> +device interface. For example, the sensor controls are available either from the
> +sensor subdevs or from the active capture device.
> +
> +Warp7 with OV2680
> +-----------------
> +
> +On this platform an OV2680 MIPI CSI-2 module is connected to the internal MIPI
> +CSI-2 receiver. The following example configures a video capture pipeline with
> +an output of 800x600, and BGGR 10 bit bayer format:
> +
> +.. code-block:: none
> +   # Setup links
> +   media-ctl -l "'ov2680 1-0036':0 -> 'imx7-mipi-csis.0':0[1]"
> +   media-ctl -l "'imx7-mipi-csis.0':1 -> 'csi_mux':1[1]"
> +   media-ctl -l "'csi_mux':2 -> 'csi':0[1]"
> +   media-ctl -l "'csi':1 -> 'csi capture':0[1]"
> +
> +   # Configure pads for pipeline
> +   media-ctl -V "'ov2680 1-0036':0 [fmt:SBGGR10_1X10/800x600 field:none]"
> +   media-ctl -V "'csi_mux':1 [fmt:SBGGR10_1X10/800x600 field:none]"
> +   media-ctl -V "'csi_mux':2 [fmt:SBGGR10_1X10/800x600 field:none]"
> +   media-ctl -V "'imx7-mipi-csis.0':0 [fmt:SBGGR10_1X10/800x600 field:none]"
> +   media-ctl -V "'csi':0 [fmt:SBGGR10_1X10/800x600 field:none]"
> +
> +After this streaming can start, the v4l2-ctl tool can be used to select any of

                        can start. The

> +the resolutions supported by the sensor.
> +
> +.. code-block:: none
> +    root@imx7s-warp:~# media-ctl -p
> +    Media controller API version 4.17.0
> +
> +    Media device information
> +    ------------------------
> +    driver          imx-media
> +    model           imx-media
> +    serial
> +    bus info
> +    hw revision     0x0
> +    driver version  4.17.0
> +
> +    Device topology
> +    - entity 1: csi (2 pads, 2 links)
> +		type V4L2 subdev subtype Unknown flags 0
> +		device node name /dev/v4l-subdev0
> +	    pad0: Sink
> +		    [fmt:SBGGR10_1X10/800x600 field:none]
> +		    <- "csi_mux":2 [ENABLED]
> +	    pad1: Source
> +		    [fmt:SBGGR10_1X10/800x600 field:none]
> +		    -> "csi capture":0 [ENABLED]
> +
> +    - entity 4: csi capture (1 pad, 1 link)
> +		type Node subtype V4L flags 0
> +		device node name /dev/video0
> +	    pad0: Sink
> +		    <- "csi":1 [ENABLED]
> +
> +    - entity 10: csi_mux (3 pads, 2 links)
> +		type V4L2 subdev subtype Unknown flags 0
> +		device node name /dev/v4l-subdev1
> +	    pad0: Sink
> +		    [fmt:unknown/0x0]
> +	    pad1: Sink
> +		    [fmt:unknown/800x600 field:none]
> +		    <- "imx7-mipi-csis.0":1 [ENABLED]
> +	    pad2: Source
> +		    [fmt:unknown/800x600 field:none]
> +		    -> "csi":0 [ENABLED]
> +
> +    - entity 14: imx7-mipi-csis.0 (2 pads, 2 links)
> +		type V4L2 subdev subtype Unknown flags 0
> +		device node name /dev/v4l-subdev2
> +	    pad0: Sink
> +		    [fmt:SBGGR10_1X10/800x600 field:none]
> +		    <- "ov2680 1-0036":0 [ENABLED]
> +	    pad1: Source
> +		    [fmt:SBGGR10_1X10/800x600 field:none]
> +		    -> "csi_mux":1 [ENABLED]
> +
> +    - entity 17: ov2680 1-0036 (1 pad, 1 link)
> +		type V4L2 subdev subtype Sensor flags 0
> +		device node name /dev/v4l-subdev3
> +	    pad0: Source
> +		    [fmt:SBGGR10_1X10/800x600 field:none]
> +		    -> "imx7-mipi-csis.0":0 [ENABLED]
> +
> +
> +References
> +----------
> +
> +.. [#f1] https://www.nxp.com/docs/en/reference-manual/IMX7SRM.pdf

thanks.
-- 
~Randy
