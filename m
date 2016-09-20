Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:60250 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753395AbcITJZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 05:25:49 -0400
Date: Tue, 20 Sep 2016 11:25:43 +0200
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk,
        Rob Taylor <rob.taylor@codethink.co.uk>
Subject: Re: [PATCH 1/2] ARM: dts: lager: Add entries for VIN HDMI input
 support
Message-ID: <20160920092543.GE30286@verge.net.au>
References: <20160916130909.21225-1-ulrich.hecht+renesas@gmail.com>
 <20160916130909.21225-2-ulrich.hecht+renesas@gmail.com>
 <fa19d487-941b-9b00-c280-e4acabf29615@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa19d487-941b-9b00-c280-e4acabf29615@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 17, 2016 at 01:25:47PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 9/16/2016 4:09 PM, Ulrich Hecht wrote:
> 
> >From: William Towle <william.towle@codethink.co.uk>
> >
> >Add DT entries for vin0, vin0_pins, and adv7612.
> >
> >Sets the 'default-input' property for ADV7612, enabling image and video
> >capture without the need to have userspace specifying routing.
> >
> >Signed-off-by: William Towle <william.towle@codethink.co.uk>
> >Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> >[uli: added interrupt, renamed endpoint, merged default-input]
> >Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> >---
> > arch/arm/boot/dts/r8a7790-lager.dts | 39 +++++++++++++++++++++++++++++++++++++
> > 1 file changed, 39 insertions(+)
> >
> >diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> >index 52b56fc..fc9d129 100644
> >--- a/arch/arm/boot/dts/r8a7790-lager.dts
> >+++ b/arch/arm/boot/dts/r8a7790-lager.dts
> [...]
> >@@ -722,6 +742,25 @@
> > 	status = "okay";
> > };
> >
> >+/* HDMI video input */
> >+&vin0 {
> >+	pinctrl-0 = <&vin0_pins>;
> >+	pinctrl-names = "default";
> >+
> >+	status = "ok";
> 
>    Should be "okay", although "ok" is also valid.

Ulrich, could you fix this and repost?
