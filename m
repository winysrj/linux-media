Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2on0085.outbound.protection.outlook.com ([65.55.169.85]:25792
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755187AbbAZTwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 14:52:08 -0500
From: Chris Kohn <christian.kohn@xilinx.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Michal Simek <michals@xilinx.com>,
	Hyun Kwon <hyunk@xilinx.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4 08/10] v4l: xilinx: Add Xilinx Video IP core
Date: Mon, 26 Jan 2015 19:37:02 +0000
References: <1417464820-6718-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1417464820-6718-9-git-send-email-laurent.pinchart@ideasonboard.com>
 <2694110.qINIujyFZb@avalon> <54C0C65C.7010702@xs4all.nl>
In-Reply-To: <54C0C65C.7010702@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Message-ID: <6959e7a2c9ad45e9a17c0c5738bce09f@BN1BFFO11FD053.protection.gbl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans and Laurent,

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Thursday, January 22, 2015 1:44 AM
> To: Laurent Pinchart; Chris Kohn
> Cc: linux-media@vger.kernel.org; Michal Simek; Hyun Kwon;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH v4 08/10] v4l: xilinx: Add Xilinx Video IP core
>
> On 01/22/15 04:01, Laurent Pinchart wrote:
> > Hi Hans and Chris,
> >
> > On Monday 01 December 2014 22:13:38 Laurent Pinchart wrote:
> >> Xilinx platforms have no hardwired video capture or video processing
> >> interface. Users create capture and memory to memory processing
> >> pipelines in the FPGA fabric to suit their particular needs, by
> >> instantiating video IP cores from a large library.
> >>
> >> The Xilinx Video IP core is a framework that models a video pipeline
> >> described in the device tree and expose the pipeline to userspace
> >> through the media controller and V4L2 APIs.
> >>
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> >> Signed-off-by: Radhey Shyam Pandey <radheys@xilinx.com>
> >> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >
> > [snip]
> >
> >> diff --git a/Documentation/devicetree/bindings/media/xilinx/video.txt
> >> b/Documentation/devicetree/bindings/media/xilinx/video.txt new file
> >> mode
> >> 100644
> >> index 0000000..15720e4
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/xilinx/video.txt
> >> @@ -0,0 +1,52 @@
> >> +DT bindings for Xilinx video IP cores
> >> +-------------------------------------
> >> +
> >> +Xilinx video IP cores process video streams by acting as video sinks
> >> +and/or sources. They are connected by links through their input and
> >> +output ports, creating a video pipeline.
> >> +
> >> +Each video IP core is represented by an AMBA bus child node in the
> >> +device tree using bindings documented in this directory. Connections
> >> +between the
> >> IP
> >> +cores are represented as defined in ../video-interfaces.txt.
> >> +
> >> +The whole  pipeline is represented by an AMBA bus child node in the
> >> +device tree using bindings documented in ./xlnx,video.txt.
> >> +
> >> +Common properties
> >> +-----------------
> >> +
> >> +The following properties are common to all Xilinx video IP cores.
> >> +
> >> +- xlnx,video-format: This property represents a video format
> >> +transmitted on
> >> an
> >> +  AXI bus between video IP cores. How the format relates to the IP
> >> + core is  decribed in the IP core bindings documentation. The
> >> + following formats are  supported.
> >> +
> >> +  rbg
> >> +  xrgb
> >> +  yuv422
> >> +  yuv444
> >> +  rggb
> >> +  grbg
> >> +  gbrg
> >> +  bggr
> >> +
> >> +- xlnx,video-width: This property qualifies the video format with
> >> +the
> >> sample
> >> +  width expressed as a number of bits per pixel component. All
> >> + components
> >> must
> >> +  use the same width.
> >
> > Hans, last time we've discussed this on IRC you were not happy with
> > the format description used in these DT bindings. Your argument was,
> > if I remember correctly, that as the formats map directly to media bus
> > codes, it would be better to use the media bus codes (or a string
> > representation of them) in the bindings instead of creating a new format
> description. Is that correct ?
>
> Correct. Where possible I think the names should map to the mediabus names.
> So uyvy instead of yuv422, srggb instead of rggb, etc.

A string representation of the mediabus names sounds good to me.

Cheers,
Chris

> >
> > Chris, what's your opinion on that ? The RGB and YUV formats in the
> > table below describe the hardware and come from table 1-4 on page 8 of
> >
> http://www.xilinx.com/support/documentation/ip_documentation/axi_videoip/
> v1_0/ug934_axi_videoIP.pdf.
> > The Bayer formats are not standardized in the document, and I don't
> > think we need them at the moment.
> >
> >> +The following table lists the supported formats and widths
> >> +combinations,
> >> along
> >> +with the corresponding media bus pixel code.
> >> +
> >> +----------------+-------+-------------------------------------------
> >> +----------------+-------+-------
> >> +Format            | Width | Media bus code
> >> +----------------+-------+-------------------------------------------
> >> +----------------+-------+-------
> >> +rbg               | 8     | V4L2_MBUS_FMT_RBG888_1X24
> >> +xrgb              | 8     | V4L2_MBUS_FMT_RGB888_1X32_PADHI
> >> +yuv422            | 8     | V4L2_MBUS_FMT_UYVY8_1X16
> >> +yuv444            | 8     | V4L2_MBUS_FMT_VUY888_1X24
> >> +rggb              | 8     | V4L2_MBUS_FMT_SRGGB8_1X8
> >> +grbg              | 8     | V4L2_MBUS_FMT_SGRBG8_1X8
> >> +gbrg              | 8     | V4L2_MBUS_FMT_SGBRG8_1X8
> >> +bggr              | 8     | V4L2_MBUS_FMT_SBGGR8_1X8
> >> +----------------+-------+-------------------------------------------
> >> +----------------+-------+-------
> >> diff --git
> >> a/Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
> >> b/Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt new
> >> file mode 100644 index 0000000..5a02270
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
> >> @@ -0,0 +1,55 @@
> >> +Xilinx Video IP Pipeline (VIPP)
> >> +-------------------------------
> >> +
> >> +General concept
> >> +---------------
> >> +
> >> +Xilinx video IP pipeline processes video streams through one or more
> >> +Xilinx video IP cores. Each video IP core is represented as
> >> +documented in
> >> video.txt
> >> +and IP core specific documentation, xlnx,v-*.txt, in this directory.
> >> +The DT node of the VIPP represents as a top level node of the
> >> +pipeline and defines mappings between DMAs and the video IP cores.
> >> +
> >> +Required properties:
> >> +
> >> +- compatible: Must be "xlnx,video".
> >> +
> >> +- dmas, dma-names: List of one DMA specifier and identifier string
> >> +(as
> >> defined
> >> +  in Documentation/devicetree/bindings/dma/dma.txt) per port. Each
> >> + port  requires a DMA channel with the identifier string set to
> >> + "port" followed
> >> by
> >> +  the port index.
> >> +
> >> +- ports: Video port, using the DT bindings defined in
> >> ../video-interfaces.txt.
> >> +
> >> +Required port properties:
> >> +
> >> +- direction: should be either "input" or "output" depending on the
> >> direction
> >> +  of stream.
> >> +
> >> +Example:
> >> +
> >> +  video_cap {
> >> +          compatible = "xlnx,video";
> >> +          dmas = <&vdma_1 1>, <&vdma_3 1>;
> >> +          dma-names = "port0", "port1";
> >> +
> >> +          ports {
> >> +                  #address-cells = <1>;
> >> +                  #size-cells = <0>;
> >> +
> >> +                  port@0 {
> >> +                          reg = <0>;
> >> +                          direction = "input";
> >> +                          vcap0_in0: endpoint {
> >> +                                  remote-endpoint = <&scaler0_out>;
> >> +                          };
> >> +                  };
> >> +                  port@1 {
> >> +                          reg = <1>;
> >> +                          direction = "input";
> >> +                          vcap0_in1: endpoint {
> >> +                                  remote-endpoint = <&switch_out1>;
> >> +                          };
> >> +                  };
> >> +          };
> >> +  };
> >



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

