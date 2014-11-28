Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaK1Nhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 08:37:50 -0500
Message-ID: <54787A8A.6040209@redhat.com>
Date: Fri, 28 Nov 2014 14:37:14 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Chen-Yu Tsai <wens@csie.org>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
References: <20141126211318.GN25249@lukather> <5476E3A5.4000708@redhat.com> <CAGb2v652m0bCdPWFF4LWwjcrCJZvnLibFPw8xXJ3Q-Ge+_-p7g@mail.gmail.com> <5476F8AB.2000601@redhat.com> <20141127190509.GR25249@lukather>
In-Reply-To: <20141127190509.GR25249@lukather>
Content-Type: multipart/mixed;
 boundary="------------070704020809030602050306"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070704020809030602050306
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 11/27/2014 08:05 PM, Maxime Ripard wrote:
> Hi,
>
> On Thu, Nov 27, 2014 at 11:10:51AM +0100, Hans de Goede wrote:
>> Hi,
>>
>> On 11/27/2014 10:28 AM, Chen-Yu Tsai wrote:
>>> Hi,
>>>
>>> On Thu, Nov 27, 2014 at 4:41 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> <snip>
>>
>>>> I notice that you've not responded to my proposal to simple make the clock
>>>> node a child node of the clocks node in the dt, that should work nicely, and
>>>> avoid the need for any kernel level changes to support it, I'm beginning to
>>>> think that that is probably the best solution.
>>>
>>> Would that not cause an overlap of the io regions, and cause one of them
>>> to fail? AFAIK the OF subsystem doesn't like overlapping resources.
>>
>> No the overlap check is done by the platform dev resource code, and of_clk_declare
>> does not use that. So the overlap would be there, but not an issue (in theory
>> I did not test this).
>
> An overlap is always an issue.
>
>> Thinking more about this, I believe that using the MFD framework for the prcm seems
>> like a mistake to me. It gains us nothing, since we have no irq to de-multiplex or
>> some such. We're not using MFD for the CMU, why use it for CMU2 (which the prcm
>> effectively is) ?
>
> Because the PRCM is much more than that. It also handles the power
> domains for example.

Ok, so thinking more about this, I'm still convinced that the MFD framework is only
getting in the way here. But I can see having things represented in devicetree
properly, with the clocks, etc. as child nodes of the prcm being something which
we want.

So since all we are using the MFD for is to instantiate platform devices under the prcm
nodes, and assign an io resource for the regs to them, why not simply make the prcm node
itself a simple-bus.

This does everything the MFD prcm driver currently does, without actually needing a specific
kernel driver, and as added bonus this will move the definition of the mfd function reg offsets
out of the kernel and into the devicetree where they belong in the first place.

Please see the attached patches, I've tested this on sun6i, if we go this route we should
make the same change on sun8i (I can make the change, but not test it).

Regards,

Hans

--------------070704020809030602050306
Content-Type: text/x-patch;
 name="0001-ARM-dts-sun6i-Change-prcm-node-into-a-simple-bus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ARM-dts-sun6i-Change-prcm-node-into-a-simple-bus.patch"

>From 6756574293a1f291a8dcc29427b27f32f83acb2d Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 28 Nov 2014 13:48:58 +0100
Subject: [PATCH v2 1/2] ARM: dts: sun6i: Change prcm node into a simple-bus

The prcm node's purpose is to group the various prcm sub-devices together,
it does not need any special handling beyond that, there is no need to
handle shared resources like a shared (multiplexed) interrupt or a shared
i2c bus.

As such there really is no need to have a separate compatible for it, using
simple-bus for it works fine. This also allows us to specify the register
offsets of the various child-devices directly into the dts, rather then having
to specify them in the OS implementation, putting the register offsets where
the belong.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 29e6438..4b8541f 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -846,11 +846,15 @@
 		};
 
 		prcm@01f01400 {
-			compatible = "allwinner,sun6i-a31-prcm";
+			compatible = "simple-bus";
 			reg = <0x01f01400 0x200>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
 
 			ar100: ar100_clk {
 				compatible = "allwinner,sun6i-a31-ar100-clk";
+				reg = <0x01f01400 0x4>;
 				#clock-cells = <0>;
 				clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
 				clock-output-names = "ar100";
@@ -867,6 +871,7 @@
 
 			apb0: apb0_clk {
 				compatible = "allwinner,sun6i-a31-apb0-clk";
+				reg = <0x01f0140c 0x4>;
 				#clock-cells = <0>;
 				clocks = <&ahb0>;
 				clock-output-names = "apb0";
@@ -874,6 +879,7 @@
 
 			apb0_gates: apb0_gates_clk {
 				compatible = "allwinner,sun6i-a31-apb0-gates-clk";
+				reg = <0x01f01428 0x4>;
 				#clock-cells = <1>;
 				clocks = <&apb0>;
 				clock-output-names = "apb0_pio", "apb0_ir",
@@ -884,6 +890,7 @@
 
 			apb0_rst: apb0_rst {
 				compatible = "allwinner,sun6i-a31-clock-reset";
+				reg = <0x01f014b0 0x4>;
 				#reset-cells = <1>;
 			};
 		};
-- 
2.1.0


--------------070704020809030602050306
Content-Type: text/x-patch;
 name="0002-ARM-dts-sun6i-Add-ir_clk-node.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-ARM-dts-sun6i-Add-ir_clk-node.patch"

>From a152b0405d446c748fef146915736e4a8fc548b1 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 28 Nov 2014 13:54:14 +0100
Subject: [PATCH v2 2/2] ARM: dts: sun6i: Add ir_clk node

Add an ir_clk sub-node to the prcm node.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 4b8541f..92a1c95 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -888,6 +888,14 @@
 						"apb0_i2c";
 			};
 
+			ir_clk: ir_clk {
+				reg = <0x01f01454 0x4>;
+				#clock-cells = <0>;
+				compatible = "allwinner,sun4i-a10-mod0-clk";
+				clocks = <&osc32k>, <&osc24M>;
+				clock-output-names = "ir";
+			};
+
 			apb0_rst: apb0_rst {
 				compatible = "allwinner,sun6i-a31-clock-reset";
 				reg = <0x01f014b0 0x4>;
-- 
2.1.0


--------------070704020809030602050306--
