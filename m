Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE094C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 16:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 758F721900
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 16:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfCVQCF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:02:05 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51693 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbfCVQCF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 12:02:05 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 0DC7FC000A;
        Fri, 22 Mar 2019 16:01:58 +0000 (UTC)
Date:   Fri, 22 Mar 2019 17:02:38 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Vishal Sagar <vsagar@xilinx.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
Subject: Re: [PATCH v6 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Message-ID: <20190322160238.zh7sgalvvkdrl7wz@uno.localdomain>
References: <1552365330-21155-1-git-send-email-vishal.sagar@xilinx.com>
 <1552365330-21155-2-git-send-email-vishal.sagar@xilinx.com>
 <20190312102118.6ianedkzscr7gdba@kekkonen.localdomain>
 <DM5PR02MB2713DB568A4AD713BE3B2621A7490@DM5PR02MB2713.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qjobgvtznmmsbbct"
Content-Disposition: inline
In-Reply-To: <DM5PR02MB2713DB568A4AD713BE3B2621A7490@DM5PR02MB2713.namprd02.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--qjobgvtznmmsbbct
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Vishal,
   sorry, I missed this

On Tue, Mar 12, 2019 at 02:45:06PM +0000, Vishal Sagar wrote:
>
> Hi Sakari,
>
> Thanks for reviewing this.
>
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Sakari Ailus
> > Sent: Tuesday, March 12, 2019 3:51 PM
> > To: Vishal Sagar <vishal.sagar@xilinx.com>
> > Cc: Hyun Kwon <hyunk@xilinx.com>; laurent.pinchart@ideasonboard.com;
> > mchehab@kernel.org; robh+dt@kernel.org; mark.rutland@arm.com; Michal
> > Simek <michals@xilinx.com>; linux-media@vger.kernel.org;
> > devicetree@vger.kernel.org; hans.verkuil@cisco.com; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Dinesh Kumar
> > <dineshk@xilinx.com>; Sandip Kothari <sandipk@xilinx.com>
> > Subject: Re: [PATCH v6 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
> > CSI-2 Rx Subsystem
> >
> > EXTERNAL EMAIL
> >
> > Hi Vishal,
> >
> > Thanks for the update. This looks pretty good, please see a few comments
> > below.
> >
> > On Tue, Mar 12, 2019 at 10:05:29AM +0530, Vishal Sagar wrote:
> > > Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> > >
> > > The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> > > DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> > >
> > > Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> > > Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > ---
> > > v6
> > > - Added "control" after V4L2_CID_XILINX_MIPICSISS_ACT_LANES as suggested
> > by Luca
> > > - Added reviewed by Rob Herring
> > >
> > > v5
> > > - Incorporated comments by Luca Cersoli
> > > - Removed DPHY clock from description and example
> > > - Removed bayer pattern from device tree MIPI CSI IP
> > >   doesn't deal with bayer pattern.
> > >
> > > v4
> > > - Added reviewed by Hyun Kwon
> > >
> > > v3
> > > - removed interrupt parent as suggested by Rob
> > > - removed dphy clock
> > > - moved vfb to optional properties
> > > - Added required and optional port properties section
> > > - Added endpoint property section
> > >
> > > v2
> > > - updated the compatible string to latest version supported
> > > - removed DPHY related parameters
> > > - added CSI v2.0 related property (including VCX for supporting upto 16
> > >   virtual channels).
> > > - modified csi-pxl-format from string to unsigned int type where the value
> > >   is as per the CSI specification
> > > - Defined port 0 and port 1 as sink and source ports.
> > > - Removed max-lanes property as suggested by Rob and Sakari
> > >
> > >  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 118
> > +++++++++++++++++++++
> > >  1 file changed, 118 insertions(+)
> > >  create mode 100644
> > Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > >
> > > diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > > new file mode 100644
> > > index 0000000..5b8170f
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> > > @@ -0,0 +1,118 @@
> > > +Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
> > > +--------------------------------------------------------
> > > +
> > > +The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traffic
> > > +from compliant camera sensors and send the output as AXI4 Stream video
> > data
> > > +for image processing.
> > > +
> > > +The subsystem consists of a MIPI DPHY in slave mode which captures the
> > > +data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
> > > +packet data. The optional Video Format Bridge (VFB) converts this data to
> > > +AXI4 Stream video data.
> > > +
> > > +For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Subsystem.
> > > +
> > > +Required properties:
> > > +--------------------
> > > +- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
> > > +- reg: Physical base address and length of the registers set for the device.
> > > +- interrupts: Property with a value describing the interrupt number.
> > > +- clocks: List of phandles to AXI Lite and Video clocks.
> > > +- clock-names: Must contain "lite_aclk" and "video_aclk" in the same order
> > > +  as clocks listed in clocks property.
> > > +- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw design.
> > > +  Packets other than this data type (except for RAW8 and User defined data
> > > +  types) will be filtered out. Possible values are as below -
> > > +  0x1E - YUV4228B
> > > +  0x1F - YUV42210B
> > > +  0x20 - RGB444
> > > +  0x21 - RGB555
> > > +  0x22 - RGB565
> > > +  0x23 - RGB666
> > > +  0x24 - RGB888
> > > +  0x28 - RAW6
> > > +  0x29 - RAW7
> > > +  0x2A - RAW8
> > > +  0x2B - RAW10
> > > +  0x2C - RAW12
> > > +  0x2D - RAW14
> > > +  0x2E - RAW16
> > > +  0x2F - RAW20
> > > +
> > > +
> > > +Optional properties:
> > > +--------------------
> > > +- xlnx,vfb: This is present when Video Format Bridge is enabled.
> > > +  Without this property the driver won't be loaded as IP won't be able to
> > generate
> > > +  media bus format compliant stream output.
> >
> > What's the use case for this? I read in an earlier thread that this is
> > used to prevent the driver from loading.
> >
>
> This property ensures that the data being sent on the media bus complies with
> existing formats. If Video Format Bridge (VFB) is disabled, then the data is sent on the bus in the
> same way as it is received. For e.g. with RAW10 with bus width of 32 bits, the first clock
> cycle will contain the MSB 8bits of 4 pixels.
> The lower 2 bits of each pixel will be sent on the next clock.
>
> When VFB is enabled, the input data stream is processed based on the CSI Data Type and
> Pixels per clock selected in design and then sent out.
> For e.g. for RAW10 with 2 pixels per clock and VFB enabled, the bus will have pixel 0 data
> on 9:0 and pixel 1 data on 19:10. Upper bits on the bus will be zeros.
>
> > > +- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
> > > +- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
> > > +  only 4. This is present only if xlnx,en-csi-v2-0 is present.
> > > +- xlnx,en-active-lanes: present if the number of active lanes can be
> > > +  reconfigured at runtime in the Protocol Configuration Register.
> > > +  If present, the V4L2_CID_XILINX_MIPICSISS_ACT_LANES control is added.
> > > +  Otherwise all lanes, as set in IP configuration, are always active.
> >
> > The bindings document hardware, therefore a V4L2 control name doesn't
> > belong here.
> >
> Ok. I will remove this and revert to original description as below -
>
> xlnx,en-active-lanes: present if the number of active lanes can be
> re-configured at runtime in the Protocol Configuration Register
>
> > If you want to set the number of lanes at runtime, the frame descriptors
> > are probably the best way to do that. The patchset will be merged in the
> > near future. Jacopo sent the last iteration of it recently. I'd leave that
> > feature out for now though: few transmitter drivers support the feature
> > (using an old API).
> >
>
> I had a look at Jacopo's patch set
>
> [PATCH v3 15/31] v4l: Add bus type to frame descriptors
> [PATCH v3 16/31] v4l: Add CSI-2 bus configuration to frame descriptors
> [PATCH v3 17/31] v4l: Add stream to frame descriptor
> [PATCH v3 29/31] rcar-csi2: use frame description information to configure CSI-2 bus
>
> +/**
> + * struct v4l2_mbus_frame_desc_entry_csi2
> + *
> + * @channel: CSI-2 virtual channel
> + * @data_type: CSI-2 data type ID
> + */
> +struct v4l2_mbus_frame_desc_entry_csi2 {
> +       u8 channel;
> +       u8 data_type;
> +};
>
> It looks like this patch set is trying to add support for virtual channel number and data type association.
> This is different from controlling number of lanes on which CSI Rx will receive data.
> Please correct my understanding if not right.

That part is indeed meant to add support for VC, but on top of that
series I recently sent:
"[RFC 0/5] media: Implement negotiation of CSI-2 data lanes"
where support for the negotiation of CSI-2 data lanes is implemented.

As you can see it's still RFC, so I would apreciate any input you
might have :)

Thanks
  j


>
> > > +
> > > +Ports
> > > +-----
> > > +The device node shall contain two 'port' child nodes as defined in
> > > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > > +
> > > +The port@0 is a sink port and shall connect to CSI2 source like camera.
> > > +It must have the data-lanes property.
> > > +
> > > +The port@1 is a source port and can be connected to any video processing IP
> > > +which can work with AXI4 Stream data.
> > > +
> > > +Required port properties:
> > > +--------------------
> > > +- reg: 0 - for sink port.
> > > +       1 - for source port.
> > > +
> > > +Optional endpoint property:
> > > +---------------------------
> > > +- data-lanes: specifies MIPI CSI-2 data lanes as covered in video-
> > interfaces.txt.
> > > +  This should be in the sink port endpoint which connects to MIPI CSI2 source
> > > +  like sensor. The possible values are:
> > > +  1       - For 1 lane enabled in IP.
> > > +  1 2     - For 2 lanes enabled in IP.
> > > +  1 2 3   - For 3 lanes enabled in IP.
> > > +  1 2 3 4 - For 4 lanes enabled in IP.
> > > +
> > > +Example:
> > > +
> > > +     csiss_1: csiss@a0020000 {
> >
> > The node name should be generic, a Cadence device uses csi2rx which seems
> > like a good fit here, too.
> >
>
> Ok. I will change it to xcsi2rxss_1:csi2rx@a0020000.
>
> > > +             compatible = "xlnx,mipi-csi2-rx-subsystem-4.0";
> > > +             reg = <0x0 0xa0020000 0x0 0x10000>;
> > > +             interrupt-parent = <&gic>;
> > > +             interrupts = <0 95 4>;
> > > +             xlnx,csi-pxl-format = <0x2a>;
> > > +             xlnx,vfb;
> > > +             xlnx,en-active-lanes;
> > > +             xlnx,en-csi-v2-0;
> > > +             xlnx,en-vcx;
> > > +             clock-names = "lite_aclk", "video_aclk";
> > > +             clocks = <&misc_clk_0>, <&misc_clk_1>;
> > > +
> > > +             ports {
> > > +                     #address-cells = <1>;
> > > +                     #size-cells = <0>;
> > > +
> > > +                     port@0 {
> > > +                             /* Sink port */
> > > +                             reg = <0>;
> > > +                             csiss_in: endpoint {
> > > +                                     data-lanes = <1 2 3 4>;
> > > +                                     /* MIPI CSI2 Camera handle */
> > > +                                     remote-endpoint = <&camera_out>;
> > > +                             };
> > > +                     };
> > > +                     port@1 {
> > > +                             /* Source port */
> > > +                             reg = <1>;
> > > +                             csiss_out: endpoint {
> > > +                                     remote-endpoint = <&vproc_in>;
> > > +                             };
> > > +                     };
> > > +             };
> > > +     };
> >
> > --
> > Kind regards,
> >
> > Sakari Ailus
> > sakari.ailus@linux.intel.com
>
> Regards
> Vishal Sagar

--qjobgvtznmmsbbct
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyVBx4ACgkQcjQGjxah
VjwsqhAAr80GYETTNrUgRV2HLKPbrzyYHEnMFe76iSPHZN5hzeIfNWP8FouYBW5F
MhaNKRDLc4FpaGZCBu1EBirNPUsXr44658PZzl7VJhSVs0v3Jm6v4ueui6aVS8vd
fnJvyW4br+H9880RKuAQQw6mCsrAg0hNaWrWZibgd+aB1dTpRbwNUonlim54/U2P
4PJHjkGeU5gm0jbAa9APl1n6Cty0SyJ7IO5L/Mv6WyJG87PxfcnHA3BjRQdJttxb
naAv/+V2pf6/vqUjUsGKFdufENrs+rDTMuPD+SKFXqUq+doyu4FsCR0TglVHt0ot
2NYXVZ7aJ8KWYRsubIkEF/aX9DsoEnAeU6NzZaHRHf8OacHYuiNxpmV//TJKubTB
3QTNPsb4XfiWk0oVOl27Nxbt2mQJ/eYhXPm1bEtFliT9iZfxJc4C7W7gjneIBmib
MoMSe1/nxiHv9I8gQoAalZOrESmx6iU2fHITUDbnsC1coPkQ+6jyx7+tmeICGzI/
tbjPnXfwTSKkX4DXnLBvTUTALqKW0xIylC2TUBKZNGgRb3F3zr4I77XmfFPoEt15
Q8svllnYfQ+/B9cTawXi7OR5Zn4Et1YraZ48YqwjLZ1uA3ameV7UEvH/ywpzN/7o
FEHyK1GBLk9dfQGvkPC95Um0ggMZj0ffM/KnE8OU0tBCYxpAgyM=
=MVZ8
-----END PGP SIGNATURE-----

--qjobgvtznmmsbbct--
