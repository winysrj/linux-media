Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:59420 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755724AbeDXIYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:24:00 -0400
Date: Tue, 24 Apr 2018 10:23:56 +0200
From: Simon Horman <horms@verge.net.au>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/10] ARM: dts: r7s72100: Add Capture Engine Unit
 (CEU)
Message-ID: <20180424082355.y2cnfkqa7bj4fpy4@verge.net.au>
References: <1519235284-32286-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519235284-32286-5-git-send-email-jacopo+renesas@jmondi.org>
 <20180221182918.fbxnhdl4r4y3ejfj@verge.net.au>
 <20180423152143.GH3999@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423152143.GH3999@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 05:21:43PM +0200, jacopo mondi wrote:
> Hi Simon,
> 
> On Wed, Feb 21, 2018 at 07:29:18PM +0100, Simon Horman wrote:
> > On Wed, Feb 21, 2018 at 06:47:58PM +0100, Jacopo Mondi wrote:
> > > Add Capture Engine Unit (CEU) node to device tree.
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > This patch depends on the binding for "renesas,r7s72100-ceu".
> > Please repost or otherwise ping me once that dependency has been accepted.
> 
> Bindings for the CEU interface went in v4.17-rc1.
> 
> Could you please resurect this patch?

Sure, I took the liberty of "rebasing" it to preserve the new node-order
of r7s72100.dtsi. The result is as follows:

From: Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH] ARM: dts: r7s72100: Add Capture Engine Unit (CEU)

Add Capture Engine Unit (CEU) node to device tree.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
[simon: rebased]
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm/boot/dts/r7s72100.dtsi | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
index ecf9516bcda8..4a1aade0e751 100644
--- a/arch/arm/boot/dts/r7s72100.dtsi
+++ b/arch/arm/boot/dts/r7s72100.dtsi
@@ -375,6 +375,15 @@
 			status = "disabled";
 		};
 
+		ceu: camera@e8210000 {
+			reg = <0xe8210000 0x3000>;
+			compatible = "renesas,r7s72100-ceu";
+			interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&mstp6_clks R7S72100_CLK_CEU>;
+			power-domains = <&cpg_clocks>;
+			status = "disabled";
+		};
+
 		wdt: watchdog@fcfe0000 {
 			compatible = "renesas,r7s72100-wdt", "renesas,rza-wdt";
 			reg = <0xfcfe0000 0x6>;
@@ -429,9 +438,9 @@
 			#clock-cells = <1>;
 			compatible = "renesas,r7s72100-mstp-clocks", "renesas,cpg-mstp-clocks";
 			reg = <0xfcfe042c 4>;
-			clocks = <&p0_clk>;
-			clock-indices = <R7S72100_CLK_RTC>;
-			clock-output-names = "rtc";
+			clocks = <&b_clk>, <&p0_clk>;
+			clock-indices = <R7S72100_CLK_CEU R7S72100_CLK_RTC>;
+			clock-output-names = "ceu", "rtc";
 		};
 
 		mstp7_clks: mstp7_clks@fcfe0430 {
-- 
2.11.0
