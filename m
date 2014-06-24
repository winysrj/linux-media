Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd19416.kasserver.com ([85.13.139.185]:58981 "EHLO
	dd19416.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaFXR0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 13:26:13 -0400
Message-ID: <53A9B31A.80607@herbrechtsmeier.net>
Date: Tue, 24 Jun 2014 19:19:22 +0200
From: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>	<CA+2YH7uDVL+s9aY-erktyKeUbmd2=49r=nDZXPRCZ8dcSjmCoA@mail.gmail.com> <CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com>
In-Reply-To: <CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060306010608070902020009"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060306010608070902020009
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 24.06.2014 17:19, schrieb Enrico:
> On Tue, May 27, 2014 at 10:38 AM, Enrico <ebutera@users.berlios.de> wrote:
>> On Mon, May 26, 2014 at 9:50 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hello,
>>>
>>> This patch sets implements support for BT.656 and interlaced formats in the
>>> OMAP3 ISP driver. Better late than never I suppose, although given how long
>>> this has been on my to-do list there's probably no valid excuse.
>> Thanks Laurent!
>>
>> I hope to have time soon to test it :)
> i wanted to try your patches but i'm having a problem (probably not
> caused by your patches).
>
> I merged media_tree master and omap3isp branches, applied your patches
> and added camera platform data in pdata-quirks, but when loading the
> omap3-isp driver i have:
>
> omap3isp: clk_set_rate for cam_mclk failed
>
> The returned value from clk_set_rate is -22 (EINVAL), but i can't see
> any other debug message to track it down. Any ides?
> I'm testing it on an igep proton (omap3530 version).
Hi Enrico,

please test the attached patch. It is based on Laurent's patches for the 
clock and boot testes on an Gumstix Overo with an OMAP3530.

Regards,
   Stefan


--------------060306010608070902020009
Content-Type: text/x-patch;
 name="0021-ARM-dts-set-ti-set-rate-parent-for-dpll4_m5x2-clock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0021-ARM-dts-set-ti-set-rate-parent-for-dpll4_m5x2-clock.pat";
 filename*1="ch"

>From 9f8162ddebf7636e60101f0831d071e73ab6df75 Mon Sep 17 00:00:00 2001
From: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Date: Fri, 13 Jun 2014 18:15:56 +0200
Subject: [PATCH 21/25] ARM: dts: set 'ti,set-rate-parent' for dpll4_m5x2 clock

Set 'ti,set-rate-parent' property for the dpll4_m5x2_ck clock, which
is used for the ISP functional clock. This fixes the OMAP3 ISP driver's
clock rate configuration on OMAP34xx, which needs the rate to be
propagated properly to the divider node (dpll4_m5_ck).

Signed-off-by: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
---
 arch/arm/boot/dts/omap3xxx-clocks.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap3xxx-clocks.dtsi b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
index 25adab1..beeff7c 100644
--- a/arch/arm/boot/dts/omap3xxx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
@@ -465,6 +465,7 @@
 		ti,bit-shift = <0x1e>;
 		reg = <0x0d00>;
 		ti,set-bit-to-disable;
+		ti,set-rate-parent;
 	};
 
 	dpll4_m6_ck: dpll4_m6_ck {
-- 
2.0.0


--------------060306010608070902020009--
