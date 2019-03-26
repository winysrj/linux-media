Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1B1C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F27620856
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfCZNoM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:44:12 -0400
Received: from retiisi.org.uk ([95.216.213.190]:43012 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbfCZNoL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 09:44:11 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 1EC8C634C7B;
        Tue, 26 Mar 2019 15:44:05 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1h8mN3-0000Kn-Ph; Tue, 26 Mar 2019 15:44:05 +0200
Date:   Tue, 26 Mar 2019 15:44:05 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Mickael GUENE <mickael.guene@st.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: Document MIPID02 bindings
Message-ID: <20190326134405.v6ipjsl35ql67qil@valkosipuli.retiisi.org.uk>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-2-git-send-email-mickael.guene@st.com>
 <20190326121731.m7z5o2jbzlfxalu6@valkosipuli.retiisi.org.uk>
 <7a62fee6-5792-0390-fd6f-f34aca0dc759@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a62fee6-5792-0390-fd6f-f34aca0dc759@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mickael,

On Tue, Mar 26, 2019 at 01:40:18PM +0000, Mickael GUENE wrote:
> Hi Sakari,
> 
> On 3/26/19 13:17, Sakari Ailus wrote:
> > Hi Mickael,
> > 
> > On Tue, Mar 26, 2019 at 11:03:39AM +0100, Mickael Guene wrote:
> >> This adds documentation of device tree for MIPID02 CSI-2 to PARALLEL
> >> bridge.
> >>
> >> Signed-off-by: Mickael Guene <mickael.guene@st.com>
> >> ---
> >>
> >> Changes in v3: None
> >> Changes in v2:
> >> - Add precision about first CSI-2 port data rate
> >> - Document endpoints supported properties
> >> - Rename 'mipid02@14' into generic 'csi2rx@14' in example
> >>
> >>  .../bindings/media/i2c/st,st-mipid02.txt           | 83 ++++++++++++++++++++++
> >>  MAINTAINERS                                        |  7 ++
> >>  2 files changed, 90 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
> >> new file mode 100644
> >> index 0000000..dfeab45
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
> >> @@ -0,0 +1,83 @@
> >> +STMicroelectronics MIPID02 CSI-2 to PARALLEL bridge
> >> +
> >> +MIPID02 has two CSI-2 input ports, only one of those ports can be active at a
> >> +time. Active port input stream will be de-serialized and its content outputted
> >> +through PARALLEL output port.
> >> +CSI-2 first input port is a dual lane 800Mbps per lane whereas CSI-2 second
> >> +input port is a single lane 800Mbps. Both ports support clock and data lane
> >> +polarity swap. First port also supports data lane swap.
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
> >> +
> >> +Endpoint node optional properties for CSI-2 connection are:
> >> +- bus-type: if present should be 4 - MIPI CSI-2 D-PHY.
> > 
> > You can drop this IMO --- there's just a single valid value so the driver
> > may know that.
> > 
> ok
> >> +- clock-lanes: should be set to <0> if present (clock lane on hardware lane 0).
> > 
> > And please omit this, too, if the clock lane is always 0. Please update the
> > example, too. The driver doesn't need to check that either IMO, but up to
> > you.
> > 
> ok I will drop it from device tree documentation but I will keep driver check.
> I will also make data-lanes mandatory.
> >> +- data-lanes: if present should be <1> for Port 1. for Port 0 dual-lane
> >> +operation should be <1 2> or <2 1>. For Port 0 single-lane operation should be
> >> +<1> or <2>.
> >> +- lane-polarities: any lane can be inverted.
> >> +
> >> +Endpoint node optional properties for PARALLEL connection are:
> >> +- bus-type: if present should be 5 - Parallel.
> > 
> > This, too, can be omitted.
> > 
> ok
> >> +- bus-width: shall be set to <6>, <7>, <8>, <10> or <12>.
> >> +- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> >> +- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> > 
> > If these are optional, what are the defaults? IMO you could make them
> > mandatory as well.
> > 
> I will make bus-width mandatory
> hsync-active and vsync-active will stay optional with LOW being the default.

The above seems good to me. Thanks!

-- 
Sakari Ailus
