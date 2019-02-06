Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1308C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB6F217F9
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfBFKyn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:54:43 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42655 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfBFKyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 05:54:43 -0500
Received: from [IPv6:2001:983:e9a7:1:d87d:799b:abeb:e52d] ([IPv6:2001:983:e9a7:1:d87d:799b:abeb:e52d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id rKqlgeOyQNR5yrKqmguSQ7; Wed, 06 Feb 2019 11:54:40 +0100
Subject: Re: [PATCH v13 10/13] media: imx7.rst: add documentation for i.MX7
 media driver
To:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
 <20190206102522.29212-11-rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20a5f044-9ce6-1ead-9bc4-3e6008706928@xs4all.nl>
Date:   Wed, 6 Feb 2019 11:54:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190206102522.29212-11-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfP2YHRaywqEvuUBQQwR31sKsDqpSrN0ewovWot9OLL5qfj0aA5+MM85jz3a52wHJFfCu+0NwKVNWXo3/rybhe0G6C9tWg80EPdSwWlKe0l/cxTQoLoAF
 7MZdRLa6BFd0RM7jQLwgCA6lsY8AvtEEvRbZYabZqpnhblYsd/cInRs7Gb38BbtltHhrH5d8IIGoA25vGQPM2dHUQLfaq4o9UmfgfwPsop7cPOWQUF5iTNTj
 BcN0iSB6xLhehttQxWIY3GV/tkzqUjtbYuIlhNifFJ6oQTYP3hHA4//x7+ur/T/DsUySrqGKJlxKDbBob7z+mwdxI7TX7f6tPPMElMpxGN6eVmbWs6aQD/Cr
 XDHE4/Ywpjo0kIBY+1pPgtXnRRN/3SKO4AVhXSgo0qEkZXhZaKx33iux8w26OEUQhlXL4b0uLQgbfA/XKTVr6/9MmSxznk89/lU6RqNA9cmBpDPdov+lN+fp
 5sVbWfx3k1x46aMcVic6IoliVLrGMqNcFstopKHspMcvBaCrFEXifNLaz0YkxirUHo6iIiST3rDsD3/3
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/6/19 11:25 AM, Rui Miguel Silva wrote:
> Add rst document to describe the i.MX7 media driver and also a working
> example from the Warp7 board usage with a OV2680 sensor.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Checkpatch gives me:

Applying: media: imx7.rst: add documentation for i.MX7 media driver
WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#2:
new file mode 100644

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
#7: FILE: Documentation/media/v4l-drivers/imx7.rst:1:
+i.MX7 Video Capture Driver

total: 0 errors, 2 warnings, 164 lines checked

Both warnings are valid, so can you make a v13.1 for this patch only?
Just include the MAINTAINERS change in this patch.

Regards,

	Hans

> ---
>  Documentation/media/v4l-drivers/imx7.rst  | 157 ++++++++++++++++++++++
>  Documentation/media/v4l-drivers/index.rst |   1 +
>  2 files changed, 158 insertions(+)
>  create mode 100644 Documentation/media/v4l-drivers/imx7.rst
> 
> diff --git a/Documentation/media/v4l-drivers/imx7.rst b/Documentation/media/v4l-drivers/imx7.rst
> new file mode 100644
> index 000000000000..cd1195d391c5
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
> +Unit (IPU); because of that the capabilities to perform operations or
> +manipulation of the capture frames are less feature rich.
> +
> +For image capture the i.MX7 has three units:
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
> +This is the MIPI CSI-2 receiver entity. It has one sink pad to receive the pixel
> +data from MIPI CSI-2 camera sensor. It has one source pad, corresponding to the
> +virtual channel 0. This module is compliant to previous version of Samsung
> +D-phy, and supports two D-PHY Rx Data lanes.
> +
> +csi_mux
> +-------
> +
> +This is the video multiplexer. It has two sink pads to select from either camera
> +sensor with a parallel interface or from MIPI CSI-2 virtual channel 0.  It has
> +a single source pad that routes to the CSI.
> +
> +csi
> +---
> +
> +The CSI enables the chip to connect directly to external CMOS image sensor. CSI
> +can interface directly with Parallel and MIPI CSI-2 buses. It has 256 x 64 FIFO
> +to store received image pixel data and embedded DMA controllers to transfer data
> +from the FIFO through AHB bus.
> +
> +This entity has one sink pad that receives from the csi_mux entity and a single
> +source pad that routes video frames directly to memory buffers. This pad is
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
> +After this streaming can start. The v4l2-ctl tool can be used to select any of
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
> diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
> index f28570ec9e42..dfd4b205937c 100644
> --- a/Documentation/media/v4l-drivers/index.rst
> +++ b/Documentation/media/v4l-drivers/index.rst
> @@ -44,6 +44,7 @@ For more details see the file COPYING in the source distribution of Linux.
>  	davinci-vpbe
>  	fimc
>  	imx
> +	imx7
>  	ipu3
>  	ivtv
>  	max2175
> 

