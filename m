Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856B1C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D0232083D
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfCRIuR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 04:50:17 -0400
Received: from retiisi.org.uk ([95.216.213.190]:49236 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726449AbfCRIuR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 04:50:17 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D9B2D634C7F;
        Mon, 18 Mar 2019 10:48:24 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1h5nwX-0004DO-F4; Mon, 18 Mar 2019 10:48:25 +0200
Date:   Mon, 18 Mar 2019 10:48:25 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Mickael GUENE <mickael.guene@st.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v1 1/3] dt-bindings: Document MIPID02 bindings
Message-ID: <20190318084825.3hpejk5xg2xt2h4b@valkosipuli.retiisi.org.uk>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-2-git-send-email-mickael.guene@st.com>
 <20190316214649.co63p5arhiwbuv3g@valkosipuli.retiisi.org.uk>
 <b238948a-4b08-4fb8-c955-d071bbcd3d2d@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b238948a-4b08-4fb8-c955-d071bbcd3d2d@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 18, 2019 at 08:28:36AM +0000, Mickael GUENE wrote:
> Hi Sakari,
> 
> Thanks for your review. Find my comments below.
> 
> On 3/16/19 22:46, Sakari Ailus wrote:
> > Hi Mickael,
> > 
> > Thanks for the patchset.
> > 
> > On Tue, Mar 12, 2019 at 07:44:03AM +0100, Mickael Guene wrote:
> >> This adds documentation of device tree for MIPID02 CSI-2 to PARALLEL
> >> bridge.
> >>
> >> Signed-off-by: Mickael Guene <mickael.guene@st.com>
> >> ---
> >>
> >>  .../bindings/media/i2c/st,st-mipid02.txt           | 69 ++++++++++++++++++++++
> >>  1 file changed, 69 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
> >> new file mode 100644
> >> index 0000000..a1855da
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
> >> @@ -0,0 +1,69 @@
> >> +STMicroelectronics MIPID02 CSI-2 to PARALLEL bridge
> >> +
> >> +MIPID02 has two CSI-2 input ports, only one of those ports can be active at a
> >> +time. Active port input stream will be de-serialized and its content outputted
> >> +through PARALLEL output port.
> >> +CSI-2 first input port is a dual lane 800Mbps whereas CSI-2 second input port is
> > 
> > 800 Mbps per lane (or total)?
> > 
> 800 Mbps per lane. I will document it.
> >> +a single lane 800Mbps. Both ports support clock and data lane polarity swap.
> >> +First port also supports data lane swap.
> >> +PARALLEL output port has a maximum width of 12 bits.
> >> +Supported formats are RAW6, RAW7, RAW8, RAW10, RAW12, RGB565, RGB888, RGB444,
> >> +YUV420 8-bit, YUV422 8-bit and YUV420 10-bit.
> >> +
> >> +Required Properties:
> >> +- compatible: should be "st,st-mipid02"
> >> +- clocks: reference to the xclk input clock.
> >> +- clock-names: should be "xclk".
> >> +- VDDE-supply: sensor digital IO supply. Must be 1.8 volts.
> >> +- VDDIN-supply: sensor internal regulator supply. Must be 1.8 volts.
> > 
> > Perhaps Rob can confirm, but AFAIR the custom is to use lower case letters.
> > 
>  It seems there is a 50-50 ratio between upper and lower case usage in
> Documentation/devicetree/bindings/media/i2. I will wait Rob's answer to change
> it or not.
> >> +
> >> +Optional Properties:
> >> +- reset-gpios: reference to the GPIO connected to the xsdn pin, if any.
> >> +	       This is an active low signal to the mipid02.
> >> +
> >> +Required subnodes:
> >> +  - ports: A ports node with one port child node per device input and output
> >> +	   port, in accordance with the video interface bindings defined in
> >> +	   Documentation/devicetree/bindings/media/video-interfaces.txt. The
> >> +	   port nodes are numbered as follows:
> >> +
> >> +	   Port Description
> >> +	   -----------------------------
> >> +	   0    CSI-2 first input port
> >> +	   1    CSI-2 second input port
> >> +	   2    PARALLEL output
> > 
> > Please document which endpoint properties are relevant. From the above
> > description I'd presume this to be at least clock-lanes (1st input),
> > data-lanes, lane-polarities (for CSI-2) as well as bus-width for the
> > parallel bus.
> > 
> ok. I will add documentation.
> >> +
> >> +Example:
> >> +
> >> +mipid02: mipid02@14 {
> > 
> > The node should be a generic name. "csi2rx" is used by a few devices now.
> >
>  If I understand you well, you would prefer:
> csi2rx: mipid02@14 {
>  I show no usage of csi2rx node naming except for MIPI-CSI2 RX controller.

The other way around. :)

The label can be more or less anything AFAIK.

-- 
Sakari Ailus
