Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44686 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaFLRNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:13:17 -0400
Message-ID: <1402593194.3444.137.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 32/43] ARM: dts: imx: sabrelite: add video capture ports
 and endpoints
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 12 Jun 2014 19:13:14 +0200
In-Reply-To: <1402486732.4107.128.camel@paszta.hi.pengutronix.de>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-33-git-send-email-steve_longerbeam@mentor.com>
	 <1402486732.4107.128.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 11.06.2014, 13:38 +0200 schrieb Philipp Zabel:
> Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> [...]
> > +&ipu1 {
> > +	status = "okay";
> > +
> > +	v4l2-capture {
> > +		compatible = "fsl,imx6-v4l2-capture";
> 
> I'm not happy with adding the simple-bus compatible to the ipu
> device tree node just to instantiate a virtual subdevice. See
> my comment in the following mail. I think it would be better to
> create this platform device from code, not from the device tree
> if something is connected to ipu port@0 or port@1, see below.
> 
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		status = "okay";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <
> > +			&pinctrl_ipu1_csi0_1
> > +			&pinctrl_ipu1_csi0_data_en
> > +		>;
> > +
> > +		/* CSI0 */
> > +		port@0 {
> 
> That port really is a property of the IPU itself. I have left
> space for ports 0 and 1 when specifying the IPU output interfaces
> as port 2 (DI0) and 3 (DI1).

Shawn Guo's for-next tree contains the CSI ports in
1fbf4ad8e1983732aa6a1de10da0bfcc7384f626

regards
Philipp

