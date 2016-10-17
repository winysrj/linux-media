Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56816 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757570AbcJQMMn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 08:12:43 -0400
Message-ID: <1476706359.2488.13.camel@pengutronix.de>
Subject: Re: [PATCH v2 08/21] [media] imx: Add i.MX IPUv3 capture driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jack Mitchell <ml@embed.me.uk>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Mon, 17 Oct 2016 14:12:39 +0200
In-Reply-To: <a5a06050-f6e7-2031-4b14-312f085c5644@embed.me.uk>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
         <1476466481-24030-9-git-send-email-p.zabel@pengutronix.de>
         <a5a06050-f6e7-2031-4b14-312f085c5644@embed.me.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jack,

Am Montag, den 17.10.2016, 12:32 +0100 schrieb Jack Mitchell:
> Hi Philipp,
> 
> I'm looking at how I would enable a parallel greyscale camera using this 
> set of drivers and am a little bit confused. Do you have an example 
> somewhere of a devicetree with an input node.

In your board device tree it should look somewhat like this:

&i2c1 {
	sensor@48 {
		compatible = "aptina,mt9v032m";
		/* ... */

		port {
			cam_out: endpoint {
				remote-endpoint = <&csi_in>;
			}
		};
	};
};

/*
 * This is the input port node corresponding to the 'CSI0' pad group,
 * not necessarily the CSI0 port of IPU1 or IPU2. On i.MX6Q it's port@1
 * of the mipi_ipu1_mux, on i.MX6DL it's port@4 of the ipu_csi0_mux,
 * the csi0 label is added in patch 13/21.
 */
&csi0 {
	#address-cells = <1>;
	#size-cells = <0>;

	csi_in: endpoint@0 {
		bus-width = <8>;
		data-shift = <12>;
		hsync-active = <1>;
		vsync-active = <1>;
		pclk-sample = <1>;
		remote-endpoint = <&cam_out>;
	};
};

>  I also have a further note below:
[...]
> > +	if (raw && priv->smfc) {
> 
> How does this ever get used? If I were to set 1X8 greyscale it wouldn't 
> ever take this path, correct?

Thank you, that is a leftover from stripping down the driver to the
basics. I'll test with a grayscale camera and fix this in the next
version.

regards
Philipp

