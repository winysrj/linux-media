Return-Path: <SRS0=zy/9=RN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAF9C43381
	for <linux-media@archiver.kernel.org>; Sun, 10 Mar 2019 21:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97AAD20850
	for <linux-media@archiver.kernel.org>; Sun, 10 Mar 2019 21:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="oZR+S+zg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfCJVsn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 10 Mar 2019 17:48:43 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:39294 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfCJVsn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Mar 2019 17:48:43 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C068D9B7;
        Sun, 10 Mar 2019 22:48:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552254520;
        bh=DkrBkV/hnyYOesLgFgWGeT14u+wMsmQl0yTjmUtMVi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZR+S+zggsSvbelL7VRzXObDkOs3EM00gN2z9+Wue6uJ4o3vSgi+Knsw7ePhfTKsA
         x1EYLiNzd4x6oi42AXkYMAXGcE1DlSC417jlb2569Zx46FgIwej3U47R22/wO1mGad
         mnXkoDVr0DmUlHJjTM2GbMafcLKuEWKN941kvHok=
Date:   Sun, 10 Mar 2019 23:48:34 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Rui Miguel Silva <rui.silva@linaro.org>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v4 06/12] media: dt-bindings: add bindings for i.MX7
 media driver
Message-ID: <20190310214834.GB7578@pendragon.ideasonboard.com>
References: <20180517125033.18050-1-rui.silva@linaro.org>
 <20180517125033.18050-7-rui.silva@linaro.org>
 <20180518065824.csio2fgwsxo2g2ow@valkosipuli.retiisi.org.uk>
 <m3tvr5xt9t.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3tvr5xt9t.fsf@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rui,

On Fri, May 18, 2018 at 09:27:58AM +0100, Rui Miguel Silva wrote:
> Hi Sakari,
> Thanks for the review.
> On Fri 18 May 2018 at 06:58, Sakari Ailus wrote:
> > On Thu, May 17, 2018 at 01:50:27PM +0100, Rui Miguel Silva wrote:
> >> Add bindings documentation for i.MX7 media drivers.
> >> 
> >> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> >> ---
> >>  .../devicetree/bindings/media/imx7.txt        | 145 
> >>  ++++++++++++++++++
> >>  1 file changed, 145 insertions(+)
> >>  create mode 100644 
> >>  Documentation/devicetree/bindings/media/imx7.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/imx7.txt 
> >> b/Documentation/devicetree/bindings/media/imx7.txt
> >> new file mode 100644
> >> index 000000000000..161cff8e6442
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/imx7.txt
> >> @@ -0,0 +1,145 @@
> >> +Freescale i.MX7 Media Video Device
> >> +==================================
> >> +
> >> +Video Media Controller node
> >> +---------------------------
> >
> > Note that DT bindings document the hardware, they are as such 
> > not Linux dependent.
> 
> This was removed in this series, however I removed it in the wrong 
> patch, If you see patch 11/12 you will see this being removed. I will
> fix this in v5. Thanks for notice it.
> 
> >> +
> >> +This is the media controller node for video capture support. 
> >> It is a
> >> +virtual device that lists the camera serial interface nodes 
> >> that the
> >> +media device will control.
> >
> > Ditto.
> >
> >> +
> >> +Required properties:
> >> +- compatible : "fsl,imx7-capture-subsystem";
> >> +- ports      : Should contain a list of phandles pointing to 
> >> camera
> >> +		sensor interface port of CSI
> >> +
> >> +example:
> >> +
> >> +capture-subsystem {
> >
> > What's the purpose of this node, if you only refer to another 
> > device? This one rather does not look like a real device at all.
> >
> >> +	compatible = "fsl,imx7-capture-subsystem";
> >> +	ports = <&csi>;
> >> +};
> >> +
> >> +
> >> +mipi_csi2 node
> >> +--------------
> >> +
> >> +This is the device node for the MIPI CSI-2 receiver core in 
> >> i.MX7 SoC. It is
> >> +compatible with previous version of Samsung D-phy.
> >> +
> >> +Required properties:
> >> +
> >> +- compatible    : "fsl,imx7-mipi-csi2";
> >> +- reg           : base address and length of the register set 
> >> for the device;
> >> +- interrupts    : should contain MIPI CSIS interrupt;
> >> +- clocks        : list of clock specifiers, see
> >> + 
> >> Documentation/devicetree/bindings/clock/clock-bindings.txt for 
> >> details;
> >> +- clock-names   : must contain "pclk", "wrap" and "phy" 
> >> entries, matching
> >> +                  entries in the clock property;
> >> +- power-domains : a phandle to the power domain, see
> >> + 
> >> Documentation/devicetree/bindings/power/power_domain.txt for 
> >> details.
> >> +- reset-names   : should include following entry "mrst";
> >> +- resets        : a list of phandle, should contain reset 
> >> entry of
> >> +                  reset-names;
> >> +- phy-supply    : from the generic phy bindings, a phandle to 
> >> a regulator that
> >> +	          provides power to MIPI CSIS core;
> >> +- bus-width     : maximum number of data lanes supported (SoC 
> >> specific);
> >> +
> >> +Optional properties:
> >> +
> >> +- clock-frequency : The IP's main (system bus) clock frequency 
> >> in Hz, default
> >> +		    value when this property is not specified is 
> >> 166 MHz;
> >> +
> >> +port node
> >> +---------
> >> +
> >> +- reg		  : (required) can take the values 0 or 1, 
> >> where 0 is the
> >> +                     related sink port and port 1 should be 
> >> the source one;
> >> +
> >> +endpoint node
> >> +-------------
> >> +
> >> +- data-lanes    : (required) an array specifying active 
> >> physical MIPI-CSI2
> >> +		    data input lanes and their mapping to logical 
> >> lanes; the
> >> +		    array's content is unused, only its length is 
> >> meaningful;
> >> +
> >> +- fsl,csis-hs-settle : (optional) differential receiver 
> >> (HS-RX) settle time;
> >
> > Could you calculate this, as other drivers do? It probably 
> > changes
> > depending on the device runtime configuration.
> 
> The only reference to possible values to this parameter is given 
> by table in [0], can you point me out the formula for imx7 in the
> documentation?
> 
> [0] https://community.nxp.com/thread/463777

Can't you use the values from that table ? :-) You can get the link
speed by querying the connected subdev and reading its
V4L2_CID_PIXEL_RATE control.

-- 
Regards,

Laurent Pinchart
