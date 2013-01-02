Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3ABWBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 17:01:30 -0500
Date: Wed, 2 Jan 2013 23:01:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC v2 01/15] [media] Add common video interfaces OF
 bindings documentation
In-Reply-To: <50E4ABD8.4040902@gmail.com>
Message-ID: <Pine.LNX.4.64.1301022256280.13661@axis700.grange>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
 <1356969793-27268-2-git-send-email-s.nawrocki@samsung.com>
 <Pine.LNX.4.64.1301021220370.7829@axis700.grange> <50E4ABD8.4040902@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Wed, 2 Jan 2013, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 01/02/2013 12:31 PM, Guennadi Liakhovetski wrote:
> > Hi Sylwester
> > 
> > Thanks for picking up these patches! In general both look good to me, just
> > a couple of nit-picks, that I couldn't help remarking:-)
> 
> Sure, thanks again for the feedback.
> 
> > On Mon, 31 Dec 2012, Sylwester Nawrocki wrote:
> > 
> > > From: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > > 
> > > This patch adds a document describing common OF bindings for video
> > > capture, output and video processing devices. It is curently mainly
> > > focused on video capture devices, with data busses defined by
> > > standards like ITU-R BT.656 or MIPI-CSI2.
> > > It also documents a method of describing data links between devices.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > > Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> > > Reviewed-by: Stephen Warren<swarren@nvidia.com>
> > > 
> > > ---
> > > 
> > > This is basically a resend of my previous version of this patch [1],
> > > with just a few typo/grammar issue corrections.
> > > 
> > > [1] http://patchwork.linuxtv.org/patch/15911/
> > > ---
> > >   .../devicetree/bindings/media/video-interfaces.txt |  198
> > > ++++++++++++++++++++
> > >   1 file changed, 198 insertions(+)
> > >   create mode 100644
> > > Documentation/devicetree/bindings/media/video-interfaces.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > new file mode 100644
> > > index 0000000..d1eea35
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > @@ -0,0 +1,198 @@
> > > +Common bindings for video data receiver and transmitter interfaces
> > > +
> > > +General concept
> > > +---------------
> > > +
> > > +Video data pipelines usually consist of external devices, e.g. camera
> > > sensors,
> > > +controlled over an I2C, SPI or UART bus, and SoC internal IP blocks,
> > > including
> > > +video DMA engines and video data processors.
> > > +
> > > +SoC internal blocks are described by DT nodes, placed similarly to other
> > > SoC
> > > +blocks.  External devices are represented as child nodes of their
> > > respective
> > > +bus controller nodes, e.g. I2C.
> > > +
> > > +Data interfaces on all video devices are described by their child 'port'
> > > nodes.
> > > +Configuration of a port depends on other devices participating in the
> > > data
> > > +transfer and is described by 'endpoint' subnodes.
> > > +
> > > +dev {
> > > +	#address-cells =<1>;
> > > +	#size-cells =<0>;
> > > +	port@0 {
> > > +		endpoint@0 { ... };
> > > +		endpoint@1 { ... };
> > > +	};
> > > +	port@1 { ... };
> > > +};
> > > +
> > > +If a port can be configured to work with more than one other device on
> > > the same
> > > +bus, an 'endpoint' child node must be provided for each of them.  If more
> > > than
> > > +one port is present in a device node or there is more than one endpoint
> > > at a
> > > +port, a common scheme, using '#address-cells', '#size-cells' and 'reg'
> > > properties
> > > +is used.
> > > +
> > > +Two 'endpoint' nodes are linked with each other through their
> > > 'remote-endpoint'
> > > +phandles.  An endpoint subnode of a device contains all properties needed
> > > for
> > > +configuration of this device for data exchange with the other device.  In
> > > most
> > > +cases properties at the peer 'endpoint' nodes will be identical, however
> > > +they might need to be different when there is any signal modifications on
> > > the
> > > +bus between two devices, e.g. there are logic signal inverters on the
> > > lines.
> > > +
> > > +Required properties
> > > +-------------------
> > > +
> > > +If there is more than one 'port' or more than one 'endpoint' node
> > > following
> > > +properties are required in relevant parent node:
> > > +
> > > +- #address-cells : number of cells required to define port number, should
> > > be 1.
> > > +- #size-cells    : should be zero.
> > > +
> > > +Optional endpoint properties
> > > +----------------------------
> > > +
> > > +- remote-endpoint : phandle to an 'endpoint' subnode of the other device
> > > node.
> > 
> > This spacing before ":" looks strange to me. I personally prefer the
> > normal English rule - "x: y," i.e. no space before and a space after, but
> > I wouldn't remark on your choice of a space on each side in this specific
> > case, if it was consistent. Whereas sometimes having one space and
> > sometimes having none looks weird to me. I would go for "no space before
> > ':'" throughout this document.
> 
> Gah, it was so close! ;) Sorry about it, it looked more readable to me that
> way.
> And I've checked other bindings' documentation and there was many files having
> space on both sides of a colon. Nevertheless, I will change it back to the
> original form.
> 
> > > +- slave-mode : a boolean property, run the link in slave mode. Default is
> > > master
> > > +  mode.
> > > +- bus-width : number of data lines, valid for parallel buses.
> > 
> > As we discussed before, both "busses" and "buses" spellings are commonly
> > used at different locations around the world, but I think we should stick
> > to only one of them in a single document. It looks weird to have "buses"
> > in one line and "busses" in the following one.
> 
> True, I think that was the one occurrence I'd noticed and have forgotten to
> correct then. I'll fix it, thanks for pointing out.

I think there were at least 2 of them, but I might be wrong, a grep will 
tell with certainty :-)

> > > +- data-shift: on parallel data busses, if bus-width is used to specify
> > > the
> > > +  number of data lines, data-shift can be used to specify which data
> > > lines are
> > > +  used, e.g. "bus-width=<10>; data-shift=<2>;" means, that lines 9:2 are
> > > used.
> > > +- hsync-active : active state of HSYNC signal, 0/1 for LOW/HIGH
> > > respectively.
> > > +- vsync-active : active state of VSYNC signal, 0/1 for LOW/HIGH
> > > respectively.
> > > +  Note, that if HSYNC and VSYNC polarities are not specified, embedded
> > > +  synchronization may be required, where supported.
> > > +- data-active : similar to HSYNC and VSYNC, specifies data line polarity.
> > > +- field-even-active: field signal level during the even field data
> > > transmission.
> > > +- pclk-sample : rising (1) or falling (0) edge to sample the pixel clock
> > > signal.
> > 
> > Yes, it was in my original document too, but don't we mean "sample data on
> > rising (1) or falling (0) edge of the pixel clock signal?"
> 
> Oops, I've managed to overlooked this. Certainly, it wasn't supposed to mean
> sampling the clock signal. BTW, I had some doubts about this property. On the
> transmitter side we more care about driving, rather than sampling data. And
> usually when a transmitter drives data line at one clock edge type (e.g.
> rising)
> then the receiver samples data on the other edge (e.g. falling).
> 
> In the display timing bindings there is a definitions like:
> 
> + - pixelclk-active: with
> +			- active high = drive pixel data on rising edge/
> +					sample data on falling edge
> +			- active low  = drive pixel data on falling edge/
> +					sample data on rising edge
> +			- ignored     = ignored
> 
> where:
> 
> +    <1>: high active
> +    <0>: low active
> +    omitted: not used on hardware
> 
> 
> Then in our case, e.g. pclk-sample = <1>; on the transmitter side would mean
> the receiver, which also has same pclk-sample = <1>; specified in its node,
> has to sample data on rising clock edge and the transmitter is driving data
> on falling edge, right ?

That's also what seems logical to me. We can rephrase it to "should be 
sampled (by the receiver) on the rising edge."

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
