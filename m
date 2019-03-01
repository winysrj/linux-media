Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FEDC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 10:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29103218AE
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 10:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfCAKwm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 05:52:42 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60575 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfCAKwm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 05:52:42 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gzfmO-0002Aa-20; Fri, 01 Mar 2019 11:52:36 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gzfmN-0000jo-Gc; Fri, 01 Mar 2019 11:52:35 +0100
Date:   Fri, 1 Mar 2019 11:52:35 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:37:22 up 41 days, 15:19, 49 users,  load average: 0.11, 0.08,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 19-02-18 12:03, Sakari Ailus wrote:
> Hi Marco,
> 
> My apologies for reviewing this so late. You've received good comments
> already. I have a few more.

Thanks for your review for the other patches as well =) Sorry for my
delayed response.

> On Tue, Dec 18, 2018 at 03:12:38PM +0100, Marco Felsch wrote:
> > Add corresponding dt-bindings for the Toshiba tc358746 device.
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
> >  1 file changed, 80 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > new file mode 100644
> > index 000000000000..499733df744a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > @@ -0,0 +1,80 @@
> > +* Toshiba TC358746 Parallel to MIPI CSI2-TX or MIPI CSI2-RX to Parallel Bridge
> > +
> > +The Toshiba TC358746 is a bridge that converts a Parallel-in stream to MIPI CSI-2 TX
> > +or a MIPI CSI-2 RX stream into a Parallel-out. It is programmable through I2C.
> 
> This is interesting. The driver somehow needs to figure out the direction
> of the data flow if it does not originate from DT. I guess it shouldn't as
> it's not the property of an individual device, albeit in practice in all
> hardware I've seen the direction of the pipeline is determinable and this
> is visible in the kAPI as well. So I'm suggesting no changes due to this in
> bindings, likely we'll need to address it somehow elsewhere going forward.

What did you mean with "... and this is visible in the kAPI as well"?
I'm relative new in the linux-media world but I never saw a device which
supports two directions. Our customer which uses that chip use it
only in parallel-in/csi-out mode. To be flexible the switching should be
done by a subdev-ioctl but it is also reasonable to define a default value
within the DT.

> > +
> > +Required Properties:
> > +
> > +- compatible: should be "toshiba,tc358746"
> > +- reg: should be <0x0e>
> > +- clocks: should contain a phandle link to the reference clock source
> > +- clock-names: the clock input is named "refclk".
> > +
> > +Optional Properties:
> > +
> > +- reset-gpios: gpio phandle GPIO connected to the reset pin
> > +
> > +Parallel Endpoint:
> > +
> > +Required Properties:
> 
> It'd be nice if the relation between these sections would be somehow
> apparent. E.g. using different underlining, such as in
> Documentation/devicetree/bindings/media/ti,omap3isp.txt .

Thats a really good example thanks.

> 
> > +
> > +- reg: should be <0>
> > +- bus-width: the data bus width e.g. <8> for eight bit bus, or <16>
> > +	     for sixteen bit wide bus.
> > +
> > +MIPI CSI-2 Endpoint:
> > +
> > +Required Properties:
> > +
> > +- reg: should be <1>
> > +- data-lanes: should be <1 2 3 4> for four-lane operation,
> > +	      or <1 2> for two-lane operation
> > +- clock-lanes: should be <0>
> > +- link-frequencies: List of allowed link frequencies in Hz. Each frequency is
> > +		    expressed as a 64-bit big-endian integer. The frequency
> > +		    is half of the bps per lane due to DDR transmission.
> > +
> > +Optional Properties:
> > +
> > +- clock-noncontinuous: Presence of this boolean property decides whether the
> > +		       MIPI CSI-2 clock is continuous or non-continuous.
> > +
> > +For further information on the endpoint node properties, see
> > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +
> > +Example:
> > +
> > +&i2c {
> > +	tc358746: tc358746@0e {
> 
> The node name should be a generic name of the type of the device, not the
> name of the specific device as such. A similar Cadence device uses
> "csi-bridge".

Okay, I will change that.

> 
> > +		reg = <0x0e>;
> > +		compatible = "toshiba,tc358746";
> > +		pinctrl-names = "default";
> > +		clocks = <&clk_cam_ref>;
> > +		clock-names = "refclk";
> > +		reset-gpios = <&gpio3 2 GPIO_ACTIVE_LOW>;
> > +
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +
> > +		port@0 {
> > +			reg = <0>;
> > +
> > +			tc358746_parallel_in: endpoint {
> > +				bus-width = <8>;
> > +				remote-endpoint = <&micron_parallel_out>;
> > +			};
> > +		};
> > +
> > +		port@1 {
> > +			reg = <1>;
> > +
> > +			tc358746_mipi2_out: endpoint {
> > +				remote-endpoint = <&mipi_csi2_in>;
> > +				data-lanes = <1 2>;
> > +				clock-lanes = <0>;
> > +				clock-noncontinuous;
> > +				link-frequencies = /bits/ 64 <216000000>;
> > +			};
> > +		};
> > +	};
> > +};
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
