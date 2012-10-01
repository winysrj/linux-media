Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56640 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2JAUpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 16:45:45 -0400
Message-ID: <506A00F3.40909@gmail.com>
Date: Mon, 01 Oct 2012 22:45:39 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 09/27/2012 04:07 PM, Guennadi Liakhovetski wrote:
> This patch adds a document, describing common V4L2 device tree bindings.
> 
> Co-authored-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> ---
>   Documentation/devicetree/bindings/media/v4l2.txt |  162 ++++++++++++++++++++++
>   1 files changed, 162 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/media/v4l2.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/v4l2.txt b/Documentation/devicetree/bindings/media/v4l2.txt
> new file mode 100644
> index 0000000..b8b3f41
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/v4l2.txt
> @@ -0,0 +1,162 @@
> +Video4Linux Version 2 (V4L2)
> +
> +General concept
> +---------------
> +
> +Video pipelines consist of external devices, e.g. camera sensors, controlled
> +over an I2C, SPI or UART bus, and SoC internal IP blocks, including video DMA
> +engines and video data processors.
> +
> +SoC internal blocks are described by DT nodes, placed similarly to other SoC
> +blocks. External devices are represented as child nodes of their respective bus
> +controller nodes, e.g. I2C.
> +
> +Data interfaces on all video devices are described by "port" child DT nodes.
> +Configuration of a port depends on other devices participating in the data
> +transfer and is described by "link" DT nodes, specified as children of the
> +"port" nodes:
> +
> +/foo {
> +	port@0 {
> +		link@0 { ... };
> +		link@1 { ... };
> +	};
> +	port@1 { ... };
> +};
> +
> +If a port can be configured to work with more than one other device on the same
> +bus, a "link" child DT node must be provided for each of them. If more than one
> +port is present on a device or more than one link is connected to a port, a
> +common scheme, using "#address-cells," "#size-cells" and "reg" properties is
> +used.
> +
> +Optional link properties:
> +- remote: phandle to the other endpoint link DT node.
> +- slave-mode: a boolean property, run the link in slave mode. Default is master
> +  mode.
> +- data-shift: on parallel data busses, if data-width is used to specify the
> +  number of data lines, data-shift can be used to specify which data lines are
> +  used, e.g. "data-width=<10>; data-shift=<2>;" means, that lines 9:2 are used.
> +- hsync-active: 1 or 0 for active-high or -low HSYNC signal polarity
> +  respectively.
> +- vsync-active: ditto for VSYNC. Note, that if HSYNC and VSYNC polarities are
> +  not specified, embedded synchronisation may be required, where supported.
> +- data-active: similar to HSYNC and VSYNC specifies data line polarity.
> +- field-even-active: field signal level during the even field data transmission.
> +- pclk-sample: rising (1) or falling (0) edge to sample the pixel clock pin.
> +- data-lanes: array of serial, e.g. MIPI CSI-2, data hardware lane numbers in
> +  the ascending order, beginning with logical lane 0.
> +- clock-lanes: hardware lane number, used for the clock lane.

It is not very clear we are using common contiguous range of logical indexes
for the clock and the data lanes, IMO. Maybe something like this would be
more explicit:

- data-lanes: an array of hardware data lane indexes. Position of an entry 
  determines logical lane number, while the value of an entry indicates hardware
  lane number, e.g. for 2-lane MIPI CSI-2 bus we could have data-lanes = <1>, <2>;,
  assuming the clock lane is on hardware lane 0. This property is applicable to
  serial buses only (e.g. MIPI CSI-2). 

?

--

Thanks,
Sylwester
